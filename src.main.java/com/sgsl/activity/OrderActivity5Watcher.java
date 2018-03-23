package com.sgsl.activity;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TUserCoupon;
import com.sgsl.utils.DateFormatUtil;

//具体的主题角色coupon  支付完成后优惠券赠送活动
public class OrderActivity5Watcher implements Watcher {
	protected final static Logger logger = Logger.getLogger(OrderActivity5Watcher.class);

	@Override
	public void update(TransmitDataInte data) {
		
		OrderTransmitData orderData = (OrderTransmitData) data;

		//防止刷浏览器,一个订单无限获取优惠券(一笔订单只有一次返券机会，客户刷浏览器可能会有多次机会返券)
		TUserCoupon orderCoupon = new TUserCoupon().findUserCouponByOrderId(orderData.getOrderId());
		if(orderCoupon!=null){
			return;
		}
		// 先查看活动是否有效
		MActivity activity = MActivity.dao.findFirst("select * from m_activity where yxbz='Y' and activity_type = 6");
		if (activity == null) {
			return;
		}
		/*
		 * 指定商品且商品在活动内价格累计
		 */
		int activity_product_price_total = 0;
		if ("Y".equals(activity.get("designate_product"))) {
			// 判定是否在活动商品内
			int order_product_id;
			int activity_product_id;
			int order_product_price = 0;
			List<Record> order_product_list = orderData.getOrder().getOrderProducts();
			List<Record> activity_product_list = Db.find(
					"select product_id from m_activity_product where activity_id in (select id from m_activity where activity_type=6 and yxbz='Y')");
			// 拿到订单中每一个产品，然后去匹对活动中的产品,将购买的活动的商品价格加起来
			for (Record order_product : order_product_list) {
				order_product_id = order_product.getInt("product_id");
				for (Record activity_product : activity_product_list) {
					activity_product_id = activity_product.getInt("product_id");
					if (order_product_id == activity_product_id) {
						order_product_price = order_product.getInt("pay_price");
						// 累加购买的活动商品价格
						activity_product_price_total += order_product_price;
					}
				}
			}

		}

		// 存在有效的返券活动
		if (activity != null) {

			// 先看是否指定商品
			if (activity.get("designate_product").equals("Y")) {// 指定商品

				// 找到对应商品符合最小金额返券
				TCouponCategory min_pay_give = TCouponCategory.dao.findMaxValueToGive(activity_product_price_total);
				giveCoupons(orderData, activity, min_pay_give);
				
			}else{
				//找到订单支付价格符合返券的最小金额返券
				TCouponCategory min_pay_give = TCouponCategory.dao.findMaxValueToGive(orderData.getNeedPay());
				giveCoupons(orderData, activity, min_pay_give);

			}
						
		}
	}

