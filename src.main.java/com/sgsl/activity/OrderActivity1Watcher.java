package com.sgsl.activity;

import java.util.List;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPresent;

//具体的主题角色 满立减活动 随机立减 支付前减金额 10分钟内一个用户5单以上就不减
public class OrderActivity1Watcher implements Watcher {
	protected final static Logger logger = Logger.getLogger(OrderActivity1Watcher.class);

	@Override
	public void update(TransmitDataInte data) {
		
		int activityType = 7;
		MActivity activity = new MActivity();
		List<Record> mljs = activity.findMActivitys(activityType);
		OrderTransmitData orderData = (OrderTransmitData) data;

		if ("gm".equals(orderData.getType())) {
			TOrder order = TOrder.dao.findById(orderData.getOrderId());
			Record unpay = order.findTUnpayOrderTotal(orderData.getUserId());

			if (mljs.size() > 0 && (unpay == null || unpay.getLong("dfk") < 10)) {
				// 获取满立减配置信息
				Record mlj = mljs.get(0);
				// 达到满立减金额
				if (order.getInt("total") >= mlj.getInt("full_amount")) {

					// 查看是否随机,随机则去随机生成一个金额
					String money_random = mlj.getStr("money_random");
					int activity_money = mlj.getInt("activity_money");
					if (money_random.equals("Y")) {
						activity_money = (int) (Math.random() * activity_money);
						if(activity_money == 0){//防止满立减为0元
							activity_money = mlj.getInt("activity_money");
							}
					}

					order.set("discount", order.getInt("discount") + activity_money);
					order.set("need_pay", order.getInt("need_pay") - activity_money);
					order.update();
					logger.info("满立减活动" + orderData.getUserId() + "购买订单" + orderData.getOrderId() + "需要支付"
							+ orderData.getNeedPay());
				}
			}
		} else if ("zs".equals(orderData.getType())) {
			TPresent present = orderData.getPresent();
			Record unpay = present.findTUnpayPresentTotal(orderData.getUserId());

			if (mljs.size() > 0 && (unpay == null || unpay.getLong("present_count") < 10)) {
				// 获取满立减配置信息
				Record mlj = mljs.get(0);
				// 达到满立减金额
				if (present.getInt("need_pay") >= mlj.getInt("full_amount")) {

					// 查看是否随机,随机则去随机生成一个金额
					String money_random = mlj.getStr("money_random");
					int activity_money = mlj.getInt("activity_money");
					if (money_random.equals("Y")) {
						activity_money = (int) (Math.random() * activity_money);
						if(activity_money == 0){//防止满立减为0元
							activity_money = mlj.getInt("activity_money");
							}
					}

					present.set("discount", activity_money);
					present.set("need_pay", present.getInt("need_pay") - activity_money);
					present.update();
					logger.info("满立减活动" + orderData.getUserId() + "赠送订单" + orderData.getPresent().get("id") + "需要支付"
							+ present.get("need_pay"));
				}
			}
		}
	}

}