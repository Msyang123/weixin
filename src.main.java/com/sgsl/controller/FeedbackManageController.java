package com.sgsl.controller;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.util.StringUtil;


/**
 *用户反馈管理
 */
public class FeedbackManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(FeedbackManageController.class);

    /**
     * 
     */
    public void initFeedback() {
        render(AppConst.PATH_MANAGE_PC + "/feedback/feedbackList.ftl");
    }

    

    /**
     * ajax查询
     */
    public void feedbackList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        
        StringBuffer sql=new StringBuffer("from t_feedback f left join t_user u on f.fb_user=u.id");
        if(StringUtil.isNotNull(sidx)){
        	sql.append(" order by ");
        	sql.append(sidx);
        	sql.append(" ");
        	sql.append(sord);
        }
        Page<Record> feedbacks= Db.paginate(page, pageSize, "select f.*,u.user_img_id,u.nickname,u.phone_num", sql.toString());


        JSONObject result=new JSONObject();
        result.put("total",feedbacks.getTotalPage());
        result.put("page",feedbacks.getPageNumber());
        result.put("records",feedbacks.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record fb:feedbacks.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",fb.getInt("id"));
            row.add("");
            row.add(fb.getInt("id"));
            row.add(fb.getStr("fb_title"));
            row.add(fb.getStr("fb_content"));
            row.add(fb.getStr("fb_time"));
            row.add(fb.getStr("nickname"));
            row.add(fb.getStr("user_img_id"));
            row.add(fb.getStr("phone_num"));
            row.add(fb.getStr("is_deal"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * 增删改
     */
    public void feedbackSave(){
    	if("edit".equals(getPara("oper"))){
    		Db.update("update t_feedback set is_deal=? where id=?",getPara("is_deal"),getPara("id"));
    	}
    	redirect("/feedbackManage/initFeedback");
    }

}
