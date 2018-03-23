package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class TFeedback extends Model<TFeedback> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        /**
         * 获取到所有的反馈信息
         * @return
         */
        public List<Record> getAllFeeBack(){
        	return Db.find("select f.*,u.user_img_id,u.nickname,u.phone_num from t_feedback f left join t_user u on f.fb_user=u.id");
        }
    }