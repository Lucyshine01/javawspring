package com.spring.javawspring.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javawspring.vo.BoardReplyVO;
import com.spring.javawspring.vo.BoardVO;

public interface BoardDAO {

	public int setBoardInput(@Param("vo") BoardVO vo);

	public BoardVO getBoardContent(@Param("idx") int idx);

	public void setBoardReadNum(@Param("idx") int idx);

	public void setBoardGood(@Param("idx") int idx, @Param("good") int good, @Param("goodIdx") String goodIdx);

	public ArrayList<BoardVO> getPrevNext(@Param("idx") int idx);

	public void setBoardDeleteOk(@Param("idx") int idx);

	public void setBoardUpdateOk(@Param("vo") BoardVO vo);

	public void setBoardReplyInput(@Param("replyVo") BoardReplyVO replyVo);

	public List<BoardReplyVO> getBoardReply(@Param("idx") int idx, 
			@Param("stratIndexNo") int stratIndexNo, @Param("replyPageSize") int replyPageSize);

	public void setboardReplyDeleteOk(@Param("idx") int idx);

	public String getMaxLevelOrder(@Param("boardIdx") int boardIdx);


	public void setBoardReplyInput2(@Param("replyVo") BoardReplyVO replyVo);

	public ArrayList<BoardReplyVO> getAfterReplyList(@Param("replyVo") BoardReplyVO replyVo);

	public void setLevelOrderPlusUpdate(@Param("boardIdx") int boardIdx, @Param("levelOrder") int levelOrder);

	public void setLevelOrderMinusUpdate(@Param("boardIdx") int boardIdx, @Param("levelOrder") int levelOrder);
	
	public int totRecCnt(@Param("idx") int idx);

	public void setBoardReplyUpdate(@Param("replyVo") BoardReplyVO replyVo);

	
}
