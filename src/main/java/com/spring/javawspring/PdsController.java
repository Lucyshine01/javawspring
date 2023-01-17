package com.spring.javawspring;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.javawspring.common.SecurityUtil;
import com.spring.javawspring.pagination.PageProcess;
import com.spring.javawspring.pagination.PageVO;
import com.spring.javawspring.service.PdsService;
import com.spring.javawspring.vo.PdsVO;

@Controller
@RequestMapping("/pds")
public class PdsController {
	
	@Autowired
	PdsService pdsService; 
	
	@Autowired // 스프링 시큐리티 의존성 주입완료
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	JavaMailSender mailSender;
	
	@RequestMapping(value = "/pdsList", method = RequestMethod.GET)
	public String pdsListGet(Model model,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part
		) {
		
		PageVO pageVO = new PageVO();
		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		
		ArrayList<PdsVO> vos = new ArrayList<PdsVO>();
		ObjectMapper objectMapper = new ObjectMapper();
		ArrayList<HashMap<String, Object>> listMap = pageProcess.paging(pageVO, model, "pds2", "part", part);
		for(int i=0; i<listMap.size(); i++) vos.add(objectMapper.convertValue(listMap.get(i), PdsVO.class));
		model.addAttribute("vos",vos);
		
		return "pds/pdsList";
	}
	
	@RequestMapping(value = "/pdsInput", method = RequestMethod.GET)
	public String pdsInputGet() {
		return "pds/pdsInput";
	}
	
	@RequestMapping(value = "/pdsInput", method = RequestMethod.POST)
	public String pdsInputPost(PdsVO vo,
			MultipartHttpServletRequest file) {
		String pwd = vo.getPwd();
		SecurityUtil securityUtil = new SecurityUtil();
		pwd = securityUtil.encryptSHA256(pwd);
		vo.setPwd(pwd);
		
		pdsService.setPdsInput(file, vo);
		
		return "redirect:/msg/pdsInputOk";
	}
	
	@ResponseBody
	@RequestMapping(value = "/pdsDownNum", method = RequestMethod.POST)
	public String pdsDownNumPost(int idx) {
		pdsService.setPdsDownNum(idx);
		return "";
	}
	
	
	// PDS 내용 삭제처리하기(삭제처리하기전에 비밀번호를 먼저 체크하여 맞으면 삭제처리한다.)
	@ResponseBody
	@RequestMapping(value = "/pdsDelete", method = RequestMethod.POST)
	public String pdsDeletePost(PdsVO vo) {
		int res = 0;
		vo.setPwd(SecurityUtil.encryptSHA256(vo.getPwd()));
		res = pdsService.setpdsDelete(vo);
		return String.valueOf(res);
	}
	
	// PDS 전체 다운로드
	@RequestMapping(value = "/pdsTotalDown", method = RequestMethod.GET)
	public void pdsTotalDownGet(HttpServletRequest request, HttpServletResponse response, int idx) throws IOException {
		
		// 파일 압축다운로드전에 다운로드수를 증가시킨다.
		pdsService.setPdsDownNum(idx);
		
		// 여러개의 파일일 경우 모든 파일을 하나의 파일로 압축(?=통합)하여 다운한다.
		// 이때 압축파일명은 '제목'으로 처리한다.
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/pds/");
		PdsVO vo = pdsService.getPdsContent(idx);
		String[] fiNames = vo.getFiName().split("/");
		String[] fiSNames = vo.getFiSName().split("/");
		
		String zipPath = realPath + "temp/";
		String zipName = vo.getTitle() + ".zip";
		
		FileInputStream fis = null;
		//FileOutputStream fos = null;
		
		// temp2에 zip파일 생성(이무것도 안들은 껍데기 파일)
		ZipOutputStream zout = new ZipOutputStream(new FileOutputStream(zipPath + zipName));
		
		byte[] buffer = new byte[2048];
		
		
		for(int i=0; i<fiSNames.length; i++) {
			// zip에 넣을 파일을 읽어온다
			fis = new FileInputStream(realPath + fiSNames[i]);
			//File moveAndRename = new File(zipPath + fiNames[i]);
			
			
//			// fos에 파일 쓰기작업
//			fos = new FileOutputStream(zipPath + fiNames[i]);
//			while(fis.read(buffer, 0, buffer.length) != -1) {
//				fos.write(buffer, 0, buffer.length);
//			}
//			fos.flush();
//			fos.close();
//			fis.close();
			
			zout.putNextEntry(new ZipEntry(fiNames[i]));
			
			while(fis.read(buffer, 0, buffer.length) != -1) {
				zout.write(buffer, 0, buffer.length);
			}
			zout.flush();
			zout.closeEntry();	// 엔트리 닫기
			fis.close();
		}
		
		zout.close();	// zip파일 닫기
		
		// 하나로 통합하기위해 닫음
		
		// java.net.URLEncoder.encode() : get방식 url을 타고 넘어가기위해 파일명을 utf로 인코딩해서 넘김(한글방지)
		// return "redirect:/pds/pdsDownAction?file="+java.net.URLEncoder.encode(zipName);
		System.out.println(java.net.URLEncoder.encode(zipName));
		
		
		
		
		/* 브라우저 별로 안정처리 */
		// 헤더에 있는 브라우저 정보를 받아오기, MSIE : 마이크로소프트 IE
//			if(request.getHeader("user-agent").indexOf("MSIE") == -1) {
//				// 8859_1 : 윈도우의 한글코드 변환방식
//				downLoadName = new String(zipName.getBytes("UTF-8"), "8859_1");
//			}
//			else {
//				downLoadName = new String(zipName.getBytes("EUC-KR"), "8859_1");
//			}
		
		
		/* zip파일 클라이언트에게 다운로드 처리 */
		
		fis = new FileInputStream(zipPath + zipName);
		
		// 클라이언트에게 전송할 파일명변경
		zipName = new String(zipName.getBytes("UTF-8"), "8859_1");	// 한글 파일명을 대비한 setHeader전에 파일명을 utf-8로 변환처리해준다
		response.setHeader("Content-Disposition", "attachment;filename="+zipName);	// 넘어갈 파일명을 response객체에서 정해준다
		ServletOutputStream sos = response.getOutputStream();
		
		while(fis.read(buffer, 0, buffer.length) != -1) {
			sos.write(buffer, 0, buffer.length);
		}
		
		sos.flush();
		sos.close();
		fis.close();
		
		// 파일삭제
		//new File(zipPath + zipName).delete();
		
		// void임으로 return을 하지않아도 됌
		// return "pds/pdsList";
	}
	
	
	// file명을 get방식을 받아왔을떄
	@RequestMapping(value = "/pdsDownAction", method = RequestMethod.GET)
	public void pdsDownActionGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String file = request.getParameter("file");
		
		String downPathFile = request.getSession().getServletContext().getRealPath("/resources/data/pds/temp/") + file;
		
		File downFile = new File(downPathFile);

		String downFileName = new String(file.getBytes("UTF-8"), "8859_1");
		
		response.setHeader("Content-Disposition", "attachment;filename="+downFileName);
		
		FileInputStream fis = new FileInputStream(downFile);
		ServletOutputStream sos = response.getOutputStream();
		
		byte[] buffer = new byte[2048];
		int data = 0;
		while((data = fis.read(buffer, 0, buffer.length)) != -1) {
			sos.write(buffer, 0, data);
		}
		sos.flush();
		sos.close();
		fis.close();
		
		// 다운로드 완료후 temp폴더의 파일들을 모두 삭제한다.
		// new File(downPathFile).delete();
	}
	
	
}
