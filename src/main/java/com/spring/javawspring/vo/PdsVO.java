package com.spring.javawspring.vo;

import lombok.Data;

@Data
public class PdsVO {
	private int idx;
	private String mid;
	private String nickName;
	private String fiName;
	private String fiSName;
	private int fiSize;
	private String title;
	private String part;
	private String pwd;
	private String fiDate;
	private int downNum;
	private String openSw;
	private String content;
	private String hostIp;
	
	//as 필드
	private int day_diff;
	private int hour_diff;
	
}
