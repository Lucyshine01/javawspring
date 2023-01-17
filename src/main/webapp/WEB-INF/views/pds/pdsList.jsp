<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>pdsList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  	'use strict';
  	let pag = ${pag};
  	let totPage = ${totPage};
  	let search = "${search}";
  	let part = "${part}";
  	/* if(pag > totPage || pag <= 0){
  		if(search != null){
				location.href = "${ctp}/pdsSearch.pds?part="+part+"&search=${search}&searchString=${searchString}&pag=${totPage}";
			}
			else {
				location.href = "${ctp}/pdsList.pds?part="+part+"&pag=${totPage}";
			}
  	} */
  	function partCheck() {
			let part2 = partForm.part.value;
			console.log("1 : "+search);
  		if(search != null){
				location.href = "${ctp}/pdsSearch.pds?part="+part2+"&search=${search}&searchString=${searchString}&pag=${pag}";
  		}
  		else {
				location.href = "${ctp}/pdsList.pds?part="+part2;
  		}
		}
  	function modalView(title,nickName,mid,part,fiName,fiSName,fiSize,downNum,fiDate) {
			let imgs = fiSName.split("/");
			
			//부트스트랩 모달에 내용 넣을때 사용법(부트스트랩 공식 가이드)
			$("#myModal").on("show.bs.modal", function(e) {
				$(".modal-header #title").html(title);
				$(".modal-header #part").html(part);
				$(".modal-body #nickName").html(nickName);
				$(".modal-body #mid").html(mid);
				$(".modal-body #fiName").html(fiName);
				$(".modal-body #fiSName").html(fiSName);
				$(".modal-body #fiSize").html(fiSize);
				$(".modal-body #fiDate").html(fiDate);
				$(".modal-body #downNum").html(downNum);
				$(".modal-body #imgBox").html("");
				for (let i = 0; i < imgs.length; i++) {
					let exp = imgs[i].substring(imgs[i].lastIndexOf("."));
					exp = exp.toUpperCase();
					if(exp == ".PNG" || exp == ".JPG" || exp == ".GIF"){
						$(".modal-body #imgBox").append("<img src='${ctp}/data/pds/"+imgs[i]+"' width='200px'/>");
					}
					else if(exp == ".MP4"){
						$(".modal-body #imgBox").append('<video controls autoplay muted width="450"><source src="${ctp}/data/pds/'+imgs[i]+'" type="video/mp4"></video>');
					}
					else if(exp == ".MP3"){
						$(".modal-body #imgBox").append('<audio controls><source src="${ctp}/data/pds/'+imgs[i]+'" type="audio/mpeg"></audio>');
					}
				}
				//$(".modal-body #imgSrc").attr("src",'${ctp}/data/pds/'+imgs[0]);
			});
		}
  	
  	// 선택한 항목의 자료 삭제하기...
  	//(prompt창을 통해 비밀번호를 입력받음)
  	//prompt창을 통해 비밀번호를 받으면 보안에 문제가 생김으로 하지않음
  	
  	
  	
  	// modal창을 통해서 비밀번호 확인후 파일을 삭제처리
  	function pdsDelCheckModal(idx,fiSName) {
  		
  		$("#myPwdModal").on("show.bs.modal", function(e) {
  			$(".modal-body #idx").val(idx);
  			$(".modal-body #fiSName").val(fiSName);
  		});
		}
  	
 		// 선택한 항목의 자료 삭제하기...(aJax 처리)
  	function pdsDelCheckModalOk() {
		let idx = pwdModalForm.idx.value;
		let pwd = pwdModalForm.pwd.value;
		let query = {
				idx : idx,
				pwd : pwd
		}
		
		$.ajax({
			type : "post",
			url : "${ctp}/pds/pdsDelete",
			data : query,
			success: function(res) {
				if(res == "1"){
					location.reload();
				}
				else if (res == "2"){
					$("#pwdModalFormInfo").html("비밀번호가 일치하지 않습니다.");
				}
				else {
					$("#pwdModalFormInfo").html("서버 오류로 인하여 삭제하지못하였습니다.");
				}
			},
			error: function() {
				alert("전송 오류");
			}
		});
	}
  	
  	// 다운로드 회수 증가
  	function downNumCheck(idx) {
			$.ajax({
				type: "post",
				url : "${ctp}/pds/pdsDownNum",
				data: {idx:idx},
				success: function() {
					location.reload();
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	// 검색기능
  	function searchCheck() {
			let searchString = $("#searchString").val();
			if(searchString.trim() == ""){
				alert("검색어를 입력해서 검색해주세요.");
				return;
			}
			searchForm.submit();
		}
  	
  </script>
  <style></style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<div>
		<a href="${ctp}/test.pds">test</a>
	</div>
	<c:if test="${empty search}">
  	<h2>자 료 실 리 스 트(${part})</h2>
  </c:if>
	<c:if test="${!empty search}">
  	<h2>자 료 실 검 색 목 록(${part})</h2>
  	${searchString}을 ${search}(으)로 검색한 결과입니다. 총 ${curScrStartNo}건입니다.
  </c:if>
  <br />
  <table class="table table-borderless">
  	<tr>
  		<td style="width: 20%">
  			<form name="partForm">
  				<select name="part" class="form-control" onchange="partCheck()">
  					<option ${pageVO.part == '전체' ? 'selected' : ''} value="전체">전체</option>
  					<option ${pageVO.part == '학습' ? 'selected' : ''} value="학습">학습</option>
  					<option ${pageVO.part == '여행' ? 'selected' : ''} value="여행">여행</option>
  					<option ${pageVO.part == '음식' ? 'selected' : ''} value="음식">음식</option>
  					<option ${pageVO.part == '기타' ? 'selected' : ''} value="기타">기타</option>
  				</select>
  			</form>
  		</td>
  		<td class="text-right">
  			<a href="${ctp}/pds/pdsInput?part=${pageVO.part}" class="btn btn-success">자료올리기</a>
  		</td>
  	</tr>
  </table>
  <table class="table table-hover text-center">
  	<tr>
  		<th>번호</th>
  		<th>자료제목</th>
  		<th>업로더</th>
  		<th>업로드일</th>
  		<th>분류</th>
  		<th>파일명(크기)</th>
  		<th>다운로드수</th>
  		<th>비고</th>
  	</tr>
  	<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}" />
  	<c:forEach var="vo" items="${vos}" varStatus="st">
  		<tr>
  			<td>${curScrStartNo}</td>
  			<td>
  				<a href="${ctp}/pds/pdsContent?idx=${vo.idx}&pag=${pag}&part=${part}">${vo.title}</a>
  				<c:if test="${vo.day_diff < 1}"><img src="${ctp}/images/new.gif"/></c:if>
  			</td>
  			<td>${vo.nickName}</td>
  			<td>
  				<c:if test="${vo.hour_diff < 1}">1시간 내</c:if>
  				<c:if test="${1 <= vo.hour_diff && vo.hour_diff < 24}">${vo.hour_diff}시간 전</c:if>
  				<c:if test="${24 <= vo.hour_diff && vo.day_diff == 1}">하루 전</c:if>
  				<c:if test="${1 < vo.day_diff && vo.day_diff < 30}">${vo.day_diff}일 전</c:if>
  				<c:if test="${30 <= vo.day_diff}">${fn:substring(vo.fiDate,0,10)}</c:if>
  			</td>
  			<td>${vo.part}</td>
  			<td>
  				<c:set var="fiNames" value="${fn:split(vo.fiName,'/')}" />
  				<c:set var="fiSNames" value="${fn:split(vo.fiSName,'/')}" />
  				<c:forEach begin="0" end="${fn:length(fiNames)}" varStatus="st">
  					<a href="${ctp}/data/pds/${fiSNames[st.index]}" onclick="downNumCheck(${vo.idx})" download="${fiNames[st.index]}"  >${fiNames[st.index]}<br/></a>
  				</c:forEach>
  				<c:if test="${1000 <= vo.fiSize/1024}">
	  				(<fmt:formatNumber value="${vo.fiSize/(1024*1024)}" pattern="#.##" />MB)
	  				<c:set var="fiSize_" value="${vo.fiSize/(1024*1024)}"/>
  				</c:if>
  				<c:if test="${1000 > vo.fiSize/1024}">
	  				(<fmt:formatNumber value="${vo.fiSize/1024}" pattern="#.##" />KB)
  				</c:if>
				</td>
  			<td>${vo.downNum}</td>
  			<td>
	  			<a href="#" onclick="modalView('${vo.title}','${vo.nickName}','${vo.mid}','${vo.part}','${vo.fiName}','${vo.fiSName}','${fiSize_}','${vo.downNum}','${vo.fiDate}')" class="badge badge-primary badgepill" data-toggle="modal" data-target="#myModal">모달창</a>
	  			<br/>
	  			<a href="${ctp}/pds/pdsTotalDown?idx=${vo.idx}" class="badge badge-success badgepill">전체다운</a>
	  			<br/>
	  			<a href="#" onclick="pdsDelCheckModal('${vo.idx}')" data-toggle="modal" data-target="#myPwdModal" class="badge badge-danger badgepill">삭제</a>
  			</td>
  		</tr>
  		<tr><td colspan="8" class="p-0 m-0"></td></tr>
  		<c:set var="curScrStartNo" value="${curScrStartNo-1}" />
  	</c:forEach>
  </table>
  <c:if test="${empty search}">
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		    <c:if test="${pageVO.pag > 1}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsList.pds?part=${pageVO.part}&pag=1">첫페이지</a></li>
		    </c:if>
		    <c:if test="${pageVO.curBlock > 0}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsList.pds?part=${pageVO.part}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
		    </c:if>
		    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
		      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
		    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp}/pdsList.pds?part=${pageVO.part}&pag=${i}">${i}</a></li>
		    	</c:if>
		      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
		    		<li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsList.pds?part=${pageVO.part}&pag=${i}">${i}</a></li>
		    	</c:if>
		    </c:forEach>
		    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsList.pds?part=${pageVO.part}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
		    </c:if>
		    <c:if test="${pageVO.pag < pageVO.totPage}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsList.pds?part=${pageVO.part}&pag=${pageVO.totPage}">마지막페이지</a></li>
		    </c:if>
		  </ul>
		</div>
	</c:if>
  <c:if test="${!empty search}">
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		    <c:if test="${pageVO.pag > 1}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsSearch.pds?part=${pageVO.part}&pag=1&search=${search}&searchString=${searchString}">첫페이지</a></li>
		    </c:if>
		    <c:if test="${pageVO.curBlock > 0}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsSearch.pds?part=${pageVO.part}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}&search=${search}&searchString=${searchString}">이전블록</a></li>
		    </c:if>
		    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(curBlock)*blockSize + blockSize}" varStatus="st">
		      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
		    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${ctp}/pdsSearch.pds?part=${pageVO.part}&pag=${i}&search=${search}&searchString=${searchString}">${i}</a></li>
		    	</c:if>
		      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
		    		<li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsSearch.pds?part=${pageVO.part}&pag=${i}&search=${search}&searchString=${searchString}">${i}</a></li>
		    	</c:if>
		    </c:forEach>
		    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsSearch.pds?part=${pageVO.part}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}&search=${search}&searchString=${searchString}">다음블록</a></li>
		    </c:if>
		    <c:if test="${pageVO.pag < pageVO.totPage}">
		      <li class="page-item"><a class="page-link text-secondary" href="${ctp}/pdsSearch.pds?part=${pageVO.part}&pag=${pageVO.totPage}&search=${search}&searchString=${searchString}">마지막페이지</a></li>
		    </c:if>
		  </ul>
		</div>
	</c:if>
	<br/>
	<!-- 검색기 처리 시작 -->
	<div class="container">
		<form name="searchForm" method="post" action="${ctp}/pdsSearch.pds?part=${part}">
			<b>검색 : </b>
			<select name="search">
				<option ${search=='all' ? 'selected' : '' } value="all">전체</option>
				<option ${search=='title' ? 'selected' : '' } value="title">제목</option>
				<option ${search=='content' ? 'selected' : '' } value="content">내용</option>
				<option ${search=='nickName' ? 'selected' : '' } value="nickName">닉네임</option>
			</select>
			<input type="text" name="searchString" id="searchString" value="${searchString}"/>
			<input type="button" value="검색" onclick="searchCheck()" class="btn btn-secondary btn-sm" />
			<input type="hidden" name="pag" value="${pag}" />
		</form>
	</div>
	<!-- 검색기 처리 끝 -->
	
