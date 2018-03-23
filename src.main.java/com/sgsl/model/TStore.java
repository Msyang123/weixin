package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class TStore extends Model<TStore> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;
        
        public static final TStore dao = new TStore();
        /**
         * 门店查询
         * @return
         */
        public List<Record> findStores() {
        	String sql = "select s.*,(select i.save_string from t_image i where i.id=s.qrcode_img) as qrcodeimg, "
        			+" (select i.save_string from t_image i where i.id=s.wxgroup_img) as wxgroupimg, "
        			+" (select i.save_string from t_image i where i.id=s.store_img) as storeimg "
        			+" from t_store s where s.store_id not in('07310103','07310206','07310111','8888')";
            return Db.find(sql);
        }
        public List<TStore> findAllStores(){
        	return dao.find("select * from t_store");
        }
        public TStore getStoreByStoreId(String storeId){
        	return dao.findFirst("select * from t_store where store_id=?",storeId);
        }
    }