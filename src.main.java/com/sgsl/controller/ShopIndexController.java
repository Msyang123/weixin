package com.sgsl.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.revocn.util.DateUtil;
import com.sgsl.activity.ConcreteWatched;
import com.sgsl.activity.OrderActivity1Watcher;
import com.sgsl.activity.OrderActivity2Watcher;
import com.sgsl.activity.OrderTransmitData;
import com.sgsl.activity.RegisterActivity1Watcher;
import com.sgsl.activity.RegisterActivityWatcher;
import com.sgsl.activity.RegisterTransmitData;
import com.sgsl.activity.Watched;
import com.sgsl.activity.Watcher;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.AFuwa;
import com.sgsl.model.AFwGet;
import com.sgsl.model.AUserFw;
import com.sgsl.model.Activitys;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MCarousel;
import com.sgsl.model.MHdParam;
import com.sgsl.model.MInterval;
import com.sgsl.model.MPackage;
import com.sgsl.model.MPackageInstance;
import com.sgsl.model.MPackageSeedR;
import com.sgsl.model.MProductSeedR;
import com.sgsl.model.MRecommend;
import com.sgsl.model.MSeedInstance;
import com.sgsl.model.MSeedProduct;
import com.sgsl.model.MSeedProductInstance;
import com.sgsl.model.MShare;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TCategory;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TExchangeOrderLog;
import com.sgsl.model.TFaqDetail;
import com.sgsl.model.TFeedback;
import com.sgsl.model.TIndexSetting;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPayLog;
import com.sgsl.model.TPayLog.PaySourceTypes;
import com.sgsl.model.TPresent;
import com.sgsl.model.TProduct;
import com.sgsl.model.TProductF;
import com.sgsl.model.TRefundLog;
import com.sgsl.model.TRepository;
import com.sgsl.model.TStock;
import com.sgsl.model.TStore;
import com.sgsl.model.TUser;
import com.sgsl.model.TUserCoupon;
import com.sgsl.util.HdUtil;
import com.sgsl.util.PushUtil;
import com.sgsl.util.RandomUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.MapUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.wechat.TwitterIdWorker;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.sgsl.wechat.util.XNode;
import com.sgsl.wechat.util.XPathParser;
import com.xgs.model.XAchievementRecord;

/**
 * Created by yj 手机端首页
 */
