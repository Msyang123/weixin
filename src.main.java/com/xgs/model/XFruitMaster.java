package com.xgs.model;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.config.AppConst;
import com.sgsl.util.StringUtil;

/**
 * 
 * @author TW 鲜果师成员
 */
public class XFruitMaster extends Model<XFruitMaster> {

	private static final long serialVersionUID = 1L;
	public static final XFruitMaster dao = new XFruitMaster();
	
	/**
	 * 通过session user_id找到对应的鲜果师信息
	 * @param user_id
	 * @return
	 */
	public XFruitMaster findMasterByUserId(int user_id){
		return dao.findFirst("select * from x_fruit_master where user_id = ?",user_id);
	}
	/**
	 * 通过session user_id找到对应的鲜果师信息
	 * @param user_id
	 * @return
	 */
	public XFruitMaster findSuccessMasterByUserId(int user_id){
		return dao.findFirst("select * from x_fruit_master where master_status='3' and user_id = ?",user_id);
	}
	/**
	 * 鲜果师详情
	 */
	public XFruitMaster findXFruitMasterById(int master_id) {
		return dao.findById(master_id);
	}

	/**
	 * 鲜果师今日交易单及单日总额
	 */
	public Record findOneDayStatisticByMasterId(int master_id) {
		Record master_turnover = Db.findFirst(
				"select count(*) as order_numbers,ifnull(sum(o.need_pay),0) as order_total from t_order o where o.order_status in(3,4,5,8,9,10,11,12) and master_id = ? and order_source='1' "
						+ "and (SELECT CAST((CAST(SYSDATE()AS DATE) - INTERVAL 0 DAY)AS DATETIME))<=createtime "
						+ "and createtime< (SELECT CAST((CAST(SYSDATE()AS DATE) - INTERVAL -1 DAY)AS DATETIME)AS DATETIME)",
				master_id);
		return master_turnover;
	}

	/**
	 * 鲜果师所有交易总额
	 */
	public Record findTotalByMasterId(int master_id) {
		Record total = Db.findFirst(
				"select ifnull(sum(o.need_pay),0) as total from t_order o where o.order_status in(3,4,5,8,9,10,11,12) and master_id = ? and order_source = '1'",
				master_id);
		return total;
	}

	/**
	 * 鲜果师当月销售额
	 */
	public Record findMasterMonthTotal(int master_id) {
		return Db.findFirst(
				"select ifnull(sum(o.need_pay),0) as total from t_order o "
						+ " where master_id = ? and order_status in(3,4,5,8,9,10,11,12) and order_source='1' and DATE_ADD(curdate(),interval -day(curdate())+1 day)<o.pay_time and o.pay_time<now()",
				master_id);

	}

	/**
	 * 鲜果师下级列表
	 */
	public List<XFruitMaster> findSubMasterListById(int master_id) {
		/*return dao.find(
				"select fm.*,u.phone_num from x_fruit_master fm left join  t_user u  on fm.user_id = u.id where fm.master_status=3 and fm.user_id in (SELECT user_id from x_master_user where master_id = ?)",
				master_id);*/
		return dao.find(
				"select fm.*,u.phone_num from x_fruit_master fm left join  t_user u  on fm.user_id = u.id where fm.master_status=3 and fm.master_recommend = ?",
				master_id);
	}

	/**
	 * 单个下级鲜果师信息
	 */
	public XFruitMaster findSubMasterById(int master_id) {
		return dao.findFirst(
				"select fm.*,u.phone_num from x_fruit_master fm left join  t_user u  on fm.user_id = u.id where fm.id=?",
				master_id);
	/*	return dao.findFirst(
				"select fm.*,u.phone_num from x_fruit_master fm left join  t_user u  on fm.user_id = u.id where fm.user_id in (SELECT user_id from x_master_user where master_id = ?)",
				master_id);*/
	}

