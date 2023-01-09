package com.spring.javawspring.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class Level3Interceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)throws Exception {
		HttpSession session = request.getSession();
		int level = session.getAttribute("sLevel") == null ? 99 : (int)session.getAttribute("sLevel");
		if(level > 3) {
			RequestDispatcher dispatcher;
			if(level == 99) {	// 비회원인 경우
				dispatcher = request.getRequestDispatcher("/msg/memberNo");
				dispatcher.forward(request, response);
				return false;
			}
			else { // 준회원(level : 4)인경우 
				dispatcher = request.getRequestDispatcher("/msg/levelCheckNo");
			}
			dispatcher.forward(request, response);
			return false;
		}
		
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)throws Exception {
		
	}
	
}
