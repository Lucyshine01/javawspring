<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<%-- <% 
	if(request.getRemoteAddr().equals("192.168.50.191")){
		out.println("<script>");
		out.println("alert('당신은 밴됬습니다~ 뿌우~')");
		out.println("location.href='/javawjsp/'");
		out.println("</script>");
	}
%> --%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>guList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  	'use strict';
  	function delCheck(idx) {
			let ans = confirm("정말로 삭제하시겠습니까?");
			if(ans) location.href="${ctp}/guDelete.gu?idx="+idx;
		}
  	
  	/* 
  	function pageSizeChg() {
	    let pageSelect = document.getElementById("pageSize");
  		location.href="${ctp}/guList.gu?pageSize="+pageSelect.options[pageSelect.selectedIndex].value;
		}
  	 */
  	 
  	//이미지 크기제한
  	$(function(){
  		$("img").each(function () {
				let maxWidth = 960;
				let width = $(this).width();
				if(maxWidth < width){
					$(this).css("width", maxWidth);
				}
			})
  	});
  	
  </script>
  <style>
  	th {
  		text-align: center;
  		background-color: #ccc;
  	}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>방 명 록 리 스 트</h2>
  <br/>
  <table class="table">
  	<tr>
  		<td>
				<c:if test="${sAMid eq 'admin'}">
					<a href="${ctp}/adminLogout.gu" class="btn btn-sm btn-danger">관리자 로그아웃</a>
				</c:if>
				<c:if test="${sAMid ne 'admin'}">
					<a href="${ctp}/adminLogin.gu" class="btn btn-sm btn-secondary">관리자</a>
				</c:if>
			</td>
  		<td style="text-align: right;"><a href="${ctp}/guest/guestInput" class="btn btn-sm btn-secondary">글쓰기</a></td>
  	</tr>
  </table>
  <table class="table table-borderless m-0 p-0">
  	<tr>
  		<td class="text-left">
  			<h5>글 표시수</h5>
  			<!-- <select name="pageSize" id="pageSize" onchange="pageSizeChg()"> -->
  			<%-- 
  			<c:choose>
  				<c:when test="${pageSize==null}"><c:set var="pageSize" value="5"/></c:when>
  				<c:otherwise><c:set var="pageSize" value="${pageSize}"/></c:otherwise>
  			</c:choose>
  			 --%>
  			<%--  
  			<%
  				System.out.println("psg : "+(String)request.getAttribute("pageSize"));
	  			String pageSize = request.getAttribute("pageSize")==null ? "5" : (String)request.getAttribute("pageSize");
	  			request.setAttribute("pageSize", pageSize);
  			%>
  			 --%>
  			<form method="post" action="${ctp}/guList.gu?pag=${pag}">
					<select name="pageSize" id="pageSize" onchange="submit();" class="text-center">
						<option value="5" <c:if test="${pageSize==5}">selected</c:if>>5개</option>
						<option value="10" <c:if test="${pageSize==10}">selected</c:if>>10개</option>
						<option value="25" <c:if test="${pageSize==25}">selected</c:if>>25개</option>
						<option value="50" <c:if test="${pageSize==50}">selected</c:if>>50개</option>
						<option value="100" <c:if test="${pageSize==100}">selected</c:if>>100개</option>
					</select>
  			</form>
  		</td>
  		<td class="text-right">
  		
  			<!-- 현재 페이지가 최대페이지를 넘어갈 경우 최대페이지로 변환 -->
  			<c:if test="${pag>totPage}"><script>location.href="${ctp}/guList.gu?pag=${totPage}&pageSize=${pageSize}";</script></c:if>
  			
  			<!-- 첫페이지 / 이전페이지 / (현페이지번호/총페이지수) / 다음페이지 / 마지막페이지 -->
  			<c:if test="${pag > 1}">
  				<a href="${ctp}/guList.gu?pag=1&pageSize=${pageSize}">[첫페이지]</a>
  				<a href="${ctp}/guList.gu?pag=${pag-1}&pageSize=${pageSize}">[이전페이지]</a>
  			</c:if>
  			${pag}/${totPage}
  			<c:if test="${pag < totPage}">
  				<a href="${ctp}/guList.gu?pag=${pag+1}&pageSize=${pageSize}">[다음페이지]</a>
  				<a href="${ctp}/guList.gu?pag=${totPage}&pageSize=${pageSize}">[마지막페이지]</a>
  			</c:if>
  		</td>
  	</tr>
  </table>
  
  <div class="text-center">
		<c:forEach begin="1" end="${totPage}" varStatus="st">
			<c:if test="${pag eq st.count}">
				<a href="${ctp}/guList.gu?pag=${st.count}&pageSize=${pageSize}" class="btn btn-warning" style="width: 40px">${st.count}</a>
			</c:if>
			<c:if test="${pag ne st.count}">
				<a href="${ctp}/guList.gu?pag=${st.count}&pageSize=${pageSize}" class="btn btn-primary" style="width: 40px">${st.count}</a>
			</c:if>
		</c:forEach>
	</div>
	
	<!-- 첫페이지 / 이전블록 / 1(4) 2(5) 3(6) / 다음블록 / 마지막페이지-->

  <c:set var="curScrStartNo" value="${curScrStartNo}"/>
  <c:forEach var="vo" items="${vos}" varStatus="st">
	  <table class="table">
	  	<tr>
	  		<td>방문번호 : ${curScrStartNo}
				<c:if test="${sAMid eq 'admin'}">
					<a href="javascript:delCheck(${vo.idx})" class="btn btn-sm btn-danger">삭제</a>
				</c:if>
				</td>
	  		<td style="text-align: right;">방문IP : ${vo.hostIp}</td>
	  	</tr>
	  </table>
	  <table class="table table-bordered mb-0">
	  	<tr>
	  		<th style="width: 20%;">성명</th>
	  		<td style="width: 30%;">${vo.name}</td>
	  		<th style="width: 20%;">방문날짜</th>
	  		<td style="width: 30%;">${fn:substring(vo.visitDate,0,16)}</td>
	  	</tr>
	  	<tr>
	  		<th>전자우편</th>
	  		<td colspan="3">${vo.email}</td>
	  	</tr>
	  	<tr>
	  		<th>홈페이지</th>
	  		<td colspan="3">
	  			<c:if test="${fn:length(vo.homePage) <= 8}">없음</c:if>
	  			<c:if test="${fn:length(vo.homePage) > 8}">
	  				<a href="${vo.homePage}" target="_blank">${vo.homePage}</a>
	  			</c:if>
	  		</td>
	  	</tr>
	  	<tr>
	  		<th>방문소감</th>
	  		<td colspan="3">${fn:replace(vo.content, newLine, '<br/>')}</td>
	  	</tr>
	  </table>
  	<br/>
  	<c:set var="curScrStartNo" value="${curScrStartNo-1}"/>
  </c:forEach>
