package com.spring.javawspring.service;

import java.util.List;

import com.spring.javawspring.vo.WebMessageVO;

public interface WebMessageService {

	public WebMessageVO getWmMessageOne(int idx, String mid, int mFlag, String receiveSw);

	public List<WebMessageVO> getWmMessageList(String mid, int mSw, int startIndexNo, int pageSize);

	public void setWmInputOk(WebMessageVO vo);

	public void wmDeleteCheck(int idx, int mFlag);

	public void wmDelete(int idx, int mFlag);

}
