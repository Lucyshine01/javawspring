package com.spring.javawspring.service;

import java.util.ArrayList;

import com.spring.javawspring.vo.BoardVO;

public interface BoardService {

	public int setBoardInput(BoardVO vo);

	public BoardVO getBoardContent(int idx);

	public void setBoardReadNum(int idx);

	public void setBoardGood(int idx,int good, String goodIdx);

	public ArrayList<BoardVO> getPrevNext(int idx);

	public void imgCheck(String content);

	public void setBoardDeleteOk(int idx);

	public void imgDelete(String content);

	public void imgCheckUpdate(String content);

	public void setBoardUpdateOk(BoardVO vo);

}
