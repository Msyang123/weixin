package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.core.JFinal;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.revocn.mapping.RoleMapping;
import com.sgsl.config.AppConst;
import com.sgsl.model.MWxmsg;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.SubmitMsg;
import com.sgsl.model.SysMenu;
import com.sgsl.model.SysUser;
import com.sgsl.util.BlankUtil;
import com.sgsl.util.MD5Util;
import com.sgsl.util.StringUtil;

import java.util.Date;

/**
 * Created by Tao on 2014-07-17.
 */
public class SubmitMsgController extends BaseController {
    protected final static Logger logger = Logger.getLogger(SubmitMsgController.class);


    public void searchSubmitMsgs() {
        String keyWord=getPara("keyWord");
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<SubmitMsg> pageInfo=null;
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        if(StringUtil.isNull(keyWord)){
            if(StringUtil.isNull(sidx)){
                pageInfo= SubmitMsg.dao.paginate(page,pageSize,"select *","from submit_msg where send_user=?",publicAccount.getStr("old_num"));
            }else{
                pageInfo=SubmitMsg.dao.paginate(page,pageSize,"select *","from submit_msg where send_user=? order by "+sidx+" "+sord,publicAccount.getStr("old_num"));
            }
        }else{
            if(StringUtil.isNull(sidx)){
                pageInfo=SubmitMsg.dao.paginate(page,pageSize,"select *","from submit_msg where key_word like '%"+keyWord+"%' and send_user=?",publicAccount.getStr("old_num"));
            }else{
                pageInfo=SubmitMsg.dao.paginate(page,pageSize,"select *","from submit_msg where key_word like '%"+keyWord+"%' and send_user=? order by "+sidx+" "+sord,publicAccount.getStr("old_num"));
            }
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (SubmitMsg sm:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",sm.get("id"));
            row.add("");
            row.add(sm.get("id"));
            row.add(sm.get("message_type"));
            row.add(sm.get("key_word"));
            row.add(sm.get("pic_url"));
            row.add(sm.get("url"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }

    public void initSubmitMsg() {
        render(AppConst.PATH_MANAGE_PC + "/sys/submitMsg.ftl");
    }
    public void initWxmsg(){
    	render(AppConst.PATH_MANAGE_PC + "/sys/mWxmgs.ftl");
    }
    public void initRepWxmsg(){
    	setAttr("id",getPara("id"));
    	setAttr("msgFrom",getPara("msgFrom"));
    	setAttr("ids",getPara("ids"));
    	render(AppConst.PATH_MANAGE_PC + "/sys/repWxmsg.ftl");
    }
    /**
     * 删除指定的消息
     */
    public void deleteSubmitMsg(){
        if(getPara("oper").equals("del")){
            SubmitMsg.dao.deleteById(getParaToInt("id"));
            renderJson("{result:'success'}");
        }
    }

    /**
     * 编辑指定的消息
     */
    public void initEditSubmitMsg(){
        SubmitMsg sm=SubmitMsg.dao.findById(getPara("id"));
        if(sm==null){
            sm=new SubmitMsg();
        }
        setAttr("sm",sm);
        render(AppConst.PATH_MANAGE_PC+"/sys/editSubmitMsg.ftl");
    }
    /**
     * 保存消息
     */
    public void saveSubmitMsg(){
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        SubmitMsg model = getModel(SubmitMsg.class,"sm");
        Record record = new Record();
        record.set("send_user",publicAccount.getStr("old_num"));
        record.set("uuid", publicAccount.getStr("uuid"));
        record.set("status",1);
        record.setColumns(model2map(model));
        if(StringUtil.isNull(getPara("sm.id"))){
            Db.save("submit_msg", record);
        }else{
            Db.update("submit_msg",record);
        }
        redirect("/submitMsg/initSubmitMsg");
    }
    /**
     * ajax查询客服消息
     */
    public void searchWxmsgs() {
        String keyWord=getPara("keyWord");
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<MWxmsg> pageInfo=null;
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        if(StringUtil.isNull(keyWord)){
            if(StringUtil.isNull(sidx)){
                pageInfo= MWxmsg.dao.paginate(page,pageSize,"select w.*,u.user_img_id,nickname","from m_wxmsg w left join t_user u on w.msg_from=u.open_id where msg_to=?",publicAccount.getStr("old_num"));
            }else{
                pageInfo=MWxmsg.dao.paginate(page,pageSize,"select w.*,u.user_img_id,nickname","from m_wxmsg w left join t_user u on w.msg_from=u.open_id where msg_to=? order by "+sidx+" "+sord,publicAccount.getStr("old_num"));
            }
        }else{
            if(StringUtil.isNull(sidx)){
                pageInfo=MWxmsg.dao.paginate(page,pageSize,"select w.*,u.user_img_id,nickname","from m_wxmsg w left join t_user u on w.msg_from=u.open_id where content like '%"+keyWord+"%' and msg_to=?",publicAccount.getStr("old_num"));
            }else{
                pageInfo=MWxmsg.dao.paginate(page,pageSize,"select w.*,u.user_img_id,nickname","from m_wxmsg w left join t_user u on w.msg_from=u.open_id where content like '%"+keyWord+"%' and msg_to=? order by "+sidx+" "+sord,publicAccount.getStr("old_num"));
            }
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (MWxmsg sm:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",sm.get("id"));
            row.add(sm.get("id"));
            row.add(sm.get("msg_from"));
            row.add(sm.get("nickname"));
            row.add(sm.get("user_img_id"));
            row.add(sm.get("content"));
            
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
}