</div>
		
<!-- The Modal(폼태그로 비밀번호 처리하기 위한 모달창) -->
  <div class="modal fade" id="myPwdModal">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">비밀번호 입력</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
        	<form name="pwdModalForm" class="was-validated" >
        		<div class="mb-2">비밀번호 입력 <span id="pwdModalFormInfo" class="ml-3" style="color: red; font-weight: 300; font-size: 0.8em"></span></div>
        		<input type="password" name="pwd" id="pwd" placeholder="비밀번호 입력" class="form-control mb-3" required/>
        		<input type="button" value="비밀번호확인후전송" class="btn btn-success form-control" onclick="pdsDelCheckModalOk()"/>
        		<input type="hidden" name="idx" id="idx" />
        	</form>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>
 <!-- The Modal(모달창 클릭시 자료실의 내용을 모달창에 출력한다.) -->
  <div class="modal fade" id="myModal">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title"><span id="title"></span>(분류:<span id="part"></span>)</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
        	- 업로더 : <span id="nickName"></span>
        	<hr />
        	- 아이디 : <span id="mid"></span><br/>
        	- 파일명 : <span id="fiName"></span><br/>
        	- 파일크기 : <span id="fiSize"></span><br/>
        	- 다운횟수 : <span id="downNum"></span><br/>
        	<hr />
        	- 저장파일명 : <span id="fiSName"></span><br/>
        	<div id="imgBox">
        		
        	</div>
        	<img id="imgSrc" width="350px"/><br/>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>