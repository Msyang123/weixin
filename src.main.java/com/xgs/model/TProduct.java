package com.xgs.model;

import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;

public class TProduct extends Model<TProduct>{
	
	private static final long serialVersionUID = 1L;
	public static final TProduct dao = new TProduct();
	
	/**
	 * 后台查询所有商品
	 * @return
	 */
	public Page<Record> findTProduct(String productName, String productStatus, int categoryId, int pageSize, int page,
			String sidx, String sord,Boolean isNutritionPage,String isNutrition){
		String sql = "SELECT p.id,p.product_status,p.product_name,c.category_name,i.save_string,u.unit_name, "
				+ " f.id as pf_id,f.standard,f.show_standard,f.is_vlid,f.price ";
		String 	where ="FROM t_product p ";
		 		where +="LEFT JOIN t_product_f f on p.id=f.product_id ";
				where +="LEFT JOIN t_image i ON p.img_id=i.id ";
				where +="LEFT JOIN t_unit u ON u.unit_code=p.base_unit ";
				where +="LEFT JOIN t_category c ON c.category_id=p.category_id ";
				where +="where p.fresh_format=1 and p.product_status='" + productStatus + "'";
		       if(StringUtil.isNotNull(productName)){
		    	   where +=" and p.product_name like concat('%','" + productName + "','%') ";
		       }
		       if (categoryId > 0) {
					where += " and c.category_id=" + categoryId;
				}
		       if(isNutritionPage==true){
		    	   if(StringUtil.isNotNull(isNutrition)){
		    		   where += "and f.id in(select ap.product_f_id from m_activity a "
		    		   		+ "left join m_activity_product ap on a.id=ap.activity_id where a.activity_type=16) ";
		    	   }else{
		    		   /*where += "and f.id not in(select ap.product_f_id from m_activity a "
		    		   		+ "left join m_activity_product ap on a.id=ap.activity_id where a.activity_type=16) ";*/
		    	   }
		    	    
		       }
				where += " order by p.id desc ";
				return Db.paginate(page, pageSize, sql, where);

	}
	
	/**
	 * 后台食鲜推荐列表查询
	 * @param pageSize
	 * @param page
	 * @return
	 */
	public Page<Record> findRecommend(int pageSize, int page){
		String sql = "select a.id,a.activity_type,a.main_title,a.yxbz,a.subheading ";
		String where = "from  m_activity a  ";
			   where += "where a.activity_type=15 ";
		return Db.paginate(page, pageSize, sql, where);
	}
	
	/**
	 * 后台查询所有商品
	 * @return
	 */
	public Page<Record> findRecommentList(String productName, String productStatus, int pageSize, int page,
			Boolean isRecommend,int activity_id){
		String sql = "SELECT p.id,p.product_status,p.product_name,c.category_name,i.save_string,u.unit_name, "
				+ " f.id as pf_id,f.standard,f.show_standard,f.is_vlid,f.price ";
		String 	where ="FROM t_product p ";
		 		where +="LEFT JOIN t_product_f f on p.id=f.product_id ";
				where +="LEFT JOIN t_image i ON p.img_id=i.id ";
				where +="LEFT JOIN t_unit u ON u.unit_code=p.base_unit ";
				where +="LEFT JOIN t_category c ON c.category_id=p.category_id ";
				where +="where p.fresh_format=1 and p.product_status='" + productStatus + "'";
		       if(StringUtil.isNotNull(productName)){
		    	   where +=" and p.product_name like concat('%','" + productName + "','%') ";
		       }
		       if(isRecommend!=null){
	    		   where += "and p.id in(select p.id from t_product p left join m_activity_product ap on p.id=ap.product_id "
		    	   		+ "left join m_activity a on a.id=ap.activity_id where a.activity_type=15 and ap.activity_id="+activity_id+") ";
		       }else{
		    	   where += "and p.id not in(select p.id from t_product p left join m_activity_product ap on p.id=ap.product_id "
			    	   		+ "left join m_activity a on a.id=ap.activity_id where a.activity_type=15) ";
		       }// and a.id = ?
	    	   where += " order by p.id desc ";
				return Db.paginate(page, pageSize, sql, where);
	}
	
	/**
	 * 鲜果师商城营养精选(营养精选是一款活动)
	 */
	public List<TProduct> findMasterTProduct() {
		return dao
			.find("select p.*,pf.price,pf.standard,pf.show_standard,c.unit_name,u.unit_name as base_unitname,pf.product_amount,pf.id as pf_id,i.save_string "
					+ " from t_product_f pf left JOIN t_product p on p.id = pf.product_id "
					+ " left JOIN t_image i on p.img_id = i.id "
					+ " left join t_unit c on pf.product_unit=c.unit_code "
					+ " left join t_unit u on p.base_unit=u.unit_code where p.fresh_format = '1' and p.product_status='01' and pf.id in "
					+ "(select product_f_id from m_activity_product where activity_id = (select id from m_activity where activity_type=16 limit 1 ))");

}

	
	public TProduct findTProductId(int id) {
		return dao.findFirst("select * from t_product where id=?", id);
	}
	
