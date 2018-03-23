package com.sgsl.task;

import java.util.Date;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.sgsl.model.TDeliverNote;
import com.sgsl.util.DadaUtil;

/**
 * 达达配送9:00-21:00发送订单，其他时间段统一第二天发单 此用于未发送成功订单或者其中取消掉的订单
 * @author yijun
 *
 */
public class OrderDadaSendTask extends Thread{
	protected final static Logger logger = Logger.getLogger(OrderDadaSendTask.class);
	private long sleepTime;
	
	public OrderDadaSendTask(){}
	public OrderDadaSendTask(long sleepTime){
		this.sleepTime=sleepTime;
	}
	@Override
	public void run() {
		//0-未接单 1-待取货 2-配送中 3-配送完成 4-配送失败 5-未配送
	    while(true){
	    	Date currentTime=new Date();
	    	if (currentTime.getHours()>= 9 && currentTime.getHours()<=21){
	    		logger.info("--开始达达配送定时任务--");
	  	       //查找所有未配送的达达配送单
	  	       List<TDeliverNote> deliverNotes= TDeliverNote.dao.find("select * from t_deliver_note where deliver_status = '4' and failure_cause='订单自动过期'");
	  	      
	  	       for(TDeliverNote item:deliverNotes){
	  	    	  
	  	    	  JSONObject addOrderResult=new DadaUtil().send(item.getStr("order_id"));
	  	    	  logger.info(addOrderResult.toJSONString());
	  	    	  if(addOrderResult!=null&&addOrderResult.getIntValue("code")==0){
	  	    		  //成功就是未接单状态
	  	    		  item.set("deliver_status", "0");
	  	    		  item.update();
	  	    	  }else if(addOrderResult!=null&&addOrderResult.getIntValue("code")==-1){
	  	    		  item.set("deliver_status", "6");
	  	    		  item.set("failure_cause", addOrderResult.get("msg"));
	  	    		  item.update();
	  	    	  }else{
	  	    		  logger.error("订单："+item.getStr("order_id")+"发送达达失败");
	  	    	  }
	  	       }
	  	       logger.info("--结束达达配送定时任务--");
	    	}
	      try {
	        sleep(this.sleepTime);
	      } catch (InterruptedException e) {
	        logger.error("达达配送定时任务线程出错"+e.getLocalizedMessage());
	      }
	    }
	}
	

}
