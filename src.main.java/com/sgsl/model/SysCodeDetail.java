package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

import java.util.List;

public class SysCodeDetail extends Model<SysCodeDetail> {
	public static final SysCodeDetail dao = new SysCodeDetail();

	public List<SysCodeDetail> getListBid(int typeId) {
		return find("select code_value,code_name from sys_code_detail where type_id = ? ",
				new Object[] { Integer.valueOf(typeId) });
	}

	public List<SysCodeDetail> getListBname(String type_code) {
		return find("select a.* from sys_code_detail a,sys_code_type b where b.id=a.type_id and b.type_code= ? ",
				new Object[] { type_code });
	}
}
