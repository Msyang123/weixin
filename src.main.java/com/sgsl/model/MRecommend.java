package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 * 推荐商品
 */
public class MRecommend extends Model<MRecommend> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final MRecommend dao = new MRecommend();

        public List<MRecommend> findMRecommendByTypeId(int typeId) {
            return dao.find("select * from m_recommend where type_id=?",typeId);
        }
        public List<Record> findMRecommendsByTypeId(int typeId){
        	return Db.find("select c.*,ifnull(recomm_img,i.save_string) as save_string,p.id as product_id,p.product_name,f.price,f.special_price as real_price,f.product_unit,f.id as pf_id,u.unit_name, "+
        	" (select saleCount from t_product_sale ps where ps.product_f_id=f.id) as saleCount from m_recommend c "+
           " left join t_product_f f on f.id=c.product_f_id " +
        	" left join t_product p on c.product_id=p.id " +
           " left join t_image i on p.img_id=i.id " +
           " left join t_unit u on f.product_unit=u.unit_code " +
           "where p.fresh_format is null and c.type_id=? and p.product_status='01' order by c.order_id asc", 
            typeId);
        }
    }