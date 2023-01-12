package com.spring.javawspring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.javawspring.pagination.PageProcess;
import com.spring.javawspring.pagination.PageVO;
import com.spring.javawspring.service.BoardService;
import com.spring.javawspring.service.MemberService;
import com.spring.javawspring.vo.BoardReplyVO;
import com.spring.javawspring.vo.BoardVO;
import com.spring.javawspring.vo.MemberVO;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardService boardService; 
	
	@Autowired
	MemberService memberService; 
	
	
	@Autowired // 스프링 시큐리티 의존성 주입완료
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/boardList", method = RequestMethod.GET)
	public String boardListGet(Model model, PageVO pageVO) {
		
		ArrayList<BoardVO> vos = new ArrayList<BoardVO>();
		ObjectMapper objectMapper = new ObjectMapper();
		ArrayList<HashMap<String, Object>> listMap = pageProcess.paging(pageVO,model,"board2", "");
		for(int i=0; i<listMap.size(); i++) vos.add(objectMapper.convertValue(listMap.get(i), BoardVO.class));
		model.addAttribute("vos",vos);
		
		return "board/boardList";
	}
	
	@RequestMapping(value = "/boardInput", method = RequestMethod.GET)
	public String boardInputGet(HttpSession session, Model model, PageVO pageVO) {
		String mid = (String)session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		model.addAttribute("pag",pageVO.getPag());
		model.addAttribute("pageSize",pageVO.getPageSize());
		model.addAttribute("email", vo.getEmail());
		model.addAttribute("homePage", vo.getHomePage());
		
		return "board/boardInput";
	}
	
	@RequestMapping(value = "/boardInput", method = RequestMethod.POST)
	public String boardInputPost(BoardVO vo, PageVO pageVO) {
		// content에 이미지가 저장되어 있다면, 저장된 이미지만 골라서 /resources/data/board/폴더에 저장시켜준다.
		boardService.imgCheck(vo.getContent());
		
		//이미지 복사작업이 끝나면, board폴더에 실제로 저장된 파일명을 DB에 저장시켜준다.(/resources/data/ckeditor/ => /resources/data/board/)
		vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/ckeditor/board/"));
		int res = boardService.setBoardInput(vo);
		
		if(res == 1) return "redirect:/msg/boardInputOk?pageSize="+pageVO.getPageSize();
		else return "redirect:/msg/boardInputNo?pag="+pageVO.getPag()+"&pageSize="+pageVO.getPageSize();
	}
	
	@RequestMapping(value = "/boardContent", method = RequestMethod.GET)
	public String boardContentGet(Model model, int idx, PageVO pageVO, HttpSession session,
			@RequestParam(name = "replyPag", defaultValue = "", required = false) String replyPag) {
		// 글 조회수 1회 증가시키기.(조회수 중복방지처리 - 세션 사용 : 'board+고유번호'를 객체배열에 추가시킨다.);
		ArrayList<String> contentIdx = (ArrayList)session.getAttribute("sContentIdx");
		if(contentIdx == null) contentIdx = new ArrayList<String>();
		if(!contentIdx.contains("b"+idx)) {
			// 조회수 증가처리
			boardService.setBoardReadNum(idx);
			contentIdx.add("b"+idx);
			session.setAttribute("sContentIdx", contentIdx);
		}
		
		// 해당접속자 '좋아요' 체크
		BoardVO vo = boardService.getBoardContent(idx);
		MemberVO memberVO = memberService.getMemberIdCheck((String) session.getAttribute("sMid"));
		if(vo.getGoodIdx().indexOf("("+memberVO.getIdx()+")/") != -1) model.addAttribute("goodSW","ON");
		else model.addAttribute("goodSW","OFF");
		
		// 이전글/ 다음글 가져오기
		ArrayList<BoardVO> pnVos = boardService.getPrevNext(idx);
		
		int replyPageSize = 10;
		int totRecCnt = boardService.totRecCnt(idx); 
		int totPage = (totRecCnt % replyPageSize)==0 ? totRecCnt / replyPageSize : (totRecCnt / replyPageSize)+1;
		
		int pag = 0;
		if(replyPag.equals("")) pag = totPage;
		else pag = Integer.parseInt(replyPag);
		
		int stratIndexNo = (pag-1) * replyPageSize; 
		int curScrStartNo = totRecCnt - stratIndexNo;
		
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize; 
		int lastBlock = (totPage-1) / blockSize;
		
		// 댓글 자겨오기(replyVos)
		if(totRecCnt != 0) {
			List<BoardReplyVO> replyVos = boardService.getBoardReply(idx,stratIndexNo,replyPageSize);
			model.addAttribute("replyVos", replyVos);
		}
		
		model.addAttribute("blockSize", blockSize);
		model.addAttribute("curBlock", curBlock); 
		model.addAttribute("lastBlock",lastBlock); 
		model.addAttribute("replyPageSize", replyPageSize);
		model.addAttribute("replyPag", pag);
		model.addAttribute("totPage", totPage);
		model.addAttribute("curScrStartNo", curScrStartNo);
		
		
		model.addAttribute("vo",vo);
		model.addAttribute("pag",pageVO.getPag());
		model.addAttribute("pageSize",pageVO.getPageSize());
		model.addAttribute("pnVos",pnVos);
		
		return "board/boardContent";
	}
	
	@ResponseBody
	@RequestMapping(value = "/boardGood", method = RequestMethod.POST,
			produces = "application/text; charset=utf8")
	public String boardGoodPost(BoardVO boardVO, HttpSession session) {
		boardVO = boardService.getBoardContent(boardVO.getIdx());
		MemberVO memberVO = memberService.getMemberIdCheck((String)session.getAttribute("sMid"));
		String goodStr = "";
		String goodIdxMid = "("+memberVO.getIdx()+")/";
		if(boardVO.getGoodIdx().indexOf(goodIdxMid) == -1) {
			boardVO.setGoodIdx(boardVO.getGoodIdx()+goodIdxMid);
			boardVO.setGood(boardVO.getGood() + 1);
			goodStr = "/plus";
		}
		else {
			boardVO.setGoodIdx(boardVO.getGoodIdx().replace(goodIdxMid, ""));
			boardVO.setGood(boardVO.getGood() - 1);
			goodStr = "/minus";
		}
		boardService.setBoardGood(boardVO.getIdx(),boardVO.getGood(),boardVO.getGoodIdx());
		
		return boardVO.getGood() + goodStr;
	}
	
	@RequestMapping(value = "/boardDeleteOk", method = RequestMethod.GET)
	public String boardDeleteOkGet(BoardVO boardVO, PageVO pageVO, Model model, HttpSession session) {
		boardVO = boardService.getBoardContent(boardVO.getIdx());
		
		String mid = (String) session.getAttribute("sMid");
		if(!mid.equals(boardVO.getMid())) {
			if((int)session.getAttribute("sLevel") != 0) {
				model.addAttribute("flag","?idx="+boardVO.getIdx()+"&pag="+pageVO.getPag()+"&pageSize="+pageVO.getPageSize());
				return "redirect:/msg/boardDeleteNo";
			}
		}
		
		// 게시글에 사진이 존재한다면 서버에 있는 사전파일을 먼저 삭제한다.
		if(boardVO.getContent().indexOf("src=\"/") != -1) {
			boardService.imgDelete(boardVO.getContent());
		}
		
		// DB에서 실제로 존재하는 게시글을 삭제처리한다.
		boardService.setBoardDeleteOk(boardVO.getIdx());
		
		model.addAttribute("flag","?pag="+pageVO.getPag()+"&pageSize="+pageVO.getPageSize());
		
		return "redirect:/msg/boardDeleteOk";
	}
	
	// 수정하기 폼 호출
	@RequestMapping(value = "/boardUpdate", method = RequestMethod.GET)
	public String boardUpdateGet(Model model, int idx, int pag, int pageSize) {
		// 수정창으로 이동시에는 먼저 원본파일에 그림파일이 있다면, 현재폴더(board)의 그림파일을 ckeditor폴더로 복사시켜놓는다.
		BoardVO vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheckUpdate(vo.getContent());
		
		model.addAttribute("vo",vo);
		model.addAttribute("pag",pag);
		model.addAttribute("pageSize",pageSize);
		
		return "board/boardUpdate";
	}
	
	// 변경된 내용 수정처리(그림포함)
	@RequestMapping(value = "/boardUpdate", method = RequestMethod.POST)
	public String boardUpdatePost(Model model, BoardVO vo, int pag, int pageSize) {
		// 수정된 자료가 원본자료와 수정할 필요가 없기에 CB에 저장된 원본 자료를 불러와서 비교한다.
		BoardVO origVO = boardService.getBoardContent(vo.getIdx());
		
		// content의 내용이 조금이라도 변경된것이 있다면 아래 내용을 수행처리시킨다.
		if(!origVO.getContent().equals(vo.getContent())) {
			// 실제로 수정하기버튼을 클릭하게되면 기존의 board폴더에 저장된 현재 content의 그림파일 모두를 삭제 시킨다.
			if(origVO.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(origVO.getContent());
			
			// vo.getContent()에 들어있는 파일의 경로는 'ckeditor/board'경로를 'ckeditor'로 변경시켜줘야한다.
			vo.setContent(vo.getContent().replace("/data/ckeditor/board/", "/data/ckeditor/"));
			
			// 앞의 모든준비가 끝나면, 파일을 처음 업로드한것과 같은 작업을 처리한다.
			// 이 작업은 처음 게시글을 올릴때의 파일복사 작업과 동일한 작업이다.
			boardService.imgCheck(vo.getContent());
			
			// 파일 업로드가 끝나면 다시 경로를 수정한다. 'ckeditor'경로를 'ckeditor/baord'변경시켜줘야한다.(즉, 변경된 vo.getContent()를 vo.setContent() 처리한다.)
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/ckeditor/board/"));
		}
		
		// 잘 정비된 vo를 DB에 Update시켜준다.
		boardService.setBoardUpdateOk(vo);
		
		model.addAttribute("flag","?idx="+vo.getIdx()+"&pag="+pag+"&pageSize="+pageSize);
		
		return "redirect:/msg/boardUpdateOk";
	}
	
	// 댓글 달기
	@ResponseBody
	@RequestMapping(value = "/boardReplyInput", method = RequestMethod.POST)
	public String boardReplyInputPost(BoardReplyVO replyVo) {
		//int level = 0;
		int levelOrder = 0;
		String strlevelOrder = boardService.getMaxLevelOrder(replyVo.getBoardIdx());
		if(strlevelOrder != null) levelOrder = Integer.parseInt(strlevelOrder);
		replyVo.setLevelOrder(levelOrder + 1);
		
		boardService.setBoardReplyInput(replyVo);
		
		return "1";
	}
	
	// 대댓글(답글) 달기
	@ResponseBody
	@RequestMapping(value = "/boardReplyInput2", method = RequestMethod.POST)
	public String boardReplyInput2Post(BoardReplyVO replyVo) {
		//System.out.println("replyVo : " + replyVo);
		
		ArrayList<BoardReplyVO> afterVos = boardService.getAfterReplyList(replyVo);
		
		int levelOrder = 0;
		if(afterVos.size() != 0) {
			for(int i=0; i<afterVos.size(); i++) {
				if(afterVos.get(i).getLevel() <= replyVo.getLevel()) {
					levelOrder = afterVos.get(i).getLevelOrder();
					break;
				}	
			}
			if(levelOrder == 0) levelOrder = afterVos.get(afterVos.size()-1).getLevelOrder()+1;
		}
		else {
			levelOrder = replyVo.getLevelOrder()+1;
		}
		
		boardService.setLevelOrderPlusUpdate(replyVo.getBoardIdx(),levelOrder);
		
		replyVo.setLevel(replyVo.getLevel()+1);
		replyVo.setLevelOrder(levelOrder);
		boardService.setBoardReplyInput2(replyVo);
		
		return "";
	}
	
	
	// 댓글 삭제
	@ResponseBody
	@RequestMapping(value = "/boardReplyDeleteOk", method = RequestMethod.POST)
	public String boardReplyDeleteOkPost(BoardReplyVO replyVo) {
		boardService.setboardReplyDeleteOk(replyVo.getIdx());
		boardService.setLevelOrderMinusUpdate(replyVo.getBoardIdx(), replyVo.getLevelOrder());
		return "";
	}
	
	// 댓글 수정
	@ResponseBody
	@RequestMapping(value = "/boardReplyUpdateOk", method = RequestMethod.POST)
	public String boardReplyUpdateOkPost(BoardReplyVO replyVo) {
		boardService.setBoardReplyUpdate(replyVo);
		return "";
	}
	
	
}
