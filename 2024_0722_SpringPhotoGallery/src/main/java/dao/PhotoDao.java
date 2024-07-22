package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.PhotoVo;

public class PhotoDao {

	SqlSession sqlSession;

	//Setter Injection
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	
	public List<PhotoVo> selectList(Map<String, Object> map) {
		
		return sqlSession.selectList("photo.photo_list_page", map);
	}
	
	// p_idx에 대한 1건의 정보
	public PhotoVo selectOne(int p_idx) {

		return sqlSession.selectOne("photo.photo_one",p_idx);
	}

	public int insert(PhotoVo vo) {
		// TODO Auto-generated method stub

		return sqlSession.insert("photo.photo_insert", vo);

	}//end:insert()

	public int delete(int p_idx) {
		// TODO Auto-generated method stub

		return sqlSession.delete("photo.photo_delete", p_idx);

	}//end:delete()

	public int update_filename(PhotoVo vo) {
		// TODO Auto-generated method stub

		return sqlSession.update("photo.photo_update_filename", vo);

	}//end:update()  

	public int update(PhotoVo vo) {
		// TODO Auto-generated method stub

		return sqlSession.update("photo.photo_update", vo);

	}//end:update()

	public int selectRowTotal() {
		// TODO Auto-generated method stub
		
		return sqlSession.selectOne("photo.photo_row_total");
	}
	
}
