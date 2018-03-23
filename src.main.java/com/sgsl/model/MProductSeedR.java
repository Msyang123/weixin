package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Model;

/**
 * 商品与种子兑换关系表
 * @author yijun
 *
 */
public class MProductSeedR extends Model<MProductSeedR> {
	private static final long serialVersionUID = 1L;


    public static final MProductSeedR dao = new MProductSeedR();
    
    public List<MProductSeedR> getMProductSeedR(int seedProductId){
    	return dao.find("select * from m_product_seed_r where seed_product_id=?",seedProductId);
    }
}
