package com.spring.javawspring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javawspring.dao.WebMessageServiceDAO;
import com.spring.javawspring.vo.WebMessageVO;

@Service
public class WebMessageServiceImpl implements WebMessageService {
	
	@Autowired
	WebMessageServiceDAO webMessageServiceDAO;

	@Override
	public WebMessageVO getWmMessageOne(int idx, String mid, int mFlag, String receiveSw) {
		if(receiveSw.equals("n") || mFlag != 5) {
			webMessageServiceDAO.setWmUpdate(idx, mid);
		}
		
		return webMessageServiceDAO.getWmMessageOne(idx,mid,mFlag);
	}

	@Override
	public List<WebMessageVO> getWmMessageList(String mid, int mSw, int startIndexNo, int pageSize) {
		return webMessageServiceDAO.getWmMessageList(mid,mSw,startIndexNo,pageSize);
	}

	@Override
	public void setWmInputOk(WebMessageVO vo) {
		webMessageServiceDAO.setWmInputOk(vo);
	}

	@Override
	public void wmDeleteCheck(int idx, int mFlag) {
		webMessageServiceDAO.wmDeleteCheck(idx,mFlag);
	}

	@Override
	public void wmDelete(int idx, int mFlag) {
		webMessageServiceDAO.wmDelete(idx,mFlag);
	}
}
