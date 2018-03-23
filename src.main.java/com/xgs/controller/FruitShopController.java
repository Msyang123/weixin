package com.xgs.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MCarousel;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TOrder;
import com.xgs.model.TProductF;
import com.xgs.model.XAchievementRecord;
import com.sgsl.model.TStore;
import com.sgsl.model.TUser;
import com.sgsl.util.HdUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.TwitterIdWorker;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.xgs.model.XFruitMaster;
import com.xgs.model.XMasterUser;

public class FruitShopController extends BaseController{
	protected final static Logger logger = Logger.getLogger(FruitShopController.class);
	private TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);
	
	//访问次数标记
	private AtomicInteger viewTimes= new AtomicInteger(0);
	
	private Map<String,Object> cacheMap=new ConcurrentHashMap<String,Object>(20);
	
	/**
	 * 鲜果师首页初始化
	 * 
	 * @throws IOException
	 */
	public void indexMaster(){
		int viewTimesLocal = viewTimes.get();
		//设置用户入口的来源，默认为空，也可能是code(二维码入口)
		setSessionAttr("from", getPara("from"));
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		if(StringUtil.isNull(user.getStr("phone_num"))){
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/member_mobile.ftl");
		}else{
			if(viewTimesLocal==100){
				viewTimes.set(0);
			}else{
				viewTimes.addAndGet(1);
			}
			// 鲜果师首页轮播图
			List<Record> mCarousels=(List<Record>)cacheMap.get("mCarousels");
			if(mCarousels==null||viewTimesLocal==0){
				MCarousel mCarousel = new MCarousel();
				mCarousels = mCarousel.findMCarousels(1);
				cacheMap.putIfAbsent("mCarousels",mCarousels);
			}
			setAttr("mCarousels", mCarousels);
			
			//明星鲜果师
			List<Record> xFreshFruits=(List<Record>)cacheMap.get("xFreshFruit");
			if(xFreshFruits==null||viewTimesLocal==0){
				XFruitMaster xFreshFruit = new XFruitMaster();
				xFreshFruits = xFreshFruit.findMasterStar();
				cacheMap.putIfAbsent("xFreshFruits",xFreshFruits);
			}
			setAttr("xFreshFruits", xFreshFruits);
			
			//食鲜之味文章
			List<Record> xArticles=(List<Record>)cacheMap.get("xArticle");
			if(xArticles==null||viewTimesLocal==0){
				xArticles = Db.find("select * from x_article");
				cacheMap.putIfAbsent("xArticles",xArticles);
			}
			setAttr("xArticles", xArticles);
		}
	}
	
	
	/**
	 * 购物车页面
	 * 
	 * @throws Exception
	 */
	public void cart() throws Exception {
		// 获取到购物车中商品信息
		String xgCartInfo = getCookie("xgCartInfo");
		//xgCartInfo=xgCartInfo.replaceAll("#", ",");
		List<Map<String, Object>> proList = new ArrayList<Map<String, Object>>();
		double sum = 0.00;
		boolean cookieNull = false;
		if (StringUtil.isNotNull(xgCartInfo)) {
			JSONArray xgcartInfoJson = JSONArray.parseArray(URLDecoder.decode(xgCartInfo, "UTF-8"));
			JSONArray xgcartInfoJsonCopy = new JSONArray();
			for (int i = 0; i < xgcartInfoJson.size(); i++) {
				JSONObject item = xgcartInfoJson.getJSONObject(i);
				if (StringUtil.isNull(item.getString("pf_id"))) {
					continue;
				}
				int pfId = item.getInteger("pf_id");
				Record product = Db.findFirst(
						"select p.*,i.save_string,pf.product_unit,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.product_amount,pf.id as pf_id,pf.comments,c.unit_name,u.unit_name as base_unitname "
								+ " from t_product_f pf left join t_product p"
								+ " on p.id=pf.product_id left join t_image i on p.img_id=i.id "
								+ "left join t_unit c on pf.product_unit=c.unit_code "
								+ "left join t_unit u on p.base_unit=u.unit_code " + "where pf.id=?",
						pfId);
				if(product==null){
					cookieNull = true;
					continue;
				}else{
					xgcartInfoJsonCopy.add(item);
				}
				int productNum = item.getInteger("product_num");
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("product", product);
				map.put("productNum", productNum);
				proList.add(map);
				// 商品价格乘以商品数量 除以100换算成元
				sum += (product.getInt("real_price") == null ? 0 : product.getInt("real_price")) * productNum;
			}
			if(cookieNull){
				setCookie("xgCartInfo", xgcartInfoJsonCopy.toJSONString(), 604800);
			}
		}
		setAttr("sum", sum);
		setAttr("proList", proList);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/cart.ftl");
	}
	
	
	/**
	 * 跳转到商品订单页
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void order() throws UnsupportedEncodingException {
		TUser user = UserStoreUtil.get(getRequest());
		if(StringUtil.isNull(user.getStr("phone_num"))){//跳转手机号码填写
			setAttr("requestUrl","${CONTEXT_PATH}/fruitShop/cart");
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/userRegister.ftl");
			return;
		}
		String currDate = DateFormatUtil.format4(new Date());
		setAttr("currDate", currDate);
		List<Record> storeList = new TStore().findStores();
		
		setAttr("storeList", storeList);
		String xgCartInfo = getCookie("xgCartInfo");// 从cookie中取得商品信息
		//xgCartInfo=xgCartInfo.replaceAll("#", ",");
		String pId=getPara("pId");//商品编号
		String pfId=getPara("pfId");//规格编号
		int totalPrice = 0;
		int[] pfIds=null;
		/*TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		setAttr("user", user);*/
		if(StringUtil.isNotNull(pId)&&StringUtil.isNotNull(pfId)){
			Record product = new TProductF().findTProductFById(Integer.parseInt(pfId));
			totalPrice=product.getInt("real_price");
			//只是买一个商品
			String productInfo=getCookie("productInfo");
			if(StringUtil.isNotNull(productInfo)){
				removeCookie("productInfo");
			}
			setCookie("productInfo","[{'product_id':"+pId+"#'product_num':1#'pf_id':"+pfId+"}]",604800);
			setAttr("isSingle", 1);
		}else if (StringUtil.isNotNull(xgCartInfo)) {
			//购物车商品
			JSONArray xgCartInfoJson = JSONArray.parseArray(URLDecoder.decode(xgCartInfo, "UTF-8"));
			logger.info("======order方法xgCartInfo:"+xgCartInfoJson.toJSONString());
			String selectList = getPara("selectList");
			JSONArray selectProductList = JSONArray.parseArray(URLDecoder.decode(selectList, "UTF-8"));
			logger.info("======order方法selectList:"+selectProductList.toJSONString());
			pfIds=new int[selectProductList.size()];
			for(int i=0; i<selectProductList.size();i++){
				JSONObject item = selectProductList.getJSONObject(i);
				int pf_Id = item.getInteger("pf_id");
				//装载到数值中用于下面优惠券活动中屏蔽操作
				pfIds[i]=pf_Id;
				int productNum = item.getInteger("product_num");
				int productId = item.getInteger("product_id");
			//	needRemove.add(item);
				Record product = new TProductF().findTProductFById(pf_Id);
				int realPrice=product.getInt("real_price");
				
				totalPrice += product.getInt("real_price") * productNum;
			}
			setCookie("selectProduct", selectProductList.toJSONString().replaceAll("\"", "'"),604800);
			//xgCartInfoJson.removeAll(selectProductList);
			String v = xgCartInfoJson.toJSONString();//.replaceAll("\"", "'");
			setCookie("xgCartInfo", v,604800);
			
			setAttr("isSingle", 0);
		} 
		setAttr("balance", totalPrice);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/order.ftl");
	}

	/**
	 * 确认订单
	 * @throws UnsupportedEncodingException
	 * 
	 */
	public void orderCmt() throws UnsupportedEncodingException {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		String now = DateFormatUtil.format1(new Date());
		TOrder order = getModel(TOrder.class, "order");
		Record record = new Record();
		record.setColumns(model2map(order));
		record.set("createtime", now);
		//直接单独购买1或者购物车购买0
		int isSingle=StringUtil.isNull(getPara("isSingle"))?0:getParaToInt("isSingle");
		String selectProduct = isSingle==0?getCookie("selectProduct"):getCookie("productInfo");// 从cookie中取得商品信息
		if(StringUtil.isNull(selectProduct)){
			redirect("/myself/userOrder?type=1");
			return;
		}
		
		
		selectProduct=selectProduct.replaceAll("#", ",");
		int totalPrice = 0;// 商品总金额
		int discount = 0;// 优惠金额
		int needPay = 0;// 应付金额
		List<Map<String, Integer>> orderProducts = new ArrayList<Map<String, Integer>>();
		if (StringUtil.isNotNull(selectProduct)) {
			
			JSONArray selectProductJson = JSONArray.parseArray(URLDecoder.decode(selectProduct, "UTF-8"));
			logger.info("========orderCmt方法selectProduct:"+selectProductJson.toJSONString());
			for (int i = 0; i < selectProductJson.size(); i++) {
				JSONObject item = selectProductJson.getJSONObject(i);
				int pf_Id = item.getInteger("pf_id");
				int productId = item.getInteger("product_id");
				int productNum = item.getInteger("product_num");
				Record product = new TProductF().findTProductFById(pf_Id);
				totalPrice += product.getInt("real_price") * productNum;
				Map<String, Integer> map = new HashMap<String, Integer>();
				map.put("pfId", pf_Id);
				map.put("productId", productId);
				map.put("productNum", productNum);
				map.put("unitPrice", product.getInt("real_price") * productNum);
				orderProducts.add(map);
			}
			//如果是购物车结算
			String xgCartInfo = getCookie("xgCartInfo");// 从cookie中取得商品信息
			if(StringUtil.isNotNull(xgCartInfo)){
				JSONArray xgCartInfoJson = JSONArray.parseArray(URLDecoder.decode(xgCartInfo, "UTF-8"));
				logger.info("=======orderCmt方法xgCartInfo:"+xgCartInfoJson.toJSONString());
				xgCartInfoJson.removeAll(selectProductJson);
				setCookie("xgCartInfo", xgCartInfoJson.toJSONString(),604800);
			}
			
		} else {
			redirect("/myself/userOrder?type=1");
			return;
		}
		
		int userId = tUserSession.get("id");
		//优惠券编号
		Integer coupon =null;
		if(order.get("order_coupon")!=null){
			coupon=order.getInt("order_coupon");
		}	
		//优惠信息在订阅活动中处理
		
		//该用户是否有关联的鲜果师
		XMasterUser xMasterUser = XMasterUser.dao.findXUser(userId);
		if(xMasterUser!=null){
			Record master = Db.findById("x_fruit_master", xMasterUser.get("master_id"));
			if(master.getInt("master_status")==3){
				record.set("master_id", xMasterUser.get("master_id"));
			}
		}
		record.set("order_user", userId);
		needPay = totalPrice;
		record.set("total", totalPrice);
		record.set("order_coupon", coupon);
		record.set("discount", discount);
		record.set("need_pay", needPay);
		record.set("order_id", orderNoGenerator.nextId());
		record.set("order_status", "1");
		record.set("order_source", 1);
		Db.save("t_order", record);
		//收集用户手机号并且填到用户信息中
		if(StringUtil.isNull(tUserSession.getStr("phone_num"))){
			String phoneNum=getPara("phone_num");
			//先取界面联系方式,如果为空就取订单地址中的联系方式
			if(StringUtil.isNull(phoneNum)){
				phoneNum=getPara("order.receiver_mobile");
			}
			tUserSession.set("phone_num", phoneNum);
			tUserSession.update();
			//发送数据到海鼎进行注册
			HdUtil.registUser("07310109", phoneNum, phoneNum);
		}
		
		//购买 赠送不做优惠券领取
    	TOrder orderOper=new TOrder();
		long id = record.getLong("id");
		TOrder orderAfterDiscount=orderOper.findTOrderByOrderId(record.getStr("order_id"));
		discount=(orderAfterDiscount.getInt("discount")==null)?0:orderAfterDiscount.getInt("discount");//订单优惠价格
		totalPrice=(orderAfterDiscount.getInt("total")==null)?orderAfterDiscount.getInt("need_pay"):orderAfterDiscount.getInt("total");//订单总价 赠送订单不会存储总价
		//单位折扣率
		double unitDiscount=discount/(1.0*totalPrice);
		for (Map<String, Integer> pro : orderProducts) {
			Record orderPro = new Record();
			orderPro.set("order_id", id);
			orderPro.set("product_id", pro.get("productId"));
			orderPro.set("product_f_id", pro.get("pfId"));
			orderPro.set("amount", pro.get("productNum"));
			orderPro.set("unit_price", pro.get("unitPrice"));
			orderPro.set("buy_time", now);
			//单品总价 减掉分摊优惠金额
			orderPro.set("pay_price", (1-unitDiscount)*pro.get("unitPrice"));
			Db.save("t_order_products", orderPro);
		} 
		
		//setCookie("xgCartInfo", xgCartInfoJson.toJSONString(),604800);
		redirect("/pay/payFruitmasterPayment?id=" + id);
	}
	
	
	/**
	 * 订单提交
	 * 
	 * @throws UnsupportedEncodingException
	 */
	/*@Before({ OAuth2Interceptor.class })
	public void sbmtOrder() {
		long id = getParaToLong("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		setAttr("order", new TOrder().findTOrderById(id, userId));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/payment.ftl");
	}*/
	
	/**
	 * 退款（未备货状态下）(暂无部分退货)
	 * @throws Exception 
	 */
	public void hdCancelOrder() throws Exception{
		JSONObject jsonResult=new JSONObject();
		jsonResult.put("success", false);
		jsonResult.put("message", "未找到订单");
		int id=getParaToInt("hdCancelOrderId");
		TOrder oper=new TOrder();
		TOrder order= oper.findById(id);
		if(order!=null&&"3".equals(order.getStr("order_status"))){
			//是别人的客户，此时就需要添加一条收支明细
			Record orderRecord = Db.findFirst("select * from t_order where id = ?",id);
			if(StringUtil.isNotNull(String.valueOf(orderRecord.getInt("master_id")))){
				XAchievementRecord.dao.addXAchievementRecord(orderRecord, 4);
			}
			//设置成取消中
			oper.updateReason(id,order.getInt("order_user"),"3","7",getPara("reason"));
			//取消订单为所有订单商品都是退货状态
			List<Record> orderProList=oper.findOrderProList(id);
			for(Record item:orderProList){
				item.set("is_back", "Y");
				Db.update("t_order_products",item); 
			}
			//改订单为退款完成并退款	
			String hdCancelOrderResult= HdUtil.orderCancel(order.getStr("order_id"),order.getStr("reason"));
			//code=200{...}
			if(hdCancelOrderResult!=null){
				//去掉 code=200
				hdCancelOrderResult=hdCancelOrderResult.substring(8);
				jsonResult=JSONObject.parseObject(hdCancelOrderResult);
				//调用成功
				if(jsonResult.getBooleanValue("success")){
					StringBuffer sql=new StringBuffer();
		    		sql.append("select t.order_type,t.order_user,t.order_store,t.order_id,t.need_pay,p.out_trade_no,p.source_type,p.source_table from t_order t ");
		    		sql.append(" left join t_pay_log p ");
		    		sql.append(" on t.order_id=p.out_trade_no ");
		    		sql.append(" where t.order_id=? ");
		    		
		    		Record pay= Db.findFirst(sql.toString(),order.getStr("order_id"));
		    		//赠送提货订单或者余额支付订单，直接转成用户余额
		    		if("2".equals(pay.getStr("order_type"))||("t_user".equals(pay.getStr("source_table"))&&"balance".equals(pay.getStr("source_type"))&&
		    					StringUtil.isNotNull(pay.getStr("out_trade_no"))&&pay.getStr("out_trade_no").length()==18)){
		    			//修改订单为已退款
		    			if(oper.updateStatus(order.getInt("id"), order.getInt("order_user"),"7", "6")==1){
			    			//加果币
			    			Db.update("update t_user set balance=balance+? where id=?",
			    					pay.getInt("need_pay"),
			    					pay.getInt("order_user"));
			    			//增加加果币记录
			    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
			    			tBlanceRecord.set("store_id", pay.getStr("order_store"));
			    			tBlanceRecord.set("user_id", order.getInt("order_user"));
			    			tBlanceRecord.set("blance", pay.getInt("need_pay"));
			    			tBlanceRecord.set("ref_type", "orderBack");
			    			tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
			    			tBlanceRecord.set("order_id", order.getStr("order_id"));
			    			tBlanceRecord.save();
			    			logger.info("赠送提货订单或者余额支付订单，直接转成用户余额:"+order.getStr("order_id")+"-blance:"+pay.getInt("need_pay"));
			    			jsonResult.put("success", false);
		    				jsonResult.put("message", "取消订单成功，直接转成用户余额");
		    			}else{
		    				jsonResult.put("success", false);
		    				jsonResult.put("message", "修改订单状态失败");
		    			}
		    		}else{
		    			//直接支付订单 可能存在调货，调货要根据原始订单编号退货
		    			String result=WeChatUtil.refund(StringUtil.isNotNull(order.getStr("old_order_id"))?order.getStr("old_order_id"):order.getStr("order_id"),
		    					pay.getInt("need_pay"),
		    					new File(getRequest().getSession().getServletContext().getRealPath("/WEB-INF/classes/apiclient_cert.p12")));
		    			logger.info("直接支付订单result:"+result);
		    			if(result.indexOf("SUCCESS")!=-1){
		    				jsonResult.put("success", true);
		    				jsonResult.put("message", "取消订单成功，直接支付订单已经申请微信退款");
		    				oper.updateStatus(order.getInt("id"), order.getInt("order_user"),"7", "6");	
		    			}else{
		    				jsonResult.put("success", false);
		    				jsonResult.put("message", "直接支付订单申请微信退款失败");
		    			}
		    		}
		    		logger.info("订单编号："+order.getStr("order_id")+"发送海鼎取消订单成功");
			  }
			    jsonResult.put("success", true);
			    jsonResult.put("message", "订单取消申请成功");
			}else{
				jsonResult.put("message", "调用接口失败，请联系客服");
			}
		}else if("1".equals(order.getStr("hd_status"))){
			jsonResult.put("success", false);
			jsonResult.put("message", "订单海鼎发送状态为失败");
		}
		renderJson(jsonResult);
	}
	
}

