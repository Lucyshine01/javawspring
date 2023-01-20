package com.spring.javawspring.dao;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.spring.javawspring.vo.GuestVO;

public class PageDAOTest {

	@Test
	public void testGetTermList() {
		GuestDAO dao = new GuestDAO() {
			
			@Override
			public int totRecCnt() {
				// TODO Auto-generated method stub
				return 0;
			}
			
			@Override
			public void setGuestInput(GuestVO vo) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void setGuestDeleteOk(int idx) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public ArrayList<GuestVO> getGuestList(int stratIndexNo, int pageSize) {
				// TODO Auto-generated method stub
				return null;
			}
		};
		
		List<GuestVO> vos = dao.getGuestList(0, 10);
		System.out.println("vos : " + vos);
		
	}

}
