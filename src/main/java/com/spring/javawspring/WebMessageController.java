package com.spring.javawspring;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javawspring.pagination.PageProcess;
import com.spring.javawspring.pagination.PageVO;
import com.spring.javawspring.service.MemberService;
import com.spring.javawspring.service.WebMessageService;
import com.spring.javawspring.vo.MemberVO;
import com.spring.javawspring.vo.WebMessageVO;

@Controller
@RequestMapping("/webMessage")
public class WebMessageController {
	
	@Autowired
	WebMessageService webMessageService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/wmMessage", method = RequestMethod.GET)
	public String webMessageGet(Model model, HttpSession session,
			@RequestParam(name="mSw", defaultValue = "1", required = false) int mSw,
			@RequestParam(name="mFlag", defaultValue = "1", required = false) int mFlag,
			@RequestParam(name="pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize", defaultValue = "5", required = false) int pageSize,
			@RequestParam(name="receiveSw", defaultValue = "", required = false) String receiveSw,
			@RequestParam(name="idx", defaultValue = "0", required = false) int idx) {
		
		String mid = (String) session.getAttribute("sMid");
		
		if(mSw == 0) {	// 메세지 작성하기
			
		}
		else if(mSw == 6) {	// 메세지 내용 상세보기
			WebMessageVO vo = webMessageService.getWmMessageOne(idx, mid, mFlag, receiveSw);
			model.addAttribute("vo",vo);
			model.addAttribute("pag", pag);
		}
		else {	// 받은메세지, 새메세지, 보낸메세지, 수신확인, 휴지통
			PageVO pageVo = pageProcess.totRecCnt(pag, pageSize, "webMessage", mid, mSw+"");
			List<WebMessageVO> vos = webMessageService.getWmMessageList(mid, mSw, pageVo.getStartIndexNo(), pageSize);
			model.addAttribute("vos", vos);
			model.addAttribute("pageVo", pageVo);
		}
		model.addAttribute("mSw", mSw);
		
		return "webMessage/wmMessage";
	}
	
	@RequestMapping(value = "/wmInput", method = RequestMethod.POST)
	public String wmInputPost(WebMessageVO vo) {
		MemberVO vo2 = memberService.getMemberIdCheck(vo.getReceiveId());
		if(vo2 == null) return "redirect:/msg/wmInputNo";
		
		webMessageService.setWmInputOk(vo);
		return "redirect:/msg/wmInputOk";
	}
	
	// 받은 메세지함에서의 휴지통 보내기
	@RequestMapping(value = "/wmDeleteCheck", method = RequestMethod.GET)
	public String wmDeleteCheckGet(int mSw, int idx, int mFlag, Model model) {
		webMessageService.wmDeleteCheck(idx,mFlag);
		model.addAttribute("mSw",mSw);
		return "redirect:/webMessage/wmMessage";
	}
	
	// 보낸 메세지함에서의 휴지통으로 삭제하기
	@ResponseBody
	@RequestMapping(value = "/wmDelete", method = RequestMethod.POST)
	public String wmDeletePost(int idx, int mFlag) {
		webMessageService.wmDeleteCheck(idx,mFlag);
		return "";
	}
	
	// 메세지 x로 삭제
	@ResponseBody
	@RequestMapping(value = "/wmDelete2", method = RequestMethod.POST)
	public String wmDelete2Post(int idx, int mFlag) {
		webMessageService.wmDelete(idx,mFlag);
		return "";
	}
	
}
