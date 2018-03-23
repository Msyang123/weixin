package com.sgsl.controller;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.ext.render.excel.PoiRender;
import com.jfinal.kit.PathKit;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.render.Render;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MActivityProductExcept;
import com.sgsl.model.MActivityStore;
import com.sgsl.model.MAward;
import com.sgsl.model.MCarousel;
import com.sgsl.model.MHdAward;
import com.sgsl.model.MInterval;
import com.sgsl.model.MTeamBuyScale;
import com.sgsl.model.TUserCoupon;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TCouponScale;
import com.sgsl.model.TImage;
import com.sgsl.model.TProductF;

import com.sgsl.model.TUser;
import com.sgsl.model.TStore;
import com.sgsl.util.DateUtil;
import com.sgsl.util.ExcelUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.swetake.util.Qrcode;

/**
 * Created by yj 管理活动 初始化活动编辑
 */
public class ActivityManageController extends BaseController {
	protected final static Logger logger = Logger.getLogger(ActivityManageController.class);

	public void initEdit() {

		MActivity activity = MActivity.dao.findById(getPara("id"));
		if (activity == null) {
			activity = new MActivity();
		} else if (activity.getInt("activity_type") == 14) {
			String sqlStr = "select content from m_activity where id=?";
			Record re = Db.findFirst(sqlStr, getPara("id"));
			JSONObject jsonObject = JSONObject.parseObject(re.get("content"));
			JSONArray jsonArray = jsonObject.getJSONArray("annoucementContent");
			setAttr("annouce", jsonArray);
		} else {
			TImage image = new TImage();
			setAttr("image", image.findById(activity.getInt("img_id")));
		}

		setAttr("activity", activity);
		render(AppConst.PATH_MANAGE_PC + "/activity/editActivity.ftl");
	}

