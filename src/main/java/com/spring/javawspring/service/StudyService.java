package com.spring.javawspring.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javawspring.vo.GuestVO;
import com.spring.javawspring.vo.KakaoAddressVO;

public interface StudyService {

	public String[] getCityStringArr(String dodo);

	public ArrayList<String> getCityArrayListArr(String dodo);

	public GuestVO getGuestMid(String mid);

	public ArrayList<GuestVO> getGuestNames(String mid);

	public int fileUpload(MultipartFile fName);

	public void getCalendar();

	public String qrCreate(String mid, String moveFlag, String realPath);

	public int qrCodePracticeCreate(String mid, String movie, String adult, String student, String realPath);

	public KakaoAddressVO getKakaoAddressName(String address);

	public void setKakaoAddressName(KakaoAddressVO vo);

	public List<KakaoAddressVO> getAddressNameList();

	public void setKakaoDelete(String address);

	public void setKakaoAddressNameList(List<String> arr);

}
