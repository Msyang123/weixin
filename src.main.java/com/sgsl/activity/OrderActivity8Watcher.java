package com.sgsl.activity;

import java.util.Date;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.TUserAwardRecord;
import com.sgsl.utils.DateFormatUtil;

//订单送九宫格抽奖活动
public class OrderActivity8Watcher implements Watcher
{
	protected final static Logger logger = Logger.getLogger(OrderActivity8Watcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
    	OrderTransmitData orderData=(OrderTransmitData)data;
    	logger.info("订单送九宫格抽奖活动"+orderData.getUserId());
    	MActivity activity= MActivity.dao.findFirst("select * from m_activity where activity_type=13 and cjjh_type in(1,3) and yxbz='Y'");
    	
    	if(activity!=null){
        	String currentDay=DateFormatUtil.format5(new Date());
        	Record count= Db.findFirst("select count(*) as c from t_user_award_record where user_id=? and activity_id=? and get_time=?",orderData.getUserId(),activity.getInt("id"),currentDay);
        	//每天不能超过十次的获取抽奖机会,不算注册获取
        	if(count.getLong("c")>10){
        		return;
        	}
        	Record awardRecord = Db.findFirst("select * from t_user_award_record where out_trade_no = ?",orderData.getOrder().getStr("order_id"));
        	//该笔订单送过抽奖机会，就不再赠送
        	if(awardRecord!=null){
        		return;
        	}
    		if(orderData.getOrder().getInt("need_pay")>=activity.getInt("activity_money")
    			&&("1".equals(activity.getStr("cjjh_type"))||"3".equals(activity.getStr("cjjh_type")))
    			){
	    		//单独门店
	    		Record activityStore=
	    				Db.findFirst("select t2.store_id from m_activity_store t1 left join t_store t2 on t1.store_id=t2.id where t1.activity_id=?",activity.getInt("id"));
	    		TUserAwardRecord userAwardRecord=new TUserAwardRecord();
	        	userAwardRecord.set("user_id", orderData.getUserId());
	        	userAwardRecord.set("activity_id", activity.getInt("id"));
	        	userAwardRecord.set("is_valid", "1");
	        	userAwardRecord.set("get_time", DateFormatUtil.format5(new Date()));
	        	userAwardRecord.set("out_trade_no", orderData.getOrderId());
	    		if("2".equals(activity.getStr("scope"))
	    				&&orderData.getStoreId().equals(activityStore.get("store_id"))){
		    		//设置用户有一次抽奖机会
		        	userAwardRecord.save();
	    	    }else if("1".equals(activity.getStr("scope"))){
	    	    	//设置用户有一次抽奖机会
		        	userAwardRecord.save();
	    	    }
    		}
    	}	
    }
}