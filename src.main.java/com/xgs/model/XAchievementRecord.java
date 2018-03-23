package com.xgs.model;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.utils.DateFormatUtil;

public class XAchievementRecord extends Model<XAchievementRecord> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final XAchievementRecord dao = new XAchievementRecord();

	/**
	 * 收支明细 最多90天
	 * 
	 * @param inout_type（1收入，2支出）
	 * @return
	 */
	public Page<XAchievementRecord> findAchievementRecord(int pageNumber, int pageSize, int master_id,int inout_type) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// 设置日期格式
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(new Date());
		calendar.add(calendar.DATE, -90);// 90天前
		String time = df.format(calendar.getTime());
		// inout_type（1收入，2支出）
		String type = inout_type == 1 ? " and type in(1,2) " : " and type in(3,4) ";
		String select = "select id,master_id,user_id,order_id,money,type,"
				      + "time ,if(type=1 or type=2,'收入','支出') as inout_type ";
		String sqlExceptSelect = " from x_achievement_record where master_id = "+master_id + type + " and time >='"+time+"' order by time desc";
		return dao.paginate(pageNumber, pageSize, select, sqlExceptSelect);
	}
	
	/**
	 * 添加收支明细
	 * @param order 订单数据
	 * @param type  1.收入类型:订单分成;2.收入类型:分销商红利;3.支出类型:红利结算;4.支出类型:客户退款'
	 * @return
	 */
	public boolean addXAchievementRecord(Record order,int type){
		Record record = Db.findFirst("select * from x_bonus_percentage");
		XAchievementRecord achievementRecord = new XAchievementRecord();
		achievementRecord.set("master_id", order.getInt("master_id"));
		achievementRecord.set("user_id", order.getInt("order_user"));
		achievementRecord.set("order_id", order.get("order_id"));
		achievementRecord.set("money", order.getInt("need_pay")*record.getInt("sale_percentage")/100.0);
		achievementRecord.set("type", type);
		achievementRecord.set("time", DateFormatUtil.format1(new Date()));
		return achievementRecord.save();
	}
	
}
