<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>kakaoEx2.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2>DB에 저장된 지명으로 검색하기</h2>
  <hr/>
  <div>
    <form name="myform" method="post">
      <div>
        <font size="4"><b>저장된 지명으로 검색하기</b></font>
        <select name="address" id="address" onchange="changMap()">
          <option value="">지역선택</option>
          <c:forEach var="vo" items="${vos}">
            <option value="${vo.address}">${vo.address}</option>
          </c:forEach>
        </select>
        <c:forEach var="vo" items="${vos}">
        	<input type="hidden" id="${vo.address}" value="${vo.latitude}/${vo.longitude}" />
        </c:forEach>
        <input type="button" value="지역검색" onclick="addressSearch()"/>
        <input type="button" value="검색된지역을DB에서삭제" onclick="addressDelete()"/>
      </div>
    </form>
  </div>
  <hr/>
  <div id="map" style="width:100%;height:500px;"></div>
  <hr/>
  <jsp:include page="kakaoMenu.jsp"/>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=158c673636c9a17a27b67c95f2c6be5c"></script>
  <script>
	  var address = '${vo.address}';
	  var latitude = '${vo.latitude}';
	  var longitude = '${vo.longitude}';
	  //alert("address : " + address + " , 위도 : " + latitude + " , 경도 : " + longitude);
  
  	
	  var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	  mapOption = { 
	      center: new kakao.maps.LatLng(latitude, longitude), // 지도의 중심좌표
	      level: 3 // 지도의 확대 레벨
	  };
	
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
		
		//마커가 표시될 위치입니다 
		var markerPosition  = new kakao.maps.LatLng(latitude, longitude); 
		
		//마커를 생성합니다
		var marker = new kakao.maps.Marker({
		  position: markerPosition
		});
		
		//마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		
		//아래 코드는 지도 위의 마커를 제거하는 코드입니다
		//marker.setMap(null);  
		
		function addressSearch() {
			address = myform.address.value;
			if(address == '') {
				alert("검색할 지점을 선택하세요.");
				return false;
			}
			location.href = "${ctp}/study/kakao/kakaomap/kakaoEx2?address=" + address;
		}
		
		function changMap() {
			marker.setMap(null);
			var address = $("#address").val();
			var latitude = document.getElementById(address).value.split("/")[0];
		  var longitude = document.getElementById(address).value.split("/")[1];
		  
		  // 해당 좌표로 포지션지정
		  markerPosition  = new kakao.maps.LatLng(latitude, longitude);
		  
		  map.setCenter(markerPosition); // 포지션으로 지도 중앙이동
		  
		  marker = new kakao.maps.Marker({	// 포지션으로 마커 이동
			  position: markerPosition
			});
		  
		  marker.setMap(map);
		}
		
		function addressDelete() {
			var address = $("#address").val();
			$.ajax({
	    		type  : "post",
	    		url   : "${ctp}/study/kakaomap/kakaoDelete",
	    		data  : {address:address},
	    		success:function(res) {
	    			location.reload();
	    		},
	    		error : function() {
	    			alert("전송오류!");
	    		}
	    	});
		}
  </script>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>