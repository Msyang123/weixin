package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

/**
 * Created by yj on 2014/7/28.
 * 订单商品
 */
public class TOrderProducts extends Model<TOrderProducts> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        public static final TOrderProducts dao = new TOrderProducts();
        
//        /**
//         *  某一订单下商品总量统计
//         * @param order_id
//         * @return
//         */
//        public int findProductCountByOrderID(int order_id){
//        	return dao.findFirst("select count(*) as count from t_order_products where order_id = ",order_id).getInt("count");
//        }
    }