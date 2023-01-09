package com.spring.javawspring.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javawspring.dao.GuestDAO;
import com.spring.javawspring.vo.GuestVO;

@Service
public class GuestServiceImpl implements GuestService {
	
	@Autowired
	GuestDAO guestDAO;

	@Override
	public ArrayList<GuestVO> getGuestList(int stratIndexNo, int pageSize) {
		return guestDAO.getGuestList(stratIndexNo,pageSize);
	}

	@Override
	public void setGuestInput(GuestVO vo) {
		guestDAO.setGuestInput(vo);
	}

	@Override
	public int totRecCnt() {
		return guestDAO.totRecCnt();
	}

	@Override
	public void setGuestDeleteOk(int idx) {
		guestDAO.setGuestDeleteOk(idx);
	}
	
}
