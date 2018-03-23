package com.sgsl.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.DbKit;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.activity.ConcreteWatched;
import com.sgsl.activity.OrderActivity3Watcher;
import com.sgsl.activity.OrderActivity4Watcher;
import com.sgsl.activity.OrderActivity5Watcher;
import com.sgsl.activity.OrderActivity6Watcher;
import com.sgsl.activity.OrderActivity8Watcher;
import com.sgsl.activity.OrderTransmitData;
import com.sgsl.activity.RechargeActivityWatcher;
import com.sgsl.activity.RechargeJggWatcher;
import com.sgsl.activity.RechargeTransmitData;
import com.sgsl.activity.RefererWatcher;
import com.sgsl.activity.Watched;
import com.sgsl.activity.Watcher;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MCarousel;
import com.sgsl.model.MTeamBuy;
import com.sgsl.model.MTeamBuyScale;
import com.sgsl.model.MTeamMember;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TDeliverNote;
import com.sgsl.model.TIndexSetting;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPayLog;
import com.sgsl.model.TPayLog.PaySourceTypes;
import com.sgsl.model.TPresent;
import com.sgsl.model.TStock;
import com.sgsl.model.TStore;
import com.sgsl.model.TUser;
import com.sgsl.model.TUserCoupon;
import com.sgsl.util.GiveSeed;
import com.sgsl.util.HdUtil;
import com.sgsl.util.PushUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.TwitterIdWorker;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.sgsl.wechat.util.XNode;
import com.sgsl.wechat.util.XPathParser;
import com.sgsl.wechat.util.XPathWrapper;
import com.xgs.model.XAchievementRecord;

/**
 * 微信支付
 * 
 * @author User
 *
 */
public class PaymentController extends BaseController {
	protected final static Logger logger = Logger.getLogger(PaymentController.class);
	protected static final int ORDER_TIMEFRAME = 6;// 订单时限，单位分钟
	protected String encoding = "UTF-8";

