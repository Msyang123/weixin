package com.sgsl.task;


import java.util.Date;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.IAtom;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TOrder;
import com.sgsl.util.HdUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.xgs.model.XAchievementRecord;

/**
 * 将订单中状态为待收货(3)的订单改为失效(0)
 * 过期时间为3天
 * @author yijun
 *
 */
public class OrderInvalidTask extends Thread{
	protected final static Logger logger = Logger.getLogger(OrderInvalidTask.class);
	private long sleepTime;
	private String refType="orderBack";
	public OrderInvalidTask(){}
	public OrderInvalidTask(long sleepTime){
		this.sleepTime=sleepTime;
	}
	@Override
	public void run() {
		
		while(true){
			logger.info("--开始将订单中状态为待收货(3)的订单改为失效(0)定时任务--");
			String currentDate=DateFormatUtil.format1(new Date());
			TBlanceRecord blanceRecordOper=new TBlanceRecord();
			//超过三天并且是门店自提未提货订单
			List<TOrder> orderList= TOrder.dao.find("select * from t_order "
					+ "where order_status=3 and deliverytype='1' and unix_timestamp(date_format(createtime,'%Y-%m-%d %H:%i:%s'))<unix_timestamp(date_sub(now(),interval 3 day))");
			
        	for(TOrder item:orderList){
        		//排除备了货，但是由于外部原因，数据库中订单状态没变的订单,直接修改数据库中订单状态
        		String order_status = HdUtil.orderDetail(item.getStr("order_id"));
        		if("delivering".equals(order_status)||"delivered".equals(order_status)){
        			Db.update("update t_order set order_status=4 where id =?",item.getInt("id"));
        			continue;
        		}
        	//查找此订单是否已经有退款记录
        	  TBlanceRecord blanceRecord=blanceRecordOper.getRecordByOrderId(
        			  item.getInt("order_user"),
        			  item.getStr("order_id"),
        			  refType);
        	  //找到这条已经处理的订单，就跳过
        	  if(blanceRecord!=null){
        		  continue;
        	  }
        		//事务优化
  		      Db.tx(new IAtom() {
  		    	boolean saveDataResult = true;
  		    	String hdCancelOrderResult=null;
  				JSONObject jsonResult=new JSONObject();
  		        @Override
  		        public boolean run(){
        		//发起海鼎订单取消订单
  		        logger.info("海鼎取消订单定时任务记录order_id:"+item.getStr("order_id")+"status:"+item.getStr("order_status"));	
        		hdCancelOrderResult=HdUtil.orderCancel(item.getStr("order_id"), "72小时未提货");
        		if(hdCancelOrderResult!=null){
        			//去掉 code=200
        			hdCancelOrderResult=hdCancelOrderResult.substring(8);
        			jsonResult=JSONObject.parseObject(hdCancelOrderResult);
        			//调用成功
        			if(jsonResult.getBooleanValue("success")){
        				item.set("order_status", "0");
        				item.update();
        				//是别人的客户，此时就需要添加一条收支明细
        				Record orderRecord = Db.findFirst("select * from t_order where id = ?",item.getInt("id"));
        				if(StringUtil.isNotNull(String.valueOf(orderRecord.getInt("master_id")))){
        					XAchievementRecord.dao.addXAchievementRecord(orderRecord, 4);
        				}
        				//加果币
		    			Db.update("update t_user set balance=balance+? where id=?",
		    					item.getInt("need_pay"),
		    					item.getInt("order_user"));
		    			//增加加果币记录
		    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
		    			tBlanceRecord.set("store_id", item.getStr("order_store"));
		    			tBlanceRecord.set("user_id", item.getInt("order_user"));
		    			tBlanceRecord.set("blance", item.getInt("need_pay"));
		    			tBlanceRecord.set("ref_type", refType);
		    			tBlanceRecord.set("create_time", currentDate);
		    			tBlanceRecord.set("order_id", item.getStr("order_id"));
		    			tBlanceRecord.save();
        				saveDataResult=true;
        			}
        			else{
        				saveDataResult=false;
        			}
        		}
        		else{
        			saveDataResult=false;
        		}
        		return saveDataResult;
  		        }
  		     });
        	
          }  
    	 try {
	        sleep(this.sleepTime);
	      } catch (InterruptedException e) {
	        logger.error("将订单中状态为待收货(3)的订单改为失效(0)定时任务线程出错"+e.getLocalizedMessage());
	      }
		}	
	}

}
