<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>title</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<script>
		'use strict';
		
		function pwdCheck() {
			
			let mid = $("#mid").val();
			if(mid.trim == ''){
				alert("아이디를 입력하세요!");
				$("#mid").focus;
				return false;
			}
			
			let email1 = $("#email1").val();
			let email2 = $("#email2").val();
			
			if(email1.trim == '') {
				alert("이메일을 입력하세요!");
				$("#email1").focus;
				return false;
			}
			else if(email2.trim == '') {
				alert("이메일을 입력하세요!");
				$("#email2").focus;
				return false;
			}
			
			let toMail = email1 + "@" + email2;
			
			$("#toMail").val(toMail);
			
			myform.submit();
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="container" style="padding: 30px">
		  	<form name="myform" method="post" class="was-validated">
			  	<h2>비밀번호 찾기</h2>
			  	<p>회원 아이디를 입력해 주세요.</p>
			  	<div class="form-group mb-3">
			      <div class="input-group">
				      <input type="text" class="form-control" name="mid" id="mid" placeholder="example" required autofocus/>
				      <div class="valid-feedback">&nbsp;</div>
				      <div class="invalid-feedback">아이디를 입력해주세요.</div>
			      </div>
			    </div>
			  	<p>회원 이메일을 입력해 주세요.</p>
			  	<div class="form-group mb-3" style="height: 80px;">
			      <div class="input-group">
				      <input type="text" class="form-control" name="email1" id="email1"  placeholder="example" required/>
				      <div class="input-group-append">
				      	<span class="input-group-text">@</span>
				      </div>
				      <input type="text" class="form-control" name="email2" id="email2"  placeholder="example.com" required/>
				      <div class="valid-feedback"></div>
				      <div class="invalid-feedback">이메일을 입력해주세요.</div>
			      </div>
			    </div>
			    <div class="form-group text-right">
					  <button type="button" onclick="pwdCheck()" class="btn btn-primary">전송</button>
					  <button type="reset" class="btn btn-primary">다시입력</button>
					  <button type="button" onclick="location.href='${ctp}/member/memberLogin';" class="btn btn-primary">돌아가기</button>
			    </div>
			    <input type="hidden" name="toMail" id="toMail" />
			  </form>
		  </div>
  	</div>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>