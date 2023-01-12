package com.spring.javawspring.pagination;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.javawspring.dao.PageDAO;
import com.spring.javawspring.vo.MemberVO;

@Service
public class PageProcess {

//	@Autowired
//	GuestDAO guestDAO;
//	
//	@Autowired
//	MemberDAO memberDAO;
	
	@Autowired
	PageDAO PageDAO;
	
	
	// 매퍼 동적처리로 하나로 통일
	public ArrayList<HashMap<String, Object>> paging(PageVO vo, Model model, String tableName, String searchWord) {
		
		if(vo.getPag() == 0) vo.setPag(1);
		if(vo.getPageSize() == 0) vo.setPageSize(5);
		
		vo.setTotRecCnt(PageDAO.totTermRecCnt(tableName, vo.getPart(), searchWord));
		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
		
		vo.setBlockSize(3);
		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
		
		
		model.addAttribute("blockSize", vo.getBlockSize());
		model.addAttribute("curBlock", vo.getCurBlock());
		model.addAttribute("lastBlock", vo.getLastBlock());
		model.addAttribute("pageSize", vo.getPageSize());
		model.addAttribute("pag", vo.getPag());
		model.addAttribute("totRecCnt", vo.getTotRecCnt());
		model.addAttribute("totPage", vo.getTotPage());
		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
		
		model.addAttribute("pageVO", vo);
		return PageDAO.getTermList(tableName, vo.getStartIndexNo(), vo.getPageSize(), vo.getPart(), searchWord);
	}
	
	
	
//	public ArrayList<MemberVO> paging(PageVO vo, Model model, String tableName) {
//		
//		if(vo.getPag() == 0) vo.setPag(1);
//		if(vo.getPageSize() == 0) vo.setPageSize(5);
//		
//		vo.setTotRecCnt(PageDAO.totRecCnt(tableName));
//		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
//		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
//		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
//		
//		vo.setBlockSize(3);
//		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
//		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
//		
//		model.addAttribute("blockSize", vo.getBlockSize());
//		model.addAttribute("curBlock", vo.getCurBlock());
//		model.addAttribute("lastBlock", vo.getLastBlock());
//		model.addAttribute("pageSize", vo.getPageSize());
//		model.addAttribute("pag", vo.getPag());
//		model.addAttribute("totPage", vo.getTotPage());
//		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
//		
//		return PageDAO.getList(tableName, vo.getStartIndexNo(), vo.getPageSize());
//	}
	
	public ArrayList<MemberVO> pagingSearch(PageVO vo, Model model, String tableName, String keyWord, String searchWord) {
		
		if(vo.getPag() == 0) vo.setPag(1);
		if(vo.getPageSize() == 0) vo.setPageSize(5);
		
		vo.setTotRecCnt(PageDAO.totRecCntSearch(tableName, keyWord, searchWord));
		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
		
		vo.setBlockSize(3);
		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
		
		model.addAttribute("blockSize", vo.getBlockSize());
		model.addAttribute("curBlock", vo.getCurBlock());
		model.addAttribute("lastBlock", vo.getLastBlock());
		model.addAttribute("pageSize", vo.getPageSize());
		model.addAttribute("pag", vo.getPag());
		model.addAttribute("totPage", vo.getTotPage());
		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
		
		return PageDAO.getListSearch(tableName, vo.getStartIndexNo(), vo.getPageSize(), keyWord, searchWord);
	}
}
