package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;

/**
 * Created by yj on 2014/7/28.
 */
public class MCarousel extends Model<MCarousel> {

        /**
         *轮播图
         */
        private static final long serialVersionUID = 1L;


        public static final MCarousel dao = new MCarousel();

        public List<MCarousel> findMCarouselByTypeId(int typeId) {
            return dao.find("select * from m_carousel where type_id=?",typeId);
        }
        public List<Record> findMCarousels(int typeId){
        	return Db.find("select c.*,i.save_string from m_carousel c left join t_image i on c.img_id=i.id where c.type_id=? order by c.order_id asc", typeId);
        }
        public Page<Record> getMCarousels(int pageSize,
				int page,
				String sidx,
				String sord,int typeId){
        	return Db.paginate(page,pageSize,"select c.*,i.save_string","from m_carousel c left join t_image i on c.img_id=i.id where c.type_id=? order by c.order_id asc", typeId);
        }
        public Record findMCarousel(int typeId){
        	return Db.findFirst("select c.*,i.save_string from m_carousel c left join t_image i on c.img_id=i.id where c.type_id=? order by c.order_id asc", typeId);
        }
    }