	/**
	 * 订单提交
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before({ OAuth2Interceptor.class })
	public void sbmtOrder() {
		long id = getParaToLong("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		setAttr("order", new TOrder().findTOrderById(id, userId));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/payment.ftl");
	}

	/**
	 * 赠送支付页
	 */
	@Before({ OAuth2Interceptor.class })
	public void sbmtPresent() {
		int presentId = getParaToInt("present_id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record present = new TPresent().findTPresentById(presentId, userId);
		setAttr("present", present);
		List<Record> presentPros = new ArrayList<Record>();
		if (present != null) {
			presentPros = new TPresent().findPresentProList(presentId);
		}
		setAttr("presentProducts", presentPros);
		setAttr("productNum", presentPros.size());
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/present_payment.ftl");
	}

	/**
	 * 订单详情
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before({ OAuth2Interceptor.class })
	public void orderDetail() {
		int id = getParaToInt("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record order = new TOrder().findTOrderDetail(id, userId);
		setAttr("order", order);
		List<Record> orderProducts = new ArrayList<Record>();
		if (order != null) {
			String orderType = order.getStr("order_type");
			orderProducts = new TOrder().findOrderProList(id, orderType);
			if (order.getInt("order_coupon") != null) {
				setAttr("coupon", TCouponCategory.dao.findById(order.getInt("order_coupon")));
			}
			//查找种子购活动是否开启
			MActivity mactivity = MActivity.dao.findYxActivityByType(18);
			//查看是否是单线订单（非团购订单）
			Record record = Db.findFirst("select * from m_team_member where order_id = ?",order.getStr("order_id"));
			if(order.getInt("order_style")!=null && order.getInt("order_style")==2 && order.getStr("createtime").compareTo("2018-01-01 00:00:00")>=0){//兑换订单不能退货
				setAttr("isVisible", "false");
			}else{
				//活动开启且单线，不让直接退货
				if(mactivity!=null&&record==null){//退货按钮
					setAttr("isVisible", "false");
				}else{
					setAttr("isVisible", "true");
				}
			}
		}
		setAttr("orderProducts", orderProducts);
		setAttr("product_num", orderProducts.size());
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myOrder_detail.ftl");
	}

	/**
	 * 赠送详情
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before({ OAuth2Interceptor.class })
	public void presentDetail() {
		int id = getParaToInt("id");
		String type = getPara("type");
		setAttr("type", type);
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record present = new TPresent().findTPresentDetail(id, userId, type);
		setAttr("present", present);
		List<Record> presentProducts = new ArrayList<Record>();
		if (present != null) {
			presentProducts = new TPresent().findPresentProList(id);
		}
		setAttr("presentProducts", presentProducts);
		setAttr("product_num", presentProducts.size());
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myPresent_detail.ftl");
	}

	/**
	 * 微信支付 orderId
	 * @throws Exception 
	 */
	@Before({ OAuth2Interceptor.class })
	public void order() throws Exception {
		TUser sessionUser = UserStoreUtil.get(getRequest());
		Record user = Db.findById("t_user", sessionUser.get("id"));
		Map<String, Object> ret = new HashMap<>();
		ret.put("state", "failure");
		String orderId = getPara("orderId");
		Record order = Db.findFirst(
				"select * from t_order where order_id = ? and order_status = '1' and order_user = ?", orderId,
				user.get("id"));
		if (order == null) {
			ret.put("msg", "订单不存在！");
			renderJson(ret);
			return;
		}
		if ("0".equals(order.getStr("order_status"))) {
			ret.put("msg", "订单超时，请重新下单！");
			renderJson(ret);
			return;
		}
		// 此处存在漏洞，可能导致下架商品订单刚好订单金额为0，然后可以提交到门店
		if (order.getInt("need_pay") < 0) {
			ret.put("msg", "无效金额！");
			renderJson(ret);
			return;
		}
		//需要支付配送费
		if (user.getInt("balance") >= order.getInt("need_pay")+order.getInt("delivery_fee")) {
			String currentTime = WeChatUtil.getCurrTime("yyyy-MM-dd HH:mm:ss:SSS");
			// 余额支付
			boolean success = balancePayOrder(user, order, currentTime);
			if (!success) {
				try {
					DbKit.getConfig().getThreadLocalConnection().rollback();
				} catch (SQLException e) {
				}
				ret.put("msg", "余额支付失败");
			} else {
				TPayLog paylog = new TPayLog();
				paylog.balancePaySaveLog(user.get("open_id"), PaySourceTypes.BALANCE, order.getInt("need_pay")+order.getInt("delivery_fee"),
						orderId);
				ret.put("state", "success");
				ret.put("msg", "余额支付成功");
				/*long time = 30*60*1000;//30分钟
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date now=new Date(new Date().getTime()+time);
				String e=order.getStr("deliverytime");
				 String[] b=e.split(" ");
			        String date=b[0];//日期 2018-02-28
			        String[] d=b[1].split("-");
			        String time1=d[0];//时间 15:55:00
			        String deliverytime = date + " "
			                + time1+":00";
			        //送货上门的单  当前时间加30钟大于等于开始发蜂鸟配送时间
				if("2".equals(order.getStr("deliverytype"))&&(sdf.format(now)).compareTo(deliverytime)>=0){
					Db.update("update t_order set hd_status = '2' where order_id = ?", orderId);
				}else{
					logger.info("===========余额支付海鼎减商品库存start==============");
					if (HdUtil.orderReduce(orderId)) {
						Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
						logger.info("=========写入送货上门订单=================");
						new TDeliverNote().saveDeliverNote(order.getStr("order_id"),order.getStr("order_store"),1);
					} else {
						TIndexSetting setting = new TIndexSetting();
						Map<String, String> map = setting.getIndexSettingMap();
						PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
						Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
					}
				}*/
				
				logger.info("===========余额支付海鼎减商品库存start==============");
				if (HdUtil.orderReduce(orderId)) {
					int updateLine=Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
					//送货上门订单
					if(updateLine==1&&"2".equals(order.getStr("deliverytype"))){
						logger.info("=========写入送货上门订单配送=================");
						new TDeliverNote().saveDeliverNote(order.getStr("order_id"),order.getStr("order_store"),1,"5",null,order.getInt("delivery_fee"));
					}
				} else {
					TIndexSetting setting = new TIndexSetting();
					Map<String, String> map = setting.getIndexSettingMap();
					PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
					Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
				}
				logger.info("===========余额支付海鼎减商品库存end==============");
			}
			renderJson(ret);
			return;
		} else {
			// 微信支付
			logger.info("=================账户余额不足, 开始微信预支付===============");
			String currTime = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			String strTime = currTime.substring(8, currTime.length());
			String nonce = strTime + WeChatUtil.buildRandom(4);
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			cal.add(Calendar.MINUTE, ORDER_TIMEFRAME);// 注意：最短失效时间间隔必须大于5分钟
			String timeExpire = WeChatUtil.getTime(cal.getTime(), "yyyyMMddHHmmss");
			String timeStart = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			logger.info("=================开始微信签名===============");

			SortedMap<Object, Object> packageParams = new TreeMap<Object, Object>();
			packageParams.put("appid", AppProps.get("appid"));
			packageParams.put("mch_id", AppProps.get("partner_id"));
			packageParams.put("nonce_str", nonce);// 随机串
			packageParams.put("body", "水果熟了 - 微商城订单支付");// 描述
			packageParams.put("attach", "");// 附加数据
			packageParams.put("out_trade_no", order.get("order_id"));// 商户订单号
			packageParams.put("total_fee", order.getInt("need_pay")+order.getInt("delivery_fee"));// 微信支付金额单位为（分） 应付金额+配送费
			packageParams.put("time_start", timeStart);// 订单生成时间
			packageParams.put("time_expire", timeExpire);// 订单失效时间
			packageParams.put("spbill_create_ip", WeChatUtil.getRemoteAddr(getRequest()));// 订单生成的机器
			// IP

			packageParams.put("notify_url", AppProps.get("app_domain") + "/pay/orderCallback");// 支付完成后微信发给该链接信息，可以判断会员是否支付成功，改变订单状态等。
			packageParams.put("trade_type", "JSAPI");
			packageParams.put("openid", user.get("open_id"));
			String sign = WeChatUtil.createSign(AppProps.get("partner_key"), packageParams); // 获取签名
			
			//WeChatUtil.getSandboxnewKey()
			packageParams.put("sign", sign);
			String xml = WeChatUtil.getRequestXml(packageParams); // 获取请求微信的XML
			logger.info("=================获取预支付ID===============" + xml);
			String prepay_id = WeChatUtil.sendWeChatGetPrepayId(xml);
			if (StringUtil.isNull(prepay_id)) {
				ret.put("msg", "微信预支付出错（无法获取预支付编号）");
				ret.put("resouce_from", 0);
				renderJson(ret);
				return;
			}
			logger.info("=================微信预支付成功，生成JSAPI签名===============");
			SortedMap<Object, Object> finalpackage = new TreeMap<Object, Object>();
			finalpackage.put("appId", AppProps.get("appid"));
			String timestamp = Long.toString(System.currentTimeMillis() / 1000);
			finalpackage.put("timeStamp", timestamp);
			finalpackage.put("nonceStr", nonce);
			String packages = "prepay_id=" + prepay_id;
			finalpackage.put("package", packages);
			finalpackage.put("signType", "MD5");
			String finalsign = WeChatUtil.createSign(AppProps.get("partner_key"), finalpackage);

			// JSAPI弹出用户充值成功后的提示页面，用户点击右上角"完成"按钮，JSAPI通知微信支付成功，可以回调了
			logger.info("=================响应到JSAPI，完成微信支付===============");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("appid", AppProps.get("appid"));
			map.put("timeStamp", timestamp);
			map.put("nonceStr", nonce);
			map.put("packageValue", packages);
			map.put("sign", finalsign);
			map.put("orderId", order.get("order_id"));
			String userAgent = getRequest().getHeader("user-agent");
			char agent = userAgent.charAt(userAgent.indexOf("MicroMessager") + 15);
			map.put("agent", new String(new char[] { agent }));

			// 后台修改订单为支付中状态
			Db.update("update t_order set order_status = ?, pay_time = ? where order_id = ?", "2",
					WeChatUtil.getCurrTime("yyyy-MM-dd HH:mm:ss:SSS"), orderId);
			renderJson(map);
		}
	}
	
	
	/**
	 * 微信支付 orderId
	 * @throws Exception 
	 */
	@Before({ OAuth2Interceptor.class })
	public void present() throws Exception {
		TUser sessionUser = UserStoreUtil.get(getRequest());
		Record user = Db.findById("t_user", sessionUser.get("id"));
		Map<String, Object> ret = new HashMap<>();
		ret.put("state", "failure");
		String presentId = getPara("presentId");
		Record present = Db.findFirst(
				"select * from t_present where id = ? and present_status = '1' and present_user = ?", presentId,
				user.get("id"));
		if (present == null) {
			ret.put("msg", "订单不存在！");
			renderJson(ret);
			return;
		}
		if ("0".equals(present.getStr("present_status"))) {
			ret.put("msg", "订单超时，请重新下单！");
			renderJson(ret);
			return;
		}
		if (present.getInt("need_pay") < 0) {
			ret.put("msg", "无效金额！");
			renderJson(ret);
			return;
		}
		if (user.getInt("balance") >= present.getInt("need_pay")) {
			String currentTime = WeChatUtil.getCurrTime("yyyy-MM-dd HH:mm:ss:SSS");
			// 余额支付
			boolean success = balancePayPresent(user, present, currentTime);
			if (!success) {
				try {
					DbKit.getConfig().getThreadLocalConnection().rollback();
				} catch (SQLException e) {
				}
				ret.put("msg", "余额支付失败");
			} else {
				int id = Integer.parseInt(presentId);
				List<Record> presentPros = new TPresent().findProList(id);
				int userId = present.getInt("target_user");
				TStock stock = new TStock().getStockByUser(userId);
				int stockId = stock.getInt("id");
				for (Record pro : presentPros) {
					Record stockProduct = new Record();
					stockProduct.set("stock_id", stockId);
					stockProduct.set("product_f_id", pro.get("pf_id"));
					stockProduct.set("product_id", pro.get("product_id"));
					stockProduct.set("unit_price", pro.get("unit_price"));
					stockProduct.set("amount", pro.get("amount"));
					stockProduct.set("get_time", DateFormatUtil.format1(new Date()));
					Db.save("t_stock_product", stockProduct);
				}
				TUser target = new TUser().findById(userId);
				if (StringUtil.isNotNull(target.get("phone_num"))) {
					String nickname = user.get("nickname");
					String sourceMobile = user.get("phone_num");
					if (nickname == null) {
						nickname = "";
					}
					if (sourceMobile == null) {
						sourceMobile = "";
					}
					String nickString = nickname + "(" + sourceMobile + ")";
					PushUtil.sendPresentMsgToUser(target.get("phone_num"), nickString);
				}

				TPayLog paylog = new TPayLog();
				paylog.balancePaySaveLog(user.get("open_id"), PaySourceTypes.BALANCE, present.getInt("need_pay"),
						presentId);
				ret.put("state", "success");
				ret.put("msg", "余额支付成功");
			}
			renderJson(ret);
			return;
		} else {
			// 微信支付
			logger.info("=================账户余额不足, 开始微信预支付===============");
			String currTime = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			String strTime = currTime.substring(8, currTime.length());
			String nonce = strTime + WeChatUtil.buildRandom(4);
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			cal.add(Calendar.MINUTE, ORDER_TIMEFRAME);// 注意：最短失效时间间隔必须大于5分钟
			String timeExpire = WeChatUtil.getTime(cal.getTime(), "yyyyMMddHHmmss");
			String timeStart = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			logger.info("=================开始微信签名===============");

			SortedMap<Object, Object> packageParams = new TreeMap<Object, Object>();
			packageParams.put("appid", AppProps.get("appid"));
			packageParams.put("mch_id", AppProps.get("partner_id"));
			packageParams.put("nonce_str", nonce);// 随机串
			packageParams.put("body", "水果熟了 - 微商城赠送支付");// 描述
			packageParams.put("attach", "");// 附加数据
			packageParams.put("out_trade_no", System.currentTimeMillis() + "_" + presentId);// 商户订单号
			packageParams.put("total_fee", present.getInt("need_pay"));// 微信支付金额单位为（分）
			packageParams.put("time_start", timeStart);// 订单生成时间
			packageParams.put("time_expire", timeExpire);// 订单失效时间
			packageParams.put("spbill_create_ip", WeChatUtil.getRemoteAddr(getRequest()));// 订单生成的机器
			// IP

			packageParams.put("notify_url", AppProps.get("app_domain") + "/pay/presentCallback");// 支付完成后微信发给该链接信息，可以判断会员是否支付成功，改变订单状态等。
			packageParams.put("trade_type", "JSAPI");
			packageParams.put("openid", user.get("open_id"));
			//AppProps.get("partner_key")
			String sign = WeChatUtil.createSign(AppProps.get("partner_key"), packageParams); // 获取签名
			packageParams.put("sign", sign);
			String xml = WeChatUtil.getRequestXml(packageParams); // 获取请求微信的XML
			logger.info("=================获取预支付ID===============" + xml);
			String prepay_id = WeChatUtil.sendWeChatGetPrepayId(xml);
			if (StringUtil.isNull(prepay_id)) {
				ret.put("msg", "微信预支付出错（无法获取预支付编号）");
				ret.put("resouce_from", 0);
				renderJson(ret);
				return;
			}
			logger.info("=================微信预支付成功，生成JSAPI签名===============");
			SortedMap<Object, Object> finalpackage = new TreeMap<Object, Object>();
			finalpackage.put("appId", AppProps.get("appid"));
			String timestamp = Long.toString(System.currentTimeMillis() / 1000);
			finalpackage.put("timeStamp", timestamp);
			finalpackage.put("nonceStr", nonce);
			String packages = "prepay_id=" + prepay_id;
			finalpackage.put("package", packages);
			finalpackage.put("signType", "MD5");
			String finalsign = WeChatUtil.createSign(AppProps.get("partner_key"), finalpackage);

			// JSAPI弹出用户充值成功后的提示页面，用户点击右上角"完成"按钮，JSAPI通知微信支付成功，可以回调了
			logger.info("=================响应到JSAPI，完成微信支付===============");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("appid", AppProps.get("appid"));
			map.put("timeStamp", timestamp);
			map.put("nonceStr", nonce);
			map.put("packageValue", packages);
			map.put("sign", finalsign);
			String userAgent = getRequest().getHeader("user-agent");
			char agent = userAgent.charAt(userAgent.indexOf("MicroMessager") + 15);
			map.put("agent", new String(new char[] { agent }));
			renderJson(map);

			// 后台修改订单为支付中状态
			Db.update("update t_present set present_status = '2', pay_time = ? where id = ?",
					WeChatUtil.getCurrTime("yyyy-MM-dd HH:mm:ss:SSS"), presentId);
		}
	}
	
	/*public void getSandboxnewKey() throws Exception{
		JSONObject result=new JSONObject();
		String resultXml=WeChatUtil.getSandboxnewKey();
		if(StringUtil.isNotNull(resultXml)){
			result.put("msg", resultXml);
		}else{
			result.put("msg", "接口错误！");
		}
		renderJson(result);
	}*/

	/**
	 * 支付完成，回调方法
	 * 
	 * @throws IOException
	 */
	public void orderCallback() throws IOException {
		logger.info("========支付结束，微信回调后台=======");
		XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
		XNode resultCode = xpath.evalNode("//result_code");
		if ("SUCCESS".equalsIgnoreCase(resultCode.body())) {
			logger.info("========微信支付成功，记录购物表微信支付金额，并修改购物状态为支付成功状态=======");
			XNode orderId = xpath.evalNode("//out_trade_no");
			logger.info("========微信支付成功，避免订单没有送九宫格抽奖bug=======");
			Watched orderActivityWatched = new ConcreteWatched();
			TOrder orderData = TOrder.dao.findFirst("select * from t_order where order_id=?",orderId.body());
			if(orderData!=null){//订单支付
				OrderTransmitData orderTransmitData = new OrderTransmitData();
				orderTransmitData.setUserId(orderData.getInt("order_user"));
				orderTransmitData.setOrderId(orderData.getInt("id"));
				orderTransmitData.setNeedPay(orderData.getInt("need_pay"));//支付订单金额
				//orderTransmitData.setCouponId(orderData.getInt("order_coupon"));//优惠券
				orderTransmitData.setCurrentTime(new Date());//订单创建时间
				orderTransmitData.setOrder(orderData);
				orderTransmitData.setStoreId(orderData.getStr("order_store"));
				Watcher orderActivity8Watcher = new OrderActivity8Watcher();
				orderActivityWatched.addWatcher(orderActivity8Watcher);
				orderActivityWatched.notifyWatchers(orderTransmitData);
			}
			int i = Db.update("update t_order set order_status = '3' where order_id = ?", orderId.body());
			if (i > 0) {
				logger.info("===========微信海鼎减商品库存start==============");
				if (HdUtil.orderReduce(orderId.body())) {
					TOrder order=new TOrder();
					Db.update("update t_order set hd_status = '0' where order_id = ?", orderId.body());
					order=order.findTOrderByOrderId(orderId.body());
					//送货上门订单
					if("2".equals(order.getStr("deliverytype"))){
						logger.info("=========写入送货上门订单=================");
						new TDeliverNote().saveDeliverNote(order.getStr("order_id"),order.getStr("order_store"),1,"5",null,order.getInt("delivery_fee"));
					}
				} else {
					// 发送消息给指定的管理员
					TIndexSetting setting = new TIndexSetting();
					Map<String, String> map = setting.getIndexSettingMap();
					PushUtil.sendMsgToManager(map.get("managerPhone"), orderId.body());
					Db.update("update t_order set hd_status = '1' where order_id = ?", orderId.body());
				}
				logger.info("===========微信海鼎减商品库存end==============");
				new TPayLog().save("t_order", PaySourceTypes.ORDER, xpath);
				getResponse().getWriter()
						.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
								+ "<xml><return_code><![CDATA[SUCCESS]]></return_code>"
								+ "<return_msg><![CDATA[OK]]></return_msg></xml>");
				getResponse().getWriter().flush();
				getResponse().getWriter().close();
			}
		}
		renderNull();
	}

