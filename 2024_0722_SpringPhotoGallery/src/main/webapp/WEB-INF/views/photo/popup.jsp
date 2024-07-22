<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style type="text/css">
	.mycommon{
		/* text-align: center; */
		width: 300px;
   		margin: auto;
		border: 1px solid gray;
		margin-bottom: 10px;
		padding: 5px;
		
		box-shadow: 1px 1px 1px black;
	}
	
	#pop_image{
		width: 300px;
		height: 300px;
		border: 2px solid gray;
		outline: 2px solid black;
	}
	#pop_content{
		min-height: 80px;	/* 최소 높이 */	
	}

</style>

<script type="text/javascript">
	
	//g_p_filename; // hoisting -> 변수 선언하기 전에 사용 가능(자바에서는 불가능하지만 자바스크립트에서는 가능하다)
	
	//전역변수
	var g_p_filename;
	var g_p_idx;
	
	// 파일 다운로드
	function download(){
		// 현재경로 photo > popup.jsp
		/* alert("홍길동/" + encodeURIComponent("홍길동", "utf-8")); */
		location.href="../FileDownload.do?dir=/resources/images/&filename=" 
						+ encodeURIComponent(g_p_filename, "utf-8");
	}
	// 삭제
	function delete_photo(){
		if(confirm("정말 삭제 하시겠습니까?")==false) return;
		location.href="delete.do?page=${ empty  param.page ? 1 : param.page }&p_idx=" + g_p_idx;	// PhotoDeleteAction 만들기
		
	}
	// 수정
	function modify_photo(){
		location.href="modify_form.do?page=${ empty  param.page ? 1 : param.page }&p_idx=" + g_p_idx;	// PhotoModifyFormAction 만들기
	}

</script>


</head>
<body>

<!-- 이미지 박스 클릭 시 나오는 팝업창  -->

<!-- Modal -->
<div class="modal fade" id="photoModal" role="dialog">
    <div class="modal-dialog" style="width:360px;">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">×</button>
          
          <!-- 제목 -->
          <h4 class="modal-title" id="pop_mem_name"> 올린이: 홍길동</h4>		
        </div>
        
        <!-- 본문 -->
        <div class="modal-body">
	        <div style="text-align: center; height: 310px;">
	        	<img id="pop_image">
	        </div>	
        	<div class="mycommon" id="pop_title">사진 제목</div>
        	<div class="mycommon" id="pop_content">사진 내용</div>
        	<div class="mycommon" id="pop_regdate">업로드 날짜</div>
        	
        	<div id="pop_job" style="test-align: center;">
        		
        		<input style="display: none;" class="btn btn-info" type="button" id="btn_pop_update" 
        			   value="수정" onclick="modify_photo();"> 
        		<input style="display: none;" class="btn btn-danger" type="button" id="btn_pop_delete" 
        			   value="삭제" onclick="delete_photo();"> 
        		<input style="display: none;" class="btn btn-success" type="button" id="btn_pop_download"
        			   value="다운" onclick="download();">
        		
        		<button class="btn btn-primary" type="button" data-dismiss="modal">닫기</button>
        	</div>
        	
        </div>
        <!-- 닫기버튼 하단에도 배치하는 것
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div> -->
      </div>
      
    </div>
</div>
</body>
</html>