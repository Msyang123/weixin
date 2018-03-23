package com.xgs.model;

import java.util.List;

import com.alibaba.fastjson.JSONArray;
import com.xgs.model.TProductF;

public class MasterProduct {
	private int id;
	private String product_name;//产品名称
	private String product_description;//产品描述
	private String main_img;//产品主图
	private String[] sub_img;//产品详细图
	private String product_unit;//产品基础单位
	private int proNum;//购物车数量
	private double money;
	private List<TProductF> product_fs;//产品的所有规格
	private JSONArray standardList;
	public String getProduct_unit() {
		return product_unit;
	}
	public void setProduct_unit(String product_unit) {
		this.product_unit = product_unit;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getMain_img() {
		return main_img;
	}
	public void setMain_img(String main_img) {
		this.main_img = main_img;
	}
	public String[] getSub_img() {
		return sub_img;
	}
	public void setSub_img(String[] sub_img) {
		this.sub_img = sub_img;
	}
	
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}
	
	public String getProduct_description() {
		return product_description;
	}
	public void setProduct_description(String product_description) {
		this.product_description = product_description;
	}
	public List<TProductF> getProduct_fs() {
		return product_fs;
	}
	public void setProduct_fs(List<TProductF> product_fs) {
		this.product_fs = product_fs;
	}

	public int getProNum() {
		return proNum;
	}
	public void setProNum(int proNum) {
		this.proNum = proNum;
	}
	public double getMoney() {
		return money;
	}
	public void setMoney(double money) {
		this.money = money;
	}
	
	
	public JSONArray getStandardList() {
		return standardList;
	}
	public void setStandardList(JSONArray standardList) {
		this.standardList = standardList;
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}
}	
