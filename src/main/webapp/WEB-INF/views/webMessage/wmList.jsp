<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>wmList.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<script>
		setTimeout("location.reload()", 1000*10);
		
		// 보낸 메세지함에서는 삭제처리만 할 수 있게 한다.
		function msgDel(idx) {
			let ans = confirm("선택된 메세지를 삭제하시겠습니까?");
			if(!ans) return false;
			let query = {
					idx : idx,
					mFlag : 3
			}
			$.ajax({
				type : "post",
				url : "${ctp}/webMessage/wmDelete",
				data : query,
				success: function() {
					alert("메세지가 삭제되었습니다.");
					location.reload();
				}
			});
			
		}
		
		// 휴지통에서 보낸메세지,받은메세지을 구분하여 삭제한다
		function msgDel2(idx,num) {
			let ans = confirm("선택된 메세지를 삭제하시겠습니까?");
			if(!ans) return false;
			let query = {
					idx : idx,
					mFlag : num
			}
			$.ajax({
				type : "post",
				url : "${ctp}/webMessage/wmDelete2",
				data : query,
				success: function() {
					alert("메세지가 삭제되었습니다.");
					location.reload();
				}
			});
		}
	</script>
</head>
<body>
<p><br/></p>
<div class="container">
	<table class="table table-hover">
		<tr class="table-dark text-dark">
			<th>번호</th>
			<th>
				<c:if test="${mSw==1 || mSw==2 || mSw==5}">보낸사람</c:if>
				<c:if test="${mSw==3 || mSw==4}">받은사람</c:if>
			</th>
			<th>제목</th>
			<th>
				<c:if test="${mSw==1 || mSw==2 || mSw==5}">보낸날짜</c:if>
				<c:if test="${mSw==3 || mSw==4}">받은날짜</c:if>
			</th>
		</tr>
		<!-- 
			mSw 	=> 1:받은메세지, 2:새메세지, 3:보낸메세지, 4.수신확인, 5:휴지통, 6:메세지상세보기, 0:메세지작서 
			mFlag => 1:받은메세지, 2:새메세지, 3:보낸메세지, 5:휴지통
		 -->
		<c:set var="curScrStartNo" value="${pageVo.curScrStartNo}"/>
		<c:forEach var="vo" items="${vos}">
		  <tr>
		    <td>${curScrStartNo}</td>
		    <td>
		    	<c:if test="${mSw==1 || mSw==2 || mSw==5}">${vo.sendId}</c:if>
				<c:if test="${mSw==3 || mSw==4}">${vo.receiveId}</c:if>
		    </td>
		    <td>
		    	<a href="wmMessage?mSw=6&mFlag=${param.mSw}&idx=${vo.idx}&receiveSw=${vo.receiveSw}&pag=${pageVo.pag}">${vo.title}</a>
		    	<c:if test="${vo.receiveSw=='n'}">
		    		<c:if test="${mSw==1 || mSw==2}"><img src="${ctp}/images/new.gif"/></c:if>
		    	</c:if>
		    	<c:if test="${mSw == 3}">
		        <a href="javascript:msgDel(${vo.idx})" class="badge badge-danger">삭제</a>
		      </c:if>
		    	<c:if test="${mSw == 5}">
		        <a href="javascript:msgDel2(${vo.idx},${vo.sendId == sMid ? '3' : '1'})" class="badge badge-danger">삭제</a>
		      </c:if>
		    </td>
		    <td>
		    	<span style="font-size: 0.8em">${fn:substring(vo.receiveDate,0,19)}</span>
		    </td>
		  </tr>
			<c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
		</c:forEach> 
		<tr><td colspan="4" class="m-0 p-0"></td></tr>   
	</table>
	<!-- 블록 페이지 시작 -->
	<div class="text-center">
		<c:set var="ctp_msg" value="${ctp}/webMessage/wmMessage?mSw=${mSw}&mFlag=${param.mFlag}" />
	  <ul class="pagination justify-content-center">
	    <c:if test="${pageVo.pag > 1}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_msg}&pag=${pageVo.pag}">첫페이지</a></li>
	    </c:if>
	    <c:if test="${pageVo.curBlock > 0}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_msg}&pag=${(pageVo.curBlock-1)*pageVo.blockSize + 1}">이전블록</a></li>
	    </c:if>
	    <c:forEach var="i" begin="${(pageVo.curBlock)*pageVo.blockSize + 1}" end="${(pageVo.curBlock)*pageVo.blockSize + pageVo.blockSize}" varStatus="st">
	      <c:if test="${i <= pageVo.totPage && i == pageVo.pag}">
	    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp_msg}&pag=${i}">${i}</a></li>
	    	</c:if>
	      <c:if test="${i <= pageVo.totPage && i != pageVo.pag}">
	    		<li class="page-item"><a class="page-link text-secondary" href="${ctp_msg}&pag=${i}">${i}</a></li>
	    	</c:if>
	    </c:forEach>
	    <c:if test="${pageVo.curBlock < pageVo.lastBlock}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_msg}&pag=${(pageVo.curBlock+1)*pageVo.blockSize + 1}">다음블록</a></li>
	    </c:if>
	    <c:if test="${pageVo.pag < pageVo.totPage}">
	      <li class="page-item"><a class="page-link text-secondary" href="${ctp_msg}&pag=${pageVo.totPage}">마지막페이지</a></li>
	    </c:if>
	  </ul>
	</div>
	<!-- 블록 페이지 끝 -->
</div>
<p><br/></p>
</body>
</html>