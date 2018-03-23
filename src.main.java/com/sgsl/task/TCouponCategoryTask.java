package com.sgsl.task;

import java.util.List;
import com.jfinal.log.Logger;
import com.sgsl.model.MTeamBuy;
import com.sgsl.model.TCouponCategory;

/**
 * 优惠券兑换码活动超时修改状态为N
 * @author andrew
 *
 */
public class TCouponCategoryTask extends Thread{
	public TCouponCategoryTask(){
		super();
	}
	
	public TCouponCategoryTask(long sleepTime){
		this.sleepTime = sleepTime;
	}
	
	protected final static Logger logger = Logger.getLogger(TeamBuyCancelTask.class);
	private String apiclientCertPath;
	private long sleepTime;
	private TCouponCategory category=new TCouponCategory();
	
	public TCouponCategoryTask(String apiclientCertPath,long sleepTime){
		this.apiclientCertPath=apiclientCertPath;
		this.sleepTime=sleepTime;
	}
	
	@Override
	public void run(){
		while(true){
			logger.info("====进了优惠券兑换码活动定时任务===");
			List<TCouponCategory> alreadBeginList=category.alreadBeginList();
			for(TCouponCategory item:alreadBeginList){
				category.cancelCouponCategory(item.getInt("id"));
			}
			
			logger.info("====取消优惠券兑换码活动定时任务====");
			try {
				sleep(sleepTime);
			} catch (InterruptedException e) {
				logger.info("====取消优惠券兑换码活动线程出错===="+e.getLocalizedMessage());
			}
		}
	}
	
}
