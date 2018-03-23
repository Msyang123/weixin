package com.sgsl.activity;

import java.util.List;

import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MInterval;

//限时抢购活动
public class OrderActivity4Watcher implements Watcher
{

    @Override
    public void update(TransmitDataInte data)
    {
    	OrderTransmitData orderData=(OrderTransmitData)data;
    	int activityType=1;
    	MActivity activity=new MActivity();
    	MActivityProduct activityProOper=new MActivityProduct();
		MInterval miOper=new MInterval();
    	List<Record> qghd= activity.findMActivitys(activityType);
    	for(Record item:qghd){
    		//查找活动商品
			List<MActivityProduct> activityProducts=
					activityProOper.findMActivityProductList(item.getInt("id"));
			for(MActivityProduct mp:activityProducts){
	    		//购买
	    		if("gm".equals(orderData.getType())){
					for(Record orderPro:orderData.getOrder().getOrderProducts()){
						if(mp.getInt("product_f_id").equals(orderPro.getInt("product_f_id"))
						   &&miOper.isInInterval(item.getInt("id"))!=null
						   &&mp.getDouble("product_count")>0){
							//减少抢购数量
			    			mp.set("product_count", mp.getDouble("product_count")-orderPro.getDouble("amount"));
			    			mp.update();
			    			break;
						}
					}
				}else{
					//赠送
					for(Record orderPro:orderData.getPresent().getPresentProducts()){
						if(mp.getInt("product_f_id").equals(orderPro.getInt("pf_id"))
						   &&miOper.isInInterval(item.getInt("id"))!=null
						   &&mp.getDouble("product_count")>0){
							//减少抢购数量
			    			mp.set("product_count", mp.getDouble("product_count")-orderPro.getInt("amount"));
			    			mp.update();
			    			break;
						}
					}
				}
			}
    		
    	}
        System.out.println("限时打折活动"+orderData.getUserId()+"订单"+orderData.getOrderId()+"需要支付"+orderData.getNeedPay());
    }

}