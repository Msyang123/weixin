package com.sgsl.model;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.util.StringUtil;
import com.sgsl.util.DateUtil;
import com.sgsl.util.RandomUtil;
import com.sgsl.utils.DateFormatUtil;

public class TCouponReal extends Model<TCouponReal> {

	private static final long serialVersionUID = 1L;

	public static final TCouponReal dao = new TCouponReal();

	/**
	 * 查找返券促销类型的活动的符合小于等于订单支付金额的优惠券
	 */
	public TCouponReal findGiveTCouponByActivityId(int minPayGive) {
		// 判定活动有效
		return dao.findFirst(
				"select * from t_coupon_real where activity_id in (select id from m_activity where activity_type=6 and yxbz='Y') and status='0' and min_cost<=? order by coupon_val desc limit 1",
				minPayGive);
	}

	/**
	 * 获取一张优惠券
	 * 
	 * @param title
	 * @param activityId
	 * @return
	 */
	public Map<String, String> getOneCoupon(String coupon_category_id, String activityId, int user_id) {
		Map<String, String> resultMap = new HashMap<String, String>();

		// 查看领取次数
		Record coupon_category = Db.findById("t_coupon_category", coupon_category_id);
		//用户领取次数限制		
		int user_gain_times = Integer.parseInt(coupon_category.get("user_gain_times"));
		
		// 用户领取的该种优惠券数量
		long count = Db.findFirst(
				"select count(*) as count from t_coupon_real where coupon_category_id = ? "
						+ "and id in (select coupon_id from t_user_coupon where user_id = ? and activity_id=?)",
				coupon_category_id, user_id, activityId).getLong("count");

		String coupon_total = coupon_category.get("coupon_total");
		if ("/".equals(coupon_total)) {// 优惠券数量无限
			if (count < user_gain_times) {// 已领数量小于限领数量，发券
				createOneCouponTorelease(coupon_category_id,coupon_category.getInt("coupon_scale_id"),activityId, user_id);
				resultMap.put("errcode", "0");
				resultMap.put("errmsg", "恭喜领取成功");
			} else {// 领取次数达到限制，返回
				resultMap.put("errcode", "2");
				resultMap.put("errmsg", "您已经领取过该优惠券了");
			}
			
		} else {
			//剩余未领取的优惠券数量
			long remain_coupon_total = Db
					.findFirst("select count(*) as count from t_coupon_real where status=0 and coupon_category_id = ?",
							coupon_category_id)
					.getLong("count");
			if(remain_coupon_total==0){//已领完
				resultMap.put("errcode", "1");
				resultMap.put("errmsg", "该优惠券已经没有了");
			}else{//未领完，拿一张，然后发给用户
				if (count < user_gain_times) {// 已领数量小于限领数量，发券
					Record user_coupon_record = new Record();
					Record oneRealCoupon = Db.findFirst("select * from t_coupon_real where status=0 and coupon_category_id = ?",coupon_category_id);
					//发给用户
					user_coupon_record.set("user_id", user_id);
					user_coupon_record.set("coupon_id", oneRealCoupon.getInt("id"));
					user_coupon_record.set("is_expire", "0");
					user_coupon_record.set("title", oneRealCoupon.get("coupon_desc"));
					user_coupon_record.set("activity_id", activityId);
					user_coupon_record.set("create_time", DateFormatUtil.format1(new Date()));
					Db.save("t_user_coupon", user_coupon_record);
					//更改优惠券被领取
					oneRealCoupon.set("status", 1);
					Db.update("t_coupon_real", oneRealCoupon);
					
					resultMap.put("errcode", "0");
					resultMap.put("errmsg", "领取成功");
				}else{
					resultMap.put("errcode", "2");
					resultMap.put("errmsg", "您已经领取过该优惠券了");
				}
				
			}
			
		}
		return resultMap;
	}

