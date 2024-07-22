<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap 3 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<!-- SweetAlert2사용설정  -->
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style type="text/css">
  #box{
      width: 600px;
      margin: auto;
      margin-top: 50px;  
  }

  textarea {
	  width: 100%;
	  resize: none;
  }
  
  input[type='button']{
      width: 100px;
  }
  
  img{
      width: 200px;
  }

</style>


<script type="text/javascript">
   
   function send(f){
	   
	   //입력값 체크....
	   
	   var p_title = f.p_title.value.trim();
	   var p_content = f.p_content.value.trim();
	   
	   if(p_title==''){
		   alert('제목을 입력하세요');
		   f.p_title.value='';
		   f.p_title.focus();
		   return;
	   }
	   
	   
	   if(p_content==''){
		   alert('내용을 입력하세요');
		   f.p_content.value='';
		   f.p_content.focus();
		   return;
	   }
	   
	   
	   f.action = "modify.do"; //PhotoModifyAction
	   f.submit();
	   
   }
 
   /* Ajax 이용해 이미지 수정 과정  */
   function ajaxFileUpload() {
       // 업로드 버튼이 클릭되면 파일 찾기 창을 띄운다.
       $("#ajaxFile").click();		// id가 ajaxFile인 애를 클릭해라 
   }

   function ajaxFileChange() {
       // 파일이 선택되면 업로드를 진행한다.
       photo_upload();
   }


   
   function photo_upload() {

	   //파일선택->취소시    파일의 첫번쩨  없으면 함수 끝내라(취소하면 동작 실행하면 안되니까)
	   if( $("#ajaxFile")[0].files[0]==undefined)return;
	   
	   	   
	   var form = $("ajaxForm")[0];		// 폼에 대한 정보 얻어오기
       var formData = new FormData(form);
       formData.append("p_idx", '${ vo.p_idx }');		//p_idx=5 이런식으로 넘어온것?
       formData.append("photo", $("#ajaxFile")[0].files[0]);//photo라는 이름으로 parameter 선택?

       $.ajax({
             url : "photo_upload.do", //PhotoUploadAction 만들기 -> 이미지 수정하기 위해 만드는 servlet
             type : "POST",
             data : formData,
             processData : false,
             contentType : false,
             dataType : 'json',
             success:function(res_data) {
            	 //res_data = {"p_filename":"aaa.jpb"}
                 
            	 //location.href=''; //자신의 페이지를 리로드(refresh)
            	 
            	 $("#my_img").attr("src","../images/" + res_data.p_filename);
            	 // $("#my_img").prop("src","../images/" + res_data.p_filename); <- 이거 써도 됨
            	 
             },
             error : function(err){
            	 alert(err.responseText);
             }
       });

   }
</script>



</head>
<body>

<!--파일업로드용 폼 -> 이게 못생겨서 기능은 얘가 하되 숨겨놓고 예쁜 버튼을 앞에 내세운 것이다-> 예쁜버튼= -->
<form enctype="multipart/form-data" id="ajaxForm" method="post">
    <input id="ajaxFile" type="file"  style="display:none;"  onChange="ajaxFileChange();" >
</form>

  
  
  
<form>

  <input type="hidden"  name="p_idx"  value="${ vo.p_idx }"> 

  <div id="box">
        <div class="panel panel-primary">
	      <div class="panel-heading"><h4>수정화면</h4></div>
	      <div class="panel-body">
	          <table class="table  table-striped">
	               <tr>
	                   <td colspan="2" align="center">
	                       <img src="../images/${ vo.p_filename }" id="my_img">
	                       <br>															<!-- 클릭하면 이 함수 호출 -->
	                       <input  class="btn  btn-info" type="button"  value="이미지편집"  onclick="ajaxFileUpload();">
	                       <!-- 과정 설명: 이미지편집 클릭-> ajaxFileUpload()호출->  $("#ajaxFile").click()에 의해 id가 ajaxFile인 애가 클릭됨->ajaxFileChange()에 의해  photo_upload 호출, 그 안의 내용 실행됨-->
	                   </td>
	               </tr>
	          
	               <tr>
	                  <th>제목</th>
	                  <td><input name="p_title"  value="${ vo.p_title }"></td>
	               </tr>
	               
	               <tr>
	                  <th>내용</th>
	                  <td>
	                      <textarea  name="p_content"  rows="5" cols="">${ vo.p_content }</textarea>
	                  </td>
	               </tr>
	               
	               <tr>
	                   <td colspan="2" align="center">
	                       <input class="btn  btn-primary" type="button"  value="수정하기" 
	                              onclick="send(this.form);">
	                       <input class="btn  btn-success" type="button"  value="메인으로" 
	                              onclick="location.href='list.do'">
	                   </td>
	               </tr>
	               
	          </table>
	      </div>
	    </div>
  </div>
</form>


</body>
</html>