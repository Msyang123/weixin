package com.sgsl.activity;

import java.util.Date;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.utils.DateFormatUtil;

/**
 * 充值送九宫格抽奖活动
 */
public class RechargeJggWatcher implements Watcher {
	protected final static Logger logger = Logger.getLogger(RechargeJggWatcher.class);

	@Override
	public void update(TransmitDataInte data) {
		try {
			// 查找有效的九宫格抽奖活动
			MActivity activity = MActivity.dao.findFirst("select * from m_activity where yxbz='Y' and activity_type=13 and cjjh_type=4");
			if (activity != null && "4".equals(activity.get("cjjh_type"))) {// 这个活动存在且在此次活动时间内
				int activity_money = activity.getInt("activity_money");// 充值达标金额
				RechargeTransmitData rechargeTransmitData = (RechargeTransmitData) data;
				int charge_money = rechargeTransmitData.getRecharge();
				Record userAwardRecord = Db.findFirst(
						"select * from t_user_award_record where user_id=? and out_trade_no=?",
						rechargeTransmitData.getUserId(), rechargeTransmitData.getOutTradeNo());
				if(userAwardRecord!=null){//已经赠送抽奖机会
					return;
				}
				if (charge_money >= activity_money) {// 充值满200送抽奖机会
					String user_id = rechargeTransmitData.getUserId();// 用户id
					int activity_id = activity.getInt("id");// 活动id
					Record record = new Record();
					record.set("user_id", user_id);
					record.set("activity_id", activity_id);
					record.set("is_valid", 1);
					record.set("get_time", DateFormatUtil.format5(new Date()));
					record.set("out_trade_no", rechargeTransmitData.getOutTradeNo());
					int recharge_times = activity.getInt("default_czcjjh_count");// 充值赠送机会
					boolean boo = true;
					for (int i = 0; i < recharge_times; i++) {// 赠送抽奖机会次数
						boo = Db.save("t_user_award_record", record);
						record.remove("id");
					}
					if (boo) {
						logger.info("用户" + user_id + "充值了" + charge_money + ",获得" + recharge_times + "抽奖记录");
					} else {
						logger.info("用户" + user_id + "充值了" + charge_money + ",系统出错，没有赠送抽奖记录");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("=====充值满送抽奖活动异常，赠送失败=====");
		}
	}

}
