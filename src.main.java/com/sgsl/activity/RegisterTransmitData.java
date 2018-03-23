package com.sgsl.activity;


/**
 * 注册订阅传输数据vo类
 * @author User
 *
 */
public class RegisterTransmitData implements TransmitDataInte {
	private int userId;
	private String storeId;//门店编号
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getStoreId() {
		return storeId;
	}
	public void setStoreId(String storeId) {
		this.storeId = storeId;
	}
	
}
