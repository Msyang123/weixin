package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Model;

/**
 * 
 * @author yj
 * 活动门店表
 */
public class MActivityStore extends Model<MActivityStore>{
	
	private static final long serialVersionUID = 1L;

    public static final MActivityStore dao = new MActivityStore();
    
    /*
     * 根据活动类型查找所有的相关奖品信息，并根据奖品顺序排序
     */
    public List<MActivityStore> findMActivityStoresByActivityId(String activityId){
    	return dao.find("select * from m_activity_store where activity_id = ?", activityId);
    }
    
}