</div>
	<div>
		<ul class="pagination justify-content-center">
				<c:if test="${pag > 1}">
					<li class="page-item"><a class="page-link text-secondary" href="${ctp}/guList?pag=1&pageSize=${pageSize}">첫페이지</a></li>
				</c:if>
				<c:if test="${curBlock > 0}">
					<li class="page-item"><a class="page-link text-secondary" href="${ctp}/guList?pag=${(curBlock-1)*blockSize + 1}&pageSize=${pageSize}">이전블록</a></li>
				</c:if>
			<c:forEach var="i" begin="${curBlock*blockSize + 1}" end="${curBlock*blockSize + blockSize}" varStatus="st">
					<c:if test="${i <= totPage && i == pag}">
						<li class="page-item active "><a class="page-link bg-secondary border-secondary" href="${ctp}/guList?pag=${i}&pageSize=${pageSize}">${i}</a></li>
					</c:if>
					<c:if test="${i <= totPage && i != pag}">
						<li class="page-item"><a class="page-link text-secondary" href="${ctp}/guList?pag=${i}&pageSize=${pageSize}">${i}</a></li>
					</c:if>
			</c:forEach>
				<c:if test="${curBlock < lastBlock}">
					<li class="page-item"><a class="page-link text-secondary" href="${ctp}/guList?pag=${(curBlock+1)*blockSize + 1}&pageSize=${pageSize}">다음블록</a></li>
				</c:if>
				<c:if test="${pag < totPage}">
					<li class="page-item"><a class="page-link text-secondary" href="${ctp}/guList?pag=${totPage}&pageSize=${pageSize}">마지막페이지</a></li>
				</c:if>
		</ul>
	</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>