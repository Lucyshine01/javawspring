package com.spring.javawspring.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.spring.javawspring.common.SecurityUtil;
import com.spring.javawspring.dao.StudyDAO;
import com.spring.javawspring.vo.GuestVO;
import com.spring.javawspring.vo.QrCodeVO;

@Service
public class StudyServiceImpl implements StudyService {
	
	@Autowired
	StudyDAO studyDAO;
	
	@Override
	public String[] getCityStringArr(String dodo) {
		String[] strArr = new String[100];
		
		if(dodo.equals("서울")) {
			strArr[0] = "강남구";
			strArr[1] = "서초구";
			strArr[2] = "동대문구";
			strArr[3] = "성북구";
			strArr[4] = "마포구";
			strArr[5] = "강동구";
			strArr[6] = "관악구";
			strArr[7] = "광진구";
			strArr[8] = "중구";
			strArr[9] = "서구";
		}
		else if(dodo.equals("경기")) {
			strArr[0] = "수원시";
			strArr[1] = "이천시";
			strArr[2] = "일산시";
			strArr[3] = "용인시";
			strArr[4] = "시흥시";
			strArr[5] = "광명시";
			strArr[6] = "광주시";
			strArr[7] = "의정부시";
			strArr[8] = "평택시";
			strArr[9] = "안성시";
		}
		else if(dodo.equals("충북")) {
			strArr[0] = "청주시";
			strArr[1] = "충주시";
			strArr[2] = "괴산군";
			strArr[3] = "진천군";
			strArr[4] = "제천시";
			strArr[5] = "음성군";
			strArr[6] = "옥천군";
			strArr[7] = "영동군";
			strArr[8] = "단양군";
			strArr[9] = "증평군";
		}
		else if(dodo.equals("충남")) {
			strArr[0] = "천안시";
			strArr[1] = "병천시";
			strArr[2] = "옥산군";
			strArr[3] = "아산시";
			strArr[4] = "공주시";
			strArr[5] = "당진군";
			strArr[6] = "보령시";
			strArr[7] = "계롱시";
			strArr[8] = "논산시";
			strArr[9] = "예산군";
		}
		
		return strArr;
	}

	@Override
	public ArrayList<String> getCityArrayListArr(String dodo) {
		ArrayList<String> vos = new ArrayList<String>();
		
		if(dodo.equals("서울")) {
			vos.add("강남구");
			vos.add("서초구");
			vos.add("동대문구");
			vos.add("성북구");
			vos.add("마포구");
			vos.add("강동구");
			vos.add("관악구");
			vos.add("광진구");
			vos.add("중구");
			vos.add("서구");
		}
		else if(dodo.equals("경기")) {
			vos.add("수원시");
			vos.add("이천시");
			vos.add("일산시");
			vos.add("용인시");
			vos.add("시흥시");
			vos.add("광명시");
			vos.add("광주시");
			vos.add("의정부시");
			vos.add("평택시");
			vos.add("안성시");
		}
		else if(dodo.equals("충북")) {
			vos.add("청주시");
			vos.add("충주시");
			vos.add("괴산군");
			vos.add("진천군");
			vos.add("제천시");
			vos.add("음성군");
			vos.add("옥천군");
			vos.add("영동군");
			vos.add("단양군");
			vos.add("증평군");
		}
		else if(dodo.equals("충남")) {
			vos.add("천안시");
			vos.add("병천시");
			vos.add("옥산군");
			vos.add("아산시");
			vos.add("공주시");
			vos.add("당진군");
			vos.add("보령시");
			vos.add("계롱시");
			vos.add("논산시");
			vos.add("예산군");
		}
		
		return vos;
	}

	@Override
	public GuestVO getGuestMid(String mid) {
		return studyDAO.getGuestMid(mid);
	}

	@Override
	public ArrayList<GuestVO> getGuestNames(String mid) {
		return studyDAO.getGuestNames(mid);
	}

