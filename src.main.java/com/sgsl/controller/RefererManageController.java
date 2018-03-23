package com.sgsl.controller;


import java.util.List;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.ext.render.excel.PoiRender;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.render.Render;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.TRefererRecord;



/**
 * Created by yj 
 * 用户行为分析
 */
public class RefererManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(RefererManageController.class);

    

    /**
     * 初始化
     */
    public void initReferer(){
        
        render(AppConst.PATH_MANAGE_PC + "/referer/refererList.ftl");
    }
    
    /**
     * 异步加载用户访问记录表
     */
    public void getRefererRecordJson(){
    	 
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");//排序的字段
        String sord=getPara("sord");//升序或者降序
        Page<Record> pageInfo=new TRefererRecord().getRefererRecord(pageSize,page,sidx,sord);

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record tc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",tc.get("id"));
            	row.add(tc.get("id"));
            	row.add(tc.get("referer"));
            	row.add(tc.get("create_time"));
            	row.add(tc.get("user_id"));
            	row.add(tc.get("current_url"));
            	row.add(tc.get("order_id"));
            	row.add(tc.get("order_type"));
            	row.add(tc.get("nickname"));
            	row.add(tc.get("phone_num"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows",rows);
        renderJson(result);
    }
    /**
     * 导出记录
     */
    public void export(){
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
    	String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        List<Record> list = Db.find("select t.*,u.nickname,u.phone_num from t_referer_record t left join t_user u on t.user_id=u.id order by t.create_time desc");
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="refererList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName("用户浏览记录导出").columns(columns);
        render(poirender);
    }
    
}