	private void createOneCouponTorelease(String category_id, int coupon_scale_id,String activityId,int user_id) {
		TCouponCategory couponCategory = TCouponCategory.dao.findById(category_id);
		// 用来保存的优惠券
		TCouponReal couponReal = new TCouponReal();
		couponReal.set("coupon_category_id", category_id);
		couponReal.set("coupon_scale_id", coupon_scale_id);
		couponReal.set("give_type", 1);// 手动发券
		couponReal.set("activity_id",activityId);
		couponReal.set("coupon_desc", couponCategory.get("coupon_desc"));
		couponReal.set("user_gain_times", couponCategory.get("user_gain_times"));
		couponReal.set("coupon_val", couponCategory.get("coupon_val"));
		couponReal.set("min_cost", couponCategory.get("min_cost"));
		couponReal.set("start_time", couponCategory.get("yxq_q"));
		couponReal.set("end_time", couponCategory.get("yxq_z"));
		couponReal.set("status", 1);
		couponReal.set("yxbz", "Y");
		couponReal.save();
		// 用户优惠券记录
		TUserCoupon userCoupon = new TUserCoupon();
		userCoupon.set("is_expire", 0);
		userCoupon.set("title", couponCategory.get("coupon_desc"));
		userCoupon.set("activity_id", activityId);
		userCoupon.set("create_time", DateFormatUtil.format1(new Date()));
		userCoupon.set("used_time", "");
		userCoupon.set("user_id", user_id);
		userCoupon.set("coupon_id", couponReal.get("id"));
		userCoupon.save();
	}

	/**
	 * 是否是单品优惠券
	 */
	public boolean isSingleCoupon(int coupon_id){
		Record record = Db.findFirst("select * from t_coupon_real cr LEFT JOIN t_coupon_scale cs on cr.coupon_scale_id = cs.id where cs.is_single = 'Y' and cr.id=?",coupon_id);
		if(record==null){
			return false;
		}else{
			return true;
		}
	}
	
	/**
	 * 使用优惠券码兑换优惠券
	 */
	public JSONObject exchangeCouponByCode(String code,String userid,String orderMoney){
		JSONObject result = new JSONObject();
		
		if(StringUtil.isNull(code.trim())){
			result.put("success",false);
			result.put("msg", "请输入兑换码");
			return result;
		}
		
		if(StringUtil.isNull(userid)){
			result.put("success",false);
			result.put("msg", "请先登录授权");
			return result;
		}
		
		//根据兑换码去查找到真实优惠券记录
		TCouponReal couponReal=TCouponReal.dao.findFirst("select * from t_coupon_real where coupon_code=?",code);
		TCouponCategory category=TCouponCategory.dao.findById(couponReal.getInt("coupon_category_id"));
		if(couponReal==null){
			result.put("success",false);
			result.put("msg", "兑换码不存在");
			return result;
		}else{
			List<TCouponReal> isReceiveCode=dao.isReceiveCode(userid,couponReal.getInt("activity_id"));
			if(isReceiveCode.size()>=Integer.parseInt(category.getStr("user_gain_times"))){
				result.put("success",false);
				result.put("msg", "您已超过限领的次数！");
				return result;
			}
		}
	
		//更新优惠券的真实起止时间--用户兑换时间/用户兑换时间+有效期
		Date now=new Date();
		int yxq=0;
		
		//根据category_id去查有效期
	    if(category!=null){
	    	yxq=Integer.parseInt(category.getStr("yxq"));
	    }
	    
	    String validateTime=DateFormatUtil.format1(DateUtil.dayAdd(yxq));
	    	    
	    //如果已经过了兑换码的时间
	    if(StringUtil.isNotNull(couponReal.getStr("end_time"))&&
    		now.after(DateUtil.convertString2Date(couponReal.getStr("end_time")))){
  			result.put("success",false);
  			result.put("msg", "兑换码已过期");
  			return result;
	    }	
	  		
		//判断是否重复兑换
		if(StringUtil.isNotNull(couponReal.getStr("status"))){
			//根据优惠券id去用户表里查询，如果有记录，则兑换码已领取或者已使用
			TUserCoupon usercoupon=TUserCoupon.dao.findUserCouponByCouponId(couponReal.getInt("id"));
			if(couponReal.getStr("status").equals("1")||couponReal.getStr("status").equals("2")||usercoupon!=null){
				result.put("success",false);
				result.put("msg", "兑换码已使用,请勿重复兑换");
				return result;
			}else{
				//如果期间终止合作即category的状态为N，则未兑换的优惠券码全部失效
				if(category!=null&&category.getStr("yxbz").equals("N")){
					result.put("success",false);
					result.put("msg", "兑换码失效");
					return result;
				}
				
				//找到后去修改优惠券的领取状态
				couponReal.set("status", 1);
				couponReal.set("start_time", DateFormatUtil.format1(now));
				couponReal.set("end_time", validateTime);
				couponReal.update();	
						   
			    //返回优惠券部分信息用于前端显示
				result.put("coupon_val",couponReal.getInt("coupon_val"));
				result.put("coupon_desc", couponReal.getStr("coupon_desc"));
				result.put("start_time", DateFormatUtil.format1(now));
				result.put("end_time", validateTime);
				result.put("coupon_id", couponReal.getInt("id")); 
			}
		}
				
	    //TODO:如果订单金额小于兑换完的优惠券门槛金额，则需要设置优惠券的状态置灰  优惠券页兑换的无订单金额
	    if(StringUtil.isNotNull(orderMoney)){
		    if(Integer.parseInt(orderMoney)<couponReal.getInt("min_cost")){
				result.put("isEnable", false);
		    }else{
		    	result.put("isEnable", true);
		    }
	    }
		//TODO:还需要使用锁的概念，因为兑换可能存在并发
		//并插入一条t_user_coupon记录
	    Record userCoupon=new Record();	     		
	    userCoupon.set("user_id",Integer.parseInt(userid));
	    userCoupon.set("coupon_id", couponReal.getInt("id"));
	    userCoupon.set("is_expire","0");
	    userCoupon.set("title",couponReal.getStr("coupon_desc"));
	    userCoupon.set("activity_id", couponReal.getInt("activity_id"));
	    userCoupon.set("create_time", DateFormatUtil.format1(now));
	    userCoupon.set("validity_time",validateTime);
	    Db.save("t_user_coupon", userCoupon);
	    
	    result.put("success",true);
		result.put("msg", "兑换成功");
		return result;
	}
	
