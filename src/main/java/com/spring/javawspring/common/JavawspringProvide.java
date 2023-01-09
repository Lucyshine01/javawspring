package com.spring.javawspring.common;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

public class JavawspringProvide {
	
	public int fileUpload(MultipartFile fName) {
		int res = 0;
		try {
			UUID uid = UUID.randomUUID();
			String oFileName = fName.getOriginalFilename();
			String saveFileName = uid + "_" + oFileName;
			
			writeFile(fName, saveFileName, "");
			res = 1;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return res;
	}

	// 실제 파일 업로드
	public void writeFile(MultipartFile fName, String saveFileName, String flag) throws IOException {
		byte[] data = fName.getBytes();
		
		// 서비스에서 리퀘스트 객체를 가져오려면 해당 코드를 작성해야한다.
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
//		request.getRealPath("/resources/pds/temp/");
		String realPath = "";
		realPath = request.getSession().getServletContext().getRealPath("/resources/"+flag+"/");
		
//		fName.getInputStream().read()...
		
		FileOutputStream fos = new FileOutputStream(realPath + saveFileName);
		fos.write(data);
//		fos.flush(); 2048 혹은 1024단위로 반복문돌릴때 남은 용량 처리로 사용
		fos.close();
		
	}
}
