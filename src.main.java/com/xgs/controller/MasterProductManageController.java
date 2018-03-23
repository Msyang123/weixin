package com.xgs.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.PathKit;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.mongodb.util.Hash;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.TCategory;
import com.sgsl.model.TImage;
import com.sgsl.util.StringUtil;
import com.xgs.model.TProduct;
import com.xgs.model.TProductF;

public class MasterProductManageController extends BaseController{
	 protected final static Logger logger = Logger.getLogger(MasterProductManageController.class);

	/**
	 * 初始化商品列表
	 */
	public void initProductList() {
        render(AppConst.PATH_MANAGE_PC + "/masterSys/productManage/productList.ftl");
    }
	
	/**
	 * 后台商品列表查询
	 */
	public void productList(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Boolean isNutritionPage = getParaToBoolean("isNutritionPage");
        String isNutrition = getPara("isNutrition");
        String productName="";
        if(StringUtil.isNotNull(getPara("productName"))){
        	productName=getPara("productName");
        }
        String productStatus="01";
        if(StringUtil.isNotNull(getPara("productStatus"))){
        	productStatus=getPara("productStatus");
        }
        int categoryId=-1;
        if(StringUtil.isNotNull(getPara("categoryIdValue"))){
        	categoryId=getParaToInt("categoryIdValue");
        }
        TProduct product=new TProduct();
        Page<Record> pageInfo=product.findTProduct(productName,productStatus,categoryId,
        		pageSize, page, sidx, sord,isNutritionPage,isNutrition);


        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            if(isNutritionPage==true){
            	json.put("id",rc.getInt("pf_id"));
            	row.add(rc.getInt("pf_id"));
            }else{
            	json.put("id",rc.getInt("id"));
            	row.add(rc.getInt("id"));
            }
            row.add(rc.getStr("product_status"));
            row.add(rc.getStr("product_name"));
            row.add(rc.getStr("category_name"));
            row.add(rc.getStr("save_string"));
            row.add(rc.getStr("unit_name"));
            row.add(rc.getDouble("product_amount"));
            row.add(rc.getStr("product_unit"));
            row.add(rc.getStr("standard"));
            row.add(rc.getInt("price"));
            row.add(rc.getInt("special_price"));
            row.add(rc.getStr("is_vlid"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	
	/**
	 * 初始化商品编辑页
	 */
	public void initSave(){
    	TProduct product=null;
    	TCategory category=null;
    	TImage image=null;
    	if(StringUtil.isNull(getPara("id"))){
    		//添加
    		product=new TProduct();
    		category=new TCategory();
    		image=new TImage();
    	}else{
    		//修改
    		int id=getParaToInt("id");
    		//删除的规格不存在规格编号，故此时传递产品编号
    		product=TProduct.dao.findById(id);
    		category=TCategory.dao.findFirst("select * from t_category where category_id=?",
    				product.getStr("category_id"));
    		image=TImage.dao.findById(product.getInt("img_id"));
    	}
    	setAttr("product", product);
    	setAttr("category",category);
    	setAttr("image", image);
    	//设置商品的规格列表
    	List<Record> unitList=Db.find("select * from t_unit");
    	boolean flag=false;
    	StringBuffer sb =new StringBuffer();
    	for(int i=0;i<unitList.size();i++){
    		if(flag){
    			sb.append(";");
    		}
    		sb.append(unitList.get(i).getStr("unit_code"));
    		sb.append(":");
    		sb.append(unitList.get(i).getStr("unit_name"));
    		flag=true;
    	}
    	setAttr("unitList",unitList);
    	setAttr("unitList1",sb.toString());
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/productManage/editProduct.ftl");
    }
	
	public void productSave(){
    	TImage image = getModel(TImage.class,"image");
    	if(image.get("id")==null){
    		image.save();
    	}else{
    		//存储图片优化，如果图片修改过了,删除掉原来的图片
    		TImage imageOper=new TImage();
    		TImage imgOld=imageOper.findById(image.get("id"));
    		String saveStr=imgOld.getStr("save_string");
    		if(StringUtil.isNotNull(saveStr)&&!imgOld.getStr("save_string").equals(image.getStr("save_string"))){
    			try{
    				int attachedIndex=saveStr.indexOf("attached");
    				if(attachedIndex!=-1){
    					//去掉字符weixin
    					saveStr=saveStr.substring(attachedIndex);
    				}
	    			File file=new File(PathKit.getWebRootPath()+"\\"+saveStr);
	    			if(file.exists()){
	    				file.delete();
	    			}
	    		}catch(Exception e){
					this.logger.error(e.getMessage());
				}
    		}
    		image.update();
    	}
    	TProduct product = getModel(TProduct.class,"product");
    	if(product.get("id")==null){
    		product.set("img_id", image.get("id"));
    		product.set("fresh_format", 1);
    		product.save();
    	}else{
    		product.update();
    	}
    	
    	redirect("/masterProductManage/initProductList");
    }
	
	/**
	 * 后台商品删除
	 */
	public void delProduct(){
		Db.deleteById("t_product", getParaToInt("id"));
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("success", "success");
		result.put("msg", "删除成功");
		result.put("id", "id");
		renderJson(result);
	}
	
	/**
     * 商品规格列表
     */
    public void productFList(){
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        int productId=getParaToInt("productId");
        TProductF productF=new TProductF();
        
        Page<Record> pageInfo=productF.findByProductId(productId,pageSize,page,sidx,sord);
        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            //操作列，需要第一列填充空数据
            row.add("");
            row.add(rc.getInt("id"));
            row.add(rc.getStr("product_code"));
            row.add(rc.getStr("bar_code"));
            row.add(rc.getDouble("product_amount"));
            row.add(rc.getStr("product_unit"));
            row.add(rc.getStr("standard"));
            row.add(rc.getInt("price"));
            row.add(rc.getInt("special_price"));
            row.add(rc.getStr("show_standard"));
            row.add(rc.getStr("is_vlid"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    
    /**
     * 保存或者修改规格
     */
    public void productFSave(){
    	TProductF productF = getModel(TProductF.class,"pf");
    	productF.set("product_id", getParaToInt("productId"));
    	if("del".equals(getPara("oper"))){
    		productF.set("id", getParaToInt("id"));
    		productF.delete();
    		redirect("/productManage/initSave?id="+getParaToInt("productId"));
    	}else if("add".equals(getPara("oper"))){
    		//去除掉空格
    		productF.set("product_code", productF.getStr("product_code").trim());
    		productF.set("fresh_format", 1);
    		productF.save();
    		redirect("/productManage/initSave?id="+getParaToInt("productId"));
    	}else{
    		//去除掉空格
    		productF.set("product_code", productF.getStr("product_code").trim());
    		productF.update();
    		redirect("/productManage/initSave?id="+getParaToInt("productId"));
    	}
    }
    
    /**
	 * 初始化营养精选页面
	 */
	public void initNutritionProductList() {
        render(AppConst.PATH_MANAGE_PC + "/masterSys/productManage/nutritionSelection.ftl");
    }
	
	/**
	 * 营养精选商品关联
	 */
	public void relevance(){
		String ids = getPara("ids");
		int type = getParaToInt("type");
		MActivity mActivity = MActivity.dao.findFirst("select * from m_activity where activity_type=? ", type);
		Map<String, Object> mes =new HashMap<String, Object>();
		MActivityProduct mActivityProduct = new MActivityProduct();
		Record record = new Record();
		for (String item : ids.split(",")) {
			TProductF tProductF = TProductF.dao.findFirst("select *from t_product_f where id=?",item);
			mActivityProduct.set("product_id", tProductF.getInt("product_id"));
			mActivityProduct.set("activity_id", mActivity.get("id"));
			mActivityProduct.set("product_count", 0);
			mActivityProduct.set("activity_price",0);//特价
			mActivityProduct.set("product_f_id", item);
			record.setColumns(model2map(mActivityProduct));
			Db.save("m_activity_product", record);
			record.clear();
		}
		mes.put("success", "商品关联成功！");
		renderJson(mes);
	}
	
	/**
	 * 营养精选取消关联
	 */
	public void canselRelevance(){
		String ids = getPara("ids");
		for (String item : ids.split(",")) {
			Record record = Db.findFirst("select *from m_activity_product where product_f_id=?", item);
			Db.delete("m_activity_product", record);
		}
		Map<String, Object> mes =new HashMap<String, Object>();
		mes.put("success", "商品取消关联成功！");
		renderJson(mes);
	}
	
	public void initRecommentList(){
		 render(AppConst.PATH_MANAGE_PC + "/masterSys/productManage/foodRecommendList.ftl");
	}
	
	/**
	 * 后台食鲜推荐列表
	 */
	public void recommentList(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        TProduct product=new TProduct();
        Page<Record> pageInfo=product.findRecommend(pageSize, page);

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getInt("id"));
            row.add(rc.getStr("main_title"));
            row.add(pageInfo.getList().size());
            row.add(rc.getStr("yxbz"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	
	/**
	 * 初始化食鲜推荐编辑页
	 */
	public void initRecommendSave(){
		MActivity mActivity= new MActivity();
		TImage image = new TImage();
		if(StringUtil.isNotNull(getPara("id"))){
			int id = getParaToInt("id");
			mActivity = MActivity.dao.findById(id);
			image = TImage.dao.findById(mActivity.get("img_id"));
		}
		setAttr("mActivity", mActivity);
		setAttr("image", image);
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/productManage/editRecommend.ftl");
    }
	
	/**
	 * 食鲜推荐添加与修改
	 */
	public void recommentSave(){
		String activity_id = getPara("mActivity.id");
		TImage image = getModel(TImage.class,"image");
		MActivity mActivity = getModel(MActivity.class,"mActivity");
		if(StringUtil.isNull(activity_id)){//添加
			image.save();
			mActivity.set("img_id", image.getInt("id"));
			mActivity.set("activity_type", 15);
			mActivity.save();
		}else{//修改
			TImage imageOper=new TImage();
    		TImage imgOld=imageOper.findById(image.get("id"));
    		String saveStr=imgOld.getStr("save_string");
    		if(StringUtil.isNotNull(saveStr)&&!imgOld.getStr("save_string").equals(image.getStr("save_string"))){
    			try{
    				int attachedIndex=saveStr.indexOf("attached");
    				if(attachedIndex!=-1){
    					//去掉字符weixin
    					saveStr=saveStr.substring(attachedIndex);
    				}
	    			File file=new File(PathKit.getWebRootPath()+"\\"+saveStr);
	    			if(file.exists()){
	    				file.delete();
	    			}
	    		}catch(Exception e){
					this.logger.error(e.getMessage());
				}
    		}
			image.update();
			mActivity.update();
		}
		
    	if(image.get("id")==null){
    		image.save();
    	}else{
    		//存储图片优化，如果图片修改过了,删除掉原来的图片
    		TImage imageOper=new TImage();
    		TImage imgOld=imageOper.findById(image.get("id"));
    		String saveStr=imgOld.getStr("save_string");
    		if(StringUtil.isNotNull(saveStr)&&!imgOld.getStr("save_string").equals(image.getStr("save_string"))){
    			try{
    				int attachedIndex=saveStr.indexOf("attached");
    				if(attachedIndex!=-1){
    					//去掉字符weixin
    					saveStr=saveStr.substring(attachedIndex);
    				}
	    			File file=new File(PathKit.getWebRootPath()+"\\"+saveStr);
	    			if(file.exists()){
	    				file.delete();
	    			}
	    		}catch(Exception e){
					this.logger.error(e.getMessage());
				}
    		}
    		image.update();
    	}
/*    	MActivity mActivity = getModel(MActivity.class,"mActivity");
    	if(mActivity.get("id")==null){
    		mActivity.set("img_id", image.get("id"));
    		mActivity.save();
    	}else{
    		mActivity.set("img_id", image.get("id"));
    		mActivity.update();
    	}*/
    	
    	redirect("/masterProductManage/initRecommentList");
	}
	
	/**
	 * 食鲜推荐关联商品
	 */
	public void recommendProductRelate(){
		String ids = getPara("ids");
		Map<String, Object> mes =new HashMap<String, Object>();
		MActivityProduct mActivityProduct = new MActivityProduct();
		Record record = new Record();
		for (String item : ids.split(",")) {
			mActivityProduct.set("product_id", item);
			mActivityProduct.set("activity_id", getParaToInt("activity_id"));
			mActivityProduct.set("product_count", 0);
			//mActivityProduct.set("activity_price",0);//特价
			Record productFRecord = Db.findFirst("select id from t_product_f where product_id=?",item);
			if(productFRecord==null){
				mActivityProduct.set("product_f_id",0);
				mes.put("success", "商品关联不成功！商品不存在规格，请先添加规格再关联！");
			}else{
				mActivityProduct.set("product_f_id", productFRecord.getInt("id"));
			}
			record.setColumns(model2map(mActivityProduct));
			Db.save("m_activity_product", record);
			record.clear();
		}
		mes.put("success", "商品关联成功！");
		renderJson(mes);
	}
	
	/**
	 * 取消食鲜推荐关联商品
	 */
	public void cancleRecommendProduct(){
		int activity_id = getParaToInt("activity_id");
		String ids = getPara("ids");
		Map<String, Object> mes =new HashMap<String, Object>();
		Record mActivityProduct = new Record();
		for (String item : ids.split(",")) {
			mActivityProduct = Db.findFirst("select * from m_activity_product where product_id=? and activity_id=?",item,activity_id);
			Db.delete("m_activity_product", mActivityProduct);
		}
		mes.put("success", "商品取消关联成功！");
		renderJson(mes);
	}
	/**
	 * 食鲜推荐删除
	 */
	public void delRecommend(){
		int activity_id = getParaToInt("activity_id");
		//step1.删除该食鲜推荐活动的活动产品
		List<Record> mActivityProductList = Db.find("select * from m_activity_product where activity_id=?",activity_id);
		if(mActivityProductList.size()>0){
			for (Record record : mActivityProductList) {
				Db.delete("m_activity_product", record);
			}
		}
		//step2.删除该活动
		Db.deleteById("m_activity", activity_id);
		Map<String,String> result = new HashMap<String,String>();
		result.put("success", "success");
		renderJson(result);
	}
	
	public void recommendProductList(){
		int page = getParaToInt("page");
		int pageSize = getParaToInt("rows");
		Boolean isRecommend = getParaToBoolean("isRecommend");
		
		String productName = "";
		if(StringUtil.isNotNull(productName)){
			productName = getPara("productName");
		}
		
		int activity_id = 0;
		if(StringUtil.isNotNull(getPara("activity_id"))){
			activity_id =  getParaToInt("activity_id");
		}
		String productStatus="01";
        if(StringUtil.isNotNull(getPara("productStatus"))){
        	productStatus=getPara("productStatus");
        }
        Page<Record> productInfo = TProduct.dao.findRecommentList(productName, productStatus, pageSize, page, isRecommend,activity_id);
        JSONObject result = new JSONObject();
        result.put("total",productInfo.getTotalPage());
        result.put("page",productInfo.getPageNumber());
        result.put("records",productInfo.getPageSize());
        
        JSONArray rows = new JSONArray();
        for (Record rc : productInfo.getList()) {
        	JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getInt("id"));
            row.add(rc.getStr("product_status"));
            row.add(rc.getStr("product_name"));
            row.add(rc.getStr("category_name"));
            row.add(rc.getStr("save_string"));
            row.add(rc.getStr("unit_name"));
            row.add(rc.getDouble("product_amount"));
            row.add(rc.getStr("product_unit"));
            row.add(rc.getStr("standard"));
            row.add(rc.getInt("price"));
            row.add(rc.getInt("special_price"));
            row.add(rc.getStr("is_vlid"));
            json.put("cell",row);
            rows.add(json);
		}
        result.put("rows", rows);
        renderJson(result);
	}
	

}
