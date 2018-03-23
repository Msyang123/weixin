package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class TUserWhite extends Model<TUserWhite> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        public static final TUserWhite dao = new TUserWhite();
        /**
         * @return
         */
        public Record isWhite(int userId,int activityId) {
        	String sql = "select * from t_user_white a "
        			+ "left join t_white_gift b "
        			+ "on a.user_id=b.user_id and a.activity_id=b.activity_id "
        			+ "left join m_activity m on a.activity_id = m.id "
        			+ "where a.user_id=? and a.activity_id=? and b.user_id is null and m.yxbz='Y' and NOW()>m.yxq_q";
            return Db.findFirst(sql,userId,activityId);
        }
    }