	 public XFruitMaster findXFruitMaster(int freshId){
		   return dao.findFirst("select * from x_fruit_master where master_status=3 and id = ?",freshId);
	   }
	   
	   public List<Record> findMasterStar(){
		   return Db.find("select  * from x_fruit_master  where master_status=3 and is_fresh_star=1 limit 10 ");
	   }
	   
	   /**
	    * 查询普通用户是否是在鲜果师平台有注册数据(需要是成功的鲜果师)
	    * @param userId
	    * @return
	    */
	   public XFruitMaster findIsFruitMaster(int userId){
		   return dao.findFirst("SELECT t.* ,x.id as master_id from t_user t "
				   				+"LEFT JOIN x_fruit_master x on t.id=x.user_id where x.master_status=3 and x.id is not null and t.id=?", userId);
	   }

	   
	   /**
	    * 鲜果师模糊查询
	    * @param content
	    * @return
	    */
	   public Page<Record> findMasterAndContent(int page,int pageSize, String content){
		   String sql="SELECT * ";
		   String where ="from x_fruit_master ";
		   		  where +="where master_status=3 and (master_name like '%"+content+"%' or master_nc like '%"+content+"%')";
		   return Db.paginate(page, pageSize, sql, where);
	   }

	/**
	 * 鲜果师信息修改（没有限制修改的字段个数）
	 * 
	 * @param map
	 * @param master_id
	 * @return 
	 */
	public int updateMaster(Map<String, Object> map, int master_id,String tableName) {
		String updateColumn = "";
		for (String key : map.keySet()) {//拼接的修改字段及其修改值
			System.out.println(key+"======="+map.get(key));
			updateColumn = updateColumn + key + " = '" + map.get(key) + "',";// 拼接key1=value1,key2=value2...这种格式
		}
//		Iterator<Entry<String, Object>> it = map.entrySet().iterator();
//		while (it.hasNext()) {
//	          Entry<String, Object> entry = it.next();
//	          updateColumn = updateColumn + entry.getKey() + " = '" +entry.getValue() + "',";// 拼接key1=value1,key2=value2...这种格式
//	          System.out.println(updateColumn);
//	    }
		updateColumn = updateColumn.substring(0, updateColumn.length() - 1);// 去掉尾部的逗号
		int result = Db.update("update "+tableName+" set " + updateColumn + " where id = " + master_id);
		return result;
	}
	
	
	/**
	 * 查询鲜果师列表
	 * @param pageSize
	 * @param page
	 * @return
	 */
	public Page<Record> findMasterList(int pageSize, int page){
		String sql = " select * ";
		String where = " from x_fruit_master where master_status in(3) ";
		System.out.println("==============");
		return Db.paginate(page, pageSize, sql, where);
	}
	/**
	 * 鲜果师审核
	 * @param pageSize
	 * @param page
	 * @param master_status
	 * @param masterName
	 * @param createDateBegin
	 * @param createDateEnd
	 * @return
	 */
	public Page<Record> findCherkList(int pageSize, int page,int master_status
			,String masterName,String createDateBegin,String createDateEnd){
		String sql = "select m.id,m.create_time,m.master_name,a.mobile,a.idcard ";
		String where = "from x_fruit_master m ";
			   where +="left join x_fruit_apply a on m.id=a.master_id where m.master_name is not null ";
			   if(master_status>-1){
				   where +="and m.master_status="+master_status+" ";
			   }
			   if(StringUtil.isNotNull(masterName)){
				   where +="and m.master_name='"+masterName+"' ";
			   }
			   if(StringUtil.isNotNull(createDateBegin)&&StringUtil.isNotNull(createDateEnd)){
				   where +="and m.create_time between '"+createDateBegin+"' and '"+createDateEnd+"' ";
			   }
			   where += "order by m.id desc";
		return Db.paginate(page, pageSize, sql, where);
	}
	
