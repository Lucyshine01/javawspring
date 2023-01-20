package com.spring.javawspring.errorTest;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
public class ErrorAdvice {
	
	private Logger logger = LoggerFactory.getLogger(ErrorAdvice.class);
	
	@ExceptionHandler(Exception.class)
	public String handelExcption(Exception ex, Model model, HttpServletRequest request) {
		logger.error("예외오류발생 : {}", ex.getMessage());
		System.out.println("exception : " + ex);
		System.out.println("exception : " + ex.getMessage());
		model.addAttribute("msg", "예외오류가 발생되었습니다.<br/>" + ex.getMessage());
		
		String url = "";
		if(request.getHeader("referer") != null) url = "location.href=\""+request.getHeader("referer")+"\"";
		else url = "history.back()";
		model.addAttribute("url", url);
		return "errorPage/errorMsg3";
	}
	
	// 404에러가 발생시에 처리하는 메소드...
	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(value = HttpStatus.NOT_FOUND)
	public String handler404(NoHandlerFoundException ex, Model model, HttpServletRequest request) {
		logger.error("예외오류발생 : {}", ex.getMessage());
		System.out.println("exception : " + ex);
		System.out.println("exception : " + ex.getMessage());
		System.out.println("exception : " + ex.getRequestURL());
		String url = "";
		if(request.getHeader("referer") != null) url = "location.href=\""+request.getHeader("referer")+"\"";
		else url = "history.back()";
		model.addAttribute("msg", "<p>접속한 페이지 정보가 없습니다. 확인하시고 다시 접속해 주세요.</p><p><input type='button' value='이전 페이지로 돌아가기' onclick='"+url+"' class='btn btn-secondary'/></p><p>" + ex.getMessage() + "</p>");
		//model.addAttribute("msg", "<p>접속한 페이지 정보가 없습니다. 확인하시고 다시 접속해 주세요.</p><p><input type='button' value='이전 페이지로 돌아가기' onclick='history.back();' class='btn btn-secondary'/></p>" + ex.getMessage());
		return "errorPage/errorMsg3";
	}
	
	
	
}
