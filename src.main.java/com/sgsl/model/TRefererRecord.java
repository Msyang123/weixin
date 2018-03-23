package com.sgsl.model;



import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;

/**
 * 来源记录表
 * @author yijun
 *
 */
public class TRefererRecord extends Model<TRefererRecord> {
	private static final long serialVersionUID = 1L;


    public static final TRefererRecord dao = new TRefererRecord();
    
    public Page<Record> getRefererRecord(int pageSize,
										int page,
										String sidx,
										String sord){
    	String select="select t.*,u.nickname,u.phone_num",sqlExceptSelect=" from t_referer_record t left join t_user u on t.user_id=u.id order by t.create_time desc";
    	return Db.paginate(page, pageSize, select, sqlExceptSelect);
    }
    
}
