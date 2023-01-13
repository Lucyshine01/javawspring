<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  	'use strict';
  	let pag = ${pageVO.pag};
  	let totPage = ${pageVO.totPage};
		if(totPage == 0) totPage = 1;
		
		let search = '${search}';
		
		
  	if(pag > totPage) {
  		if(search.length > 1) location.href = "${ctp}/board/boardSearch?pageSize=${pageVO.pageSize}&search=${search}&searchString=${searchString}&pag=${pageVO.totPage}";
			else location.href = "${ctp}/board/boardList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}";
  	}
  	function pageCheck() {
  		let pageSize = document.getElementById("pageSize").value;
			if(search.length > 1) location.href = "${ctp}/board/boardSearch?pageSize="+pageSize+"&pag=${pageVO.pag}&search=${search}&searchString=${searchString}";
			else location.href = "${ctp}/board/boardList?pageSize="+pageSize+"&pag=${pageVO.pag}";
		}
  	
  	
  	
  	function searchCheck() {
			let searchString = $("#searchString").val();
			
			if(searchString.trim() == "") {
				alert("검색어를 입력해주세요!");
				searchForm.searchString.focus();
			}
			else {
				searchForm.submit();
			}
		}
  	
  	
  	
  	function reply_blank(idx,title,nickName) {
			$.ajax({
				type: "post",
				url: "${ctp}/board/boardReplyViewPage",
				data: {boardIdx: idx},
				success: function(res) {
					let jsonRes = JSON.parse(res);
					
					let tempIdx = "";
					let tempBoardIdx = "";
					let tempMid = "";
					let tempNickName = "";
					let tempwrDate = "";
					let tempHostIp = "";
					let tempContent = "";
					//ajax안에선 안됌
					//$("#relpyModal").on("show.bs.modal", function(e) {
					$(".modal-body table").html("");
					$(".modal-header #title").html(title);
					$(".modal-header #nick").html(nickName);
					let str = '<tr><th>작성자</th><th>댓글내용</th><th>작성일자</th><th>접속IP</th></tr>';
					$(".modal-body table").append(str);
					for(let i in jsonRes.reply) {
						tempIdx = jsonRes.reply[i].idx;
						tempBoardIdx = jsonRes.reply[i].boardIdx;
						tempMid = jsonRes.reply[i].mid;
						tempNickName = jsonRes.reply[i].nickName;
						tempwrDate = jsonRes.reply[i].wrDate;
						tempHostIp = jsonRes.reply[i].hostIp;
						tempContent = jsonRes.reply[i].content;
						str = '<tr><td>'+tempNickName+'</td><td style="border-left: 1px solid #eee;">'+tempContent.replace("\n", "<br/>")+'</td>';
						str += '<td style="border-left: 1px solid #eee;">'+tempwrDate.substring(0, 16)+'</td><td style="border-left: 1px solid #eee;">'+tempHostIp+'</td></tr>';
						$(".modal-body table").append(str);
					}
					//}
				},
				error: function() {
					alert("실패");
				}
			});
		}
  </script>
  <style></style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<c:if test="${search != null}"><c:set var="ctp_boSearch" value="${ctp}/board/boardSearch?pageSize=${pageVO.pageSize}&search=${search}&searchString=${searchString}"/></c:if>
