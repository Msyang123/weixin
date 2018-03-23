package com.xgs.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;

public class XApplyMoney extends Model<XApplyMoney> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final XApplyMoney dao = new XApplyMoney();

	/**
	 * 
	 * @param matser_id
	 * @param type 0申请中，1已成功，2已失效
	 * @return
	 */
	public Record findMoney(int master_id, int type) {
		return Db.findFirst("select ifnull(sum(apply_money),0) total from x_apply_money where master_id = ? and status = ?",
				master_id, type);
	}
	
	public void addApplyMoneyRecord(Record record){
		Db.save("x_apply_money", record);
	}
	
	/**
	 * 本月是否已经申请
	 * @param master_id
	 * @return
	 */
	public XApplyMoney findXApplyMoneyByThisMonth(int master_id){
		
		return dao.findFirst("select * from x_apply_money where apply_time<=now() and DATE_FORMAT(DATE_ADD(curdate(),interval -day(curdate())+1 day),'%Y-%m-%d 00:00:00')<apply_time and master_id = ?",master_id);
	}
	
	/**
	 * 本月成功提现记录
	 */
	public XApplyMoney findApplyRecordThisMonth(int master_id){
		return dao.findFirst("select * from x_apply_money where master_id=? and DATE_FORMAT(DATE_ADD(curdate(),interval -day(curdate())+1 day),'%Y-%m-%d 00:00:00')<apply_time",master_id);
	}
	
	/**
	 * 薪资结算处理查询
	 * @param page
	 * @param pageSize
	 * @return
	 */
	public Page<Record> findNotReal(int page,int pageSize,int status,String masterName
			,String createDateBegin, String createDateEnd){
		String sql = "select a.id,m.master_name ,a.apply_money,a.apply_time,a.status ";
		String where = "from x_fruit_master m ";
			   where +="left join x_apply_money a on m.id=a.master_id where a.apply_money is not null ";
			   if(status==0){
				   where +="and a.status=0 ";
			   }else if(status==-1){
				   where +="and a.status in(1,2) ";
			   }else{
				   where +="and a.status="+status+" ";
			   }
			   if(StringUtil.isNotNull(masterName)){
				   where +="and m.master_name like '%"+masterName+"%'";
			   }
			   if(StringUtil.isNotNull(createDateBegin)&&StringUtil.isNotNull(createDateEnd)){
				   where +="and a.apply_time between '"+createDateBegin+"' and '"+createDateEnd+"' ";
			   }
			   where +="order by a.apply_time desc";
		return Db.paginate(page, pageSize, sql, where);
	}

}
