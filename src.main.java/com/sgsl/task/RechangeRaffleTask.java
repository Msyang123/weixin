package com.sgsl.task;

import java.util.Date;
import java.util.List;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.utils.DateFormatUtil;

public class RechangeRaffleTask extends Thread{
	
	protected final static Logger logger = Logger.getLogger(RechangeRaffleTask.class);
	private long sleepTime;

	public RechangeRaffleTask() {
	}

	public RechangeRaffleTask(long sleepTime) {
		this.sleepTime = sleepTime;
	}
	
	
	@Override
	public void run() {
		/*while (true) {
			logger.info("====进了充值满200送九宫格抽奖活动定时任务=====");
			//查找有效的九宫格抽奖活动
			try {//查出这个活动是否有效
				MActivity activity = MActivity.dao.findYxActivityByType(13);

				if(activity!=null&&"4".equals(activity.get("cjjh_type"))){
					Date start_time = activity.getDate("yxq_q");//活动开始时间
					Date end_time = activity.getDate("yxq_z");//活动结束时间
					//在活动期间充值满足活动的用户
					List<Record> userList = Db.find("select u.nickname,u.id,pl.total_fee,DATE_FORMAT(pl.time_end,'%Y-%m-%d %H:%i:%s') time_end " 
							+" from t_user u left join t_pay_log pl on u.open_id=pl.openid "
							+" where pl.source_type='recharge' and pl.shop_type is null and DATE_FORMAT(pl.time_end,'%Y-%m-%d %H:%i:%s')>= DATE_FORMAT(?,'%Y-%m-%d %H:%i:%s') "
							+"	and DATE_FORMAT(pl.time_end,'%Y-%m-%d %H:%i:%s')<=DATE_FORMAT(?,'%Y-%m-%d %H:%i:%s')  "
							+"  and pl.total_fee>=?",start_time,end_time,activity.getInt("activity_money"));
					
					if(userList!=null){
						//判断该用户先一天是否有有效的抽奖记录
						for(Record user:userList){
							System.out.println("userid=========="+user.getInt("id"));
							Record isRaffle = Db.findFirst("select * from t_user_award_record tuar "
									+ "where user_id=? and TO_DAYS(NOW())- TO_DAYS( tuar.get_time) <= 1 ", user.getInt("id"));
							
							if(isRaffle!=null){
								if(isRaffle.get("is_valid").equals("1")){
									Db.update("update t_user_award_record set is_valid=0 where id=? ",isRaffle.getInt("id"));
									logger.info("====用户"+isRaffle.getInt("user_id")+"先一天未抽奖记录作废=====");
								}
								//查看本日是否已经送过，送过就不再赠送
								Record giveRecord = Db.findFirst("select * from t_user_award_record where user_id =? and get_time = DATE_FORMAT(NOW(),'%Y-%m-%d') ",user.getInt("id"));
								if(giveRecord==null){//没有赠送，送一次抽奖机会
									Record record = new Record();
									record.set("user_id", isRaffle.get("user_id"));
									record.set("activity_id", activity.getInt("id"));
									record.set("is_valid", 1);
									record.set("get_time", DateFormatUtil.format5(new Date()));
									Db.save("t_user_award_record", record);
									logger.info("====用户"+isRaffle.getInt("user_id")+"先一天没有抽奖记录，今日成功获取一次抽奖机会=====");
								}
							}
							
						}
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("=====充值满200送抽奖活动异常，赠送失败=====");
			}
			try {
				sleep(this.sleepTime);
			} catch (InterruptedException e) {
				logger.error("海鼎订单减库存定时任务线程出错"+e.getLocalizedMessage());
			}
		}*/
	}
	
}
