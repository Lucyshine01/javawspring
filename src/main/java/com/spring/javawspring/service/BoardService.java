package com.spring.javawspring.service;

import java.util.ArrayList;
import java.util.List;

import com.spring.javawspring.vo.BoardReplyVO;
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

	public void setBoardReplyInput(BoardReplyVO replyVo);

	public List<BoardReplyVO> getBoardReply(int idx, int stratIndexNo, int replyPageSize);

	public void setboardReplyDeleteOk(int idx);

	public String getMaxLevelOrder(int boardIdx);


	public void setBoardReplyInput2(BoardReplyVO replyVo);

	public ArrayList<BoardReplyVO> getAfterReplyList(BoardReplyVO replyVo);

	public void setLevelOrderPlusUpdate(int boardIdx, int levelOrder);

	public int totRecCnt(int idx);

	public void setLevelOrderMinusUpdate(int boardIdx, int levelOrder);

	public void setBoardReplyUpdate(BoardReplyVO replyVo);

}
