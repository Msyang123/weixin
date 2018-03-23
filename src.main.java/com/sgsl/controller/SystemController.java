package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.SysUser;
import com.sgsl.model.UserDefinedMenu;
import com.sgsl.util.StringUtil;

import java.util.List;
import java.util.UUID;

/**
 * Created by Tao on 2014-07-17.
 */
public class SystemController extends BaseController {
    protected final static Logger logger = Logger.getLogger(SystemController.class);

    /*public void userList() {
        Page<SysUser> sysUsers=SysUser.dao.paginate();
        if(BlankUtil.isBlankModel(user)){
            if(JFinal.me().getConstants().getDevMode()){//开发模式，默认登录用户名
                setAttr("uuu","admin");
            }
            render(AppConst.PATH_MANAGE_PC + "/login.ftl");
        }else{
            render(AppConst.PATH_MANAGE_PC + "/index.ftl");
        }
    }*/
    public void sysuserList(){
        render(AppConst.PATH_MANAGE_PC + "/sys/sysuserList.ftl");
    }
    public void getSysusersJson(){
        String username=getPara("username");
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<PublicAccount> pageInfo=null;
        if(StringUtil.isNull(username)){
            if(StringUtil.isNull(sidx)){
                pageInfo=PublicAccount.dao.paginate(page,pageSize,"select *","from public_account");
            }else{
                pageInfo=PublicAccount.dao.paginate(page,pageSize,"select *","from public_account order by "+sidx+" "+sord);
            }
        }else{
            if(StringUtil.isNull(sidx)){
                pageInfo=PublicAccount.dao.paginate(page,pageSize,"select *","from public_account where username like '%"+username+"%'");
            }else{
                pageInfo=PublicAccount.dao.paginate(page,pageSize,"select *","from public_account where username like '%"+username+"%' order by "+sidx+" "+sord);
            }
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (PublicAccount pa:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",pa.get("id"));
            row.add(pa.get("id"));
            row.add(pa.get("username"));
            row.add(pa.get("app_id"));
            row.add(pa.get("app_key"));
            row.add(pa.get("user_kind"));
            row.add(pa.get("uuid"));
            row.add(pa.get("valid_flag"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows",rows);
        renderJson(result);
    }
    /**
     * 自定义微信菜单初始化编辑
     */
    public void initShowWeixinMenu(){

        render(AppConst.PATH_MANAGE_PC+"/sys/weixinMenu.ftl");
    }
    /**
     * 异步查找微信菜单列表
     */
    public void showWeixinMenu(){
        //找到当前用户的菜单
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        int nodeId=0;
        if(StringUtil.isNotNull(getPara("id"))){
            nodeId=getParaToInt("id");
        }

        //找到当前节点的所有子节点
        List<UserDefinedMenu> childMenuItems=UserDefinedMenu.dao.findByParentId(nodeId,publicAccount.getStr("uuid"));
        UserDefinedMenu currentMenuItem=UserDefinedMenu.dao.findById(nodeId);
        JSONObject menuInfo=new JSONObject();
        menuInfo.put("currentMenuItem",currentMenuItem);
        JSONArray childMenuItemsJson=new JSONArray();
        for(UserDefinedMenu item:childMenuItems){
            item.set("is_parent",UserDefinedMenu.dao.isParent(item.getInt("id"),publicAccount.getStr("uuid")));
            childMenuItemsJson.add(item);
        }
        menuInfo.put("childMenuItems", childMenuItemsJson);
        renderJson(menuInfo);
    }
    /**
     * 保存编辑好的菜单项
     *
     */
    public void saveItem(){
        //查找到当前登录用户
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        UserDefinedMenu model = getModel(UserDefinedMenu.class,"udm");

        Record record = new Record();
        record.set("uuid",publicAccount.getStr("uuid"));
        record.setColumns(model2map(model));
        renderHtml("{result:"+ (StringUtil.isNull(getPara("udm.id"))?Db.save("user_defined_menu",record):Db.update("user_defined_menu",record))+"}");
    }

    /**
     * 判断当前节点是否用于子节点
     */
    public void isParent(){
        //查找到当前登录用户
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        renderHtml("{result:"+UserDefinedMenu.dao.isParent(getParaToInt("id"),publicAccount.getStr("uuid"))+"}");
    }
    /**
     * 删除指定节点
     */
    public void removeItem(){
        //查找到当前登录用户
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        List<UserDefinedMenu> childern=UserDefinedMenu.dao.getChildern(getParaToInt("id"),publicAccount.getStr("uuid"));
        for(UserDefinedMenu item:childern) {
            Db.deleteById("user_defined_menu",item.get("id"));
        }
        Db.deleteById("user_defined_menu",getPara("id"));
        renderHtml("{result:true}");
    }
    /**
     * 审核
     */
    public void check(){
        PublicAccount.dao.set("id",getPara("id")).set("valid_flag","1").update();
        renderHtml("{result:'success'}");
    }
}
