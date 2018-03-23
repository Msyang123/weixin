package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 * 商品分类
 */
public class TCategory extends Model<TCategory> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final TCategory dao = new TCategory();
        //去掉年货商品分类
        public List<Record> findTCategorys(String parentId){
        	return Db.find("select c.*,i.save_string from t_category c left join t_image i on c.img_id=i.id where c.parent_id=?  and category_id!='07'order by c.order_num", parentId);
        }
        
        public TCategory findTCategoryById(String categoryId){
        	return dao.findFirst("select * from t_category where category_id=?",categoryId);
        }
    }