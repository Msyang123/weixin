package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.Bespeak;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.SubmitMsg;
import com.sgsl.model.SysUser;
import com.sgsl.util.MD5Util;
import com.sgsl.util.StringUtil;

import java.util.Date;
import java.util.UUID;

/**
 *预约
 */
public class BespeakController extends BaseController {
    protected final static Logger logger = Logger.getLogger(BespeakController.class);

    /**
     * 初始化网上预约会见表单
     */
    public void initBespeakForm() {
        setAttr("uuid",getPara("uuid"));
        setAttr("errormsg",1);
        render(AppConst.PATH_MANAGE_PC + "/client/bespeak.ftl");
    }

    /**
     * 保存提交的预约表单信息
     */
    public void saveBespeak(){
        Bespeak model = getModel(Bespeak.class,"be");
        Record record = new Record();
        record.setColumns(model2map(model));
        record.set("create_time",new Date());
        if(Db.save("bespeak",record)) {
            render(AppConst.PATH_MANAGE_PC + "/client/success.ftl");
        }else{
            setAttr("errormsg","提交信息失败，请重试");
            render(AppConst.PATH_MANAGE_PC + "/client/bespeak.ftl");
        }
    }

    /**
     * 后台初始化查询预约信息
     */
    public void initBespeakList(){
        render(AppConst.PATH_MANAGE_PC+"/sys/bespeakList.ftl");
    }

    /**
     * ajax查询预约信息
     */
    public void searchBespeaks() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<Bespeak> pageInfo=null;
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));

        if(StringUtil.isNull(sidx)){
            pageInfo= Bespeak.dao.paginate(page,pageSize,"select *","from bespeak where uuid=? order by create_time desc",publicAccount.getStr("uuid"));
        }else{
            pageInfo=Bespeak.dao.paginate(page,pageSize,"select *","from bespeak where uuid=? order by "+sidx+" "+sord,publicAccount.getStr("uuid"));
        }


        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Bespeak sm:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",sm.get("id"));
            row.add(sm.getInt("id"));
            row.add(sm.getStr("submit_name"));
            row.add(sm.get("age"));
            row.add(sm.getStr("job"));
            row.add(sm.getStr("meet"));
            row.add(sm.getStr("date"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }

}
