package com.sgsl.activity;

import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TOrder;
import com.sgsl.model.TUser;
import com.sgsl.utils.DateFormatUtil;

//具体的主题角色coupon  首单免单活动
//具体的主题角色  首单送鲜果币活动
public class OrderActivity3Watcher implements Watcher {
	protected final static Logger logger = Logger.getLogger(OrderActivity3Watcher.class);
	// @Override
	// public void update(TransmitDataInte data)
	// {
	// OrderTransmitData orderData=(OrderTransmitData)data;
	// //查找当前用户是否存在过已经支付成功的订单
	// if(orderData.getUserId()==1){
	// orderData.setNeedPay(0);
	// }
	// System.out.println("首单免单内"+orderData.getUserId()+"订单"+orderData.getOrderId()+"需要支付"+orderData.getNeedPay());
	// }

	@Override
	public void update(TransmitDataInte data) {
		OrderTransmitData orderData = (OrderTransmitData) data;
		int user_id = orderData.getUserId();
		// 查看首单即送活动是否有效（有效标志，有效时间段），有效则执行，无效就不执行
		String sql = "select id,activity_money from m_activity where activity_type = '11' and yxbz = 'Y' and yxq_q <= NOW() and yxq_z >=NOW()";
		MActivity mActivity = new MActivity().findFirst(sql);

		if (mActivity != null) {
			// 后台设置赠送的鲜果币个数
			int blance = mActivity.get("activity_money");

			// 查看是否首单(排除团购订单)
			TOrder tOrder = new TOrder();
			List<TOrder> orders = tOrder
					.find("select order_id from t_order t where order_status > 2 and order_status <= 11 "
							+ "and 	order_id not in(select order_id from m_team_member m where team_user_id=? and is_pay='Y') "
							+ "and order_user =? ", user_id, user_id);
			// 查看用户是否已经获得过首单送鲜果币福利,如果有记录就不执行,有记录说明下过单
			TBlanceRecord tbBlanceRecord = new TBlanceRecord().findFirst(
					"select id,user_id from t_blance_record where user_id = ? and ref_type = 'first_present'", user_id);

			// 没有记录就去添加,有记录无需操作
			if (tbBlanceRecord == null && orders.size() == 1) {
				// 赠送鲜果币,获取后台赠送的鲜果币个数
				Record record = new Record();
				record.set("store_id", orderData.getOrder().get("order_store"));
				record.set("user_id", user_id);
				record.set("blance", blance);
				record.set("ref_type", "first_present");
				record.set("create_time", DateFormatUtil.format1(new Date()));
				record.set("order_id", orderData.getOrderId());
				// 像表中增加一条记录
				Db.save("t_blance_record", record);

				// 给用户鲜果币余额加上所赠送的鲜果币数
				TUser tUser = new TUser().findById(user_id);
				int new_balance = (int) tUser.get("balance") + blance;
				Db.update("update t_user set balance = ? where id = ?", new_balance, user_id);

				logger.info("首单即送鲜果币：" + user_id + "用户获得" + (double) blance / 100.0 + "鲜果币 ");

			}
		}
	}

}