package com.spring.javawspring.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javawspring.vo.GuestVO;

public interface GuestDAO {

	public ArrayList<GuestVO> getGuestList(@Param("stratIndexNo") int stratIndexNo, @Param("pageSize") int pageSize);

	public void setGuestInput(@Param("vo") GuestVO vo);

	public int totRecCnt();

	public void setGuestDeleteOk(@Param("idx") int idx);
	
}
