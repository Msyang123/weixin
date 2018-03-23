package com.sgsl.model;


import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.DateUtil;

/**
 * 活动时间区间
 * @author yijun
 *
 */
public class MInterval extends Model<MInterval> {
	private static final long serialVersionUID = 1L;


    public static final MInterval dao = new MInterval();
    
    /**
     * 计算种子活动获取时间
     * @param activityId
     * @return
     */
    public Map<String,Integer> getLest10Min(int activityId){
    	Map<String,Integer> result=new HashMap<String,Integer>();
    	//活动区间内可以参加领取
    	MInterval interval=dao.findFirst("select * from  m_interval where activity_id=? and begin_time<date_format(now(),'%Y-%m-%d %H:%i:%s') and end_time>date_format(now(),'%Y-%m-%d %H:%i:%s') and status=1 ",activityId);
    	
    	if(interval!=null){
    		result.put("mark", 1);
    		return result;
    	}
    	interval=dao.findFirst("select * from  m_interval where activity_id=? and begin_time<date_format(date_sub(now(),interval -10 minute),'%Y-%m-%d %H:%i:%s') and end_time>date_format(now(),'%Y-%m-%d %H:%i:%s') and status=1 ",activityId);
    	if(interval!=null){
    		//在10分钟内 要显示倒计时 row=1
    		result.put("mark", 0);
    		String beginTimeStr=interval.getStr("begin_time");
    		Date beginTime=DateUtil.convertString2Date(beginTimeStr);
    		long sub=beginTime.getTime() - new Date().getTime();
    		if(sub<0){
    			sub=0;
    		}
    		Date subDate=new Date(sub);
    		result.put("minute",subDate.getMinutes());
    		result.put("second", subDate.getSeconds());
    	}else{
    		//不在10分钟内 不要显示
    		result.put("mark", -1);
    	}
    	return result;
    }
    /**
     * 是否在活动区间段内
     */
    public MInterval isInInterval(int activityId){
    	return dao.findFirst("select * from  m_interval where activity_id=? and begin_time<NOW() and end_time>NOW()",activityId);
    }
    
    /**
     * 活动区间领取种子总数
     * @param id
     * @return
     */
    public Long totalCount(int id){
    	BigDecimal b= Db.findFirst("select SUM(seedCount)as total from (select t.seed_name,(select count(*) from m_interval m "
    			+ "left join m_seed_instance i on m.activity_id=i.activity_id "
    			+ "where m.activity_id=? and i.get_time >=m.begin_time and i.get_time<=m.end_time and i.seed_type_id=t.id )as seedCount from m_seed_type t "
    			+ "where t.`status`='Y' ) d",id).getBigDecimal("total");
    	return b.longValue();
    }
    
    /**
     * 活动某个区间段内领取种子总数
     * @param id
     * @return
     */
    public List<Record> intervalStatistic(int id,String startTime,String endTime){
    	return Db.find("select count(*) as seedCount,'已领取总数' as seed_name from m_seed_instance a where a.activity_id=?"
    			+" and a.get_time >=? and a.get_time<=? union "
    			+" select (select count(*) from m_seed_instance a where b.id=a.seed_type_id and a.activity_id=?" 
    		    +" and a.get_time >=? and a.get_time<=? ) as seedCount ,b.seed_name from m_seed_type b where b.status='Y' ",id,startTime,endTime,id,startTime,endTime);
    }
    
    /**
     * 各类型种子区间领取情况
     * @param id
     * @return
     */
    public List<Record> seedTypeCount(int id,String startTime,String endTime){
    	return Db.find("select t.seed_name,(select count(*) from m_interval m "
    			+ "left join m_seed_instance i on m.activity_id=i.activity_id where m.activity_id=? and i.get_time >="+startTime+" "
    			+ "and i.get_time<="+endTime+" and i.seed_type_id=t.id )as seedCount from m_seed_type t where t.`status`='Y' ", id);
    }
}
