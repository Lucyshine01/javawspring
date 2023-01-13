package com.spring.javawspring.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;

import com.spring.javawspring.vo.MemberVO;

public interface PageDAO {
	
	public int totRecCnt(@Param("tableName") String tableName);

	public ArrayList<MemberVO> getList(@Param("tableName") String tableName, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totRecCntSearch(@Param("tableName") String tableName, @Param("keyWord") String keyWord, @Param("searchWord") String searchWord);

	public ArrayList<MemberVO> getListSearch(@Param("tableName") String tableName, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("keyWord") String keyWord, @Param("searchWord") String searchWord);
	
	
	
	
	public int totTermRecCnt(@Param("tableName") String tableName, @Param("keyWord") String keyWord, @Param("searchWord") String searchWord);

	public ArrayList<HashMap<String, Object>> getTermList(@Param("tableName") String tableName, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("keyWord") String keyWord, @Param("searchWord") String searchWord);
	
}
