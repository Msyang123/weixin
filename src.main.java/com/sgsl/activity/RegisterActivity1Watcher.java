package com.sgsl.activity;

import java.util.Date;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.TUserAwardRecord;
import com.sgsl.utils.DateFormatUtil;

//支付之后集果娃活动
public class RegisterActivity1Watcher implements Watcher
{
	protected final static Logger logger = Logger.getLogger(RegisterActivity1Watcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
    	RegisterTransmitData registerData=(RegisterTransmitData)data;
    	logger.info("注册送九宫格抽奖活动"+registerData.getUserId());
    	MActivity activity=new MActivity().findYxActivityByType(13);
    	if(activity!=null&&("2".equals(activity.getStr("cjjh_type"))||"3".equals(activity.getStr("cjjh_type")))){
    		//设置用户有一次抽奖机会
        	//单独门店
    		Record activityStore=
    				Db.findFirst("select t2.store_id from m_activity_store t1 left join t_store t2 on t1.store_id=t2.id where t1.activity_id=?",activity.getInt("id"));
    		TUserAwardRecord userAwardRecord=new TUserAwardRecord();
        	userAwardRecord.set("user_id", registerData.getUserId());
        	userAwardRecord.set("activity_id", activity.getInt("id"));
        	userAwardRecord.set("is_valid", "1");
    		userAwardRecord.set("get_time", DateFormatUtil.format5(new Date()));
    		if("2".equals(activity.getStr("scope"))
    				&&registerData.getStoreId().equals(activityStore.get("store_id"))){
	    		//设置用户有一次抽奖机会
	        	userAwardRecord.save();
    	    }else if("1".equals(activity.getStr("scope"))){
    	    	//设置用户有一次抽奖机会
	        	userAwardRecord.save();
    	    }
    	}
    	
    	
    }

}