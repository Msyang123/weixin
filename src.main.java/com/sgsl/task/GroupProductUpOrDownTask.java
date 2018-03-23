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
import com.sgsl.util.StringUtil;

/**
 * 根据拼团商品上架时间和下架时间来自动设置商品的上下架
 * 
 * @author yjw
 */
public class GroupProductUpOrDownTask extends Thread{

	protected final static Logger logger = Logger.getLogger(GroupProductUpOrDownTask.class);
	private long sleepTime;
	
	public GroupProductUpOrDownTask(){
	}
	
	public GroupProductUpOrDownTask(long sleepTime){
		this.sleepTime = sleepTime;
	}
	
	@Override
	public void run() {
		while(true){
			//设置日期格式
			MActivity activity = MActivity.dao.findYxActivityByType(10);//查找有效的团购活动
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = df.format(new Date());//当前时间
			if(activity!=null){
				String start_time = df.format(activity.getDate("yxq_q"));//活动开始时间
				String end_time = df.format(activity.getDate("yxq_z"));//活动结束时间
				//当前时间大于活动开始时间小于活动结束时间（有效时间）
				if(currentTime.compareTo(start_time)>=0&&currentTime.compareTo(end_time)<=0){
					//团购期间所有商品
					List<Record> activityProductList = Db.find("select * from m_activity_product where activity_id=?", activity.getInt("id"));
					if(activityProductList.size()>0){
						for(Record activityProduct:activityProductList){
							String up_time=activityProduct.get("up_time");//商品上架时间
							String down_time=activityProduct.get("down_time");//商品下架时间
							//检测商品上架下架时间是否有空
							if(StringUtil.isNotNull(up_time)&&StringUtil.isNotNull(up_time)){
								MActivityProduct map=MActivityProduct.dao.findById(activityProduct.getInt("id"));
								
								if(currentTime.compareTo(up_time)>=0&&currentTime.compareTo(down_time)<=0){
									if(activityProduct.getInt("status")!=0){
										map.set("status", 0);//上架
										map.update();
									}
								}else{
									if(activityProduct.getInt("status")!=1){
										map.set("status", 2);//下架
										map.update();
									}
								}
							}
						}
					}else{
						logger.info("====没有团购商品===");
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
