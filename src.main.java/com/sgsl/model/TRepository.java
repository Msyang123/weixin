package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class TRepository extends Model<TRepository> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        public static final TRepository dao = new TRepository();
        /**
         * 门店查询
         * @return
         */
        public List<TRepository> findTRepository() {
        	String sql = "select * from t_repository where status='2'";
            return dao.find(sql);
        }
    }