package com.sgsl.model;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.DateUtil;

/**
 * 
 * @author TianWei 某一种具体的优惠券
 */
public class TCouponCategory extends Model<TCouponCategory> {

	private static final long serialVersionUID = 1L;

	public static final TCouponCategory dao = new TCouponCategory();

	public List<TCouponCategory> findCouponCategoryByActivityId(String activity_id) {
		List<TCouponCategory> couponCategory = dao.find("select * from t_coupon_category where activity_id = ?",
				activity_id);
		return couponCategory;
	}

	/**
	 * 查找当期活动优惠券种类
	 * 
	 * @param activityId
	 * @return
	 */
	public List<Record> findTCouponCategoryByActivityId(String activityId) {
		List<Record> result = Db.find(
				"select id,img_id,coupon_desc as title,coupon_desc,give_type,coupon_val,coupon_total from t_coupon_category tc where yxbz='Y' and activity_id=?",
				activityId);
		for (Record item : result) {
			if ("/".equals(item.get("coupon_total"))) {
				// 优惠券数量不限量
				item.set("c", 99999);
			} else {
				// 优惠券数量限量，查出剩余未领取的张数
				Record count = Db.findFirst(
						"select count(*) as c from t_coupon_real t where t.activity_id=? and t.coupon_category_id=? and t.status=0",
						activityId, item.getInt("id"));
				item.set("c", count.getLong("c"));
			}
		}
		return result;
	}

	/**
	 * 查找返券促销类型的活动的符合小于等于订单支付金额的优惠券
	 */
	public TCouponCategory findGiveCouponCategoryByActivityId() {
		// 判定活动有效
		return dao.findFirst(
				"select * from t_coupon_category where activity_id in (select id from m_activity where activity_type=6 and yxbz='Y') and yxbz='Y'  order by coupon_val desc limit 1");
	}

	/**
	 * 找到最大的满足返券条件的面值优惠券种类
	 */
	public TCouponCategory findMaxValueToGive(int cost_money) {
		// 判定活动有效
		return dao.findFirst(
				"select id,min_pay_give from t_coupon_category where activity_id in (select id from m_activity where activity_type=6 and yxbz='Y') and yxbz='Y' and min_pay_give<=? order by coupon_val desc limit 1",
				cost_money);
	}

	/**
	 * 对应活动、金额、有效的优惠券种类
	 */
	public List<TCouponCategory> findCouponCategorysToGive(int activityId, int min_pay_give) {
		return dao.find("select * from t_coupon_category where activity_id=? and yxbz='Y' and min_pay_give =? ",
				activityId, min_pay_give);
	}
	
	/**
     * 查找所有已经开启的category
     * @return
     */
    public List<TCouponCategory> alreadBeginList(){
    	List<TCouponCategory> lst=new ArrayList<TCouponCategory>();
    	MActivity activity=MActivity.dao.findYxActivityByType(19);
    	if(activity==null) return lst;
    	return dao.find("select * from t_coupon_category where activity_id=? and yxbz='Y' ",activity.getInt("id"));
    }
	
	/**
     * 取消优惠券兑换码活动 
     * @param teamBuyId
     *getRequest().getSession().getServletContext().getRealPath("/WEB-INF/classes/apiclient_cert.p12")
     */
    public void cancelCouponCategory(int categoryId){
    	TCouponCategory category=TCouponCategory.dao.findById(categoryId);
    	MActivity activity = MActivity.dao.findById(category.get("activity_id"));
    	if(category==null) return;
    	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	String currentTime = df.format(new Date());//当前时间
    	
        System.out.println("categoryId and yxq_z"+categoryId+category.getStr("yxq_z"));
        //判定当前时间大于截止时间
    	//Date endTime = DateUtil.convertString2Date(category.getStr("yxq_z"));
    	if(currentTime.compareTo(category.getStr("yxq_z"))>0&&category.getStr("yxbz").equals("Y")){
    		System.out.println("满足过期条件");
    		activity.set("yxbz", "N");
    		activity.update();
    		category.set("yxbz", "N");
    		category.update();
    	}
    }
}
