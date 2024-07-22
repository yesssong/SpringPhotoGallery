<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		margin: auto;
		margin-top: 100px;
	}
	#th{
		vertical-align: middle; !important;
		text-align: right;
		font-size: 16px;
	}
	#id_msg{
		display: inline-block;
		width: 300px;
		height:20px;
		margin-left: 10px; 
	}
</style>

<!-- 주소 검색 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

	function check_id(){
		// 회원 가입 버튼은 비활성화 (id체크 후 활성화 할 것임)
		// <input id="btn_register" type="button"....disabled="disabled">
		$("#btn_register").prop("disabled", true);
		
		// 			 document.getElementbyId(mem_id).value -> 자바스크립트 식으로 작성했을 때
		let mem_id = $("#mem_id").val();
		
		if(mem_id.length==0){
			$("#id_msg").html("");
			return;
		}
		
		if(mem_id.length<3){
			$("#id_msg").html("id는 3자리 이상 입력하세요").css("color","red");
			return;
		}
		// 서버에 현재 입력된 id를 체크 요청 jQuery Ajax 이용
		$.ajax({
			
			url		:	"check_id.do",		// id 체크하는 서블릿 만들어서 체크해달라고 요청하기(서버한테) -> MemberCheckIdAction
			data	:	{"mem_id":mem_id},	// parameter -> check_id.do?mem_id=one   서버에 보낼 데이터(체크하려면 값 보내줘야 하니까) -> 지금 id 체크 중이므로 id 정보를 보내야함
			dataType:	"json",				// 데이터를 json타입으로 보낼래
			success	:	function(res_data){
					// res_data = {"result":true} or {"result":false}
					if(res_data.result){
						$("#id_msg").html("사용 가능한 아이디입니다").css("color","blue");
						$("#btn_register").prop("disabled", false);
					}else{
						$("#id_msg").html("이미 사용 중인 아이디입니다").css("color","red");
					}
			},
			error	:	function(err){
					alert(err.responseText)	// 에러 바로 확인하기 위해
			}
		});
	} // end: check_id
	
	function find_addr(){
		
		var themeObj = {
				   bgColor: "#B51D1D" //바탕 배경색
		   };
	
		new daum.Postcode({
			 theme: themeObj,
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
	            // 예제를 참고하여 다양한 활용법을 확인해 보세요.
	            $("#mem_zipcode").val(data.zonecode);		// 우편번호 넣기
	            $("#mem_addr").val(data.address);				// 주소 넣기
	        }
	    }).open();
		
	}// end: find_addr
	
	// 입력했는지 확인
	function send(f){
		
		let mem_name 	= f.mem_name.value.trim();
		let mem_pwd	 	= f.mem_pwd.value.trim();
		let mem_zipcode = f.mem_zipcode.value.trim();
		let mem_addr 	= f.mem_addr.value.trim();
		
		if(mem_name==''){
			alert("이름을 입력하세요");
			f.mem_name.value='';
			f.mem_name.focus();
			return;
		} 
		
		if(mem_pwd==''){
			alert("비밀번호를 입력하세요");
			f.mem_pwd.value='';
			f.mem_pwd.focus();
			return;
		} 
		
		if(mem_zipcode==''){
			alert("우편번호를 입력하세요");
			f.mem_zipcode.value='';
			f.mem_zipcode.focus();
			return;
		} 
		
		if(mem_addr==''){
			alert("주소를 입력하세요");
			f.mem_addr.value='';
			f.mem_addr.focus();
			return;
		} 
		f.action = "insert.do";	// servlet 만들어서 보내주기 MemberInsertAction 
		f.submit();		// 전송
	}// end: send
	
</script>

</head>
<body>

<form class="form-inline">
	<div id="box">
		<div class="panel panel-success">
			<div class="panel-heading">회원가입</div>
			<div class="panel-body">
				<table class="table">
					<tr>
						<th>이름</th> <!-- 부드러운 네모모양..  -->
						<td><input style="width:50%" class="form-control" name="mem_name"></td>
					</tr>
					
					<tr>
						<th>아이디</th>												
						<td>
							<input style="width:50%" class="form-control" name="mem_id" id="mem_id" onkeyup="check_id();">
							<span id="id_msg"></span>
						</td>
					</tr>
					
					<tr>
						<th>비밀번호</th>
						<td><input style="width:50%" class="form-control" type="password" name="mem_pwd"></td>
					</tr>
					
					<tr>
						<th>우편번호</th>
						<td>
							<input style="width:50%" class="form-control" name="mem_zipcode" id="mem_zipcode">
							<input class="btn btn-info" type="button" value="주소검색" onclick="find_addr();">
						</td>
					</tr>
					
					<tr>
						<th>주소</th>
						<td><input style="width:100%" class="form-control" name="mem_addr" id="mem_addr"></td>
					</tr>
					
					<tr>
						<td colspan="2" align="center">
							<input class="btn btn-success" type="button" value="메인화면"
									onclick="location.href='../photo/list.do'">
							<input id="btn_register" class="btn btn-primary" type="button" value="가입하기" disabled="disabled"
								onclick="send(this.form);">
						</td>
					</tr>
				</table>
			
			</div>
		</div>
	</div>
</form>

</body>
</html>