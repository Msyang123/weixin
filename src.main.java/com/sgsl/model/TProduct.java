package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;

/**
 * Created by yj on 2014/7/28. 水果商品信息
 */
public class TProduct extends Model<TProduct> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public static final TProduct dao = new TProduct();

	public TProduct findTProductId(int id) {
		return dao.findFirst("select * from t_product where id=?", id);
	}

	public Record findTProductDetialById(int id) {
		String sql = "select p.*,f.price,f.special_price as real_price,f.standard,f.product_f_des,"
				+ "c.unit_name,u.unit_name as base_unitname,f.product_amount,f.id as pf_id,i.save_string,"
				+ "(select sum(op.amount) from t_order_products op left join t_order o on op.order_id=o.id where o.order_status in('3','4','5','11') and f.id=op.product_f_id) as saleCount "
				+ " from t_product_f f " + " left join t_product p on p.id=f.product_id "
				+ " left join t_image i on p.img_id=i.id " + " left join t_unit c on f.product_unit=c.unit_code "
				+ " left join t_unit u on p.base_unit=u.unit_code " + "where f.id=?";
		return Db.findFirst(sql, id);
	}

	public List<Record> findTProductByCategoryId(String categoryId) {
		// 存在有商品但是没有规格的数据需要注意
		return Db.find(
				"select i.save_string,p.id,p.base_barcode,p.safe_qty,p.product_name,f.price,f.special_price as real_price,f.product_amount,f.product_unit,f.comments,f.id as pf_id,c.unit_name as unit_name,u.unit_name as base_unitname from  "
						+ " t_product_f f  " + " left join t_product p on p.id=f.product_id "
						+ " left join t_image i on p.img_id=i.id " + "left join t_unit c on f.product_unit=c.unit_code "
						+ "left join t_unit u on p.base_unit=u.unit_code "
						+ "where p.category_id=? and p.product_status='01' and f.fresh_format is null and f.is_vlid='Y' " + "order by f.order_id",
				categoryId);
	}

	public List<Record> findTProductByKeyword(String keyword) {
		// 存在有商品但是没有规格的数据需要注意
		String sql = "select i.save_string,p.id,p.product_name,p.base_barcode,p.safe_qty,f.product_amount,f.price,f.special_price as real_price,f.product_unit,f.comments,f.id as pf_id,u.unit_name as unit_name,u1.unit_name as base_unitname from  ";
		sql += " t_product_f f  ";
		sql += " left join t_product p on p.id=f.product_id ";
		sql += " left join t_category c on p.category_id=c.id ";
		sql += " left join t_image i on p.img_id=i.id ";
		sql += "left join t_unit u on f.product_unit=u.unit_code ";
		sql += "left join t_unit u1 on p.base_unit=u1.unit_code ";
		sql += "where p.product_status='01' and f.is_vlid='Y' and f.fresh_format is null and (c.category_name like concat('%',?,'%') or p.product_name like concat('%',?,'%')) ";
		sql += "order by f.order_id limit 20";
		return Db.find(sql, keyword, keyword);
	}

	public List<Record> findTProductByActivityId(int activityId) {
		// 存在有商品但是没有规格的数据需要注意
		String sql = "select i.save_string,p.id,p.product_name,f.product_amount,f.price,ifnull(f.special_price,f.price) as real_price,f.product_unit,f.comments,f.id as pf_id,u.unit_name as unit_name,u1.unit_name as base_unitname from  ";
		sql += " t_product_f f  ";
		sql += " left join t_product p on p.id=f.product_id ";
		sql += " left join t_category c on p.category_id=c.id ";
		sql += " left join t_image i on p.img_id=i.id ";
		sql += "left join t_unit u on f.product_unit=u.unit_code ";
		sql += "left join t_unit u1 on p.base_unit=u1.unit_code ";
		sql += "where p.product_status='01' and  f.id in (select product_f_id from m_activity_product where activity_id=?) ";
		sql += "order by f.order_id";
		return Db.find(sql, activityId);
	}

	public List<Record> findPresentProduct() {
		String sql = "select i.save_string,p.id,p.product_name,p.base_barcode,f.product_amount,f.price,ifnull(f.special_price,f.price) as real_price,f.product_unit,f.comments,f.id as pf_id,c.unit_name as unit_name,u.unit_name as base_unitname from  ";
		sql += " t_product_f f  ";
		sql += " left join t_product p on p.id=f.product_id ";
		sql += "left join t_unit c on f.product_unit=c.unit_code ";
		sql += "left join t_unit u on p.base_unit=u.unit_code ";
		sql += " left join t_image i on p.img_id=i.id ";
		sql += "where f.is_gift='1' and p.product_status='01' ";
		sql += "order by f.order_id";
		// 存在有商品但是没有规格的数据需要注意
		return Db.find(sql);
	}

	public Record findTProductUnitById(int id) {
		String sql = "select u.unit_name,u.is_int from t_product p ";
		sql += "left join t_unit u on p.base_unit=u.unit_code ";
		sql += "where p.id=?";
		return Db.findFirst(sql, id);
	}

	/**
	 * 后台搜索
	 * 
	 * @param productName
	 * @param product_status
	 * @param categoryId
	 * @param priceBigEquals
	 * @param priceSmallEquals
	 * @return
	 */
	public Page<Record> findTProduct(String productName, String productStatus, int categoryId, int pageSize, int page,
			String sidx, String sord) {
		// 存在有商品但是没有规格的数据需要注意
		String sql = "select p.id,p.product_status,c.category_name,i.save_string,p.id,p.product_name,u1.unit_name as base_unitname  ";
		String where = " from  t_product p ";
		where += " left join t_category c on p.category_id=c.category_id ";
		where += " left join t_image i on p.img_id=i.id ";
		where += " left join t_unit u1 on p.base_unit=u1.unit_code ";
		where += " where p.fresh_format is null and p.product_status='" + productStatus + "'";
		if (StringUtil.isNotNull(productName)) {
			where += "  and  p.product_name like concat('%','" + productName + "','%') ";
		}
		if (categoryId > 0) {
			where += " and c.category_id=" + categoryId;
		}

		where += " order by p.id desc ";
		return Db.paginate(page, pageSize, sql, where);
	}

	/**
	 * 横向分类商品查询
	 */
	public List<Record> findCustomTProduct(String activityId) {
		// 存在有商品但是没有规格的数据需要注意
		return Db
				.find("select i.save_string,p.id,p.product_name,f.price,ifnull(f.special_price,f.price) as real_price,f.product_amount,f.product_unit,f.comments,f.id as pf_id,c.unit_name as unit_name,u.unit_name as base_unitname from "
						+ "m_activity_product m left join " + "t_product_f f  on m.product_f_id = f.id "
						+ " left join t_product p on p.id=f.product_id " + " left join t_image i on p.img_id=i.id "
						+ "left join t_unit c on f.product_unit=c.unit_code "
						+ "left join t_unit u on p.base_unit=u.unit_code "
						+ "where m.activity_id=? and p.product_status='01' " + "order by m.dis_order", activityId);
	}

}