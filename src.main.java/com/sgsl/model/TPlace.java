package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class TPlace extends Model<TPlace> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        public static final TPlace dao = new TPlace();
        
        public String findPlaceByCode(String code) {
        	String sql = "select * from t_place where code=?";
            return dao.findFirst(sql,code).getStr("name");
        }
        
    }