package com.sgsl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TCouponScale;
import com.sgsl.model.TImage;
import com.sgsl.model.TProductF;
import com.sgsl.util.StringUtil;

/**
 * 
 * @author tw 优惠券管理
 */
public class CouponManageController extends BaseController {

	protected final static Logger logger = Logger.getLogger(CouponManageController.class);

	public void editGiveCoupon() {
		String activity_id = getPara("id");
		MActivity activity = MActivity.dao.findById(activity_id);
		if (activity == null) {
			activity = new MActivity();
		}
		setAttr("activity", activity);
		render(AppConst.PATH_MANAGE_PC + "/coupon/giveCouponActivity.ftl");
	}
	
	public void isData(){
		String activity_id = getPara("id");
		JSONObject result = new JSONObject();
		List<Record> records=Db.find("select * from t_user_coupon where activity_id=? ",activity_id);
		if(records.size()>0){
			result.put("success", false);
			result.put("msg", "已有业务数据产生，不能编辑！");
			renderJson(result);
			return;
		}else{
			result.put("success", true);
		}
		renderJson(result);
	}

	/**
	 * 发券活动编辑
	 */
   public void editOutCoupon() {
        String activity_id = getPara("id");
        MActivity activity = MActivity.dao.findById(activity_id);
        if (activity == null) {
            activity = new MActivity();
        }
        setAttr("activity", activity);
        TImage image = TImage.dao.findById(activity.getInt("img_id"));
        setAttr("image", image);
        
        List<TCouponScale> tCouponScale = TCouponScale.dao.findAllValidTCouponScales();
        setAttr("tCouponScale", tCouponScale);
        
        List<TCouponCategory> tCouponCategory = TCouponCategory.dao.findCouponCategoryByActivityId(activity_id);
        if(tCouponCategory.size()>0){
        	setAttr("tCouponCategorys", tCouponCategory);
        }
        render(AppConst.PATH_MANAGE_PC + "/coupon/editOutCoupon.ftl");
    }
   
   public void addOutCoupon1(){
	   JSONObject mes =new JSONObject();
	   String activity_id = getPara("activity_id");
	   String user_gain_times = getPara("user_gain_times");//用户限领次数
	   String coupon_total = getPara("coupon_total");
	   String activity_type=getPara("activity_type");
	   int CouponId = getParaToInt("relateCoupon");
	   String main_title=getPara("main_title");
	   String yxq_q = getPara("yxq_q");
	   String yxq_z = getPara("yxq_z");
	   String yxbz = getPara("yxbz");	
	   TCouponCategory tCouponCategory = new TCouponCategory();
	   tCouponCategory.set("activity_id", activity_id);
	   tCouponCategory.set("yxq_q", yxq_q);
	   tCouponCategory.set("yxq_z", yxq_z);
	   tCouponCategory.set("yxbz", yxbz);
	   tCouponCategory.set("coupon_scale_id", CouponId);
	   if(StringUtil.isNull(coupon_total)){
		   tCouponCategory.set("coupon_type", 2);
		   tCouponCategory.set("coupon_total", "/");
	   }else{
		   tCouponCategory.set("coupon_type", 1);
		   tCouponCategory.set("coupon_total", coupon_total);
	   }
	   System.out.println("+=========="+getRequest().getScheme()+"://"+ getRequest().getServerName());//获取服务器域名
	   //System.out.println("+=========="+getRequest().getServerName());
	   
	   tCouponCategory.set("user_gain_times", user_gain_times);
	   MActivity mActivity = new MActivity();
	   mActivity.set("activity_type", activity_type);
	   mActivity.set("yxq_q", yxq_q);
	   mActivity.set("yxq_z", yxq_z);
	   mActivity.set("yxbz", yxbz);
	   mActivity.set("main_title", main_title);
	 //  mActivity.set("coupon_count", coupon_total);// DOTO优惠券数量
	   List<Record> activityList=Db.find("select * from m_activity where yxbz='Y' and activity_type=17 ");
	   if("Y".equals(yxbz)&&activityList.size()>0){
		   mes.put("mes", "已经有开启的活动了，请先关闭其他的活动在进行下面操作！");
		   renderJson(mes);
		   return;
	   }
	   if(StringUtil.isNull(activity_id)){
		   String referer = getRequest().getHeader("Referer");
		   String urlHead=referer.substring(0, referer.indexOf("weixin/"));
		   System.out.println(urlHead+"========================================");
		   mActivity.set("url", urlHead+"weixin/coupon/sendCoupon");
		   boolean flag = mActivity.save();
		   if(flag==true){
			   Record coupon = Db.findFirst("select *from t_coupon_scale where id=?", CouponId);
			   tCouponCategory.set("main_title", coupon.get("coupon_desc"));
			   tCouponCategory.set("activity_id", mActivity.getInt("id"));
			   tCouponCategory.set("min_cost", coupon.getInt("min_cost"));
			   tCouponCategory.set("give_type", 3);
			   tCouponCategory.set("coupon_desc", coupon.get("coupon_desc"));
			   tCouponCategory.set("coupon_val", coupon.getInt("coupon_val"));
			   tCouponCategory.save();
		   }
		   mes.put("mes", "添加成功！");
	   }else{//修改活动
			TCouponScale.dao.updateInfo(model2map(mActivity), getParaToInt("activity_id"), "m_activity");
			Record couponCategory = Db.findFirst("select * from t_coupon_category where coupon_scale_id=?",CouponId);
			TCouponScale.dao.updateInfo(model2map(tCouponCategory), couponCategory.getInt("id"), "t_coupon_category");
			mes.put("mes", "修改成功！");
	   }
	   //redirect("/activityManage/yhq");
	   renderJson(mes);
   }
   