	/**
	 * 支付完成，回调方法
	 * 
	 * @throws IOException
	 */
	public void presentCallback() throws IOException {
		logger.info("========支付结束，微信回调后台=======");
		XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
		XNode resultCode = xpath.evalNode("//result_code");
		if ("SUCCESS".equalsIgnoreCase(resultCode.body())) {
			XNode xnode = xpath.evalNode("//out_trade_no");
			String presentId = xnode.body().split("[_]")[1];
			logger.info("========微信支付成功，记录购物表微信支付金额，并修改购物状态为支付成功状态=======");
			int i = Db.update("update t_present set present_status = '3' where id = ?", presentId);
			if (i > 0) {
				int id = Integer.parseInt(presentId);
				List<Record> presentPros = new TPresent().findProList(id);
				TPresent present = new TPresent().findById(id);
				int userId = present.getInt("target_user");
				TStock stock = new TStock().getStockByUser(userId);
				int stockId = stock.getInt("id");
				for (Record pro : presentPros) {
					Record stockProduct = new Record();
					stockProduct.set("stock_id", stockId);
					stockProduct.set("product_f_id", pro.get("pf_id"));
					stockProduct.set("product_id", pro.get("product_id"));
					stockProduct.set("unit_price", pro.get("unit_price"));
					stockProduct.set("amount", pro.get("amount"));
					stockProduct.set("get_time", DateFormatUtil.format1(new Date()));
					Db.save("t_stock_product", stockProduct);
				}
				TUser target = new TUser().findById(userId);
				TUser user = new TUser().findById(present.getInt("present_user"));
				if (StringUtil.isNotNull(target.get("phone_num"))) {
					String nickname = user.get("nickname");
					String sourceMobile = user.get("phone_num");
					if (nickname == null) {
						nickname = "";
					}
					if (sourceMobile == null) {
						sourceMobile = "";
					}
					String nickString = nickname + "(" + sourceMobile + ")";
					PushUtil.sendPresentMsgToUser(target.get("phone_num"), nickString);
				}
				new TPayLog().save("t_present", PaySourceTypes.PRESENT, xpath);
				getResponse().getWriter()
						.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
								+ "<xml><return_code><![CDATA[SUCCESS]]></return_code>"
								+ "<return_msg><![CDATA[OK]]></return_msg></xml>");
				getResponse().getWriter().flush();
				getResponse().getWriter().close();
			}
		}
		renderNull();
	}

	/**
	 * 余额支付
	 * 
	 * @param user
	 * @param order
	 * @return
	 */
	private boolean balancePayOrder(Record user, Record order, String currentTime) {
		int balance = user.getInt("balance");
		int needPay = order.getInt("need_pay")+order.getInt("delivery_fee");//加上配送费
		user.set("balance", balance - needPay);
		if (Db.update("t_user", user)) {
			order.set("order_status", "3");
			order.set("pay_time", currentTime);
			return Db.update("t_order", order);
		}
		return false;
	}

	/**
	 * 余额支付
	 * 
	 * @param user
	 * @param order
	 * @return
	 */
	private boolean balancePayPresent(Record user, Record present, String currentTime) {
		int balance = user.getInt("balance");
		int needPay = present.getInt("need_pay");
		user.set("balance", balance - needPay);
		if (Db.update("t_user", user)) {
			present.set("present_status", "3");
			present.set("pay_time", currentTime);
			return Db.update("t_present", present);
		}
		return false;
	}

	/**
	 * 支付失败跳转
	 * 
	 * @param user
	 * @param order
	 * @return
	 */
	public void orderFailure() {
		int i = Db.update("update t_order set order_status = '1', pay_time = '' where order_id = ? and order_status<3",
				getPara("orderId"));
		renderJson("{\"state\": \"" + i + "\"}");
	}

	/**
	 * 支付失败跳转
	 * 
	 * @param user
	 * @param order
	 * @return
	 */
	public void presentFailure() {
		int i = Db.update("update t_present set present_status = '1', pay_time = '' where id = ? and order_status<3",
				getPara("presentId"));
		renderJson("{\"state\": \"" + i + "\"}");
	}

	/**
	 * 跳转到充值页面
	 */
	public void sbmtRecharge() {
		List<Record> gives = Db.find("select * from t_user_recharge_gift where on_off = '1' order by give_fee asc");
		setAttr("gives", gives);
		//充值banner图
		Record rechargeBanner = MCarousel.dao.findMCarousel(4);
		setAttr("rechargeBanner",rechargeBanner);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/recharge.ftl");
	}
	
	/**
	 * 跳转到充值成功页面
	 */
	@Before(OAuth2Interceptor.class)
	public void successRecharge() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		TUser user = TUser.dao.findTUserInfo(userId);
		setAttr("balance",user.getInt("balance"));//余额
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/successRecharge.ftl");
	}
	
	/**
	 * 充值
	 */
	@Before({ OAuth2Interceptor.class })
	public void recharge() {
		TUser sessionUser = UserStoreUtil.get(getRequest());
		Record user = Db.findById("t_user", sessionUser.get("id"));
		Map<String, Object> ret = new HashMap<>();
		ret.put("state", "failure");
		if (StringUtil.isNull(user.getStr("open_id"))) {
			ret.put("msg", "用户ID为空！");
			renderJson(ret);
			return;
		}
		String money = getPara("totalFee");
		if (StringUtil.isNull(money)) {
			ret.put("msg", "请填写充值金额！");
			renderJson(ret);
			return;
		}
		int iMoney = Integer.parseInt(money);
		if (iMoney < 1) {
			ret.put("msg", "您输入的金额不正确！");
			renderJson(ret);
			return;
		}

		String currTime = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
		String strTime = currTime.substring(8, currTime.length());
		String nonce = strTime + WeChatUtil.buildRandom(4);
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.MINUTE, ORDER_TIMEFRAME);// 设置6分钟过期
		String timeExpire = WeChatUtil.getTime(cal.getTime(), "yyyyMMddHHmmss");
		logger.info("=================开始微信签名===============");
		SortedMap<Object, Object> packageParams = new TreeMap<Object, Object>();
		packageParams.put("appid", AppProps.get("appid"));
		packageParams.put("mch_id", AppProps.get("partner_id"));
		packageParams.put("nonce_str", nonce);// 随机串
		packageParams.put("body", "水果熟了 - 微商城用户充值");// 商品描述
		packageParams.put("attach", user.get("id"));// 附加数据
		packageParams.put("out_trade_no", System.currentTimeMillis());// 商户订单号
		packageParams.put("total_fee", iMoney * AppProps.getInt("payunit", 100));// 微信支付金额单位为（分）
		packageParams.put("time_expire", timeExpire);
		packageParams.put("spbill_create_ip", WeChatUtil.getRemoteAddr(getRequest()));// 订单生成的机器
		// IP
		packageParams.put("notify_url", AppProps.get("app_domain") + "/pay/rechargeCallback");// 支付完成后微信发给该链接信息，可以判断会员是否支付成功，改变订单状态等。
		packageParams.put("trade_type", "JSAPI");
		packageParams.put("openid", user.getStr("open_id"));
		String sign = WeChatUtil.createSign(AppProps.get("partner_key"), packageParams); // 获取签名
		packageParams.put("sign", sign);
		logger.info("=================获取预支付ID===============");
		String xml = WeChatUtil.getRequestXml(packageParams); // 获取请求微信的XML
		String prepay_id = WeChatUtil.sendWeChatGetPrepayId(xml);
		if (StringUtil.isNull(prepay_id)) {
			throw new RuntimeException("微信预支付出错");
		}
		logger.info("=================微信预支付成功，响应到JSAPI完成微信支付===============");
		SortedMap<Object, Object> finalpackage = new TreeMap<Object, Object>();
		finalpackage.put("appId", AppProps.get("appid"));
		String timestamp = Long.toString(System.currentTimeMillis() / 1000);
		finalpackage.put("timeStamp", timestamp);
		finalpackage.put("nonceStr", nonce);
		String packages = "prepay_id=" + prepay_id;
		finalpackage.put("package", packages);
		finalpackage.put("signType", "MD5");
		String finalsign = WeChatUtil.createSign(AppProps.get("partner_key"), finalpackage);

		JSONObject json = new JSONObject();
		json.put("appid", AppProps.get("appid"));
		json.put("timeStamp", timestamp);
		json.put("nonceStr", nonce);
		json.put("packageValue", packages);
		json.put("sign", finalsign);
		json.put("orderId", user.get("id"));
		String userAgent = getRequest().getHeader("user-agent");
		char agent = userAgent.charAt(userAgent.indexOf("MicroMessager") + 15);
		json.put("agent", new String(new char[] { agent }));
		renderJson(json);
	}

	/**
	 * 充值微信回调
	 * 
	 * @throws IOException
	 */
	public void rechargeCallback() throws IOException {
		logger.info("========支付成功，后台回调=======");
		XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
		XPathWrapper wrap = new XPathWrapper(xpath);
		String resultCode = wrap.get("result_code");
		if ("SUCCESS".equalsIgnoreCase(resultCode)) {
			String userId = wrap.get("attach");
			String totalFee = wrap.get("total_fee");
			int fee = Integer.parseInt(totalFee);
			TUser user = new TUser().findById(userId);
			int balance = user.getInt("balance");
			/*
			 * int give = 0;
			 * 
			 * logger.info("========微信支付成功，修改用户余额======="); try { List<Record>
			 * gives = Db.find(
			 * "select * from t_user_recharge_gift where on_off = '1' order by give_fee desc"
			 * ); for (Record record : gives) { int recharge_fee =
			 * record.getInt("recharge_fee"); if(fee >= recharge_fee){ give =
			 * record.getInt("give_fee"); break; } } } catch (Exception e) {
			 * logger.error("========充值赠送活动异常，赠送失败。=======", e); }
			 * 
			 * int i = Db.update("update t_user set balance = ? where id = ?"
			 * ,(balance + fee + give), userId);
			 */
			int i = Db.update("update t_user set balance = ? where id = ?", (balance + fee), userId);
			if (i > 0) {
				new TPayLog().save("t_user", PaySourceTypes.RECHARGE, xpath);
				/****** 充值活动订阅通知 *************/
				Watched rechargeActivityWatched = new ConcreteWatched();
				//Watcher rechargeWatcher = new RechargeActivityWatcher();
				Watcher rechargeJggWatcher = new RechargeJggWatcher();
				//rechargeActivityWatched.addWatcher(rechargeWatcher);
				rechargeActivityWatched.addWatcher(rechargeJggWatcher);
				RechargeTransmitData rData = new RechargeTransmitData();
				rData.setRecharge(fee);
				rData.setUserId(userId);
				rData.setOutTradeNo(wrap.get("out_trade_no"));
				rechargeActivityWatched.notifyWatchers(rData);
				/****** 充值活动订阅通知 *************/
				getResponse().getWriter()
						.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
								+ "<xml><return_code><![CDATA[SUCCESS]]></return_code>"
								+ "<return_msg><![CDATA[OK]]></return_msg></xml>");
				getResponse().getWriter().flush();
				getResponse().getWriter().close();
			}
		}
		renderNull();
	}

	/**
	 * 成功支付前台跳转页面
	 */
	@Before(OAuth2Interceptor.class)
	public void successPay() {

		// order表的order_id 或者t_present的id
		String orderId = getPara("orderId");

		setAttr("orderId", orderId);
		String type = getPara("type");
		setAttr("payType", type);
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		/****** 订单支付成功订阅通知 *************/
		OrderTransmitData orderData = new OrderTransmitData();
		Watched orderActivityWatched = new ConcreteWatched();
		Watcher orderActivity4Watcher = new OrderActivity4Watcher();
		Watcher orderActivity6Watcher = new OrderActivity6Watcher();
		Watcher orderActivity3Watcher = new OrderActivity3Watcher();
		Watcher orderActivity8Watcher = new OrderActivity8Watcher();

		String referer = getSessionAttr("referer");
		// 获取记录用户来源
		if (StringUtil.isNotNull(referer)) {
			Watcher refererWatcher = new RefererWatcher();
			orderActivityWatched.addWatcher(refererWatcher);
			Map<String, Object> ext = new HashMap<String, Object>();
			ext.put("referer", referer);
			orderData.setExt(ext);
		}
		// 抢购减库存
		orderActivityWatched.addWatcher(orderActivity4Watcher);
		// 随机送鲜果币
		orderActivityWatched.addWatcher(orderActivity6Watcher);
		// 首单送鲜果币
		orderActivityWatched.addWatcher(orderActivity3Watcher);
		//购物送九宫格抽奖机会
		orderActivityWatched.addWatcher(orderActivity8Watcher);
		
		orderData.setUserId(userId);
		orderData.setCurrentTime(new Date());
		// 购买 赠送不做优惠券领取

		if (!"zs".equals(type)) {
			TOrder orderOper = new TOrder();
			TOrder orderQuery = orderOper.findTOrderByOrderId(getPara("orderId"));
			orderQuery.setOrderProducts(orderOper.findOrderProList(orderQuery.getInt("id")));
			orderData.setType("gm");
			orderData.setOrderId(orderQuery.getInt("id"));
			orderData.setNeedPay(orderQuery.getInt("need_pay"));
			orderQuery.setTotalProduct(orderQuery.getOrderProducts().size());
			orderData.setOrder(orderQuery);
			//订单所在门店
			orderData.setStoreId(orderQuery.getStr("order_store"));
			Watcher orderActivity5Watcher = new OrderActivity5Watcher();
			// 送优惠券
			orderActivityWatched.addWatcher(orderActivity5Watcher);

			setAttr("deliverytype", orderQuery.getStr("deliverytype"));
		} else {
			// 赠送类型
			TPresent presentQuery = TPresent.dao.findById(getParaToInt("orderId"));
			// 赠送商品
			presentQuery.setPresentProducts(
					Db.find("select * from t_present_products where present_id=?", getParaToInt("orderId")));
			orderData.setType("zs");
			orderData.setOrderId(getParaToInt("orderId"));
			orderData.setNeedPay(presentQuery.getInt("need_pay"));
			presentQuery.setTotalProduct(presentQuery.getPresentProducts().size());
			orderData.setPresent(presentQuery);
			//订单所在门店,由于是赠送，没有此值，设置成中心8888
			orderData.setStoreId("8888");
			setAttr("deliverytype", getPara("deliverytype"));
		}
		orderActivityWatched.notifyWatchers(orderData);
		/****** 订单支付成功订阅通知 *************/
		// 查找是否有送优惠券
		setAttr("userCoupon", new TUserCoupon().findUserCouponByOrderId(orderData.getOrderId()));
		setAttr("getCouponNum",new TUserCoupon().findUserGetCouponNumByOrderId(orderData.getOrderId()));
		// 查看是否首单,首单传给前台bonus参数，并且更改用户前端鲜果币显示数量
		/*
		 * TBlanceRecord blanceRecord=new
		 * TBlanceRecord().getRecordByOrderId(userId, orderData.getOrderId());
		 * if(blanceRecord!=null){
		 * setAttr("bonus",blanceRecord.getInt("blance")/100.0); }
		 */
		// 先去查找有效的首单送鲜果币活动,设置赠送鲜果币个数
		String sql = "select id,activity_money from m_activity where activity_type = '11' and yxbz = 'Y' and yxq_q <= NOW() and yxq_z >=NOW();";
		MActivity mActivity = new MActivity().findFirst(sql);
		if (mActivity != null) {
			// 判定是不是首单
			TBlanceRecord blanceRecord = new TBlanceRecord().getRecordByOrderId(userId, orderData.getOrderId());
			if (blanceRecord != null) {
				// 显示赠送的鲜果币相关信息,首单赠送的鲜果币数量,是否第一次购买，是否门店自提
				setAttr("first_order_present", (int) mActivity.get("activity_money") / 100.0);
				setAttr("isUserFirstBuy", true);
			} else {
				setAttr("isUserFirstBuy", false);
			}
		} else {
			setAttr("isUserFirstBuy", false);
		}
		Record activity = Db.findFirst("select *from m_activity where activity_type=18 and yxbz='Y' ");
		List<Record> productList = Db.find("select id from t_order_products where order_id = ? and product_f_id in (1756,1757)",orderData.getOrderId());
		// 活动有效状态
		if (productList.size()==0&&activity != null) {
			
			int money_count = orderData.getNeedPay()/100;//支付金额
			if ("zs".equals(type)) {
				// 购买7赠送8
				setAttr("seed", new GiveSeed().get1(activity.getInt("id"), userId, money_count, 8));
			} else {
				setAttr("seed", new GiveSeed().get1(activity.getInt("id"), userId, money_count, 7));
			}
		}

		render(AppConst.PATH_MANAGE_PC + "/client/mobile/successPay.ftl");
	}

	// @Before(OAuth2Interceptor.class)
	/**
	 * 转账初始化
	 */
	public void initBalanceTransfer() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		// 重新查询一次用户数据
		setAttr("user", tUserSession.findTUserInfo(userId));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/balanceTransfer.ftl");
	}

	/**
	 * 鲜果币转账
	 */
	@Before(OAuth2Interceptor.class)
	public void balanceTransfer() {
		TUser sessionUser = UserStoreUtil.get(getRequest());
		// 转账金额 单位 元 必须整数
		int money = getParaToInt("money") * 100;
		TUser user = TUser.dao.findFirst("select * from t_user where id=?", sessionUser.getInt("id"));
		TUser targetUser = TUser.dao.findFirst("select * from t_user where id=?", getPara("target_user"));
		int balance = user.getInt("balance");
		JSONObject ret = new JSONObject();
		ret.put("money", money);
		if (targetUser == null) {
			ret.put("msg", "未找到转账用户");
			logger.info("未找到转账用户");
			redirect("/me");
			return;
		}
		if (balance >= money && money >= 100) {
			user.set("balance", balance - money);
			int targetUserNalance = targetUser.getInt("balance");
			targetUser.set("balance", targetUserNalance + money);
			if (user.update()) {
				setSessionAttr(AppConst.WEIXIN_USER, user);
				targetUser.update();
			}
			ret.put("msg", "转账成功");
			logger.info("转账成功");
			// 保存操作日志
			String date = DateFormatUtil.format1(new Date());
			TBlanceRecord record = new TBlanceRecord();
			record.set("user_id", user.getInt("id"));
			record.set("blance", -money);
			record.set("ref_type", "balanceTransfer");
			record.set("create_time", date);
			record.save();
			TBlanceRecord recordTarget = new TBlanceRecord();
			recordTarget.set("user_id", targetUser.getInt("id"));
			recordTarget.set("blance", money);
			recordTarget.set("ref_type", "balanceTransfer");
			recordTarget.set("create_time", date);
			recordTarget.save();
			// 发送短信通知给对方
			PushUtil.sendMsgToFriend(targetUser.getStr("phone_num"), user.getStr("nickname"), getPara("money"));
		} else {
			ret.put("msg", "转账金额不足");
			logger.info("转账金额不足");
		}
		setAttr("ret", ret);
		redirect("/me");
	}

	/**
	 * 团购支付 包括开团和拼团
	 */
	@Before({ OAuth2Interceptor.class })
	public void payTeamBuy() {
		Map<String, Object> ret = new HashMap<>();
		ret.put("state", "failure");
		TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);
		// 获取团购规模编号
		int buyScaleId = getParaToInt("buyScaleId");
		// 获取团购编号 开团的时候不会发送
		int teamBuyId = getParaToInt("teamBuyId");
		TUser sessionUser = UserStoreUtil.get(getRequest());
		int userId = sessionUser.get("id");
		// 考虑到seeion缓存再次查询用户余额
		Record user = Db.findById("t_user", userId);
		MTeamBuyScale teamByuScale = MTeamBuyScale.dao.findById(buyScaleId);
		MTeamBuy teamBuyOper = new MTeamBuy();
		MTeamMember teamMemberOper = new MTeamMember();
		// 检查是否有待支付订单
		MTeamMember teamMember = teamMemberOper.getDMTeamMemberByUserId(userId, teamBuyId);
		if (teamByuScale == null) {
			logger.info("找不到团购规模或者团 buyScaleId=" + buyScaleId + "-teamBuyId=" + teamBuyId);
			ret.put("msg", "找不到团购规模或者团");
			renderJson(ret);
			return;
		} else {
			MActivityProduct activityProduct= MActivityProduct.dao.findById(teamByuScale.getInt("activity_product_id"));
			MActivity activity=new MActivity().findYxActivityById(activityProduct.getInt("activity_id"));
			if(activity==null){
				ret.put("msg", "团购活动已结束，期待您的下期参与");
				renderJson(ret);
				return;
			}
			// 查找当前规模今天的开团数
			long todayBeginTour = teamBuyOper.todayBeginTour(buyScaleId);
			// 开团且达到当天最大开团数
			if (StringUtil.isNull(getPara("teamBuyId")) && teamByuScale.getInt("team_open_times") <= todayBeginTour) {
				ret.put("msg", "此商品今日开团数已满，明天再来哦~");
				renderJson(ret);
				return;
			}
			// 检查是否开团或者参团数大于我今天的最大限制
			long todayMyJoinTimes = teamMemberOper.todayMyJoinTimes(userId, buyScaleId);
			if (teamByuScale.getInt("team_buy_times") <= todayMyJoinTimes) {
				ret.put("msg", "您今天已经参与过多此类商品的团购，去瞧瞧其它商品的团购!");
				renderJson(ret);
				return;
			}
		}
		// 已经参团的不能再在这个团内参团
		if (teamBuyId > 0) {
			MTeamMember myJoinTeam = teamMemberOper.myAlreadyJoinTeam(userId, teamBuyId);
			if (myJoinTeam != null) {
				logger.info("已经参团的不能再在这个团内参团 userId" + userId + "-teamBuyId=" + teamBuyId);
				ret.put("msg", "已经参团的不能再次参加此团");
				renderJson(ret);
				return;
			}
			// 检查团购人数是否满足团购人数,开团的时候不需要检查，因为必定大于1
			if (teamMemberOper.payCheckIsFull(userId, teamBuyId)) {
				logger.info("已经大于最大参团人数，不能参加此团 userId" + userId + "-teamBuyId=" + teamBuyId);
				ret.put("msg", "已经大于最大参团人数，不能参加此团");
				renderJson(ret);
				return;
			}
		}

		// 获取团购支付金额
		int needPay = teamByuScale.getInt("activity_price_reduce")+getParaToInt("delivery_fee");
		// 用户鲜果币超过商品价格-团购优惠价格，那么就用鲜果币支付
		if (user.getInt("balance") >= needPay) {
			// String currentTime = WeChatUtil.getCurrTime("yyyy-MM-dd
			// HH:mm:ss:SSS");
			// 余额支付
			user.set("balance", user.getInt("balance") - needPay);
			if (Db.update("t_user", user)) {
				// 设置加入团
				// 是加入团
				if (teamBuyId > 0) {
					if (teamMember == null) {
						teamMember = teamMemberOper.joinTeamBuy(false, "Y", getPara("order_store"),
								getPara("deliverytype"), getPara("deliverytime"), getPara("receiver_name"),
								getPara("receiver_mobile"), getPara("address_detail"), userId, teamBuyId,
								orderNoGenerator.nextId(), buyScaleId , getParaToInt("delivery_fee"),
								Double.parseDouble(getPara("lat")),Double.parseDouble(getPara("lng")));
					}
				} else {
					// 是开团
					teamMember = teamBuyOper.createTeamBuy(false, "Y", getPara("order_store"), getPara("deliverytype"),
							getPara("deliverytime"), getPara("receiver_name"), getPara("receiver_mobile"),
							getPara("address_detail"), userId, buyScaleId,getParaToInt("delivery_fee"),
							Double.parseDouble(getPara("lat")),Double.parseDouble(getPara("lng")));
				}
				// 写支付日志
				TPayLog paylog = new TPayLog();
				paylog.balancePaySaveLog(user.get("open_id"), PaySourceTypes.BALANCE, needPay,
						teamMember.getStr("order_id"));
				//送货上门订单
				if("2".equals(teamMember.getStr("deliverytype"))){
					logger.info("=========写入送货上门订单=================");
					new TDeliverNote().saveDeliverNote(teamMember.getStr("order_id"),teamMember.getStr("order_store"),1,"5",null,teamMember.getInt("delivery_fee"));
				}
				
				ret.put("orderId", teamMember.getStr("order_id"));
				ret.put("state", "success");
				ret.put("msg", "余额支付成功");

			} else {
				try {
					DbKit.getConfig().getThreadLocalConnection().rollback();
				} catch (SQLException e) {
				}
				ret.put("msg", "余额支付失败");
			}
			renderJson(ret);
			return;
		} else {
			// 设置加入团 还未支付
			// 是加入团
			if (teamBuyId > 0) {
				// 判定当前的参团是继续支付还是直接支付
				if (teamMember == null) {
					teamMember = teamMemberOper.joinTeamBuy(false, "D", getPara("order_store"), getPara("deliverytype"),
							getPara("deliverytime"), getPara("receiver_name"), getPara("receiver_mobile"),
							getPara("address_detail"), userId, teamBuyId, orderNoGenerator.nextId(), buyScaleId,getParaToInt("delivery_fee"),
							Double.parseDouble(getPara("lat")),Double.parseDouble(getPara("lng")));
				}
			} else {
				// 是开团
				teamMember = teamBuyOper.createTeamBuy(false, "N", getPara("order_store"), getPara("deliverytype"),
						getPara("deliverytime"), getPara("receiver_name"), getPara("receiver_mobile"),
						getPara("address_detail"), userId, buyScaleId,getParaToInt("delivery_fee"),
						Double.parseDouble(getPara("lat")),Double.parseDouble(getPara("lng")));
			}
			// 微信支付
			logger.info("=================账户余额不足, 开始微信预支付===============");
			String currTime = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			String strTime = currTime.substring(8, currTime.length());
			String nonce = strTime + WeChatUtil.buildRandom(4);
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			cal.add(Calendar.MINUTE, ORDER_TIMEFRAME);// 注意：最短失效时间间隔必须大于5分钟
			String timeExpire = WeChatUtil.getTime(cal.getTime(), "yyyyMMddHHmmss");
			String timeStart = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			logger.info("=================开始微信签名===============");

			SortedMap<Object, Object> packageParams = new TreeMap<Object, Object>();
			packageParams.put("appid", AppProps.get("appid"));
			packageParams.put("mch_id", AppProps.get("partner_id"));
			packageParams.put("nonce_str", nonce);// 随机串
			packageParams.put("body", "水果熟了 - 微商城订单支付");// 描述
			packageParams.put("attach", userId);// 附加数据 用户编号加参团编号
			packageParams.put("out_trade_no", teamMember.get("order_id"));// 商户订单号
			packageParams.put("total_fee", needPay);// 微信支付金额单位为（分）
			packageParams.put("time_start", timeStart);// 订单生成时间
			packageParams.put("time_expire", timeExpire);// 订单失效时间
			packageParams.put("spbill_create_ip", WeChatUtil.getRemoteAddr(getRequest()));// 订单生成的机器
			// IP
			packageParams.put("notify_url", AppProps.get("app_domain") + "/pay/teamCallback");// 支付完成后微信发给该链接信息，可以判断会员是否支付成功，改变订单状态等。
			packageParams.put("trade_type", "JSAPI");
			packageParams.put("openid", user.get("open_id"));
			String sign = WeChatUtil.createSign(AppProps.get("partner_key"), packageParams); // 获取签名
			packageParams.put("sign", sign);
			String xml = WeChatUtil.getRequestXml(packageParams); // 获取请求微信的XML
			logger.info("=================获取预支付ID===============" + xml);
			String prepay_id = WeChatUtil.sendWeChatGetPrepayId(xml);
			if (StringUtil.isNull(prepay_id)) {
				ret.put("msg", "微信预支付出错（无法获取预支付编号）");
				ret.put("resouce_from", 0);//支付错误信息来源于微商城
				renderJson(ret);
				return;
			}
			logger.info("=================微信预支付成功，生成JSAPI签名===============");
			SortedMap<Object, Object> finalpackage = new TreeMap<Object, Object>();
			finalpackage.put("appId", AppProps.get("appid"));
			String timestamp = Long.toString(System.currentTimeMillis() / 1000);
			finalpackage.put("timeStamp", timestamp);
			finalpackage.put("nonceStr", nonce);
			String packages = "prepay_id=" + prepay_id;
			finalpackage.put("package", packages);
			finalpackage.put("signType", "MD5");
			String finalsign = WeChatUtil.createSign(AppProps.get("partner_key"), finalpackage);

			// JSAPI弹出用户充值成功后的提示页面，用户点击右上角"完成"按钮，JSAPI通知微信支付成功，可以回调了
			logger.info("=================响应到JSAPI，完成微信支付===============");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("appid", AppProps.get("appid"));
			map.put("timeStamp", timestamp);
			map.put("nonceStr", nonce);
			map.put("packageValue", packages);
			map.put("sign", finalsign);
			map.put("orderId", teamMember.getStr("order_id"));
			String userAgent = getRequest().getHeader("user-agent");
			char agent = userAgent.charAt(userAgent.indexOf("MicroMessager") + 15);
			map.put("agent", new String(new char[] { agent }));

			renderJson(map);
		}
	}

	/**
	 * 团购成功支付前台跳转页面
	 */
	@Before(OAuth2Interceptor.class)
	public void teamSuccessPay() {
		// 获取团购规模编号
		int buyScaleId = getParaToInt("buyScaleId");

		String orderId = getPara("orderId");

		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		MTeamMember teamMenberOper = new MTeamMember();
		MTeamMember teamMember = teamMenberOper.getMTeamMemberByOrderId(orderId);
		// 设置成支付成功 之前支付前就已经保持了相关团购信息，此处只需要修改状态为已支付，并且检测拼团成就发货
		MTeamMember member = teamMenberOper.joinTeamBuy(true, "Y", null, null, null, null, null, null, userId,
				teamMember.getInt("team_buy_id"), orderId, buyScaleId,getParaToInt("delivery_fee"),
				Double.parseDouble(getPara("lat")),Double.parseDouble(getPara("lng")));
		/*
		 * int teamBuyId=member.getInt("team_buy_id"); //查找当前团下面的成员 MTeamMember
		 * memberOper=new MTeamMember(); MTeamBuy teamBuyOper=new MTeamBuy();
		 * List<Record> members= memberOper.personInTeam(teamBuyId);
		 * setAttr("members", members); //查看我是否参加了当前团 MTeamMember isMyJoin=
		 * memberOper.myJoinTeam(userId,teamBuyId); setAttr("isMyJoin",
		 * isMyJoin); //查找所属规模 MTeamBuyScale teamBuyScaleOper=new
		 * MTeamBuyScale(); MTeamBuyScale
		 * teamBuyScale=teamBuyScaleOper.findById(buyScaleId);
		 * setAttr("teamBuyScale",teamBuyScale); Record
		 * beginTeam=teamBuyOper.searchBeginTeamById(teamBuyId);
		 * setAttr("beginTeam",beginTeam); //团购商品详情 Record
		 * productDetial=teamBuyOper.teamProductDetial(teamBuyId);
		 * setAttr("productDetial",productDetial);
		 */

		// 注 此处不能这样写，必须服务器跳转
		// render(AppConst.PATH_MANAGE_PC +
		// "/client/mobile/activity_groupbuyinfo.ftl");
		// 跳转到团购成功详情页
		redirect("/activity/groupBuyInfo?teamBuyId=" + member.getInt("team_buy_id"));
	}

	/**
	 * 团购支付失败跳转 不需要做任何处理
	 * 
	 * @param user
	 * @param order
	 * @return
	 */
	public void teamFailure() {

		renderJson("{\"state\": \"1\"}");
	}

	/**
	 * 团购支付后端回调接口
	 * 
	 * @throws IOException
	 */
	public void teamCallback() throws IOException {
		logger.info("========团购支付成功，后台回调=======");
		XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
		XPathWrapper wrap = new XPathWrapper(xpath);
		String resultCode = wrap.get("result_code");
		if ("SUCCESS".equalsIgnoreCase(resultCode)) {
			String attach = wrap.get("attach");
			logger.info("attach:" + attach);
			String orderId = wrap.get("out_trade_no");
			TUser user = new TUser().findById(attach);
			MTeamMember teamMember = new MTeamMember().getMTeamMemberByOrderId(orderId);
			MTeamBuy reamBuy = MTeamBuy.dao.findById(teamMember.getInt("team_buy_id"));
			// 设置成支付成功 之前支付前就已经保持了相关团购信息，此处只需要修改状态为已支付，并且检测拼团成就发货
			new MTeamMember().joinTeamBuy(true, "Y", null, null, null, null, null, null, user.getInt("id"),
					teamMember.getInt("team_buy_id"), orderId, reamBuy.getInt("m_team_buy_scale_id"),teamMember.getInt("delivery_fee"),teamMember.getDouble("lat"),teamMember.getDouble("lng"));

			TPayLog paylog = new TPayLog();
			paylog.save("t_order", PaySourceTypes.ORDER, xpath);
			//送货上门订单
			if("2".equals(teamMember.getStr("deliverytype"))){
				logger.info("=========写入送货上门订单=================");
				new TDeliverNote().saveDeliverNote(orderId,teamMember.getStr("order_store"),1,"5",null,teamMember.getInt("delivery_fee"));
			}
			getResponse().getWriter()
					.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							+ "<xml><return_code><![CDATA[SUCCESS]]></return_code>"
							+ "<return_msg><![CDATA[OK]]></return_msg></xml>");
			getResponse().getWriter().flush();
			getResponse().getWriter().close();
		}
		renderNull();
	}

	/**
	 * 团购订单支付--F
	 */
	public void groupPayment() {
		// 防止返回有问题
		if (StringUtil.isNull(getPara("tbs"))) {
			redirect("/activity/groupBuys");
			return;
		}
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		// 团购规模编号
		int tbs = getParaToInt("tbs");
		Record teamBuyScale = new MTeamBuyScale().getMTeamBuyScaleById(tbs);
		setAttr("teamBuyScale", teamBuyScale);
		// 团购编号
		setAttr("teamBuyId", getPara("teamBuyId"));
		TUser target = new TUser().findById(userId);
		// 如果当前用户没有绑定手机号，就获取手机信息并且绑定
		if (StringUtil.isNull(target.getStr("phone_num"))) {
			target.set("phone_num", getPara("phone_num"));
			// 更新数据库内容
			target.update();
			// 更新内存中session信息
			setSessionAttr(AppConst.WEIXIN_USER, target);
			// 发送数据到海鼎进行注册
			HdUtil.registUser(getPara("nearStore"), getPara("phone_num"), getPara("phone_num"));
		}
		MTeamMember teamMember = null;
		if (StringUtil.isNotNull(getPara("teamMemberId"))) {
			teamMember = MTeamMember.dao.findById(getPara("teamMemberId"));
		} else {
			teamMember = getModel(MTeamMember.class, "teamMember");
		}
		setAttr("teamMember", teamMember);
		// 查询下单店铺
		TStore store = new TStore().getStoreByStoreId(teamMember.getStr("order_store"));
		setAttr("store", store);

		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_group_payment.ftl");
	}
	
	
	/*********************鲜果师订单支付*********************************************************/
	
	/**
	 * 鲜果师订单支微信付
	 */
	@Before({ OAuth2Interceptor.class })
	public void payFruitmasterBuy() {
		TUser sessionUser = UserStoreUtil.get(getRequest());
		Record user = Db.findById("t_user", sessionUser.get("id"));
		Map<String, Object> ret = new HashMap<>();
		ret.put("state", "failure");
		String orderId = getPara("orderId");
		Record order = Db.findFirst(
				"select * from t_order where order_id = ? and order_status = '1' and order_user = ?", orderId,
				user.get("id"));
		if (order == null) {
			ret.put("msg", "订单不存在！");
			renderJson(ret);
			return;
		}
		if ("0".equals(order.getStr("order_status"))) {
			ret.put("msg", "订单超时，请重新下单！");
			renderJson(ret);
			return;
		}
		if (order.getInt("need_pay") < 0) {
			ret.put("msg", "无效金额！");
			renderJson(ret);
			return;
		}

		if (user.getInt("balance") >= order.getInt("need_pay")) {
			String currentTime = WeChatUtil.getCurrTime("yyyy-MM-dd HH:mm:ss:SSS");
			// 余额支付
			boolean success = balancePayOrder(user, order, currentTime);
			if (!success) {
				try {
					DbKit.getConfig().getThreadLocalConnection().rollback();
				} catch (SQLException e) {
				}
				ret.put("msg", "余额支付失败");
			} else {
				com.xgs.model.TPayLog paylog = new com.xgs.model.TPayLog();
				paylog.xgBalancePaySaveLog("t_user",user.get("open_id"), PaySourceTypes.BALANCE, order.getInt("need_pay"),
						orderId,"1");
				//是别人的客户，此时就需要添加一条收支明细
//				com.xgs.model.TOrder xorder = com.xgs.model.TOrder.dao.findFirst("select * from t_order where order_id =?",orderId);
				if(StringUtil.isNotNull(String.valueOf(order.getInt("master_id")))){
					XAchievementRecord.dao.addXAchievementRecord(order, 1);
				}
				ret.put("state", "success");
				ret.put("msg", "余额支付成功");
			}
			logger.info("===========余额支付海鼎减商品库存start==============");
			if (HdUtil.orderReduce(orderId)) {
				Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
			} else {
				TIndexSetting setting = new TIndexSetting();
				Map<String, String> map = setting.getIndexSettingMap();
				PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
				Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
			}
			logger.info("===========余额支付海鼎减商品库存end==============");
			renderJson(ret);
			return;
		} else {
			// 微信支付
			logger.info("=================账户余额不足, 开始微信预支付===============");
			String currTime = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			String strTime = currTime.substring(8, currTime.length());
			String nonce = strTime + WeChatUtil.buildRandom(4);
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			cal.add(Calendar.MINUTE, ORDER_TIMEFRAME);// 注意：最短失效时间间隔必须大于5分钟
			String timeExpire = WeChatUtil.getTime(cal.getTime(), "yyyyMMddHHmmss");
			String timeStart = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
			logger.info("=================开始微信签名===============");

			SortedMap<Object, Object> packageParams = new TreeMap<Object, Object>();
			packageParams.put("appid", AppProps.get("appid"));
			packageParams.put("mch_id", AppProps.get("partner_id"));
			packageParams.put("nonce_str", nonce);// 随机串
			packageParams.put("body", "水果熟了 - 美味食鲜订单支付");// 描述
			packageParams.put("attach", "");// 附加数据
			packageParams.put("out_trade_no", order.get("order_id"));// 商户订单号
			packageParams.put("total_fee", order.getInt("need_pay"));// 微信支付金额单位为（分）
			packageParams.put("time_start", timeStart);// 订单生成时间
			packageParams.put("time_expire", timeExpire);// 订单失效时间
			packageParams.put("spbill_create_ip", WeChatUtil.getRemoteAddr(getRequest()));// 订单生成的机器
			// IP

			packageParams.put("notify_url", AppProps.get("app_domain") + "/pay/payFruitmasterCallback");// 支付完成后微信发给该链接信息，可以判断会员是否支付成功，改变订单状态等。
			packageParams.put("trade_type", "JSAPI");
			packageParams.put("openid", user.get("open_id"));
			String sign = WeChatUtil.createSign(AppProps.get("partner_key"), packageParams); // 获取签名
			packageParams.put("sign", sign);
			String xml = WeChatUtil.getRequestXml(packageParams); // 获取请求微信的XML
			logger.info("=================获取预支付ID===============" + xml);
			String prepay_id = WeChatUtil.sendWeChatGetPrepayId(xml);
			if (StringUtil.isNull(prepay_id)) {
				ret.put("msg", "微信预支付出错（无法获取预支付编号）");
				ret.put("resouce_from", 1);
				renderJson(ret);
				return;
			}
			logger.info("=================微信预支付成功，生成JSAPI签名===============");
			SortedMap<Object, Object> finalpackage = new TreeMap<Object, Object>();
			finalpackage.put("appId", AppProps.get("appid"));
			String timestamp = Long.toString(System.currentTimeMillis() / 1000);
			finalpackage.put("timeStamp", timestamp);
			finalpackage.put("nonceStr", nonce);
			String packages = "prepay_id=" + prepay_id;
			finalpackage.put("package", packages);
			finalpackage.put("signType", "MD5");
			String finalsign = WeChatUtil.createSign(AppProps.get("partner_key"), finalpackage);

			// JSAPI弹出用户支付成功后的提示页面，用户点击右上角"完成"按钮，JSAPI通知微信支付成功，可以回调了
			logger.info("=================响应到JSAPI，完成微信支付===============");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("appid", AppProps.get("appid"));
			map.put("timeStamp", timestamp);
			map.put("nonceStr", nonce);
			map.put("packageValue", packages);
			map.put("sign", finalsign);
			map.put("orderId", order.get("order_id"));
			String userAgent = getRequest().getHeader("user-agent");
			char agent = userAgent.charAt(userAgent.indexOf("MicroMessager") + 15);
			map.put("agent", new String(new char[] { agent }));

			// 后台修改订单为支付中状态
			Db.update("update t_order set order_status = ?, pay_time = ? where order_id = ?", "2",
					WeChatUtil.getCurrTime("yyyy-MM-dd HH:mm:ss:SSS"), orderId);
			renderJson(map);
		}
	}

	/**
	 * 鲜果师订单支付成功支付前台跳转页面
	 */
	@Before(OAuth2Interceptor.class)
	public void fruitmasterSuccessPay() {
		String orderId = getPara("orderId");
		setAttr("orderId", orderId);
		String type = getPara("type");
		setAttr("payType", type);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/successPay.ftl");
	}

	/**
	 * 鲜果师订单支付失败跳转 不需要做任何处理
	 * 
	 * @param user
	 * @param order
	 * @return
	 */
	public void payFruitmasterFailure() {
		int i = Db.update("update t_order set order_status = '1', pay_time = '' where order_id = ? and order_status<3",
				getPara("orderId"));
		renderJson("{\"state\": \"1\"}");
	}

	/**
	 * 鲜果师订单支付后端回调接口
	 * 
	 * @throws IOException
	 */
	public void payFruitmasterCallback() throws IOException {//orderCallback
		logger.info("========订单支付成功，后台回调=======");
		XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
		XPathWrapper wrap = new XPathWrapper(xpath);
		String resultCode = wrap.get("result_code");
		if ("SUCCESS".equalsIgnoreCase(resultCode)) {
			String attach = wrap.get("attach");
			logger.info("attach:" + attach);
			String orderId = wrap.get("out_trade_no");
			logger.info("========微信支付成功，记录购物表微信支付金额，并修改购物状态为支付成功状态=======");
			//XNode orderId = xpath.evalNode("//out_trade_no");
			int i=Db.update("update t_order set order_status = '3' where order_id = ?", orderId);
			if (i > 0) {
				logger.info("===========微信海鼎减商品库存start==============");
				if (HdUtil.orderReduce(orderId)) {
					TOrder order=new TOrder();
					Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
					order=order.findTOrderByOrderId(orderId);
				} else {
					// 发送消息给指定的管理员
					TIndexSetting setting = new TIndexSetting();
					Map<String, String> map = setting.getIndexSettingMap();
					PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
					Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
				}
			
				logger.info("===========微信海鼎减商品库存end==============");
			com.xgs.model.TPayLog paylog = new com.xgs.model.TPayLog();
			paylog.save("t_user", PaySourceTypes.ORDER, xpath,"1");//第一个参数‘1’为来源于鲜果师商城
			//是别人的客户，此时就需要添加一条收支明细
			Record order = Db.findFirst("select * from t_order where order_id =?",orderId);
			if(StringUtil.isNotNull(String.valueOf(order.getInt("master_id")))){
				XAchievementRecord.dao.addXAchievementRecord(order, 1);
			}
			getResponse().getWriter()
					.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							+ "<xml><return_code><![CDATA[SUCCESS]]></return_code>"
							+ "<return_msg><![CDATA[OK]]></return_msg></xml>");
			getResponse().getWriter().flush();
			getResponse().getWriter().close();
			}
		}
		renderNull();
	}

	/**
	 * 鲜果师订单支付
	 */
	
	public void payFruitmasterPayment() {
		// 防止返回有问题
//		if (StringUtil.isNull(getPara("tbs"))) {
//			redirect("/activity/groupBuy");
//			return;
//		}
		long id = getParaToLong("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		setAttr("order", new TOrder().findTOrderById(id, userId));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/payment.ftl");
	}
	
	/***************鲜果师商城充值***********************************/
	/**
	 * 跳转到充值页面
	 */
	public void payFruitmasterSbmtRecharge() {
		List<Record> gives = Db.find("select * from t_user_recharge_gift where on_off = '1' order by give_fee asc");
		setAttr("gives", gives);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/recharge.ftl");
	}
	/**
	 * 充值
	 */
	@Before({ OAuth2Interceptor.class })
	public void payFruitmasterRecharge() {
		System.out.println("===========coming");
		TUser sessionUser = UserStoreUtil.get(getRequest());
		Record user = Db.findById("t_user", sessionUser.get("id"));
		Map<String, Object> ret = new HashMap<>();
		ret.put("state", "failure");
		if (StringUtil.isNull(user.getStr("open_id"))) {
			ret.put("msg", "用户ID为空！");
			renderJson(ret);
			return;
		}
		String money = getPara("totalFee");
		if (StringUtil.isNull(money)) {
			ret.put("msg", "请填写充值金额！");
			renderJson(ret);
			return;
		}
		int iMoney = Integer.parseInt(money);
		if (iMoney < 1) {
			ret.put("msg", "您输入的金额不正确！");
			renderJson(ret);
			return;
		}

		String currTime = WeChatUtil.getCurrTime("yyyyMMddHHmmss");
		String strTime = currTime.substring(8, currTime.length());
		String nonce = strTime + WeChatUtil.buildRandom(4);
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.MINUTE, ORDER_TIMEFRAME);// 设置6分钟过期
		String timeExpire = WeChatUtil.getTime(cal.getTime(), "yyyyMMddHHmmss");
		logger.info("=================开始微信签名===============");
		SortedMap<Object, Object> packageParams = new TreeMap<Object, Object>();
		packageParams.put("appid", AppProps.get("appid"));
		packageParams.put("mch_id", AppProps.get("partner_id"));
		packageParams.put("nonce_str", nonce);// 随机串
		packageParams.put("body", "水果熟了 - 微商城用户充值");// 商品描述
		packageParams.put("attach", user.get("id"));// 附加数据
		packageParams.put("out_trade_no", System.currentTimeMillis());// 商户订单号
		packageParams.put("total_fee", iMoney * AppProps.getInt("payunit", 100));// 微信支付金额单位为（分）
		packageParams.put("time_expire", timeExpire);
		packageParams.put("spbill_create_ip", WeChatUtil.getRemoteAddr(getRequest()));// 订单生成的机器
		// IP
		packageParams.put("notify_url", AppProps.get("app_domain") + "/pay/payFruitmasterRechargeCallback");// 支付完成后微信发给该链接信息，可以判断会员是否支付成功，改变订单状态等。
		packageParams.put("trade_type", "JSAPI");
		packageParams.put("openid", user.getStr("open_id"));
		String sign = WeChatUtil.createSign(AppProps.get("partner_key"), packageParams); // 获取签名
		packageParams.put("sign", sign);
		logger.info("=================获取预支付ID===============");
		String xml = WeChatUtil.getRequestXml(packageParams); // 获取请求微信的XML
		String prepay_id = WeChatUtil.sendWeChatGetPrepayId(xml);
		if (StringUtil.isNull(prepay_id)) {
			throw new RuntimeException("微信预支付出错");
		}
		logger.info("=================微信预支付成功，响应到JSAPI完成微信支付===============");
		SortedMap<Object, Object> finalpackage = new TreeMap<Object, Object>();
		finalpackage.put("appId", AppProps.get("appid"));
		String timestamp = Long.toString(System.currentTimeMillis() / 1000);
		finalpackage.put("timeStamp", timestamp);
		finalpackage.put("nonceStr", nonce);
		String packages = "prepay_id=" + prepay_id;
		finalpackage.put("package", packages);
		finalpackage.put("signType", "MD5");
		String finalsign = WeChatUtil.createSign(AppProps.get("partner_key"), finalpackage);

		JSONObject json = new JSONObject();
		json.put("appid", AppProps.get("appid"));
		json.put("timeStamp", timestamp);
		json.put("nonceStr", nonce);
		json.put("packageValue", packages);
		json.put("sign", finalsign);
		json.put("orderId", user.get("id"));
		String userAgent = getRequest().getHeader("user-agent");
		char agent = userAgent.charAt(userAgent.indexOf("MicroMessager") + 15);
		json.put("agent", new String(new char[] { agent }));
		renderJson(json);
	}

	/**
	 * 充值微信回调
	 * 
	 * @throws IOException
	 */
	public void payFruitmasterRechargeCallback() throws IOException {
		logger.info("========支付成功，后台回调=======");
		XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
		XPathWrapper wrap = new XPathWrapper(xpath);
		String resultCode = wrap.get("result_code");
		if ("SUCCESS".equalsIgnoreCase(resultCode)) {
			String userId = wrap.get("attach");
			String totalFee = wrap.get("total_fee");
			int fee = Integer.parseInt(totalFee);
			TUser user = new TUser().findById(userId);
			int balance = user.getInt("balance");
			int i = Db.update("update t_user set balance = ? where id = ?", (balance + fee), userId);
			if (i > 0) {
				 com.xgs.model.TPayLog tpayLog = new com.xgs.model.TPayLog();
				 tpayLog.save("t_user", PaySourceTypes.RECHARGE, xpath, "1");
 
				/****** 充值活动订阅通知 *************/
				Watched rechargeActivityWatched = new ConcreteWatched();
				Watcher rechargeWatcher = new RechargeActivityWatcher();
				rechargeActivityWatched.addWatcher(rechargeWatcher);
				RechargeTransmitData rData = new RechargeTransmitData();
				rData.setRecharge(fee);
				rData.setUserId(userId);
				rData.setOutTradeNo(wrap.get("out_trade_no"));
				rechargeActivityWatched.notifyWatchers(rData);
				/****** 充值活动订阅通知 *************/
				getResponse().getWriter()
						.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
								+ "<xml><return_code><![CDATA[SUCCESS]]></return_code>"
								+ "<return_msg><![CDATA[OK]]></return_msg></xml>");
				getResponse().getWriter().flush();
				getResponse().getWriter().close();
			}
		}
		renderNull();
	}
}
