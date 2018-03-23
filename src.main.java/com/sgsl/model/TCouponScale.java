package com.sgsl.model;

import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
/**
 * 
 * @author TianWei
 *	优惠券规模	
 */
public class TCouponScale extends Model<TCouponScale>{
	
	private static final long serialVersionUID = 1L;
	
	public static final TCouponScale dao = new TCouponScale();
	
	/*
	 * 查找所有优惠券规模
	 */
	public List<TCouponScale> findAllTCouponScales(){
		return dao.find("select * from t_coupon_scale order by is_valid");
	}
	/**
	 * 找到所有有效的优惠券规模
	 * @return
	 */
	public List<TCouponScale> findAllValidTCouponScales(){
		return dao.find("select * from t_coupon_scale where is_valid='Y'");
	}
	
	/**
	 * 信息修改（没有限制修改的字段个数）
	 * 
	 * @param map
	 * @return 
	 */
	public int updateInfo(Map<String, Object> map, int id,String tableName) {
		String updateColumn = "";
		for (String key : map.keySet()) {//拼接的修改字段及其修改值
			System.out.println(key+"======="+map.get(key));
			updateColumn = updateColumn + key + " = '" + map.get(key) + "',";// 拼接key1=value1,key2=value2...这种格式
		}
//		Iterator<Entry<String, Object>> it = map.entrySet().iterator();
//		while (it.hasNext()) {
//	          Entry<String, Object> entry = it.next();
//	          updateColumn = updateColumn + entry.getKey() + " = '" +entry.getValue() + "',";// 拼接key1=value1,key2=value2...这种格式
//	          System.out.println(updateColumn);
//	    }
		updateColumn = updateColumn.substring(0, updateColumn.length() - 1);// 去掉尾部的逗号
		int result = Db.update("update "+tableName+" set " + updateColumn + " where id = " + id);
		return result;
	}
	
	/**
	 * 信息修改（没有限制修改的字段个数）
	 * 
	 * @param map
	 * @return 
	 */
	public int updateInfo1(Map<String, Object> map, int id,String tableName) {
		String updateColumn = "";
		for (String key : map.keySet()) {//拼接的修改字段及其修改值
			System.out.println(key+"======="+map.get(key));
			updateColumn = updateColumn + key + " = " + map.get(key) + ",";// 拼接key1=value1,key2=value2...这种格式
		}
//		Iterator<Entry<String, Object>> it = map.entrySet().iterator();
//		while (it.hasNext()) {
//	          Entry<String, Object> entry = it.next();
//	          updateColumn = updateColumn + entry.getKey() + " = '" +entry.getValue() + "',";// 拼接key1=value1,key2=value2...这种格式
//	          System.out.println(updateColumn);
//	    }
		updateColumn = updateColumn.substring(0, updateColumn.length() - 1);// 去掉尾部的逗号
		int result = Db.update("update "+tableName+" set " + updateColumn + " where id = " + id);
		return result;
	}

}
