package com.sgsl.activity;


import com.jfinal.log.Logger;
import com.sgsl.model.TRefererRecord;

/**
 * 记录用户成功支付后的浏览记录信息
 * @author Administrator
 *
 */
public class RefererWatcher implements Watcher
{

	
	protected final static Logger logger = Logger.getLogger(RefererWatcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
    	logger.info("进入支付成功订阅通知");
    	OrderTransmitData orderData=(OrderTransmitData)data;
		 TRefererRecord refererRecord=new TRefererRecord();
	     refererRecord.set("referer", orderData.getExt().get("referer"));
	     refererRecord.set("order_type", orderData.getType());
	     refererRecord.set("user_id", orderData.getUserId());
	     refererRecord.set("create_time", orderData.getCurrentTime());
	     refererRecord.set("order_id", orderData.getOrderId());
	     refererRecord.save();
		
		logger.info("写入用户浏览记录成功");
    }

}