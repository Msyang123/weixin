package com.sgsl.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;

import java.util.List;

public class SysRole extends Model<SysRole> {
	private static final long serialVersionUID = 1L;
	public static final SysRole dao = new SysRole();

	public List<String> getRoleNameList(String username) {
		StringBuffer sb = new StringBuffer();

		sb.append(" SELECT DISTINCT c.role_name FROM sys_user a,sys_user_role b,sys_role c ");
		sb.append("  where a.id = b.user_id and b.role_id = c.id ");
		sb.append("    and a.user_name =  ? ");
		return Db.query(sb.toString(), new Object[] { username });
	}

	public List<String> getRoleNameList() {
		StringBuffer sb = new StringBuffer();

		sb.append(" SELECT DISTINCT c.role_name FROM sys_user a,sys_user_role b,sys_role c ");
		sb.append("  where a.id = b.user_id and b.role_id = c.id ");
		return Db.query(sb.toString());
	}

	public List<String> getMenuList(String username) {
		StringBuffer sb = new StringBuffer();

		sb.append(" SELECT DISTINCT e.href FROM sys_user a,sys_user_role b,sys_role_menu d,sys_menu e ");
		sb.append("  where a.id = b.user_id and b.role_id = d.role_id and d.menu_id = e.id ");
		sb.append("    and e.valid_flag='1' and a.user_name = ? ");

		return Db.query(sb.toString(), new Object[] { username });
	}

	public List<String> getMenuList() {
		StringBuffer sb = new StringBuffer();

		sb.append(" SELECT DISTINCT e.href FROM sys_user a,sys_user_role b,sys_role_menu d,sys_menu e ");
		sb.append("  where a.id = b.user_id and b.role_id = d.role_id and d.menu_id = e.id ");

		return Db.query(sb.toString());
	}

	public List<SysRole> listRole() {
		return dao.find("select * from sys_role");
	}
}