	@Override
	public int fileUpload(MultipartFile fName) {
		int res = 0;
		try {
			UUID uid = UUID.randomUUID();
			String oFileName = fName.getOriginalFilename();
			String saveFileName = uid + "_" + oFileName;
			
			writeFile(fName, saveFileName);
			res = 1;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return res;
	}

	// 실제 파일 업로드
	public void writeFile(MultipartFile fName, String saveFileName) throws IOException {
		byte[] data = fName.getBytes();
		
		// 서비스에서 리퀘스트 객체를 가져오려면 해당 코드를 작성해야한다.
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
//		request.getRealPath("/resources/pds/temp/");
		String realPath = request.getSession().getServletContext().getRealPath("/resources/pds/temp/");
		
//		fName.getInputStream().read()...
		
		FileOutputStream fos = new FileOutputStream(realPath + saveFileName);
		fos.write(data);
//		fos.flush(); 2048 혹은 1024단위로 반복문돌릴때 남은 용량 처리로 사용
		fos.close();
		
	}

	@Override
	public void getCalendar() {
	  // model객체를 사용하게되면 불필요한 메소드가 많이 따라오기에 여기서는 request객체를 사용했다.
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		
		// 오늘 날짜 저장시켜둔다.(calToday변수, 년(toYear), 월(toMonth), 일(toDay))
		Calendar calToday = Calendar.getInstance();
		int toYear = calToday.get(Calendar.YEAR);
		int toMonth = calToday.get(Calendar.MONTH);
		int toDay = calToday.get(Calendar.DATE);
				
		// 화면에 보여줄 해당 '년(yy)/월(mm)'을 셋팅하는 부분(처음에는 오늘 년도와 월을 가져오지만, '이전/다음'버튼 클릭하면 해당 년과 월을 가져오도록 한다.
		Calendar calView = Calendar.getInstance();
		int yy = request.getParameter("yy")==null ? calView.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("yy"));
	  int mm = request.getParameter("mm")==null ? calView.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("mm"));
	  
	  if(mm < 0) { // 1월에서 전월 버튼을 클릭시에 실행
	  	yy--;
	  	mm = 11;
	  }
	  if(mm > 11) { // 12월에서 다음월 버튼을 클릭시에 실행
	  	yy++;
	  	mm = 0;
	  }
	  calView.set(yy, mm, 1);		// 현재 '년/월'의 1일을 달력의 날짜로 셋팅한다.
	  
	  int startWeek = calView.get(Calendar.DAY_OF_WEEK);  						// 해당 '년/월'의 1일에 해당하는 요일값을 숫자로 가져온다.
	  int lastDay = calView.getActualMaximum(Calendar.DAY_OF_MONTH);  // 해당월의 마지막일자(getActualMaxximum메소드사용)를 구한다.
	  
	  // 화면에 보여줄 년월기준 전년도/다음년도를 구하기 위한 부분
	  int prevYear = yy;  			// 전년도
	  int prevMonth = (mm) - 1; // 이전월
	  int nextYear = yy;  			// 다음년도
	  int nextMonth = (mm) + 1; // 다음월
	  
	  if(prevMonth == -1) {  // 1월에서 전월 버튼을 클릭시에 실행..
	  	prevYear--;
	  	prevMonth = 11;
	  }
	  
	  if(nextMonth == 12) {  // 12월에서 다음월 버튼을 클릭시에 실행..
	  	nextYear++;
	  	nextMonth = 0;
	  }
	  
	  // 현재달력에서 앞쪽의 빈공간은 '이전달력'을 보여주고, 뒷쪽의 남은공간은 '다음달력'을 보여주기위한 처리부분(아래 6줄)
	  Calendar calPre = Calendar.getInstance(); // 이전달력
	  calPre.set(prevYear, prevMonth, 1);  			// 이전 달력 셋팅
	  int preLastDay = calPre.getActualMaximum(Calendar.DAY_OF_MONTH);  // 해당월의 마지막일자를 구한다.
	  
	  Calendar calNext = Calendar.getInstance();// 다음달력
	  calNext.set(nextYear, nextMonth, 1);  		// 다음 달력 셋팅
	  int nextStartWeek = calNext.get(Calendar.DAY_OF_WEEK);  // 다음달의 1일에 해당하는 요일값을 가져온다.
	  
	  /* ---------  아래는  앞에서 처리된 값들을 모두 request객체에 담는다.  -----------------  */
	  
	  // 오늘기준 달력...
	  request.setAttribute("toYear", toYear);
	  request.setAttribute("toMonth", toMonth);
	  request.setAttribute("toDay", toDay);
	  
