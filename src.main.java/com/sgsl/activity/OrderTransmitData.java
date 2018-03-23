package com.sgsl.activity;

import java.util.Date;
import java.util.Map;

import com.sgsl.model.TOrder;
import com.sgsl.model.TPresent;

/**
 * 订单订阅传输数据vo类
 * @author User
 *
 */
public class OrderTransmitData implements TransmitDataInte {
	private int userId;
	private int orderId;
	private int needPay;//支付订单金额
	private int couponId;//优惠券
	private Map<String,Object> ext;//扩展信息
	private Date currentTime;//订单创建时间
	private String type;//订单类型 gm购买 zs赠送
	private TOrder order;//订单信息
	private TPresent present;//赠送信息
	private String storeId;//门店编号
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public int getNeedPay() {
		return needPay;
	}
	public void setNeedPay(int needPay) {
		this.needPay = needPay;
	}
	
	public int getCouponId() {
		return couponId;
	}
	public void setCouponId(int couponId) {
		this.couponId = couponId;
	}
	public Date getCurrentTime() {
		return currentTime;
	}
	public void setCurrentTime(Date currentTime) {
		this.currentTime = currentTime;
	}
	public TOrder getOrder() {
		return order;
	}
	public void setOrder(TOrder order) {
		this.order = order;
	}
	public TPresent getPresent() {
		return present;
	}
	public void setPresent(TPresent present) {
		this.present = present;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Map<String, Object> getExt() {
		return ext;
	}
	public void setExt(Map<String, Object> ext) {
		this.ext = ext;
	}
	public String getStoreId() {
		return storeId;
	}
	public void setStoreId(String storeId) {
		this.storeId = storeId;
	}
	
	
}
