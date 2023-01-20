package com.spring.javawspring.errorTest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/errorPage")
public class ErrorController {
	
	// 에러 연습 폼...
	@RequestMapping(value = "/error", method = RequestMethod.GET)
	public String errorGet() {
		return "errorPage/errorMain";
	}
	
	// jsp파일에서의 에러발생폼을 호출
	@RequestMapping(value = "/error1", method = RequestMethod.GET)
	public String error1Get() {
		return "errorPage/error1";
	}
	
	// 웹에서 400,403,404,405,500 에러가 발생시 이동할 경로설정
	@RequestMapping(value = "/errorOk", method = RequestMethod.GET)
	public String errorOkGet(String code, Model model) {
		model.addAttribute("code",code);
		return "errorPage/errorMsg2";
	}
	
	// Servlet에서 예외오류 발생....
	@RequestMapping(value = "/error3", method = RequestMethod.GET)
	public String error3Get() {
		String str = null;
		System.out.println("str : " + str.toString());
		return "errorPage/errorMain";
	}
	
}
