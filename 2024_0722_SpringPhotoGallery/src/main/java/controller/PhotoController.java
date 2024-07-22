package controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import dao.MemberDao;
import dao.PhotoDao;
import vo.MemberVo;
import util.MyCommon;
import util.Paging;
import vo.PhotoVo;

@Controller
@RequestMapping("/photo/")		// 경로 매번 쓰기 귀찬ㅀ으니까 한번에 적용
public class PhotoController {
	
	@Autowired
	PhotoDao photo_dao;  // context-3-dao로부터 injection 받음

	@Autowired
	HttpServletRequest request;		// ip 구할 때 필요
	
	@Autowired
	HttpSession session;

	@Autowired
	ServletContext application;		// 절대경로 구하기 위해 필요 <- 파일 업로드 기능 시 필요한 정보
	
	
	
	
	public PhotoController() {
		// TODO Auto-generated constructor stub
		System.out.println("--- PhotoController() ---");
	}

	// /photo/list.do
	// /photo/list.do?page=2
	@RequestMapping("list.do")  // 파라미터로 page가 들어오면 nowPage로 처리하겠다
	public String list(@RequestParam(name="page",defaultValue="1")int nowPage, Model model) {
												// parameter로 들어 오는 값은 무조건 string
		
		// 한 페이지 당 몇 개씩 볼건지 처리하는 것이 필요 -> MyCommon 파일 생성 : BLOCK_LIST 상수 선언
		// 게시물 범위 계산(start/end)
		int start = (nowPage-1) * MyCommon.Photo.BLOCK_LIST + 1;		// 시작페이지 계산
		int end = start + MyCommon.Photo.BLOCK_LIST - 1;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);
		
		List<PhotoVo> list = photo_dao.selectList(map);   // Dao 메소드 추가
		
		// 전체 게시물 수
		int rowTotal = photo_dao.selectRowTotal();  // Dao에 메소드 만들기
		
		// page menu 만들기
		String pageMenu = Paging.getPaging("list.do",					// page url
											nowPage,					// 현재 페이지
											rowTotal,					// 전체 게시물 수
											MyCommon.Photo.BLOCK_LIST,	// 한 화면에 보여질 게시물 수
											MyCommon.Photo.BLOCK_PAGE); // 한 화면에 보여질 페이지 수
		model.addAttribute("list",list);
		model.addAttribute("pageMenu", pageMenu);

