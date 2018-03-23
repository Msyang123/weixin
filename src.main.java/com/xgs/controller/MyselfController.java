package com.xgs.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TFaqDetail;
import com.sgsl.model.TFeedback;
import com.sgsl.model.TUser;
import com.sgsl.model.TUserCoupon;
import com.sgsl.model.TPayLog.PaySourceTypes;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.util.StringUtil;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.xgs.model.TOrder;
import com.xgs.model.TPayLog;
import com.xgs.model.XFruitMaster;

public class MyselfController extends BaseController{

	@Before(OAuth2Interceptor.class)
	public void me() {
		// 登录用户
		TUser tUserSession = UserStoreUtil.get(getRequest());
		JSONObject masterObj =new JSONObject();
		TUser tUser = new TUser();
		int userId = tUserSession.get("id");
		
		//TUser tUserSession = UserStoreUtil.get(getRequest());
				//TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		
		// 查找用户基本信息和积分总和
		TUser result = tUser.findTUserInfo(userId);
		if(StringUtil.isNull(result.getStr("phone_num"))){//跳转手机号码填写
			setAttr("requestUrl","${CONTEXT_PATH}/myself/me");
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/userRegister.ftl");
		}else{
			JSONObject user = ObjectToJson.modelConvert(result);
			masterObj.put("tUser", user);
			//用户是否是鲜果师
			XFruitMaster xFruitMaster = XFruitMaster.dao.findIsFruitMaster(userId);
			boolean isFruitMaster=false;
			if(xFruitMaster!=null){
				isFruitMaster=true;
				masterObj.put("master_id", xFruitMaster.get("master_id"));
			}
		    masterObj.put("isFruitMaster", isFruitMaster);
			// 查询订单信息（订单数量）
			TOrder tOrder = new TOrder();
			Record totalOrder = tOrder.findTOrderTotal(userId);//查询待付款，待收货数量
			JSONObject orderNum = ObjectToJson.recordConvert(totalOrder);
			masterObj.put("totalOrder", orderNum);
			TUserCoupon userCoupon=new TUserCoupon();
			List<Record> userCouponList=userCoupon.findTUserCoupon(userId);
			//优惠券数量
			masterObj.put("couponCount", (userCouponList==null)?0:userCouponList.size());
			setAttr("masterObj", masterObj);
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/me.ftl");
		}
	}
	
	
	@Before(OAuth2Interceptor.class)
	public void userOrder(){
		// 此处只是为了初始化页面为哪个tab项
				setAttr("type", getPara("type"));
				TUser tUserSession = UserStoreUtil.get(getRequest());
				TOrder orderOper= new TOrder();
				// 查询分类订单下的订单列表和订单中的商品信息（所有）
				List<TOrder> tOrders = orderOper.findTOrdersByUserId(tUserSession.get("id"));
				List<TOrder> qbTOrders = new ArrayList<TOrder>();
				List<TOrder> dfkTOrders = new ArrayList<TOrder>();
				List<TOrder> dshTOrders = new ArrayList<TOrder>();
				List<TOrder> thTOrders = new ArrayList<TOrder>();
				for (TOrder order : tOrders) {
					qbTOrders.add(order);
					if (order.getStr("order_status").equals("1")) {// 查询分类订单下的订单列表和订单中的商品信息（待付款）
						dfkTOrders.add(order);
					} else if (order.getStr("order_status").equals("3")) {// 查询分类订单下的订单列表和订单中的商品信息（已付款）
						dshTOrders.add(order);
					} else if (order.getStr("order_status").equals("4") || order.getStr("order_status").equals("5")
							|| order.getStr("order_status").equals("6")
							|| order.getStr("order_status").equals("7") || order.getStr("order_status").equals("8")) {// 查询分类订单下的订单列表和订单中的商品信息（退货）
						thTOrders.add(order);
					}
				}
				setAttr("qbTOrders", qbTOrders);
				setAttr("dfkTOrders", dfkTOrders);
				setAttr("dshTOrders", dshTOrders);
				setAttr("thTOrders", thTOrders);
				//renderJson(doing);
				render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/userOrder.ftl");
	}
	
	/**
	 * 商品订单详情
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before({ OAuth2Interceptor.class })
	public void userOrderDetail() {
		int id = getParaToInt("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		JSONObject orderDetail = new JSONObject();
		JSONArray orderProduct =new JSONArray();
		Record order = new com.sgsl.model.TOrder().findTOrderDetail(id, userId);
		orderDetail = ObjectToJson.recordConvert(order);
		List<Record> orderProducts = new ArrayList<Record>();
		if (order != null) {
			String orderType = order.getStr("order_type");
			orderProducts = new com.sgsl.model.TOrder().findOrderProList(id, orderType);
			if (order.getInt("order_coupon") != null) {
				orderDetail.put("coupon", TCouponCategory.dao.findById(order.getInt("order_coupon")));
			}

		}
		orderProduct = ObjectToJson.recordListConvert(orderProducts);
		orderDetail.put("orderProducts", orderProduct);
		orderDetail.put("product_num", orderProducts.size());
		setAttr("orderDetail", orderDetail);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/userOrderDetail.ftl");
	}

	/**
	 * 帮助中心-FAQ列表
	 */
	public void faqList() {
		String type = getPara("type");
		List<TFaqDetail> faqList = new TFaqDetail().findFaqByType(type);
		JSONArray faq = ObjectToJson.modelListConvert(faqList);
		JSONObject faqJson = new JSONObject();
		faqJson.put("faqList", faq);
		faqJson.put("type",type);
		setAttr("faqs", faqJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/helperCenter.ftl");
	}
	
	/**
	 * 鲜果师/用户反馈
	 */
	@Before({ OAuth2Interceptor.class })
	public void saveFeedBack(){
		String now = DateFormatUtil.format1(new Date());
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		String title =getPara("title");
		String content = getPara("content");
		TFeedback tFeedback = new TFeedback();
		tFeedback.set("fb_title", title);
		tFeedback.set("fb_content", content);
		tFeedback.set("fb_time", now);
		tFeedback.set("fb_user",userId);
		Record record =new Record();
		XFruitMaster xFruitMaster = XFruitMaster.dao.findIsFruitMaster(userId);
		int fb_type = 2;
		if(xFruitMaster != null){
			//鲜果师反馈
			fb_type = 1;
		}
		tFeedback.set("fb_type", fb_type);
		record.setColumns(model2map(tFeedback));
		boolean message = Db.save("t_feedback", record);
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("status", message);
		if(message){
			result.put("message", "success");
		}else{
			result.put("message", "failure");
		}
		renderJson(result);
	}
	
	/**
	 * 鲜果师我的余额
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void myRest() throws UnsupportedEncodingException {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = new TUser().findById(tUserSession.get("id"));
		setAttr("user", ObjectToJson.modelConvert(user));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myRest.ftl");
	}
	
	/**
	 * 鲜果师余额明细
	 */
	public void myRestDetail() {
		TUser user = UserStoreUtil.get(getRequest());
		List<Record> tPayLogs = new TPayLog().findXgTPayLogByUserId(user.get("open_id"), PaySourceTypes.RECHARGE);
		setAttr("payLogs", tPayLogs);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myRestDetail.ftl");
	}
	
	
}
