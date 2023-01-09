<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberMain.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
  <script>
  	'use strict'
  	// 회원가입폼 체크후 서비로 전송(submit)
		var idChecksw = 0;
		var nickChecksw = 0;
  	function fCheck() {
  		console.log(idChecksw);
  		console.log(nickChecksw);
  		
			let maxSize = 1024 * 1024 * 1;	// 1MByte 까지 허용
			let fName = myform.fName.value;
			let ext = fName.substring(fName.lastIndexOf(".")+1)
			let uExt = ext.toUpperCase();
			
			let submitFlag = 0;
			
			// 파일 전송전에 파일에 관한사항 체크..(파일명이 넘어올경우는 해당 파일을 넘기고, 비었으면 'noimage.jpg'를 념겨준다.')
			if(fName.trim() == "") {
				myform.photo.value = "noimage.jpg";
				submitFlag = 1;
			}
			else {
				let fileSize = document.getElementById("file").files[0].size;
				
				if(fileSize > maxSize) {
					alert("업로드 파일의 크기는 1Mbyte를 초과할수 없습니다.");
					return false;
				}
				else if(uExt != "JPG" && uExt != "GIF" && uExt != "PNG") {
					alert("업로드 가능한 파일은 'JPG/GIF/PNG' 파일 입니다.");
					return false;
				}
				else if(fName.indexOf(" ") != -1) {
					alert("업로드 파일에는 공백을 포함할수 없습니다.");
					return false;
				}
				else {
					submitFlag = 1;
				}
			}
			
			// 전송전에 모든 체크가 끝났다면 submitFlag가 1일 되도록 처리후 서버로 전송한다.
			if(submitFlag == 1){
				// 아이디와 닉네임 중복체크버튼에 대한 체크...
				
				let midCheck = myform.midCheck.value;
				let nickNameCheck = myform.nickNameCheck.value;
				if(midCheck != 1 || idChecksw != 1){
					alert("아이디 중복체크를 하세요!");
					return false;
				}
				else if(nickNameCheck != 1 || nickChecksw != 1){
					alert("닉네임 중복체크를 하세요!");
					return false;
				}
				
				// 이메일을 하나로 묶어준다.
				let email1 = myform.email1.value;
				let email1_2 = myform.email1_2.value;
				let email2 = myform.email2.value;
				myform.email.value = email1 + "@" + email1_2 + email2;
				
				// 전화번호 합치기
				let tel1 = myform.tel1.value;
				let tel2 = myform.tel2.value;
				let tel3 = myform.tel3.value;
				let tel = tel1 + "-" + tel2 + "-" + tel3;
				myform.tel.value = tel;
				
				// 전송전에 '주소'를 하나로 묶어서 전송처리
				let postcode = myform.postcode.value + " ";
				let roadAddress = myform.roadAddress.value + " ";
				let detailAddress = myform.detailAddress.value + " ";
				let extraAddress = myform.extraAddress.value + " ";
				myform.address.value = postcode + "/" + roadAddress + "/" + detailAddress + "/" + extraAddress;
				

				// 폼의 유효성 검사~~~~
				// 숙제...
				let regId = /^([a-zA-Z0-9]){6,20}$/g;   //아이디는 영문소문자,대문자,숫자,밑줄만 사용가능  
				let regPwd = /^([!@#$%^&+=<>?,\./\*()_-]?[a-zA-Z0-9]){6,20}$/g;  //비밀번호는 영문대,소문자,숫자,키보드에서 입력가능한 특수문자 사용가능 최소6자~최대20자
				let regNick = /^([가-힣a-zA-Z]{2,20})$/g;  //닉네임은 한글/영문만 가능하도록 길이는 2~20자까지
				let regName = /^([가-힣a-zA-Z]{2,20})$/g;  //성명은 한글/영문만 가능하도록 길이는 2~20자까지
				let regEmail = /^([-_.]?[0-9a-zA-Z]){4,20}@+([-_.]?[0-9a-zA-Z]){4,20}.+[a-zA-Z]{2,3}$/i; //이메일 형식에 맞도록 체크(a@b.c)
				let regTel = /^([0-9]){2,3}-+([0-9]){3,4}-+([0-9]){3,4}$/g;
				
	      let mid = myform.mid.value;
	      let pwd = myform.pwd.value;
	      let nickName = myform.nickName.value;
	      let name = myform.name.value;
	      let email = email1 + "@" + email1_2 + email2;
	      
				if(!mid.match(regId)){
					alert("허용되지 않는 아이디입니다!");
          document.getElementById("mid").focus();
          return false;
				}
				else if(!pwd.match(regPwd)){
					alert("허용되지 않는 비밀번호입니다!");
          document.getElementById("pwd").focus();
          return false;
				}
				else if(!nickName.match(regNick)){
					alert("허용되지 않는 닉네임입니다!");
          document.getElementById("nickName").focus();
          return false;
				}
				else if(!name.match(regName)){
					alert("허용되지 않는 성명입니다!");
          document.getElementById("name").focus();
          return false;
				}
				else if(!email.match(regEmail)){
					alert("허용되지 않는 이메일입니다!");
          document.getElementById("email1").focus();
          return false;
				}
				else if(!tel.match(regTel) && tel != "010--"){
					alert("허용되지 않는 전화번호입니다!");
          document.getElementById("tel2").focus();
          return false;
				}
				//alert("회원 가입성공!");
				myform.submit();
			}
			else {
				alert("회원가입 실패!");
			}
			
		}
  	
  	// id 중복체크
  	function idCheck() {
			let mid = myform.mid.value;
			
			if(mid.trim() == "" || mid.length<6 || mid.length>=20){
				alert("아이디를 확인하세요!(아이디 범위 6~20자)");
				myform.mid.focus();
				return false;
			}
			
			$.ajax({
				type : "post",
				url : "${ctp}/member/memberIdCheck",
				data : {mid : mid},
				success: function(res) {
					if(res == "1") {
						alert("이미 사용중인 아이디 입니다.");
						$("#mid").focus();
					}
					else {
						alert("사용 가능한 아이디입니다.");
						idChecksw = 1;
						document.getElementById("midCheck_label").style.visibility = "hidden";
						myform.midCheck.value = 1;
						$("#mid").attr("readonly","readonly");
					}
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	// nickName 중복체크
  	function nickCheck() {
			let nickName = myform.nickName.value;
			if(nickName.trim() == "" || nickName.length<2 || nickName.length>=20){
				alert("닉네임를 확인하세요!(닉네임 범위 6~20자)");
				myform.nickName.focus();
				return false;
			}
			
			$.ajax({
				type : "post",
				url : "${ctp}/member/memberNickNameCheck",
				data : {nickName : nickName},
				success: function(res) {
					if(res == "1") {
						alert("이미 사용중인 닉네임 입니다.");
						$("#nickName").focus();
					}
					else {
						alert("사용 가능한 닉네임입니다.");
						nickChecksw = 1;
						document.getElementById("nickNameCheck_label").style.visibility = "hidden";
						myform.nickNameCheck.value = 1;
						$("#nickName").attr("readonly","readonly");
					}
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	//중복체크 확인 표시
  	function midOverCheck() {
  		myform.midCheck.value = 0;
  		idChecksw = 0;
  		document.getElementById("midCheck_label").style.visibility = "visible";
		}
  	
  	function nickOverCheck() {
  		myform.nickNameCheck.value = 0;
  		nickChecksw = 0;
  		document.getElementById("nickNameCheck_label").style.visibility = "visible";
		}
  	
  	// 이메일 직접입력
  	$(function name() {
			$("#email2").change(function(){
				if (this.value == "") {
					$('#email1_2').attr('disabled', false);
				}
				else {
					$('#email1_2').val("");
					$('#email1_2').attr('disabled', true);
				}
			});
		});
  	
  </script>
  <style></style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/include/slide2.jsp"></jsp:include>
<p><br/></p>
<div class="container">
  <!-- <form name="myform" method="post" class="was-validated" enctype="multipart/form-data"> -->
  <form name="myform" method="post" class="was-validated">
    <h2>회 원 가 입</h2>
    <br/>
    <div class="form-group">
      <label for="mid">아이디 : &nbsp; &nbsp;<input type="button" value="아이디 중복체크" class="btn btn-secondary btn-sm" onclick="idCheck()"/></label>
      <!-- 아이디 중복체크 표시 -->
      <input type="hidden" value="0" id="midCheck"/>
      <span id="midCheck_label"><font color="red" style="font-size: 0.8em">아이디 중복체크를 하세요.</font></span>
      <input type="text" class="form-control" name="mid" id="mid" onchange="midOverCheck()" placeholder="아이디를 입력하세요." required autofocus/>
    </div>
    <div class="form-group">
      <label for="pwd">비밀번호 :</label>
      <input type="password" class="form-control" id="pwd" placeholder="비밀번호를 입력하세요." name="pwd" required />
    </div>
    <div class="form-group">
      <label for="nickName">닉네임 : &nbsp; &nbsp;<input type="button" value="닉네임 중복체크" class="btn btn-secondary btn-sm" onclick="nickCheck()" /></label>
      <!-- 닉네임 중복체크 표시 -->
      <input type="hidden" value="0" id="nickNameCheck"/>
      <span id="nickNameCheck_label"><font color="red" style="font-size: 0.8em">닉네임 중복체크를 하세요.</font></span>
      <input type="text" class="form-control" id="nickName" onchange="nickOverCheck()" placeholder="별명을 입력하세요." name="nickName" required />
    </div>
    <div class="form-group">
      <label for="name">성명 :</label>
      <input type="text" class="form-control" id="name" placeholder="성명을 입력하세요." name="name" required />
    </div>
    <div class="form-group">
      <label for="email1">Email address:</label>
				<div class="input-group mb-3">
				  <input type="text" class="form-control" placeholder="Email을 입력하세요." id="email1" name="email1" required/>
				  <span style="font-size: 1.3em;padding: 3px 10px;">@</span>
				  <input type="text" class="form-control"  id="email1_2" name="email1_2" value="" required disabled/>
				  <div class="input-group-append" style="padding-left: 10px">
				    <select name="email2" id="email2" class="custom-select">
					    <option value="naver.com" selected>naver.com</option>
					    <option value="hanmail.net">hanmail.net</option>
					    <option value="hotmail.com">hotmail.com</option>
					    <option value="gmail.com">gmail.com</option>
					    <option value="nate.com">nate.com</option>
					    <option value="yahoo.com">yahoo.com</option>
					    <option value="">직접입력</option>
					  </select>
				  </div>
				</div>
	  </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">성별 :</span> &nbsp; &nbsp;
			  <label class="form-check-label">
			    <input type="radio" class="form-check-input" name="gender" value="남자" checked>남자
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="radio" class="form-check-input" name="gender" value="여자">여자
			  </label>
			</div>
    </div>
    <div class="form-group">
      <label for="birthday">생일</label>
      <input type="date" name="birthday" value="<%=LocalDate.now() %>" class="form-control"/>
    </div>
    <div class="form-group">
      <div class="input-group mb-3">
	      <div class="input-group-prepend">
	        <span class="input-group-text">전화번호 :</span> &nbsp;&nbsp;
			      <select name="tel1" class="custom-select">
					    <option value="010" selected>010</option>
					    <option value="02">서울</option>
					    <option value="031">경기</option>
					    <option value="032">인천</option>
					    <option value="041">충남</option>
					    <option value="042">대전</option>
					    <option value="043">충북</option>
			        <option value="051">부산</option>
			        <option value="052">울산</option>
			        <option value="061">전북</option>
			        <option value="062">광주</option>
					  </select>-
	      </div>
	      <input type="text" name="tel2" size=4 maxlength=4 class="form-control"/>-
	      <input type="text" name="tel3" size=4 maxlength=4 class="form-control"/>
	    </div> 
    </div>
    <div class="form-group">
      <label for="address">주소</label>
			<input type="hidden" name="address" id="address">
			<div class="input-group mb-1">
				<input type="text" name="postcode" id="sample6_postcode" placeholder="우편번호" class="form-control">
				<div class="input-group-append">
					<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-secondary">
				</div>
			</div>
			<input type="text" name="roadAddress" id="sample6_address" size="50" placeholder="주소" class="form-control mb-1">
			<div class="input-group mb-1">
				<input type="text" name="detailAddress" id="sample6_detailAddress" placeholder="상세주소" class="form-control"> &nbsp;&nbsp;
				<div class="input-group-append">
					<input type="text" name="extraAddress" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
				</div>
			</div>
    </div>
    <div class="form-group">
	    <label for="homepage">Homepage address:</label>
	    <input type="text" class="form-control" name="homePage" value="http://" placeholder="홈페이지를 입력하세요." id="homePage"/>
	  </div>
    <div class="form-group">
      <label for="name">직업</label>
      <select class="form-control" id="job" name="job">
        <option>학생</option>
        <option>회사원</option>
        <option>공무원</option>
        <option>군인</option>
        <option>의사</option>
        <option>법조인</option>
        <option>세무인</option>
        <option>자영업</option>
        <option>기타</option>
      </select>
    </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">취미</span> &nbsp; &nbsp;
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="등산" name="hobby"/>등산
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="낚시" name="hobby"/>낚시
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="수영" name="hobby"/>수영
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="독서" name="hobby"/>독서
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="영화감상" name="hobby"/>영화감상
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="바둑" name="hobby"/>바둑
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="축구" name="hobby"/>축구
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="checkbox" class="form-check-input" value="기타" name="hobby" checked/>기타
			  </label>
			</div>
    </div>
    <div class="form-group">
      <label for="content">자기소개</label>
      <textarea rows="5" class="form-control" id="content" name="content" placeholder="자기소개를 입력하세요."></textarea>
    </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">정보공개</span>  &nbsp; &nbsp; 
			  <label class="form-check-label">
			    <input type="radio" class="form-check-input" name="userInfor" value="공개" checked/>공개
			  </label>
			</div>
			<div class="form-check-inline">
			  <label class="form-check-label">
			    <input type="radio" class="form-check-input" name="userInfor" value="비공개"/>비공개
			  </label>
			</div>
    </div>
    <div  class="form-group">
      회원 사진(파일용량:2MByte이내) :
      <input type="file" name="fName" id="fName" class="form-control-file border"/>
    </div>
    <button type="button" class="btn btn-secondary" onclick="fCheck()">회원가입</button> &nbsp;
    <button type="reset" class="btn btn-secondary">다시작성</button> &nbsp;
    <button type="button" class="btn btn-secondary" onclick="location.href='${ctp}/member/memberLogin.mem';">돌아가기</button>
    
    <input type="hidden" name="photo"/>
    <input type="hidden" name="tel"/>
    <input type="hidden" name="email"/>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>