public class ShopIndexController extends BaseController {
	protected final static Logger logger = Logger.getLogger(ShopIndexController.class);
	private TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);

	// 访问次数标记
	private AtomicInteger viewTimes = new AtomicInteger(0);

	private Map<String, Object> cacheMap = new ConcurrentHashMap<String, Object>(20);

	/**
	 * 微商城主页面
	 * 
	 * @throws IOException
	 */
	@Before(OAuth2Interceptor.class)
	public void main() {
		int viewTimesLocal = viewTimes.get();

		// 设置用户入口的来源，默认为空，也可能是code(二维码入口)
		setSessionAttr("from", getPara("from"));
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));

		if (StringUtil.isNull(user.getStr("phone_num"))) {
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/member_mobile.ftl");
		} else {
			if (viewTimesLocal == 100) {
				viewTimes.set(0);
			} else {
				viewTimes.addAndGet(1);
			}
			List<Record> mCarousels = (List<Record>) cacheMap.get("mCarousels");
			if (mCarousels == null || viewTimesLocal == 0) {
				MCarousel mCarousel = new MCarousel();
				// 轮播图
				mCarousels = mCarousel.findMCarousels(0);
				cacheMap.putIfAbsent("mCarousels", mCarousels);
			}
			setAttr("mCarousels", mCarousels);

			// 抢购活动
			MActivity activity = new MActivity();
			List<Record> activitys = activity.findMActivitys(1);
			MActivityProduct activityProOper = new MActivityProduct();
			MInterval miOper = new MInterval();
			TProductF pfOper = new TProductF();

			for (Record item : activitys) {
				// 查找活动商品
				List<MActivityProduct> activityProducts = activityProOper.findMActivityProductList(item.getInt("id"));
				for (MActivityProduct mp : activityProducts) {
					// 没有在此时间段内的
					if (miOper.isInInterval(item.getInt("id")) == null || mp.getDouble("product_count") <= 0) {
						item.set("isInInterval", false);
						pfOper.updateSpecialPriceAsPrice(mp.getInt("product_f_id"));
						break;
					} else {// 活动期间内，查找到对应活动商品，并且将价格设置成活动价格

						item.set("isInInterval", true);
						pfOper.updateSpecialPrice(mp.getInt("product_f_id"), mp.getInt("activity_price"));
						break;
					}
				}
			}

			// 查询是否在抢购活动时间内
			setAttr("activitys", activitys);

			List<Record> tCategorys = (List<Record>) cacheMap.get("tCategorys");
			// 四大分类
			if (tCategorys == null || viewTimesLocal == 0) {
				tCategorys = new TCategory().findTCategorys("0");
				cacheMap.putIfAbsent("tCategorys", tCategorys);
			}
			setAttr("tCategorys", tCategorys);

			// 优惠券
			// List<Record> tCouponActivitys = activity.findMActivitys(5);
			// if(tCouponActivitys.size()>0){
			// TCoupon coupon=new TCoupon();
			// List<Record> couponList=
			// coupon.findTCouponKind(tCouponActivitys.get(0).getInt("id").toString());
			// //优惠券活动相关信息
			// setAttr("tCouponActivity", tCouponActivitys.get(0));
			// //优惠券活动中的优惠券种类列表
			// setAttr("couponList",couponList);
			// }
			// 优惠券
			List<Record> tCouponActivitys = activity.findMActivitys(5);
			if (tCouponActivitys.size() > 0) {
				TCouponCategory coupon = new TCouponCategory();
				List<Record> couponList = coupon
						.findTCouponCategoryByActivityId(tCouponActivitys.get(0).getInt("id").toString());
				// 优惠券活动相关信息
				setAttr("tCouponActivity", tCouponActivitys.get(0));
				// 优惠券活动中的优惠券种类列表
				setAttr("couponList", couponList);
			}

			List<Record> mRecommends = (List<Record>) cacheMap.get("mRecommends");
			// 主推商品
			if (mRecommends == null || viewTimesLocal == 0) {
				mRecommends = new MRecommend().findMRecommendsByTypeId(1);
				cacheMap.putIfAbsent("mRecommends", mRecommends);
			}
			setAttr("mRecommends", mRecommends);

			// 热门爆款
			List<Record> weekRecommends = (List<Record>) cacheMap.get("weekRecommends");

			if (weekRecommends == null || viewTimesLocal == 0) {
				weekRecommends = new MRecommend().findMRecommendsByTypeId(2);
				cacheMap.putIfAbsent("weekRecommends", weekRecommends);
			}
			setAttr("weekRecommends", weekRecommends);
			// 最底下活动商品
			Activitys bottomActivitys = (Activitys) cacheMap.get("bottomActivitys");
			Activitys result = new Activitys();
			// 主推商品
			if (bottomActivitys == null || viewTimesLocal == 0) {
				// 活动列表数据
				List<Record> bottomActivityList = activity.findMActivitys(2);

				MActivityProduct mActivityProduct = new MActivityProduct();
				// 循环活动列表
				for (Record item : bottomActivityList) {
					Activitys.BottomActivity bottomActivity = result.new BottomActivity();
					bottomActivity.setImgSrc(item.getStr("save_string"));
					bottomActivity.setUrl(item.getStr("url"));
					bottomActivity.setId(item.get("id") + "");
					bottomActivity.setProducts(mActivityProduct.findMActivityProducts(item.getInt("id")));
					result.getBottomActivity().add(bottomActivity);
				}
				cacheMap.putIfAbsent("bottomActivitys", result);
			}
			setAttr("bottomActivitys", result);

			// 首页其它设置参数
			Map<String, String> indexSetting = (Map<String, String>) cacheMap.get("indexSetting");
			if (indexSetting == null || viewTimesLocal == 0) {
				TIndexSetting indexSettingOper = new TIndexSetting();
				indexSetting = indexSettingOper.getIndexSettingMap();
				cacheMap.putIfAbsent("indexSetting", indexSetting);
			}
			setAttr("indexSetting", indexSetting);
			// 排名活动或者banner展示活动
			List<Record> bannerActivitys = (List<Record>) cacheMap.get("bannerActivitys");
			if (bannerActivitys == null || viewTimesLocal == 0) {
				bannerActivitys = activity.findMActivitys(new int[] { 9 });
				cacheMap.putIfAbsent("bannerActivitys", bannerActivitys);
			}
			setAttr("bannerActivitys", bannerActivitys);
			
			//团购banner展示活动
			List<Record> groupActivity = (List<Record>) cacheMap.get("groupActivity");
			if(groupActivity == null || viewTimesLocal == 0){
				groupActivity = activity.findGroupMActivity(10);
				cacheMap.putIfAbsent("groupActivity", groupActivity);
			}
			setAttr("groupActivity", groupActivity);
			/*
			 * 滚动公告
			 */
			MActivity annoucementActivity = MActivity.dao.findYxActivityByType(14);
			if (annoucementActivity == null) {
				annoucementActivity = new MActivity();
			}
			cacheMap.putIfAbsent("annoucementActivity", annoucementActivity);
			setAttr("annoucementActivity", annoucementActivity);
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/shopIndex1.ftl");
		}
	}

	/**
	 * “我的”页面
	 */
	@Before(OAuth2Interceptor.class)
	public void me() {
		// 登录用户
		TUser tUserSession = UserStoreUtil.get(getRequest());
        TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));

        if (StringUtil.isNull(user.getStr("phone_num"))) {
            render(AppConst.PATH_MANAGE_PC + "/client/mobile/member_mobile.ftl");
        } else {
			TUser tUser = new TUser();
			int userId = tUserSession.get("id");
			// 查找用户基本信息和积分总和
			TUser result = tUser.findTUserInfo(userId);
			setAttr("tUser", result);
			// 查询订单信息（订单数量）
			TOrder tOrder = new TOrder();
			Record totalOrder = tOrder.findTOrderTotal(userId);
			setAttr("totalOrder", totalOrder);
			Record myPresent = new TPresent().findMyPresentCount(userId);
			setAttr("myPresent", myPresent);
			TUserCoupon userCoupon = new TUserCoupon();
			List<Record> userCouponList = userCoupon.findTUserCoupon(userId);
			//是否开启种子
			Record mActivity = Db.findFirst("select *from m_activity where activity_type=18 and yxbz='Y' ");
			if(mActivity!=null){
				setAttr("activityId", mActivity.getInt("id"));
			}else{
				setAttr("activityId", 0);
			}
			// 优惠券数量
			setAttr("couponCount", (userCouponList == null) ? 0 : userCouponList.size());
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/me.ftl");
		}
	}

	/**
	 * 我的基本信息
	 */
	public void myDetial() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser tUser = new TUser().findById(tUserSession.get("id"));
		setAttr("user", tUser);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myDetial.ftl");
	}

	/**
	 * 清除用户session信息
	 */
	public void clear() {
		UserStoreUtil.clear(getRequest(), getResponse());
		renderJson();
	}

	public void userModifyCmt() {
		TUser tUser = getModel(TUser.class, "tUser");
		tUser.update();
		redirect("/me");
	}

	/**
	 * 我的订单
	 */
	@Before(OAuth2Interceptor.class)
	public void myOrder() {
		// 此处只是为了初始化页面为哪个tab项
		setAttr("type", getPara("type"));
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TOrder orderOper = new TOrder();
		// 查询分类订单下的订单列表和订单中的商品信息（所有）
		List<TOrder> tOrders = orderOper.findTOrdersByUserId1(tUserSession.get("id"));
		setAttr("tOrders", tOrders);
		List<TOrder> dfkTOrders = new ArrayList<TOrder>();
		List<TOrder> dshTOrders = new ArrayList<TOrder>();
		List<TOrder> thTOrders = new ArrayList<TOrder>();
		//查找种子购活动是否开启
		MActivity mactivity = MActivity.dao.findFirst("select * from m_activity where yxbz='Y' and activity_type=18 ");
		List<Map<String,Object>> temp=new ArrayList<>();
		for (TOrder order : tOrders) {
			Map<String,Object> orderItem=new HashMap<>();
			orderItem.put("orderId",order.getStr("order_id"));
			if(order.getInt("order_style")!=null&&order.getInt("order_style")==2 && "2018-01-01 00:00:00".compareTo(order.getStr("createtime"))<=0){//兑换订单不能退货
				orderItem.put("isVisible", "false");
			}else{
				//活动开启且单线，不让直接退货
				if(mactivity!=null&&order.isTeamOrder()==false){//退货按钮
					orderItem.put("isVisible", "false");
				}else{
					orderItem.put("isVisible", "true");
				}
			}
			temp.add(orderItem);
			
			if (order.getStr("order_status").equals("1")) {// 查询分类订单下的订单列表和订单中的商品信息（待付款）
				dfkTOrders.add(order);
			} else if (order.getStr("order_status").equals("3") || order.getStr("order_status").equals("12")) {// 查询分类订单下的订单列表和订单中的商品信息（已付款）
				dshTOrders.add(order);
			} else if (order.getStr("order_status").equals("4") || order.getStr("order_status").equals("5")
					|| order.getStr("order_status").equals("6") || order.getStr("order_status").equals("7")
					|| order.getStr("order_status").equals("8")) {// 查询分类订单下的订单列表和订单中的商品信息（退货）
				thTOrders.add(order);
			}
		}
		setAttr("temp", temp);
		setAttr("dfkTOrders", dfkTOrders);
		setAttr("dshTOrders", dshTOrders);
		setAttr("thTOrders", thTOrders);
		// 查询是否为首次消费，如果首次消费且到店自提，则提示提货流程

		if ("2".equals(getPara("deliverytype")) && orderOper.isUserFirstBuy(tUserSession.get("id"))) {
			setAttr("isUserFirstBuy", true);
		}
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myOrder.ftl");
	}

	/**
	 * 我的订单-取消订单
	 */
	public void cancelOrder() {
		int orderId = getParaToInt("orderId");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int user = tUserSession.get("id");
		int count = new TOrder().updateStatus(orderId, user, "1", "0");
		Map<String, String> result = new HashMap<String, String>();
		if (count > 0) {
			result.put("result", "success");
		} else {
			result.put("result", "failed");
			result.put("msg", "操作失败,请检查订单状态！");
		}
		renderJson(result);
	}

	/**
	 * 海鼎取消订单（未备货状态下）
	 * @throws Exception 
	 */
	public void hdCancelOrder() throws Exception {
		JSONObject jsonResult = new JSONObject();
		jsonResult.put("success", false);
		jsonResult.put("message", "未找到订单或订单状态有误");
		int id = getParaToInt("hdCancelOrderId");
		TOrder oper = new TOrder();
		TOrder order = oper.findById(id);
		if (order != null && "3".equals(order.getStr("order_status"))&&"confirmed".equals(HdUtil.orderDetail(order.getStr("order_id")))) {
			// 是别人的客户，此时就需要添加一条收支明细
			Record orderRecord = Db.findFirst("select * from t_order where id = ?", id);
			if (StringUtil.isNotNull(String.valueOf(orderRecord.getInt("master_id")))) {
				XAchievementRecord.dao.addXAchievementRecord(orderRecord, 4);
			}
			// 设置成取消中
			oper.updateReason(id, order.getInt("order_user"), "3", "7", getPara("reason"));
			// 取消订单为所有订单商品都是退货状态
			List<Record> orderProList = oper.findOrderProList(id);
			for (Record item : orderProList) {
				item.set("is_back", "Y");
				Db.update("t_order_products", item);
			}
			// 改订单为退款完成并退款
			String hdCancelOrderResult = HdUtil.orderCancel(order.getStr("order_id"), order.getStr("reason"));
			// code=200{...}
			if (hdCancelOrderResult != null) {
				// 去掉 code=200
				hdCancelOrderResult = hdCancelOrderResult.substring(8);
				jsonResult = JSONObject.parseObject(hdCancelOrderResult);
				// 调用成功
				if (jsonResult.getBooleanValue("success")) {
					StringBuffer sql = new StringBuffer();
					sql.append(
							"select t.order_type,t.order_user,t.order_store,t.order_id,t.need_pay,t.delivery_fee,p.out_trade_no,p.source_type,p.source_table from t_order t ");
					sql.append(" left join t_pay_log p ");
					sql.append(" on t.order_id=p.out_trade_no ");
					sql.append(" where t.order_id=? ");

					Record pay = Db.findFirst(sql.toString(), order.getStr("order_id"));
					// 赠送提货订单或者余额支付订单，直接转成用户余额
					if ("2".equals(pay.getStr("order_type")) || ("t_user".equals(pay.getStr("source_table"))
							&& "balance".equals(pay.getStr("source_type"))
							&& StringUtil.isNotNull(pay.getStr("out_trade_no"))
							&& pay.getStr("out_trade_no").length() == 18)) {
						// 修改订单为已退款
						if (oper.updateStatus(order.getInt("id"), order.getInt("order_user"), "7", "6") == 1) {
							// 加果币+退运费
							Db.update("update t_user set balance=balance+? where id=?",
									pay.getInt("need_pay") + pay.getInt("delivery_fee"), pay.getInt("order_user"));
							// 增加加果币记录
							TBlanceRecord tBlanceRecord = new TBlanceRecord();
							tBlanceRecord.set("store_id", pay.getStr("order_store"));
							tBlanceRecord.set("user_id", order.getInt("order_user"));
							tBlanceRecord.set("blance", pay.getInt("need_pay") + pay.getInt("delivery_fee"));
							tBlanceRecord.set("ref_type", "orderBack");
							tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
							tBlanceRecord.set("order_id", order.getStr("order_id"));
							tBlanceRecord.save();
							logger.info("赠送提货订单或者余额支付订单，直接转成用户余额:" + order.getStr("order_id") + "-blance:"
									+ pay.getInt("need_pay"));
							jsonResult.put("success", false);
							jsonResult.put("message", "取消订单成功，直接转成用户余额");
						} else {
							jsonResult.put("success", false);
							jsonResult.put("message", "修改订单状态失败");
						}
					} else {
						// 直接支付订单 可能存在调货，调货要根据原始订单编号退货 不退运费
						String orderId = StringUtil.isNotNull(order.getStr("old_order_id"))
								? order.getStr("old_order_id") : order.getStr("order_id");
						String result = WeChatUtil.refund(orderId, pay.getInt("need_pay") + pay.getInt("delivery_fee"),
								new File(getRequest().getSession().getServletContext()
										.getRealPath("/WEB-INF/classes/apiclient_cert.p12")));
						logger.info("直接支付订单result:" + result);
						if (result.indexOf("SUCCESS") != -1) {
							jsonResult.put("success", true);
							jsonResult.put("message", "取消订单成功，直接支付订单已经申请微信退款");
							oper.updateStatus(order.getInt("id"), order.getInt("order_user"), "7", "6");
							//添加退款记录
		    				XPathParser xpath = new XPathParser(result);
		    				XNode refund_fee = xpath.evalNode("//refund_fee");
		    				XNode transaction_id = xpath.evalNode("//transaction_id");
		    				TRefundLog refundLog = new TRefundLog();
		    				refundLog.set("user_id", order.getInt("order_user"));
		    				refundLog.set("refund_fee", refund_fee.body());
		    				refundLog.set("transaction_no", transaction_id.body());
		    				refundLog.set("refund_time", DateFormatUtil.format1(new Date()));
		    				refundLog.set("order_id",order.getStr("order_id") );
		    				refundLog.save();
						} else {
							jsonResult.put("success", false);
							jsonResult.put("message", "直接支付订单申请微信退款失败");
						}
					}
					logger.info("订单编号：" + order.getStr("order_id") + "发送海鼎取消订单成功");
				}
				jsonResult.put("success", true);
				jsonResult.put("message", "订单取消申请成功");
			} else {
				jsonResult.put("message", "调用接口失败，请联系客服");
			}
		} else if ("1".equals(order.getStr("hd_status"))) {
			jsonResult.put("success", false);
			jsonResult.put("message", "订单海鼎发送状态为失败");
		}
		renderJson(jsonResult);
	}

	/**
	 * 我的订单-确认收货
	 */
	public void confirmReceipt() {
		int orderId = getParaToInt("orderId");
		String order_status = getPara("order_status");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int user = tUserSession.get("id");
		int count = new TOrder().updateStatus(orderId, user, order_status, "4");
		Map<String, String> result = new HashMap<String, String>();
		if (count > 0) {
			result.put("result", "success");
		} else {
			result.put("result", "failed");
			result.put("msg", "操作失败,请检查订单状态！");
		}
		renderJson(result);
	}

	/**
	 * 我的订单-退货
	 */
	public void returnOrder() {
		System.out.println("==============================================");
		int orderId = getParaToInt("orderId");
		Map<String, String> result = new HashMap<String, String>();
		// 退货原因
		String reason = getPara("reason");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int user = tUserSession.get("id");
		TOrder oper = new TOrder();
		TOrder order = oper.findById(orderId);
		if("delivering".equals(HdUtil.orderDetail(order.getStr("order_id")))||"delivered".equals(HdUtil.orderDetail(order.getStr("order_id")))){
			int count = oper.updateReason(orderId, user, "4", "5", reason);
			// 取消的订单商品
			Integer[] cancelPIds = getParaValuesToInt("cancel_fruit");
			List<Record> orderProList = oper.findOrderProList(orderId);
			// 处理部分退货
			for (Record item : orderProList) {
				for (Integer pid : cancelPIds) {
					if (item.getInt("product_id").equals(pid)) {
						item.set("is_back", "Y");
						Db.update("t_order_products", item);
						break;
					}
				}
			}
			if (order != null && count > 0) {
				// 查看是否调货订单，调货订单要用新分配单号去做处理
				if (HdUtil.orderRejected(order.getStr("order_id"))) {
					order.set("order_status", "8");
					logger.info("订单编号：" + orderId + "发送海鼎退货成功");
					result.put("msg", "退货申请成功,请将商品退给门店");
					result.put("result", "success");
				} else {
					order.set("order_status", "9");
					logger.info("订单编号：" + orderId + "发送海鼎退货失败");
					result.put("result", "failed");
					result.put("msg", "操作失败,请联系管理员！");
				}
				order.update();
	
			} else {
				result.put("result", "failed");
				result.put("msg", "操作失败,请联系管理员！");
				logger.info("订单编号：" + orderId + "更新订单状态失败");
			}
		}else{
			result.put("result", "failed");
			result.put("msg", "操作失败,请联系管理员！");
			logger.info("订单编号：" + orderId + "海鼎订单状态不正确更新订单状态失败");
		}
		renderJson(result);
	}

	/**
	 * 帮助中心
	 */
	public void faq() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/FAQ.ftl");
	}

	/**
	 * 帮助中心-FAQ列表
	 */
	public void faqList() {
		String type = getPara("type");
		List<TFaqDetail> faqList = new TFaqDetail().findFaqByType(type);
		setAttr("faqList", faqList);
		String typeName = "";
		if (type.equals("1")) {
			typeName = "售前问题";
		} else if (type.equals("2")) {
			typeName = "售后问题";
		} else if (type.equals("3")) {
			typeName = "退换货";
		}
		setAttr("typeName", typeName);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/FAQ_list.ftl");
	}

	/**
	 * 鲜果养生-列表
	 */
	public void healthList() {
		// String type = getPara("type");
		List<TRepository> repList = new TRepository().findTRepository();
		setAttr("repList", repList);
		// String typeName = "";
		// if(type.equals("1")){
		// typeName = "美味果汁";
		// }else if(type.equals("2")){
		// typeName = "水果美容";
		// }else if(type.equals("3")){
		// typeName = "水果食疗";
		// }
		// setAttr("typeName", typeName);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/healthList.ftl");
	}

	public void healthDetail() {
		int id = getParaToInt("id");
		TRepository rep = new TRepository().findById(id);
		setAttr("rep", rep);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/health_detail.ftl");
	}

	/**
	 * 反馈中心
	 */
	public void feedback() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/feedback.ftl");
	}

	/**
	 * 反馈提交
	 */
	public void feedback_cmt() {
		String now = DateFormatUtil.format1(new Date());
		TFeedback feedback = new TFeedback();
		feedback.set("fb_title", getPara("fb_title"));
		feedback.set("fb_content", getPara("fb_content"));
		feedback.set("fb_type", getPara("fb_type"));// 0.微商城用户反馈 1.鲜果师反馈
													// 2.鲜果师商城用户反馈
		feedback.set("fb_time", now);
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		feedback.set("fb_user", userId);
		Record record = new Record();
		record.setColumns(model2map(feedback));
		Db.save("t_feedback", record);
		renderJson();
	}

	/**
	 * 我的钱途
	 */
	public void myCost() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myCost.ftl");
	}

	/**
	 * 门店列表 以后可以根据定位计算远近店铺排序
	 */
	public void store() {
		List<Record> storeList = new TStore().findStores();
		String lat = getPara("lat");
		String lng = getPara("lng");
		if (StringUtil.isNotNull(lng) && StringUtil.isNotNull(lat)) {
			for (Record store : storeList) {
				String store_lat = store.getStr("lat");
				String store_lng = store.getStr("lng");
				String distance = "";
				try {
					distance = MapUtil.getDistance(lat, lng, store_lat, store_lng);
				} catch (Exception e) {
					distance = "-1";
				}
				store.set("distance", distance);
			}
			Collections.sort(storeList, new Comparator<Record>() {
				public int compare(Record record1, Record record2) {
					String distanceStr1 = record1.get("distance");
					String distanceStr2 = record2.get("distance");
					int distance1 = (int) (Double.parseDouble(distanceStr1) * 10);
					int distance2 = (int) (Double.parseDouble(distanceStr2) * 10);
					return distance1 - distance2;
				}
			});
		}
		setAttr("storeList", storeList);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/store.ftl");
	}

	/**
	 * 购物车页面
	 * 
	 * @throws Exception
	 */
	@Before(OAuth2Interceptor.class)
	public void cart() throws Exception {
		// 获取到购物车中商品信息
		String cartInfo = getCookie("cartInfo");
		List<Map<String, Object>> proList = new ArrayList<Map<String, Object>>();
		double sum = 0.00;
		boolean cookieNull = false;
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			JSONArray cartInfoJsonCopy = new JSONArray();
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
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
				if (product == null) {
					cookieNull = true;
					continue;
				} else {
					cartInfoJsonCopy.add(item);
				}
				int productNum = item.getInteger("product_num");
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("product", product);
				map.put("productNum", productNum);
				proList.add(map);
				// 商品价格乘以商品数量 除以100换算成元
				sum += (product.getInt("real_price") == null ? 0 : product.getInt("real_price")) * productNum;
			}
			if (cookieNull) {
				setCookie("cartInfo", cartInfoJsonCopy.toJSONString(), 604800);
			}
		}
		setAttr("sum", sum);
		setAttr("proList", proList);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/cart.ftl");
	}

	/**
	 * 计算门店距离排序
	 */
	public void storeList() {
		List<Record> storeList = new TStore().findStores();
		String lat = null, lng = null;
		String flag = getPara("flag");
		/*
		 * 无论是送货上门还是门店自提，都必须传递经纬度 if ("2".equals(flag)) { String address =
		 * getPara("address"); if (StringUtil.isNotNull(address)) {//
		 * 有地址，则根据地址获取经纬度 JSONObject json = null; try { json =
		 * BaiduMapUtil.getLocation(address); } catch (Exception e) {
		 * e.printStackTrace(); } if (json != null) { JSONObject result =
		 * (JSONObject) json.get("result"); if (result != null) { JSONObject
		 * location = (JSONObject) result.get("location"); if (location != null)
		 * { lat = location.get("lat").toString(); lng =
		 * location.get("lng").toString(); } } } } } else { lat =
		 * getPara("lat"); lng = getPara("lng"); }
		 */
		lat = getPara("lat");
		lng = getPara("lng");
		if (StringUtil.isNull(lng) || StringUtil.isNull(lat)) {// 获取不到经纬度，则不排序显示全部
			renderJson(storeList);
			return;
		}
		// 根据经纬度计算与门店距离
		for (Record store : storeList) {
			String store_lat = store.getStr("lat");
			String store_lng = store.getStr("lng");
			String distance = "";
			try {
				distance = MapUtil.getDistance(lat, lng, store_lat, store_lng);
			} catch (Exception e) {
				distance = "-1";
			}
			store.set("distance", distance);
		}
		// 根据距离排序
		Collections.sort(storeList, new Comparator<Record>() {
			public int compare(Record record1, Record record2) {
				String distanceStr1 = record1.get("distance");
				String distanceStr2 = record2.get("distance");
				int distance1 = (int) (Double.parseDouble(distanceStr1) * 10);
				int distance2 = (int) (Double.parseDouble(distanceStr2) * 10);
				return distance1 - distance2;
			}
		});
		renderJson(storeList);
	}
	/**
	 * 门店列表
	 */
	public void initStoreList() {
		List<Record> storeList = new TStore().findStores();
		String lat = getPara("lat"), lng = getPara("lng");
		if (StringUtil.isNull(lng) || StringUtil.isNull(lat)) {// 获取不到经纬度，则不排序显示全部
			renderJson(storeList);
			return;
		}
		// 根据经纬度计算与门店距离
		for (Record store : storeList) {
			String store_lat = store.getStr("lat");
			String store_lng = store.getStr("lng");
			String distance = "";
			try {
				distance = MapUtil.getDistance(lat, lng, store_lat, store_lng);
			} catch (Exception e) {
				distance = "-1";
			}
			store.set("distance", distance);
		}
		// 根据距离排序
		Collections.sort(storeList, new Comparator<Record>() {
			public int compare(Record record1, Record record2) {
				String distanceStr1 = record1.get("distance");
				String distanceStr2 = record2.get("distance");
				int distance1 = (int) (Double.parseDouble(distanceStr1) * 10);
				int distance2 = (int) (Double.parseDouble(distanceStr2) * 10);
				return distance1 - distance2;
			}
		});
		setAttr("storeList",storeList);
		render(AppConst.PATH_MANAGE_PC+"/client/mobile/selectStore.ftl");
	}
	
	/**
	 * 订单提交页面
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void order() throws UnsupportedEncodingException {
		String currDate = DateFormatUtil.format4(new Date());
		setAttr("currDate", currDate);
		List<Record> storeList = new TStore().findStores();
		
		setAttr("storeList", storeList);
		String cartInfo = getCookie("cartInfo");// 从cookie中取得商品信息
		String pId = getPara("pId");// 商品编号
		String pfId = getPara("pfId");// 规格编号
		int totalPrice = 0;
		int[] pfIds = null;
		//是否全为年货
		boolean isAllSpecialGoods=false;
		if (StringUtil.isNotNull(pId) && StringUtil.isNotNull(pfId)) {
			Record product = new TProductF().findTProductFById(Integer.parseInt(pfId));
			totalPrice = product.getInt("real_price");
			// 只是买一个商品
			String productInfo = getCookie("productInfo");
			if (StringUtil.isNotNull(productInfo)) {
				removeCookie("productInfo");
			}
			setCookie("productInfo", "[{'product_id':" + pId + "#'product_num':'1'#'pf_id':" + pfId + "}]", 604800);
			setAttr("isSingle", 1);
			// 装载到数值中用于下面优惠券活动中屏蔽操作
			pfIds = new int[] { Integer.valueOf(pfId) };
			//判断是年货分类
			if(product.getStr("category_id").startsWith("06")){
				isAllSpecialGoods=true;
			}
		}
		// 购物车商品
		else if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			TProduct tpOper = new TProduct();
			JSONArray needRemove = new JSONArray();
			pfIds = new int[cartInfoJson.size()];
			boolean[] isAllSpecialGoodsList=new boolean[cartInfoJson.size()];
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int pf_Id = item.getInteger("pf_id");
				// 装载到数值中用于下面优惠券活动中屏蔽操作
				pfIds[i] = pf_Id;
				int productNum = item.getInteger("product_num");
				int productId = item.getInteger("product_id");
				TProduct tp = tpOper.findTProductId(productId);
				// 防止后台已经修改了商品下架购物车中还能继续购买问题
				if (!"01".equals(tp.get("product_status"))) {
					needRemove.add(item);
					continue;
				}
				Record product = new TProductF().findTProductFById(pf_Id);
				totalPrice += product.getInt("real_price") * productNum;
				//判断是年货分类
				if(product.getStr("category_id").startsWith("06")){
					isAllSpecialGoodsList[i]=true;
				}else{
					isAllSpecialGoodsList[i]=false;
				}
			}
			//检索是否有不是年货的商品
			for(boolean item:isAllSpecialGoodsList){
				if(item){
					isAllSpecialGoods=true;
				}else{
					isAllSpecialGoods=false;
					break;
				}
			}
			// 将购物车中已经下架的商品移除掉
			// cartInfoJson.removeAll(needRemove);
			// setCookie("cartInfo",cartInfoJson.toJSONString(),604800);
			setAttr("isSingle", 0);
		} else {
			redirect("/cart");
			return;
		}
		setAttr("balance", totalPrice);
		//是否全部是年货商品
		setAttr("isAllSpecialGoods", isAllSpecialGoods?0:1);
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		// 显示优惠券 排除掉活动中需要排除的商品（如特价）
		List<Record> couponList = new TUserCoupon().findUserCoupons(userId, totalPrice, pfIds);
		setAttr("couponList", couponList);
		setAttr("storeId",getCookie("store_id")==null?"07310109":getCookie("store_id"));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/order.ftl");
	}

	/**
	 * 订单选择地址
	 */
	public void orderAddress() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/order_addressPanel.ftl");
	}
	public void test() throws Exception{
		HdUtil.querySku("07310109", new String[]{"90825"});
		/*1860
		90825
		2860*/
	}
	
	/**
	 * 是否已使用过优惠券(防止返回重复使用优惠券)
	 */
	public void isOrderCoupon(){
		String order_coupon = getPara("order_coupon");
		JSONObject result = new JSONObject();
		if(StringUtil.isNotNull(order_coupon)){
			TUserCoupon userCoupon = TUserCoupon.dao.findUserCouponByCouponId(getParaToInt("order_coupon"));
			//优惠券0 未过期 1 已过期
			if(userCoupon!=null){
				if(userCoupon.getStr("is_expire").equals("1")){
					result.put("msg", "该优惠券已过期！");
					renderJson(result);
					return;
				}
			}else{
				result.put("msg", "没有该优惠券！");
				renderJson(result);
				return;
			}
		}
		result.put("msg", 1);
		renderJson(result);
	}
	
	/**
	 * 订单提交
	 * @throws Exception 
	 */
	public void orderCmt() throws Exception {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		String now = DateFormatUtil.format1(new Date());
		TOrder order = getModel(TOrder.class, "order");
		Record record = new Record();
		record.setColumns(model2map(order));
		record.set("createtime", now);
		// 直接单独购买1或者购物车购买0
		int isSingle = StringUtil.isNull(getPara("isSingle")) ? 0 : getParaToInt("isSingle");
		String cartInfo = isSingle == 0 ? getCookie("cartInfo") : getCookie("productInfo");// 从cookie中取得商品信息
		if (StringUtil.isNull(cartInfo)) {
			redirect("/myOrder?type=1");
			return;
		}
		cartInfo = cartInfo.replaceAll("#", ",");
		int totalPrice = 0;// 商品总金额
		int discount = 0;// 优惠金额
		int needPay = 0;// 应付金额
		List<Map<String, Integer>> orderProducts = new ArrayList<Map<String, Integer>>();
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
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
		} else {
			redirect("/myOrder?type=1");
			return;
		}
		
		int userId = tUserSession.get("id");
		// 优惠券编号
		Integer coupon = null;
		if (order.get("order_coupon") != null) {
			coupon = order.getInt("order_coupon");
		}
		// 优惠信息在订阅活动中处理
		record.set("order_user", userId);
		needPay = totalPrice;
		record.set("total", totalPrice);
		record.set("order_coupon", coupon);
		record.set("discount", discount);
		record.set("need_pay", needPay);
		record.set("order_id", orderNoGenerator.nextId());
		record.set("order_status", "1");
		record.set("order_style", 0);
		Db.save("t_order", record);
		// 收集用户手机号并且填到用户信息中
		if (StringUtil.isNull(tUserSession.getStr("phone_num"))) {
			String phoneNum = getPara("phone_num");
			// 先取界面联系方式,如果为空就取订单地址中的联系方式
			if (StringUtil.isNull(phoneNum)) {
				phoneNum = getPara("order.receiver_mobile");
			}
			tUserSession.set("phone_num", phoneNum);
			tUserSession.update();
			// 发送数据到海鼎进行注册
			HdUtil.registUser("07310109", phoneNum, phoneNum);
		}

		// 购买 赠送不做优惠券领取
		TOrder orderOper = new TOrder();
		TOrder orderQuery = orderOper.findTOrderByOrderId(record.getStr("order_id"));
		/****** 订阅支付中活动 ******************/

		OrderTransmitData orderData = new OrderTransmitData();
		// 满立减活动
		Watcher orderActivity1Watcher = new OrderActivity1Watcher();
		// 优惠券抵扣活动
		Watcher orderActivity2Watcher = new OrderActivity2Watcher();

		Watched orderActivityWatched = new ConcreteWatched();
		// 先做优惠券抵扣再做满立减活动
		orderActivityWatched.addWatcher(orderActivity2Watcher, 0);
		orderActivityWatched.addWatcher(orderActivity1Watcher, 1);

		orderData.setUserId(userId);

		orderData.setCurrentTime(new Date());

		// 此处实际查询不到用户订单商品，因为还没有存储相关记录
		order.setOrderProducts(orderOper.findOrderProList(orderQuery.getInt("id")));
		orderData.setType("gm");
		orderData.setOrderId(orderQuery.getInt("id"));
		orderData.setNeedPay(orderQuery.getInt("need_pay"));
		if (orderQuery.getInt("order_coupon") != null) {
			orderData.setCouponId(orderQuery.getInt("order_coupon"));
		}
		order.setTotalProduct(order.getOrderProducts().size());
		orderData.setOrder(order);

		orderActivityWatched.notifyWatchers(orderData);

		/****** 订阅支付中活动 ******************/
		long id = record.getLong("id");
		TOrder orderAfterDiscount = orderOper.findTOrderByOrderId(record.getStr("order_id"));
		/*
		 * discount=(orderAfterDiscount.getInt("discount")==null)?0:
		 * orderAfterDiscount.getInt("discount");//订单优惠价格
		 * totalPrice=(orderAfterDiscount.getInt("total")==null)?
		 * orderAfterDiscount.getInt("need_pay"):orderAfterDiscount.getInt(
		 * "total");//订单总价 赠送订单不会存储总价
		 */
		// 单位折扣率
		double unitDiscount = 0;
		// 查看是否是用的单品优惠券
		boolean is_singleCoupon = false;
		if (orderAfterDiscount.get("order_coupon")!=null) {
			is_singleCoupon = TCouponReal.dao.isSingleCoupon(orderAfterDiscount.getInt("order_coupon"));
		}
		if (is_singleCoupon) {
			// 此处使用了单品优惠券，单品优惠券单独分摊到单独的商品上
			Record productCouponRecord = Db.findFirst(
					"select pc.*,cs.* from t_product_coupon pc left join t_coupon_scale cs on pc.coupon_scale_id = cs.id where pc.coupon_scale_id in (SELECT coupon_scale_id from t_coupon_real cr where cr.id=?)",
					orderAfterDiscount.getInt("order_coupon"));
			/*//只使用了单品优惠券
			if(orderAfterDiscount.getInt("discount")==productCouponRecord.getInt("coupon_val")){
				discount = (orderAfterDiscount.getInt("discount") == null) ? 0 : orderAfterDiscount.getInt("discount");// 订单优惠价格
			}else{}*/
				//还有其他优惠,其他优惠需要均摊
			discount = (orderAfterDiscount.getInt("discount") == null) ? 0 : orderAfterDiscount.getInt("discount")-productCouponRecord.getInt("coupon_val");// 订单优惠价格
			
			totalPrice = (orderAfterDiscount.getInt("total") == null) ? orderAfterDiscount.getInt("need_pay")
					: orderAfterDiscount.getInt("total");// 订单总价 赠送订单不会存储总价
			// 单位折扣率
			unitDiscount = discount / (1.0 * totalPrice);
			for (Map<String, Integer> pro : orderProducts) {
				Record orderPro = new Record();
				orderPro.set("order_id", id);
				orderPro.set("product_id", pro.get("productId"));
				orderPro.set("product_f_id", pro.get("pfId"));
				orderPro.set("amount", pro.get("productNum"));
				orderPro.set("unit_price", pro.get("unitPrice"));
				orderPro.set("buy_time", now);
				// 单品总价 减掉分摊优惠金额
				int a = productCouponRecord.getInt("product_f_id");int b=pro.get("pfId");
				if(productCouponRecord.getInt("product_f_id")==(int)pro.get("pfId")){//减掉分摊优惠金额和单品优惠券金额
					orderPro.set("pay_price", (1 - unitDiscount) * pro.get("unitPrice")-productCouponRecord.getInt("coupon_val"));
				}else{
					//如果优惠金额大于应付金额要设值为0
					if((1 - unitDiscount) * pro.get("unitPrice")<0){
						orderPro.set("pay_price", 0);
					}else{
						orderPro.set("pay_price", (1 - unitDiscount) * pro.get("unitPrice"));
					}
				}
				Db.save("t_order_products", orderPro);
			}
		} else {// 没有
			discount = (orderAfterDiscount.getInt("discount") == null) ? 0 : orderAfterDiscount.getInt("discount");// 订单优惠价格
			totalPrice = (orderAfterDiscount.getInt("total") == null) ? orderAfterDiscount.getInt("need_pay")
					: orderAfterDiscount.getInt("total");// 订单总价 赠送订单不会存储总价
			// 单位折扣率
			unitDiscount = discount / (1.0 * totalPrice);
			for (Map<String, Integer> pro : orderProducts) {
				Record orderPro = new Record();
				orderPro.set("order_id", id);
				orderPro.set("product_id", pro.get("productId"));
				orderPro.set("product_f_id", pro.get("pfId"));
				orderPro.set("amount", pro.get("productNum"));
				orderPro.set("unit_price", pro.get("unitPrice"));
				orderPro.set("buy_time", now);
				// 单品总价 减掉分摊优惠金额
				if((1 - unitDiscount) * pro.get("unitPrice")<0){
					orderPro.set("pay_price",0);
				}else{
					orderPro.set("pay_price", (1 - unitDiscount) * pro.get("unitPrice"));
				}
				Db.save("t_order_products", orderPro);
			}
		}
		removeCookie("cartInfo");
		redirect("/pay/sbmtOrder?id=" + id);
	}
	
	// public void addressList() {
	// TUser user= UserStoreUtil.get(getRequest());
	// int user_id =user.getInt("id");
	// List<Record> addressList = new TReceiverAddress().findAddresses(user_id);
	// setAttr("addressList", addressList);
	// render(AppConst.PATH_MANAGE_PC + "/client/mobile/addressList.ftl");
	// }

	/**
	 * 新增收货地址
	 */
	// public void saveAddress(){
	// JSONObject result = new JSONObject();
	// try{
	// TUser user= UserStoreUtil.get(getRequest());
	// TReceiverAddress address = new TReceiverAddress();
	// String address_id = getPara("address_id");
	// String is_default = getPara("is_default");
	// //通过session获取用户信息
	// int user_id = user.getInt("id");
	// String province = getPara("province");
	// String city = getPara("city");
	// String area = getPara("area");
	// String receiver_address = getPara("receiver_address");
	// if(StringUtil.isNull(is_default)||!is_default.equals("1")){
	// is_default = "0";
	// }
	// address.set("user_id", user_id);
	// address.set("receiver_name", getPara("receiver_name"));
	// address.set("receiver_mobile", getPara("receiver_mobile"));
	// address.set("province", province);
	// address.set("city", city);
	// address.set("area", area);
	// address.set("receiver_address", receiver_address);
	// /*TPlace place = new TPlace();
	// //先暂时不做code存储位置
	// String provinceName = place.findPlaceByCode(province_code);
	// String cityName = place.findPlaceByCode(city_code);
	// String areaName = place.findPlaceByCode(area_code);*/
	// String addressDetail = province+city+area+receiver_address;
	// address.set("address_detail", addressDetail);
	// address.set("is_default", is_default);
	// Record record = new Record();
	// record.setColumns(model2map(address));
	// if(is_default.equals("1")){
	// new TReceiverAddress().updateDefaullt(getPara("user_id"));
	// }
	// //查找数据库用户地址 根据用户姓名 电话和详细地址判定唯一性
	// List<Record> addressList = new TReceiverAddress().findAddresses(user_id);
	// boolean flag=true;
	// int needUpdateAddressId=0;
	// //需要更新的地址编号
	// if(StringUtil.isNotNull(address_id)){
	// needUpdateAddressId=getParaToInt("address_id");
	// }
	// for (Record item : addressList) {
	// if(address.getStr("receiver_name").equals(item.getStr("receiver_name"))
	// &&address.getStr("receiver_mobile").equals(item.getStr("receiver_mobile"))
	// &&address.getStr("address_detail").equals(item.getStr("address_detail"))){
	// //找到相同地址就更新
	// flag=false;
	// needUpdateAddressId=item.getInt("id");
	// break;
	// }
	// }
	//
	// if(StringUtil.isNull(address_id)&&flag){
	//
	// if(addressList.size()>=5){
	// result.put("status", "fail");
	// result.put("errorMsg", "地址不能超出5个！");
	// }else{
	// //更新其他地址为非默认
	// Db.update("update t_receiver_address set is_default='1' where
	// user_id=?",user_id);
	// Db.save("t_receiver_address", record);
	// result.put("status", "success");
	// result.put("record", record.toJson());
	// }
	// }else{
	// record.set("id", needUpdateAddressId);
	// //更新其他地址为非默认
	// Db.update("update t_receiver_address set is_default='1' where
	// user_id=?",user_id);
	// Db.update("t_receiver_address", record);
	// result.put("status", "success");
	// result.put("record", record.toJson());
	// }
	// }catch (Exception e) {
	// e.printStackTrace();
	// result.put("status", "failed");
	// result.put("errorMsg", "系统异常！");
	// }
	//
	// renderJson(result);
	// }

	/**
	 * 赠送商品列表
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void present() throws UnsupportedEncodingException {
		List<Record> products = new TProduct().findPresentProduct();
		setAttr("products", products);
		HdUtil.productInv(getCookie("store_id")==null?"07310109":getCookie("store_id"), products);
		// 获取cookie中赠送车商品数据
		String zscartInfo = getCookie("zscartInfo");
		if (StringUtil.isNotNull(zscartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(zscartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/present_proList.ftl");
	}

	/**
	 * 赠送车页面
	 * 
	 * @throws Exception
	 */
	public void zscart() throws Exception {
		// 获取到购物车中商品信息
		String zscartInfo = getCookie("zscartInfo");
		List<Map<String, Object>> proList = new ArrayList<Map<String, Object>>();
		double sum = 0.00;
		boolean cookieNull = false;// cookie里面是否有不存在的商品
		if (StringUtil.isNotNull(zscartInfo)) {
			JSONArray zscartInfoJson = JSONArray.parseArray(URLDecoder.decode(zscartInfo, "UTF-8"));
			JSONArray zscartInfoJsonCopy = new JSONArray();
			for (int i = 0; i < zscartInfoJson.size(); i++) {
				JSONObject item = zscartInfoJson.getJSONObject(i);
				int pfId = item.getInteger("pf_id");
				Record product = Db.findFirst(
						"select p.*,i.save_string,pf.product_unit,pf.comments,pf.product_amount,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.id as pf_id,c.unit_name,u.unit_name as base_unitname "
								+ " from t_product_f pf left join t_product p"
								+ " on p.id=pf.product_id left join t_image i on p.img_id=i.id "
								+ "left join t_unit c on pf.product_unit=c.unit_code "
								+ "left join t_unit u on p.base_unit=u.unit_code " + "where pf.id=?",
						pfId);
				if (product == null) {
					cookieNull = true;
					continue;
				} else {
					zscartInfoJsonCopy.add(item);
				}
				int productNum = item.getInteger("product_num");
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("product", product);
				map.put("productNum", productNum);
				proList.add(map);
				// 商品价格乘以商品数量 除以100换算成元
				sum += (product.getInt("real_price") == null ? 0 : product.getInt("real_price")) * productNum;
			}
			if (cookieNull) {
				setCookie("zscartInfo", zscartInfoJsonCopy.toJSONString(), 604800);
			}

		}
		setAttr("sum", sum);
		setAttr("proList", proList);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/zscart.ftl");
	}

	/**
	 * 赠送提交页面
	 * 
	 * @throws Exception
	 */
	public void presentOrder() throws Exception {
		// 判断是立即赠送还是购物车中购买
		String isImmediate = getPara("isImmediate");
		List<Map<String, Object>> proList = new ArrayList<Map<String, Object>>();
		double sum = 0.00;
		if (StringUtil.isNotNull(isImmediate)) {
			int productNum = 1;// 直接购买直接给一份getParaToInt("productNum");
			int pfId = getParaToInt("pfId");
			Record product = Db.findFirst(
					"select p.*,pf.product_amount as amount,pf.product_unit,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.id as pf_id,u.unit_name as base_unitname,i.save_string "
							+ " from t_product_f pf left join t_product p  on p.id=pf.product_id "
							+ "left join t_unit u on p.base_unit=u.unit_code " + "left join t_image i on p.img_id=i.id "
							+ "where pf.id=?",
					pfId);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("product", product);
			map.put("pf_id", pfId);
			map.put("product_price", product.getInt("real_price") * productNum);
			map.put("product_num", productNum);
			proList.add(map);
			// 商品价格乘以商品数量 除以100换算成元
			sum = (product.getInt("real_price") == null ? 0 : product.getInt("real_price")) * productNum;
			setAttr("pro_num", 1);
		} else {
			// 获取到购物车中商品信息
			String zscartInfo = getCookie("zscartInfo");
			// 复选框中选中的商品
			String[] zsFruits = getParaValues("zs_fruit");
			if (StringUtil.isNotNull(zscartInfo) && zsFruits != null) {
				JSONArray zscartInfoJson = JSONArray.parseArray(URLDecoder.decode(zscartInfo, "UTF-8"));
				for (int i = 0; i < zscartInfoJson.size(); i++) {
					JSONObject item = zscartInfoJson.getJSONObject(i);
					Integer pfId = item.getInteger("pf_id");
					for (String zsPfId : zsFruits) {
						// 只有勾选的才提交订单
						if (pfId.equals(new Integer(zsPfId))) {
							Record product = Db.findFirst(
									"select p.*,pf.product_amount as amount,pf.product_unit,pf.price,ifnull(pf.special_price,pf.price) as real_price,pf.id as pf_id,u.unit_name as base_unitname,i.save_string "
											+ " from t_product_f pf left join t_product p  on p.id=pf.product_id "
											+ "left join t_unit u on p.base_unit=u.unit_code "
											+ "left join t_image i on p.img_id=i.id " + "where pf.id=?",
									pfId);
							int productNum = item.getInteger("product_num");
							Map<String, Object> map = new HashMap<String, Object>();
							map.put("pf_id", pfId);
							map.put("product", product);
							map.put("product_price", product.getInt("real_price") * productNum);
							map.put("product_num", productNum);
							proList.add(map);
							// 商品价格乘以商品数量 除以100换算成元
							sum += (product.getInt("real_price") == null ? 0 : product.getInt("real_price"))
									* productNum;
							break;
						}
					}
				}
				setAttr("pro_num", zscartInfoJson.size());
			}
		}
		setAttr("sum", sum);
		setAttr("proList", proList);
		setAttr("proListJson", JSON.toJSONString(proList));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/present_order.ftl");
	}

	/**
	 * 赠送提交
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void presentCmt() throws UnsupportedEncodingException {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		Date current = new Date();
		String now = DateFormatUtil.format1(current);
		TPresent present = getModel(TPresent.class, "present");
		Record record = new Record();
		record.setColumns(model2map(present));
		record.set("present_time", now);
		String zscartInfo = getCookie("zscartInfo");// 不再 从cookie中取得商品信息
		String proListJson = getPara("proListJson");

		int needPay = 0;// 应付金额
		List<Map<String, Object>> presentProducts = new ArrayList<Map<String, Object>>();
		double total_num = 0;
		if (StringUtil.isNotNull(proListJson)) {
			/*
			 * JSONArray zscartInfoJson=new JSONArray(); if(zscartInfo!=null){
			 * zscartInfoJson =
			 * JSONArray.parseArray(URLDecoder.decode(zscartInfo, "UTF-8")); }
			 */
			List<Map> proList = JSON.parseArray(getPara("proListJson"), Map.class);
			for (Map<String, Object> item : proList) {
				// JSONObject item = zscartInfoJson.getJSONObject(i);
				int pf_Id = (int) item.get("pf_id");
				int productNum = (int) item.get("product_num");
				Record product = new TProductF().findTProductFById(pf_Id);
				double product_amount = product.getDouble("product_amount");
				needPay += product.getInt("real_price") * productNum;
				total_num += product_amount * productNum;
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("product", product);
				map.put("pfId", pf_Id);
				map.put("productNum", product_amount * productNum);
				map.put("unitPrice", product.getInt("real_price") / product_amount);
				presentProducts.add(map);
				/*
				 * for(int j=0;j<zscartInfoJson.size();j++){
				 * if(zscartInfoJson.getJSONObject(j).getInteger("pf_id").equals
				 * (pf_Id)){ zscartInfoJson.remove(j); break; } }
				 */
			}
			/*
			 * if(zscartInfo!=null){ setCookie("zscartInfo",
			 * zscartInfoJson.toJSONString(), 604800); }
			 */
		} else {
			return;
		}
		record.set("need_pay", needPay);
		present.set("need_pay", needPay);
		record.set("total_amount", total_num);
		present.set("total_amount", total_num);

		int userId = tUserSession.get("id");
		record.set("present_user", userId);
		present.set("present_user", userId);
		record.set("present_status", "1");
		present.set("present_status", "1");
		Db.save("t_present", record);
		long id = record.getLong("id");
		present.set("id", id);
		List<Record> presentProductList = new ArrayList<Record>();
		for (Map<String, Object> pro : presentProducts) {
			Record presentPro = new Record();
			presentPro.set("present_id", id);
			presentPro.set("pf_id", pro.get("pfId"));
			presentPro.set("amount", pro.get("productNum"));
			presentPro.set("unit_price", pro.get("unitPrice"));
			presentPro.set("buy_time", now);
			presentPro.set("remain_amount", pro.get("productNum"));
			Db.save("t_present_products", presentPro);
			presentProductList.add(presentPro);
		}

		/****** 订阅支付中活动 ******************/

		OrderTransmitData orderData = new OrderTransmitData();
		// 满立减活动
		Watcher orderActivity1Watcher = new OrderActivity1Watcher();
		Watched orderActivityWatched = new ConcreteWatched();
		orderActivityWatched.addWatcher(orderActivity1Watcher);

		orderData.setUserId(userId);

		orderData.setCurrentTime(current);
		// 购买 赠送不做优惠券领取
		orderData.setType("zs");
		present.setPresentProducts(presentProductList);
		present.setTotalProduct(presentProductList.size());
		orderData.setPresent(present);
		orderData.setNeedPay(needPay);

		orderActivityWatched.notifyWatchers(orderData);

		/****** 订阅支付中活动 ******************/

		redirect("/pay/sbmtPresent?present_id=" + record.getLong("id"));
	}

	/**
	 * 赠送分享页面
	 * 
	 * @throws Exception
	 */
	public void presentShare() throws Exception {
		String presentId = getPara("present_id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record present = new TPresent().findTPresentById(Integer.parseInt(presentId), userId);
		setAttr("present", present);
		List<Record> presentPros = new ArrayList<Record>();
		if (present != null) {
			presentPros = new TPresent().findPresentProList(Integer.parseInt(presentId));
		}
		setAttr("presentPros", presentPros);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/present_result.ftl");
	}

	/**
	 * 我的余额
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void myBalance() throws UnsupportedEncodingException {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = new TUser().findById(tUserSession.get("id"));
		setAttr("user", user);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myBalance.ftl");
	}

	/**
	 * 我的仓库页面
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void myStorage() throws UnsupportedEncodingException {
		// 获取cookie中提货篮信息
		String basketInfo = getCookie("basketInfo");
		if (StringUtil.isNotNull(basketInfo)) {
			JSONArray basketInfoJson = JSONArray.parseArray(URLDecoder.decode(basketInfo, "UTF-8"));
			setAttr("proNum", basketInfoJson.size());
			// 用于前台初始化提货篮展示
			setAttr("basketInfoJson", basketInfoJson);

		} else {
			setAttr("proNum", 0);
		}

		TUser tUserSession = UserStoreUtil.get(getRequest());
		List<Record> sockProducts = new TStock().findTStockByUserId(tUserSession.get("id"));
		setAttr("sockProducts", sockProducts);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myStorage.ftl");
	}

	/**
	 * 提货篮
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void txBasket() throws UnsupportedEncodingException {
		// 获取cookie中提货篮信息
		String basketInfo = getCookie("basketInfo");
		boolean cookieNull = false;
		if (StringUtil.isNotNull(basketInfo)) {
			JSONArray basketInfoJson = JSONArray.parseArray(URLDecoder.decode(basketInfo, "UTF-8"));
			JSONArray basketInfoJsonCopy = new JSONArray();
			List<JSONObject> txProList = new ArrayList<JSONObject>();
			for (int i = 0; i < basketInfoJson.size(); i++) {
				JSONObject item = basketInfoJson.getJSONObject(i);
				int productId = item.getInteger("product_id");
				Record product = new TProduct().findTProductUnitById(productId);
				if (product == null) {
					cookieNull = true;
					continue;
				} else {
					basketInfoJsonCopy.add(item);
				}
				item.put("base_unitname", product.get("unit_name"));
				item.put("is_int", product.get("is_int"));
				txProList.add(item);
			}
			if (cookieNull) {
				setCookie("basketInfo", basketInfoJsonCopy.toJSONString(), 604800);
			}
			// 用于前台初始化提货篮展示
			setAttr("basketInfoJson", txProList);
		}
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/tx_basket.ftl");
	}

	/**
	 * 提货订单
	 * (不从仓库提货，暂且不用该接口)
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void txOrder() throws UnsupportedEncodingException {
		String currDate = DateFormatUtil.format4(new Date());
		setAttr("currDate", currDate);
		List<Record> storeList = new TStore().findStores();
		String cartInfo = getCookie("basketInfo");// 从cookie中取得商品信息
		int need_pay = 0;
		boolean flag = true;
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int product_id = item.getInteger("product_id");
				double productNum = item.getDouble("product_num");
				List<Record> proList = new TStock().findTStockPro(userId, product_id);// 按时间从早至晚获取商品列表
				int price = 0;
				for (Record stockPro : proList) {
					double amount = stockPro.getDouble("amount");
					if (productNum >= amount) {
						price += (int) (stockPro.getInt("unit_price") * amount);
						productNum = productNum - amount;
					} else {
						price += (int) (stockPro.getInt("unit_price") * productNum);
						productNum = 0;
						break;
					}
				}
				if (productNum > 0) {
					flag = false;
				}
				need_pay += price;
			}
		} else {
			return;
		}
		//提货门店id
		setAttr("storeId",getCookie("store_id")==null?"07310109":getCookie("store_id"));
		if (need_pay == 0 || !flag) {
			removeCookie("basketInfo");
			setAttr("proNum", 0);
			List<Record> sockProducts = new TStock().findTStockByUserId(userId);
			setAttr("sockProducts", sockProducts);
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/myStorage.ftl");
		} else {
			setAttr("storeList", storeList);
			setAttr("balance", need_pay);
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/txOrder.ftl");
		}

	}
	
	/**
	 * 种子抵扣直接生成订单页
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void txOrder1() throws UnsupportedEncodingException {
		System.out.println("================");
		String currDate = DateFormatUtil.format4(new Date());
		setAttr("currDate", currDate);
		List<Record> storeList = new TStore().findStores();
		String proList=URLDecoder.decode(getPara("proList"), "utf-8").replace("\"", "'");
		int need_pay = 0;
		boolean flag = true;
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		/*if (StringUtil.isNotNull(proList)) {
			JSONArray cartInfoJson = JSONArray.parseArray(proList);
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int product_id = item.getInteger("product_id");
				double productNum = item.getDouble("product_num");
				need_pay += (int) (item.getInteger("real_price") * productNum);
				
				if (productNum > 0) {
					flag = false;
				}
			}
		} else {
			return;
		}*/
		//seedTypeList
		String seedTypeList=URLDecoder.decode(getPara("seedTypeList"), "utf-8").replace("\"", "'");
		//提货门店id
		String store_id=getCookie("store_id");
		System.out.println(store_id);
		setAttr("storeId",getCookie("store_id")==null?"07310109":getCookie("store_id"));
		setAttr("storeList", storeList);
		setAttr("balance", need_pay);
		setAttr("proList",proList);
		setAttr("exchangeId", getParaToInt("exchangeId"));
		setAttr("exchangeType", getPara("exchangeType"));
		setAttr("seedTypeList",seedTypeList);//种子扣除类型集合
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/seedBuyOrder.ftl");

	}

	/**
	 * 提货订单提交
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void txOrderCmt() throws UnsupportedEncodingException {
		String now = DateFormatUtil.format1(new Date());
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		TOrder order = getModel(TOrder.class, "order");
		Record record = new Record();
		record.setColumns(model2map(order));
		record.set("createtime", now);
		String cartInfo = getCookie("basketInfo");// 从cookie中取得商品信息
		// int totalPrice = 0;// 商品总金额
		List<Map<String, Object>> orderProducts = new ArrayList<Map<String, Object>>();
		int need_pay = 0;
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));

			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int product_id = item.getInteger("product_id");
				double productNum = item.getDouble("product_num");
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("productId", product_id);
				map.put("productNum", productNum);
				List<Record> proList = new TStock().findTStockPro(userId, product_id);// 按时间从早至晚获取商品列表
				int price = 0;
				for (Record stockPro : proList) {
					double amount = stockPro.getDouble("amount");
					// 此处修改为单价的 writeBy yj
					// map.put("unitPrice", stockPro.getInt("unit_price"));
					if (productNum >= amount) {
						price += (int) (stockPro.getInt("unit_price") * amount);
						new TStock().deleteOnePro(stockPro.getInt("id"));// 从最早的商品开始做删除或减法
						productNum = productNum - amount;
					} else {
						price += (int) (stockPro.getInt("unit_price") * productNum);
						new TStock().updateAmount(stockPro.getInt("id"), productNum);
						break;
					}
				}
				need_pay += price;
				// totalPrice += product.getInt("price") * productNum;
				// 此处修改为单价的 writeBy yj
				map.put("unitPrice", price);
				orderProducts.add(map);
			}
		} else {
			return;
		}
		record.set("order_user", userId);
		// record.set("total", totalPrice);
		record.set("order_id", orderNoGenerator.nextId());
		record.set("order_status", "3");
		record.set("order_type", "2");
		record.set("need_pay", need_pay);
		Db.save("t_order", record);
		long id = record.getLong("id");
		for (Map<String, Object> pro : orderProducts) {
			Record orderPro = new Record();
			orderPro.set("order_id", id);
			orderPro.set("product_id", pro.get("productId"));
			orderPro.set("amount", pro.get("productNum"));
			orderPro.set("unit_price", pro.get("unitPrice"));
			// orderPro.set("buy_time", now);
			Db.save("t_order_products", orderPro);
		}
		redirect("/txSuccess?id="+id);
	}
	
	/**
	 * 是否符合兑换订单条件接口
	 */
	@Before(OAuth2Interceptor.class)
	public void isExchangeOrder(){
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		String seedTypeList = getPara("seedTypeList");
		JSONArray seedTypeInfoJson = JSONArray.parseArray(seedTypeList);
		String proList = getPara("proList");
		int exchangeId=getParaToInt("exchangeId");//单品id  套餐id
		String exchangeType=getPara("exchangeType");//套餐或者单品类型
		HashMap<String, Object> resultJson=new HashMap<String, Object>();
		//先查询出用户有多少神秘种子
    	List<MSeedInstance> mysteriousSeed=MSeedInstance.dao.find("select * from m_seed_instance where seed_type_id=5 and status=1 and user_id=? ",userId);
		if("D".equals(exchangeType)){
			//兑换
	    	List<MProductSeedR> mpsr= new MProductSeedR().getMProductSeedR(exchangeId);
	    	//需要的神秘种子
	    	int needMysteriousSeed=0;
	    	boolean flag=true;
	    	for(MProductSeedR psr:mpsr){
	    		Record count=Db.findFirst("select count(*) as c from m_seed_instance where seed_type_id=? and status=1 and user_id=? ",
	    				psr.getInt("seed_type_id"),userId);
	    		if(count.getLong("c").intValue()>=psr.getInt("amount").intValue()){
	    			continue;
				}else{
	    			//需要神秘种子累积
	    			needMysteriousSeed+=psr.getInt("amount")-count.getLong("c");
	    		}
	    		//连神秘种子都不够抵扣
	    		if(mysteriousSeed.size()<needMysteriousSeed){
	    			flag=false;
	    			break;
	    		}
	    	}
	    	
	    	if(flag){
	    		//查看单品
	    		MSeedProduct mSeedProduct = MSeedProduct.dao.getSingle(exchangeId);
	    		 if(mSeedProduct==null){
	    			resultJson.put("success", false);
	     			resultJson.put("message", "没有可兑换的单品");
	     			renderJson(resultJson);
	     			return;
	    		 }
	    		 
	    		 if(mSeedProduct.getInt("isLimit")==1&&mSeedProduct.getInt("max_num")<=0){
	    			 resultJson.put("success", false);
	       			 resultJson.put("message", "兑换的单品份数不够了~");
	       			 renderJson(resultJson);
	       			 return;
	    		 }
	    		 
	    	}else{
				resultJson.put("success", false);
				resultJson.put("message", "您的种子不够，请继续收集相应的种子");
				renderJson(resultJson);
				return;
			}
		}else{
			//兑换
			List<MPackageSeedR> mpsr=  new MPackageSeedR().getPackageSeedR(exchangeId);
			//需要的神秘种子
			int needMysteriousSeed=0;
			boolean flag=true;
			for(MPackageSeedR psr:mpsr){
				Record count=Db.findFirst("select count(*) as c from m_seed_instance where seed_type_id=? and status=1 and user_id=? ",
						psr.getInt("seed_type_id"),userId);
				//用户的种子数是否大于套餐所需的种子数   我的种子数量     要扣的种子数量
				if(count.getLong("c").intValue()>=psr.getInt("amount").intValue()){
					continue;
				}else{
					//需要神秘种子累积
					needMysteriousSeed+=psr.getInt("amount")-count.getLong("c");
				}
				//连神秘种子都不够抵扣
				if(mysteriousSeed.size()<needMysteriousSeed){
					flag=false;
					break;
				}
			}
			
			if(flag){
				MPackage mPackage=MPackage.dao.getPackage(exchangeId);
				if(mPackage.getInt("isLimit")==1&&mPackage.getInt("max_num")<=0){
					resultJson.put("success", false);
					resultJson.put("message", "兑换的套餐份数不够了~");
					renderJson(resultJson);
					return;
				}
			}else{
				resultJson.put("success", false);
				resultJson.put("message", "您的种子不够，请继续收集相应的种子");
				renderJson(resultJson);
				return;
			}
		}
		resultJson.put("exchangeId", exchangeId);
		resultJson.put("exchangeType", exchangeType);
		resultJson.put("seedTypeList", seedTypeList);
		resultJson.put("proList", proList);
		resultJson.put("success", true);
		renderJson(resultJson);
	}
	
	/**
	 * 提货订单提交
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void txOrderCmt1() throws UnsupportedEncodingException {
		String now = DateFormatUtil.format1(new Date());
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		TOrder order = getModel(TOrder.class, "order");
		Record record = new Record();
		record.setColumns(model2map(order));
		record.set("createtime", now);
		String proList = getPara("proList");
		 int totalPrice = 0;// 商品总金额
		List<Map<String, Object>> orderProducts = new ArrayList<Map<String, Object>>();
		int need_pay = 0;
		int price=0;
		if (StringUtil.isNotNull(proList)) {
			JSONArray cartInfoJson = JSONArray.parseArray(proList);

			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int product_id = item.getInteger("product_id");
				double productNum = item.getDouble("product_num");
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("productId", product_id);
				map.put("productNum", productNum);
				map.put("pf_id", item.getInteger("pf_id"));
				price=(int) (item.getInteger("real_price") * productNum);
				need_pay += (int) (item.getInteger("real_price") * productNum);
				// 此处修改为单价的 writeBy yj
				map.put("unitPrice", price);
				orderProducts.add(map);
			}
		} else {
			return;
		}
		totalPrice=need_pay;
		record.set("order_user", userId);
		record.set("total", totalPrice);
		record.set("order_id", orderNoGenerator.nextId());
		record.set("order_status", "3");
		record.set("order_type", "2");//兑换类型
		record.set("need_pay", need_pay);
		record.set("order_style", 2);//
		Db.save("t_order", record);
		long id = record.getLong("id");
		MActivity activity = MActivity.dao.findYxActivityByType(18);//查找有效的种子活动
		for (Map<String, Object> pro : orderProducts) {
			Record orderPro = new Record();
			orderPro.set("order_id", id);
			orderPro.set("product_id", pro.get("productId"));
			orderPro.set("amount", pro.get("productNum"));
			orderPro.set("unit_price", pro.get("unitPrice"));//这里有问题
			// orderPro.set("buy_time", now);
			Db.save("t_order_products", orderPro);
		}
		//添加兑换支付日志记录
		TPayLog paylog = new TPayLog();
		paylog.balancePaySaveLog(tUserSession.get("open_id"), PaySourceTypes.EXCHANGE, need_pay,
				record.get("order_id"));
		int exchangeId=getParaToInt("exchangeId");
		//兑换记录
		TExchangeOrderLog exchangeOrderLog = new TExchangeOrderLog();
		if(orderProducts.size()>1){
			Record packge = Db.findFirst("select m.* from m_package m  where m.id=?",exchangeId);
			exchangeOrderLog.set("record_name", packge.getStr("package_name"));
			exchangeOrderLog.set("image_id", packge.getInt("image_id"));
			exchangeOrderLog.set("exchange_type", "T");
		}else{
			MSeedProduct seedProduct = MSeedProduct.dao.findFirst("select * from m_seed_product sp left join t_product t on sp.product_id=t.id where sp.id=?",exchangeId);//单品商品
			exchangeOrderLog.set("record_name", seedProduct.getStr("single_name"));
			exchangeOrderLog.set("image_id", seedProduct.getInt("img_id"));
			exchangeOrderLog.set("exchange_type", "D");
		}
		exchangeOrderLog.set("order_id", record.get("order_id"));
		exchangeOrderLog.set("create_time", now);
		exchangeOrderLog.set("user_id", userId);
		exchangeOrderLog.set("activity_id", activity.getInt("id"));
		exchangeOrderLog.save();
		//exchangeOrderLog.remove("id");
		
		String exchangeType=getPara("exchangeType");
		String currentTime=DateFormatUtil.format1(new Date());
		if("D".equals(exchangeType)){
			//查找有效的单品
			MSeedProduct seedProduct=MSeedProduct.dao.getSingle(exchangeId);
			if(seedProduct.getInt("isLimit")==1&&seedProduct.getInt("max_num")>0){
				seedProduct.set("max_num", seedProduct.getInt("max_num")-1);//限制的份数-1
				seedProduct.update();
				//产生一个单品m_seed_product_instance
				MSeedProductInstance mSeedProductInstance = new MSeedProductInstance();
				mSeedProductInstance.set("seed_product_id", exchangeId);
				mSeedProductInstance.set("status", 1);
				mSeedProductInstance.set("user_id", userId);
				mSeedProductInstance.set("get_time", currentTime);
				mSeedProductInstance.save();
			}
		}else if("T".equals(exchangeType)){
			//查找有效的套餐
			MPackage mPackage = MPackage.dao.getPackage(exchangeId);
			if(mPackage.getInt("isLimit")==1&&mPackage.getInt("max_num")>0){
				mPackage.set("max_num", mPackage.getInt("max_num")-1);
				mPackage.update();
				//产生一个套餐
				MPackageInstance mPackageInstance = new MPackageInstance();
				mPackageInstance.set("package_id", exchangeId);
				mPackageInstance.set("status", 1);
				mPackageInstance.set("user_id", userId);
				mPackageInstance.set("get_time", currentTime);
				mPackageInstance.save();
			}
		}
		String seedTypeList = getPara("seedTypeList");
		JSONArray seedTypeInfoJson = JSONArray.parseArray(seedTypeList);
		for(int i=0;seedTypeInfoJson.size()>i;i++){
			JSONObject item = seedTypeInfoJson.getJSONObject(i);
			//Record count=Db.findFirst("select * from m_seed_instance where seed_type_id=? and status=1 and user_id=?", item.getInteger("id"),userId);
			MSeedInstance.dao.seedDeduction(currentTime, exchangeType, exchangeId, item.getInteger("id"), userId, item.getInteger("amount"));//扣除种子
		}
		setAttr("seedTypeList", seedTypeList);
		setAttr("id",id);
		txSuccess1();
	}

	/**
	 * 提货成功页
	 * 
	 * @throws UnsupportedEncodingException
	 */
	//@Before(OAuth2Interceptor.class)
	public void txSuccess1() throws UnsupportedEncodingException {
		long id = (Long)getAttr("id");// getParaToLong("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record order = new TOrder().findTOrderDetail(id, userId);
		setAttr("order", order);
		//removeCookie("basketInfo");
		logger.info("===========仓库提货海鼎减商品库存start==============");
		String orderId = order.getStr("order_id");
		if (HdUtil.orderReduce(orderId)) {
			Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
		} else {
			// 发送消息给指定的管理员
			TIndexSetting setting = new TIndexSetting();
			Map<String, String> map = setting.getIndexSettingMap();
			PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
			Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
		}
		logger.info("===========仓库提货海鼎减商品库存end==============");
		//扣除的种子集合
		//String seedTypeList=getPara("seedTypeList");
		//String seedTypeList=URLDecoder.decode(getPara("seedTypeList"), "utf-8").replace("\"", "'");
		JSONArray seedTypeInfoJson=JSONArray.parseArray(getAttr("seedTypeList"));
		JSONArray seedTypes= new JSONArray();
		
		
		for(int i=0;seedTypeInfoJson.size()>i;i++){
			JSONObject item=seedTypeInfoJson.getJSONObject(i);
			JSONObject seedtype=new JSONObject();
			Record record = Db.findFirst("select * from m_seed_type where id=? ",item.getInteger("id"));
			seedtype.put("seed_name",record.getStr("seed_name"));//种子名称
			seedtype.put("amount", item.getInteger("amount"));//扣除的种子数量
			seedTypes.add(seedtype);
		}
		setAttr("seedTypes", seedTypes);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/seedSuccess.ftl");
	}
	
	/**
	 * 提货成功页
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void txSuccess() throws UnsupportedEncodingException {
		long id = getParaToLong("id");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record order = new TOrder().findTOrderDetail(id, userId);
		setAttr("order", order);
		removeCookie("basketInfo");
		logger.info("===========仓库提货海鼎减商品库存start==============");
		String orderId = order.getStr("order_id");
		if (HdUtil.orderReduce(orderId)) {
			Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
		} else {
			// 发送消息给指定的管理员
			TIndexSetting setting = new TIndexSetting();
			Map<String, String> map = setting.getIndexSettingMap();
			PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
			Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
		}
		logger.info("===========仓库提货海鼎减商品库存end==============");
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/txOrder_success.ftl");
	}

	/**
	 * 我的赠送页面
	 */
	public void myPresent() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		// 查询我赠送的订单列表
		List<Record> sourcePresents = new TPresent().findTPresentsByUserId(userId, "source");
		setAttr("sourcePresents", sourcePresents);
		List<Record> targetPresents = new TPresent().findTPresentsByUserId(userId, "target");
		setAttr("targetPresents", targetPresents);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myPresent.ftl");
	}

	/**
	 * 我的赠送-取消赠送
	 */
	public void cancelPresent() {
		int presentId = getParaToInt("presentId");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int user = tUserSession.get("id");
		int count = new TPresent().cancelPresent(presentId, user);
		Map<String, String> result = new HashMap<String, String>();
		if (count > 0) {
			result.put("result", "success");
		} else {
			result.put("result", "failed");
			result.put("msg", "操作失败,请检查赠送状态！");
		}
		renderJson(result);
	}

	/**
	 * 接受赠送
	 */
	public void recievePresent() {
		int presentId = getParaToInt("presentId");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int user = tUserSession.get("id");
		int count = new TPresent().recievePresent(presentId, user);
		Map<String, String> result = new HashMap<String, String>();
		if (count > 0) {
			result.put("result", "success");
		} else {
			result.put("result", "failed");
			result.put("msg", "操作失败,请检查赠送状态！");
		}
		renderJson(result);
	}

	/**
	 * 优惠券页面
	 */
	public void myCoupon() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		TUserCoupon userCoupon = new TUserCoupon();
		setAttr("couponList", userCoupon.findTUserCoupon(userId));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myCoupon.ftl");
	}

	/**
	 * 根据类别加载商品列表
	 * @throws UnsupportedEncodingException 
	 */
	@Before(OAuth2Interceptor.class)
	public void catProList() throws UnsupportedEncodingException {
		// 获取cookie中购物车商品数据
		String cartInfo = getCookie("cartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		// 设置load来源
		setAttr("from", "category");
		String categoryId = getPara("category_id");
		setAttr("category_id", categoryId);
		List<Record> products = new TProduct().findTProductByCategoryId(categoryId);
		//查询门店商品库存，并处理商品
		HdUtil.productInv(getCookie("store_id")==null?"07310109":getCookie("store_id"),products);
		setAttr("products", products);
		System.out.println("adadsadsa"+products);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/proList.ftl");
	}

	/**
	 * 底部活动点击跳转
	 */
	public void bottomActivity() {
		setAttr("activity", new MActivity().findById(getParaToInt("activityId")));
		setAttr("activityId", getParaToInt("activityId"));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/bottomActivity.ftl");
	}

	/**
	 * 底部活动详情的商品列表
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void productByActivityId() throws UnsupportedEncodingException {

		List<Record> products = new TProduct().findTProductByActivityId(getParaToInt("activityId"));
		setAttr("products", products);
		// 获取cookie中购物车商品数据
		String cartInfo = getCookie("cartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		// 设置load来源
		setAttr("from", "productByActivityId");
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/proList.ftl");
	}

	/**
	 * 根据搜索加载商品列表
	 * @throws UnsupportedEncodingException 
	 *   
	 */
	@Before(OAuth2Interceptor.class)
	public void searchProList() throws UnsupportedEncodingException   {
		String keyword = getPara("keyword");
		List<Record> products = new TProduct().findTProductByKeyword(keyword);
		//查询门店商品库存，并处理商品
		HdUtil.productInv(getCookie("store_id")==null?"07310109":getCookie("store_id"),products);
		setAttr("products", products);
		
		// 获取cookie中购物车商品数据
		String cartInfo = getCookie("cartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		// 设置load来源
		setAttr("from", "search");
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/proList.ftl");
	}

	/**
	 * 根据搜索加载赠送商品列表
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void searchZsProList() throws UnsupportedEncodingException {
		String keyword = getPara("keyword");
		List<Record> products = new TProduct().findTProductByKeyword(keyword);
		HdUtil.productInv(getCookie("store_id")==null?"07310109":getCookie("store_id"), products);
		setAttr("products", products);

		// 获取cookie中赠送购物车商品数据
		String cartInfo = getCookie("zscartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}

		render(AppConst.PATH_MANAGE_PC + "/client/mobile/zsProList.ftl");
	}

	/**
	 * 手机活动信息详情
	 */
	public void activityDetails() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activityDetails.ftl");
	}

	/**
	 * 手机水果分类
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void fruitKind() throws UnsupportedEncodingException {
		// 获取水果一级分类信息
		String id = getPara("id");
		TCategory parentTCategory = TCategory.dao.findTCategoryById(id);
		setAttr("parentTCategory", parentTCategory);
		TCategory tCategory = new TCategory();
		// 查询水果二级分类信息
		List<Record> tCategorys = tCategory.findTCategorys(id);
		setAttr("tCategorys", tCategorys);
		// 设置一个随机种子用于页面冒泡
		/*
		 * TUser tUserSession = UserStoreUtil.get(getRequest()); int userId =
		 * tUserSession.get("id");
		 */
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/fruitKind.ftl");
	}

	/**
	 * 商品详情
	 * @throws UnsupportedEncodingException 
	 * 
	 */
	@Before(OAuth2Interceptor.class)
	public void fruitDetial() throws UnsupportedEncodingException {
		String id = getPara("pf_id");
		String barcode = getPara("barcode");
		// 商品限制购买数量
		String restrict = getPara("restrict");
		int pf_id;
		if (StringUtil.isNull(id) && StringUtil.isNotNull(barcode)) {
			TProduct product = TProduct.dao.findFirst("select id from t_product_f where bar_code=?", barcode);
			pf_id = product.getInt("id");
		} else {
			pf_id = Integer.parseInt(id);
		}
		Record product = new TProduct().findTProductDetialById(pf_id);
		//查询门店商品库存，并处理商品
		List<Record> productList = new ArrayList<Record>();
		productList.add(product);
		HdUtil.productInv(getCookie("store_id")==null?"07310109":getCookie("store_id"),productList);
		
		setAttr("product", productList.get(0));
		// 获取cookie中购物车商品数据
		String cartInfo = getCookie("cartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		// 是否抢购商品,查询指定抢购时间段内的活动商品
		MActivityProduct activityProduct = MActivityProduct.dao.findFirst(
				"select * from m_activity_product where product_f_id=? and  activity_id in "
						+ "(select activity_id from m_interval where activity_id in( "
						+ "select id from m_activity where activity_type=1 and yxbz='Y') "
						+ "and   str_to_date(begin_time, '%Y-%m-%d %H:%i:%s')<now() and now()<str_to_date(end_time, '%Y-%m-%d %H:%i:%s') )",
				pf_id);
		setAttr("isActivityProduct", activityProduct == null ? false : true);
		// 详情页推荐商品(每页的都是一样的推荐商品)
		List<Record> detialProductRecommends = new MRecommend().findMRecommendsByTypeId(5);
		setAttr("detialProductRecommends", detialProductRecommends);
		
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/fruitDetial.ftl");
	}

	/**
	 * 查询门店库存
	 */
	public void queryStoreInv(){
		JSONObject resultJson = new JSONObject();
		//查询的商品barcode
		Record product = Db.findFirst("select * from t_product where id =?",getPara("product_id"));
		String[] barcodes = {product.getStr("base_barcode")};
		try {
			JSONObject queryResult = HdUtil.querySku(getCookie("store_id")==null?"07310109":getCookie("store_id"), barcodes);
			JSONArray invArr = queryResult.getJSONArray("businvs");
			if(queryResult.getIntValue("echoCode")==0 && invArr!=null && invArr.size()>0){
				//查询成功
				if(invArr.getJSONObject(0).getDoubleValue("qty")<product.getDouble("safe_qty")){
					//库存小于安全库存
					resultJson.put("result", true);
					resultJson.put("msg", "查询成功");
					resultJson.put("inv_enough", false);
				}else{
					//库存大于安全库存
					resultJson.put("result", true);
					resultJson.put("msg", "查询成功");
					resultJson.put("inv_enough", true);
				}
			}else{
				resultJson.put("result", false);
				resultJson.put("inv_enough", false);
				resultJson.put("msg", "查询失败");
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
			resultJson.put("result", false);
			resultJson.put("inv_enough", false);
			resultJson.put("msg", "查询失败");
		}
		renderJson(resultJson);
	}
	
	/**
	 * 搜索
	 */
	public void search() throws UnsupportedEncodingException {
		String cartInfo = getCookie("cartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/search.ftl");
	}

	/**
	 * 根据搜索加载用户列表
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void searchUserList() throws UnsupportedEncodingException {
		String keyword = getPara("keyword");
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		List<TUser> userList = new TUser().findTUserByKeyword(keyword, userId);
		setAttr("userList", userList);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/userList.ftl");
	}

	/**
	 * 手机展示活动详情
	 */
	public void activity() {
		setAttr("activity", new MActivity().findById(getParaToInt("activityId")));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity.ftl");
	}

	/**
	 * 我的福娃
	 */
	public void myFuwa() {
		TUser tUserSession = UserStoreUtil.get(getRequest());

		List<Record> myFws = Db.find("select au.*,i.save_string,af.fw_name from a_user_fw au "
				+ " left join a_fuwa af on au.fw_id=af.id " + " left join t_image i on af.img_id=i.id  "
				+ " left join m_activity m on m.id=af.activity_id " + " where af.activity_id=8 and au.user_id=? ",
				tUserSession.getInt("id"));
		// 当前没有一个福娃
		if (myFws.size() == 0) {
			myFws = Db.find("select af.*,i.save_string,0 as fw_count,af.id as fw_id from  a_fuwa af "
					+ "left join  t_image i on af.img_id=i.id ");
		}

		setAttr("myFws", myFws);
		// 统计我收集齐了的新年大礼包
		setAttr("getMyGift", new AUserFw().getMyGift(tUserSession.getInt("id")));
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myFuwa.ftl");
	}

	/**
	 * 我的福娃 详情
	 */
	public void myFuwaDetial() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		List<Record> myFws = Db.find(
				"select a.*,af.fw_name,u.nickname from a_fw_get a " + " left join a_fuwa af on a.fw_id=af.id"
						+ " left join m_activity m on m.id=af.activity_id "
						+ " left join t_user u on a.gift_send_user=u.id"
						+ " where af.activity_id=8 and m.yxbz='Y' and a.user_id=? order by get_time desc",
				tUserSession.getInt("id"));
		setAttr("myFws", myFws);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myFuwaDetial.ftl");
	}

	public void fuwaSend() {
		MActivity activity = MActivity.dao.findById(8);
		if (activity != null && "N".equals(activity.get("yxbz"))) {
			redirect("/myFuwa");
			return;
		}
		AFwGet fwGet = getModel(AFwGet.class, "fw_get");
		// 赠送之后就减掉
		TUser tUserSession = UserStoreUtil.get(getRequest());
		Db.update("update a_user_fw set fw_count=fw_count-1  where user_id=? and fw_id=?", tUserSession.getInt("id"),
				fwGet.getInt("fw_id"));
		AFwGet myFwGet = AFwGet.dao.findFirst(
				"select * from a_fw_get where user_id=? and fw_id=? and is_vaild=0 limit 0,1 ",
				tUserSession.getInt("id"), fwGet.getInt("fw_id"));
		// 设置当前的福娃无效
		myFwGet.set("is_vaild", 1);
		myFwGet.set("user_id", tUserSession.getInt("id"));
		myFwGet.update();

		// 对方的需要添加
		AUserFw aufFriend = AUserFw.dao.findFirst("select * from a_user_fw where user_id=? and fw_id=?",
				fwGet.getInt("user_id"), fwGet.getInt("fw_id"));
		if (aufFriend == null) {
			AFuwa aFuwaOper = new AFuwa();
			List<AFuwa> aFws = aFuwaOper.find("select * from a_fuwa where activity_id=8 ");
			for (AFuwa af : aFws) {
				AUserFw auf = new AUserFw();
				auf.set("fw_id", af.getInt("id"));
				auf.set("user_id", fwGet.getInt("user_id"));
				// 给指定用户的指定福娃加1
				if (af.getInt("id") == fwGet.getInt("fw_id")) {
					auf.set("fw_count", 1);
					auf.save();
				}
			}
		} else {
			aufFriend.set("fw_count", aufFriend.getInt("fw_count") + 1);
			aufFriend.update();
		}
		AFwGet aFwGet = new AFwGet();
		aFwGet.set("fw_id", fwGet.getInt("fw_id"));
		aFwGet.set("get_time", DateFormatUtil.format1(new Date()));
		aFwGet.set("user_id", fwGet.getInt("user_id"));
		aFwGet.set("is_vaild", "0");
		aFwGet.set("order_id", "");
		aFwGet.set("is_zs", "Y");
		aFwGet.set("gift_send_user", tUserSession.getInt("id"));
		aFwGet.save();

		redirect("/myFuwa");
	}

	/**
	 * 余额明细
	 */
	public void balanceDetail() {
		TUser user = UserStoreUtil.get(getRequest());
		List<Record> tPayLogs = new TPayLog().findTPayLogByUserId(user.get("open_id"), PaySourceTypes.RECHARGE);
		setAttr("payLogs", tPayLogs);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/mybalanceDetail.ftl");
	}

	/**
	 * 集果娃活动详情页
	 */
	public void collectGw() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_fw.ftl");
	}

	/**
	 * 排行榜
	 */
	public void rankingList() {
		List<Record> bonusList = Db.find("select b.nickname,b.phone_num,a.fwBonus,a.fwCount from "
				+ " (select user_id,min(fw_count) fwBonus,sum(fw_count) fwCount from a_user_fw GROUP BY user_id HAVING min(fw_count)>0) a "
				+ " LEFT JOIN t_user b " + "ON a.user_id = b.id order by a.fwBonus desc,a.fwCount desc limit 10");
		renderJson(bonusList);
	}

	/**
	 * 活动结束
	 */
	public void activityEnd() {
		MActivity activity = MActivity.dao.findById(8);
		activity.set("yxbz", "N");
		activity.update();
		Map<String, String> result = new HashMap<String, String>();
		result.put("success", "1");
		renderJson(result);
	}

	/**
	 * 私人定制页
	 */
	public void srdz() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_srdz.ftl");
	}

	/**
	 * 新年鲜果
	 */
	public void xnxg() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_xnxg.ftl");
	}

	/**
	 * 好友互赠
	 */
	public void hyhz() {
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_hyhz.ftl");
	}

	/**
	 * 获取验证码
	 */
	public void getVerifyCode() {
		String phone_num = getPara("phone_num");
		TUser user = TUser.dao.findFirst("select * from t_user where phone_num=?", phone_num);
		Map<String, String> result = new HashMap<String, String>();
		if (user == null) {
			System.out.println(phone_num);
			int verifyNum = 0;
			if (getSessionAttr("verifyNum") != null) {
				verifyNum = getSessionAttr("verifyNum");
			}
			if (verifyNum >= 5) {
				result.put("result", "failed");
				result.put("msg", "超过发送限制");
			} else {
				Map<String, String> map = PushUtil.sendMsgToUser(phone_num, "水果熟了");
				if ("success".equals(map.get("status"))) {
					setSessionAttr("verifyCode", map.get("verifyCode"));
					result.put("result", "success");
					setSessionAttr("verifyNum", verifyNum + 1);
				} else {
					result.put("result", "failed");
					result.put("msg", "系统发送短信中，请稍等！");
				}

			}
		} else {
			result.put("result", "failed");
			result.put("msg", "手机号已存在！");
		}

		// setSessionAttr("verifyCode", PushUtil.sendMsgToUser(phone_num));
		renderJson(result);
	}

	/**
	 * 会员验证登陆
	 */
	public void memberMobileCmt() {
		Map<String, String> result = new HashMap<String, String>();
		String phone_num = getPara("phone_num");
		String verifyCode = getPara("verifyCode");
		String sessionVerify = getSessionAttr("verifyCode");
		if (sessionVerify == null) {
			result.put("result", "failed");
			result.put("msg", "请先点击获取验证码！");
			renderJson(result);
		} else {
			if (verifyCode.equals(sessionVerify)) {
				TUser tUser = new TUser();
				TUser tUserSession = UserStoreUtil.get(getRequest());
				tUser.set("id", tUserSession.getInt("id"));
				tUser.set("phone_num", phone_num);
				tUser.set("store_id", getPara("nearStore"));// 注册门店
				tUser.update();
				result.put("result", "success");
				tUserSession.set("phone_num", phone_num);
				// 发送数据到海鼎进行注册
				HdUtil.registUser(getPara("nearStore"), phone_num, phone_num);
				// 绑定了手机号，就代表注册了

				/****** 注册活动订阅通知 *************/
				Watched registerActivityWatched = new ConcreteWatched();
				Watcher registerWatcher = new RegisterActivityWatcher();
				Watcher registerWatcher1 = new RegisterActivity1Watcher();
				registerActivityWatched.addWatcher(registerWatcher);
				// 九宫格注册送抽奖机会
				registerActivityWatched.addWatcher(registerWatcher1);
				RegisterTransmitData registerData = new RegisterTransmitData();
				registerData.setUserId(tUserSession.getInt("id"));
				registerData.setStoreId(getPara("nearStore"));
				registerActivityWatched.notifyWatchers(registerData);
				/****** 注册活动订阅通知 *************/
				//是否开启发券活动
				String activity_id=getPara("activity_id");
				if(StringUtil.isNotNull(activity_id)){
					MActivity activity=MActivity.dao.findById(activity_id);
					if(activity!=null&&"Y".equals(activity.getStr("yxbz"))){
						result.put("status", "1");//发券活动已开启
						result.put("url", "/coupon/receiveCoupon?activity_id="+activity_id+"&userId="+tUserSession.getInt("id"));
					}
				}
				
				//二维码抽奖活动
				String receiveId=getPara("receiveId");
				if(StringUtil.isNotNull(receiveId)){
					result.put("status", "2");
					result.put("url", "/activity/myTwoCodeLottery");
				}
				renderJson(result);
			} else {
				result.put("result", "failed");
				result.put("msg", "验证码错误！");
				renderJson(result);
			}
		}
	}

	/**
	 * 私人定制套餐详情查看
	 */
	public void srdzDetail() {
		String tcName = getPara("tcName").replace("套餐", "");
		setAttr("tc", tcName);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/srdz_detail.ftl");
	}

	/**
	 * 底部分类商品列表链接
	 * 
	 * @throws UnsupportedEncodingException
	 */
	public void customProList() throws UnsupportedEncodingException {
		String activityId = getPara("activityId");
		MActivity activity = MActivity.dao.findById(activityId);
		setAttr("activity", activity);
		List<Record> products = new TProduct().findCustomTProduct(activityId);
		setAttr("products", products);
		// 获取cookie中购物车商品数据
		String cartInfo = getCookie("cartInfo");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			int productNum = 0;
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				productNum += item.getInteger("product_num");
			}
			setAttr("proNum", productNum);
		} else {
			setAttr("proNum", 0);
		}
		// 设置load来源
		setAttr("from", "search");
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/custom_proList.ftl");
	}

	/**
	 * 购买分享获得鲜果币
	 */
	public void getCoinByShare() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TOrder order = new TOrder().findTOrderByOrderId(getPara("orderId"));
		TBlanceRecord tBlanceRecord = new TBlanceRecord();
		TBlanceRecord blanceRecordResult = tBlanceRecord.getRecordByOrderId(tUserSession.getInt("id"),
				order.getStr("order_id"), "share");
		Map<String, Object> result = new HashMap<String, Object>();
		// 订单存在并且没有获取过鲜果币
		if (order != null && blanceRecordResult == null) {
			Random rand = new Random();
			int give = (int) Math.floor(order.getInt("need_pay") * 0.0005);
			if (give < 1) {
				give = 1;
			}
			int coinCount = rand.nextInt(give) + 1;
			coinCount = coinCount < 1 ? 100 : coinCount * 100;

			Db.update("update t_user set balance=balance+? where id=?", coinCount, tUserSession.getInt("id"));
			// 增加加果币记录
			tBlanceRecord.set("store_id", order.getStr("order_store"));
			tBlanceRecord.set("user_id", order.getInt("order_user"));
			tBlanceRecord.set("blance", coinCount);
			tBlanceRecord.set("ref_type", "share");
			tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
			tBlanceRecord.set("order_id", order.getStr("order_id"));
			tBlanceRecord.save();
			result.put("result", "success");
			result.put("coinCount", coinCount / 100);
		} else {
			result.put("result", "failed");
			result.put("msg", "已经领取鲜果币！");
		}

		renderJson(result);
	}
	
    /**
     * 页面分享
     */
    @Before(OAuth2Interceptor.class)
    public void share(){
    	 String url = getRequest().getHeader("Referer");
    	 System.out.println(url);
    	 TUser tUserSession = UserStoreUtil.get(getRequest());
    	 JSONObject result = new JSONObject(); 
    	 List<MShare> shareList = MShare.dao.find("select * from m_share where status=0");
    	 if(shareList!=null){
    		 //根据分享id排序
    		 Collections.sort(shareList, new Comparator<MShare>() {
					@Override
					public int compare(MShare o1, MShare o2) {
						// TODO Auto-generated method stub
						return o1.getInt("id").compareTo(o2.getInt("id"));
					}
    	        });
    		 for(MShare share:shareList){
    			 if(StringUtil.isNotNull(share.getStr("url"))){
    				 for(String url1:share.getStr("url").split(",")){
    					 if(url.indexOf(url1)!=-1){
    						 result.put("tUserSession", tUserSession);
    						 result.put("share", share);
    						 renderJson(result);
    						 return;
    					 }
    				 }
    			 }else{
    				 result.put("tUserSession", tUserSession);
					 result.put("share", share);
					 renderJson(result);
					 return;
    			 }
    		 }
    	 }
    }
    
    /**
     * 兑奖记录
     */
    @Before(OAuth2Interceptor.class)
    public void getExchangeRecord(){
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	List<Record> records = Db.find("select t.*,t1.save_string from t_exchange_order_log t left join t_image t1 on t.image_id=t1.id where user_id=? ", tUserSession.getInt("id"));
		setAttr("records", records);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/seedExchangeRecord.ftl");
    }
    
    /**
     * 海鼎接入接口
     * 抽奖信息（抽奖链接，抽奖码）
     * @param order_id
     * @param order_from
     * @param deliver_type
     * @param order_time
     * @param shop_code
     * @return
     * @throws IOException 
     */
    public void lotteryInfo() throws IOException{
    	InputStream resultJson = getRequest().getInputStream();
		// 转换成utf-8格式输出
		BufferedReader in = new BufferedReader(new InputStreamReader(resultJson, "UTF-8"));
		List<String> lst = IOUtils.readLines(in);
		IOUtils.closeQuietly(resultJson);
		String resultStr = StringUtils.join(lst, "");
		logger.info("传入JSON字符串：" + resultStr);
    	JSONObject result = new JSONObject();
    	JSONObject getJsonVal = JSONObject.parseObject(resultStr);
    	String order_id=getJsonVal.getString("order_id");
    	String order_from=getJsonVal.getString("order_from");
    	String deliver_type=getJsonVal.getString("deliver_type");
    	String order_time=getJsonVal.getString("order_time");
    	String store_code=getJsonVal.getString("store_code");
    	if(StringUtil.isNull(order_id)){
    		result.put("code", 400);
			result.put("msg", "订单不能为空！");
			renderJson(result);
			return;
    	}
    	
    	if(StringUtil.isNull(store_code)){
    		result.put("code", 400);
			result.put("msg", "门店编码不能为空！");
			renderJson(result);
			return;
    	}
    	
    	if(StringUtil.isNull(order_from)){
    		result.put("code", 400);
			result.put("msg", "订单来源不能为空！");
			renderJson(result);
			return;
    	}
    	
    	if(StringUtil.isNull(deliver_type)){
    		result.put("code", 400);
			result.put("msg", "配送方式不能为空！");
			renderJson(result);
			return;
    	}
    	
    	String referer = getRequest().getHeader("Referer");
    	/*logger.info("referer:"+referer);
    	String urlHead=referer.substring(0, referer.indexOf("weixin/"));
    	logger.info(urlHead+"========================================");*/
    	MHdParam param = MHdParam.dao.findFirst("select * from m_hd_param where order_id=?",order_id);
    	if(param!=null){
    		result.put("code", 200);
    		result.put("msg", "该订单已存在！");
    		result.put("lottery_code", param.getStr("lottery_code"));
    		result.put("lottery_url", "https://weixin1.food-see.com/weixin/activity/twoCodeLottery?twoCode="+param.getStr("lottery_code"));//抽奖页面链接
    	}else{
    		String lottery_code=createLotteryCode(null);
    		result.put("code", 200);
    		result.put("lottery_code", lottery_code);//抽奖码
    		result.put("lottery_url", "https://weixin1.food-see.com/weixin/activity/twoCodeLottery?twoCode="+lottery_code);//抽奖页面链接
    		MHdParam hd=new MHdParam();
    		hd.set("order_id", order_id);
    		hd.set("order_from", Integer.parseInt(order_from));
    		hd.set("deliver_type", Integer.parseInt(deliver_type));
    		hd.set("order_time", order_time);
    		hd.set("store_code", store_code);
    		hd.set("lottery_code", lottery_code);
    		hd.set("yxbz", "Y");
    		hd.save();
    	}
    	logger.info("返回参数："+result.toJSONString());
    	renderJson(result);
    }
    
    public String createLotteryCode(String lotteryCode){
    	lotteryCode=RandomUtil.ranDomNo(10);
    	MHdParam hdParam=MHdParam.dao.findFirst("select * from m_hd_param where lottery_code=?",lotteryCode);
    	if(hdParam!=null){//是否存在相同的抽奖码
			return createLotteryCode(lotteryCode);
		}else{
			return lotteryCode;
		}
    }
    
}
