package com.sgsl.model;


import java.math.BigDecimal;
import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 种子类型
 * @author yijun
 *
 */
public class MSeedType extends Model<MSeedType> {
	private static final long serialVersionUID = 1L;


    public static final MSeedType dao = new MSeedType();
    
    /**
     * 种子发放领取总数
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public long receiveSeedNum(String createBegainTime,String createEndTime,int activity_id){
    	return Db.queryLong("select count(*)as receiveTotal from m_seed_instance t "
    			+ "left join m_activity t2 on t2.id=t.activity_id "
    			+ "where t.get_time BETWEEN ? and ? and t.`status`=1 and t2.id=? ", createBegainTime,createEndTime,activity_id);
    }
    
    /**
     * 分享赠送种子总数
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public long shareSeedNum(String createBegainTime,String createEndTime,int activity_id){
    	return Db.queryLong("select count(*) from m_seed_instance t "
    			+ "left join m_activity t2 on t.activity_id=t2.id "
    			+ "where t.`status`=1 and t.get_type in(1,2,3,4,5) and t.get_time BETWEEN ? and ? "
    			+ "and t2.id=?  ", createBegainTime,createEndTime,activity_id);
    }
    
    /**
     * 购物赠送种子总数
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public long shopSeedNum(String createBegainTime,String createEndTime,int activity_id){
    	return Db.queryLong("select count(*) from m_seed_instance t "
    			+ "left join m_activity t2 on t.activity_id=t2.id "
    			+ "where t.`status`=1 and t.get_type in(7) and t.get_time BETWEEN ? and ? "
    			+ "and t2.id=?", createBegainTime,createEndTime,activity_id);
    }
    
    /**
     * 兑换单品总份数
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public long exchangeSingleNum(String createBegainTime,String createEndTime,int activity_id){
    	return Db.queryLong("select count(*) from m_seed_product_instance t "
    			+ "left join m_seed_product t1 on t1.id=t.seed_product_id "
    			+ "left join m_activity t2 on t1.activity_id=t2.id "
    			+ "where t.status=1 and t2.id=? and t.get_time BETWEEN ? and ? ",activity_id,createBegainTime,createEndTime);
    }
    
    /**
     * 兑换套餐总份数
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public long exchangePackageNum(String createBegainTime,String createEndTime,int activity_id){
    	return Db.queryLong("select count(*) from m_package_instance t "
    			+ "left join m_package t1 on t.package_id=t1.id "
    			+ "left join m_activity t2 on t1.activity_id=t2.id "
    			+ "where t.`status`=1 "
    			+ "and t.get_time BETWEEN ? and ? and t2.id=?  ", createBegainTime,createEndTime,activity_id);
    }
    
    /**
     * 兑换商品总金额
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public BigDecimal totalMoney(String createBegainTime,String createEndTime,int activity_id){
    	//兑换领取单品总金额
    	BigDecimal dResult=Db.queryBigDecimal("select ifnull(SUM(ifnull(t2.price,t2.special_price)),0)as moneyTotal "
    			+ "from m_seed_product_instance t "
    			+ "left join m_seed_product t1 on t1.id=t.seed_product_id "
    			+ "left join t_product_f t2 on t2.id=t1.product_f_id "
    			+ "left join m_activity t3 on t1.activity_id=t3.id "
    			+ "where t.get_time BETWEEN ? and ? and t3.id=?", createBegainTime,createEndTime,activity_id);
    	
    	//兑换领取套餐总金额
    	BigDecimal tResult=Db.queryBigDecimal("select ifnull(sum(ifnull(t3.price,t3.special_price)),0)as price from m_package_instance t "
    			+ "left join m_package t1 on t.package_id=t1.id "
    			+ "left join m_package_product t2 on t2.package_id=t1.id "
    			+ "left join t_product_f t3 on t2.product_f_id=t3.id "
    			+ "left join m_activity t4 on t1.activity_id=t4.id "
    			+ "where t1.`status`='Y' and t.`status`=1 and t.get_time BETWEEN ? and ? and t4.id=?", createBegainTime,createEndTime,activity_id);
    	BigDecimal total=dResult.add(tResult);
    	System.out.println(total);
    	return dResult.add(tResult);
    }
    
    /**
     * 种子具体领取情况统计 
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public List<Record> receiveSeedCount(String createBegainTime,String createEndTime,int activity_id){
    	List<Record> re= Db.find("select st.seed_name,"
    			+ "(select count(*) from m_seed_instance i left join m_activity ma on ma.id=i.activity_id "
    			+ "where i.seed_type_id=st.id and i.`status`=1 and i.get_time BETWEEN ? and ? "
    			+ "and ma.id=?)as seed_count from m_seed_type st ", createBegainTime,createEndTime,activity_id);
    	return re;
    }
    
    /**
     * 单品具体领取情况统计
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public List<Record> receiveSingleCount(String createBegainTime,String createEndTime,int activity_id){
    	return Db.find("select single_name ,"
    			+ "(select count(*) from m_seed_product_instance t "
    			+ "where t.`status`=1 and t.seed_product_id=m.id and t.get_time BETWEEN ? and ? )as seedCount "
    			+ "from m_seed_product m where m.activity_id=? and m.`status`='Y'", createBegainTime,createEndTime,activity_id);
    }
    
    /**
     * 套餐具体领取情况统计
     * @param createBegainTime
     * @param createEndTime
     * @param activity_id
     * @return
     */
    public List<Record> receivePackageCount(String createBegainTime,String createEndTime,int activity_id){
    	return Db.find("select package_name,"
    			+ "(select count(*) from m_package_instance t where t.`status`=1 and t.get_time BETWEEN ? and ? )as seedCount "
    			+ "from m_package where `status`='Y' and activity_id=?", createBegainTime,createEndTime,activity_id);
    }
}
