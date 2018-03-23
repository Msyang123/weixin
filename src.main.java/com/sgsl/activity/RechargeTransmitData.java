package com.sgsl.activity;

/**
 * 充值订阅传输数据vo类
 * @author User
 *
 */
public class RechargeTransmitData implements TransmitDataInte {
	private String userId;
	private int recharge;//充值金额 分
	private String outTradeNo;//交易流水号
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getRecharge() {
		return recharge;
	}
	public void setRecharge(int recharge) {
		this.recharge = recharge;
	}
	public String getOutTradeNo() {
		return outTradeNo;
	}
	public void setOutTradeNo(String outTradeNo) {
		this.outTradeNo = outTradeNo;
	}
	
	
}
