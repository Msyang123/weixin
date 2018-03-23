package com.xgs.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;

public class TProductF extends Model<TProductF>{

	private static final long serialVersionUID = 1L;
	public static final TProductF dao = new TProductF();
	
	public Page<Record> findByProductId(
    		int productId,
    		int pageSize,
			int page,
			String sidx,
			String sord){
    	String select="select f.*,u.unit_name";
    	String sqlExceptSelect=null;
    	if(StringUtil.isNull(sidx)){
    		sqlExceptSelect="from t_product_f f left join t_unit u on f.product_unit=u.unit_code where product_id=? ";
    	}
    	else{
    		sqlExceptSelect="from t_product_f f left join t_unit u on f.product_unit=u.unit_code where product_id=? order by "+sidx+" "+sord;
    	}
    	return Db.paginate(page, pageSize, select, sqlExceptSelect,productId);
    }
	
	 public Record findTProductFById(int id) {
     	String sql = "select a.*,b.*,ifnull(a.special_price,a.price) as real_price, a.id as pf_id,c.unit_name as unit_name,d.save_string from t_product_f a "
     			+ "left join t_product b on a.product_id=b.id "
     			+ "left join t_unit c on a.product_unit=c.unit_code "
     			+ "left join t_image d on b.img_id=d.id "
     			+ "where a.fresh_format=1 and a.id=?";
         return Db.findFirst(sql,id);
     }
	 
     /**
      * 找出鲜果师某一种商品的所有规格
      */
     public List<TProductF> findMasterTProductFByProductId(int pf_id){
     	return dao.find("select f.*,u.unit_name from t_product_f f LEFT JOIN t_unit u ON f.product_unit=u.unit_code where f.product_id = ? order by f.id",pf_id);
     }
}
