package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.MemberVo;

public class MemberDao {
	
	// mybatis
	SqlSession sqlSession;  // SqlSessionTemplate의 interface

	// setter injection을 위한 setter 만들기
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	// mem_id에 해당되는 1건의 정보 얻어오기 : selectOne_memid
	public MemberVo selectOne(String mem_id) {

		return sqlSession.selectOne("member.member_one_id", mem_id);
	} // end : selectOne

	public List<MemberVo> selectList() {
		// TODO Auto-generated method stub
		
		return sqlSession.selectList("member.member_list");
	}

	public int insert(MemberVo vo) {
		// TODO Auto-generated method stub
		return sqlSession.insert("member.member_insert", vo);
	}

	public int delete(int mem_idx) {
		// TODO Auto-generated method stub
		return sqlSession.delete("member.member_delete", mem_idx);
	}

	public MemberVo selectOne(int mem_idx) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("member.member_one_idx");
	}

	public int update(MemberVo vo) {
		// TODO Auto-generated method stub
		return sqlSession.update("member.member_update", vo);
	}
	
	

}
