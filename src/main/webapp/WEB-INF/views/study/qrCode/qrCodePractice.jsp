<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>qrCodePractice.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<script>
		'use strict';
		
		function qrCreate(no) {
			let movie = $("#movie").val();
			let adult = $("#adult").val();
			let student = $("#student").val();
			
			if(adult == '' && student == '') {
				alert("인원을 설정해주세요!");
				return;
			}
			
			let query = {
					movie: movie,
					adult: adult,
					student: student
			}
			
			$.ajax({
				type: "post",
				url :  "${ctp}/study/qrCodePractice",
				data: query,
				success: function(res) {
					location.reload();
				},
				error : function() {
					alert("전송 오류");
				}
			});
			
		}
		
		function searchCheck() {
			let searchWord = $("#searchWord").val();
			let part = $("#part").val();
			if(searchWord.trim == '') {
				return;
			}
			location.href = '${ctp}/study/qrCodePractice?searchWord='+searchWord+'&part='+part+'&pag=${pageVO.pag}'
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container mb-2">
	<b>검색 : </b>
	<select name="part" id="part">
		<option ${pageVO.part =='idx' ? 'selected' : '' } value="idx">표번호</option>
		<option ${pageVO.part =='qrCode' ? 'selected' : '' } value="qrCode">qr코드</option>
		<option ${pageVO.part =='bigo' ? 'selected' : '' } value="bigo">내용</option>
	</select>
	<input type="text" name="searchWord" id="searchWord" value="${searchWord}"/>
	<input type="button" value="검색" onclick="searchCheck()" class="btn btn-secondary btn-sm" />
</div>
<div class="container">
	<table class="table text-center">
		<tr>
			<th>표번호</th>
			<th>내용</th>
			<th>qr코드</th>
			<th>표생성일</th>
		</tr>
		<c:forEach var="vo" items="${vos}" varStatus="st">
			<tr>
				<td style="vertical-align: middle;">${vo.idx}</td>
				<td style="vertical-align: middle;">${vo.bigo}</td>
				<td><img src="${ctp}/data/qrCode/practice/${vo.qrCode}.png"/></td>
				<td style="vertical-align: middle;"><fmt:formatDate value="${vo.qrDate}" pattern="yyyy년 MM월 dd일"/></td>
			</tr>
		</c:forEach>
		<tr><td colspan="4"></td></tr>
	</table>
	<c:if test="${searchWord == sMid && pageVO.part == qrCode}">
		<c:set var="ctp_qrList" value="${ctp}/study/qrCodePractice?" />
	</c:if>
	<c:if test="${searchWord != sMid || pageVO.part != qrCode}">
		<c:set var="ctp_qrList" value="${ctp}/study/qrCodePractice?searchWord=${searchWord}&part=${pageVO.part}&" />
	</c:if>
	<div class="text-center">
	  <ul class="pagination justify-content-center">
	    <c:if test="${pageVO.pag > 1}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_qrList}pag=1">첫페이지</a></li>
	    </c:if>
	    <c:if test="${pageVO.curBlock > 0}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_qrList}pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
	    </c:if>
	    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
	      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
	    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp_qrList}pag=${i}">${i}</a></li>
	    	</c:if>
	      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
	    		<li class="page-item"><a class="page-link text-secondary" href="${ctp_qrList}pag=${i}">${i}</a></li>
	    	</c:if>
	    </c:forEach>
	    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_qrList}pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
	    </c:if>
	    <c:if test="${pageVO.pag < pageVO.totPage}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_qrList}pag=${pageVO.totPage}">마지막페이지</a></li>
	    </c:if>
	  </ul>
	</div>
</div>
<div class="container">
	<h2>영화 예매</h2>
	<div>
		영화 : 
		<select name="movie" id="movie" class="mb-2">
			<option value="아바타">아바타</option>
			<option value="슬램덩크">슬램덩크</option>
			<option value="영웅">영웅</option>
			<option value="짱구는 못말려">짱구는 못말려</option>
			<option value="더복서">더복서</option>
			<option value="밀정">밀정</option>
		</select><br/>
		인원 : 성인
		<select name="adult" id="adult">
			<option value="">인원선택</option>
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
			<option value="8">8</option>
		</select> &nbsp;
		청소년
		<select name="student" id="student">
			<option value="">인원선택</option>
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
			<option value="8">8</option>
		</select><br/>
		<input type="button" value="예매하기" onclick="qrCreate()" class="btn btn-info mt-2" />
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>