<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>fileList.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<script>
		'use strict';
		
		let clickSW = true;
		
		function allClick() {
			let files = document.getElementsByName("files");
			for(let i=0; i<files.length; i++) {
				files[i].checked = clickSW;
			}
			if(clickSW) clickSW = false;
			else clickSW = true;
		}
		
		function reverseClick() {
			let files = document.getElementsByName("files");
			for(let i=0; i<files.length; i++) {
				if(files[i].checked == true) files[i].checked = false;
				else files[i].checked = true;
			}
		}
		
		function checkedDelete() {
			let ans = confirm("파일을 삭제하시겠습니까?");
			if(!ans) return false;
			let files = document.getElementsByName("files");
			let	filesNames = '';
			for(let i=0; i<files.length; i++) {
				if(files[i].checked == true) {
					filesNames += files[i].id + "/";
				}
			}
			if(filesNames == '') return false;
			else {
				filesNames = filesNames.substring(0,filesNames.length-1);
				$.ajax({
					type: "post",
					url : "${ctp}/admin/file/fileDelete",
					data: {filesNames:filesNames},
					success: function(res) {
						alert(res);
						location.reload();
					},
					error: function() {
						alert("전송 오류");
					}
				});
			}
		}
		
	</script>
</head>
<body>
<p><br/></p>
<div class="container">
	<h2>서버 파일 리스트</h2>
	<hr/>
	<p>서버의 파일 경로 : ${ctp}/data/ckeditor/~~~파일명</p>
	<div class="mt-2">
		<input type="button" onclick="allClick()" value="전체 선택" class="btn btn-success"/>
		<input type="button" onclick="checkedDelete()" value="선택이미지 삭제" class="btn btn-warning"/>
		<input type="button" onclick="reverseClick()" value="반전 선택" class="btn btn-info"/>
	</div>
	<hr/>
	<table class="table table-hover text-center">
		<tr class="table-dark text-dark">
			<th>선택</th>
			<th>파일명</th>
			<th>이미지</th>
		</tr>
		<c:forEach var="file" items="${files}" varStatus="st">
			<c:if test="${file != 'board'}">
				<tr>
				<td style="vertical-align: middle;">
					<input type="checkbox" name="files" id="${file}" class="mr-3" style="transform: scale(1.5, 1.5)"/>
				</td>
				<td style="vertical-align: middle;">
					${file}
				</td>
				<td>
					<img src="${ctp}/data/ckeditor/${file}" width="150px"/>
				</td>
				</tr>
			</c:if>
		</c:forEach>
	</table>
</div>
<p><br/></p>
</body>
</html>