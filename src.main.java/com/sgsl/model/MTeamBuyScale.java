package com.sgsl.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.utils.DateFormatUtil;


/**
 * 团购规模 如2人团 5人团
 * @author yijun
 *
 */
public class MTeamBuyScale extends Model<MTeamBuyScale> {
	private static final long serialVersionUID = 1L;


    public static final MTeamBuyScale dao = new MTeamBuyScale();
    
    /**
     * 根据团购商品获取团购规模列表
     * @return
     */
    public List<Record> getMTeamBuyScale(int activityProductId){
    	String currentDate=DateFormatUtil.format5(new Date());
    	return Db.find("select tbs.*,(select count(*) from m_team_buy tb where tb.m_team_buy_scale_id=tbs.id and tb.create_time between ? and ?) as currenttimes "
    			+ " from m_team_buy_scale tbs where activity_product_id=? and yxbz='Y' order by tbs.dis_order desc",
    			currentDate+" 00:00:00",currentDate+" 23:59:59",activityProductId);
    }
    /**
     * 获取团购中商品信息
     * @param buyScaleId
     * @return
     */
    public TProductF getTeamBuyProduct(int buyScaleId){
    	return TProductF.dao.findFirst("select pf.* from m_team_buy_scale tbs left join m_activity_product map "
    			+ " on map.id=tbs.activity_product_id left join t_product_f pf "
    			+ " on map.product_id=pf.product_id and map.product_f_id=pf.id where tbs.id=?",buyScaleId);
    }
    
    /**
     * 查找单个团购详情
     */
    public Record getMTeamBuyScaleById(int teamBuyScaleId){
    	return Db.findFirst("select s.*,map.product_f_id,(select ifnull(pf.special_price,pf.price) "+
    			" from t_product_f pf where pf.id=map.product_f_id and pf.product_id=map.product_id ) real_price "+
    			" from m_team_buy_scale s "+
    			" left join m_activity_product map on map.id=s.activity_product_id where s.id=? ", teamBuyScaleId);
    }
}
