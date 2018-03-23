package com.sgsl.task;

import java.util.List;

import com.jfinal.log.Logger;
import com.sgsl.model.MTeamBuy;
import com.sgsl.model.MTeamMember;

/**
 * 团购超时取消并退款
 * 过期时间为1天
 * @author yijun
 *
 */
public class TeamBuyCancelTask extends Thread{
	public TeamBuyCancelTask(){
		super();
	}
	protected final static Logger logger = Logger.getLogger(TeamBuyCancelTask.class);
	private String apiclientCertPath;
	private long sleepTime;
	private MTeamMember memberOper=new MTeamMember();
	private MTeamBuy buyoper=new MTeamBuy();
	
	public TeamBuyCancelTask(String apiclientCertPath,long sleepTime){
		this.apiclientCertPath=apiclientCertPath;
		this.sleepTime=sleepTime;
	}
	@Override
	public void run() {
		while(true){
			List<MTeamBuy> alreadBeginTeamBuys=buyoper.alreadBeginTeam();
			for(MTeamBuy item:alreadBeginTeamBuys){
				try {
					buyoper.cancelTeamBuy(item.getInt("id"),this.apiclientCertPath);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			logger.info("--取消超时团购定时任务--");
			
			memberOper.cancelTeamMemberUnpay();
			logger.info("--取消超时团购订单定时任务--");
			try {
				sleep(sleepTime);
			} catch (InterruptedException e) {
				logger.info("--取消超时团购订单定时任务线程出错--"+e.getLocalizedMessage());
			}
		}
	}

}
