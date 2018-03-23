package com.sgsl.task;

import java.util.Date;
import java.util.List;
import java.util.TimerTask;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.utils.DateFormatUtil;
import com.xgs.model.XBonusPercentage;
import com.xgs.model.XFruitMaster;

public class MasterAchievementRecordTask extends Thread {

	protected final static Logger logger = Logger.getLogger(MasterAchievementRecordTask.class);
	private long sleepTime;

	public MasterAchievementRecordTask() {
	}

	public MasterAchievementRecordTask(long sleepTime) {
		this.sleepTime = sleepTime;
	}

	/**
	 * 月初的时候生成下级红利记录。将鲜果师定时任务结算状态变为未启动
	 * 
	 */
	@Override
	public void run() {
		while (true) {
			logger.info("====月初刷新定时任务=");
			Date currentTime = new Date();
			int day = currentTime.getDate();
			if (day == 1) {// 定时任务只在1号之后刷
				List<Record> record = Db.find("select * from x_fruit_master where is_caculate=1");
				if(record.size()>0){
					Db.update("update x_fruit_master set is_caculate=0 where is_caculate=1");
				}
				logger.info("========鲜果师结算状态重置=======");
			}
			if (day == 7) {//7号之后不能退货
				// 从下级分成比例
				int bonus_percentage = XBonusPercentage.dao.findFirst("select * from x_bonus_percentage")
						.getInt("bonus_percentage");
				Record achievementRecord = new Record();
				List<XFruitMaster> masterList = XFruitMaster.dao
						.find("select * from x_fruit_master where master_status = 3 and is_add_record =0");
				for (XFruitMaster xFruitMaster : masterList) {

					List<XFruitMaster> subMasterList = XFruitMaster.dao
							.findSubMasterListById(xFruitMaster.getInt("id"));
					double sub_sale_bonus = 0;
					if (subMasterList.size() > 0) {// 有下级鲜果师下级的时候才需要计算从下级获得红利，否则不需要算
						String subMaster_ids = "(";
						System.out.println("<<><><><>" + subMasterList.size());
						for (XFruitMaster subMaster : subMasterList) {
							subMaster_ids += subMaster.get("id") + ",";
						}
						// 拼接出(1,2,3)这种格式
						subMaster_ids = subMaster_ids.substring(0, subMaster_ids.length() - 1) + ")";
						// 统计下级分销商的订单交易额
						Record subMasterRecod = Db.findFirst(
								"select ifnull(sum(need_pay),0) sale_total from t_order where order_status = 11 "
										+ " and master_id in " + subMaster_ids + " and order_source = '1' "
										+ " and date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m-00 00:00:00') <= pay_time "
										+ " and pay_time <= date_format(DATE_SUB(curdate(), INTERVAL 0 MONTH),'%Y-%m-00 00:00:00')");
						sub_sale_bonus = Integer.parseInt(subMasterRecod.get("sale_total").toString())
								* bonus_percentage / 100.0;
						if (sub_sale_bonus > 0) {// 从下级获利大于0的加入记录
							achievementRecord.set("master_id", xFruitMaster.getInt("id"));
							achievementRecord.set("money", sub_sale_bonus);
							achievementRecord.set("type", 2);
							achievementRecord.set("time", DateFormatUtil.format1(new Date()));
							Db.save("x_achievement_record", achievementRecord);
							achievementRecord.clear();
						}
					}
					xFruitMaster.set("is_add_record", 1);
					xFruitMaster.update();
				}
				logger.info("=====下级红利记录生成========");
			}
			try {
				sleep(this.sleepTime);
			} catch (InterruptedException e) {
				logger.error("添加记录定时任务线程出错" + e.getLocalizedMessage());
			}
		}
	}

}
