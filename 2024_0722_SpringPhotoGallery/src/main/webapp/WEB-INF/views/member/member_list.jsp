<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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
		width: 1300px;
		margin: auto;
		margin-top: 50px;
	}
	#title{
		text-align: center;
		font-weight: bold;
		font-size: 35px;
		color: green;
		text-shadow: 1px 1px 1px black;
	}
	#empty_msg{
		text-align: center;
		font-size: 30px;
		color: red;
		margin-top: 150px;
	}
	th{
		background: gray;
		color: black;
	}
	td{
		vertical-align: middle !important;
	}

</style>

<script type="text/javascript">

	// del에 삭제할 idx 넘기기 
	function del(mem_idx){
		
		// console.log(mem_idx,"삭제"); -> 정보 전달 되는지 확인
		
		if(confirm('정말 삭제하시겠습니까?')==false) return;
		
		// 삭제 요청
		location.href = "delete.do?mem_idx=" + mem_idx;		// MemberDeleteAction 만들기
		// 제약 사항 걸기? 만약 회원목록에서 본인을 삭제한다면 로그인 해제 되어야 함
		// 로그인(본인 수정/삭제 가능) -> 삭제 -> 본인 정보가 없느 ㄴ상황인데 로그인 되어 있는건 이상..-> 로그인 해제 시키기
		// 관리자는 본인 삭제 못하게 해야 함 -> 프로그램 최고 권한 관리자가 삭제 될 필요는 없으니까
		
	}

</script>

<script type="text/javascript">
	// 초기화 1
	//= $(document).ready(function(){});
	
	// 초기화 2
	$(function(){
		setTimeout(showMessage,100);
	});
	
	function showMessage(){
		if("${param.reason eq 'not_admin_delete'}" == "true"){
			alert("관리자는 삭제 할 수 없습니다.");
		}
	}

</script>



</head>
<body>
	<div id="box">
		<h1 id="title">-----회원목록-----</h1>
		
		<div style="text-align: right;">
			<!-- 로그인 안 된 경우 -->
			<c:if test="${empty sessionScope.user}">
				<input class="btn btn-primary" type="button" value="로그인" onclick="location.href='login_form.do'">		<!-- login_form.do 만들어주기 -->
			</c:if>
			<!-- 로그인 된 경우 -->
			<c:if test="${not empty sessionScope.user}">
				<b>${ sessionScope.user.mem_name }</b>님 환영합니다
				<input class="btn btn-primary" type="button" value="로그아웃" onclick="location.href='login_form.do'">		<!-- LogoutAction 만들기 -->
			</c:if>
		</div>
		
		<div style="margin-top:50px; margin-bottom:5px;">
			<input class="btn btn-primary" type="button" value="회원가입"
				   onclick="location.href='insert_form.do'">		
		</div>
		
		<table class="table">
			<tr class="info">
				<th>회원번호</th>
				<th>회원명</th>
				<th>아이디</th>
				<th>비밀번호</th>
				<th>우편번호</th>
				<th>주소</th>
				<th>아이피</th>
				<th>가입일자</th>
				<th>회원등급</th>
				<th>편집</th>
			</tr>

		<!-- 데이터 있을 경우 -->
			<c:forEach var="vo" items="${list}">
				<tr>
					<td>${ vo.mem_idx }</td>	<!-- vo의 getter 이용 -->
					<td>${ vo.mem_name }</td>
					<td>${ vo.mem_id }</td>
					<td>${ vo.mem_pwd }</td>
					<td>${ vo.mem_zipcode }</td>
					<td>${ vo.mem_addr }</td>
					<td>${ vo.mem_ip }</td>
					<td>${ fn:substring(vo.mem_regdate,0,10) }</td>
					<td>${ vo.mem_grade }</td>
					<td> <!-- 수정 삭제 버튼 권한		관리자					글 작성자 본인	  -->
						<c:if test="${(user.mem_grade eq '관리자') or (user.mem_idx eq vo.mem_idx)}">
							<input class="btn btn-success" type="button" value="수정" 
							onclick="location.href='modify_form.do?mem_idx=${vo.mem_idx}'">		<!-- MemberModifyFormAction 만들러 가면 됨 -->
							<input class="btn btn-danger" type="button" value="삭제" 
							onclick="del('${vo.mem_idx}');">
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
		
		<!-- 데이터 없는 경우 -->
		<c:if test="${ empty list }">
		<div id="empty_msg">등록된 회원 정보가 없습니다.</div>
		</c:if>
	</div>
</body>
</html>