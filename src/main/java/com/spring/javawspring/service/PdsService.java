package com.spring.javawspring.service;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.javawspring.vo.PdsVO;

public interface PdsService {
	
	public PdsVO getPdsContent(int idx);
	
	public void setPdsInput(MultipartHttpServletRequest file, PdsVO vo);

	public void setPdsDownNum(int idx);

	public int setpdsDelete(PdsVO vo);

}
