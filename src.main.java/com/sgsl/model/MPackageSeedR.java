package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Model;

/**
 * 种子兑换套餐关系表
 * @author yijun
 *
 */
public class MPackageSeedR extends Model<MPackageSeedR> {
	private static final long serialVersionUID = 1L;


    public static final MPackageSeedR dao = new MPackageSeedR();
    
    /**
     * 种子套餐兑换关系
     * @param packageId
     * @return
     */
    public List<MPackageSeedR> getPackageSeedR(int packageId){
    	return dao.find("select * from m_package_seed_r where package_id=?",packageId);
    }
}
