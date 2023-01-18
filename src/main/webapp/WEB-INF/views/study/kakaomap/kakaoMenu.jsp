<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div>
	<p>
		<a href="${ctp}/study/kakao/kakaomap/kakaoEx1" class="btn btn-success">마커표시/DB저장</a>
		<a href="${ctp}/study/kakao/kakaomap/kakaoEx2" class="btn btn-success">DB에 저장된지명검색/삭제</a>
		<a href="${ctp}/study/kakao/kakaomap/kakaoEx3" class="btn btn-success">키워드 검색</a>
		<a href="${ctp}/study/kakao/kakaomap/kakaoEx4" class="btn btn-success">카테고리별 검색</a>
	</p>
</div>