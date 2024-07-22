<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- BootStrap 3.x-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style type="text/css">

#box{
	width: 800px;
	margin: auto;	/*  box 수평 정렬  */
	margin-top: 30px;
}

#title{
	text-align: center;
	font-size: 32px;
	font-weight: bold;
	color: #87cefa;
	text-shadow: 2px 2px 3px black;
	margin-bottom: 50px;
}

#photo-box{
	height: 470px;
	border: 4px solid #87cefa;
	margin-top: 15px;
	/* 상하스크롤 : y빼면 상하,좌우 스크롤 두 개 생김 */
	/* overflow-y: scroll; */ 	/* 이 박스를 벗어나는 자식 박스가 있다면 스크롤로 보겠다 hidden : 넘치는 애는 자르겠다. */
}

.photo{
	width: 140px;
	height: 180px;
	border: 3px solid #ffe4e1 ;
	margin: 23px;
	padding: 8px;
	float: left;	/* div는 블럭요소이므로 한칸 다차지 하지만 float하면 옆으로 붙다가 자리없으면 줄바꿈 하는 형태로 배치할 수 있다. */
	box-shadow: 2px 2px 2px gray;
}
.photo:hover{
	border-color: #f08080
}
.photo img{
	width: 120px;
	height: 120px;
	border: 1px solid gray;
	outline: 1px solid black;
}

.title{
	width: 120px;
	border: 1px solid gray;
	outline: 1px solid black;
	padding: 5px;
/* 	text-align: center; */
	margin-top: 5px;
	
	  /* ellipsis */
     overflow: hidden;
	 white-space: nowrap;
	 text-overflow: ellipsis;
	 word-break: break-all;
}
</style>

<!-- 메인 화면창 -->
<script type="text/javascript">

	/* 사진 올리기 함수 만들기 */
	function photo_insert(){
		
		// 로그인 체크
		//  로그인 안 했다면
		if("${ empty user }"=="true"){
			if(confirm("사진등록은 로그인 후 가능한 서비스입니다 \n 로그인 하시겠습니까?")==false) return; // 아니오 선택 시
			// 로그인 폼으로 이동
			location.href="../member/login_form.do";
			return;
		}
		
		// 로그인 된 경우 사진 등록 폼으로 이동 시키기
		location.href="insert_form.do";		//PhotoInsertAction 만들기(사진등록화면창). 자기 경로 안에서 움직이는 것이므로 앞에 /photo/ 안 붙여도 됨
	
	}// end: photo_insert
	
	// 이미지 박스 선택 시 설명 팝업창 뜨기
	
	function showPhoto(p_idx){
		/* alert(p_idx + "번 그림정보 조회")   popup.jsp 만들기(설명 팝업창-이미지+설명이 들어간) */
		$("#photoModal").modal({backdrop: "static"});
		
		// p_idx에 대한 사진 정보 가져오기 -> Ajax 이용해서 json 형식으로 가져옴
		$.ajax({
			url		:	"photo_one.do",		// 누구 요청할거니 PhotoOneAction 사진 하나 가져올 액션
			data	:	{"p_idx": p_idx},	// parameter => photo_one.do?p_idx5
			dataType:	"json",
			success	:	function(res_data){
				//res_data = {"p_idx":5, "p_title":"제목", "p_content":"내용", "p_filename":"a.jpg"...}
				console.log(res_data);
				
				// 다운로드 받을 파일명을 셋팅함
				g_p_filename = res_data.p_filename;
				g_p_idx		 = res_data.p_idx;	/* res_data.p_idx : 서버에서 받아 온 p_idx */
				
				
				// 이미지 넣기
				$("#pop_mem_name").html("올린이 : " + res_data.mem_name );
				$("#pop_image").prop("src","../resources/images/"+res_data.p_filename);
				
				$("#pop_title").html(res_data.p_title);
				$("#pop_content").html(res_data.p_content);
				$("#pop_regdate").html(res_data.p_regdate);
				
				// 버튼 보여지기 유/무 (수정 삭제 다운 버튼) -> 로그인 해야 볼 수 있게
				// 1. 버튼 세 개 일단 다 감추기 
				$("#btn_pop_download").hide(); // 다운버튼
				$("#btn_pop_update").hide();   // 수정버튼
				$("#btn_pop_delete").hide();   // 삭제버튼
				
				// 2. 로그인 되어 있다면 다운 버튼 보여주기
				if("${not empty user}" == "true"){		// user가 비어있지 않다 = 로그인 되어 있다
				//	$("input[value='다운']").show();   -> popup.jsp의 input 태그에 value가 '다운'인것 셀렉 -> 가능하나 위험(같은 value 있을 경우..) 
					$("#btn_pop_download").show(); 	// -> 안전하게 id를 설정하고 그 id 이름을 셀렉하자
				}
				
				// 3. 로그인한 유저와 사진 올린 유저가 같으면 수정,삭제버튼 보여주기
				// 지금 로그인 되어 있는 유저 == 현재 클릭한 사진의 소유주(사진 올린 사람)
				if("${user.mem_idx}" == res_data.mem_idx){ 
					$("#btn_pop_update").show(); 
					$("#btn_pop_delete").show(); 
				}
			},
			errer	:	function(err){
				alert(err.responseText);
			}
		});
		
		
	}
</script>

</head>
<body>
 <!-- popup:Modal -->
  <%@include file="popup.jsp" %> 
  
	<div id="box">
		<h1 id="title">:::::Photo Gallery:::::</h1>
		<div class="row">
			<div class="col-sm-6">
				<input class="btn btn-primary" type="button" value="사진올리기" 
					   onclick="photo_insert();">
			</div>
			<div class="col-sm-6" style="text-align:right">
			
				<!-- 로그인 안 된 경우 -->
				<c:if test="${ empty user }">
					<input class="btn btn-info" type="button" value="회원가입" 
					       onclick="location.href='../member/insert_form.do'">
					<input class="btn btn-primary" type="button" value="로그인" 
					       onclick="location.href='../member/login_form.do'">		<!-- member 안에 있는 login_form.jsp 불러내야함 -->
				</c:if>
				
				<!-- 로그인 된 경우 -->
				<c:if test="${ not empty user }">
					<b>${ user.mem_name }</b>님 환영합니다!
					<input class="btn btn-primary" type="button" value="로그아웃" 
					       onclick="location.href='../member/logout.do'">		
				</c:if>
				
			</div>
		</div>
		
			<div id="photo-box">
				<%-- <c:forEach begin="1" end="30"> --%>
				<c:forEach var="vo" items="${list}">
						<!-- 사진 박스 하나 (이미지+설명)       vo의 사진인덱스번호 얻어온 것 => 각 사진 박스에 맞는 사진과 정보 담아야 하므로 인덱스 번호로 가져온듯  -->
						<div class="photo" onclick="showPhoto('${vo.p_idx}');"> 
							<img src="../resources/images/${vo.p_filename}">
							<div class="title">(${vo.no}) ${vo.p_title}</div>
						</div>
				</c:forEach>
			</div>
				<!-- Page Menu -->
				<div style="text-align: center; margin-top: 10px;">
					${ pageMenu }
					<!-- <br>
					<ul class='pagination'>
					  <li><a href='list.do?page=1'>◀</a></li>
					  <li><a href="list.do?page=1">1</a></li>
					  <li><a href="?page=2">2</a></li>
					  <li><a href="?page=3">3</a></li>
					  <li><a href="?page=4">4</a></li>
					  <li><a href="?page=5">5</a></li>
					  <li><a href="list.do?page=1">▶</a></li>
					</ul> -->
				</div>
		
	</div>
</body>
</html>