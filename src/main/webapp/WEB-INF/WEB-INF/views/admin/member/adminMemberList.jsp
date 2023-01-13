<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>adminMemberList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  	'use strict'
  	function midSearch() {
			let mid = myform.mid.value;
			if(mid.trim() == "") {
				alert("아이디를 입력하세요!");
				myform.mid.focus();
			}
			else {
				myform.temp.value = "";
				myform.submit();
			}
		}
  	function search() {
			let temp = myform.temp.value;
			if(temp.trim() == "") {
				myform.temp.focus();
			}
			else {
				myform.mid.value = "";
				myform.submit();
			}
		}
  	function delCheck(idx) {
    	let ans = confirm("탈퇴처리 시키겠습니까?");
    	if(ans) location.href='${ctp}/adMemDel.ad?idx='+idx+'&pag=${pag}';
    }
  	
  	function searchCheck(e) {
    	let ans = confirm("등급을 수정하시겠습니까?");
    	if(!ans) return false;
    	
    	let items = e.value.split("/");
    	
    	let query = {
    			idx : items[1],
    			level : items[0]
    	}
    	
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/admin/member/adminMemberLevel",
    		data  : query,
    		success:function(res) {
    			if(res == "1") alert("등급 수정완료!");
    			else alert("등급 수정실패!");
    			location.reload();
    		},
    		error : function() {
    			alert("전송 오류");
    		}
    	});
    }
  	
  	
  </script>
  <style></style>
</head>
<body>
<p><br/></p>
<div class="container">
  <c:if test="${sLevel != 0}"><h2>전체 회원 리스트</h2></c:if>
  <c:if test="${sLevel == 0}"><h2>전체 회원 리스트(관리자용)</h2></c:if>
  <br/>
  <form name="myform">
  	<div class="row">
  		<div class="col text-left"><button type="button" onclick="location.href='${ctp}/adMemList.ad'" class="btn btn-secondary m-2" >전체검색</button></div>
  		<div class="col form-inline">
  			<input type="text" name="mid" class="form-control m-2" autofocus/>
  			<input type="button" value="아이디개별검색" onclick="midSearch();" class="btn btn-secondary m-2" />
  		</div>
  		<div class="col form-inline">
  			<input type="text" name="temp" class="form-control m-2" autofocus/>
  			<input type="button" value="일반검색" onclick="search();" class="btn btn-secondary m-2" />
  		</div>
  	</div>
  </form>
  <table class="table table-hover text-center">
  	<tr class="table-dark text-dark">
  		<th>회원번호</th>
  		<th>아이디</th>
  		<th>별명</th>
  		<th>성명</th>
  		<th>자기소개</th>
  		<th>최초가입일</th>
  		<th>마지막접속일</th>
  		<th>등급</th>
  		<th>정보공개</th>
  		<th>탈퇴유무</th>
  	</tr>
  	<c:forEach var="vo" items="${vos}" varStatus="st">
  		<tr>
  			<td>${vo.idx}</td>
  			<td><a href="${ctp}/adMemInfor.ad?mid=${vo.mid}&pag=${pag}">${vo.mid}</a></td>
  			<td>${vo.nickName}</td>
  			<td>${vo.name}<c:if test="${sLevel == 0 && vo.userInfor == '비공개'}"><font color="red">(비공개)</font></c:if></td>
  			<td style="width: 200px">
  				<c:if test="${vo.content == ''}">없음</c:if>
  				<c:if test="${vo.content != ''}">${vo.content}</c:if>
  			</td>
  			<td>${fn:substring(vo.startDate,0,10)}</td>
  			<td>${fn:substring(vo.lastDate,0,10)}</td>
  			<td style="width: 200px">
  				<form name="levelForm" method="post" action="${ctp}/adMemberLevel.ad">
  					<select name="level" onchange="searchCheck(this)" >
  						<option value="0/${vo.idx}" <c:if test="${vo.level==0}">selected</c:if>>관리자</option>
              <option value="1/${vo.idx}" <c:if test="${vo.level==1}">selected</c:if>>운영자</option>
              <option value="2/${vo.idx}" <c:if test="${vo.level==2}">selected</c:if>>우수회원</option>
              <option value="3/${vo.idx}" <c:if test="${vo.level==3}">selected</c:if>>정회원</option>
              <option value="4/${vo.idx}" <c:if test="${vo.level==4}">selected</c:if>>준회원</option>
  					</select>
  					<input type="hidden" name="idx" value="${vo.idx}"/>
  				</form>
  			</td>
  			<td>${vo.userInfor}</td>
  			<td>
  				<c:if test="${vo.userDel == 'OK'}">
  					<form method="post" action="${ctp}/adMemDel.ad">
  						<a href="javascript:delCheck(${vo.idx})"><font color="red"><b>탈퇴신청</b></font></a>
  					</form>
  				</c:if>
  				<c:if test="${vo.userDel != 'OK'}">활동중</c:if>
  			</td>
  		</tr>
  		<tr><td colspan="5" class="m-0 p-0"></td></tr>
  	</c:forEach>
  </table>
  <!-- 블록 페이지 시작 -->
<div class="text-center">
  <ul class="pagination justify-content-center">
    <c:if test="${pageVO.pag > 1}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/admin/member/adminMemberList?pag=1">첫페이지</a></li>
    </c:if>
    <c:if test="${pageVO.curBlock > 0}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/admin/member/adminMemberList?pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
    </c:if>
    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp}/admin/member/adminMemberList?pag=${i}">${i}</a></li>
    	</c:if>
      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
    		<li class="page-item"><a class="page-link text-secondary" href="${ctp}/admin/member/adminMemberList?pag=${i}">${i}</a></li>
    	</c:if>
    </c:forEach>
    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/admin/member/adminMemberList?pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
    </c:if>
    <c:if test="${pageVO.pag < pageVO.totPage}">
      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/admin/member/adminMemberList?pag=${pageVO.totPage}">마지막페이지</a></li>
    </c:if>
  </ul>
</div>
<div class="text-center">
		<c:forEach begin="1" end="${totPage}" varStatus="st">
			<c:if test="${pag eq st.count}">
				<a href="${ctp}/admin/member/adminMemberList?pag=${st.count}" class="btn btn-warning" style="width: 40px">${st.count}</a>
			</c:if>
			<c:if test="${pag ne st.count}">
				<a href="${ctp}/admin/member/adminMemberList?pag=${st.count}" class="btn btn-primary" style="width: 40px">${st.count}</a>
			</c:if>
		</c:forEach>
	</div>
<!-- 블록 페이지 끝 -->
</div>
<p><br/></p>
</body>
</html>