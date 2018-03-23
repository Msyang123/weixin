package com.xgs.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.TUser;

public class XMasterUser extends Model<XMasterUser> {

	/**
	 * @author TW
	 */
	private static final long serialVersionUID = 1L;

	public static final XMasterUser dao = new XMasterUser();

	/**
	 * 查找用户是否关联上级鲜果师
	 * 
	 * @param user_id
	 * @return
	 */
	public XMasterUser findXUser(int user_id) {
		return dao.findFirst("select * from x_master_user where user_id = ?", user_id);
	}

	/**
	 * 关注鲜果师(绑定鲜果师)
	 * 
	 * @param master_desc
	 * @param master_id
	 * @param user_id
	 */
	public void addXMasterUser(int master_id, int user_id) {
		TUser user = TUser.dao.findById(user_id);
		Record record = new Record();
		// 默认给客户的备注就是他自己的昵称
		record.set("master_desc", user.getStr("nick_name"));
		record.set("master_id", master_id);
		record.set("user_id", user_id);
		Db.save("x_master_user", record);
	}

	/**
	 * 鲜果师所有客户
	 */
	public List<XMasterUser> findUsersByMasterId(int mastser_id) {
		return dao.find(
				"select mu.*,u.* from x_master_user mu left join t_user u  on mu.user_id = u.id "
				+ "where master_id = ? order by u.regist_time desc",
				mastser_id);
	}

	/**
	 * 某个鲜果师的某个客户信息
	 * 
	 * @param mastser_id
	 * @param user_id
	 * @return
	 */
	public XMasterUser findCustomerByUserId(int user_id) {
		return dao.findFirst(
				"select mu.*,u.* from x_master_user mu left join t_user u  on mu.user_id = u.id where mu.user_id=?",
				user_id);
	}

	public void updateMasterUserDescription(int mastser_id, int user_id, String description) {
		Db.update("update x_master_user set master_desc=? where user_id = ? and master_id= ?", 
				description, user_id,mastser_id);
	}
}