	/**
	 * 生成真实优惠券--还需要随机生成兑换码
	 */
	public static void createRealCoupon(Record record) {
		String coupon_total = record.get("coupon_total");
		if (!coupon_total.equals("/")||!coupon_total.equals("0")) {//排除优惠券总数填0的概率
			Record couponRealRecord = new Record();
			couponRealRecord.set("coupon_category_id", record.get("id"));
			couponRealRecord.set("coupon_scale_id", record.get("coupon_scale_id"));
			couponRealRecord.set("activity_id", record.get("activity_id"));
			couponRealRecord.set("coupon_desc", record.get("coupon_desc"));
			couponRealRecord.set("coupon_val", record.get("coupon_val"));
			couponRealRecord.set("min_cost", record.get("min_cost"));
			couponRealRecord.set("start_time", record.get("yxq_q"));
			couponRealRecord.set("end_time", record.get("yxq_z"));
			couponRealRecord.set("status", "0");
			couponRealRecord.set("yxbz", "Y");
			//标识优惠券来源4-优惠券码兑换
			couponRealRecord.set("give_type", "4");			
			for (int i = 0; i < Integer.parseInt(coupon_total); i++) {
				//TODO: 随机生成唯一的相应数量的编码设置给record
				couponRealRecord.set("coupon_code",generateCode());
				Db.save("t_coupon_real", couponRealRecord);
				couponRealRecord.remove("id");
			}
			System.out.println("优惠券生成完毕");
		} else {
			System.out.println("该种类优惠券不限量，固不生成");
		}
	}
	
	private static String generateCode(){
		String code=RandomUtil.ranDomNo(6);
		//数据库存在记录
		if(TCouponReal.dao.findFirst("select * from t_coupon_real where coupon_code=?",code)!=null){
			return generateCode();
		}else{
			return code;
		}
	}
	
	/**
	 * 是否产生业务数据
	 * @return
	 */
	public Long isCouponRealData(Object id){
		return Db.findFirst("select count(*) as c from m_activity m "
				+ "left join t_coupon_category c on m.id=c.activity_id "
				+ "left join t_coupon_real r on m.id=r.activity_id "
				+ "where r.status=1 and m.id=? ", id).getLong("c");
	}
	
	/**
	 * 当前用户当前日期是否有领取过兑换码优惠券
	 * @param userId
	 * @return
	 */
	public List<TCouponReal> isReceiveCode(String userId,int activity_id){
		String sql="select cc.* from t_coupon_real r "
				+ "LEFT JOIN t_coupon_category cc on r.coupon_category_id=cc.id "
				+ "left join t_user_coupon c on r.id=c.coupon_id "
				+ "where c.user_id=? and cc.give_type=4 and r.activity_id=? ";
		return dao.find(sql,userId,activity_id);
	}
}
