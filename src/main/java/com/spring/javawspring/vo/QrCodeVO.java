package com.spring.javawspring.vo;

import java.util.Date;

import lombok.Data;

@Data
public class QrCodeVO {
	private int idx;
	private String qrCode;
	private String bigo;
	private Date qrDate;
}
