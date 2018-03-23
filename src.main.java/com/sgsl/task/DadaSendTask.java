package com.sgsl.task;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.sgsl.model.TDeliverNote;
import com.sgsl.model.TOrder;
import com.sgsl.util.DadaUtil;

/**
 * 达达延时发送定时任务
 * @author yangjiawen
 *
 */
public class DadaSendTask extends Thread{
	protected final static Logger logger = Logger.getLogger(DadaSendTask.class);
	private long sleepTime;
	
	public DadaSendTask(){}
	public DadaSendTask(long sleepTime){
		this.sleepTime=sleepTime;
	}
	@Override
	public void run() {
		//0-未接单 1-待取货 2-配送中 3-配送完成 4-配送失败 5-未配送 6-异常
	    while(true){
	    	logger.info("------进入延时发送达达-----");
	    	List<TDeliverNote> deliverNotes= TDeliverNote.dao.find("select * from t_deliver_note where deliver_status = '5' and system_content='延时配送'");
	    	for(TDeliverNote deliverNote:deliverNotes){
	    		TOrder order = TOrder.dao.findTOrderByOrderId(deliverNote.getStr("order_id"));
	    		long time = 30*60*1000;//30分钟
	    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    		Date now=new Date(new Date().getTime()+time);
	    		String e=order.getStr("deliverytime");
	    		String[] b=e.split(" ");
	    		String date=b[0];//日期 2018-02-28
	    		String[] d=b[1].split("-");
	    		String time1=d[0];//时间 15:55
	    		String deliverytime = date + " "+ time1+":00";
	    		logger.info("订单编号："+deliverNote.getStr("order_id")+"配送时间"+deliverytime);
	    		//送货上门的单  当前时间加30钟大于等于开始配送时间
	    		if("2".equals(order.getStr("deliverytype"))&&(sdf.format(now)).compareTo(deliverytime)>=0){
	    			JSONObject addOrderResult = new DadaUtil().send(deliverNote.getStr("order_id"));
		        	if(addOrderResult!=null&&addOrderResult.getIntValue("code") == 0){//达达接单成功
		        		logger.info(addOrderResult.toJSONString());
		        		deliverNote.set("deliver_status", "0").update();//待配送
		        		order.set("order_status", "12");//改变订单状态
						order.update();
		        	}else if(addOrderResult!=null&&addOrderResult.getIntValue("code")==-1){
		        		//将超过距离的配送记录到配送表中，用于手工处理
		        		deliverNote.set("deliver_status", "6")
						.set("failure_cause", addOrderResult.get("msg")).update();
	  	    	  }
	        	}
	    	}
	      try {
	        sleep(this.sleepTime);
	      } catch (InterruptedException e) {
	        logger.error("达达配送定时任务线程出错"+e.getLocalizedMessage());
	      }
	      
	    }
	}
	

}
