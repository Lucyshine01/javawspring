<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script src="https://kit.fontawesome.com/368f95b037.js" crossorigin="anonymous"></script>
  <script>
  	'use strict'
  	let goodSW = "${goodSW}";
  	window.onload = function(){
	  	if(goodSW != 'ON') {
	  		document.getElementById("goodOFF").style.display = "inline";
	  	}
	  	else {
	  		document.getElementById("goodON").style.display = "inline";
	  	}
  	}
  	
  	function goodCheck() {
			$.ajax({
				type: "post",
				url: "${ctp}/board/boardGood",
				data: {idx: ${vo.idx}},
				success: function(res){
					let goodCnt = res.split("/")[0];
					let plus_minus = res.split("/")[1];
					if(plus_minus != 'plus') {
						document.getElementById("goodOFF").style.display = "inline";
						document.getElementById("goodON").style.display = "none";
					}
					else {
						document.getElementById("goodOFF").style.display = "none";
						document.getElementById("goodON").style.display = "inline";
					}
					$("#goodCnt").html(goodCnt);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	// 게시글 삭제처리
  	function boardDelCheck() {
			let ans = confirm("현 게시글을 삭제하시겠습니까?");
			if(ans) location.href = "${ctp}/board/boardDeleteOk?idx=${vo.idx}&pageSize=${pageSize}&pag=${pag}";
		}
  	
  	// 전체 댓글(보이기/가리기)
  	$(function() {
  		
  		$("#replyViewBtn").hide();
  		
  		$("#replyViewBtn").click(function() {
  			$("#reply").slideDown(80);
  			$("#replyHiddenBtn").show();
  			$("#replyViewBtn").hide();
			});
  		
  		$("#replyHiddenBtn").click(function() {
  			$("#reply").slideUp(80);
  			$("#replyViewBtn").show();
  			$("#replyHiddenBtn").hide();
			});
  		
		});
  	
  	
  	
  	// 댓글 달기
  	function replyCheck() {
  		let content = $("#content").val();
  		if(content.trim() == "") {
  			alert("댓글을 입력하세요");
  			$("#content").focus;
  			return false;
  		}
  		let query = {
  				boardIdx : ${vo.idx},
  				mid : '${sMid}',
  				nickName : '${sNickName}',
  				content : content,
  				hostIp : '${pageContext.request.remoteAddr}'
  		};
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyInput",
				data : query,
				success:function(res) {
					if(res == "1") {
						alert("댓글이 등록되었습니다.");
						location.reload();
					}
					else {
						alert("댓글 등록에 실패했습니다.");
					}
				},
				error : function() {
					alert("전송 오류");
				}
			});
		}
  	
  	// 댓글 삭제하기
  	function replyDelCheck(idx) {
			let ans = confirm("댓글을 삭제하시겠습니까?");
			if(!ans) return false;
			$.ajax({
				type: "post",
				url : "${ctp}/board/boardReplyDeleteOk",
				data : {idx : idx},
				success : function() {
					location.reload();
				},
				error : function() {
						alert("전송 오류");
				}
			});
		}
  	
  	// 답변글(부모댓글의 댓글-대댓글)
  	function insertReply(idx,level,levelOrder,nickName) {
  		let insReply = '';
  		
  		insReply += '<div class="container">';
  		insReply += '<table class="m-2 p-0" style="width:90%">';
  		insReply += '<tr>';
  		insReply += '<td class="p-0 text-left">';
  		insReply += '<div>';
  		insReply += '답변 댓글 달기: &nbsp;';
  		insReply += '<input type="text" name="nickName" value="${sNickName}" size="6" readonly class="p-0"/>';
  		insReply += '</div>';
  		insReply += '</td>';
  		insReply += '<td>';
  		insReply += '<input type="button" value="답급 달기" onclick="replyCheck2(\''+idx+'\',\''+level+'\',\''+levelOrder+'\')" class="btn btn-success"/>';
  		insReply += '</td>';
  		insReply += '</tr>';
  		insReply += '<tr>';
  		insReply += '<td colspan="2" class="text-center p-0">';
  		insReply += '<textarea rows="3" class="form-control p-0" name="content" id="content'+idx+'">';
  		insReply += '@'+nickName+'\n';
  		insReply += '</textarea>';
  		insReply += '</td>';
  		insReply += '</tr>';
  		insReply += '</table>';
  		insReply += '</div>';
  		
  		$("#replyUpdateCloseBtn"+idx).hide();
  		$("#replyUpdateOpenBtn"+idx).show();
  		
  		$("#replyBoxOpenBtn"+idx).hide();
  		$("#replyBoxCloseBtn"+idx).show();
  		$("#replyBox"+idx).slideDown(100);
  		$("#replyBox"+idx).html(insReply);
		}
  	
  	function closeReply(idx) {
  		$("#replyBoxCloseBtn"+idx).hide();
  		$("#replyBoxOpenBtn"+idx).show();
  		$("#replyBox"+idx).slideUp(100);
  		$("#replyBox"+idx).html("");
		}
  	
  	function replyCheck2(idx, level, levelOrder) {
			let boardIdx = "${vo.idx}";
			let mid = "${sMid}";
			let nickName = "${sNickName}";
			let content = $("#content"+idx).val();
			let hostIp = "${pageContext.request.remoteAddr}"
  		
			if(content.trim == "") {
				alert("답변글(대댓글)을 입력하세요!");
				$("#content"+idx).focus();
				return false;
			}
			
			let query = {
					boardIdx : boardIdx,
					mid : mid,
					nickName : nickName,
					content : content,
					hostIp : hostIp,
					level : level,
					levelOrder : levelOrder
			}
  		
			$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyInput2",
				data : query,
				success: function() {
					location.reload();
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	function replyUpdateForm(idx,nickName,content) {
			let insReply = '';
  		
  		insReply += '<div class="container">';
  		insReply += '<table class="m-2 p-0" style="width:90%">';
  		insReply += '<tr>';
  		insReply += '<td class="p-0 text-left">';
  		insReply += '<div>';
  		insReply += '댓글 수정 : &nbsp;';
  		insReply += '<input type="text" name="nickName" value="${sNickName}" size="6" readonly class="p-0"/>';
  		insReply += '</div>';
  		insReply += '</td>';
  		insReply += '<td>';
  		insReply += '<input type="button" value="수정 완료" onclick="replyUpdateOk(\''+idx+'\')" class="btn btn-success"/>';
  		insReply += '</td>';
  		insReply += '</tr>';
  		insReply += '<tr>';
  		insReply += '<td colspan="2" class="text-center p-0">';
  		insReply += '<textarea rows="3" class="form-control p-0" name="content" id="content'+idx+'">';
  		insReply += content;
  		insReply += '</textarea>';
  		insReply += '</td>';
  		insReply += '</tr>';
  		insReply += '</table>';
  		insReply += '</div>';
  		
  		$("#replyBoxCloseBtn"+idx).hide();
  		$("#replyBoxOpenBtn"+idx).show();
  		
  		$("#replyUpdateOpenBtn"+idx).hide();
  		$("#replyUpdateCloseBtn"+idx).show();
  		$("#replyBox"+idx).slideDown(100);
  		$("#replyBox"+idx).html(insReply);
		}
  	
  	function replyUpdateClose(idx) {
  		$("#replyUpdateCloseBtn"+idx).hide();
  		$("#replyUpdateOpenBtn"+idx).show();
  		$("#replyBox"+idx).slideUp(100);
  		$("#replyBox"+idx).html("");
		}
  	
  	function replyUpdateOk(idx) {
  		let content = $("#content"+idx).val();
  		if(content.trim() == "") {
  			alert("댓글을 입력하세요");
  			$("#content").focus;
  			return false;
  		}
  		let query = {
  				idx : idx,
  				content : content,
  				hostIp : '${pageContext.request.remoteAddr}'
  		};
  		$.ajax({
				type : "post",
				url : "${ctp}/board/boardReplyUpdateOk",
				data : query,
				success: function() {
					location.reload();
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	
  </script>
  <style>
  	#main-table th {
  		text-align: center;
  	}
  	#goodON,#goodOFF {display: none;}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>글 내 용 보 기</h2>
  <br/>
  <table class="table table-borderless">
  	<tr>
  		<th class="text-right">hostIp : ${vo.hostIp}</th>
  	</tr>
  </table>
  <table class="table table-bordered" id="main-table">
  	<tr>
  		<th>글쓴이</th>
  		<td>${vo.nickName}</td>
  		<th>작성 날짜</th>
  		<td width="400px">
  			${fn:substring(vo.wrDate,0,16)}
  			<c:if test="${!empty vo.uwrDate}"> 
  				<font style="font-size: 0.9em; float: right;">
	  				<c:if test="${vo.upDay_diff == 0}">(방금 전 수정)</c:if>
	  				<c:if test="${0 < vo.upDay_diff && vo.upDay_diff < 60}">(${vo.upDay_diff}분 전 수정)</c:if>
	  				<c:if test="${60 < vo.upDay_diff && vo.upDay_diff < 60*24}">
	  					(${fn:substring(vo.upDay_diff/60,0,fn:indexOf(vo.upDay_diff/60,'.'))}시간 전 수정)</c:if>
	  				<c:if test="${60*24 < vo.upDay_diff}">
	  					(${fn:substring(vo.upDay_diff/(60*24),0,fn:indexOf(vo.upDay_diff/(60*24),'.'))}일 전 수정)</c:if>
  				</font>
  			</c:if>
  		</td>
  	</tr>
  	<tr>
  		<th>제목</th>
  		<td colspan="3">${vo.title}</td>
  	</tr>
  	<tr>
  		<th>이메일</th>
  		<td>${vo.email}</td>
  		<th>조회수</th>
  		<td>${vo.readNum}</td>
  	</tr>
  	<tr>
  		<th>홈페이지</th>
  		<td>${vo.homePage}</td>
  		<th>좋아요</th>
  		<td>
  			<c:set var="goodToggle" value="${'board'}${''+vo.idx}"/>
  			<span id="goodON"><font color="red"><a href="javascript:goodCheck()">❤</a></font></span>
  			<span id="goodOFF"><a href="javascript:goodCheck()">❤</a></span>
  			<span id="goodCnt">${vo.good}</span>
  			 <!-- , 👍계속증가 👎계속감소 -->
  		</td>
  	</tr>
  	<tr>
  		<th>글내용</th>
  		<td colspan="3" style="height: 250px">${fn:replace(vo.content, newLine, "<br/>")}</td>
  	</tr>
	</table>
	<table class="table table-borderless">
  	<tr>
			<c:if test="${flag != 'search'}">
				<td class="text-left">
  				<input type="button" value="돌아가기" onclick="location.href='${ctp}/board/boardList?pageSize=${pageSize}&pag=${pag}';" class="btn btn-primary"/>
  			</td>
			<c:if test="${flag == 'search'}">
			<td class="text-left">
  				<input type="button" value="돌아가기" onclick="location.href='${ctp}/board/boardSearch?pageSize=${pageSize}&pag=${pag}&search=${search}&searchString=${searchString}';" class="btn btn-primary" />
			</td>
			</c:if>
				<td class="text-right">
	  			<c:if test="${vo.mid == sMid || sLevel == 0}">
		  			<input type="button" value="수정하기" onclick="location.href='${ctp}/board/boardUpdate?idx=${vo.idx}&pageSize=${pageSize}&pag=${pag}';" class="btn btn-success"/>
		  			<input type="button" value="삭제하기" onclick="boardDelCheck()" class="btn btn-danger"/>
	  			</c:if>
  			</td>
			</c:if>
  	</tr>
  </table>
  <!-- 이전글/다음글 처리 -->
  <table class="table table-borderless">
	  <tr>
  		<td style="font-size: 1.1em">
	  		<c:if test="${!empty pnVos[1]}">
	  			<i class="fa-solid fa-arrow-up"></i> 다음글 
	  			: <a href="${ctp}/board/boardContent?idx=${pnVos[1].idx}&pageSize=${pageSize}&pag=${pag}">${pnVos[1].title}</a><br/>
	  		</c:if>
	  		<c:if test="${vo.idx < pnVos[0].idx}"><i class="fa-solid fa-arrow-up"></i> 다음글</c:if>
	  		<c:if test="${vo.idx > pnVos[0].idx}"><i class="fa-solid fa-arrow-down"></i> 이전글</c:if>
	  		  : <a href="${ctp}/board/boardContent?idx=${pnVos[0].idx}&pageSize=${pageSize}&pag=${pag}">${pnVos[0].title}</a><br/>
  		</td>
	  </tr>
  </table>
  <br/>
</div>
<!-- 댓글(대댓글) 처리 -->
<!-- 댓글 리스트보여주기 -->
<div class="container text-center mb-3">
	<input type="button" value="댓글보이기" id="replyViewBtn" class="btn btn-secondary" />
	<input type="button" value="댓글가리기" id="replyHiddenBtn" class="btn btn-info" />
</div>
<div id="reply">
	<table class="table table-hover text-center">
		<tr>
			<th>작성자</th>
			<th>댓글내용</th>
			<th>작성일자</th>
			<th>접속IP</th>
			<th>답글</th>
		</tr>
		<c:forEach var="replyVo" items="${replyVos}">
			<tr>
				<td class="text-left">
					<c:if test="${replyVo.level <= 0}">${replyVo.nickName}</c:if>
					<c:if test="${replyVo.level > 0}">
						<c:forEach var="i" begin="0" end="${replyVo.level}" >&nbsp;&nbsp;&nbsp;&nbsp;</c:forEach>
						└&nbsp;${replyVo.nickName}
					</c:if>
				</td>
				<td style="width: 600px; border-left: 1px solid #eee; padding-left: 30px" class="text-left">
					${fn:replace(replyVo.content, newLine, "<br/>")}
				</td>
				<td style="border-left: 1px solid #eee;">${fn:substring(replyVo.wrDate,0,16)}</td>
				<td style="border-left: 1px solid #eee;">
					${replyVo.hostIp}
					<c:if test="${sMid == replyVo.mid || sLevel == 0}">
						<a href="javascript:replyDelCheck('${replyVo.idx}','${replyVo.boardIdx}','${replyVo.levelOrder}')" style="width: 50px;font-size: 1.5em;" title="삭제하기">x</a>
					</c:if>
				</td>
				<td class="text-center" style="border-left: 1px solid #eee;">
					<input type="button" value="답글" onclick="insertReply('${replyVo.idx}','${replyVo.level}','${replyVo.levelOrder}','${replyVo.nickName}')" id="replyBoxOpenBtn${replyVo.idx}" class="btn btn-info btn-sm" />
					<input type="button" value="닫기" onclick="closeReply('${replyVo.idx}')" id="replyBoxCloseBtn${replyVo.idx}" class="btn btn-warning btn-sm" style="display: none;" />
					<c:if test="${sMid == replyVo.mid || sLevel == 0}">
						<input type="button" value="수정" onclick="replyUpdateForm('${replyVo.idx}','${replyVo.nickName}','${replyVo.content}')" class="btn btn-primary btn-sm" id="replyUpdateOpenBtn${replyVo.idx}"/>
						<input type="button" value="닫기" onclick="replyUpdateClose('${replyVo.idx}')" class="btn btn-warning btn-sm" style="display: none;" id="replyUpdateCloseBtn${replyVo.idx}"/>
					</c:if>
				</td>
			</tr>
			<tr>
				<td colspan="5" class="m-0 p-0" style="border-top: none;"><div id="replyBox${replyVo.idx}"></div></td>
			</tr>
		</c:forEach>
		<c:if test="${empty replyVos}">
			<tr><td colspan="5">게시글에 댓글이 없습니다!</td></tr>
		</c:if>
		<tr>
				<td colspan="5">
					<c:if test="${search == null}">
						<div class="text-center">
							<c:set var="ctp_reList" value="${ctp}/board/boardContent?idx=${vo.idx}&pageSize=${pageSize}&pag=${pag}"/>
						  <ul class="pagination justify-content-center">
						    <c:if test="${replyPag > 1}">
						      <li class="page-item"><a class="page-link text-secondary" href="${ctp_reList}&replyPag=1">첫페이지</a></li>
						    </c:if>
						    <c:if test="${curBlock > 0}">
						      <li class="page-item"><a class="page-link text-secondary" href="${ctp_reList}&replyPag=${(curBlock-1)*blockSize + 1}">이전블록</a></li>
						    </c:if>
						    <c:forEach var="i" begin="${(curBlock)*blockSize + 1}" end="${(curBlock)*blockSize + blockSize}" varStatus="st">
						      <c:if test="${i <= totPage && i == replyPag}">
						    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp_reList}&replyPag=${i}">${i}</a></li>
						    	</c:if>
						      <c:if test="${i <= totPage && i != replyPag}">
						    		<li class="page-item"><a class="page-link text-secondary" href="${ctp_reList}&replyPag=${i}">${i}</a></li>
						    	</c:if>
						    </c:forEach>
						    <c:if test="${curBlock < lastBlock}">
						      <li class="page-item"><a class="page-link text-secondary" href="${ctp_reList}&replyPag=${(curBlock+1)*blockSize + 1}">다음블록</a></li>
						    </c:if>
						    <c:if test="${replyPag < totPage}">
						      <li class="page-item"><a class="page-link text-secondary" href="${ctp_reList}&replyPag=${totPage}">마지막페이지</a></li>
						    </c:if>
						  </ul>
						</div>
					</c:if>
				</td>
			</tr>
	</table>
	<!-- 댓글 입력창 -->
	<form name="replyForm">
		<table class="table text-center">
			<tr>
				<td style="width: 85%" class="text-left">
					글내용 : 
					<textarea rows="4" name="content" id="content" placeholder="댓글을 입력해주세요." class="form-control"></textarea>
				</td>
				<td style="width: 15%">
					<br/>
					<p>작성 : ${sNickName}</p>
					<p>
						<input type="button" value="댓글달기" onclick="replyCheck()" class="btn btn-info btn-sm" />
					</p>
				</td>
			</tr>
		</table>
		<%-- <input type="hidden" name="boardIdx" value="${vo.idx}"/>
		<input type="hidden" name="hoistIp" value="${pageContext.request.remoteAddr}"/> --%>
	</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>