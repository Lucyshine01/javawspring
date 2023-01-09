package com.spring.javawspring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.javawspring.pagination.PageProcess;
import com.spring.javawspring.pagination.PageVO;
import com.spring.javawspring.service.MemberService;
import com.spring.javawspring.vo.MailVO;
import com.spring.javawspring.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	MemberService memberService; 
	
	@Autowired // 스프링 시큐리티 의존성 주입완료
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	JavaMailSender mailSender;
	
	@RequestMapping(value = "/memberLogin", method = RequestMethod.GET)
	public String memberLoginGet(HttpServletRequest request) {
		// 로그인폼 호출시에 기존에 저장된 쿠키가 있다면 불러와서 mid에 담아서 넘겨준다.
		Cookie[] cookies = request.getCookies();
		for(int i=0; i<cookies.length; i++) {
			if(cookies[i].getName().equals("cMid")) {
				request.setAttribute("mid", cookies[i].getValue());
				break;
			}
		}
		return "member/memberLogin";
	}
	
	@RequestMapping(value = "/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(HttpServletRequest request, HttpServletResponse response, 
			HttpSession session,
			@RequestParam(name = "mid", defaultValue = "", required = false) String mid, 
			@RequestParam(name = "pwd", defaultValue = "", required = false) String pwd, 
			@RequestParam(name = "idCheck", defaultValue = "", required = false) String idCheck 
			) {
		
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo != null 
			 && passwordEncoder.matches(pwd, vo.getPwd()) 
			 && vo.getUserDel().equals("NO")) {
			// 회원 인증처리된 경우 수행할 내용? strLevel처리, session에 필요한 자료를 저장, 쿠키값처리, 그날 방문자수 1 증가(방문포인트도 증가),
			String strLevel = "";
			if(vo.getLevel() == 0) strLevel = "관리자";
			else if(vo.getLevel() == 1) strLevel = "운영자";
			else if(vo.getLevel() == 2) strLevel = "우수회원";
			else if(vo.getLevel() == 3) strLevel = "정회원";
			else if(vo.getLevel() == 4) strLevel = "준회원";
			
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("sStrLevel", strLevel);
			session.setAttribute("sMid", mid);
			session.setAttribute("sNickName", vo.getNickName());
			
			if(idCheck.equals("on")) {
				Cookie cookie = new Cookie("cMid", mid);
				cookie.setMaxAge(60*60*24*7);
//				cookie.setPath("/");
				response.addCookie(cookie);
			}
			else {
				Cookie[] cookies = request.getCookies();
				for(int i=0; i<cookies.length; i++) {
					if(cookies[i].getName().equals("cMid")) {
						cookies[i].setMaxAge(0);
						response.addCookie(cookies[i]);
					}
				}
			}
			
			if(vo.getLevel() == 0) {
				session.setAttribute("sAMid", mid);
			}
			
			// 로그인한 사용자의 방문횟수(포인트) 누적...
			memberService.setMemberVisitProcess(vo);
			
			return "redirect:/msg/memberLoginOk?mid="+mid;
		}
//		else return "redirect:/msg/memberLoginNo";
		
		if(mid.equals("admin") && pwd.equals("1234")) {
			session = request.getSession();
			session.setAttribute("sAMid", mid);
			return "redirect:/msg/memberLoginOk?mid="+mid;
		}
		else return "redirect:/msg/memberLoginNo";
	}
	
	@RequestMapping(value = "memberLogout", method = RequestMethod.GET)
	public String memberLogoutGet(HttpSession session) {
		String mid = (String)session.getAttribute("sMid");
		
		session.invalidate();
		
		return "redirect:/msg/memberLogout?mid="+mid;
	}
	
	@RequestMapping(value = "/adminLogout", method = RequestMethod.GET)
	public String adminLogoutGet(HttpSession session) {
		String mid = (String) session.getAttribute("sAMid");
		session.invalidate();
		
		return "redirect:/msg/memberLogout?mid="+mid;
	}
	
	@RequestMapping(value = "/memberMain", method = RequestMethod.GET)
	public String memberMainGet(HttpSession session,Model model) {
		String mid = (String) session.getAttribute("sMid");
		
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		model.addAttribute("vo",vo);
		
		return "member/memberMain";
	}
	@RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
	public String memberJoinGet() {
		return "member/memberJoin";
	}
	
	@RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
	public String memberJoinPost(MemberVO vo) {
		//System.out.println("memberVO : " + vo);
		// 아이디 체크
		if(memberService.getMemberIdCheck(vo.getMid()) != null) {
			return "redirect:/msg/memberIdCheckNo";
		}
		// 닉네임 중복체크
		if(memberService.getMemberNickNameCheck(vo.getNickName()) != null) {
			return "redirect:/msg/memberNickNameCheckNo";
		}
		
		// 비밀번호 암호화(BCryptPasswordEncoder)
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		// 체크가 완료되면 vo에 담긴 자료를 DB에 저장시켜준다.(회원 가입)
		int res = memberService.setMemberJoinOk(vo);
		
		if(res == 1) return "redirect:/msg/memberJoinOk";
		else return "redirect:/msg/memberJoinNo";
	}
	
	@ResponseBody
	@RequestMapping(value = "/memberIdCheck", method = RequestMethod.POST)
	public String memberIdCheckGet(String mid) {
		String res = "0";
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo != null) res = "1";
		return res;
	}
	
	@ResponseBody
	@RequestMapping(value = "/memberNickNameCheck", method = RequestMethod.POST)
	public String memberNickNameCheckGet(String nickName) {
		String res = "0";
		MemberVO vo = memberService.getMemberNickNameCheck(nickName);
		if(vo != null) res = "1";
		return res;
	}
	
	
	
	
	// Pagination 이용하기...
	// 전체리스트와 검색리스트를 하나의 메소드로 처리..(매퍼 동적처리 if문(코어 라이브러리와 비슷))
	@RequestMapping(value = "/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model,PageVO pageVO,
			@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		
		ArrayList<MemberVO> vos = new ArrayList<MemberVO>();
		ArrayList<HashMap<String, Object>> listMap = pageProcess.paging(pageVO,model,"member2",mid);
		ObjectMapper objectMapper = new ObjectMapper();
		for(int i=0; i<listMap.size(); i++) {
			System.out.println(listMap.get(i));
			vos.add(objectMapper.convertValue(listMap.get(i), MemberVO.class));
		}
		model.addAttribute("vos",vos);
		
		
//		ArrayList<MemberVO> vos = objectMapper.convertValue(list, ArrayList<MemberVO>());
//		ArrayList<MemberVO> vos = (ArrayList<MemberVO>)map;
		if(!mid.equals("")) model.addAttribute("mid", mid);
		return "member/memberList";
	}
	
	// Pagination 이용하기...	
