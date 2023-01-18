<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>kakaomap.jsp(기본지도)</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<h2>KakaoMap API(기본지도)</h2>
	<hr/>
	<jsp:include page="/WEB-INF/views/study/kakaomap/kakaoMenu.jsp"/>
	<hr/>
	<div id="map" style="width:100%;height:500px;"></div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d2bcf0f819fb71881355b11fbb27052e"></script>
	<script>
		var container = document.getElementById('map');	// 지도를 표시한 div 태그 아이디
		var options = {
			center: new kakao.maps.LatLng(36.63517158030947, 127.45952996814482),	// 지도의 중심좌표
			level: 3	// 지도의 확대 레벨
		};

		var map = new kakao.maps.Map(container, options);
	</script>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>