	//根据返券达到金额，返送多种、多张券
	public void giveCoupons(OrderTransmitData orderData,MActivity activity,TCouponCategory min_pay_give){
		if (min_pay_give != null) {// 有满足条件的返券种类，没有这个种类，就不返券
			List<TCouponCategory> couponCategorys = TCouponCategory.dao
					.findCouponCategorysToGive(activity.getInt("id"), min_pay_give.getInt("min_pay_give"));
			for (TCouponCategory couponCategory : couponCategorys) {
				
				// 查看用户是否已经超过返券次数
				if (couponCategory.get("user_gain_times").equals("/")) {// 不限次数
					// 生成需要返给用户数量的优惠券张数（返券）
					Record couponRecord = new Record();
					couponRecord.set("coupon_category_id", couponCategory.getInt("id"));
					couponRecord.set("coupon_scale_id", couponCategory.getInt("coupon_scale_id"));
					couponRecord.set("activity_id", couponCategory.get("activity_id"));
					couponRecord.set("coupon_desc", couponCategory.get("coupon_desc"));
					couponRecord.set("coupon_val", couponCategory.get("coupon_val"));
					couponRecord.set("min_cost", couponCategory.get("min_cost"));
					int yxq = Integer.parseInt(couponCategory.get("yxq"));
					Date date = new Date();// 取时间
					couponRecord.set("start_time", DateFormatUtil.format1(date));
					// 截至时间加上有效期
					Calendar calendar = new GregorianCalendar();
					calendar.setTime(date);
					calendar.add(calendar.DATE, yxq);// 把日期往后增加15天.整数往后推,负数往前移动
					date = calendar.getTime(); // 这个时间就是日期往后推一天的结果
					couponRecord.set("end_time", DateFormatUtil.format1(date));
					// 返券，写为领取
					couponRecord.set("status", "1");
					couponRecord.set("yxbz", "Y");
				
					Record couponUserRecord = new Record();
					couponUserRecord.set("user_id", orderData.getUserId());
					couponUserRecord.set("is_expire", "0");
					couponUserRecord.set("title", couponRecord.getStr("coupon_desc"));
					couponUserRecord.set("activity_id", couponRecord.get("activity_id"));
					// 返劵时候的订单编号
					couponUserRecord.set("order_id", orderData.getOrderId());
					// 返劵时候的订单类型
					couponUserRecord.set("order_type", orderData.getType());
					couponUserRecord.set("create_time", DateFormatUtil.format1(new Date()));

					// 返券张数
					for (int i = 0; i < couponCategory.getInt("give_coupon_amount"); i++) {
						Db.save("t_coupon_real", couponRecord);
						couponUserRecord.set("coupon_id", couponRecord.getLong("id"));
						Db.save("t_user_coupon", couponUserRecord);
						couponRecord.remove("id");
						couponUserRecord.remove("id");
					}

					logger.info("返券促销活动内" + orderData.getUserId() + "订单" + orderData.getOrderId() + "支付了"
							+ orderData.getNeedPay() + "获得" + couponCategory.getInt("give_coupon_amount") + "张优惠券"
							+ couponUserRecord.getStr("title"));
				} else {// 限制
					int user_gain_times = Integer.parseInt(couponCategory.get("user_gain_times"));
					Record user_has_coupon = Db.findFirst(
							"select count(*) as count from t_user_coupon where user_id =? and activity_id = ?",
							orderData.getUserId(), activity.getInt("id"));

					long user_coupon_count = user_has_coupon.getLong("count");
					if (user_coupon_count < (user_gain_times * couponCategory.getInt("give_coupon_amount"))) {// 发券
						// 生成一张券（返券）
						Record couponRecord = new Record();
						couponRecord.set("coupon_category_id", couponCategory.getInt("id"));
						couponRecord.set("activity_id", couponCategory.get("activity_id"));
						couponRecord.set("coupon_desc", couponCategory.get("coupon_desc"));
						couponRecord.set("coupon_val", couponCategory.get("coupon_val"));
						couponRecord.set("min_cost", couponCategory.get("min_cost"));
						int yxq = Integer.parseInt(couponCategory.get("yxq"));
						Date date = new Date();// 取时间
						couponRecord.set("start_time", DateFormatUtil.format1(date));
						// 截至时间加上有效期
						Calendar calendar = new GregorianCalendar();
						calendar.setTime(date);
						calendar.add(calendar.DATE, yxq);// 把日期往后增加15天.整数往后推,负数往前移动
						date = calendar.getTime(); // 这个时间就是日期往后推一天的结果
						couponRecord.set("end_time", DateFormatUtil.format1(date));
						// 返券，写为领取
						couponRecord.set("status", "1");
						couponRecord.set("yxbz", "Y");
						
						Record couponUserRecord = new Record();
						couponUserRecord.set("user_id", orderData.getUserId());
						couponUserRecord.set("is_expire", "0");
						couponUserRecord.set("title", couponRecord.getStr("coupon_desc"));
						couponUserRecord.set("activity_id", couponRecord.get("activity_id"));
						// 返劵时候的订单编号
						couponUserRecord.set("order_id", orderData.getOrderId());
						// 返劵时候的订单类型
						couponUserRecord.set("order_type", orderData.getType());
						couponUserRecord.set("create_time", DateFormatUtil.format1(new Date()));

						// 返券张数
						for (int i = 0; i < couponCategory.getInt("give_coupon_amount"); i++) {
							Db.save("t_coupon_real", couponRecord);
							couponUserRecord.set("coupon_id", couponRecord.getLong("id"));
							Db.save("t_user_coupon", couponUserRecord);
							couponRecord.remove("id");
							couponUserRecord.remove("id");
						}
						;
						logger.info("返券促销活动内" + orderData.getUserId() + "订单" + orderData.getOrderId() + "支付了"
								+ orderData.getNeedPay() + "获得" + couponCategory.getInt("give_coupon_amount")
								+ "张优惠券" + couponUserRecord.getStr("title"));
					}
				}																																				
				
			}
		
		}
	}
}