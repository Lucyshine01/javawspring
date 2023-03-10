package com.spring.javawspring.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javawspring.vo.MemberVO;

public interface MemberService {

	public MemberVO getMemberIdCheck(String mid);

	public MemberVO getMemberNickNameCheck(String nickName);

	public int setMemberJoinOk(MultipartFile fName, MemberVO vo);

	public void setMemberVisitProcess(MemberVO vo);

	public int totRecCnt();

	public ArrayList<MemberVO> getMemberList(int stratIndexNo, int pageSize);

	public String getIdSearch(String toMail);

	public int setMemberPwdUpdate(String mid, String pwd);

	public MemberVO getMemberNickNameEmailCheck(String nickName, String email);

	public void setKakaoMemberInputOk(String mid, String pwd, String nickName, String email);

	public void setMemberUserDelCheck(String mid);
	
}
