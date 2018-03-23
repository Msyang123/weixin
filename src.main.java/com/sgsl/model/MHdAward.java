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
public class MHdAward extends Model<MHdAward>{
	
	private static final long serialVersionUID = 1L;

    public static final MHdAward dao = new MHdAward();
    
    /*
     * 根据活动类型查找所有的相关奖品信息，并根据奖品顺序排序
     */
    public List<Record> findMHdAwardsByActivityId(){
    	return Db.find("select t1.*,t2.save_string from m_hd_award  t1 left join t_image t2 on t1.img_id=t2.id  order by award_sequence");
    }
    
}
