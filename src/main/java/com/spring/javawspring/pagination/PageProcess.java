package com.spring.javawspring.pagination;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.javawspring.dao.PageDAO;
import com.spring.javawspring.dao.WebMessageServiceDAO;
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
	
	@Autowired
	WebMessageServiceDAO webMessageServiceDAO;
	
	// 매퍼 동적처리로 하나로 통일
	public ArrayList<HashMap<String, Object>> paging(PageVO vo, Model model, String tableName, String keyWord, String searchWord) {
		
		if(vo.getPag() == 0) vo.setPag(1);
		if(vo.getPageSize() == 0) vo.setPageSize(5);
		
		vo.setTotRecCnt(PageDAO.totTermRecCnt(tableName, keyWord, searchWord));
		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
		
		vo.setBlockSize(3);
		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
		
		vo.setPart(keyWord);
		
		model.addAttribute("blockSize", vo.getBlockSize());
		model.addAttribute("curBlock", vo.getCurBlock());
		model.addAttribute("lastBlock", vo.getLastBlock());
		model.addAttribute("pageSize", vo.getPageSize());
		model.addAttribute("pag", vo.getPag());
		model.addAttribute("totRecCnt", vo.getTotRecCnt());
		model.addAttribute("totPage", vo.getTotPage());
		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
		
		model.addAttribute("pageVO", vo);
		model.addAttribute("searchWord",searchWord);
		System.out.println(vo.getStartIndexNo()+"/"+vo.getPageSize());
		return PageDAO.getTermList(tableName, vo.getStartIndexNo(), vo.getPageSize(), keyWord, searchWord);
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
	
	public PageVO totRecCnt(int pag, int pageSize, String section, String part, String searchString) {
		PageVO pageVO = new PageVO();
		
		int totRecCnt = 0;
		
		if(section.equals("webMessage")) {
			String mid = part;
			int mSw = Integer.parseInt(searchString);
			totRecCnt = webMessageServiceDAO.totRecCnt(mid, mSw);
		}
		
		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt / pageSize : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		
		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		pageVO.setTotRecCnt(totRecCnt);
		pageVO.setTotPage(totPage);
		pageVO.setStartIndexNo(startIndexNo);
		pageVO.setCurScrStartNo(curScrStartNo);
		pageVO.setBlockSize(blockSize);
		pageVO.setCurBlock(curBlock);
		pageVO.setLastBlock(lastBlock);
		
		return pageVO;
	}
	
	
}
