package com.sgsl.controller;




import java.util.List;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MRecommend;
import com.sgsl.model.TProductF;
import com.sgsl.util.StringUtil;



/**
 * Created by yj 
 * 推荐商品
 */
public class RecommendManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(RecommendManageController.class);

    /**
     * 初始化
     */
    public void initRecommend(){
        
        render(AppConst.PATH_MANAGE_PC + "/recommend/recommendList.ftl");
    }
    
    /**
     * 推荐商品列表数据
     */
    public void getRecommendRecordJson(){
    	 
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");//排序的字段
        String sord=getPara("sord");//升序或者降序
        Page<Record> pageInfo=Db.paginate(page,pageSize, "select r.*,p.product_status,p.product_name,pf.product_amount,pf.product_unit,pf.standard,pf.price,pf.special_price,pf.is_vlid", 
        		"from m_recommend r left join t_product p on r.product_id=p.id left join t_product_f pf on r.product_f_id=pf.id");

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record tc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",tc.get("id"));
            	row.add("");
            	row.add(tc.get("id"));
            	row.add(tc.get("type_id"));
            	row.add(tc.get("order_id"));
            	row.add(tc.get("product_name"));
            	row.add(tc.get("product_status"));
            	row.add(tc.get("product_amount"));
            	row.add(tc.get("product_unit"));
            	row.add(tc.get("standard"));
            	row.add(tc.get("price"));
            	row.add(tc.get("special_price"));
            	row.add(tc.get("is_vlid"));
            	row.add(tc.get("recomm_img"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows",rows);
        renderJson(result);
    }
    
    public void delRecommend(){
    	String id=getPara("id");
    	if("del".equals(getPara("oper"))){
    		//多个记录，批量删除
    		if(id.indexOf(",")!=-1){
    			for(String item:id.split(",")){
    				MRecommend mRecommend=new MRecommend();
    				mRecommend.set("id", item);
    				mRecommend.delete();
    			}
    		}else{
        		MRecommend mRecommend=new MRecommend();
				mRecommend.set("id", getParaToInt("id"));
				mRecommend.delete();
    		}
    	}else if("edit".equals(getPara("oper"))){
    		MRecommend mRecommend=MRecommend.dao.findById(id);
    		mRecommend.set("order_id", getParaToInt("order_id"));
    		mRecommend.update();
    	}
    	render(AppConst.PATH_MANAGE_PC + "/recommend/recommendList.ftl");
    }
    
    public void initSaveRecommend(){
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
    	render(AppConst.PATH_MANAGE_PC + "/recommend/editRecommend.ftl");
    }
    
    public void saveRecommend(){
    	String typeId=getPara("type_id");
    	String ids=getPara("ids");
    	if(StringUtil.isNotNull(ids)){
    		TProductF productF=new  TProductF();
    		for(String id:ids.split(",")){
    			TProductF searchProductF= productF.findById(id);
    			if(searchProductF==null)
    				continue;
    			MRecommend recommend=new MRecommend();
    			
    			recommend.set("product_id", searchProductF.getInt("product_id"));
    			recommend.set("type_id", typeId);
    			recommend.set("order_id", 0);
    			recommend.set("product_f_id", id);
    			recommend.save();
    		}
    	}
    	render(AppConst.PATH_MANAGE_PC + "/recommend/recommendList.ftl");
    }
    
}
