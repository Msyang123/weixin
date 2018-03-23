package com.sgsl.model;


import java.util.*;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 种子活动单品
 * @author yijun
 *
 */
public class MSeedProduct extends Model<MSeedProduct> {
	private static final long serialVersionUID = 1L;


    public static final MSeedProduct dao = new MSeedProduct();
    
    /**
     * 单品展示
     */
    public List<Map>  seedProductList(int activityId){
    	List<Record> seedProductList= Db.find("select sp.*,tp.product_name,i.save_string,tpf.product_amount,u.unit_name,u1.unit_name base_unitname from m_seed_product sp "+
    			"left join t_product_f tpf on "+
    			"sp.product_f_id=tpf.id "+
    			"left join t_unit u "+
    			"on tpf.product_unit=u.unit_code "+
    			"left join t_product tp "+
    			"on  tp.id=sp.product_id "+
    			"left join t_unit u1 on u1.unit_code=tp.base_unit "+
    			"left join t_image i on tp.img_id=i.id where sp.status='Y' and sp.activity_id=? order by order_id",activityId);
    	List<Map> result=new ArrayList<Map>();
    	for(Record item:seedProductList){
    		Map sMap=new HashMap();
    		//单品
    		sMap.put("seedProduct", item);
    		//兑换种子
    		sMap.put("needSeed", Db.find("select psr.id,psr.amount,st.seed_name from "+
                           "m_product_seed_r psr  "+
                           "left join m_seed_type st "+
                           "on st.id=psr.seed_type_id "+
                           "where psr.seed_product_id=? ",item.getInt("id")));
    		result.add(sMap);
    	}
    	return result;
    }
    
    //单品
    public MSeedProduct getSingle(int singleid){
    	return dao.findFirst("select * from m_seed_product where id=? and status='Y' ", singleid);
    }
}
