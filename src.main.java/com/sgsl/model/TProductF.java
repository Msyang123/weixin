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
public class TProductF extends Model<TProductF> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public static final TProductF dao = new TProductF();

	public Record findTProductFById(int id) {
		String sql = "select a.*,b.*,ifnull(a.special_price,a.price) as real_price, a.id as pf_id,c.unit_name as unit_name,d.save_string from t_product_f a "
				+ "left join t_product b on a.product_id=b.id " + "left join t_unit c on a.product_unit=c.unit_code "
				+ "left join t_image d on b.img_id=d.id " 
				+ "where a.id=?";
		return Db.findFirst(sql, id);
	}

	public Record findTProductFAndProductById(int id) {
		String sql = "select a.product_code,a.product_name,a.category_id,a.product_grade,a.origin_id,a.description,a.product_status,a.img_id,"
				+ "a.carousel_id,a.product_detail,a.base_unit,a.base_barcode,a.img_url,a.sku_id,a.fresh_format,a.base_count,"
				+ "b.id,b.product_code,b.bar_code,b.product_amount,b.product_unit,b.standard,ifnull(b.special_price,b.price) as real_price,b.price_type,b.is_gift,b.comments,b.order_id,b.sku_id,b.is_vlid,b.fresh_format "
				+ " from t_product_f b " + "left join t_product a on b.product_id=a.id " + "where b.id=?";
		return Db.findFirst(sql, id);
	}

	public Page<Record> findByProductId(int productId, int pageSize, int page, String sidx, String sord) {
		String select = "select f.*,u.unit_name";
		String sqlExceptSelect = null;
		if (StringUtil.isNull(sidx)) {
			sqlExceptSelect = "from t_product_f f left join t_unit u on f.product_unit=u.unit_code where product_id=? ";
		} else {
			sqlExceptSelect = "from t_product_f f left join t_unit u on f.product_unit=u.unit_code where product_id=? order by "
					+ sidx + " " + sord;
		}
		return Db.paginate(page, pageSize, select, sqlExceptSelect, productId);
	}

	public Page<Record> findTProductF(String productName, String productStatus, int categoryId, int pageSize, int page,
			String sidx, String sord) {
		// 存在有商品但是没有规格的数据需要注意
		String sql = "select pf.id,p.product_status,c.category_name,i.save_string,p.product_name,u1.unit_name as base_unitname,pf.product_amount,pf.product_unit,pf.standard,pf.price,pf.special_price,pf.is_gift,pf.is_vlid";
		String where = " from  t_product p left join t_product_f pf on p.id=pf.product_id";
		where += " left join t_category c on p.category_id=c.category_id ";
		where += " left join t_image i on p.img_id=i.id ";
		where += " left join t_unit u1 on p.base_unit=u1.unit_code ";
		where += " where p.product_status='" + productStatus + "'";
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
	 * 修改商品特价
	 * 
	 * @param pfId
	 * @param specialPrice
	 */
	public void updateSpecialPrice(int pfId, int specialPrice) {
		Db.update("update t_product_f  set special_price=? where id=?", specialPrice, pfId);
	}

	/**
	 * 修改特价为原价
	 * 
	 * @param pfId
	 */
	public void updateSpecialPriceAsPrice(int pfId) {
		Db.update("update t_product_f  set special_price=price where id=?", pfId);
	}

}
