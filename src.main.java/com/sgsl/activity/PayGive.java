package com.sgsl.activity;

import java.util.List;


import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.controller.PaymentController;

public class PayGive {
	protected final static Logger logger = Logger.getLogger(PaymentController.class);
	public void give(int totalFee){
		int fee = totalFee;
		try {
			int give=0;
			List<Record> gives = Db.find("select * from t_user_recharge_gift where on_off = '1' order by give_fee desc");
			for (Record record : gives) {
				int recharge_fee = record.getInt("recharge_fee");
				if(fee >= recharge_fee){
					give = record.getInt("give_fee");
					break;
				}
			}
		} catch (Exception e) {
			logger.error("========充值赠送活动异常，赠送失败。=======", e);
		}
	}
}
