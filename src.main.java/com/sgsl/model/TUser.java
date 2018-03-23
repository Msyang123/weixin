package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
/**
 * Created by yj on 2014/7/28.
 * 微网站用户信息
 */
public class TUser extends Model<TUser> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;

        public TUser(){
        	
        }
      
		public static final TUser dao = new TUser();

        public TUser findTUserInfo(int id) {
            return dao.findFirst("select u.*"+
            		" from t_user u where u.id=?",id);
        }
        public TUser findTUserByOpenId(String openId){
        	return dao.findFirst("select * from t_user where open_id=?",openId);
        }
        
        public List<TUser> findTUserByKeyword(String keyword,int userId){
        	return dao.find("select t.*,CONCAT(INSERT(phone_num,4,8,'****'),RIGHT(phone_num,4)) as phone_num_display from t_user t where status='1' and (phone_num like concat('%',?,'%') or nickname like concat('%',?,'%')) and id != ?",keyword,keyword,userId);
        }
        /**
         * 未消费(鲜果币)
         * 已消费统计(充值+赠送+直接购买-鲜果币)
         * @return
         */
        public Record findTUserBalanceTotal(){
        	return Db.findFirst("select sum(balance) wxf,(select sum(total_fee)-sum(balance) from t_pay_log where source_type in('recharge','present','order')) yxf from t_user");
        }
    }