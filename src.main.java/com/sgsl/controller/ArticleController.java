package com.sgsl.controller;

import java.util.UUID;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.Article;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.ResourceShow;
import com.sgsl.model.SysUser;
import com.sgsl.util.StringUtil;

public class ArticleController extends BaseController {
    protected final static Logger logger = Logger.getLogger(BespeakController.class);
    
    /**
     * 初始化文章编辑页面
     */
    public void initArticle() {
    	Article article=Article.dao.findById(getPara("id"));
        if(article==null){
        	article=new Article();
        }
        setAttr("article",article);
        render(AppConst.PATH_MANAGE_PC + "/article/editArticle.ftl");
    }
    
    /**
     * 保存文章
     */
    public void saveArticle(){
    	UUID uuid = UUID.randomUUID();
        Article model = getModel(Article.class,"article");
        Record record = new Record();
        record.set("uuid",uuid.toString());
        record.setColumns(model2map(model));
        if(StringUtil.isNull(getPara("article.id"))){
            Db.save("article", record);
        }else{
            Db.update("article",record);
        }
        redirect("/article/initArticleList");
    }
    /**
     * 查询分页文章列表
     */
    public void searchArticle() {
        String keyWord=getPara("keyWord");
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<ResourceShow> pageInfo=null;
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        if(StringUtil.isNull(keyWord)){
            if(StringUtil.isNull(sidx)){
                pageInfo= ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where uuid=? order by layout_time desc",publicAccount.getStr("uuid"));
            }else{
                pageInfo=ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where uuid=? order by "+sidx+" "+sord,publicAccount.getStr("uuid"));
            }
        }else{
            if(StringUtil.isNull(sidx)){
                pageInfo=ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where key_word like '%"+keyWord+"%' and uuid=? order by layout_time desc",publicAccount.getStr("uuid"));
            }else{
                pageInfo=ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where key_word like '%"+keyWord+"%' and uuid=? order by "+sidx+" "+sord,publicAccount.getStr("uuid"));
            }
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (ResourceShow rs:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rs.get("id"));
            row.add("");
            row.add(rs.get("id"));
            row.add(rs.getStr("key_word"));
            //row.add(rs.getStr("content").length()>10?rs.getStr("content").substring(0,10):rs.getStr("content"));
            row.add(rs.get("layout_time"));
            row.add(rs.get("url"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    } 
}
