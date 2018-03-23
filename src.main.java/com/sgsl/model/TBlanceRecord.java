package com.sgsl.model;


import com.jfinal.plugin.activerecord.Model;

/**
 * 充值送果币
 * @author yijun
 *
 */
public class TBlanceRecord extends Model<TBlanceRecord> {
	private static final long serialVersionUID = 1L;


    public static final TBlanceRecord dao = new TBlanceRecord();
    
    public TBlanceRecord getRecordByOrderId(int userId,int orderId){
    	return this.findFirst("select * from t_blance_record where user_id=? and order_id=?",userId,orderId);
    }
    public TBlanceRecord getRecordByOrderId(int userId,String orderId){
    	return this.findFirst("select * from t_blance_record where user_id=? and order_id=?",userId,orderId);
    }
    public TBlanceRecord getRecordByOrderId(int userId,String orderId,String refType){
    	return this.findFirst("select * from t_blance_record where user_id=? and order_id=? and ref_type=?",userId,orderId,refType);
    }
}
