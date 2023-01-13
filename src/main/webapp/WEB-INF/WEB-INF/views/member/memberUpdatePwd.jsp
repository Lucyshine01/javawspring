<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>title</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  	'use strict'
  	function fCheck() {
  		let regPwd = /^([!@#$%^&+=<>?,\./\*()_-]?[a-zA-Z0-9]){6,20}$/g;
  		
  		let oldPwd = document.getElementById("oldPwd").value;
  		let newPwd = document.getElementById("newPwd").value;
  		let rePwd = document.getElementById("rePwd").value;
  		
  		if(oldPwd.trim() == "") {
  			alert("기존 비밀번호를 입력하세요.");
  			document.getElementById("oldPwd").focus();
  		}
  		else if(newPwd.trim() == "") {
  			alert("새 비밀번호를 입력하세요.");
  			document.getElementById("newPwd").focus();
  		}
  		else if(rePwd.trim() == "") {
  			alert("새 비밀번호를 한번더 입력하세요.");
  			document.getElementById("rePwd").focus();
  		}
  		else if(!newPwd.match(regPwd)){
				alert("허용되지 않는 비밀번호양식입니다!\n6자~20자 사이의 영문,숫자,특수문자로 만들어주세요!");
			  document.getElementById("newpwd").focus();
			  return false;
			}
  		else if(newPwd != rePwd) {
  			alert("새 비밀번호와 동일한 비밀번호를 입력해주세요!")
  			document.getElementById("repwd").focus();
  		}
  		else if(oldPwd == newPwd) {
  			alert("기존비밀번호와 새 비밀번호가 동일합니다.")
  			document.getElementById("newpwd").focus();
  		}
  		else {
  			myform.mid.value = "${sMid}";
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
  <form name="myform" method="post" class="was-validated">
  	<h2 class="text-center">비밀번호 변경</h2>
		<table class="table table-bordered">
			<tr>
				<th>기존 비밀번호</th>
				<td>
					<input type="password" name="oldPwd" id="oldPwd" autofocus required class="form-control" />
					<div class="invalid-feedback">기존 비밀번호를 입력하세요.</div>
				</td>
			</tr>
			<tr>
				<th>새 비밀번호</th>
				<td>
					<input type="password" name="newPwd" id="newPwd" autofocus required class="form-control" />
					<div class="invalid-feedback">새 비밀번호를 입력하세요.</div>
				</td>
			</tr>
			<tr>
				<th>비밀번호 학인</th>
				<td>
					<input type="password" name="rePwd" id="rePwd" autofocus required class="form-control" />
					<div class="invalid-feedback">새 비밀번호를 한번더 입력하세요.</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="text-center">
					<input type="button" value="비밀번호변경" onclick="fCheck()" class="btn btn-success" /> &nbsp;
					<input type="reset" value="다시입력" class="btn btn-success" /> &nbsp;
					<input type="button" value="돌아가기" onclick="location.href='${ctp}/memMain.mem';" class="btn btn-success" />
				</td>
			</tr>
		</table>
		<input type="hidden" name="mid" />
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>