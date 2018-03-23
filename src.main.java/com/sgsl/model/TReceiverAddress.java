package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class TReceiverAddress extends Model<TReceiverAddress> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        public static final TReceiverAddress dao = new TReceiverAddress();
        //现在直接将文字地址存地址表
        public List<Record> findAddresses(int user_id) {
        	String sql = "select a.* "
        			//"select a.*,b.name as province_name,c.name as city_name,d.name as area_name "
        			+ "from t_receiver_address a "
        			//+ "left join t_place b on a.province = b.code "
        			//+ "left join t_place c on a.city = c.code "
        			//+ "left join t_place d on a.area = d.code "
        			+ "where user_id=?";
            return Db.find(sql,user_id);
        }
        
        public TReceiverAddress findDefaultAddress(int user_id) {
        	String sql = "select * from t_receiver_address "
        			+ "where user_id=? and is_default='1'";
            return dao.findFirst(sql,user_id);
        }
        
        public int updateDefaullt(String user_id){
        	String sql = "update t_receiver_address set is_default='0' where user_id=?";
        	return Db.update(sql, user_id);
        }
    }