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
		width: 500px;
		margin: auto;
		margin-top: 200px;
	   }
	   
	input[type='button']{
		width: 100px;
	}

</style>

<script type="text/javascript">

	function send(f){
		
		let mem_id  = f.mem_id.value.trim();
		let mem_pwd = f.mem_pwd.value.trim();
		
		if(mem_id==''){
			alert("아이디를 입력하세요");
			f.mem_id.value="";
			f.mem_id.focus();
			return;
		}
		
		if(mem_pwd==''){
			alert("비밀번호를 입력하세요");
			f.mem_pwd.value="";
			f.mem_pwd.focus();
			return;
		}
		
		f.action="login.do";	// 누구한테 보낼거냐 -> MemberLoginAction 만들어야 됨 
		f.submit();
		
	}// end: send()
	
</script>

<script type="text/javascript">

	//  화면이 배치가 완료되면 호출 
	// 1) js방식
	// window.onload = function(){};
	// 2) jQuery 방식
	$(document).ready(function(){
		
		setTimeout(showMessage,100);	// 0.1초 후에 메시지 띄워라
		
	});
	
	// id,pwd 잘못 입력 시 띄울 메세지 창
	function showMessage(){
		if("${ param.reason == 'fail_id'}"=="true"){		// el 방식 작성 -> 지금 여러 방법 혼용해서 쓰는 중이므로 el 작성 시 "" 요걸로 감싼 후 작성
			alert("아이디가 틀립니다");
		}
		
		if("${ param.reason == 'fail_pwd'}"=="true"){		// el 방식 작성 -> 지금 여러 방법 혼용해서 쓰는 중이므로 el 작성 시 "" 요걸로 감싼 후 작성
			alert("비밀번호가 틀립니다");
		}
		///member/login_form.do?reason=session_timeout
		if("${ param.reason == 'session_timeout'}"=="true"){		// PhotoInsertAction에 대한 내용 추가(세션 만료 안내)
			alert("로그아웃 되었습니다");
		}
		
	}


</script>

</head>

<body>
<form>
	<div id="box">
		<div class="panel panel-success">
      <div class="panel-heading"><h5>로그인</h5></div>
      <div class="panel-body">
      	<table class="table">
      	<tr>
      		<th>아이디</th>										<!-- url에 있는 파라미터 값 읽어서 넣어주는 것  -->
      		<td><input class="form-control" name="mem_id" value="${param.mem_id}"></td>
      	</tr>
      	
      	<tr>
      		<th>비밀번호</th>
      		<td><input class="form-control" type="password" name="mem_pwd"></td>
      	</tr>
      	
      	<tr>
      		<td colspan="2" align="center">
      			<input class="btn btn-success" type="button" value="메인화면" onclick="location.href='../photo/list.do'"> <!-- 클릭하면 메인화면으로 돌아가겠다 -->
      			<input class="btn btn-primary" type="button" value="로그인" onclick="send(this.form);">
      		
      		</td>
      	</tr>
	
      	</table>
      
      </div>
	</div>
	
	
	</div>
</form>
</body>
</html>