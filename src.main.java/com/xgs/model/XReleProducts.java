package com.xgs.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

public class XReleProducts extends Model<XReleProducts>{

	/**
	 * 鲜果师
	 */
	private static final long serialVersionUID = 1L;
	public static final XReleProducts dao = new XReleProducts();
	
	/**
	 * 文章关联商品
	 */
	public boolean relateProduct(int article_id,int product_id){
		Record record = new Record();
		record.set("article_id", article_id);
		record.set("product_id", product_id);
		return Db.save("x_rele_products", record);
	}
	
	/**
	 * 文章取消关联商品
	 */
	public boolean removeRelateProduct(int article_id,int product_id){
		Record record = Db.findFirst("select * from x_rele_products where article_id=? and product_id=?",article_id,product_id);
		return Db.delete("x_rele_products",record);
	}
}