	  // 화면에 보여줄 해당 달력...
	  request.setAttribute("yy", yy);
	  request.setAttribute("mm", mm);
	  request.setAttribute("startWeek", startWeek);
	  request.setAttribute("lastDay", lastDay);
	  
	  // 화면에 보여줄 해당 달력 기준의 전년도, 전월, 다음년도, 다음월 ...
	  request.setAttribute("preYear", prevYear);
		request.setAttribute("preMonth", prevMonth);
		request.setAttribute("nextYear", nextYear);
		request.setAttribute("nextMonth", nextMonth);
		
		// 현재 달력의 '앞/뒤' 빈공간을 채울, 이전달의 뒷부분과 다음달의 앞부분을 보여주기위해 넘겨주는 변수
		request.setAttribute("preLastDay", preLastDay);				// 이전달의 마지막일자를 기억하고 있는 변수
		request.setAttribute("nextStartWeek", nextStartWeek);	// 다음달의 1일에 해당하는 요일을 기억하고있는 변수
	}

	@Override
	public String qrCreate(String mid, String moveFlag, String realPath) {
		String qrCodeName = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssSSSS");
		UUID uid = UUID.randomUUID();
		String strUid = uid.toString().substring(0,2);
		
		qrCodeName = sdf.format(new Date()) + "_" + mid + "_" + moveFlag + "_" + strUid;
		
		try {
			File file = new File(realPath);
			if(!file.exists()) file.mkdirs();	// 폴더 생성
			
			// getBytes() : 바이너리형식(2진법)을 바이트형식으로 변형
			String codeFlag = new String(moveFlag.getBytes("UTF-8"), "ISO-8859-1");
			
			// qr코드 만들기
			int qrCodeColor = 0xFF000000;	// qr코드 전경색(글자색) 16진수 색코드 0xFF000000
			int qrCodeBackColor = 0xFFFFFFFF; // qr코드 배경색 
			
			// QR코드 객체 생성
			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			
			//BitMatrix bitMatrix = qrCodeWriter.encode(moveFlag, BarcodeFormat.QR_CODE, qrCodeColor, qrCodeBackColor);
			// qr코드에 담을 내용 지정
			BitMatrix bitMatrix = qrCodeWriter.encode(codeFlag, BarcodeFormat.QR_CODE, 200, 200);
			
			// 색상 설정
			MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrCodeColor,qrCodeBackColor);
			
			// 내용과 설정을 가진 버퍼이미지 생성
			BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);
			
			// ImageIO(버퍼이미지, 이미지속성(jpg,png 등등), 파일(경로:파일명))
			ImageIO.write(bufferedImage, "png", new File(realPath + qrCodeName + ".png"));
			
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (WriterException e) {
			e.printStackTrace();
		}
		
		return qrCodeName;
	}

	@Override
	public int qrCodePracticeCreate(String mid, String movie, String adult, String student, String realPath) {
		String qrCodeName = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssSSSS");
		qrCodeName = sdf.format(new Date()) + mid + adult + student;
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy년 MM월 dd일");
		String content = "영화정보 : " + movie + " - 예매일 : " + sdf2.format(new Date()) + " - 성인 : " + adult + ", 청소년 : " + student;
		
		try {
			File file = new File(realPath);
			if(!file.exists()) file.mkdirs();
			
			String qrContent = new String(content.getBytes("UTF-8"), "ISO-8859-1");
			int qrCodeColor = 0xFF000000;
			int qrCodeBackColor = 0xFFFFFFFF;
			
			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			BitMatrix bitMatrix = qrCodeWriter.encode(qrContent, BarcodeFormat.QR_CODE, 200, 200);
			MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrCodeColor,qrCodeBackColor);
			BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);
			ImageIO.write(bufferedImage, "png", new File(realPath + qrCodeName + ".png"));
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (WriterException e) {
			e.printStackTrace();
		}
		
		content = "영화정보 : " + movie + " - 예매일 : " + sdf2.format(new Date());
		
		QrCodeVO vo = new QrCodeVO();
		
		vo.setQrCode(qrCodeName);
		vo.setBigo(content);
		return studyDAO.setQrCode(vo);
	}

	
}
