<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberLogin.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
  <!-- <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
  integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx" crossorigin="anonymous"></script> -->
  <script>
  	'use strict';
  	// 카카오 자바스크립트 인증키값
  	window.Kakao.init("d2bcf0f819fb71881355b11fbb27052e");
  	
  	// 카카오 로그인
  	function kakaoLogin() {
  		//카카오 인증 메소드 (카카오 고정 id명)
  		window.Kakao.Auth.login({
				scope: 'profile_nickname, account_email',
				// 로그인 성공시 수행
				success: function(autoObj) {
					console.log(autoObj);
					// 카카오(API) 서버에 요청(ajax) - 유저정보 가져오기
					// 무조건 get방식이라 type 쓰지않음
					window.Kakao.API.request({
						// 해당계정 정보를 가져오는 주소
						url : '/v2/user/me',
						success:function(res) {
							const kakao_account = res.kakao_account;
							// json 형식 { "키" : "값".. } - 백에서 map형식으로 받거나 프론트에서 자바스크립트형식으로 파싱시켜서 보내줌
							// 자바스크립트 형식 { 키 : "값" } - 키가 ""이 없음
							console.log(kakao_account);
							console.log(kakao_account.email);
							console.log(kakao_account.profile.nickname);
							//alert(kakao_account.email + " / " + kakao_account.profile.nickname)
							
							location.href="${ctp}/member/memberKakaoLogin?nickName="+kakao_account.profile.nickname+"&email="+kakao_account.email;
							
							// 새로운 토큰 값
							console.log(Kakao.Auth.getAccessToken(), "새로운 토큰 값");
							
							// 자바스크립트 형식, json형식 차이
							const str = `{
								  "name": "홍길동",
								  "age": 25,
								  "married": false,
								  "family": { "father": "홍판서", "mother": "춘섬" },
								  "hobbies": ["독서", "도술"],
								  "jobs": null
								}`;
							
							const obj = JSON.parse(str);
							console.log(str);
							console.log(obj);
							
						}
					});
				}
			});
		}
  	
  	
  	// 카카오 로그아웃
  	function kakaoLogout() {
  		// 카카오 언링크를 하려면 토큰값이 존재해야함으로 로그아웃전에 언링크를 실행한다.
			// unlinkApp();
  		// 다음에 로그인시에 동의항목 체크하고 로그인 할수 있도록 로그아웃시키기
  		/* Kakao.API.request({
	      url: '/v1/user/unlink',
	    }) */
	    // deleteCookie() : 쿠키를 삭제하여 로그인시 첫단계부터 로그인
	    /* .then(function(res) {
	        alert('success: ' + JSON.stringify(res));
	        deleteCookie();
	      })
	      .catch(function(err) {
	        alert('fail: ' + JSON.stringify(err));
	      }); */
  		/* Kakao.Auth.logout(function(){
  			// Kakao.Auth.getAccessToken() : 토큰값 받아오기
  			console.log(Kakao.Auth.getAccessToken(), "토큰 정보가 없습니다.(로그아웃되셨습니다.)");
  		}) */
  		Kakao.Auth.logout();
		}
  	
  	function unlinkApp() {
	    Kakao.API.request({
	      url: '/v1/user/unlink',
	    }).then(function(res) {
	        alert('success: ' + JSON.stringify(res));
	        deleteCookie();
	      })
	      .catch(function(err) {
	        alert('fail: ' + JSON.stringify(err));
	      });
	  }
  	/* --- 괴도kid 왔다감 --- */
    function deleteCookie() {
      document.cookie = 'authorize-access-token=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    }
    
  </script>
  <style></style>
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
			  	<h2>회원 로그인</h2>
			  	<p>회원 아이디와 비밀번호를 입력해 주세요</p>
			  	<br/>
			  	<div class="form-group">
			      <label for="mid">회원 아이디 : </label>
			      <input type="text" class="form-control" name="mid" id="mid" value="${cookie.cMid.value}" placeholder="아이디를 입력하세요." required autofocus/>
			      <div class="valid-feedback"></div>
			      <div class="invalid-feedback">회원 아이디는 필수 입력사항입니다.</div>
			    </div>
			  	<div class="form-group">
			      <label for="pwd">회원 비밀번호 : </label>
			      <input type="password" class="form-control" name="pwd" id="pwd" placeholder="비밀번호를 입력하세요." required/>
			      <div class="valid-feedback"></div>
			      <div class="invalid-feedback">회원 비밀번호는 필수 입력사항입니다.</div>
			    </div>
			    <div class="form-group">
					  <button type="submit" class="btn btn-primary">로그인</button>
					  <button type="reset" class="btn btn-primary">다시입력</button>
					  <button type="button" onclick="location.href='${ctp}/';" class="btn btn-primary">돌아가기</button>
					  <button type="button" onclick="location.href='${ctp}/member/memberJoin';" class="btn btn-primary">회원가입</button>
			    </div>
			    <div class="mb-2">
			    	<a href="javascript:kakaoLogin()"><img src="${ctp}/images/kakao_login_medium_narrow.png"/></a>
			    	<a href="javascript:kakaoLogout()" class="btn btn-danger" >로그아웃</a>
			    	<button class="api-btn" onclick="unlinkApp()">앱 탈퇴하기</button>
			    </div>
			    <div class="row" style="font-size:12px">
			    	<span class="col"><input type="checkbox" name="idCheck" checked/>아이디 저장</span>
			    	<span class="col">
			    		[<a href="${ctp}/member/memberIdSearch">아이디찾기</a>] / 
			    		[<a href="${ctp}/member/memberPwdSearch">비밀번호찾기</a>]
			    	</span>
			    </div>
			  </form>
		  </div>
  	</div>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>