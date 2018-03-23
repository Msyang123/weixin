package com.sgsl.model;

import java.util.ArrayList;
import java.util.List;

import com.jfinal.plugin.activerecord.Record;

/**
 * 首页底部活动-商品列表
 * @author yijun
 *
 */
public class Activitys {
	private List<BottomActivity> bottomActivity=new ArrayList<>();
	
	public List<BottomActivity> getBottomActivity() {
		return bottomActivity;
	}


	public void setBottomActivity(List<BottomActivity> bottomActivity) {
		this.bottomActivity = bottomActivity;
	}
	
	
	public class BottomActivity{
		private String imgSrc;
		private String url;
		private String id;
		private List<Record> products;
		public String getImgSrc() {
			return imgSrc;
		}
		public void setImgSrc(String imgSrc) {
			this.imgSrc = imgSrc;
		}
		public String getUrl() {
			return url;
		}
		public void setUrl(String url) {
			this.url = url;
		}
		public List<Record> getProducts() {
			return products;
		}
		public void setProducts(List<Record> products) {
			this.products = products;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		
		
	}
}
