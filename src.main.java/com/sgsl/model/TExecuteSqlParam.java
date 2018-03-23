package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;

/**
 * 执行sql对象参数
 * @author yijun
 *
 */
public class TExecuteSqlParam extends Model<TExecuteSqlParam> {
	private static final long serialVersionUID = 1L;


    public static final TExecuteSqlParam dao = new TExecuteSqlParam();
    
    public void deleteExecuteSqlParam(int executeId){
    	Db.update("delete from t_execute_sql_param where execute_id=?",executeId);
    }
    public List<TExecuteSqlParam> findExecuteSqlParam(int executeId){
    	return dao.find("select * from t_execute_sql_param where execute_id=? order by order_des asc",executeId);
    }
}