<c:if test="${search == null}"><c:set var="ctp_boList" value="${ctp}/board/boardList?pageSize=${pageVO.pageSize}"/></c:if>
<div class="container">
	<!-- search.bo -->
	<div id="test"></div>
	<c:if test="${search != null}">
		<h2 class="text-center">게 시 판 조 건 검 색 리 스 트</h2>
	  <div class="text-center">
	  	(<font color="blue">${searchTitle}</font>(으)로 <font color="red">${searchString}</font>(을)를 검색한 결과 ${searchCount}건이 검색되었습니다.)
	  </div>
	</c:if>
	<!-- list.bo -->
	<c:if test="${search == null}">
  	<h2 class="text-center">게 시 판 리 스 트</h2>
  </c:if>
  <br/>
  <table class="table table-borderless">
  	<tr>
  		<c:if test="${sLevel < 4}"><td class="text-left p-0"><a href="${ctp}/board/boardInput?pageSize=${pageVO.pageSize}&pag=${pageVO.pag}" class="btn btn-secondary btn-sm">글쓰기</a></td></c:if>
  		<td class="text-right p-0">
  			<select name="pageSize" id="pageSize" onchange="pageCheck()">
  				<option value="5" ${pageVO.pageSize==5 ? 'selected' : ''}>5건</option>
  				<option value="10" ${pageVO.pageSize==10 ? 'selected' : ''}>10건</option>
  				<option value="15" ${pageVO.pageSize==15 ? 'selected' : ''}>15건</option>
  				<option value="20" ${pageVO.pageSize==20 ? 'selected' : ''}>20건</option>
  			</select>
  		</td>
  	</tr>
  </table>
  <table class="table table-hover text-center">
  	<tr class="table-dark text-dark">
  		<th>글번호</th>
  		<th>글제목</th>
  		<th>글쓴이</th>
  		<th>글쓴날짜</th>
  		<th>조회수</th>
  		<th>좋아요</th>
  	</tr>
		<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
  	<c:forEach var="vo" items="${vos}">
  		<tr>
  			<td>${curScrStartNo}</td>
  			<td class="text-left">
  				<c:set var="ctp_content" value="${ctp}/board/boardContent?idx=${vo.idx}&pageSize=${pageVO.pageSize}&pag=${pageVO.pag}"/>
  				<a 
  					<c:if test="${search != null}">href="${ctp_content}&search=${search}&searchString=${searchString}"</c:if>
	  				<c:if test="${search == null}">href="${ctp_content}"</c:if>>
	  				${vo.title}
  				</a>
					<c:if test="${vo.replyCount != 0}">
  					<a href="#" onclick="reply_blank(${vo.idx},'${vo.title}','${vo.nickName}')" data-toggle="modal" data-target="#relpyModal"><font style="font-size: 0.9em; color: #999">[${vo.replyCount}]</font></a>
  				</c:if>
  				<c:if test="${vo.hour_diff < 24}"><img src="${ctp}/images/new.gif"/></c:if>
				</td>
  			<%-- <td class="text-left"><a >${vo.title}</a><c:if test="${vo.hour_diff < 24}"><img src="${ctp}/images/new.gif"/></c:if></td> --%>
  			<td>${vo.nickName}</td>
  			<td>
  				<c:if test="${vo.hour_diff < 24}">
  					<c:if test="${vo.hour_diff == 0}">1시간 이내</c:if>
  						
  					<c:if test="${vo.hour_diff > 0}">${vo.hour_diff}시간 전</c:if>
  				</c:if>
  				<c:if test="${vo.hour_diff >= 24}">
	  				<c:if test="${0 <= vo.day_diff && vo.day_diff <= 10}">${vo.day_diff}일 전</c:if>
	  				<c:if test="${10 < vo.day_diff && vo.day_diff <= 31}">${fn:substring(vo.wrDate,0,10)}</c:if>
	  				<c:if test="${31 < vo.day_diff}">${fn:substring(vo.wrDate,0,10)}</c:if>
  				</c:if>
  			</td>
  			<td>${vo.readNum}</td>
  			<td>${vo.good}</td>
  		</tr>
  		<c:set var="curScrStartNo" value="${curScrStartNo-1}"/>
  		<tr><td colspan="6" class="m-0 p-0"></td></tr>
  	</c:forEach>
  </table>
  <!-- 블록 페이지 시작 -->
  <!-- search.bo -->
  <c:if test="${search != null}">
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		    <c:if test="${pageVO.pag > 1}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boSearch}&pag=1">첫페이지</a></li>
		    </c:if>
		    <c:if test="${pageVO.curBlock > 0}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boSearch}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
		    </c:if>
		    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
		      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
		    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp_boSearch}&pag=${i}">${i}</a></li>
		    	</c:if>
		      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
		    		<li class="page-item"><a class="page-link text-secondary" href="${ctp_boSearch}&pag=${i}">${i}</a></li>
		    	</c:if>
		    </c:forEach>
		    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boSearch}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
		    </c:if>
		    <c:if test="${pageVO.pag < pageVO.totPage}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boSearch}&pag=${pageVO.totPage}">마지막페이지</a></li>
		    </c:if>
		  </ul>
		</div>
	</c:if>
	<!-- list.bo -->
  <c:if test="${search == null}">
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		    <c:if test="${pageVO.pag > 1}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boList}&pag=1">첫페이지</a></li>
		    </c:if>
		    <c:if test="${pageVO.curBlock > 0}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boList}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
		    </c:if>
		    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
		      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
		    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp_boList}&pag=${i}">${i}</a></li>
		    	</c:if>
		      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
		    		<li class="page-item"><a class="page-link text-secondary" href="${ctp_boList}&pag=${i}">${i}</a></li>
		    	</c:if>
		    </c:forEach>
		    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boList}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
		    </c:if>
		    <c:if test="${pageVO.pag < pageVO.totPage}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp_boList}&pag=${pageVO.totPage}">마지막페이지</a></li>
		    </c:if>
		  </ul>
		</div>
	</c:if>
	<!-- 블록 페이지 끝 -->
	<br/>
	<!-- 검색기 처리 시작 -->
	<div class="container">
		<form name="searchForm">
			<b>검색 : </b>
			<select name="search">
				<option ${search=='all' ? 'selected' : '' } value="all">전체</option>
				<option ${search=='title-content' ? 'selected' : '' } value="title-content">제목 + 내용</option>
				<option ${search=='title' ? 'selected' : '' } value="title">제목</option>
				<option ${search=='nickName' ? 'selected' : '' } value="nickName">닉네임</option>
				<option ${search=='content' ? 'selected' : '' } value="content">내용</option>
			</select>
			<input type="text" name="searchString" id="searchString" value="${searchString}"/>
			<input type="button" value="검색" onclick="searchCheck()" class="btn btn-secondary btn-sm" />
			<input type="hidden" name="pag" value="${pageVO.pag}" />
			<input type="hidden" name="pageSize" value="${pageVO.pageSize}" />
		</form>
	</div>
	<!-- 검색기 처리 끝 -->
</div>

<!-- The Modal -->
  <div class="modal fade" id="relpyModal">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">제목 : <span id="title"></span> (작성자:<span id="nick"></span>)</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
        	<div class="container" id="modal-main">
        		<table class="table table-hover text-center">
        			
        			
        		</table>
        	</div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>