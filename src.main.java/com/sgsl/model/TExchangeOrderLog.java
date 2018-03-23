package com.sgsl.model;

import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.utils.DateFormatUtil;

public class TExchangeOrderLog extends Model<TExchangeOrderLog>{

	private static final long serialVersionUID = 1L;

	private final static Logger logger = Logger.getLogger(TExchangeOrderLog.class);
	public static final TExchangeOrderLog dao = new TExchangeOrderLog();
	
	/**
	 * 查找记录里的商品和规格
	 * @param product_id
	 * @return
	 */
	public List<Record> findProductInfo(Object product_id,Object pf_id){
		String sql="select p.product_name,pf.product_amount,c.unit_name as base_unit,"
				+ "u.unit_name as product_unit,p.img_id from t_product p "
				+ "left join t_product_f pf on p.id=pf.product_id "
				+ "left join t_unit u on pf.product_unit=u.unit_code "
				+ "left join t_unit c on p.base_unit=c.unit_code "
				+ "where p.id=? and pf.id=?";
		return Db.find(sql, product_id,pf_id);
	}
	
}
