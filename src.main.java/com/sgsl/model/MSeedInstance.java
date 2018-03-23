package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 产生的种子
 * @author yijun
 *
 */
public class MSeedInstance extends Model<MSeedInstance> {
	private static final long serialVersionUID = 1L;


    public static final MSeedInstance dao = new MSeedInstance();
    
    /**
     * 我的种子
     * @return
     */
    public List<Record> getMySeedInstance(int userId){
    	List<Record> result=Db.find("select t.seed_name,"
    			+ "(select count(*) from m_seed_instance where t.id=seed_type_id and `status`=1 and user_id=?)as total_instance,"
    			+ "m.save_string from m_seed_type t "
    			+ "left join t_image m on m.id=t.image_id ORDER BY t.order_id asc",userId);
    	return result;
    }
    /**
     * 种子抵扣
     * @param exchangeTime 抵扣时间
     * @param exchangeType 兑换类型T套餐D单品
     * @param exchangeId 抵扣的套餐或者商品编号
     * @param seedTypeId 种子类型编号
     * @param userId 用户
     * @param limit 当前类型种子抵扣数量
     */
    public void seedDeduction(String exchangeTime,String exchangeType,int exchangeId,int seedTypeId,int userId,int limit){
    	
    	Db.update("update m_seed_instance s set status=2,exchange_time=?,exchange_type=?,exchange_id=? where status=1 and s.seed_type_id=? and s.user_id=? limit ?",
    									exchangeTime,exchangeType,exchangeId,seedTypeId,userId,limit);
    	
    }
}
