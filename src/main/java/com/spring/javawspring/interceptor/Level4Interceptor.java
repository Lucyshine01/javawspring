package com.spring.javawspring.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class Level4Interceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)throws Exception {
		HttpSession session = request.getSession();
		int level = session.getAttribute("sLevel") == null ? 99 : (int)session.getAttribute("sLevel");
		
		if(level > 4) {	// 비회원인 경우
			RequestDispatcher dispatcher = request.getRequestDispatcher("/msg/memberNo");
			dispatcher.forward(request, response);
			return false;
		}
		
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)throws Exception {
		
	}
	
}
