package com.spring.javawspring.vo;

import lombok.Data;

@Data
public class PageVO {
	
	// 기본 페이지네이션 변수
	private int pag;
	private int pageSize;
	private int totRecCnt;
	private int totPage;
	private int startIndexNo;
	private int curScrStartNo;
	private int blockSize;
	private int curBlock;
	private int lastBlock;
	
	// 페이지프로세스 사용 변수
	private String tableName;
	
}
