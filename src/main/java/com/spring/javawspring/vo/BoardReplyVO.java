package com.spring.javawspring.vo;

import lombok.Data;

@Data
public class BoardReplyVO {
	private int idx;
	private int boardIdx;
	private String mid;
	private String nickName;
	private String wrDate;
	private String hostIp;
	private String content;
	private int level;
	private int levelOrder;
}
