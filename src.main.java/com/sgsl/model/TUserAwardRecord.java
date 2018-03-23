package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 
 * @author Tianwei
 *	用户抽奖领奖记录
 */
public class TUserAwardRecord extends Model<TUserAwardRecord>{
	private static final long serialVersionUID = 1L;
	
	public static final TUserAwardRecord dao = new TUserAwardRecord();
	
	/**
	 * 我活动的抽奖机会
	 * @param userId
	 * @param activityId
	 * @return
	 */
	public long myHaveAwardChance(int userId,String activityId){
		Record result= Db.findFirst("select count(*) as c from t_user_award_record  where user_id=? and is_valid='1' and activity_id=?",
				userId,activityId);
		
		return result.getLong("c");
	}
	/**
	 * 查找用户一次有效的抽奖机会
	 * @param userId
	 * @param activityId
	 * @return
	 */
	public TUserAwardRecord findOneValidUserAwardRecord(int userId,String activityId){
		return dao.findFirst("select * from t_user_award_record where user_id=? and is_valid='1' and activity_id=?",
				userId,activityId);
	}
	/**
	 * 查询用户所有此次活动的奖品
	 * @param userId
	 * @param activityId
	 * @return
	 */
	public List<Record> findCurrentUserAwardRecord(int userId,String activityId){
		return Db.find("select t1.*,t2.award_name,t2.coin_count,t2.coupon_count,"
				+ " t3.save_string from t_user_award_record t1 "
				+ " left join m_award t2 on t2.id=t1.award_id "
				+ " left join t_image t3 on t2.img_id=t3.id where t1.is_valid='0' and t2.award_type!='4' and t1.user_id=? and t1.activity_id=? order by t1.award_time desc",userId,activityId);
	}
	
}
