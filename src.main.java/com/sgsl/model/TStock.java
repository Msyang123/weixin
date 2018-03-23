package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 * 仓库
 */
public class TStock extends Model<TStock> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final TStock dao = new TStock();
        
        /**
         * 查找我的仓库情况
         * 需要将赠送给我的所有商品列出来，商品需要做分组
         * @param userId
         * @return
         */
        public List<Record> findTStockByUserId(int userId) {
        	return Db.find("select p.id as product_id,sum(sp.amount) as amount,p.product_name,i.save_string as save_string,(select unit_name from t_unit where unit_code=p.base_unit) as base_unitname "+
				    "from t_stock_product sp   "+
					"left join t_stock s on sp.stock_id=s.id  "+
					"left join t_product p on sp.product_id=p.id "+
					"left join t_image i on p.img_id=i.id "+
				"where sp.`status`='Y' and s.user_id=? "+
			"group by sp.product_id", userId);
        }
        
        public List<Record> findTStockPro(int userId,int productId) {
        	return Db.find("select a.*,b.user_id,c.product_amount from t_stock_product a "
        			+ "left join t_stock b on a.stock_id = b.id "
        			+ "left join t_product_f c on a.product_f_id = c.id "
        			+ "where a.status='Y' and b.user_id=? and a.product_id=? order by get_time", userId,productId);
        }
        public TStock getStockByUser(int userId){
        	return dao.findFirst("select * from t_stock where user_id=?",userId);
        }
        public int updateAmount(int stock_pro_id,double amount){
        	String sql = "update t_stock_product set amount=amount-? where id=?";
        	return Db.update(sql, amount,stock_pro_id);
        }
        
        public boolean deleteOnePro(int stock_pro_id){
        	return Db.deleteById("t_stock_product", stock_pro_id);
        }
    }