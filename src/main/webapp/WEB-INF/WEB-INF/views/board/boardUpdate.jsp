<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boardUpdate.jsp</title>
  <script src="${ctp}/ckeditor/ckeditor.js"></script>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  	'use strict';
  	function fCheck() {
			let title = myform.title.value;
			let content = myform.content.value;
			if(title.trim() == "") {
				alert("게시글 제목을 입력하세요!");
				myform.title.focus();
				return;
			}
			else if(content.trim() == "") {
				alert("게시글 제목을 입력하세요!");
				myform.content.focus();
				return;
			}
			else {
				myform.submit();
			}
		}
  </script>
  <style></style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <form name="myform" method="post">
  	<h2 class="text-center">게시판 글 수정</h2>
  	<br/>
  	<table class="table">
  		<tr>
  			<th>글쓴이</th>
  			<td>${vo.nickName}</td>
  		</tr>
  		<tr>
  			<th>글제목</th>
  			<td><input type="text" name="title" value="${vo.title}" id="title" autofocus required class="form-control"/></td>
  		</tr>
  		<tr>
  			<th>이메일</th>
  			<td><input type="text" name="email" value="${vo.email}" id="email" placeholder="이메일을 입력하세요" class="form-control"/></td>
  		</tr>
  		<tr>
  			<th>홈페이지</th>
  			<td><input type="text" name="email" value="${vo.homePage}" id="email" placeholder="홈페이지 주소를 입력하세요" class="form-control"/></td>
  		</tr>
  		<tr>
  			<th>글내용</th>
  			<td><textarea rows="6" name="content" id="content" class="form-control" required>${vo.content}</textarea></td>
  			<script>
  				CKEDITOR.replace("content",{
  					height:500,
  					filebrowserUploadUrl:"${ctp}/imageUpload", /* 그림 업로드 브라우저 예약어 */
  					uploadUrl:"${ctp}/imageUpload"  /* 그림을 드래그해서 업로드가능하게하는 예악어 */
  				});
  			</script>
  		</tr>
  		<tr>
  			<td colspan="2" class="text-center">
  				<input type="button" value="수정하기"  onclick="fCheck()" class="btn btn-secondary" /> &nbsp;
  				<input type="reset" value="다시입력" class="btn btn-warning" /> &nbsp;
  				<input type="button" value="돌아가기"  onclick="location.href='${ctp}/board/boardContent?idx=${vo.idx}&pag=${pag}&pageSize=${pageSize}';" class="btn btn-primary" />
  			</td>
  		</tr>
  	</table>
  	<input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}"/>
  	<input type="hidden" name="nickName" value="${sNickName}"/>
  	<input type="hidden" name="pageSize" value="${pageSize}"/>
  	<input type="hidden" name="pag" value="${pag}"/>
  	<input type="hidden" name="idx" value="${vo.idx}"/>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>