	/**
	 * 搜索鲜果师商城商品
	 */
	public Page<TProduct> findMasterProductByContent(String content,int pageNumber,int pageSize) {
		String select = "select p.*,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.standard,pf.show_standard, "
				+ "c.unit_name,u.unit_name as base_unitname,pf.product_amount,pf.id as pf_id,i.save_string ";
		String sqlExceptSelect = "from t_product_f pf left JOIN t_product p on p.id = pf.product_id "
				+ "left JOIN t_image i on p.img_id = i.id "
				+ "left join t_unit c on pf.product_unit=c.unit_code " + "left join t_unit u on p.base_unit=u.unit_code "
				+ "WHERE p.fresh_format = '1' and p.product_status='01' and (p.description like '%"+content+"%' or p.product_name like '%"+content+"%')";
		return dao.paginate(pageNumber, pageSize, select, sqlExceptSelect);
	}
	
	
	/**
	 * 鲜果师商城商品详情
	 */
	public TProduct getMasterProductDetailById(int pf_id) {
		// TODO
		String sql = "select p.*,f.price,f.standard,pf.show_standard,c.unit_name,u.unit_name as base_unitname,f.product_amount,f.id as pf_id,i.save_string "
				+ " from t_product_f f " + " left join t_product p on p.id=f.product_id "
				+ " left join t_image i on p.img_id=i.id " + " left join t_unit c on f.product_unit=c.unit_code "
				+ " left join t_unit u on p.base_unit=u.unit_code " + "where p.id=? and p.fresh_format = 1";
		return dao.findFirst(sql, pf_id);
	}

	/**
	 * 鲜果师商城某一种类的商品
	 */
	public TProduct findMasterProductById(int product_id) {
		return dao.findFirst(
				"select p.*,u.unit_name,i.save_string from t_product p left join t_image i on p.img_id = i.id left join t_unit u on p.base_unit = u.unit_code where fresh_format = '1' and p.id=?",
				product_id);
	}
	
	/**
	 * 鲜果师商城 文章详情关联商品
	 */
	public List<TProduct> findArticleProduct(int article_id){
		return dao.find("select p.*,pf.*,pf.id as pf_id,c.unit_name as unit_name,u.unit_name as base_unit,i.save_string from t_product p "
				+ "LEFT JOIN t_product_f pf on p.id = pf.product_id "
				+ "left join t_unit c on pf.product_unit = c.unit_code "
				+ "left join t_unit u on p.base_unit=u.unit_code "
				+ "LEFT JOIN x_rele_products rp on p.id  = rp.product_id "
				+ "LEFT JOIN x_article a on a.id  = rp.article_id "
				+ "LEFT JOIN t_image i on p.img_id = i.id "
				+ "where  p.product_status = '01' and pf.is_vlid='Y' and p.fresh_format = '1' and a.status = 0 and a.id = ?",article_id);
	}
	@Override
	public String toString() {
		JSONObject masterProduct=new JSONObject();
		Iterator<Entry<String, Object>> iter= this.getAttrsEntrySet().iterator();
		while(iter.hasNext()){
			Entry<String, Object> item=iter.next();
			masterProduct.put(item.getKey(), item.getValue());
		}
		return masterProduct.toJSONString();
	}
	
	
	/**
	 * 查询某篇文章未关联的商品
	 * @return
	 */
	public Page<Record> findUnReleProductByArticleId(String productName, String productStatus, int categoryId, int pageSize, int page,
			String sidx, String sord,String article_ids){
		String sql = "SELECT p.id,p.product_status,p.product_name,c.category_name,i.save_string,u.unit_name, "
				+ " f.id as pf_id,f.standard,f.show_standard,f.is_vlid,f.price ";
		String 	where ="FROM t_product p ";
		 		where +="LEFT JOIN t_product_f f on p.id=f.product_id ";
				where +="LEFT JOIN t_image i ON p.img_id=i.id ";
				where +="LEFT JOIN t_unit u ON u.unit_code=p.base_unit ";
				where +="LEFT JOIN t_category c ON c.category_id=p.category_id ";
				where +="where p.fresh_format=1 and p.product_status='" + productStatus + "'";
       if(StringUtil.isNotNull(productName)){
    	   where +=" and p.product_name like concat('%','" + productName + "','%') ";
       }
       if (categoryId > 0) {
			where += " and c.category_id=" + categoryId;
		}
	   if(StringUtil.isNotNull(article_ids)){
		   where += "and p.id not in " + article_ids;
	   }
	   
	   where += " order by p.id ";
	   return Db.paginate(page, pageSize, sql, where);

	}

	/**
	 * 查询某篇文章下关联的商品
	 * @return
	 */
	public Page<Record> findReleProductByArticleId(String productStatus, int pageSize, int page,
			String sidx, String sord,String product_ids){
		String sql = "SELECT p.id,p.product_status,p.product_name,c.category_name,i.save_string,u.unit_name, "
				+ " f.id as pf_id,f.standard,f.show_standard,f.is_vlid,f.price ";
		String 	where ="FROM t_product p ";
		 		where +="LEFT JOIN t_product_f f on p.id=f.product_id ";
				where +="LEFT JOIN t_image i ON p.img_id=i.id ";
				where +="LEFT JOIN t_unit u ON u.unit_code=p.base_unit ";
				where +="LEFT JOIN t_category c ON c.category_id=p.category_id ";
				where +="where p.fresh_format=1 and p.product_status='" + productStatus + "'";
     
	   if(StringUtil.isNotNull(product_ids)){
		   where += "and p.id in " + product_ids;
	   }else{
		   where += "and 0=1 ";
	   }
	   
	   where += " order by p.id ";
	   return Db.paginate(page, pageSize, sql, where);
	}

}
