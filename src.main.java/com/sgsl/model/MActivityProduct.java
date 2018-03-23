package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28. 活动商品关联
 */
public class MActivityProduct extends Model<MActivityProduct> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public static final MActivityProduct dao = new MActivityProduct();

	public MActivityProduct findMActivityProductId(int id) {
		return dao.findFirst("select * from m_activity_product where id=?", id);
	}

	//
	public List<Record> findMActivityProducts(int activity_id) {
		return Db.find(
				"select i.save_string,p.id,p.product_name,pf.price,pf.special_price as real_price,pf.product_unit,pf.id as pf_id,pf.product_amount,u.unit_name,   "
						+ "(select saleCount from t_product_sale ps where ps.product_f_id=pf.id) as saleCount "
						+ " from m_activity_product ap " + " left join t_product_f pf on pf.id=ap.product_f_id "
						+ " left join t_product p on pf.product_id=p.id " + " left join t_image i on p.img_id=i.id "
						+ " left join t_unit u on pf.product_unit=u.unit_code "
						+ "  where ap.activity_id=? and p.product_status='01' and pf.is_vlid='Y' order by ap.dis_order asc ",
				activity_id);
	}

	/**
	 * 后台展示活动商品
	 * 
	 * @param activity_id
	 * @return
	 */
	public List<Record> mActivityProducts(int activity_id) {
		return Db
				.find("select ap.id as apid,i.save_string,p.id,p.product_name,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.product_amount,pf.product_unit,pf.id as pf_id,u.unit_name from  "
						+ " m_activity_product ap " + " left join t_product_f pf on pf.id=ap.product_f_id "
						+ " left join t_product p on pf.product_id=p.id " + " left join t_image i on p.img_id=i.id "
						+ " left join t_unit u on pf.product_unit=u.unit_code "
						+ "  where ap.activity_id=? order by ap.dis_order asc ", activity_id);
	}

	/**
	 * 查询活动商品用于调整抢购价格
	 * 
	 * @param activity_id
	 * @return
	 */
	public List<MActivityProduct> findMActivityProductList(int activity_id) {
		return dao.find("select * from m_activity_product where activity_id=?", activity_id);
	}

	/**
	 * 查询团购商品清单
	 */
	public List<Record> findTeamMActivityProductList(int activity_id) {
		return Db
				.find("select m.*,p.product_name,pf.standard,i.save_string,u.unit_name,pf.price,ifnull(pf.special_price,pf.price) as real_price "
						+ " from m_activity_product m left join t_product p on m.product_id=p.id "
						+ " left join t_product_f pf on m.product_f_id=pf.id and m.product_id=pf.product_id "
						+ " left join t_image i on p.img_id=i.id "
						+ " left join t_unit u on pf.product_unit=u.unit_code" + " where m.activity_id=?", activity_id);
	}

	/**
	 * 删除活动商品
	 */
	public void deleteActivityProduct(String activity_id) {
		List<Record> records = Db.find("select * from m_activity_product where activity_id =" + activity_id);
		for (Record record : records) {
			Db.delete("m_activity_product", record);
		}
	}
	/**
	 * 鲜果师食鲜推荐商品
	 * @param activity_id
	 * @return
	 */
	public List<Record> findMasterMActivityProducts(int activity_id) {
		return Db.find(
				"select i.save_string,p.id,p.product_name,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.product_unit,pf.id as pf_id,pf.product_amount,u.unit_name,c.unit_name as base_unitname,   "
						+ "(select saleCount from t_product_sale ps where ps.product_f_id=pf.id) as saleCount "
						+ " from m_activity_product ap " + " left join t_product_f pf on pf.id=ap.product_f_id "
						+ " left join t_product p on pf.product_id=p.id " + " left join t_image i on p.img_id=i.id "
						+ " left join t_unit u on pf.product_unit=u.unit_code " + " left join t_unit c on p.base_unit = c.unit_code "
						+ "  where ap.activity_id=? and p.product_status='01' and pf.is_vlid='Y' order by ap.dis_order asc ",
				activity_id);
	}
}