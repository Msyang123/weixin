package com.sgsl.model;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.utils.DateFormatUtil;

/**
 * Created by yj on 2014/7/28. 用户的优惠券
 */
public class TUserCoupon extends Model<TUserCoupon> {
	
        /**
         *优惠券
         */
        private static final long serialVersionUID = 1L;
        
        public static final TUserCoupon dao = new TUserCoupon();
        
        public List<Record> findUserCoupons(int userId,int balance,int[] exceptPFid) {
        	String sql = "select a.id,a.user_id,a.coupon_id,is_expire,a.title,a.activity_id,b.id,b.coupon_category_id,b.coupon_desc,b.coupon_val,b.min_cost,b.start_time,b.end_time,b.status,b.yxbz,cs.is_single,cs.id as coupon_scale_id "
        			+ "from t_user_coupon a "
        			+ "left join t_coupon_real b on a.coupon_id = b.id "
        			+ "left join t_coupon_scale cs on cs.id = b.coupon_scale_id "
        			+ "where a.user_id=? and a.is_expire='0' and b.status='1' and b.min_cost<=? "
        			+ " and b.start_time<=? and b.end_time>=? ";
        	//检测活动排除商品是否在此订单中
        		if(exceptPFid.length>0){
        			String in=" and (select count(*) from m_activity_product_except where product_f_id in(";
        			boolean flag=false;
        			for(int i:exceptPFid){
        				if(flag){
        					in+=","+i;
        				}else{
        					in+=i;
        				}
        				flag=true;
        			}
        			in+=") and activity_id=a.activity_id )=0 ";
        			sql+=in;
        		}
        		sql += " order by b.coupon_val desc";
        		String currentTime=DateFormatUtil.format1(new Date());
        		List<Record> couponList = Db.find(sql,userId,balance,currentTime,currentTime);
        		//假如优惠券中有单品
        		for(Iterator<Record> it = couponList.iterator(); it.hasNext();){
        			Record record = it.next();
        			if("Y".equals(record.getStr("is_single"))){
						Record productCoupon = Db.findFirst("select * from t_product_coupon where coupon_scale_id=?",record.getInt("coupon_scale_id"));
						boolean remove = true;
						for (int i = 0; i < exceptPFid.length; i++) {
							if(exceptPFid[i]==productCoupon.getInt("product_f_id")){
								remove=false;
							}
						}
						if(remove){
							it.remove();
						}
					}
        		}
            return couponList;
        }
        
        public Record findUserCouponsById(int couponId,int userId,int balance) {
        	String sql = "select a.*,b.* "
        			+ "from t_user_coupon a "
        			+ "left join t_coupon_real b on a.coupon_id = b.id "
        			+ "where a.id=? and a.user_id=? and a.is_expire='0' and b.status='0' and b.min_cost<=?";
            return Db.findFirst(sql,couponId,userId,balance);
        }
        public TUserCoupon findUserCouponByOrderId(int orderId){
        	return this.findFirst("select * from t_user_coupon where order_id=?",orderId);
        }
        public TUserCoupon findUserGetCouponNumByOrderId(int orderId){
        	return this.findFirst("select count(*) as count from t_user_coupon where order_id=?",orderId);
        }
        public TUserCoupon findUserCouponByCouponId(int couponId){
        	return this.findFirst("select * from t_user_coupon where coupon_id=?",couponId);
        }
        public List<Record> findTUserCoupon (int userId){
        	return Db.find("select uc.*,c.coupon_val,c.start_time,c.end_time,c.coupon_desc from t_user_coupon uc left join t_coupon_real c on uc.coupon_id=c.id "+
        			" where is_expire='0' and c.end_time>=date_format(now(),'%Y-%m-%d %H:%i:%s') and user_id=? and status=1",userId);
        }   
    }
