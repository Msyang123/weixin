package com.sgsl.activity;

import com.jfinal.log.Logger;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPresent;

//支付之后集果娃活动
public class OrderActivity7Watcher implements Watcher
{
	protected final static Logger logger = Logger.getLogger(OrderActivity7Watcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
    	OrderTransmitData orderData=(OrderTransmitData)data;
    	logger.info("支付之后集果娃活动"+orderData.getUserId()+"订单"+orderData.getOrderId()+"优惠前需要支付"+orderData.getNeedPay());
    	if("gm".equals(orderData.getType())){
	    	TOrder order=TOrder.dao.findById(orderData.getOrderId());
    	}else if("zs".equals(orderData.getType())){
    		TPresent present=orderData.getPresent();
    	}
    }

}