		return "photo/photo_list";
	}
	
	// 사진 등록폼 띄우기
	@RequestMapping("insert_form.do")
	public String insert_form() {
		return"photo/photo_insert_form";
	}
	
	// 사진 등록
	// 요청 parameter 이름과 받는 변수명이 동일하면 @RequestParam(name="")의 name속성 생략 가능 => @RequestParam 이렇게만 적어도 된다
	@RequestMapping("insert.do")
	// 파라미터 Vo로 포장해달라고 요청?
	public String insert(PhotoVo vo, @RequestParam MultipartFile photo, RedirectAttributes ra) throws IllegalStateException, IOException{
		
		// 세션 정보 구하기
		MemberVo user = (MemberVo) session.getAttribute("user");
		
		// session timeout = session이 만료가 된 상황
		if(user == null) {
			// 사용자한테 로그아웃됐다고 알려주기 => 다시 로그인 하세요 => 로그인 폼으로 보내기
			// response.sendRedirect("../member/login_form.do?reason=session_timeout");  // member_login_form.jsp로 가서 안내멘트 작성
			ra.addAttribute("reason", "session_timeout");
			
			return"redirect:../member/login_form.do";
		}
		
		// 파일 업로드 처리
		String absPath = application.getRealPath("/resources/images/");  // 파일 절대경로, 상대경로
		String p_filename = "no_file";
		if(!photo.isEmpty()) {
			
			// 업로드 된 파일 이름 얻어오기
			p_filename = photo.getOriginalFilename();
			
			File f = new File(absPath, p_filename);
			
			if(f.exists()) {	// 저장 경로에 동일한 파일이 존재하면 파일명 바꾸기
				// 원래 파일명 = 시간_원래파일명
				long tm = System.currentTimeMillis();
				p_filename = String.format("%d_%s", tm, p_filename);
				
				f = new File(absPath, p_filename);
			}
			// 임시 파일
			photo.transferTo(f);  // 예외 처리 넘기기
			
		}
		// 업로드 된 파일 이름 저장
		vo.setP_filename(p_filename);
		
		
		// ip 받기
		String p_ip = request.getRemoteAddr();
		vo.setP_ip(p_ip);
		
		// 사진 설명 내용 받기
		String p_content = vo.getP_content().replaceAll("\n", "<br>");	// 엔터처리
		vo.setP_content(p_content);
		
		// 로그인 유저 넣는다
		vo.setMem_idx(user.getMem_idx());
		vo.setMem_name(user.getMem_name());
		
		//DB insert
		int res = photo_dao.insert(vo);
		
		
		return "redirect:list.do";
		
	}
	
	// 사진 하나 띄우기 -> modal = popup
	// photo_one.do?p_idx=5 
	@RequestMapping(value="photo_one.do", produces="application/json;charset=utf-8;")  // @ResponseBody 했을 때 반환할 타입 적어주기?
	@ResponseBody		// 현재 반환 값을 응답 데이터로 이용해라 (view가 아니라)
	public String photo_one(int p_idx) {
		
		PhotoVo vo = photo_dao.selectOne(p_idx);
		
		// Vo를 json 객체로 포장하는 과정 => json 라이브러리 필요 => pom.xml에 lib 추가
		JSONObject json = new JSONObject();
		json.put("p_idx", vo.getP_idx());
		json.put("p_title", vo.getP_title());
		json.put("p_content", vo.getP_content());
		json.put("p_filename", vo.getP_filename());
		json.put("p_regdate", vo.getP_regdate());
		json.put("p_ip", vo.getP_ip());
		json.put("mem_idx", vo.getMem_idx());
		json.put("mem_name", vo.getMem_name());
		
		return json.toString();
	}
	
	// 수정폼 띄우기
	@RequestMapping("modify_form.do")
	public String modify_form(int p_idx, Model model) {
		
		PhotoVo vo = photo_dao.selectOne(p_idx);		
		
		// <br> -> "\n"
		String p_content = vo.getP_content().replaceAll("<br>", "\n");
		vo.setP_content(p_content);
		
		model.addAttribute("vo", vo);

		return"photo/photo_modify_form";
		
		
	}
	
	// 사진 수정하기 => Ajax 이용
	// /photo/photo_upload.do?p_idx=5&photo=aaa.jpg
	@RequestMapping(value="photo_upload.do", produces="application/json; charset=utf-8;")
	@ResponseBody	// redirect할 때 사용해야하는 부분?
	public String photo_upload(int p_idx, @RequestParam MultipartFile photo) throws IllegalStateException, IOException {
		
		// 파일 업로드 처리
		String absPath = application.getRealPath("/resources/images/");  // 파일 절대경로, 상대경로
		String p_filename = "no_file";
		
		if(!photo.isEmpty()) {
			
			// 업로드 된 파일 이름 얻어오기
			p_filename = photo.getOriginalFilename();
			
			File f = new File(absPath, p_filename);
			
			if(f.exists()) {	// 저장 경로에 동일한 파일이 존재하면 파일명 바꾸기
				// 원래 파일명 = 시간_원래파일명
				long tm = System.currentTimeMillis();
				p_filename = String.format("%d_%s", tm, p_filename);
				
				f = new File(absPath, p_filename);
			}
			// 임시 파일 => 내가 지정한 위치로 복사
			photo.transferTo(f);  // 예외 처리 넘기기
			
		}
		
		// 이전에 있던 파일 삭제
		 PhotoVo vo = photo_dao.selectOne(p_idx);
		 File delFile = new File(absPath, vo.getP_filename());
		 delFile.delete();
		 
		 // update된 file 이름수정
		 vo.setP_filename(p_filename);	// 새로 업로드 된 파일 이름?
		 int res = photo_dao.update_filename(vo);
		
		//변경화일명 JSON형식으로 반환
		// {"p_filename":"a.jpg"}
		JSONObject json = new JSONObject();
		json.put("p_filename", p_filename);
		
		return json.toString();
	}
	
	// 이미지 하단 컨텐츠 수정
	@RequestMapping("modify.do")
	public String modify(PhotoVo vo, int page, RedirectAttributes ra) {
		// 줄바꿈 처리
		String p_content = vo.getP_content().replaceAll("\n", "<br>");
		vo.setP_content(p_content);
		
		String p_ip = request.getRemoteAddr();
		vo.setP_ip(p_ip);
		
		// DB insert
		int res = photo_dao.update(vo);
		
		ra.addAttribute("page", page);
		
		return "redirect:list.do";
	}
	
	// 게시물 삭제
	@RequestMapping("delete.do")
	public String delete(int p_idx,int page,RedirectAttributes ra) {
		
		// 현재 p_idx가 사용하고 있는 화일도 삭제
		//2.PhotoVo정보 얻어온다
		PhotoVo vo = photo_dao.selectOne(p_idx);
		//   /images/의 절대경로
		String absPath = application.getRealPath("/resources/images/");
		//                      절대경로    (삭제)파일명 
		File delFile = new File(absPath, vo.getP_filename());
		
		delFile.delete();
		
		//DB delete
		int res = photo_dao.delete(p_idx);

		ra.addAttribute("page", page);
		return "redirect:list.do";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