   /**
    * 添加发券活动
    */
   public void addOutCoupon(){
	   JSONObject mes =new JSONObject();
	   String activity_id = getPara("activity_id");
	   String coupon_count = getPara("coupon_count");
	   String activity_type=getPara("activity_type");
	   String relateCoupons = getPara("relateCoupons");
	   JSONArray relateCouponsJson = JSONArray.parseArray(relateCoupons);
	   String main_title=getPara("main_title");
	   String yxq_q = getPara("yxq_q");
	   String yxq_z = getPara("yxq_z");
	   String receive_code=getPara("receive_code");
	   String yxq=getPara("yxq");
	   String user_receive_nums=getPara("user_receive_num");
	   String image_url=getPara("url");
	   String img_id=getPara("image_id");
	   String use_url=getPara("use_url");
	   
	   MActivity mActivity = new MActivity();
	   
	   TImage image=null;
	   if(StringUtil.isNull(img_id)){
		   if(StringUtil.isNotNull(image_url)){
			   image = new TImage();
			   image.set("save_string", image_url);
			   image.save();
			   mActivity.set("img_id", image.getInt("id"));
		   }
	   }else{
		   image=TImage.dao.findById(img_id);
		   image.set("save_string", image_url);
		   image.update();
	   }
	   
	   mActivity.set("activity_type", activity_type);
	   mActivity.set("yxq_q", yxq_q);
	   mActivity.set("yxq_z", yxq_z);
	   mActivity.set("yxbz", "N");
	   mActivity.set("main_title", main_title);
	   mActivity.set("coupon_count", coupon_count);
	   mActivity.set("receive_code", receive_code);
	   mActivity.set("yxq", yxq);
	   mActivity.set("user_receive_num", user_receive_nums);
	   if(StringUtil.isNull(use_url)){
		   mActivity.set("use_url", null);
	   }else{
		   mActivity.set("use_url", use_url.trim());
	   }
	   
	   if(StringUtil.isNull(coupon_count)){
		   mActivity.set("coupon_isLimt", 2);
		   mActivity.set("coupon_count", 9999);
	   }else{
		   mActivity.set("coupon_isLimt", 1);
		   mActivity.set("coupon_count", getParaToInt("coupon_count"));
	   }
	   
	   TCouponCategory tCouponCategory = new TCouponCategory();
	   tCouponCategory.set("activity_id", activity_id);
	   tCouponCategory.set("yxq_q", yxq_q);
	   tCouponCategory.set("yxq_z", yxq_z);
	   tCouponCategory.set("yxbz", "Y");
	   
	   //根据Id判断是新增还是修改
	   if(StringUtil.isNull(activity_id)){
		   String referer = getRequest().getHeader("Referer");
		   String urlHead=referer.substring(0, referer.indexOf("weixin/"));
		   System.out.println(urlHead+"========================================");
		   //先保存活动然后设置url再更新进去
		   mActivity.save();
		   //因为地址要带活动编号，所以要先保存数据取编号然后再改
		   mActivity.set("url", urlHead+"weixin/coupon/sendCoupon?acid="+mActivity.getInt("id"));
		   mActivity.update();
		   
		   for(int i=0;relateCouponsJson.size()>i;i++){
			   System.out.println(relateCouponsJson.get(i));
			   Record coupon = Db.findFirst("select *from t_coupon_scale where id=? and is_valid='Y' ", relateCouponsJson.get(i));
			   tCouponCategory.set("main_title", coupon.get("coupon_desc"));
			   tCouponCategory.set("activity_id", mActivity.getInt("id"));
			   tCouponCategory.set("min_cost", coupon.getInt("min_cost"));
			   tCouponCategory.set("give_type", 3);
			   tCouponCategory.set("coupon_desc", coupon.get("coupon_desc"));
			   tCouponCategory.set("coupon_val", coupon.getInt("coupon_val"));
			   tCouponCategory.set("coupon_scale_id", relateCouponsJson.get(i)); 
			   tCouponCategory.save();
			   tCouponCategory.remove("id");
		   }
		   mes.put("mes", "添加成功！");
	   }else{
			TCouponScale.dao.updateInfo(model2map(mActivity), getParaToInt("activity_id"), "m_activity");
			for(int i=0;relateCouponsJson.size()>i;i++){
				//可能存在相同模板的优惠券
				List<TCouponCategory> couponCategorys = TCouponCategory.dao.find("select * from t_coupon_category where coupon_scale_id=? and activity_id=? ",relateCouponsJson.get(i),activity_id);
				for(TCouponCategory couponCategory1:couponCategorys){
					couponCategory1.delete();
				}
				Record coupon = Db.findFirst("select *from t_coupon_scale where id=? and is_valid='Y' ", relateCouponsJson.get(i));
				tCouponCategory.set("main_title", coupon.get("coupon_desc"));
			    tCouponCategory.set("activity_id", activity_id);
			    tCouponCategory.set("min_cost", coupon.getInt("min_cost"));
			    tCouponCategory.set("give_type", 3);
			    tCouponCategory.set("coupon_desc", coupon.get("coupon_desc"));
			    tCouponCategory.set("coupon_val", coupon.getInt("coupon_val"));
			    tCouponCategory.set("coupon_scale_id", relateCouponsJson.get(i)); 
			    tCouponCategory.save();
			    tCouponCategory.remove("id");
			}
			mes.put("mes", "修改成功！");
	   }
	   renderJson(mes);
   }
   
	
	/**
	 * 添加产品到返券活动中
	 */
	public void addProductToActivity() {
		/*
		 * //得到一个产品id int product_id = getParaToInt("product_id"); int
		 * activity_id = getParaToInt("activity_id"); //添加至活动产品表内
		 * MActivityProduct activityProduct = new MActivityProduct(); Record
		 * record = new Record(); record.set("product_id", product_id);
		 * record.set("activity_id", activity_id); Db.save("m_activity_product",
		 * record); Map<Object,String> result = new HashMap<Object,String>();
		 * result.put("success", "success"); renderJson(result);
		 */
		int activity_id = getParaToInt("activity_id");
		String product_f_id = getPara("productf_id");

		TProductF productF = new TProductF();
		// for (String item : ids.split(",")) {
		TProductF searchProductF = productF.findById(product_f_id);
		if (searchProductF != null && "Y".equals(searchProductF.getStr("is_vlid"))) {
			MActivityProduct activityProduct = new MActivityProduct();
			if (activityProduct.findFirst("select * from m_activity_product where activity_id=? and product_f_id=?",
					activity_id, product_f_id) == null) {
				activityProduct.set("activity_id", activity_id);
				activityProduct.set("product_id", searchProductF.get("product_id"));
				activityProduct.set("dis_order", 1);
				activityProduct.set("product_f_id", Integer.parseInt(product_f_id));
				activityProduct.save();
			}
		}
		Map<Object, String> result = new HashMap<Object, String>();
		result.put("success", "success");
		renderJson(result);
	}

