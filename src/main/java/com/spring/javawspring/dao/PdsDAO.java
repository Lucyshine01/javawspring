package com.spring.javawspring.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.javawspring.vo.PdsVO;

public interface PdsDAO {

	public void setPdsInput(@Param("vo") PdsVO vo);

	public void setPdsDownNum(@Param("idx") int idx);

	public PdsVO getPdsContent(@Param("idx") int idx);

	public int setpdsDelete(@Param("idx") int idx);

}