	public List<Record> findmasterDetailById(int id){
		return Db.find("select m.id,m.master_name,m.master_nc,a.idcard,a.mobile,a.idcard_face,a.idcard_opposite,a.id as apply_id,a.qualification,m.master_recommend,m.head_image,m.master_image,m.description "
				+ "from x_fruit_master m left join x_fruit_apply a on m.id=a.master_id "
				+ "where m.id=?", id);
	}
	
	/**
	 * 鲜果师列表（查出上级鲜果师）
	 */
	public Page<Record> findMasterAndUpMaster(int pageSize, int page,String createDateBegin,String createDateEnd,
			int status,String masterName,String is_fresh_star){
		String sql="select fm.id,a.mobile,fm.master_name,fm.create_time,fm.head_image,fm.master_status, "
				+ "IFNULL((select master_name from x_fruit_master fm1 where fm1.id=fm.master_recommend),'无上级鲜果师')'上级鲜果师' ";
		String where="from x_fruit_master fm ";
			   where+="LEFT JOIN x_fruit_apply a on fm.id=a.master_id  ";
			   if(status==-1){
				   where+="where fm.master_status in(3,4) ";
			   }else if(status==3){
				   where+="where fm.master_status in(3) ";
			   }else if(status==4){
				   where+="where fm.master_status in(4) ";
			   }
			   if(StringUtil.isNotNull(createDateBegin)&&StringUtil.isNotNull(createDateEnd)){
				   where +="and fm.create_time between '"+createDateBegin+"' and '"+createDateEnd+"' ";
			   }
			   if(StringUtil.isNotNull(masterName)){
				   where +="and fm.master_name like '%"+masterName+"%' ";
			   }
			   if(StringUtil.isNotNull(is_fresh_star)){
				   if(is_fresh_star.equals("1")){
					   where +="and fm.is_fresh_star=1 ";
				   }else{
					   where +="and fm.is_fresh_star=0 ";
				   }
			   }
			   where+="order by fm.create_time desc";
		return Db.paginate(page, pageSize, sql, where);
	}
	
	public Page<Record> findMasterDown(int pageSize, int page,String createDateBegin,String createDateEnd,
			int status,String masterName,int master_id){
		String sql="select m.master_name as '上级鲜果师',fm.master_name,fm.id,a.mobile,fm.create_time,fm.head_image,fm.master_status ";
		String where="from x_fruit_master m ";
			   where+="left join x_fruit_master fm on m.id=fm.master_recommend ";
			   where+="left join x_fruit_apply a on fm.id=a.master_id ";
			   where+="where fm.master_recommend="+master_id+" ";
			   if(StringUtil.isNotNull(createDateBegin)&&StringUtil.isNotNull(createDateEnd)){
				   where +="and fm.create_time between '"+createDateBegin+"' and '"+createDateEnd+"' ";
			   }
			   if(StringUtil.isNotNull(masterName)){
				   where +="and fm.master_name='"+masterName+"' ";
			   }
			   if(status>-1){
				   where +="and m.master_status="+status+" ";
			   }
			   where+="order by fm.create_time desc";
		return Db.paginate(page, pageSize, sql, where);
	}
	
	public Page<Record> findMasterUser(int pageSize, int page,String createDateBegin,String createDateEnd,
			String phoneNum,int master_id){
		String sql="select u.*,if(u.sex='1','男','女') as sexDisplay,if(u.status='0','不可用','正常') as statusDisplay,s.store_name  ";
		String where="from t_user u left join t_store s on u.store_id=s.id ";
			   where+="left join x_master_user um on um.user_id=u.id ";
			   where+="where um.master_id="+master_id+" ";
			   if(StringUtil.isNotNull(phoneNum)){
				   where+="and u.phone_num like '%"+phoneNum+"%' ";
			   }
			   if(StringUtil.isNotNull(createDateBegin)&&StringUtil.isNotNull(createDateEnd)){
				   where +="and u.regist_time between '"+createDateBegin+"' and '"+createDateEnd+"' ";
			   }
		return Db.paginate(page, pageSize, sql, where);
	}

}