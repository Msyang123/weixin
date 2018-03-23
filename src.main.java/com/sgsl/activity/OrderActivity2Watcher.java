package com.sgsl.activity;

import com.jfinal.log.Logger;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TOrder;
import com.sgsl.model.TUserCoupon;
import com.sgsl.utils.DateFormatUtil;

//具体的主题角色coupon  优惠券活动
public class OrderActivity2Watcher implements Watcher
{
	protected final static Logger logger = Logger.getLogger(OrderActivity2Watcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
//    	OrderTransmitData orderData=(OrderTransmitData)data;
//    	logger.info("优惠券活动内"+orderData.getUserId()+"订单"+orderData.getOrderId()+"优惠前需要支付"+orderData.getNeedPay());
//    	TCoupon coupon=TCoupon.dao.findById(orderData.getCouponId());
//    	if(coupon==null)
//    		return;
//    	TOrder order=TOrder.dao.findById(orderData.getOrderId());
//    	
//    	TUserCoupon userCoupon=new TUserCoupon().findUserCouponByCouponId(orderData.getCouponId());
//    	order.set("need_pay", order.getInt("need_pay")-coupon.getInt("coupon_val"));
//    	order.set("discount", order.getInt("discount")+coupon.getInt("coupon_val"));
//    	order.update();
//    	coupon.set("status", "2");
//    	coupon.update();
//    	//将用户的优惠券置为无效
//    	userCoupon.set("is_expire", "1");
//    	userCoupon.set("used_order_id", orderData.getOrderId());
//    	userCoupon.set("used_order_type", orderData.getType());
//    	userCoupon.set("used_time", DateFormatUtil.format1(orderData.getCurrentTime()));
//    	userCoupon.update();
//    	logger.info("优惠券活动内"+orderData.getUserId()+"订单"+orderData.getOrderId()+"优惠后需要支付"+order.get("need_pay"));
    	OrderTransmitData orderData=(OrderTransmitData)data;
    	logger.info("优惠券活动内"+orderData.getUserId()+"订单"+orderData.getOrderId()+"优惠前需要支付"+orderData.getNeedPay());
    	TCouponReal coupon=TCouponReal.dao.findById(orderData.getCouponId());
    	if(coupon==null)
    		return;
    	TOrder order=TOrder.dao.findById(orderData.getOrderId());
    	
    	TUserCoupon userCoupon=new TUserCoupon().findUserCouponByCouponId(orderData.getCouponId());
    	//为防止出现支付金额为负数（例如：无门槛优惠券）
    	if(order.getInt("need_pay")-coupon.getInt("coupon_val")<=0){
    		order.set("need_pay", 0);
    	}else{
    		order.set("need_pay", order.getInt("need_pay")-coupon.getInt("coupon_val"));
    	}
    	order.set("discount", order.getInt("discount")+coupon.getInt("coupon_val"));
    	order.update();
    	coupon.set("status", "2");//优惠券已使用
    	coupon.update();
    	//将用户的优惠券置为无效
    	userCoupon.set("is_expire", "1");
    	userCoupon.set("used_order_id", orderData.getOrderId());
    	userCoupon.set("used_order_type", orderData.getType());
    	userCoupon.set("used_time", DateFormatUtil.format1(orderData.getCurrentTime()));
    	userCoupon.update();
    	logger.info("优惠券活动内"+orderData.getUserId()+"订单"+orderData.getOrderId()+"优惠后需要支付"+order.get("need_pay"));
    
    }

}