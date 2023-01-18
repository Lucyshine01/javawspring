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
        <select name="address" id="address">
          <option value="">지역선택</option>
          <c:forEach var="vo" items="${vos}">
            <option value="${vo.address}">${vo.address}</option>
          </c:forEach>
        </select>
        <input type="button" value="지역검색" onclick="addressSearch()"/>
      </div>
    </form>
  </div>
  <hr/>
  <div id="map" style="width:100%;height:500px;"></div>
  <hr/>
  <jsp:include page="kakaoMenu.jsp"/>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=158c673636c9a17a27b67c95f2c6be5c"></script>
  <script>
    // 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
	  var infowindow = new kakao.maps.InfoWindow({zIndex:1});
	
	  var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	      mapOption = {
	          center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
	          level: 3 // 지도의 확대 레벨
	      };  
	
	  // 지도를 생성합니다    
	  var map = new kakao.maps.Map(mapContainer, mapOption); 
	
	  // 장소 검색 객체를 생성합니다
	  var ps = new kakao.maps.services.Places(); 
	
	  // 키워드로 장소를 검색합니다
	  ps.keywordSearch('이태원 맛집', placesSearchCB); 
	
	  // 키워드 검색 완료 시 호출되는 콜백함수 입니다
	  function placesSearchCB (data, status, pagination) {
	      if (status === kakao.maps.services.Status.OK) {
	
	          // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	          // LatLngBounds 객체에 좌표를 추가합니다
	          var bounds = new kakao.maps.LatLngBounds();
	
	          for (var i=0; i<data.length; i++) {
	              displayMarker(data[i]);    
	              bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
	          }       
	
	          // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	          map.setBounds(bounds);
	      } 
	  }
	
	  // 지도에 마커를 표시하는 함수입니다
	  function displayMarker(place) {
	      
	      // 마커를 생성하고 지도에 표시합니다
	      var marker = new kakao.maps.Marker({
	          map: map,
	          position: new kakao.maps.LatLng(place.y, place.x) 
	      });
	
	      // 마커에 클릭이벤트를 등록합니다
	      kakao.maps.event.addListener(marker, 'click', function() {
	          // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
	          infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
	          infowindow.open(map, marker);
	      });
	  }
  </script>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>