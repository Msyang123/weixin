package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 * 活动排除商品关联
 */
public class MActivityProductExcept extends Model<MActivityProductExcept> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final MActivityProductExcept dao = new MActivityProductExcept();

        public MActivityProductExcept findMActivityProductExcept(int id) {
            return dao.findFirst("select * from m_activity_product_except where id=?",id);
        }
        /**
         * 后台展示活动商品
         * @param activity_id
         * @return
         */
        public List<Record> mActivityProductsExcept(int activity_id){
        	return Db.find("select ap.id as apid,i.save_string,p.id,p.product_name,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.product_unit,pf.id as pf_id,u.unit_name from  "+
        			" m_activity_product_except ap "+   
        			" left join t_product_f pf on pf.id=ap.product_f_id "+
        			" left join t_product p on pf.product_id=p.id "+
        	        " left join t_image i on p.img_id=i.id "+
        	        " left join t_unit u on pf.product_unit=u.unit_code " +
        	        "  where ap.activity_id=? ", 
        	           activity_id);
        }
    }