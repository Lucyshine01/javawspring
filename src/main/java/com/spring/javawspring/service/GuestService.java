package com.spring.javawspring.service;

import java.util.ArrayList;

import com.spring.javawspring.vo.GuestVO;

public interface GuestService {

	public ArrayList<GuestVO> getGuestList(int stratIndexNo, int pageSize);

	public void setGuestInput(GuestVO vo);

	public int totRecCnt();

	public void setGuestDeleteOk(int idx);
	
}
