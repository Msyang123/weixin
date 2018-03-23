package com.sgsl.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;

import java.util.List;

public class SysParam extends Model<SysParam> {
	public static final SysParam dao = new SysParam();
	public static final String sql = "select * from sys_param where name=?";

	public List<SysParam> getParams() {
		return Db.query("select * from sys_param where valid_flag='1'");
	}

	public SysParam findByName(String name) {
		return (SysParam) dao.findFirst("select * from sys_param where name=?", new Object[] { name });
	}
}