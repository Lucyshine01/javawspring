package com.spring.javawspring.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javawspring.vo.MemberVO;

public interface MemberDAO {

	public MemberVO getMemberIdCheck(@Param("mid") String mid);

	public MemberVO getMemberNickNameCheck(@Param("nickName") String nickName);

	public int setMemberJoinOk(@Param("vo") MemberVO vo);

	public void setTodayCntUpdate(@Param("mid") String mid);

	public void setMemTotalUpdate(@Param("mid") String mid, @Param("nowTodayPoint") int nowTodayPoint, @Param("todayCnt") int todayCnt);

	public int totRecCnt();

	public ArrayList<MemberVO> getMemberList(@Param("stratIndexNo") int stratIndexNo, @Param("pageSize") int pageSize);

	public String getIdSearch(@Param("toMail") String toMail);

	public void setMemberPwdUpdate(@Param("mid") String mid, @Param("pwd") String pwd);

	public MemberVO getMemberNickNameEmailCheck(@Param("nickName") String nickName,@Param("email") String email);

	public void setKakaoMemberInputOk(@Param("mid") String mid,@Param("pwd") String pwd,@Param("nickName") String nickName,@Param("email") String email);

	public void setMemberUserDelCheck(@Param("mid") String mid);
	
}
