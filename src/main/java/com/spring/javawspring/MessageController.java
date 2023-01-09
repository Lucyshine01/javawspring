package com.spring.javawspring;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {
	
	@RequestMapping(value = "/msg/{msgFlag}", method = RequestMethod.GET)
	public String msgget(@PathVariable String msgFlag, Model model,
			@RequestParam(value = "mid", defaultValue = "", required = false) String mid,
			HttpServletRequest request) {
		if(msgFlag.equals("memberLoginOk")) {
			model.addAttribute("msg", mid + "님 로그인 되었습니다.");
			model.addAttribute("url", "member/memberMain");
		}
		else if(msgFlag.equals("memberLogout")) {
			model.addAttribute("msg", mid + "님 로그아웃 되셨습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("memberLoginNo")) {
			model.addAttribute("msg", "로그인에 실패하였습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("guestInputOk")) {
			model.addAttribute("msg", "방명록에 글이 등록되었습니다..");
			model.addAttribute("url", "guest/guestList");
		}
		else if(msgFlag.equals("guestDeleteOk")) {
			model.addAttribute("msg", "방명록 글이 삭제되었습니다.");
			model.addAttribute("url", "guest/guestList");
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("msg", "회원가입이 완료되었습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("memberIdCheckNo")) {
			model.addAttribute("msg", "중복된 아이디 입니다.");
			model.addAttribute("url", "member/memberJoin");
		}
		else if(msgFlag.equals("memberNickNameCheckNo")) {
			model.addAttribute("msg", "중복된 닉네임 입니다.");
			model.addAttribute("url", "member/memberJoin");
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("msg", "회원가입 완료!");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("msg", "회원가입 실패!");
			model.addAttribute("url", "member/memberJoin");
		}
		else if(msgFlag.equals("adminNo")) {
			model.addAttribute("msg", "허용되지 않는 기능입니다.");
			model.addAttribute("url", "");
		}
		else if(msgFlag.equals("memberNo")) {
			model.addAttribute("msg", "회원 전용입니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("levelCheckNo")) {
			model.addAttribute("msg", "회원 등급이 낮습니다");
			model.addAttribute("url", "member/memberMain");
		}
		else if(msgFlag.equals("mailSendOk")) {
			model.addAttribute("msg", "메일이 정상적으로 전송되었습니다.");
			model.addAttribute("url", "study/mail/mailForm");
		}
		else if(msgFlag.equals("memberIdSearchOk")) {
			model.addAttribute("msg", "해당 메일에 아이디가 전송되었습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("memberIdSearchNo1")) {
			model.addAttribute("msg", "이메일과 일치하는 아이디가 존재하지 않습니다.");
			model.addAttribute("url", "member/memberIdSearch");
		}
		else if(msgFlag.equals("memberIdSearchNo2")) {
			model.addAttribute("msg", "이메일 전송중에 오류가 발생했습니다.");
			model.addAttribute("url", "member/memberIdSearch");
		}
		else if(msgFlag.equals("memberPwdSearchOk")) {
			model.addAttribute("msg", "메일에 임시 비밀번호가 발급되었습니다.");
			model.addAttribute("url", "member/memberLogin");
		}
		else if(msgFlag.equals("memberPwdSearchNo1")) {
			model.addAttribute("msg", "존재하지 않는 아이디입니다.");
			model.addAttribute("url", "member/memberPwdSearch");
		}
		else if(msgFlag.equals("memberPwdSearchNo2")) {
			model.addAttribute("msg", "아이디와 이메일이 불일치합니다.");
			model.addAttribute("url", "member/memberPwdSearch");
		}
		else if(msgFlag.equals("memberPwdSearchNo3")) {
			model.addAttribute("msg", "서버 처리중 오류가 발생했습니다. 다시 진행해주세요.");
			model.addAttribute("url", "member/memberPwdSearch");
		}
		else if(msgFlag.equals("memberPwdSearchNo4")) {
			model.addAttribute("msg", "메일 전송중 오류가 발생했습니다. 다시 진행해주세요.");
			model.addAttribute("url", "member/memberPwdSearch");
		}
		else if(msgFlag.equals("memberPwdUpdateOk")) {
			model.addAttribute("msg", "비밀번호가 수정되었습니다.");
			model.addAttribute("url", "member/memberMain");
		}
		else if(msgFlag.equals("memberPwdUpdateNo")) {
			model.addAttribute("msg", "기존 비밀번호가 불일치합니다.");
			model.addAttribute("url", "member/memberUpdatePwd");
		}
		else if(msgFlag.equals("fileUploadOk")) {
			model.addAttribute("msg", "파일이 업로드되었습니다.");
			model.addAttribute("url", "study/fileUpload/fileUploadForm");
		}
		else if(msgFlag.equals("fileUploadNo")) {
			model.addAttribute("msg", "파일 업로드 실패");
			model.addAttribute("url", "study/fileUpload/fileUploadForm");
		}
		
		return "include/message";
	}
}
