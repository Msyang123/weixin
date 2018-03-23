package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.util.StringUtil;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.util.XPathParser;
import com.sgsl.wechat.util.XPathWrapper;

public class TPayLog extends Model<TPayLog> {
	private static final long serialVersionUID = 2402889921632720158L;

	public enum PaySourceTypes {
		ORDER("order"), PRESENT("present"), BALANCE("balance"), RECHARGE("recharge"),EXCHANGE("exchange");
		private String stringValue;

		private PaySourceTypes(String stringValue) {
			this.stringValue = stringValue;
		}

		public String getStringValue() {
			return this.stringValue;
		}
	}
	public static final TPayLog dao = new TPayLog();
	public boolean save(String sourceTable, PaySourceTypes sourceType, XPathParser wxResult) {
		XPathWrapper wrap = new XPathWrapper(wxResult);
		//根据订单号查找是否已经添加过来
		TPayLog findResult=dao.findFirst("select * from t_pay_log where out_trade_no=?",wrap.get("out_trade_no"));
		if(findResult==null){
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

	public boolean save(String sourceTable, PaySourceTypes sourceType, XPathParser wxResult, int give) {
		this.set("give_fee", give);
		return this.save(sourceTable, sourceType, wxResult);
	}
	//更新日志中充值赠送记录
	public void update(String outTradeNo,int give){
		this.set("give_fee", give);
		Db.update("update t_pay_log set give_fee=? where out_trade_no=?",give,outTradeNo);
	}

	public boolean balancePaySaveLog(Object openid, PaySourceTypes sourceType, int fee, Object orderNo) {
		this.set("source_table", "t_user");
		this.set("source_type", sourceType.getStringValue());
		this.set("openid", openid);
		this.set("out_trade_no", orderNo);
		this.set("total_fee", fee);
		this.set("time_end", WeChatUtil.getCurrTime("yyyyMMddHHmmss"));
		return this.save();
	}

	public List<Record> findTPayLogByUserId(Object openId, PaySourceTypes type) {
		return Db.find(
				"select *,DATE_FORMAT( time_end, '%Y-%m-%d %h:%i:%s') as recharge_time from t_pay_log where source_table = 't_user' and openId = ? and source_type = ? and openid is not null and shop_type not in(1)",
				openId, type.getStringValue());
	}
	/**
	 * 消费统计
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public List<Record> payStat(String startTime,String endTime){
		if(StringUtil.isNotNull(startTime)&&StringUtil.isNotNull(endTime)){
			return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where date_format(time_end,'%Y-%m-%d %H:%i:%s') between ? and ? group by x.source_type ",
					startTime,endTime);
		}else{
			if(StringUtil.isNotNull(startTime)){
				return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where ?<date_format(time_end,'%Y-%m-%d %H:%i:%s') group by x.source_type ",
						startTime);
			}
			if(StringUtil.isNotNull(endTime)){
				return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x where date_format(time_end,'%Y-%m-%d %H:%i:%s')<? group by x.source_type ",
						endTime);
			}
		}
		return Db.find("select sum(total_fee)/100 total_fee,sum(give_fee)/100 give_fee,source_type from t_pay_log x group by x.source_type ");
	}
	/**
	 * 根据销售的时间段来统计
	 * @return
	 */
	public List<Record> payStatByTime(String time,boolean isAvg){
		if(isAvg){
			return Db.find("select date_format(time_end,'%H') as h,sum(total_fee)/(100*datediff(now(),'2017-01-01')) as total_fee "+
			 " from t_pay_log group by date_format(time_end,'%H')");
		}else{
			return Db.find("select date_format(time_end,'%H') as h,sum(total_fee)/100 as total_fee "+
			 " from t_pay_log where date_format(time_end,'%Y-%m-%d') like '"+time+"%' group by date_format(time_end,'%H')");
		}
		
	}
	/**
	 * 男女消费比例
	 * @return
	 */
	public List<Record> payStatBySex(){
		return Db.find("select sex,count(sex) as totalSex from t_pay_log p left join t_user u on p.openid=u.open_id group by sex");
	}
	/**
	 * 根据订单编号查找日志
	 * @param orderId
	 * @return
	 */
	public TPayLog findTPayLogByOrderId(String  orderId) {
		return dao.findFirst(
				"select * from t_pay_log where out_trade_no = ? ",orderId);
	}
	/**
	 * 后台充值查询
	 * @param presentStatus
	 * @param presentDateBegin
	 * @param presentDateEnd
	 * @param pageSize
	 * @param page
	 * @param sidx
	 * @param sord
	 * @return
	 */
	public Page<Record> payLogList(String  payLogDateBegin, String payLogDateEnd,
			int pageSize,
			int page,
			String sidx,
			String sord){
		Page<Record> pageInfo=null;
		//全部
		if(StringUtil.isNull(sidx)){
			pageInfo= Db.paginate(page,pageSize,
			"select t.*,u.nickname,u.phone_num ",
			" from t_pay_log t left join t_user u on t.openid=u.open_id "+
			" where  t.source_type='recharge' and t.time_end between '"+payLogDateBegin+"' and '"+payLogDateEnd+"'  order by t.time_end desc");
		}else{
			pageInfo= Db.paginate(page,pageSize,
			"select t.*,u.nickname ",
				" from t_pay_log t left join t_user u on t.openid=u.open_id  "+
				" where t.source_type='recharge' and t.time_end between '"+payLogDateBegin+"' and '"+payLogDateEnd+"'  order by "+sidx+" "+sord);
		}
		return pageInfo;
	}
}
