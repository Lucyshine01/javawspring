package com.spring.javawspring.pagination;

import java.util.ArrayList;

import org.springframework.ui.Model;

import com.spring.javawspring.vo.MemberVO;

public interface pageService {
	
	public ArrayList<MemberVO> paging(PageVO vo, Model model, String tableName);

	public ArrayList<MemberVO> pagingSearch(PageVO pageVO, Model model, String tableName, String keyWord, String searchWord);
	
}
