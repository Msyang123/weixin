package com.sgsl.task;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MInterval;
import com.sgsl.util.StringUtil;

/**
 * 根据发放种子根据区间时间自动开启关闭
 * 
 * @author yjw
 */
public class SeedTimeUpOrDownTask extends Thread{

	protected final static Logger logger = Logger.getLogger(SeedTimeUpOrDownTask.class);
	private long sleepTime;
	
	public SeedTimeUpOrDownTask(){
	}
	
	public SeedTimeUpOrDownTask(long sleepTime){
		this.sleepTime = sleepTime;
	}
	
	@Override
	public void run() {
		while(true){
			logger.info("====进了自动检测启动关闭种子定时任务===");
			//设置日期格式
			MActivity activity = MActivity.dao.findYxActivityByType(18);//查找有效的种子活动
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = df.format(new Date());//当前时间
			if(activity!=null){
				String start_time = df.format(activity.getDate("yxq_q"));//活动开始时间
				String end_time = df.format(activity.getDate("yxq_z"));//活动结束时间
				//当前时间大于活动开始时间小于活动结束时间（有效时间）
				if(currentTime.compareTo(start_time)>=0&&currentTime.compareTo(end_time)<=0){
					 MInterval interval = MInterval.dao.findFirst("select * from m_interval where activity_id=?",activity.getInt("id"));
					 if(interval!=null){
						 if(currentTime.compareTo(interval.get("begin_time"))>=0&&currentTime.compareTo(interval.get("end_time"))<=0){
							 interval.set("status", 1);
						 }else{
							 interval.set("status", 0);
						 }
						 interval.update();
					 }
				}else{
					logger.info("====不是有效的活动时间===");
				}
			}
			try {
				sleep(this.sleepTime);
			} catch (InterruptedException e) {
				logger.error("添加记录定时任务线程出错" + e.getLocalizedMessage());
			}
		}
		
	}
}
