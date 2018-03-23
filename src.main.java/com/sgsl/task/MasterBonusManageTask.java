package com.sgsl.task;

import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Record;
import com.xgs.controller.FruitMasterController;
import com.xgs.model.XApplyMoney;
import com.xgs.model.XFruitMaster;

/**
 * 每个月没有结算过的鲜果师，把上月个可就结算的金额刷到鲜果师（x_fruit_master）可剩余可结算余额中
 * 
 * @author User
 */
public class MasterBonusManageTask extends Thread {

	protected final static Logger logger = Logger.getLogger(MasterBonusManageTask.class);
	private long sleepTime;

	public MasterBonusManageTask() {
	}

	public MasterBonusManageTask(long sleepTime) {
		this.sleepTime = sleepTime;
	}

	/**
	 * 注意！本月提交过的订单已经在申请时将上月剩余未结算的金额加到鲜果师可结算余额中，
	 * 所以此处定时任务只需将1.申请未成功的金额加到可结算金额中，2.本月为“提交申请”的鲜果师，将他们的可结算金额刷到定时任务中
	 */
	@Override
	public void run() {
		while (true) {
			logger.info("====进了自动结算定时任务=");
			Date currentTime = new Date();
			int day = currentTime.getDate();
			if (day == 21) {// 定时任务只在21号之后刷
				logger.info("====开始结算定时任务====");
				// 所有正常运作的鲜果师
				List<XFruitMaster> masters = XFruitMaster.dao
						.find("select * from x_fruit_master where master_status =3 and is_caculate=0");
				for (XFruitMaster xFruitMaster : masters) {
					// 查找鲜果师本月是否有申请记录
					XApplyMoney applyRecord = XApplyMoney.dao.findApplyRecordThisMonth(xFruitMaster.getInt("id"));
					if (applyRecord == null) {// 本月没有提交过申请且没有将金额处理，将上月所有可结算金额加到鲜果师的可结算余额中
						// 计算上月可结算金额
						int bonus = FruitMasterController.caculateBonus(xFruitMaster.getInt("id"), 2);
						// 将金额加到鲜果师可结算余额中
						int new_balance = xFruitMaster.getInt("remaining_balance") + bonus;
						xFruitMaster.set("remaining_balance", new_balance);
						xFruitMaster.set("is_caculate",1);//标记已处理本月可结算金额
						boolean flag = xFruitMaster.update();
						if (flag) {
							logger.info("====将可结算金额处理成功====");
						} else {
							logger.info("====可结算金额处理不成功====");
						}
					} else if(applyRecord != null&&applyRecord.getInt("status")==0){// 本月提交过，但是没有处理，将提交记录中的金额加到鲜果师可结算余额中
						int money = FruitMasterController.caculateBonus(xFruitMaster.getInt("id"), 2);
						int new_balance = xFruitMaster.getInt("remaining_balance") + money + applyRecord.getInt("apply_money");
						xFruitMaster.set("remaining_balance", new_balance);
						xFruitMaster.set("is_caculate",1);//标记已处理本月可结算金额
						boolean flag = xFruitMaster.update();
						// 更新鲜果师可结算余额
						if (flag) {// 更新成功，让申请失效
							applyRecord.set("status", 2);
							applyRecord.update();
							logger.info("====将未处理的申请结算金额处理成功====");
						} else {
							logger.info("====将未处理的申请结算金额结算不成功====");
						}
					}else if(applyRecord != null&&applyRecord.getInt("status")==1){
						int apply_money = applyRecord.getInt("apply_money");
						int last_money = FruitMasterController.caculateBonus(xFruitMaster.getInt("id"), 2)+xFruitMaster.getInt("remaining_balance");//上月获得分红
						boolean flag = false;
						if (apply_money <= last_money) {// 提现金额小于上月可结算金额
							// 从多提的金额中减去剩余金额
							int beyond_money = last_money - apply_money;
							xFruitMaster.set("remaining_balance", beyond_money);
						}
						xFruitMaster.set("is_caculate",1);
						flag = xFruitMaster.update();
						if (flag) {// 更新成功，让申请失效
							logger.info("====将未处理的申请结算金额处理成功====");
						} else {
							logger.info("====将未处理的申请结算金额结算不成功====");
						}
					}
				}

			}
			try {
				sleep(this.sleepTime);
			} catch (InterruptedException e) {
				logger.error("结算定时任务线程出错" + e.getLocalizedMessage());
			}
		}

	}

}
