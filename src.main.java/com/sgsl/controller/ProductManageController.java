package com.sgsl.controller;

import java.io.File;
import java.util.List;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.PathKit;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.*;
import com.sgsl.util.StringUtil;

/**
 *订单管理
 */
public class ProductManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(ProductManageController.class);

    /**
     * 
     */
    public void initProductList() {
        render(AppConst.PATH_MANAGE_PC + "/product/productList.ftl");
    }

    /**
     * 分类树
     */
    public void category(){
    	String id=getPara("id");
    	JSONArray result=new JSONArray();
    	if(StringUtil.isNull(id)){
    		id="-1";
    		//添加一个全部节点
        	JSONObject all=new JSONObject();
        	all.put("id", "0");
        	all.put("pId", "-1");
        	all.put("name", "全部");
        	all.put("isParent", true);
    		result.add(all);
    	}
    	TCategory categroy=new TCategory();
    	List<TCategory> categroyList=categroy.find("select * from t_category where parent_id=?",
    			id);
    	
    	for(TCategory c:categroyList){
    		JSONObject item=new JSONObject();
    		item.put("id", c.getStr("category_id"));
    		item.put("pId", c.getStr("parent_id"));
    		item.put("name", c.getStr("category_name"));
    		item.put("isParent", "0".equals(c.getStr("parent_id")));
    		result.add(item);
    	}
    	
    	renderJson(result);
    }
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
    		if(product==null){
    			
    		}
    		category=TCategory.dao.findFirst("select * from t_category where category_id=?",
    				product.getStr("category_id"));
    		image=TImage.dao.findById(product.getInt("img_id"));
    	}
    	setAttr("product", product);
    	setAttr("category",category);
    	setAttr("image", image);
    	//设置商品的规格列表
    	List<Record>  unitList=Db.find("select * from t_unit");
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
    	setAttr("unitList",sb.toString());
    	render(AppConst.PATH_MANAGE_PC + "/product/editProduct.ftl");
    }
    public void save(){
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
    		product.save();
    	}else{
    		product.update();
    	}
    	
    	redirect("/productManage/initProductList");
    }
    public static void main(String[] args) {
		String x="/weixin/attached/9/image/20170109/20170109102357_81.jpg";
		System.out.println(x.substring(x.indexOf("attached")));
	}
    /**
     * ajax查询
     */
    public void productList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
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
        		pageSize, page, sidx, sord);


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
            row.add(rc.getStr("product_status"));
            row.add(rc.getStr("product_name"));
            row.add(rc.getStr("category_name"));
            row.add(rc.getStr("save_string"));
            row.add(rc.getStr("base_unitname"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
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
            row.add(rc.getStr("is_gift"));
            row.add(rc.getStr("is_vlid"));
            row.add(rc.getStr("product_f_des"));
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
    		productF.save();
    		redirect("/productManage/initSave?id="+getParaToInt("productId"));
    	}else{
    		//去除掉空格
    		productF.set("product_code", productF.getStr("product_code").trim());
    		productF.update();
    		redirect("/productManage/initSave?id="+getParaToInt("productId"));
    	}
    }

}
