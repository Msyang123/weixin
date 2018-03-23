package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 用户福娃
 * @author yijun
 *
 */
public class AUserFw extends Model<AUserFw> {
	private static final long serialVersionUID = 1L;


    public static final AUserFw dao = new AUserFw();
    
    public List<Record> getGiftCount(){
    	return Db.find("select user_id,min(fw_count) as total_gift,t.nickname "
    			+ " from a_user_fw a left join t_user t on a.user_id=t.id group by user_id having total_gift>0");
    }
    public Record getMyGift(int user_id){
    	return Db.findFirst("select min(fw_count) as total_gift  from a_user_fw a  where user_id=?",user_id);
    }
}