	/**
	 * 初始化活动设置
	 */
	public void initSetting() {
		MActivity activity = MActivity.dao.findById(getPara("id"));
		setAttr("activity", activity);
		// 设置商品的规格列表
		List<Record> unitList = Db.find("select * from t_unit");
		boolean flag = false;
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < unitList.size(); i++) {
			if (flag) {
				sb.append(";");
			}
			sb.append(unitList.get(i).getStr("unit_code"));
			sb.append(":");
			sb.append(unitList.get(i).getStr("unit_name"));
			flag = true;
		}
		setAttr("unitList", sb.toString());
		render(AppConst.PATH_MANAGE_PC + "/activity/setActivity.ftl");
	}

	/**
	 * 加载活动中的时间段列表 如抢购时间段 、种子活动时间段
	 * 
	 * @return
	 */
	public void getIntervalListJson() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		int actId=getParaToInt("activity_id");

		String interName=getPara("interval_name");
		String status=getPara("status");
		String beginTime=getPara("begin_time");
		String endTime=getPara("end_time");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<MInterval> pageInfo = null;
		String sqlStr = "from m_interval where activity_id="+actId;
		
		if(StringUtil.isNotNull(interName)){
			sqlStr+=" and interval_name like '%"+interName+"%' ";
		}
		
		if(StringUtil.isNotNull(status)){
			sqlStr+=" and status="+status;
		}
		
		if(StringUtil.isNotNull(beginTime)&&StringUtil.isNotNull(endTime)){
			sqlStr+=" and begin_time>='"+beginTime+"' and end_time<='"+endTime+"' ";
		}
		
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		
		pageInfo = MInterval.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MInterval mi : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();			
			json.put("id", mi.get("id"));
			row.add(mi.get("id"));
			row.add(mi.get("interval_name"));
			row.add(mi.get("begin_time"));
			row.add(mi.get("end_time"));
			row.add(mi.get("activity_good_price"));
			row.add(mi.get("status"));
			row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * ajax去修改当前状态  开闭活动有效标志
	 */
	public void changeIntervalStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int acid=Integer.parseInt(id);	
			if(status.equals("0")){
				Db.update("update m_interval set status=1 where id="+acid);
			}else{
				Db.update("update m_interval set status=0 where id="+acid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * 添加修改删除活动时间段
	 */
	public void saveInterval() {
		String interId=getPara("intervalId");
		String acid=getPara("activityId");
		// 时间区间段
		MInterval model = getModel(MInterval.class, "interval");
		model.set("activity_id", acid);
		
		if(StringUtil.isNotNull(interId)&&interId.equals("0")){
			model.save();
		}else{
			model.set("id", Integer.parseInt(interId));
			model.update();
		}
		redirect("/activityManage/initSetting?id="+acid);
	}
   
	/**
	 * 修改或编辑时间段
	 */
	public void intervalDetial(){
		 String sid=getPara("id");
		 JSONObject result = new JSONObject();
		 if(StringUtil.isNotNull(sid)){
			 int id=Integer.parseInt(sid);
			 String sql="select * from m_interval where id="+id;
			 MInterval interval =MInterval.dao.findFirst(sql);
			 if(interval!=null){
				 result.put("success", true);
				 result.put("data", interval);
				 result.put("msg", "查询成功");
			 }else{
				 result.put("success", false);
				 result.put("msg", "未查到此条记录");
			 }
		 }else{
			 result.put("success", false);
			 result.put("msg", "参数id为null");
		 }
		 renderJson(result);
	}
	
	/**
	 * Ajax删除活动时间段 
	 */
	public void delIntervalAjax() {
	    String ids = getPara("ids");
	    String acid=getPara("acid");
		JSONObject result = new JSONObject();
		String sql = "delete from m_interval where id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
			
		    if(StringUtil.isNotNull(acid)){
		    	int aid=Integer.parseInt(acid);
		    	MActivity activity=MActivity.dao.findById(aid);
		    	if(activity.get("yxbz").equals("Y")){
		    		result.put("success", false);
					result.put("msg", "活动进行中，不允许删除相关数据");
		    	}
		    }
			
			idArr=ids.split(",");
			if(idArr.length==1){
				Db.update(sql+idArr[0]);
			}else{
				for (int i = 0; i < idArr.length; i++) {
				    Db.update(sql+idArr[i]);
                }
			}
			result.put("success", true);
			result.put("msg", "删除成功");
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * 异步加载活动商品(已添加)
	 */
	public void mActivityProducts() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlStr = null;

		sqlStr = "from m_activity_product ap " + " left join t_product_f pf on pf.id=ap.product_f_id "
				+ " left join t_product p on pf.product_id=p.id " + " left join t_image i on p.img_id=i.id "
				+ " left join t_unit u on pf.product_unit=u.unit_code " + "  where ap.activity_id="
				+ getPara("activityId");
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize,
				"select ap.id as apid,ap.activity_price,ap.product_count,i.save_string,p.id,p.product_name,pf.price,pf.special_price,pf.product_unit,pf.standard,pf.id as pf_id,u.unit_name ",
				sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record r : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", r.get("apid"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(r.get("apid"));
			row.add(r.get("activity_price"));
			row.add(r.get("product_count"));
			row.add(r.get("save_string"));
			row.add(r.get("product_name"));
			row.add(r.get("price"));
			row.add(r.get("special_price"));
			row.add(r.get("id"));
			row.add(r.get("pf_id"));
			row.add(r.get("standard"));
			row.add(r.get("unit_name"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 活动编辑
	 */
	public void save() {
		UUID uuid = UUID.randomUUID();
		MActivity model = getModel(MActivity.class, "activity");
		// 公告数组json
		if(14==getParaToInt("activity.activity_type")){
			String annouceContent = getPara("annouceContent");
			model.set("content", annouceContent);
		}
		// 满立减活动随机取值
		if (StringUtil.isNull(getPara("activity.money_random"))) {
			model.set("money_random", "N");
		}
		String imageSrc = getPara("image_src");
		Record record = new Record();
		record.set("uuid", uuid.toString());
		record.setColumns(model2map(model));

		TImage image = new TImage();
		image.set("save_string", imageSrc);
		image.save();
		record.set("img_id", image.getInt("id"));

		if (StringUtil.isNull(getPara("activity.id"))) {
			Db.save("m_activity", record);
		} else {
			Db.update("m_activity", record);
		}
		redirect("/activityManage/activityList");

	}

	/**
	 * 活动列表
	 */
	public void activityList() {
		render(AppConst.PATH_MANAGE_PC + "/activity/activityList.ftl");
	}

	/**
	 * 异步加载活动列表
	 */
	public void getActivitysJson() {
		
		String main_title = getPara("main_title");
		String yxbz = getPara("yxbz");
		String type=getPara("activity_type");
		
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		
		Page<MActivity> pageInfo = null;
		String sql="from m_activity where activity_type not in(15,16) ";
		
		if(StringUtil.isNotNull(type)){
			sql+="and activity_type="+type+" ";
		}
		
		if(StringUtil.isNotNull(yxbz)){
			sql+="and yxbz='"+yxbz+"' ";
		}
		
		if(StringUtil.isNotNull(main_title)){
			sql+="and main_title like '%"+main_title+"%' ";
		}
		
		if(StringUtil.isNotNull(sidx)){
			sql+="order by "+sidx+" "+sord;
		}
		
		pageInfo = MActivity.dao.paginate(page, pageSize, "select *", sql);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MActivity pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(pa.get("id"));
			row.add(pa.get("main_title"));
			row.add(pa.get("subheading"));
			row.add(pa.get("url"));
			row.add(pa.get("yxbz"));
			row.add(pa.get("activity_type"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * 初始化二维码生成页面
	 */
	public void initPrintTwoBarCode() {
		setAttr("code", getPara("code"));
		render(AppConst.PATH_MANAGE_PC + "/tool/printTowBarCode.ftl");
	}

	/**
	 * 输出二维码
	 * 
	 * @throws IOException
	 */
	public void printTwoBarCode() throws IOException {
		String code = getRequest().getParameter("code");
		if (StringUtil.isNull(code)) {
			renderNull();
		}
		Qrcode testQrcode = new Qrcode();
		testQrcode.setQrcodeErrorCorrect('M');
		testQrcode.setQrcodeEncodeMode('B');
		testQrcode.setQrcodeVersion(7);
		byte[] d = code.getBytes("gbk");
		BufferedImage image = new BufferedImage(98, 98, BufferedImage.TYPE_BYTE_BINARY);
		Graphics2D g = image.createGraphics();
		g.setBackground(Color.WHITE);
		g.clearRect(0, 0, 98, 98);
		g.setColor(Color.BLACK);
		if (d.length > 0 && d.length < 120) {
			boolean[][] s = testQrcode.calQrcode(d);
			for (int i = 0; i < s.length; i++) {
				for (int j = 0; j < s.length; j++) {
					if (s[j][i]) {
						g.fillRect(j * 2 + 3, i * 2 + 3, 2, 2);
					}
				}
			}
		}
		g.dispose();
		image.flush();
		ImageIO.write(image, "jpg", getResponse().getOutputStream());
		renderNull();
	}

	/**
	 * 修改删除活动商品
	 */
	public void delActivityProduct() {
		String activityId = getPara("activityId");
		if ("del".equals(getPara("oper"))) {
			String id = getPara("id");
			// 多个记录，批量删除
			if (id.indexOf(",") != -1) {
				for (String item : id.split(",")) {
					MActivityProduct activityProduct = new MActivityProduct();
					activityProduct.set("id", item);
					activityProduct.delete();
				}
			} else {
				MActivityProduct activityProduct = new MActivityProduct();
				activityProduct.set("id", getParaToInt("id"));
				activityProduct.delete();
			}
		} else if ("edit".equals(getPara("oper"))) {
			Record activityProduct = new Record();
			activityProduct.set("id", getParaToInt("id"));
			activityProduct.set("activity_price", getParaToInt("activity_price"));
			activityProduct.set("product_count", getParaToInt("product_count"));
			Db.update("m_activity_product", activityProduct);
		}
		redirect("/activityManage/initSetting?id=" + activityId);
	}

	/**
	 * 删除活动排除的商品
	 */
	public void delActivityExceptProduct() {
		String activityId = getPara("activityId");
		if ("del".equals(getPara("oper"))) {
			String id = getPara("id");
			// 多个记录，批量删除
			if (id.indexOf(",") != -1) {
				for (String item : id.split(",")) {
					MActivityProductExcept activityProductExcept = new MActivityProductExcept();
					activityProductExcept.set("id", item);
					activityProductExcept.delete();
				}
			} else {
				MActivityProductExcept activityProductExcept = new MActivityProductExcept();
				activityProductExcept.set("id", getParaToInt("id"));
				activityProductExcept.delete();
			}
		}
		redirect("/activityManage/initSetting?id=" + activityId);
	}

	/**
	 * 添加活动商品
	 */
	public void addActivityProduct() {
		String activityId = getPara("activityId");
		String ids = getPara("ids");
		TProductF productF = new TProductF();
		for (String item : ids.split(",")) {
			TProductF searchProductF = productF.findById(item);
			if (searchProductF == null || "N".equals(searchProductF.getStr("is_vlid")))
				continue;
			MActivityProduct activityProduct = new MActivityProduct();
			if (activityProduct.findFirst("select * from m_activity_product where activity_id=? and product_f_id=?",
					activityId, item) == null) {
				activityProduct.set("activity_id", activityId);
				activityProduct.set("product_id", searchProductF.get("product_id"));
				activityProduct.set("dis_order", 1);
				activityProduct.set("product_f_id", item);
				activityProduct.save();
			}
		}
		redirect("/activityManage/initSetting?id=" + activityId);
	}

	/**
	 * 排除活动商品
	 */
	public void exceptActivityProduct() {
		String activityId = getPara("activityId");
		String ids = getPara("ids");
		TProductF productF = new TProductF();
		for (String item : ids.split(",")) {
			TProductF searchProductF = productF.findById(item);
			// 取消未上架商品
			if (searchProductF == null || "N".equals(searchProductF.getStr("is_vlid")))
				continue;
			MActivityProductExcept activityProductExcept = new MActivityProductExcept();
			if (activityProductExcept.findFirst(
					"select * from m_activity_product_except where activity_id=? and product_f_id=?", activityId,
					item) == null) {
				activityProductExcept.set("activity_id", activityId);
				activityProductExcept.set("product_id", searchProductF.get("product_id"));
				activityProductExcept.set("product_f_id", item);
				activityProductExcept.save();
			}
		}
		redirect("/activityManage/initSetting?id=" + activityId);
	}

	/**
	 * 异步加载活动排除商品
	 */
	public void productFExceptedList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlStr = null;

		sqlStr = "from m_activity_product_except ap " + " left join t_product_f pf on pf.id=ap.product_f_id "
				+ " left join t_product p on pf.product_id=p.id " + " left join t_image i on p.img_id=i.id "
				+ " left join t_unit u on pf.product_unit=u.unit_code " + "  where ap.activity_id="
				+ getPara("activityId");
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize,
				"select ap.id as apid,i.save_string,p.id,p.product_name,pf.price,pf.special_price,pf.product_unit,pf.standard,pf.id as pf_id,u.unit_name ",
				sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record r : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", r.get("apid"));
			row.add(r.get("apid"));
			row.add(r.get("save_string"));
			row.add(r.get("product_name"));
			row.add(r.get("price"));
			row.add(r.get("special_price"));
			row.add(r.get("id"));
			row.add(r.get("pf_id"));
			row.add(r.get("standard"));
			row.add(r.get("unit_name"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 活动商品查询(待添加)
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
		TProductF productF = new TProductF();
		Page<Record> pageInfo = productF.findTProductF(productName, productStatus, categoryId, pageSize, page, sidx,
				sord);

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
	 * 活动排除商品查询(待添加)
	 */
	public void productFExceptList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");
		String sord = getPara("sord");
		String productName = "";
		if (StringUtil.isNotNull(getPara("productExceptName"))) {
			productName = getPara("productExceptName");
		}
		String productStatus = "01";
		if (StringUtil.isNotNull(getPara("productExceptStatus"))) {
			productStatus = getPara("productExceptStatus");
		}
		int categoryId = -1;
		if (StringUtil.isNotNull(getPara("categoryIdExceptValue"))) {
			categoryId = getParaToInt("categoryIdExceptValue");
		}
		TProductF productF = new TProductF();
		Page<Record> pageInfo = productF.findTProductF(productName, productStatus, categoryId, pageSize, page, sidx,
				sord);

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
	 * 轮播图管理
	 */
	public void initMCarousel() {
		render(AppConst.PATH_MANAGE_PC + "/activity/carouselList.ftl");
	}

	public void initEditMCarousel() {
		MCarousel mCarousel = new MCarousel();
		TImage image = new TImage();
		if (StringUtil.isNotNull(getPara("id"))) {
			mCarousel = mCarousel.findById(getPara("id"));
			image = image.findById(mCarousel.get("img_id"));
		}
		setAttr("mCarousel", mCarousel);
		setAttr("image", image);
		render(AppConst.PATH_MANAGE_PC + "/activity/editCarousel.ftl");
	}

	public void saveMCarousel() {
		String imageSrc = getPara("image_src");
		Integer imageId = getParaToInt("image_id");
		MCarousel model = getModel(MCarousel.class, "mCarousel");
		// 图片已经改变
		if (imageId == 0) {
			TImage image = new TImage();
			image.set("save_string", imageSrc);
			image.save();
			model.set("img_id", image.getInt("id"));
		}
		if (StringUtil.isNull(getPara("mCarousel.id"))) {
			model.save();
		} else {
			model.update();
		}
		render(AppConst.PATH_MANAGE_PC + "/activity/carouselList.ftl");
	}

	public void getMCarouselJson() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		// 分页查询轮播图
		Page<Record> pageInfo = new MCarousel().getMCarousels(pageSize, page, sidx, sord, 0);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record tc : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", tc.get("id"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(tc.get("id"));
			row.add(tc.get("url"));
			row.add(tc.get("img_id"));
			row.add(tc.get("order_id"));
			row.add(tc.get("type_id"));
			row.add(tc.get("carousel_name"));
			row.add(tc.get("save_string"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 删除轮播图
	 */
	public void delCarousel() {
		String id = getPara("id");
		MCarousel mCarousel = new MCarousel();
		// 多个记录，批量删除
		if (id.indexOf(",") != -1) {
			for (String item : id.split(",")) {
				mCarousel = mCarousel.findById(item);
				TImage image = TImage.dao.findById(mCarousel.get("img_id"));
				if (image != null) {
					File file = new File(PathKit.getWebRootPath() + "\\" + image.getStr("save_string"));
					if (file.exists()) {
						file.delete();
					}
					image.delete();
				}
				mCarousel.delete();
			}
		} else {
			mCarousel = mCarousel.findById(id);
			TImage image = TImage.dao.findById(mCarousel.get("img_id"));
			if (image != null) {
				File file = new File(PathKit.getWebRootPath() + "\\" + image.getStr("save_string"));
				if (file.exists()) {
					file.delete();
				}
				image.delete();
			}
			mCarousel.delete();
		}
		render(AppConst.PATH_MANAGE_PC + "/activity/carouselList.ftl");
	}
	
	/**
	 * 充值bannerList
	 */
	public void getRechargeMCarouselJson(){
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		// 分页查询轮播图
		Page<Record> pageInfo = new MCarousel().getMCarousels(pageSize, page, sidx, sord, 4);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record tc : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", tc.get("id"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(tc.get("id"));
			row.add(tc.get("url"));
			row.add(tc.get("img_id"));
			row.add(tc.get("order_id"));
			row.add(tc.get("type_id"));
			row.add(tc.get("carousel_name"));
			row.add(tc.get("save_string"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	//充值活动banner图
	public void editRechargeBanner() {
        MCarousel mCarousel = new MCarousel();
        TImage image = new TImage();
        if (StringUtil.isNotNull(getPara("id"))) {
            mCarousel = mCarousel.findById(getParaToInt("id"));
            image = image.findById(mCarousel.get("img_id"));
        }
        setAttr("mCarousel", mCarousel);
        setAttr("image", image);
        render(AppConst.PATH_MANAGE_PC + "/activity/editRechargeBanner.ftl");
    }
		

	/**
	 * 初始化团购规模管理页面
	 */
	public void teamBuyScale() {
		setAttr("id", getPara("id"));
		render(AppConst.PATH_MANAGE_PC + "/activity/teamBuyScale.ftl");
	}

	public void teamBuyScaleListJson() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlStr = "from  m_team_buy_scale tbs left join "
				+ "m_activity_product ap on tbs.activity_product_id=ap.id "
				+ "left join t_product tp on ap.product_id=tp.id " + "where activity_product_id="
				+ getPara("activityProductId");
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize, "select tbs.*,tp.product_name", sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record r : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", r.get("id"));
			// 操作列，需要第一列填充空数据edittype: textarea
			row.add("");
			row.add(r.get("id"));
			row.add(r.getStr("product_name"));
			row.add(r.get("person_count"));
			row.add(r.get("activity_price_reduce"));
			row.add(r.get("team_open_times"));
			row.add(r.get("team_buy_times"));
			row.add(r.getStr("yxbz"));
			row.add(r.get("dis_order"));
			row.add(r.get("activity_product_id"));

			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 团购规模修改
	 */
	public void editTeamBuyScale() {
		MTeamBuyScale teamBuyScale = getModel(MTeamBuyScale.class, "teamBuyScale");
		if ("del".equals(getPara("oper"))) {
			teamBuyScale.set("id", getPara("id"));
			teamBuyScale.delete();
		} else if ("edit".equals(getPara("oper"))) {
			teamBuyScale.update();
		} else if ("add".equals(getPara("oper"))) {
			teamBuyScale.set("activity_product_id", getPara("activityProductId"));
			teamBuyScale.save();
		}
		redirect("/activityManage/activityList");
	}

	/**
	 * 优惠券主页面
	 */
	public void yhq() {
		//有效优惠券规模列表
		TCouponScale scale=new TCouponScale();
		List<TCouponScale> scaleList=scale.findAllValidTCouponScales();
		setAttr("scaleList",scaleList);
		
		//先查出有效的优惠券兑换码活动的编号 Type:19 
		MActivity activity=MActivity.dao.findYxActivityByType(19);
		if(activity!=null){
			setAttr("activity_id",activity.getInt("id"));
		}else{
			setAttr("activity_id",-1);//如果为0会查出其它的数据，这样显示就有错
		}
		
		//MActivity activity=MActivity.dao.findFirst("select * from m_activity m left join t_coupon_category t on m.id=t.activity_id where m.activity_type=19 ");
		
		render(AppConst.PATH_MANAGE_PC + "/activity/yhq.ftl");
	}

	/**
	 * 九宫格活动管理初始化页面
	 */
	public void initJiuGong() {
		// 活动列表用于显示用户中奖查询条件
		MActivity mActivity = new MActivity();
		setAttr("yxActivitys", mActivity.findActivityByType(13));
		render(AppConst.PATH_MANAGE_PC + "/activity/jgg.ftl");
	}

	/**
	 * 跳转到编辑九宫格活动页面
	 */
	public void editJggActivity() {
		MActivity mActivity = MActivity.dao.findById(getPara("id"));
		if (mActivity == null) {
			mActivity = new MActivity();
		}
		setAttr("activity", mActivity);
		// 查询到所有的门店列表
		setAttr("AllStore", new TStore().findAllStores());
		// 查找选中的门店
		MActivityStore existActivityStore = new MActivityStore();
		if (mActivity != null) {
			existActivityStore = new MActivityStore().findFirst("select * from m_activity_store where activity_id=?",
					getPara("id"));
		}
		setAttr("existActivityStore", existActivityStore);
		render(AppConst.PATH_MANAGE_PC + "/activity/editJggActivity.ftl");
	}

	/**
	 * 跳转到编辑九宫格奖品页面
	 */
	public void editAward() {
		MAward award = MAward.dao.findById(getPara("id"));
		TImage image = new TImage();
		if (award == null) {
			award = new MAward();
		} else {
			image = image.findById(award.getInt("img_id"));
		}
		setAttr("award", award);
		setAttr("activityId", getPara("activityId"));
		setAttr("image", image);
		// 查询到所有有效的优惠券规模
		List<TCouponScale> couponScale = new TCouponScale().findAllValidTCouponScales();
		setAttr("couponScale", couponScale);
		render(AppConst.PATH_MANAGE_PC + "/activity/editAward.ftl");
	}

	/**
	 * 保存九宫格活动
	 */
	public void saveJggActivity() {
		UUID uuid = UUID.randomUUID();
		MActivity model = getModel(MActivity.class, "activity");
		String imageSrc = getPara("image_src");
		Record record = new Record();
		record.set("uuid", uuid.toString());
		record.setColumns(model2map(model));
		record.set("activity_type", 13);

		TImage image = new TImage();
		image.set("save_string", imageSrc);
		image.save();
		record.set("img_id", image.getInt("id"));
		long activityId;
		if (StringUtil.isNull(getPara("activity.id"))) {
			Db.save("m_activity", record);
			activityId = record.getLong("id");
			// 如果此处有活动要默认抽奖次数>0 就给系统所有用户设置默认的抽奖次数
			if (record.getInt("default_cjjh_count") > 0) {
				for (int i = 0; i < record.getInt("default_cjjh_count"); i++) {
					Db.update(
							"insert into t_user_award_record (user_id,activity_id,is_valid,is_get,get_time)"
									+ " select id,?,'1','0',? from t_user ",
							activityId, DateFormatUtil.format5(new Date()));
				}
			}
		} else {
			Db.update("m_activity", record);
			activityId = getParaToLong("activity.id");
		}
		// 保存活动门店信息
		// m_activity_store
		MActivityStore activityStoreOper = new MActivityStore();
		MActivityStore existActivityStore = activityStoreOper
				.findFirst("select * from m_activity_store where activity_id=?", activityId);
		// 先删除掉活动门店
		if (existActivityStore != null) {
			existActivityStore.delete();
		}
		// 检查是否添加门店到活动
		if ("2".equals(record.getStr("scope"))) {
			MActivityStore activityStore = getModel(MActivityStore.class, "activityStore");
			activityStore.set("activity_id", activityId);
			activityStore.save();
		}
		redirect("/activityManage/initJiuGong");

	}

	/**
	 * 九宫格活动配置奖品
	 */
	public void saveJggAward() {
		MAward model = getModel(MAward.class, "award");
		String imageSrc = getPara("image_src");
		Record record = new Record();
		record.setColumns(model2map(model));

		TImage image = new TImage();
		image.set("save_string", imageSrc);
		image.save();
		record.set("img_id", image.getInt("id"));
		// 限制奖品数量
		if (StringUtil.isNull(record.getStr("amount_restriction"))) {
			record.set("amount_restriction", "1");
			record.set("remaining_num", record.getInt("award_num"));
		} else {
			record.set("award_num", 999999);
			record.set("remaining_num", 999999);
		}
		if (StringUtil.isNull(getPara("award.id"))) {
			Db.save("m_award", record);
		} else {
			Db.update("m_award", record);
		}
		redirect("/activityManage/editJggActivity?id=" + record.getInt("activity_id"));

	}

	/**
	 * 删除九宫格活动
	 */
	public void jggDelete() {
		MActivity activity = MActivity.dao.findById(getPara("id"));
		MActivityStore existActivityStore = MActivityStore.dao
				.findFirst("select * from m_activity_store where activity_id=?", activity.getInt("id"));
		// 先删除掉活动门店
		if (existActivityStore != null) {
			existActivityStore.delete();
		}
		activity.delete();
		redirect("/activityManage/initJiuGong");
	}

	/**
	 * 用户中奖记录查询列表
	 */
	public void userAwardRecordListJson() {
		// 抽奖活动
		String activityId = getPara("activityId");
		String phoneNum = getPara("phoneNum");

		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlStr = "from t_user_award_record t1 left join t_user t2 "
				+ " on t1.user_id=t2.id left join m_activity t3 on t1.activity_id=t3.id "
				+ " left join m_award t4 on t1.award_id=t4.id where is_valid='0' ";
		if (StringUtil.isNotNull(activityId)) {
			sqlStr += " and t1.activity_id= " + activityId;
		}
		if (StringUtil.isNotNull(phoneNum)) {
			sqlStr += " and t2.phone_num like '%" + phoneNum + "%'";
		}
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize,
				"select t2.phone_num,t4.award_type,t4.award_name,t1.award_time,t3.main_title,t1.is_get ", sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record r : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			row.add(r.getStr("phone_num"));
			row.add(r.get("award_type"));
			row.add(r.get("award_name"));
			row.add(r.get("award_time"));
			row.add(r.get("main_title"));
			row.add(r.getStr("is_get"));

			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 九宫格活动数据列表
	 */
	public void getJggActivityListJson() {
		String main_title = getPara("main_title");
		String yxbz = getPara("yxbz");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<MActivity> pageInfo = null;
		String sqlStr = "from m_activity where activity_type=13";
		if (StringUtil.isNull(main_title)) {
			if (StringUtil.isNull(yxbz)) {
				if (StringUtil.isNull(sidx)) {
				} else {
					sqlStr = "from m_activity activity_type=13 order by " + sidx + " " + sord;
				}
			} else {
				if (StringUtil.isNull(sidx)) {
					sqlStr = "from m_activity where activity_type=13 and yxbz='" + yxbz + "'";
				} else {
					sqlStr = "from m_activity where activity_type=13 and yxbz='" + yxbz + "' order by " + sidx + " "
							+ sord;
				}
			}
		} else {
			if (StringUtil.isNull(yxbz)) {
				if (StringUtil.isNull(sidx)) {
					sqlStr = "from m_activity where activity_type=13 and main_title like '%" + main_title + "%'";
				} else {
					sqlStr = "from m_activity where activity_type=13 and main_title like '%" + main_title
							+ "%' order by " + sidx + " " + sord;
				}
			} else {
				if (StringUtil.isNull(sidx)) {
					sqlStr = "from m_activity where activity_type=13 and main_title like '%" + main_title
							+ "%' and yxbz='" + yxbz + "'";
				} else {
					sqlStr = "from m_activity where activity_type=13 and main_title like '%" + main_title
							+ "%' and yxbz='" + yxbz + "' order by " + sidx + " " + sord;
				}
			}
		}
		pageInfo = MActivity.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MActivity pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(pa.get("id"));
			row.add(pa.get("yxq_q"));
			row.add(pa.get("yxq_z"));
			row.add(pa.get("main_title"));
			row.add(pa.get("url"));
			row.add(pa.get("yxbz"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 抽奖活动奖品列表
	 */
	public void getJggAwardRecordListJson() {
		String activityId = getPara("activityId");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlStr = "from m_award a left join t_image b on a.img_id=b.id where activity_id=" + activityId;
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize, "select a.*,b.save_string", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(pa.get("id"));
			row.add(pa.get("award_sequence"));
			row.add(pa.get("save_string"));
			row.add(pa.get("award_name"));
			row.add(pa.get("award_percent"));
			row.add(pa.get("award_type"));
			row.add(pa.get("award_num"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 异步加载优惠券规模列表
	 */
	public void getCouponScaleJson() {
		String coupon_desc = getPara("coupon_desc");// 优惠券描述
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		String is_valid = getPara("is_valid");// 是否有效
		String sqlStr = null;
		if (StringUtil.isNotNull(is_valid)) {
			sqlStr = "from t_coupon_scale where is_valid = 'Y' ";
		}else{
			sqlStr ="from t_coupon_scale where 1=1 ";
		}
		if(StringUtil.isNotNull(coupon_desc)){
			sqlStr+="and coupon_desc like '%" + coupon_desc + "%' ";
		}
		if (StringUtil.isNotNull(sidx)) {
			sqlStr+="order by "+sidx+" "+sord;
		}
		Page<TCouponScale> pageInfo = TCouponScale.dao.paginate(page, pageSize, "select * ", sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (TCouponScale tcs : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", tcs.get("id"));
			row.add("");
			row.add(tcs.get("id"));
			row.add(tcs.get("coupon_desc"));
			row.add(tcs.get("min_cost"));
			row.add(tcs.get("coupon_val"));
			row.add(tcs.get("is_valid"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 初始化优惠券规模编辑
	 */
	public void initEditCouponScale() {

		TCouponScale couponScale = TCouponScale.dao.findById(getPara("id"));
		if (couponScale == null) {
			couponScale = new TCouponScale();
		}
		if ("Y".equals(couponScale.get("is_single"))) {
			TProductF productF = TProductF.dao.findFirst(
					"select pf.id as id,p.product_name as product_name from t_product_f pf left join t_product p on pf.product_id = p.id "
					+ "where pf.id = (select product_f_id from t_product_coupon where coupon_scale_id=?)",
					couponScale.getInt("id"));
			setAttr("productF", productF);
		}
		setAttr("couponScale", couponScale);
		render(AppConst.PATH_MANAGE_PC + "/activity/editCouponScale.ftl");
	}

	/**
	 * 异步加载优惠券活动列表
	 */
	public void getCouponActivityJson() {
		// 再传一个id
		String activity_type = getPara("activity_type");
		String main_title = getPara("main_title");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		Page<MActivity> pageInfo = null;
		String sqlStr = "from m_activity where 1=1 ";
		if (StringUtil.isNotNull(activity_type)) {
			sqlStr += "and activity_type="+activity_type+" ";
		} 
		if (StringUtil.isNotNull(main_title)) {
			sqlStr += "and main_title like '%"+main_title+"%'";
		}
		pageInfo = MActivity.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MActivity pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			// 操作列，需要第一列填充空数据
			row.add(pa.get("id"));
			row.add(pa.get("main_title"));
			row.add(pa.get("yxq_q"));
			row.add(pa.get("yxq_z"));
			row.add(pa.get("url"));
			row.add(pa.get("yxbz"));
			row.add(pa.get("receive_code"));
			row.add("");
			row.add(pa.get("activity_type"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 添加/编辑 优惠券规模
	 */
	public void saveCouponScale() {

		Record record = new Record();
		record.set("coupon_desc", getPara("coupon_desc"));
		record.set("min_cost", getPara("min_cost"));
		record.set("coupon_val", getParaToInt("coupon_val"));
		record.set("is_valid", getPara("is_valid"));
		record.set("is_single", getPara("is_single"));
		if (StringUtil.isNull(getPara("id"))) {
			Db.save("t_coupon_scale", record);
			// 针对单独一种商品时候
			if ("Y".equals(getPara("is_single"))) {
				Record singleProductCoupon = new Record();
				singleProductCoupon.set("coupon_scale_id", record.getLong("id"));
				singleProductCoupon.set("product_f_id", getParaToInt("product_f_id"));
				Db.save("t_product_coupon", singleProductCoupon);
			}
		} else {
			record.set("id", getPara("id"));
			Db.update("t_coupon_scale", record);
			if ("Y".equals(getPara("is_single"))) {// 是单品优惠券
				Record singleProductCoupon = Db.findFirst("select * from t_product_coupon where coupon_scale_id=?",
						getParaToInt("id"));
				if (singleProductCoupon == null) {// 之前是全部优惠券
					singleProductCoupon = new Record();
					singleProductCoupon.set("coupon_scale_id", record.get("id"));
					singleProductCoupon.set("product_f_id", getPara("product_f_id"));
					Db.save("t_product_coupon", singleProductCoupon);
				} else {// 之前是单品优惠券
					singleProductCoupon.set("coupon_scale_id", record.get("id"));
					singleProductCoupon.set("product_f_id", getPara("product_f_id"));
					Db.update("t_product_coupon", singleProductCoupon);
				}

			} else {// 该种规模优惠券是全部优惠券
				Record singleProductCoupon = Db.findFirst("select * from t_product_coupon where coupon_scale_id=?",
						getParaToInt("id"));
				if (singleProductCoupon != null) {// 存在记录，说明之前是单品的优惠券，删除单品优惠券记录
					Db.delete("t_product_coupon", singleProductCoupon);
				}
			}
		}

		redirect("/activityManage/yhq");
	}

	/**
	 * 删除某条优惠券规模
	 */
	public void deleteCouponScale() {
		Db.deleteById("t_coupon_scale", getPara("id"));
		render(AppConst.PATH_MANAGE_PC + "/activity/yhq.ftl");
	}

	/**
	 * 删除优惠券活动
	 */
	public void delActivity() {
		String ids=getPara("ids");
		JSONObject result=new JSONObject();
		for(String id:ids.split(",")){
			long isCouponRealData=TCouponReal.dao.isCouponRealData(id);//是否已产生业务数据
			if(isCouponRealData<0){
				result.put("success", false);
				result.put("msg", "该活动已有业务数据不能删除！");
				renderJson(result);
				return;
			}
			List<TCouponCategory> couponCategorys=TCouponCategory.dao.findCouponCategoryByActivityId(id);//已关联的优惠券种类
			for(TCouponCategory couponCategory:couponCategorys){
				couponCategory.delete();
			}
			Db.deleteById("m_activity", id);
		}
		result.put("success", true);
		result.put("msg", "删除成功！");
		renderJson(result);
	}

	/**
	 * 初始化领券/返券活动编辑
	 */
	public void initEditCouponActivity() {
		MActivity activity = MActivity.dao.findById(getPara("id"));
		if (activity == null) {
			activity = new MActivity();
		}
		setAttr("activity", activity);
		render(AppConst.PATH_MANAGE_PC + "/activity/editCouponActivity.ftl");
	}
	
	/**
	 * 活动开启/关闭
	 */
	public void openOrCloseActivity(){
		String id=getPara("id");//活动id
		String status=getPara("status");
		//String type=getPara("type");//活动类型
		JSONObject result = new JSONObject();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentTime=df.format(new Date());
		MActivity activity = MActivity.dao.findById(id);
		String end_time = df.format(activity.getDate("yxq_z"));//活动结束时间
		if(activity!=null){
			if(status.equals("Y")){
				activity.set("yxbz", "N");
				result.put("success", true);
				result.put("msg", "活动已关闭！");
			}else{
				List<MActivity> activitys = MActivity.dao.find("select * from m_activity where yxbz='Y' and activity_type=? ",activity.getInt("activity_type"));
				if(activitys.size()>0){
					result.put("success", false);
					result.put("msg", "已经存在启动的活动，请先关闭其它活动！");
					renderJson(result);
					return;
				}  
				if(currentTime.compareTo(end_time)>0){
					result.put("success", false);
					result.put("msg", "活动结束时间小于当前时间，不能开启活动！");
					renderJson(result);
					return;
				}
				activity.set("yxbz", "Y");
				result.put("success", true);
				result.put("msg", "活动已开启！");
			}
			activity.update();
		}
		renderJson(result);
	}

	/**
	 * 优惠券活动添加修改
	 */
	public void saveCouponActivity() {
		MActivity activity = MActivity.dao.findById(getPara("id"));
		Record record = new Record();
		record.set("main_title", getPara("main_title"));
		record.set("activity_type", getPara("activity_type"));
		record.set("yxq_q", getPara("yxq_q"));
		record.set("yxq_z", getPara("yxq_z"));
		record.set("url", getPara("url"));
		//record.set("yxbz", "N");
		record.set("designate_product", getPara("designate_product"));

		JSONObject result = new JSONObject();

		if (StringUtil.isNull(getPara("id"))) {
			activity = new MActivity();
			activity.set("main_title", getPara("main_title"));
			activity.set("activity_type", getPara("activity_type"));
			activity.set("yxq_q", getPara("yxq_q"));
			activity.set("yxq_z", getPara("yxq_z"));
			activity.set("url", getPara("url"));
			activity.set("yxbz", "N");
			activity.set("designate_product", getPara("designate_product"));
			activity.save();
			result.put("activity", activity);
			result.put("id", activity.get("id"));
		} else {
			// 如果活动不指定商品，删除所有活动产品
			if (getPara("designate_product").equals("N")) {
				MActivityProduct.dao.deleteActivityProduct(getPara("id"));
			}
			record.set("id", getPara("id"));
			Db.update("m_activity", record);
			result.put("activity", record);
			result.put("id", getPara("id"));
		}

		result.put("success", true);
        result.put("msg","操作成功");
		renderJson(result);
	}

	/**
	 * 初始化编辑关联的优惠券,带有
	 */
	public void getCouponCategoryJson() {

		String activity_id = getPara("activity_id");

		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		String sqlStr = "from t_coupon_category where activity_id = '" + activity_id + "'";
		Page<TCouponCategory> pageInfo = null;

		pageInfo = TCouponCategory.dao.paginate(page, pageSize, "select * ", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (TCouponCategory pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(pa.get("id"));
			row.add(pa.get("coupon_desc"));
			row.add(pa.get("coupon_total"));
			row.add(pa.get("yxq"));
			row.add(pa.get("yxq_q"));
			row.add(pa.get("yxq_z"));
			row.add(pa.get("min_pay_give"));
			row.add(pa.get("give_coupon_amount"));
			row.add(pa.get("user_gain_times"));
			row.add(pa.get("yxbz"));
			row.add(pa.get("coupon_type"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 添加、修改活动关联的优惠券
	 */
	public void editCouponCategory() {
		String activity_id = getPara("activity_id");
		String id = getPara("id");
		// 若没有添加活动，则直接跳出，不做任何处理（运营应在活动时间之外提前设置好活动，避免出现不必要的麻烦）
		if (StringUtil.isNull(activity_id)) {
			return;
		}
		TCouponCategory couponCategory = getModel(TCouponCategory.class, "couponCategory");
		Record record = new Record();
		record.setColumns(model2map(couponCategory));

		if (StringUtil.isNull(id)) {
			Db.save("t_coupon_category", record);
		} else {
			Db.update("t_coupon_category", record);
		}
		render(AppConst.PATH_MANAGE_PC + "/activity/yhq.ftl");
	}

	/**
	 * 添加修改优惠券种类
	 */
	public void saveCouponCategory() {
		String user_gain_times = getPara("user_gain_times");
		String coupon_total = getPara("coupon_total");
		String activity_id = getPara("activity_id");
		String coupon_type = getPara("coupon_type");
		String yxq_q = getPara("yxq_q");
		String yxq_z = getPara("yxq_z");
		String yxq = getPara("yxq");
		String yxbz = getPara("yxbz");
		
		int min_pay_give = 0;
		int give_coupon_amount = 0;
		
		if (StringUtil.isNotNull(getPara("min_pay_give"))) {
			min_pay_give = getParaToInt("min_pay_give");
		}	
		
		if (StringUtil.isNotNull(getPara("give_coupon_amount"))) {
			give_coupon_amount = getParaToInt("give_coupon_amount");
		}

		Map<String, Object> result = new HashMap<String, Object>();

		if (StringUtil.isNull(activity_id)) {
			result.put("errcode", 1);
			result.put("errmsg", "请先添加或选择活动再进行优惠券添加操作");
			renderJson(result);
		}

		Record record = new Record();
		record.set("activity_id", activity_id);
		record.set("coupon_type", coupon_type);
		record.set("user_gain_times", user_gain_times);
		record.set("coupon_total", coupon_total);
		record.set("yxq_q", yxq_q);
		record.set("yxq_z", yxq_z);
		record.set("yxq", yxq);
		record.set("yxbz", yxbz);
		record.set("min_pay_give", min_pay_give);
		record.set("give_coupon_amount", give_coupon_amount);
		// 根据有无id来判定是修改还是添加
		if (StringUtil.isNull(getPara("id"))) {
			// 添加记录
			TCouponScale couponScale = TCouponScale.dao.findById(getPara("couponScale_id"));
			couponScale.get("coupon_desc");
			couponScale.get("min_cost");
			couponScale.get("coupon_val");
			record.set("coupon_scale_id", couponScale.get("id"));
			record.set("coupon_desc", couponScale.get("coupon_desc"));
			record.set("coupon_val", couponScale.get("coupon_val"));
			record.set("min_cost", couponScale.get("min_cost"));
			Db.save("t_coupon_category", record);
			// TODO去生成真实的优惠券
			createCoupon(record);
		} else {
			// 数量只能增加
			record.set("id", getPara("id"));
			// 查找之前有多少张
			Record countRecord = Db.findFirst("select count(*) as count from t_coupon_real where coupon_category_id =?",
					getPara("id"));
			long count = countRecord.getLong("count");
			Db.update("t_coupon_category", record);
			Record recordCategory = Db.findFirst(
					"select id,coupon_desc,coupon_val,min_cost,coupon_scale_id from t_coupon_category where id =? ",
					getPara("id"));
			// 领券生成优惠券
			if (!coupon_total.equals("/")) {
				// 说明不限量，固生成需要的数量
				String coupon_desc = recordCategory.get("coupon_desc");
				int coupon_val = recordCategory.get("coupon_val");
				int min_cost = recordCategory.get("min_cost");
				String start_time = record.get("yxq_q");
				String end_time = record.get("yxq_z");
				Record couponRecord = new Record();
				couponRecord.set("coupon_category_id", record.get("id"));
				couponRecord.set("coupon_scale_id", recordCategory.get("coupon_scale_id"));
				couponRecord.set("activity_id", activity_id);
				couponRecord.set("coupon_desc", coupon_desc);
				couponRecord.set("coupon_val", coupon_val);
				couponRecord.set("min_cost", min_cost);
				couponRecord.set("start_time", start_time);
				couponRecord.set("end_time", end_time);
				couponRecord.set("status", "0");
				couponRecord.set("yxbz", "Y");
				// 生成多少条
				if (Integer.parseInt(coupon_total) > count) {// 增加
					for (int i = 0; i < Integer.parseInt(coupon_total) - count; i++) {
						Db.save("t_coupon_real", couponRecord);
						couponRecord.remove("id");
					}
					System.out.println("领券限总量优惠券数量添加完毕");
				} else if (Integer.parseInt(coupon_total) < count) {// 减少
					List<String> sqlList = new ArrayList<>();
					sqlList.add("delete from t_coupon_real where status=0 and coupon_category_id = "
							+ recordCategory.get("id") + " limit 1");

					for (int i = 0; i < count - Integer.parseInt(coupon_total); i++) {
						Db.batch(sqlList, 1);

					}
					System.out.println("领券限总量优惠券数量减少完毕");
				}

			}

		}
		
		result.put("errcode", 0);
		result.put("errmsg", "操作成功");
		renderJson(result);
		
	}

	/**
	 * 删除活动关联的优惠券
	 */
	public void delCouponCategory() {
		// XXX: 改用ajax提交，目前界面刷新，导致没有选中活动
		Db.deleteById("t_coupon_category", getPara("id"));
		Map<Object, String> result = new HashMap<Object, String>();
		result.put("success", "success");
		result.put("msg", "删除成功");
		result.put("id", "id");
		renderJson(result);
	}

	/**
	 * 手动发券按钮跳转
	 */
	public void manualReleaseCoupon() {
		//有效优惠券规模列表
		TCouponScale scale=new TCouponScale();
		List<TCouponScale> scaleList=scale.findAllValidTCouponScales();
		setAttr("scaleList",scaleList);
		render(AppConst.PATH_MANAGE_PC + "/activity/manualReleaseCoupon.ftl");
	}

	/**
	 * 生成真实优惠券
	 */
	public void createCoupon(Record record) {
		// 领券生成优惠券
		String coupon_total = record.get("coupon_total");

		if (!coupon_total.equals("/")) {
			// 说明不限量，固生成需要的数量
			// int coupon_category_id = record.get("id");
			String activity_id = record.get("activity_id");
			String coupon_desc = record.get("coupon_desc");
			int coupon_val = record.get("coupon_val");
			int min_cost = record.get("min_cost");
			String start_time = record.get("yxq_q");
			String end_time = record.get("yxq_z");
			Record couponRecord = new Record();
			couponRecord.set("coupon_category_id", record.get("id"));
			couponRecord.set("coupon_scale_id", record.get("coupon_scale_id"));
			couponRecord.set("activity_id", activity_id);
			couponRecord.set("coupon_desc", coupon_desc);
			couponRecord.set("coupon_val", coupon_val);
			couponRecord.set("min_cost", min_cost);
			couponRecord.set("start_time", start_time);
			couponRecord.set("end_time", end_time);
			couponRecord.set("status", "0");
			couponRecord.set("yxbz", "Y");
			// 有待优化
			// Db.batch(sql, paras, batchSize);
			for (int i = 0; i < Integer.parseInt(coupon_total); i++) {
				Db.save("t_coupon_real", couponRecord);
				couponRecord.remove("id");
			}
			System.out.println("领券限总量优惠券生成完毕");
		} else {
			System.out.println("该种类优惠券不限量，固不生成");
		}
	}

	public void releaseCoupon() {
		
		String yxq_q = getPara("yxq_q");
		String yxq_z = getPara("yxq_z");
		String file_path = getPara("file_path");
		String scale_id = getPara("coupon_scale_id");	
		String couponNum=getPara("give_coupon_amount");
		int acid=0;
		int coupon_number=0;
	    JSONObject result = new JSONObject();
	    
	    //查出有效的手动发券活动的id-Type=12
	    MActivity activity=MActivity.dao.findYxActivityByType(12);
        if(activity!=null){
        	acid=activity.getInt("id");
        }else{
        	result.put("success",false);
    		result.put("msg", "请先创建一条有效的手动发券活动再进行后续操作");
    		renderJson(result);
    		return;
        }
		// 存储发放失败名单
		List<String> fail_phone = new ArrayList<String>();
		// 找到关联的优惠券规模
		TCouponScale couponScale = TCouponScale.dao.findById(scale_id);
		// 确定发几张
		if(StringUtil.isNotNull(couponNum)){
			coupon_number=Integer.parseInt(couponNum);
		}
		// 生成真实优惠券
		TCouponReal couponReal = new TCouponReal();
		couponReal.set("activity_id", acid);
		couponReal.set("coupon_scale_id", couponScale.get("id"));
		couponReal.set("give_type", 3);//3-手动发券
		couponReal.set("coupon_desc", couponScale.get("coupon_desc"));
		couponReal.set("coupon_val", couponScale.get("coupon_val"));
		couponReal.set("min_cost", couponScale.get("min_cost"));
		couponReal.set("start_time", yxq_q);
		couponReal.set("end_time", yxq_z);
		couponReal.set("status", 1);
		
		// 插入用户优惠券记录
		TUserCoupon userCoupon = new TUserCoupon();
		userCoupon.set("is_expire", 0);
		userCoupon.set("title", couponScale.get("coupon_desc"));
	    userCoupon.set("activity_id", acid);
		userCoupon.set("create_time", DateFormatUtil.format1(new Date()));
		
		// 读取要发送的用户名单
		List<String> phoneList=ExcelUtil.getColData(file_path);
		
		for(String phone:phoneList){
			// 匹对电话号码,查看是否有，没有就存起来
			TUser user =TUser.dao.findFirst("select * from t_user where phone_num = ?", phone);
			if (user != null) {
				// 发放优惠券，并记录到用户优惠券中
				for (int j = 0; j < coupon_number; j++) {
					couponReal.save();
					userCoupon.set("user_id", user.get("id"));
					userCoupon.set("coupon_id", couponReal.get("id"));
					userCoupon.save();
					// 清除生成的ID，否则因为id相同插入报错
					couponReal.remove("id");
					userCoupon.remove("id");
					userCoupon.remove("user_id");
					userCoupon.remove("coupon_id");
				}
			} else {
				// 存入号码
				fail_phone.add(phone);
			}
		}
		result.put("success",true);
		result.put("msg", "发放成功");
		result.put("fail_phone", fail_phone);
		renderJson(result);
	}
	
	public void initGive() {
        render(AppConst.PATH_MANAGE_PC + "/coupon/giveCouponActivity.ftl");
    }
	
	/**
	 * 兑换码真实优惠券列表
	 */
	public void getCouponRealCode() {
		String coupon_code = getPara("coupon_code");
		String status = getPara("status");
		String category_id=getPara("category_id");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");
		String sord = getPara("sord");
		String sqlStr ="from t_coupon_real t left join t_user_coupon t1 on t.id=t1.coupon_id "+ 
        " left join t_user t2 on t1.user_id=t2.id where t.coupon_category_id="+category_id;
		if(StringUtil.isNotNull(coupon_code)){
			sqlStr+=" and t.coupon_code='"+coupon_code+"' ";
		}
		if(StringUtil.isNotNull(status)){
			sqlStr+=" and t.status="+status;
		}
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by "+sidx+" "+sord;
		}
		Page<Record> pageInfo = Db.paginate(page, pageSize, "select t.coupon_code,t.status,t2.phone_num,t1.used_time ", sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			row.add(pa.get("coupon_code"));
			row.add(pa.get("status"));
			row.add(pa.get("phone_num"));
			row.add(pa.get("used_time"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * 优惠券兑换码活动列表
	 */
	public void getCouponCodeActivity(){
		String yxbz = getPara("yxbz");
		String beginTime=getPara("yxq_q");
		String endTime=getPara("yxq_z");
		String main_title = getPara("main_title");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String select="select m.id,m.main_title,t.coupon_desc,m.yxq_q,m.yxq_z,t.coupon_total,m.yxbz,t.id as coupon_category_id,m.activity_type ";
		String from ="from m_activity m left join t_coupon_category t on t.activity_id=m.id ";
			   from +="where m.activity_type=19 ";
	    if(StringUtil.isNotNull(main_title)){
	    	from +="and m.main_title like '%"+main_title+"%' ";
	    }
	    if(StringUtil.isNotNull(yxbz)){
	    	from +="and m.yxbz='"+yxbz+"' ";
	    }
	    if(StringUtil.isNotNull(beginTime)&&StringUtil.isNotNull(endTime)){
	    	from +="and m.yxq_q<='"+beginTime+"' and m.yxq_z>='"+beginTime+"' ";
	    	from +="and m.yxq_q<='"+endTime+"' and m.yxq_z>='"+endTime+"' ";
	    }
	    Page<TCouponCategory> pageInfo = TCouponCategory.dao.paginate(page, pageSize, select, from);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (TCouponCategory pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("main_title"));
			row.add(pa.get("coupon_desc"));
			row.add(pa.get("yxq_q"));
			row.add(pa.get("yxq_z"));
			row.add(pa.get("coupon_total"));
			row.add(pa.get("yxbz"));
			// 操作列，需要第一列填充空数据
			row.add("");
			row.add(pa.get("coupon_category_id"));
			row.add(pa.get("activity_type"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * 异步加载优惠券兑换码活动列表
	 */
	/*public void getCouponCodeJson() {
		String activity_id = getPara("activity_id");
		String main_title = getPara("main_title");
		String yxbz = getPara("yxbz");
		String beginTime=getPara("yxq_q");
		String endTime=getPara("yxq_z");		
		
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");
		String sord = getPara("sord");
		
		String sqlStr ="from t_coupon_category where activity_id="+activity_id+" ";
		
		if(StringUtil.isNotNull(main_title)){
			sqlStr+="and main_title like '%"+main_title+"%' ";
		}
		
		if(StringUtil.isNotNull(yxbz)){
			sqlStr+="and yxbz='"+yxbz+"' ";
		}
		
		if(StringUtil.isNotNull(beginTime)&&StringUtil.isNotNull(endTime)){
			sqlStr+="and yxq_q<='"+beginTime+"' and yxq_z>='"+beginTime+"' ";
			sqlStr+="and yxq_q<='"+endTime+"' and yxq_z>='"+endTime+"' ";
		}
		
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += "order by "+sidx+" "+sord;
		}
	    
		Page<TCouponCategory> pageInfo = TCouponCategory.dao.paginate(page, pageSize, "select * ", sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (TCouponCategory pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("main_title"));
			row.add(pa.get("coupon_desc"));
			row.add(pa.get("yxq_q"));
			row.add(pa.get("yxq_z"));
			row.add(pa.get("coupon_total"));
			row.add(pa.get("yxbz"));
			// 操作列，需要第一列填充空数据
			row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}*/
	
	/**
	 * 兑换码活动开启关闭
	 */
	public void changeCodeStatus() {
		String activity_id = getPara("id");
		String status = getPara("status");
		JSONObject result = new JSONObject();
		MActivity activity = MActivity.dao.findById(activity_id);
		String end_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(activity.getDate("yxq_z"));//活动结束时间
		String currentTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
		if (StringUtil.isNotNull(activity_id)&&StringUtil.isNotNull(status)) {
			if(status.equals("Y")){
				Db.update("update m_activity set yxbz='N' where id=? ",activity_id);
				Db.update("update t_coupon_category set yxbz='N' where activity_id=? ",activity_id);
			}else{
				if(currentTime.compareTo(end_time)>0){
					result.put("success", false);
					result.put("msg", "当前日期大于活动结束时间，则不能开启活动!");
					renderJson(result);
					return;
				}
				Db.update("update m_activity set yxbz='Y' where id=? ",activity_id);
				Db.update("update t_coupon_category set yxbz='Y' where activity_id=? ",activity_id);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		}else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * 兑换码活动开启关闭
	 */
	/*public void changeCodeStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int acid=Integer.parseInt(id);	
			if(status.equals("Y")){
				Db.update("update t_coupon_category set yxbz='N' where id="+acid);
			}else{
				Db.update("update t_coupon_category set yxbz='Y' where id="+acid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}*/
	
	/**
	 * 兑换码活动删除
	 */
	public void delCouponCodeActivity() {
	    String ids = getPara("ids");//活动id
	    JSONObject result = new JSONObject();
	    for(String id : ids.split(",")) {
			List<TCouponReal> isCouponReceive=TCouponReal.dao.find("select * from t_coupon_real where activity_id=? and status=1", id);
			if(isCouponReceive.size()>0){
				result.put("success", false);
				result.put("msg", "该种类的优惠券已有业务数据产生！");
				renderJson(result);
				return;
			}
			Db.deleteById("m_activity", id);
			TCouponCategory couponCategory = TCouponCategory.dao.findFirst("select * from t_coupon_category where activity_id=?", id);
			if(couponCategory!=null){
				couponCategory.delete();
			}
			List<TCouponReal> couponReals=TCouponReal.dao.find("select * from t_coupon_real where activity_id=? ", id);
			if(couponReals.size()>0){
				for(TCouponReal couponReal:couponReals){
					couponReal.delete();
				}
			}else{
				result.put("success", false);
				result.put("msg", "改期活动删除成功，但兑换码优惠券无数据！");
				renderJson(result);
				return;
			}
		}
	    result.put("success", true);
		result.put("msg", "删除成功！");
	    renderJson(result);
	}
	
	/**
	 * Ajax删除兑换码活动 
	 */
	/*public void delCodeAjax() {
	    String ids = getPara("ids");
	    String acid=getPara("acid");
		JSONObject result = new JSONObject();
		String sql = "delete from t_coupon_category where id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
			
			idArr=ids.split(",");
			
			if(StringUtil.isNotNull(acid)){
		    	int aid=Integer.parseInt(acid);
		    	if(idArr.length==1){
		    		Record obj=Db.findFirst("select * from t_coupon_real where activity_id=? and coupon_category_id=? and status=1 "
			    			,aid,idArr[0]);
			    	if(obj!=null){
			    		result.put("success", false);
						result.put("msg", "有业务数据产生,不允许删除相关数据");
						renderJson(result);
						return;
			    	}else{
			    		//先删除掉关联的真实优惠券
						Db.update("delete from t_coupon_real where activity_id=? and coupon_category_id=?",aid,idArr[0]);
			    		Db.update(sql+idArr[0]);  	
			    	}
		    	}else{
			    	for (int i = 0; i < idArr.length; i++) {
				    	Record obj=Db.findFirst("select * from t_coupon_real where activity_id=? and coupon_category_id=? and status=1 "
				    			,aid,idArr[i]);
				    	if(obj!=null){
				            //如果批量删除，有一条产生了数据都不允许删除
				    		result.put("success", false);
							result.put("msg", "有业务数据产生,不允许删除相关数据");
							renderJson(result);
							return;
				    	}else{
				    		//先删除掉关联的真实优惠券
				    		Db.update("delete from t_coupon_real where activity_id=? and coupon_category_id=?",aid,idArr[i]);
						    Db.update(sql+idArr[i]);
				    	}
			    	}
			    	
		    	}
		    	result.put("success", true);
				result.put("msg", "删除成功");
		    }
			
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}*/
	
	/**
	 * 查看优惠券兑换码活动详情
	 */
	public void codeDetail(){
		 String activity_id=getPara("id");
		 JSONObject result = new JSONObject();
		 if(StringUtil.isNotNull(activity_id)){
			 String sql="select t.user_gain_times,t.activity_id,t.id,m.main_title,t.coupon_desc,m.yxq_q,m.yxq_z,t.coupon_total,m.yxbz,t.coupon_scale_id,t.yxq from m_activity m "
			 		+ "left join t_coupon_category t on t.activity_id=m.id "
			 		+ "where m.activity_type=19 and m.id=? ";
			 MActivity activity =MActivity.dao.findFirst(sql,activity_id);
			 if(activity!=null){					 
				 result.put("success", true);
				 result.put("data", activity);
				 result.put("msg", "查询成功");
			 }else{
				 result.put("success", false);
				 result.put("msg", "未查到此条记录");
			 }
		 }else{
			 result.put("success", false);
			 result.put("msg", "参数id为null");
		 }
		 renderJson(result);
	}
	
	/**
	 * 查看优惠券兑换码活动
	 */
	/*public void codeDetail(){
		 String sid=getPara("id");
		 JSONObject result = new JSONObject();
		 
		 if(StringUtil.isNotNull(sid)){
			 int id=Integer.parseInt(sid);
			 String sql="select * from t_coupon_category where id="+id;
			 TCouponCategory category =TCouponCategory.dao.findFirst(sql);
			 
			 if(category!=null){					 
				 result.put("success", true);
				 result.put("data", category);
				 result.put("msg", "查询成功");
			 }else{
				 result.put("success", false);
				 result.put("msg", "未查到此条记录");
			 }
		 }else{
			 result.put("success", false);
			 result.put("msg", "参数id为null");
		 }
		 renderJson(result);
	}*/
	
	/**
	 * 添加/修改兑换码活动
	 */
	public void saveCodeActivity(){
		JSONObject result = new JSONObject();
		String yxq_q = getPara("yxq_q");
		String yxq_z = getPara("yxq_z");
		String yxq = getPara("yxq");
		String scale_id=getPara("coupon_scale_id");
		String main_title=getPara("main_title");
		String activity_id=getPara("activity_id");
		Record couponCategory = new Record();
		couponCategory.set("main_title", main_title);
		couponCategory.set("yxq_q", yxq_q);
		couponCategory.set("yxq_z", yxq_z);
		couponCategory.set("user_gain_times", getParaToInt("user_gain_times"));
		couponCategory.set("give_type", "4");
		if(StringUtil.isNull(activity_id)){
			//兑换码活动添加
			MActivity activity = new MActivity();
			activity.set("main_title", main_title);
			activity.set("yxq_q", yxq_q);
			activity.set("yxq_z", yxq_z);
			activity.set("yxbz", "N");
			activity.set("activity_type", 19);
			activity.set("designate_product", "N");//是否指定商品消费后才能返券，默认N
			activity.save();
			couponCategory.set("activity_id", activity.getInt("id"));
			couponCategory.set("coupon_total", getPara("coupon_total"));
			couponCategory.set("yxq", yxq);
			couponCategory.set("coupon_scale_id", scale_id);
			TCouponScale couponScale = TCouponScale.dao.findById(getPara("coupon_scale_id"));
			couponCategory.set("coupon_desc", couponScale.get("coupon_desc"));
			couponCategory.set("coupon_val", couponScale.get("coupon_val"));
			couponCategory.set("min_cost", couponScale.get("min_cost"));
			Db.save("t_coupon_category", couponCategory);
			//TODO 去生成真实的优惠券--先生成唯一的兑换码
			TCouponReal.createRealCoupon(couponCategory);
			result.put("success", true);
			result.put("msg", "添加成功");
		}else{
			//兑换码活动修改
			MActivity activity = MActivity.dao.findById(activity_id);
			activity.set("main_title", main_title);
			activity.set("yxq_q", yxq_q);
			activity.set("yxq_z", yxq_z);
			activity.update();
			couponCategory.set("id", getPara("id"));
			//更新起止时间时 还需要同步更新关联的未领取的优惠券的起止时间
			List<TCouponReal> couponrealList=TCouponReal.dao.find("select * from t_coupon_real where activity_id=? and coupon_category_id=? and status=0",activity_id,getPara("id"));
			//如果未被领取则更新，如果已被领取，不更新优惠券的起止时间 
			for(TCouponReal item:couponrealList){
				item.set("start_time",yxq_q);
				item.set("end_time",yxq_z); 
				item.update();
			}
			Db.update("t_coupon_category", couponCategory);
			result.put("success", true);
			result.put("msg", "修改成功");
		}
		renderJson(result);
	}
	
	/**
	 * 保存兑换码活动
	 *//*
	public void saveCodeActivity1() {
		JSONObject result = new JSONObject();
		String yxq_q = getPara("yxq_q");
		String yxq_z = getPara("yxq_z");
		String yxq = getPara("yxq");
		String scale_id=getPara("coupon_scale_id");
		String acid=getPara("activity_id");
		
		if (StringUtil.isNull(acid) || acid.equals("0")) {
			result.put("success", false);
			result.put("msg", "请先添加一条有效的优惠券兑换码活动再进行后续操作");
			renderJson(result);
			return;
		}
		
		Record record = new Record();
        record.set("main_title",getPara("main_title"));
        record.set("yxq_q", getPara("yxq_q"));
        record.set("yxq_z",getPara("yxq_z"));       
		record.set("activity_id", acid);
		
		if (StringUtil.isNull(getPara("id"))) {
			record.set("coupon_scale_id", scale_id);
	        record.set("yxq", yxq);
	        record.set("coupon_total", getPara("coupon_total"));
			//冗余规模表里的某些字段
			TCouponScale couponScale = TCouponScale.dao.findById(getPara("coupon_scale_id"));
			record.set("coupon_desc", couponScale.get("coupon_desc"));
			record.set("coupon_val", couponScale.get("coupon_val"));
			record.set("min_cost", couponScale.get("min_cost"));
			
			Db.save("t_coupon_category", record);
			// TODO去生成真实的优惠券--先生成唯一的兑换码
			//createRealCoupon(record);
			result.put("success", true);
			result.put("msg", "添加成功");
		} else {
			record.set("id", getPara("id"));
			//更新起止时间时 还需要同步更新关联的未领取的优惠券的起止时间
			List<TCouponReal> couponrealList=TCouponReal.dao.find("select * from t_coupon_real where activity_id=? and coupon_category_id=? and status=0",acid,getPara("id"));
			
			//TODO:批量更新 db.batch
			//如果未被领取则更新，如果已被领取，不更新优惠券的起止时间 
			for(TCouponReal item:couponrealList){
				item.set("start_time",yxq_q);
				item.set("end_time",yxq_z); 
				item.update();
			}
			
			Db.update("t_coupon_category", record);
			result.put("success", true);
			result.put("msg", "修改成功");
		}
		renderJson(result);
	}*/
	
	
	
	/**
     * 充值记录导出
     */
    public void exportCouponCode(){
    	String code=null,activityId=null,status=null,categoryId=null;
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        
        //TODO:有待优化
    	activityId=formDataJson.getJSONObject(0).getString("activity_id");
    	categoryId=formDataJson.getJSONObject(1).getString("coupon_category_id");
    	code=formDataJson.getJSONObject(2).getString("coupon_code");
    	status=formDataJson.getJSONObject(3).getString("status");
       
    	String sqlStr ="select t.coupon_code,case t.status when 0 then '未领取' when 1 then '已领取' when 2 then '已使用' end as status,"
    			+ " ifnull(t2.phone_num,'N/A') as phone_num,ifnull(t1.used_time,'N/A') as used_time from t_coupon_real t "
    			+ " left JOIN t_user_coupon t1 on t.id=t1.coupon_id " 
    	        + " left JOIN t_user t2 on t1.user_id=t2.id where t.activity_id="+activityId;
    	        
		if(StringUtil.isNotNull(categoryId)){
			sqlStr+=" and t.coupon_category_id="+categoryId;
		}
        
		if(StringUtil.isNotNull(code)){
			sqlStr+=" and t.coupon_code='"+code+"' ";
		}
		
		if(StringUtil.isNotNull(status)){
			sqlStr+=" and t.status="+status;
		}
				
    	List<Record> list = Db.find(sqlStr);
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="CouponCodeList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(DateUtil.convertDate2String(new Date())+"优惠券码导出").columns(columns);
        render(poirender);
    }
    
    /**
     * 初始化二维码抽奖列表
     */
    public void initTwoCodeList(){
    	render(AppConst.PATH_MANAGE_PC + "/activity/twoCodeList.ftl");
    }
    
    /**
     * 二维码抽奖奖品设置列表
     */
    public void twoCodeList(){
    	int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sql="select t.id,t.award_name,t1.save_string,t.award_percent,t.award_sequence,award_type ";
		String from= "from m_hd_award t left join t_image t1 on t.img_id=t1.id";
		Page<MHdAward> pageInfo = MHdAward.dao.paginate(page, pageSize, sql, from);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (MHdAward pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("award_name"));
			row.add(pa.get("save_string"));
			row.add(pa.get("award_percent"));
			row.add(pa.get("award_sequence"));
			row.add(pa.get("award_type"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
    }
    
    /**
     * 二维码抽奖奖品添加/编辑
     */
    public void initTwoCodeEdit(){
    	String id=getPara("id");
    	List<TCouponScale> couponScaleList = TCouponScale.dao.find("select id,coupon_desc from t_coupon_scale where is_valid='Y' ");
    	if(StringUtil.isNotNull(id)){
    		MHdAward award=MHdAward.dao.findFirst("select t.id, t.award_name,t.img_id,t1.save_string,t.award_percent,t.award_sequence,"
    				+ "t.coupon_vali_date,t.pf_id,t.award_type,t.coin_count,t.coupon_scale_id from m_hd_award t "
    				+ "left join t_image t1 on t.img_id=t1.id where t.id=? ",id);
    		setAttr("award", award);
    	}
    	setAttr("couponScaleList", couponScaleList);
    	render(AppConst.PATH_MANAGE_PC + "/activity/twoCode.ftl");
    }
    
    /**
     * 二维码抽奖修改/保存
     */
    public void saveTwoCode(){
    	MHdAward award=getModel(MHdAward.class,"award");
    	String id=getPara("id");
    	String image_src=getPara("image_src");
    	if(StringUtil.isNotNull(image_src)){
    		if(award.getInt("img_id")==null){
    			TImage image =new TImage();
    			image.set("save_string", image_src);
    			image.save();
    			award.set("img_id", image.getInt("id"));
    		}else{
    			TImage img=TImage.dao.findById(award.getInt("img_id"));
    			img.set("save_string", image_src);
    			img.update();
    		}
    	}
    	if(StringUtil.isNull(id)){
    		if(award.getStr("award_type").equals("2")){
    			award.set("coupon_scale_id", getParaToInt("coupon_scale_id"));
    		}
    		award.save();
    	}else{
    		//TCouponScale.dao.updateInfo1(model2map(award), Integer.parseInt(id), "m_hd_award");
    		Db.update("update m_hd_award set award_name=?,award_percent=?,coin_count=?,pf_id=?,award_sequence=?,award_type=?,"
    				+ "coupon_scale_id=?,coupon_vali_date=?,img_id=? where id=?", award.getStr("award_name"),award.getDouble("award_percent")
    				,award.getInt("coin_count"),award.getInt("pf_id"),award.getInt("award_sequence"),award.getStr("award_type"),getParaToInt("coupon_scale_id")
    				,award.getInt("coupon_vali_date"),award.getInt("img_id"),Integer.parseInt(id));
    	}
    	render(AppConst.PATH_MANAGE_PC + "/activity/twoCodeList.ftl");
    }
    
    
}
