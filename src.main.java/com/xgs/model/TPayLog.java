package com.xgs.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.util.StringUtil;
import com.sgsl.model.TPayLog.PaySourceTypes;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.util.XPathParser;
import com.sgsl.wechat.util.XPathWrapper;

public class TPayLog extends Model<TPayLog>{
	private static final long serialVersionUID = 2402889921632720158L;
	
	public static final TPayLog dao = new TPayLog();

	/**
	 * 美味食鲜支付日志
	 * @param openid
	 * @param balance
	 * @param fee
	 * @param orderNo
	 * @return
	 */
	public boolean xgBalancePaySaveLog(String source_table,String openid, com.sgsl.model.TPayLog.PaySourceTypes balance, int fee, String orderNo,String shopType) {
		this.set("source_table", source_table);
		this.set("source_type", balance.getStringValue());
		this.set("openid", openid);
		this.set("out_trade_no", orderNo);
		this.set("total_fee", fee);
		this.set("time_end", WeChatUtil.getCurrTime("yyyyMMddHHmmss"));
		this.set("shop_type", shopType);
		return this.save();
	}
	
	/**
	 * 消费统计
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public List<Record> payStat(String startTime,String endTime){
		if(StringUtil.isNotNull(startTime)&&StringUtil.isNotNull(endTime)){
			return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where x.shop_type='1' and date_format(time_end,'%Y-%m-%d %H:%i:%s') between ? and ? group by x.source_type ",
					startTime,endTime);
		}else{
			if(StringUtil.isNotNull(startTime)){
				return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where x.shop_type='1' and ?<date_format(time_end,'%Y-%m-%d %H:%i:%s') group by x.source_type ",
						startTime);
			}
			if(StringUtil.isNotNull(endTime)){
				return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where x.shop_type='1' date_format(time_end,'%Y-%m-%d %H:%i:%s')<? group by x.source_type ",
						endTime);
			}
		}
		return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where x.shop_type='1' group by x.source_type ");
	}
	
	/**
	 * 根据销售的时间段来统计
	 * @return
	 */
	public List<Record> payStatByTime(String time,boolean isAvg){
		if(isAvg){
			return Db.find("select date_format(time_end,'%H') as h,sum(total_fee)/(100*datediff(now(),'2017-01-01')) as total_fee "+
			 " from t_pay_log where shop_type='1' group by date_format(time_end,'%H')");
		}else{
			return Db.find("select date_format(time_end,'%H') as h,sum(total_fee)/100 as total_fee "+
			 " from t_pay_log where shop_type='1' and date_format(time_end,'%Y-%m-%d') like '"+time+"%' group by date_format(time_end,'%H')");
		}
		
	}
	
	
	
	/**
	 * 根据水果类型统计订单中的下单水果数量
	 */
	public List<Record> getOrderStatByFruitType() {
		return Db.find("select sum(tp.amount) amount,p.product_name from t_order t left join t_order_products tp "
				+ " on t.id=tp.order_id " + " left join t_product p " + " on tp.product_id=p.id "
				+ " where order_source=1 and order_status in('3','4','5','11') " + " and p.category_id not like '03%' "
				+ " group by product_name " + " limit 10 ");
	}

	
	public boolean save(String sourceTable, PaySourceTypes sourceType, XPathParser wxResult,String shopType) {
		XPathWrapper wrap = new XPathWrapper(wxResult);
		//根据订单号查找是否已经添加过来
		TPayLog findResult=dao.findFirst("select * from t_pay_log where out_trade_no=?",wrap.get("out_trade_no"));
		if(findResult==null){
			this.set("shop_type", shopType);
			this.set("source_table", sourceTable);
			this.set("source_type", sourceType.getStringValue());
			this.set("openid", wrap.get("openid"));
			this.set("transaction_id", wrap.get("transaction_id"));
			this.set("out_trade_no", wrap.get("out_trade_no"));
			this.set("trade_type", wrap.get("trade_type"));
			this.set("total_fee", wrap.get("total_fee"));
			this.set("time_end", wrap.get("time_end"));
			this.set("is_subscribe", wrap.get("is_subscribe"));
			this.set("fee_type", wrap.get("fee_type"));
			this.set("cash_fee", wrap.get("cash_fee"));
			this.set("bank_type", wrap.get("bank_type"));
			return this.save();
		}else{
			return false;
		}
	}

	public boolean save(String sourceTable, PaySourceTypes sourceType, XPathParser wxResult, int give,String shopType) {
		this.set("give_fee", give);
		return this.save(sourceTable, sourceType, wxResult,shopType);
	}
	//更新日志中充值赠送记录
	public void update(String outTradeNo,int give){
		this.set("give_fee", give);
		Db.update("update t_pay_log set give_fee=? where out_trade_no=?",give,outTradeNo);
	}

	public boolean balancePaySaveLog(Object openid, PaySourceTypes sourceType, int fee, Object orderNo,String shopType) {
		this.set("shop_type",shopType);
		this.set("source_table", "t_user");
		this.set("source_type", sourceType.getStringValue());
		this.set("openid", openid);
		this.set("out_trade_no", orderNo);
		this.set("total_fee", fee);
		this.set("time_end", WeChatUtil.getCurrTime("yyyyMMddHHmmss"));
		return this.save();
	}
	
	public List<Record> findXgTPayLogByUserId(Object openId, PaySourceTypes type) {
		return Db.find(
				"select *,DATE_FORMAT( time_end, '%Y-%m-%d %H:%i:%s') as recharge_time from t_pay_log where shop_type=1 and source_table = 't_user' and openId = ? and source_type = ? and openid is not null",
				openId, type.getStringValue());
	}
}