	/**
	 * 所有有详细信息的产品
	 */
	public void productFList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");
		String sord = getPara("sord");
		String productName = "";
		if (StringUtil.isNotNull(getPara("productName"))) {
			productName = getPara("productName");
		}
		String productStatus = "01";
		if (StringUtil.isNotNull(getPara("productStatus"))) {
			productStatus = getPara("productStatus");
		}
		int categoryId = -1;
		if (StringUtil.isNotNull(getPara("categoryIdValue"))) {
			categoryId = getParaToInt("categoryIdValue");
		}
		// TProductF productF = new TProductF();
		// Page<Record> pageInfo = productF.findTProductF(productName,
		// productStatus, categoryId, pageSize, page, sidx,
		// sord);

		// 存在有商品但是没有规格的数据需要注意
		String sql = "select pf.id,p.product_status,c.category_name,i.save_string,p.product_name,u1.unit_name as base_unitname,pf.product_amount,pf.product_unit,pf.standard,pf.price,pf.special_price,pf.is_gift,pf.is_vlid";
		String where = " from  t_product p left join t_product_f pf on p.id=pf.product_id";
		where += " left join t_category c on p.category_id=c.category_id ";
		where += " left join t_image i on p.img_id=i.id ";
		where += " left join t_unit u1 on p.base_unit=u1.unit_code ";
		where += " where p.product_status='" + productStatus + "'";
		where += " and pf.is_vlid = 'Y'";
		if (StringUtil.isNotNull(productName)) {
			where += "  and  p.product_name like concat('%','" + productName + "','%') ";
		}
		if (categoryId > 0) {
			where += " and c.category_id=" + categoryId;
		}

