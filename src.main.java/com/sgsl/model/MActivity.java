package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 * 活动
 */
public class MActivity extends Model<MActivity> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final MActivity dao = new MActivity();

        public MActivity findMActivityByUuid(String uuid) {
            return dao.findFirst("select * from m_activity where uuid=?",uuid);
        }
        //查找团购活动
        public List<Record> findGroupMActivity(int activityType){
        	return Db.find("select m.*,i.save_string from m_activity m left join t_image i on m.img_id=i.id where m.yxbz='Y' and m.status=0 and m.activity_type=? order by dis_order",activityType);
        }
        
        //
        public List<Record> findMActivitys(int activityType){
        	return Db.find("select m.*,i.save_string from m_activity m left join t_image i on m.img_id=i.id where m.yxbz='Y' and m.activity_type=? order by dis_order",activityType);
        }
        public List<Record> findMActivitys(int[] activityTypes){
        	StringBuffer sql=new StringBuffer();
        	sql.append("select m.*,i.save_string from m_activity m left join t_image i on m.img_id=i.id where m.yxbz='Y' and m.activity_type in(");
        	boolean flag=false;
        	for(int type:activityTypes){
        		if(flag){
        			sql.append(",");
        		}
        		flag=true;
        		sql.append(type);
        	}
        	sql.append(") order by dis_order");
        	return Db.find(sql.toString());
        }
        //查找活动对应的商品规格信息
        public List<Record> findMActivityProducts(int activityType){
        	return Db.find("select p.*,m.restrict from m_activity_product p left join m_activity m on m.id=p.activity_id where m.yxbz='Y' and m.activity_type=?",activityType);
        }
        public MActivity findYxActivityById(int activityId){
        	return dao.findFirst("select * from m_activity where yxbz='Y' and id=?",activityId);
        }
        /**
         * 查找有效团购活动
         * @return
         */
        public MActivity findYxActivityByType(int activityType){
        	return dao.findFirst("select * from m_activity where yxbz='Y' and activity_type=?",activityType);
        }
        /**
         * 查找所有某一类型的活动
         * @param activityType
         * @return
         */
        public List<MActivity> findActivityByType(int activityType){
        	return dao.find("select * from m_activity where activity_type=?",activityType);
        }
    }