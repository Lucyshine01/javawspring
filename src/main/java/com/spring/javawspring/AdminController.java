package com.spring.javawspring;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.javawspring.pagination.PageProcess;
import com.spring.javawspring.pagination.PageVO;
import com.spring.javawspring.service.AdminService;
import com.spring.javawspring.vo.MemberVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService; 
	
	@Autowired // 스프링 시큐리티 의존성 주입완료
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	JavaMailSender mailSender;
	
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet() {
		return "admin/adminMain";
	}
	
	@RequestMapping(value = "/adminLeft", method = RequestMethod.GET)
	public String adminLeftGet() {
		return "admin/adminLeft";
	}
	
	@RequestMapping(value = "/adminContent", method = RequestMethod.GET)
	public String adminContentGet() {
		return "admin/adminContent";
	}
	
	@RequestMapping(value = "/member/adminMemberList", method = RequestMethod.GET)
	public String adminMemberListGet(PageVO pageVO, Model model) {
		
		ArrayList<MemberVO> vos = new ArrayList<MemberVO>();
		ObjectMapper objectMapper = new ObjectMapper();
		ArrayList<HashMap<String, Object>> listMap = pageProcess.paging(pageVO,model,"member2", pageVO.getPart(),"");
		for(int i=0; i<listMap.size(); i++) vos.add(objectMapper.convertValue(listMap.get(i), MemberVO.class));
		model.addAttribute("vos",vos);
		
		return "admin/member/adminMemberList";
	}
	
	// 회원 등급 변경하기
	@ResponseBody
	@RequestMapping(value = "/member/adminMemberLevel", method = RequestMethod.POST)
	public String adminMemberLevelPost(int idx, int level) {
		int res = adminService.setMemberLevelCheck(idx, level);
		return res+"";
	}
	
	// 어드민 파일리스트 폼..
	// ckeditor폴더의 파일 리스트 보여주기
	@RequestMapping(value = "/file/fileList", method = RequestMethod.GET)
	public String fileListGet(HttpServletRequest request, Model model) {
		String realPath = request.getRealPath("/resources/data/ckeditor/");
		
		// .list() : 해당 경로에 있는 파일들의 이름(경로)를 배열에 모두 담아준다.
		String[] files = new File(realPath).list();
		model.addAttribute("files",files);
		return "admin/file/fileList";
	}
	
	// ckeiditor 폴더 이미지 삭제처리
	@ResponseBody
	@RequestMapping(value = "/file/fileDelete", method = RequestMethod.POST,
			produces = "application/text; charset=utf8")
	public String fileDeletePost(HttpServletRequest request, String filesNames) {
		String realPath = request.getRealPath("/resources/data/ckeditor/");
		String[] fileName = filesNames.split("/");
		for(int i=0; i<fileName.length; i++) {
			File delFile = new File(realPath + fileName[i]);
			if(delFile.exists()) delFile.delete();
		}
		return "총 "+fileName.length+"개의 이미지가 삭제되었습니다.";
	}
	
}
