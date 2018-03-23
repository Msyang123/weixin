package com.sgsl.activity;

import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.util.GiveGuobi;
import com.sgsl.utils.DateFormatUtil;

//具体的主题角色coupon  支付完成后鲜果币随机送活动
//活动2：鲜果币任意送
//活动时间：2017年2月13日至2月14日
//活动内容：
//单笔消费满52.0元，随机送1.25（40%）,2.14（30%）,5.20（20%）,5.21（10%）鲜果币。
public class OrderActivity6Watcher implements Watcher
{

	
	protected final static Logger logger = Logger.getLogger(OrderActivity6Watcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
    	logger.info("进入芒果节刮奖活动");
    	int activityId=33;
    	/*
    	661		贵妃芒	
    	644		水仙芒	
    	594		青皮芒果	
    	525		小台芒	
    	524		大台芒*/
    	//活动商品
    	List<MActivityProduct> activityPros=
    			MActivityProduct.dao.find("select * from m_activity_product where activity_id=?",activityId);
    	
    	OrderTransmitData orderData=(OrderTransmitData)data;
		//送果币活动
		TBlanceRecord blanceRecordOper=new TBlanceRecord();
		TBlanceRecord result= blanceRecordOper.getRecordByOrderId(orderData.getUserId(),orderData.getOrderId()); 
		//查找送果币活动
		List<Record> res= Db.find("select p.* from t_balance_percent p left join m_activity m on m.id=p.activity_id "+
		" where m.id=? and m.yxbz='Y' ",activityId);
		if(res.size()==0)
			return;
		//没有才抽奖 并且配置了活动 以及订单满52元
		int needPay="gm".equals(orderData.getType())?orderData.getOrder().getInt("total"):orderData.getPresent().getInt("need_pay");
		
		int effectivePay=0;
		for(MActivityProduct item:activityPros){
			if("gm".equals(orderData.getType())){
				for(Record orderPro:orderData.getOrder().getOrderProducts()){
					if(item.getInt("product_f_id").equals(orderPro.getInt("product_f_id"))){
						effectivePay+=orderPro.getLong("unit_price");
					}
				}
			}else{
				for(Record orderPro:orderData.getPresent().getPresentProducts()){
					if(item.getInt("product_f_id").equals(orderPro.getInt("pf_id"))){
						effectivePay+=(orderPro.getInt("amount")*orderPro.getInt("unit_price"));
					}
				}
			}
			
		}
		logger.info("芒果节活动类型"+orderData.getType()+"需要支付"+needPay+"芒果在订单中金额:"+effectivePay);
		if(result==null&&effectivePay>=3800){
			GiveGuobi giveGuobi=new GiveGuobi(
					res.get(0).getDouble("percent").toString(),
					res.get(1).getDouble("percent").toString(),
					res.get(2).getDouble("percent").toString(),
					res.get(3).getDouble("percent").toString(),
					res.get(4).getDouble("percent").toString());
			Record re=res.get(giveGuobi.get());
			double gb=re.getDouble("min_count");
			logger.info("果币活动满足条件"+orderData.getOrderId()+"赠送鲜果币:"+gb);
			//加果币
			Db.update("update t_user set balance=balance+? where id=?",(int)(gb*100),orderData.getUserId());
			//增加加果币记录
			TBlanceRecord tBlanceRecord=new TBlanceRecord();
			if("gm".equals(orderData.getType())){
				tBlanceRecord.set("store_id", orderData.getOrder().getStr("order_store"));
			}
			
			tBlanceRecord.set("user_id", orderData.getUserId());
			tBlanceRecord.set("blance", gb*100);
			tBlanceRecord.set("ref_type", "order");
			tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
			tBlanceRecord.set("order_id", orderData.getOrderId());
			tBlanceRecord.save();
			logger.info("芒果节刮奖活动成功");
		}
    }

}