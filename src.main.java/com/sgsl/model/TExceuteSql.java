package com.sgsl.model;


import com.jfinal.plugin.activerecord.Model;

/**
 * 执行sql对象
 * @author yijun
 *
 */
public class TExceuteSql extends Model<TExceuteSql> {
	private static final long serialVersionUID = 1L;


    public static final TExceuteSql dao = new TExceuteSql();
}
