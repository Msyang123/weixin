package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Page;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.SubmitMsg;
import com.sgsl.model.SysUser;
import com.sgsl.model.TIndexSetting;
import com.sgsl.model.TStore;
import com.sgsl.util.StringUtil;

public class TIndexSettingController extends BaseController {
    protected final static Logger logger = Logger.getLogger(TIndexSettingController.class);
    
    /**
     * 初始化页面
     */
    public void initIndexSetting() {
    	render(AppConst.PATH_MANAGE_PC + "/setting/indexSettingList.ftl");
    }
   
    public void indexSettingList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<TIndexSetting> pageInfo=TIndexSetting.dao.paginate(page,pageSize,"select *","from t_index_setting");

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (TIndexSetting is:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",is.get("id"));
            row.add("");
            row.add(is.get("id"));
            row.add(is.get("index_name"));
            row.add(is.get("index_value"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * 增加修改删除
     */
    public void editIndexSetting(){
    	TIndexSetting indexSetting = getModel(TIndexSetting.class,"is");
        if(getPara("oper").equals("del")){
        	TIndexSetting.dao.deleteById(getParaToInt("id"));
        }else if(getPara("oper").equals("add")){
        	indexSetting.save();
        }else if(getPara("oper").equals("edit")){
        	indexSetting.update();
        }
        redirect("/indexSetting/initIndexSetting");
    }
}
