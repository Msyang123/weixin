package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 
 * @author TianWei
 *		活动奖品表
 */
public class MHdUserAward extends Model<MHdUserAward>{
	
	private static final long serialVersionUID = 1L;

    public static final MHdUserAward dao = new MHdUserAward();
    
    /*
     * 根据活动类型查找所有的相关奖品信息，并根据奖品顺序排序
     */
    public List<Record> findMAwardsByActivityId(String activityId){
    	return Db.find("select t1.*,t2.save_string from m_award  t1 left join t_image t2 on t1.img_id=t2.id where activity_id = ? order by award_sequence", activityId);
    }
    
    /**
     * 抽奖码是否有效
     * @return
     */
    public Record isLotteryCode(int userId){
    	Record re=Db.findFirst("select t1.id from m_hd_user_award t "
    			+ "left join m_hd_param t1 on t.order_id=t1.order_id "
    			+ "where t1.yxbz='Y' and t.user_id=? ",userId);
    	return re;
    }
    
}
