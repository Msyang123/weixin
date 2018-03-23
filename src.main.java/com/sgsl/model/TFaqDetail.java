package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Model;

/**
 * Created by yj on 2014/7/28.
 */
public class TFaqDetail extends Model<TFaqDetail> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final TFaqDetail dao = new TFaqDetail();

        public List<TFaqDetail> findFaqByType(String type) {
        	String sql = "select * from t_faq_detail where type = ?";
            return dao.find(sql,type);
        }
    }