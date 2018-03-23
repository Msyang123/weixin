package com.sgsl.task;

import java.util.List;
import java.util.Map;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.IAtom;
import com.sgsl.model.TOrder;
import com.sgsl.model.TUser;
import com.sgsl.util.HdUtil;
import com.sgsl.util.PushUtil;

/**
 * 用户订单提货短信通知
 * 时间为2天
 * @author yijun
 *
 */
public class OrderRemindTask extends Thread{
	protected final static Logger logger = Logger.getLogger(OrderRemindTask.class);
	private long sleepTime;
	public OrderRemindTask(){}
	public OrderRemindTask(long sleepTime){
		this.sleepTime=sleepTime;
	}
	@Override
	public void run() {
		TOrder order=new TOrder();
		TUser userOper=new TUser();
	    while(true){
	    	logger.info("--用户订单提货短信通知定时任务--");
	     //订单是已支付且配送方式为门店自提 且未发送过短信的
	      List<TOrder> orders= order.find("select * from t_order where order_status = '3' and deliverytype='1' and is_send_message='N' "
	      		+ " and unix_timestamp(date_format(pay_time,'%Y-%m-%d %H:%i:%s'))<unix_timestamp(date_sub(now(),interval 2 day))"
	      		+ " and unix_timestamp(date_format(pay_time,'%Y-%m-%d %H:%i:%s'))>unix_timestamp(date_sub(now(),interval 3 day))");
	      int orderSize=orders.size();
	      boolean saveDataResult = true;
	      TOrder item=null;
	      String phoneNum=null;
	      Object[][] orderNoticeResult=new  Object[orderSize][];
	      
	      for(int i=0;i<orderSize;i++){
	        item=orders.get(i);
	        //如果是门店自提
	        if("1".equals(item.getStr("deliverytype"))){
	        	TUser user=userOper.findTUserInfo(item.getInt("order_user"));
	        	phoneNum=user.getStr("phone_num");
	        }else{
	        	phoneNum=item.getStr("receiver_mobile");
	        }
	        String orderId=item.getStr("order_id");
	        Map<String,String> messageResult=PushUtil.sendMsgToOrderUser(phoneNum,orderId);
	        //短信发送成功
	        if("success".equals(messageResult.get("status"))){
	        	orderNoticeResult[i]=new Object[]{"Y",orderId};
	        }else{
	        	orderNoticeResult[i]=new Object[]{"N",orderId};
	        }
	      }
	      if(orderSize>0){
		      //事务优化
		      Db.tx(new IAtom() {
		        @Override
		        public boolean run(){
		          //批量处理修改数据
		          Db.batch("update t_order set is_send_message = ? where order_id = ?", orderNoticeResult, orderSize);
		          return saveDataResult;
		        }
		      });
	      }    
	      System.out.println("--结束用户订单提货短信通知定时任务--");
	      try {
	        sleep(this.sleepTime);
	      } catch (InterruptedException e) {
	        logger.error("用户订单提货短信通知定时任务线程出错"+e.getLocalizedMessage());
	      }
	    }
	}

}
