package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

import java.util.List;

public class SysUserRole extends Model<SysUserRole> {
	public static final SysUserRole dao = new SysUserRole();

	public List<SysUserRole> getById(int id) {
		return dao.find("select a.* from sys_user_role a where a.user_id=" + id);
	}

}
