package com.spring.javawspring;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

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
import com.spring.javawspring.common.ARIAUtil;
import com.spring.javawspring.common.SecurityUtil;
import com.spring.javawspring.pagination.PageProcess;
import com.spring.javawspring.pagination.PageVO;
import com.spring.javawspring.service.MemberService;
import com.spring.javawspring.service.StudyService;
import com.spring.javawspring.vo.GuestVO;
import com.spring.javawspring.vo.MailVO;
import com.spring.javawspring.vo.MemberVO;

@Controller
@RequestMapping("study")
public class StudyController {
	
	@Autowired
	StudyService studyService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired // 스프링 시큐리티 의존성 주입완료
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	JavaMailSender mailSender;
	
	@RequestMapping(value = "/ajax/ajaxMenu", method = RequestMethod.GET)
	public String ajaxMenuGet() {
		return "study/ajax/ajaxMenu";
	}
	
	//String형식의 문자를 주고 받을때 사용하는 어노테이션(@ResponseBody)
	//return시 주소가 아니라 문자를 주고받음(Ajax 사용)
	// 일반 String값의 전달 1(숫자/영문자)
	@ResponseBody 
	@RequestMapping(value = "/ajax/ajaxTest1_1", method = RequestMethod.POST)
	public String ajaxTest1_1Post(int idx) {
		idx = (int)(Math.random()*idx) + 1;
		String res = idx + " : Happy a Good Time!!!";
		return res;
	}
	
