<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>kakaoEx1.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<script>
	function addressCheck(latitude, longitude) {
    	//alert(latitude + " / " + longitude);
    	var address = myform.address.value;
    	if(address == "") {
    		alert("선택한 지점의 장소명을 입력하세요");
    		myform.address.focus();
    		return false;
    	}
    	var query = {
    			address  : address,
    			latitude : latitude,
    			longitude:longitude
    	}
    	$.ajax({
    		type  : "post",
    		url   : "${ctp}/study/kakaomap/kakaoEx1",
    		data  : query,
    		success:function(res) {
    			if(res == "1") alert("선택한 지점이 등록되었습니다.");
    			else alert("이미 같은지점이 있습니다. 이름을 변경해서 다시 등록할수 있습니다.");
    		},
    		error : function() {
    			alert("전송오류!");
    		}
    	});
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<h2>클릭한 위치에 마커표시하기</h2>
	<hr/>
	<jsp:include page="/WEB-INF/views/study/kakaomap/kakaoMenu.jsp"/>
	<hr/>
	<div id="map" style="width:100%;height:500px;"></div>
	<p><b>마커를 표시할 지도의 위치를 클릭해 주세요</b></p>
	
	<form name="myform">
		<div id="clickPoint"></div>
	</form>
	<div>
		<input type="text" name="search" id="search" />
    <input type="button" value="검색하기" onclick="gogo()" />
	</div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d2bcf0f819fb71881355b11fbb27052e"></script>
	<script>
		var resetMarker;
		var container = document.getElementById('map');	// 지도를 표시한 div 태그 아이디
		var options = {
			center: new kakao.maps.LatLng(36.63517158030947, 127.45952996814482),	// 지도의 중심좌표
			level: 2	// 지도의 확대 레벨
		};
	
		// 지도를 표시할 div의 아이디와 지도 옵션으로 지도를 생성한다.
		var map = new kakao.maps.Map(container, options);
		
		/* // 마커가 표시될 위치입니다 
		var markerPosition  = new kakao.maps.LatLng(33.450701, 126.570667);  */

		/* // 마커를 생성합니다
		var marker = new kakao.maps.Marker({
				// 지도 중심좌표에 마커를 생성한다.
		    position: markerPosition
		}); */

		 
		// 아래 코드는 지도 위의 마커를 제거하는 코드입니다
		// marker.setMap(null);
		
		
		// 지도를 클릭한 위치에 표출할 마커입니다
		var marker = new kakao.maps.Marker({ 
	    // 지도 중심좌표에 마커를 생성합니다 
	    position: map.getCenter() 
		}); 
		
		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		
		// 지도에 클릭 이벤트를 등록합니다
		// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
	    
	    // 클릭한 위도, 경도 정보를 가져옵니다 
	    var latlng = mouseEvent.latLng; 
	    resetMarker = latlng
	    
	    // 마커 위치를 클릭한 위치로 옮깁니다
	    marker.setPosition(latlng);
	    
	    var message = '클릭한 위치의 위도는 <font color="red">' + latlng.getLat() + '</font> 이고, ';
	    message += '경도는 <font color="red">' + latlng.getLng() + '</font> 입니다. &nbsp;';
	    message += '<input type="button" value="처음위치로복귀" onclick="backFirst();"/>';
	    message += '<p>선택한 지점의 장소명 : <input type="text" name="address"/> &nbsp;</p>';
	    message += '<input type="button" value="장소저장" onclick="addressCheck('+latlng.getLat()+','+latlng.getLng()+')"/>';
	    
	    //var resultDiv = document.getElementById('clickLatlng'); 
	    //resultDiv.innerHTML = message;
	    
	    document.getElementById("clickPoint").innerHTML = message;
		});
		
		function backFirst() {
			resetMarker.La = 127.45952996814482;
			resetMarker.Ma = 36.63517158030947;
			marker.setPosition(resetMarker);
		}
		
		
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
		function gogo() {
		    let search = document.getElementById("search").value;
		    ps.keywordSearch(search, placesSearchCB); 
		}
	</script>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>