		where += " order by p.id desc ";
		Page<Record> pageInfo = Db.paginate(page, pageSize, sql, where);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record rc : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", rc.getInt("id"));
			row.add(rc.getInt("id"));
			row.add(rc.getStr("product_status"));
			row.add(rc.getStr("product_name"));
			row.add(rc.getStr("category_name"));
			row.add(rc.getStr("save_string"));
			row.add(rc.getStr("base_unitname"));
			row.add(rc.getDouble("product_amount"));
			row.add(rc.getStr("product_unit"));
			row.add(rc.getStr("standard"));
			row.add(rc.getInt("price"));
			row.add(rc.getInt("special_price"));
			row.add(rc.getStr("is_gift"));
			row.add(rc.getStr("is_vlid"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 将某种产品从活动中删除
	 */
	public void delProductFromActivity() {
		// 得到一个活动产品id
		String id = getPara("id");
		// 删除此种活动产品
		Db.deleteById("m_activity_product", id);
		Map<Object, String> result = new HashMap<Object, String>();
		result.put("success", "success");
		renderJson(result);
	}

	/**
	 * 返券活动关联的活动产品
	 */
	public void activityProductList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlsle = "select ap.id as id,p.product_status,c.category_name,i.save_string,p.product_name,u.unit_name as base_unitname,pf.product_amount,pf.product_unit,pf.standard,pf.price,pf.special_price,pf.is_gift,pf.is_vlid";
		String sqlStr = null;
		sqlStr = " from m_activity_product ap " + " left join t_product_f pf on pf.id=ap.product_f_id "
				+ " left join t_product p on pf.product_id=p.id " + " left join t_image i on p.img_id=i.id "
				+ " left join t_category c on p.category_id=c.category_id"
				+ " left join t_unit u on pf.product_unit=u.unit_code " + "  where ap.activity_id="
				+ getPara("activity_id");
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize, sqlsle, sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record r : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", r.get("id"));
			// 操作列，需要第一列填充空数据
			row.add(r.getInt("id"));
			row.add(r.getStr("product_status"));
			row.add(r.getStr("product_name"));
			row.add(r.getStr("category_name"));
			row.add(r.getStr("save_string"));
			row.add(r.getStr("base_unitname"));
			row.add(r.getDouble("product_amount"));
			row.add(r.getStr("product_unit"));
			row.add(r.getStr("standard"));
			row.add(r.getInt("price"));
			row.add(r.getInt("special_price"));
			row.add(r.getStr("is_gift"));
			row.add(r.getStr("is_vlid"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 统计一款活动下的所有优惠券领用及使用情况
	 */
	public void analysisCoupon() {
		int activity_id = getParaToInt("id");// 活动id
		//JSONObject resultJSon = new JSONObject();
		JSONArray jsonArr = new JSONArray();
		// 该活动所有的优惠券种类
		List<TCouponCategory> couponCategoryList = TCouponCategory.dao
				.find("select * from t_coupon_category where activity_id = ?", activity_id);
		for (TCouponCategory tCouponCategory : couponCategoryList) {
			JSONObject jsonObject = new JSONObject();
			TCouponReal couponReal = TCouponReal.dao.findFirst(
					"select COUNT(*) 'give_num',"
					+ "(select count(*) from t_coupon_real where activity_id =? and status=2 and coupon_category_id=?) 'use_num',"
					+ "FORMAT(IFNULL((select sum(t.need_pay)/100 from t_order t left join t_coupon_real r on t.order_coupon=r.id "
					+ "where r.coupon_category_id=? and t.order_status in(3,4,11)),0),2) as total_money "
					+ "from t_coupon_real where activity_id=? and status=1 and coupon_category_id=?",
					activity_id, tCouponCategory.getInt("id"),tCouponCategory.getInt("id"), activity_id,tCouponCategory.getInt("id"));
			//优惠券描述
			jsonObject.put("coupon_desc", tCouponCategory.get("coupon_desc"));
			//优惠券发放的数量(领取的数量)
			jsonObject.put("give_num", couponReal.getLong("give_num"));
			//优惠券使用数量
			jsonObject.put("use_num", couponReal.getLong("use_num"));
			//优惠券订单支付总金额
			jsonObject.put("total_money", couponReal.get("total_money"));
			jsonArr.add(jsonObject);
		}
		renderJson(jsonArr);
	}
}
