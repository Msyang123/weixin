package com.sgsl.model;


import java.util.*;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 种子活动套餐
 * @author yijun
 *
 */
public class MPackage extends Model<MPackage> {
	private static final long serialVersionUID = 1L;


    public static final MPackage dao = new MPackage();
    
    public List<Map> packageList(int activityId){
    	List<Map> result=new ArrayList<Map>();
    	//所有套餐 
    	List<Record> packages= Db.find("select m.*,i.save_string from m_package m left join t_image i on m.image_id=i.id where activity_id=? and m.status='Y' order by order_id",activityId);
    	for(Record item:packages){
    		Map pMap=new HashMap();
    		//套餐兑换商品
    		pMap.put("packageProduct",Db.find("select p.id as pgid,pp.amount,tp.product_name, pf.product_amount,u.unit_name,u1.unit_name base_unitname from m_package p left join m_package_product pp on p.id=pp.package_id "+
        			"left join t_product_f pf on pp.product_id= pf.product_id and pp.product_f_id=pf.id "+
        			"left join t_product tp on pp.product_id=tp.id  "+
        			"left join t_unit u on pf.product_unit=u.unit_code left join t_unit u1 on u1.unit_code=tp.base_unit where p.id=? ",item.getInt("id")));
    		pMap.put("package", item);
    		//套餐需要种子
    		pMap.put("packageSeed", Db.find("select m.seed_name,mpr.amount,i.save_string from m_package_seed_r mpr left join  m_seed_type m on m.id=mpr.seed_type_id "+
    				"left join t_image i on m.image_id=i.id where m.status='Y'  and mpr.package_id =? ",item.getInt("id")));
    		result.add(pMap);
    	}
    	return result;
    	
    }
    
    //获取有效套餐
    public MPackage getPackage(int packageid){
    	return dao.findFirst("select * from m_package where id=? and status='Y'  ", packageid);
    }
}
