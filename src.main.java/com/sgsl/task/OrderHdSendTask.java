package com.sgsl.task;

import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.IAtom;
import com.sgsl.model.TOrder;
import com.sgsl.util.HdUtil;
import com.sgsl.utils.DateFormatUtil;

/**
 * 海鼎定时发送
 * @author yijun
 *
 */
public class OrderHdSendTask extends Thread{
	protected final static Logger logger = Logger.getLogger(OrderHdSendTask.class);
	private long sleepTime;
	public OrderHdSendTask(){}
	public OrderHdSendTask(long sleepTime){
		this.sleepTime=sleepTime;
	}
	@Override
	public void run() {
		
	    while(true){
	    	logger.info("--开始海鼎订单减库存定时任务--");
	      String current=	DateFormatUtil.format1(new Date());
	      TOrder order=new TOrder();
	      List<TOrder> orders= order.find("select * from t_order where hd_status = '1' ");
	      int orderSize=orders.size();
	      boolean saveDataResult = true;
	      TOrder item=null;
	      Object[][] orderReduceResult=new  Object[orderSize][];
	      
	      int orderTodadaSize=0;
	      for(int i=0;i<orderSize;i++){
	        item=orders.get(i);
	        String orderId=item.getStr("order_id");
	        //海鼎发货成功
	        if(HdUtil.orderReduce(orderId)){
	          orderReduceResult[i]=new Object[]{"0",orderId};
	          //应该是送货上门的才需加
	          if("2".equals(item.getStr("deliverytype"))){
	        	  //达达配送订单数累加
	        	  orderTodadaSize++;
	          }
	        }else{
	          orderReduceResult[i]=new Object[]{"1",orderId};
	        }
	      }
	      Object[][] orderTodadaResult=new  Object[orderTodadaSize][];
	      int j=0;
	      for(Object[] orderReduceItem: orderReduceResult){
	    	  //只取海鼎发送成功的并且是送货上门的
	    	  TOrder findOrder= order.findTOrderByOrderId(orderReduceItem[1].toString());
	    	  if("0".equals(orderReduceItem[0])&&"2".equals(findOrder.getStr("deliverytype"))){
	    		  orderTodadaResult[j]=new Object[]{orderReduceItem[1],findOrder.getStr("order_store"),current,"5"};
	    		  j++;
	    	  }
	      }
	      if(orderSize>0){
		      //事务优化
		      Db.tx(new IAtom() {
		        @Override
		        public boolean run(){
		          //批量处理修改数据
		          Db.batch("update t_order set hd_status = ? where order_id = ?", orderReduceResult, orderSize);
		          //批量插入达达配送单数据
		          if(orderTodadaResult.length>0){
		        	  Db.batch("insert into t_deliver_note(order_id,order_store,create_time,deliver_status) values(?,?,?,?)", 
		        		  orderTodadaResult,orderTodadaResult.length);
		          }
		          return saveDataResult;
		        }
		      });
	      }
	      logger.info("--结束海鼎订单减库存定时任务--");
	      try {
	        sleep(this.sleepTime);
	      } catch (InterruptedException e) {
	        logger.error("海鼎订单减库存定时任务线程出错"+e.getLocalizedMessage());
	      }
	    }
	}

}