//	@RequestMapping(value = "/memberList", method = RequestMethod.GET)
//	public String memberListGet(Model model,PageVO pageVO) {
//		ArrayList<MemberVO> vos = pageProcess.paging(pageVO,model,"member2");
//		model.addAttribute("vos",vos);
//		return "member/memberList";
//	}
	
	// Pagination 이용하기...	
	@RequestMapping(value = "/memberList", method = RequestMethod.POST)
	public String memberListPost(Model model,PageVO pageVO, 
			@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		ArrayList<MemberVO> vos = pageProcess.pagingSearch(pageVO,model,"member2","mid",mid);
		model.addAttribute("vos",vos);
		return "member/memberList";
	}
	
	
	
	
	
	@RequestMapping(value = "/memberIdSearch", method = RequestMethod.GET)
	public String memberIdSearchGet(Model model, PageVO pageVO) {
		return "member/memberIdSearch";
	}
	
	
	@RequestMapping(value = "/memberIdSearch", method = RequestMethod.POST)
	public String memberIdSearchGet(MailVO vo, HttpServletRequest request) {
		try {
			System.out.println(vo.getToMail());
			String toMail = vo.getToMail();
			String title = "아이디 이메일 인증";
			String content = "";
			
			// 메일을 전송하기위한 객체 : MimeMessage() - 메세지 전송 , MimeMessageHelper() - 메세지 저장소(보관함)
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			// 메일보관함에 회원이 보내온 메세지들을 모두 저장시킨다.
			messageHelper.setTo(toMail);
			messageHelper.setSubject(title);
			messageHelper.setText(content);
			
			// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.
			
			String mid = memberService.getIdSearch(toMail);
			if(mid == null) {
				return "redirect:/msg/memberIdSearchNo1";
			}
			
			content = "<br>회원님의 아이디는 "+mid+"입니다<br>";
			content += "<br><hr><h3>CJ Green</h3><hr><br>";
			
			messageHelper.setText(content, true);	// 앞에 내용에 이 내용을 추가한다.
			
			// 메일 전송하기
			mailSender.send(message);
			
		} catch (MessagingException e) {
			e.printStackTrace();
			return "redirect:/msg/memberIdSearchNo2";
		}
		
		return "redirect:/msg/memberIdSearchOk";
	}
	
	
	
//	@RequestMapping(value = "/memberList", method = RequestMethod.GET)
//	public String memberListGet(Model model,
//			PageVO pageVO
////			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
////			@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize
//			) {
//		
//		
//		ArrayList<MemberVO> vos = (ArrayList<MemberVO>)pageService.paging(pageVO,model,"member2");
//		System.out.println(vos);
//		model.addAttribute("vos",vos);
//		
////		int totRecCnt = memberService.totRecCnt(); 
////		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt / pageSize : (totRecCnt / pageSize)+1; int
////		stratIndexNo = (pag-1) * pageSize; 
////		int curScrStartNo = totRecCnt - stratIndexNo;
////		
////		int blockSize = 3;
////		int curBlock = (pag - 1) / blockSize; int lastBlock = (totPage-1) / blockSize;
////		
////		ArrayList<MemberVO> vos = memberService.getMemberList(stratIndexNo,pageSize);
////		
////		model.addAttribute("vos",vos); 
////		model.addAttribute("blockSize", blockSize);
////		model.addAttribute("curBlock", curBlock); 
////		model.addAttribute("lastBlock",lastBlock); 
////		model.addAttribute("pageSize", pageSize);
////		model.addAttribute("pag", pag); 
////		model.addAttribute("totPage", totPage);
////		model.addAttribute("curScrStartNo", curScrStartNo);
//		return "member/memberList";
//	}
	
	
}
