package com.spring.javawspring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

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
import org.springframework.web.multipart.MultipartFile;

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
	
	// 카카오 로그인 완료후 수행할 내용들을 기술한다.
	@RequestMapping(value = "/memberKakaoLogin", method = RequestMethod.GET)
	public String memberKakaoLoginGet(HttpSession session, HttpServletRequest request,
			@RequestParam("nickName") String nickName,@RequestParam("email") String email) {
		
		// 카카오로그인한 회원이 현재 우리 회원인지를 조회한다.
		// 이미 가입된 회원이라면 서비스를 사용하게 하고, 그렇지 않으면 강제로 회원가입 시킨다.
		MemberVO vo = memberService.getMemberNickNameEmailCheck(nickName, email);
		
		
		// 현재 우리회원이 아니면 자동회원가입처리...(가입필수사항: 아이디,닉네임,이메일) - 아이디는 이메일주소의 '@' 앞쪽 이름을 사용하기로 한다.
		if(vo == null) {
			// 아이디 결정하기
			String mid = email.split("@")[0];
			
			// 임시 비밀번호 발급하기(여기선 '0000'으로 발급하기로 한다.)
			String pwd = passwordEncoder.encode("0000");
			
			// 자동 회원 가입처리한다.
			memberService.setKakaoMemberInputOk(mid, pwd, nickName, email);
			
			// 가입 처리된 회원의 정보를 다시 읽어와서 vo에 담아준다.
			vo = memberService.getMemberIdCheck(mid);
		}
		
	// 만약에 탈퇴신청한 회원이 카카오로그인처리하였다라면 'userDel'필드를 'NO'로 업데이트한다.
		if(!vo.getUserDel().equals("NO")) {
			memberService.setMemberUserDelCheck(vo.getMid());
		}
		
		String strLevel = "";
		if(vo.getLevel() == 0) strLevel = "관리자";
		else if(vo.getLevel() == 1) strLevel = "운영자";
		else if(vo.getLevel() == 2) strLevel = "우수회원";
		else if(vo.getLevel() == 3) strLevel = "정회원";
		else if(vo.getLevel() == 4) strLevel = "준회원";
		
		session.setAttribute("sLevel", vo.getLevel());
		session.setAttribute("sStrLevel", strLevel);
		session.setAttribute("sMid", vo.getMid());
		session.setAttribute("sNickName", vo.getNickName());
		
		// 로그인한 사용자의 방문횟수(포인트) 누적...
		memberService.setMemberVisitProcess(vo);
		
		return "redirect:/msg/memberLoginOk?mid="+vo.getMid();
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
	public String memberJoinPost(MultipartFile fName ,MemberVO vo) {
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
		
		// 체크가 완료되면 사진파일 업로드후, vo에 담긴 자료를 DB에 저장시켜준다.(회원 가입) - 서비스객체에서 수행처리했다.
		int res = memberService.setMemberJoinOk(fName, vo);
		
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
		ArrayList<HashMap<String, Object>> listMap = pageProcess.paging(pageVO,model,"member2","mid",mid);
		ObjectMapper objectMapper = new ObjectMapper();
		for(int i=0; i<listMap.size(); i++) vos.add(objectMapper.convertValue(listMap.get(i), MemberVO.class));
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
	public String memberIdSearchGet() {
		return "member/memberIdSearch";
	}
	
	
	@RequestMapping(value = "/memberIdSearch", method = RequestMethod.POST)
	public String memberIdSearchGet(MailVO vo, HttpServletRequest request) {
		try {
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
	
	// 비밀번호 찾기를 위한 임시비밀번호 발급 폼...
	@RequestMapping(value = "/memberPwdSearch", method = RequestMethod.GET)
	public String memberPwdSearchGet() {
		return "member/memberPwdSearch";
	}
	
	// 비밀번호 찾기를 위한 임시비밀번호 발급 폼...
	@RequestMapping(value = "/memberPwdSearch", method = RequestMethod.POST)
	public String memberPwdSearchPost(String mid, MailVO mailVO) {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo.getEmail() == null) return "redirect:/msg/memberPwdSearchNo1";
		else if(!vo.getEmail().equals(mailVO.getToMail())) return "redirect:/msg/memberPwdSearchNo2";
		
		// 회원정보가 맞다면 임시비밀번호를 발급받는다.
		UUID uid = UUID.randomUUID();
		String pwd = uid.toString().substring(0,8);
		
		// 발급받은 임시비밀번호를 암호화처리시켜서 DB에 저장한다.
		int res = memberService.setMemberPwdUpdate(mid,passwordEncoder.encode(pwd));
		if(res != 1) return "redirect:/msg/memberPwdSearchNo3";
		
		// 임시비밀번호를 메일로 전송처리한다.(서비스객체에서 처리)
		res = mailSend(mailVO.getToMail(), pwd);
		
		if(res == 1) return "redirect:/msg/memberPwdSearchOk";
		else return "redirect:/msg/memberPwdSearchNo4";
	}

	private int mailSend(String toMail, String pwd) {
		try {
			String title = "임시 비밀번호 발급";
			String content = "";
			
			// 메일을 전송하기위한 객체 : MimeMessage() - 메세지 전송 , MimeMessageHelper() - 메세지 저장소(보관함)
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			// 메일보관함에 회원이 보내온 메세지들을 모두 저장시킨다.
			messageHelper.setTo(toMail);
			messageHelper.setSubject(title);
			messageHelper.setText(content);
			
			// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.
			
			content = "<br>회원님의 임시비밀번호는 "+pwd+"입니다<br>빠른 시일내에 비밀번호 변경해주시길 바랍니다.<br>";
			content += "<br><hr><h3>CJ Green</h3><hr><br>";
			
			messageHelper.setText(content, true);	// 앞에 내용에 이 내용을 추가한다.
			
			// 메일 전송하기
			mailSender.send(message);
			
		} catch (MessagingException e) {
			e.printStackTrace();
			return 0;
		}
		return 1;
	}
	
	// 비밀번호 변경 폼...
	@RequestMapping(value = "/memberUpdatePwd", method = RequestMethod.GET)
	public String memberUpdatePwdGet() {
		return "member/memberUpdatePwd";
	}
	
	@RequestMapping(value = "/memberUpdatePwd", method = RequestMethod.POST)
	public String memberUpdatePwdPost(String mid, String oldPwd, String newPwd) {
		if(!passwordEncoder.matches(oldPwd, memberService.getMemberIdCheck(mid).getPwd())) {
			return "redirect:/msg/memberPwdUpdateNo";
		};
		memberService.setMemberPwdUpdate(mid, passwordEncoder.encode(newPwd));
		return "redirect:/msg/memberPwdUpdateOk";
	}
	
	// 회원 정보 수정 폼...
	@RequestMapping(value = "/memberUpdate", method = RequestMethod.GET)
	public String memberUpdateGet(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		String mid = (String)session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		model.addAttribute("vo",vo);
		
		return "member/memberUpdate";
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