	// 일반 String값의 전달 2(숫자/영문자/한글)
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest1_2", method = RequestMethod.POST,
	// text 인코딩방식을 utf8로 바꿔라
	produces = "apllication/text; charset=utf8")
	public String ajaxTest1_2Post(int idx) {
		idx = (int)(Math.random()*idx) + 1;
		String res = idx + " : 안녕하세요... Happy a Good Time!!!";
		return res;
	}
	
	// 일반 배열값(String[])의 전달
	@RequestMapping(value = "/ajax/ajaxTest2_1", method = RequestMethod.GET)
	public String ajaxTest2_1Get() {
		return "study/ajax/ajaxTest2_1";
	}
	
	// 일반 배열값(String[])의 전달
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest2_1", method = RequestMethod.POST)
	public String[] ajaxTest2_1Post(String dodo) {
//		String[] strArr = new String[100];
//		strArr = studyService.getCityStringArr(dodo);
//		return strArr;
		return studyService.getCityStringArr(dodo);
	}
	
	
	// 객체배열(ArrayList)값의 전달
	@RequestMapping(value = "/ajax/ajaxTest2_2", method = RequestMethod.GET)
	public String ajaxTest2_2Get() {
		return "study/ajax/ajaxTest2_2";
	}
	
	// 객체배열(ArrayList)값의 전달
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest2_2", method = RequestMethod.POST)
	public ArrayList<String> ajaxTest2_2Post(String dodo) {
		return studyService.getCityArrayListArr(dodo);
	}
	
	
	// Map(HashMap<key,value>)값의 전달
	@RequestMapping(value = "/ajax/ajaxTest2_3", method = RequestMethod.GET)
	public String ajaxTest2_3Get() {
		return "study/ajax/ajaxTest2_3";
	}
	
	// Map(HashMap<key,value>)값의 전달
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest2_3", method = RequestMethod.POST)
	// HashMap : key,value 에 오는 타입이 무엇인지 모르거나 여러개일 경우 Object로 처리가능
	public HashMap<Object, Object> ajaxTest2_3Post(String dodo) {
		ArrayList<String> vos = new ArrayList<String>();
		vos = studyService.getCityArrayListArr(dodo);
		
		HashMap<Object, Object> map = new HashMap<Object, Object>();
		map.put("city", vos);
		
		return map;
	}
	
	// DB를 활용한 값의 전달
	@RequestMapping(value = "/ajax/ajaxTest3", method = RequestMethod.GET)
	public String ajaxTest3Get() {
		return "study/ajax/ajaxTest3";
	}
	
	// DB를 활용한 값의 전달1(vo)
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest3_1", method = RequestMethod.POST)
	public GuestVO ajaxTest3_1Post(String mid) {
//		GuestVO vo = studyService.getGuestMid(mid);
		return studyService.getGuestMid(mid);
	}
	// DB를 활용한 값의 전달2(vos)
	@ResponseBody
	@RequestMapping(value = "/ajax/ajaxTest3_2", method = RequestMethod.POST)
	public ArrayList<GuestVO> ajaxTest3_2Post(String mid) {
//		ArrayList<GuestVO> vos = studyService.getGuestName(mid);
//		return vos;
		return studyService.getGuestNames(mid);
	}
	
	// 암호화연습(sha256)
	@RequestMapping(value = "/password/sha256", method = RequestMethod.GET)
	public String sha256Get() {
		
		return "study/password/sha256";
	}
	
	// 암호화 연습(sha256) 결과 처리
	@RequestMapping(value = "/password/sha256", method = RequestMethod.POST,
			produces = "application/text; charset=utf8")
	public @ResponseBody String sha256Post(String pwd) {
		String encPwd = SecurityUtil.encryptSHA256(pwd);
		pwd = "원본 비밀번호 : " + pwd + " / 암호화된 비밀번호 : " + encPwd;
		return pwd;
	}
	
	// 암호화연습(aria)
	@RequestMapping(value = "/password/aria", method = RequestMethod.GET)
	public String ariaGet() {
		return "study/password/aria";
	}
	
	// 암호화 연습(aria) 결과 처리
	@RequestMapping(value = "/password/aria", method = RequestMethod.POST,
			produces = "application/text; charset=utf8")
	public @ResponseBody String ariaPost(String pwd) {
		String encPwd = "";
		String decPwd = "";
		// 전자정보 프레임워크 암호화는 대부분 try/catch문이 많다
		try {
			encPwd = ARIAUtil.ariaEncrypt(pwd);			// 암호화
			decPwd = ARIAUtil.ariaDecrypt(encPwd);	// 복호화
		} catch (InvalidKeyException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		pwd = "원본 비밀번호 : " + pwd + " / 암호화된 비밀번호 : " + encPwd + " / 복호화된 비밀번호 : " + decPwd;
		return pwd;
	}
	
	// 암호화연습(bCryptPassword)
	@RequestMapping(value = "/password/bCryptPassword", method = RequestMethod.GET)
	public String bCryptPasswordGet() {
		return "study/password/security";
	}
	
	// 암호화 연습(bCryptPassword) 결과 처리
	@RequestMapping(value = "/password/bCryptPassword", method = RequestMethod.POST,
			produces = "application/text; charset=utf8")
	public @ResponseBody String bCryptPasswordPost(String pwd) {
		String encPwd = "";
		encPwd = passwordEncoder.encode(pwd); // 암호화
		
		pwd = "원본 비밀번호 : " + pwd + " / 암호화된 비밀번호 : " + encPwd;
		return pwd;
	}
	
	
	// SMTP 메일 보내기
	// 메일작성 폼
	@RequestMapping(value = "/mail/mailForm", method = RequestMethod.GET)
	public String mailFormGet(String email, Model model) {
		
		ArrayList<MemberVO> vos = memberService.getMemberList(0, 1000);
		model.addAttribute("vos",vos);
		model.addAttribute("cnt",vos.size());
		model.addAttribute("email", email);
		
		return "study/mail/mailForm";
	}
	
	// 메일 전송하기
	@RequestMapping(value = "/mail/mailForm", method = RequestMethod.POST)
	public String mailFormPost(MailVO vo, HttpServletRequest request) {
		try {
			String toMail = vo.getToMail();
			String title = vo.getTitle();
			String content = vo.getContent();
			
			// 메일을 전송하기위한 객체 : MimeMessage() - 메세지 전송 , MimeMessageHelper() - 메세지 저장소(보관함)
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			// 메일보관함에 회원이 보내온 메세지들을 모두 저장시킨다.
			messageHelper.setTo(toMail);
			messageHelper.setSubject(title);
			messageHelper.setText(content);
			
			// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.
			content = content.replaceAll("\n", "<br/>");
			content += "<br><hr><h3>CJ Green에서 보냅니다</h3><hr><br>";
			// cid : 예약어
			content += "<p><img src=\"cid:main.jpg\" width='500px'></p>";
			content += "<p><img src=\"cid:ecat.png\" width='500px'></p>";
			content += "<p>방문하기 : <a href='http://49.142.157.251:9090/green2209J_17/'>InteMoa</a></p>";
			content += "<hr>";
			
			messageHelper.setText(content, true);	// 앞에 내용에 이 내용을 추가한다.
			
//			// 본문에 기재된 그림파일의 경로를 따로 표시시켜준다.(cid) 그리고, 보관함에 다시 저장시켜준다.
//			FileSystemResource file = new FileSystemResource("D:\\JavaWorkspace\\springframework\\works\\javawspring\\src\\main\\webapp\\resources\\images\\main.png");
//			messageHelper.addInline("main.jpg", file);
//			
//			file = new FileSystemResource(request.getRealPath("/resources/images/ecat.png"));
//			messageHelper.addInline("ecat.png", file);
//			
//			// 첨부파일 보내기(서버 파일시스템에 있는 파일)
//			file = new FileSystemResource("D:\\JavaWorkspace\\springframework\\works\\javawspring\\src\\main\\webapp\\resources\\images\\ecat.png");
//			messageHelper.addAttachment("errorcat.png", file);
//			
//			file = new FileSystemResource("D:\\JavaWorkspace\\springframework\\works\\javawspring\\src\\main\\webapp\\resources\\images\\images.zip");
//			messageHelper.addAttachment("zip파일.zip", file);
//			
//			file = new FileSystemResource(request.getRealPath("/resources/images/ecat.png"));
//			messageHelper.addAttachment("asdf.png", file);
//			
//			file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/ecat.png"));
//			messageHelper.addAttachment("test1.png", file);
//			
			
			// 메일 전송하기
			mailSender.send(message);
			
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return "redirect:/msg/mailSendOk";
	}
	
	@RequestMapping(value = "/uuid/uuidForm", method = RequestMethod.GET)
	public String uuidFormGet() {
		return "study/uuid/uuidForm";
	}
	
	@ResponseBody
	@RequestMapping(value = "/uuid/uuidProcess", method = RequestMethod.POST)
	public String uuidProcessPost() {
		// 자바 유틸리티 UUID
		UUID uid = UUID.randomUUID();
		System.out.println("uid : " + uid);
		return uid.toString();
	}
	
	// 파일 업로드 폼
	@RequestMapping(value = "/fileUpload/fileUploadForm", method = RequestMethod.GET)
	public String fileUploadFormGet() {
		return "study/fileUpload/fileUploadForm";
	}
	
	// 파일 업로드 폼
	@RequestMapping(value = "/fileUpload/fileUploadForm", method = RequestMethod.POST)
	public String fileUploadFormPost(MultipartFile fName) {
		int res = studyService.fileUpload(fName);
		
		if(res == 1) return "redirect:/msg/fileUploadOk";
		else return "redirect:/msg/fileUploadNo";
	}
	
	//달력내역 가져오기
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public String calendarGet() {
		studyService.getCalendar();
		return "study/calendar/calendar";
	}
	
	
}
