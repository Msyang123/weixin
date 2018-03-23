package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

/**
 * 下单失败日志记录
 * @author User
 *
 */
public class TFailureLog extends Model<TFailureLog>{

	private static final long serialVersionUID = 1L;
	
	public static final TFailureLog dao = new TFailureLog();
	
}
