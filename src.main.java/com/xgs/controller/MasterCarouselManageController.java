package com.xgs.controller;

import java.io.File;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.PathKit;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MCarousel;
import com.sgsl.model.TImage;
import com.sgsl.util.StringUtil;
/**
 * 鲜果师轮播图管理
 * @author User
 *
 */
public class MasterCarouselManageController extends BaseController{
	protected final static Logger logger = Logger.getLogger(MasterCarouselManageController.class);
	/**
	 * 轮播图列表
	 */
	public void carouselList(){
		render(AppConst.PATH_MANAGE_PC + "/masterSys/activityManage/carouselList.ftl");
	}
	
	/*public void carouselAjax(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
		int master_status=-1;
		if(StringUtil.isNotNull(getPara("master_status"))){
			master_status=getParaToInt("master_status");
		}
		String createDateBegin=getPara("createDateBegin");
		String createDateEnd=getPara("createDateEnd");
		String masterName=getPara("masterName");
		
		XFruitMaster xFruitMaster = new XFruitMaster();
		Page<Record> pageInfo=xFruitMaster.findMasterAndUpMaster(pageSize, page, createDateBegin, 
				createDateEnd, master_status, masterName);
		
		JSONObject result=new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		
		JSONArray rows=new JSONArray();
		for(Record rc:pageInfo.getList()){
			JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getInt("id"));
            row.add(rc.getStr("mobile"));
            row.add(rc.get("master_name"));
            row.add(rc.getStr("create_time"));
            row.add(rc.get("head_image"));
            row.add(rc.get("upName"));
            row.add(rc.get("master_status"));
            
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
	}
*/	

	public void initEditMCarousel() {
		MCarousel mCarousel = new MCarousel();
		TImage image = new TImage();
		if (StringUtil.isNotNull(getPara("id"))) {
			mCarousel = mCarousel.findById(getPara("id"));
			image = image.findById(mCarousel.get("img_id"));
		}
		mCarousel.set("type_id", getParaToInt("type_id"));
		setAttr("mCarousel", mCarousel);
		setAttr("image", image);
		render(AppConst.PATH_MANAGE_PC + "/masterSys/activityManage/editCarousel.ftl");
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
		redirect("/masterCarouselManage/carouselList");
	}

	public void getMCarouselJson() {

		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		int type_id = getParaToInt("type_id");
		// 分页查询轮播图
		Page<Record> pageInfo = new MCarousel().getMCarousels(pageSize, page, sidx, sord, type_id);

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
		if ("del".equals(getPara("oper"))) {
			String id = getPara("id");
			// 多个记录，批量删除
			if (id.indexOf(",") != -1) {
				for (String item : id.split(",")) {
					MCarousel mCarousel = new MCarousel();
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
				MCarousel mCarousel = new MCarousel();
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
		}
		render(AppConst.PATH_MANAGE_PC + "/activity/carouselList.ftl");
	}

}
