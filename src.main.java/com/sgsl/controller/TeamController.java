package com.sgsl.controller;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.revocn.controller.BaseController;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MTeamBuyScale;

public class TeamController extends BaseController{

	protected final static Logger logger = Logger.getLogger(TeamController.class);
	
	/**
	 * 根据商品上下架是否成团
	 */
	public void isTeamSuccess(){
		int teamBuyScaleId = getParaToInt("teamBuyScaleId");
		JSONObject mes = new JSONObject();
		boolean flag=false;
		MTeamBuyScale teamBuyScale = MTeamBuyScale.dao.findById(teamBuyScaleId);
		if(teamBuyScale!=null){
			MActivityProduct activityProduct = MActivityProduct.dao.findFirst("select * from m_activity_product where id=?", teamBuyScale.getInt("activity_product_id"));
			if(activityProduct.getInt("status")==1){
				flag=true;
			}else{
				flag=false;
			}
		}
		mes.put("flag", flag);
		renderJson(mes);
	}
}
