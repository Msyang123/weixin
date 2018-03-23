package com.sgsl.controller;

import java.util.Date;
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
import com.sgsl.model.TExceuteSql;
import com.sgsl.model.TExecuteSqlParam;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;


/**
 * Created by yj on 2017-07-17.
 * 后台sql执行器
 */
public class ExecuteSqlController extends BaseController {
    protected final static Logger logger = Logger.getLogger(ExecuteSqlController.class);

    public void executeSqlList(){
        render(AppConst.PATH_MANAGE_PC + "/tool/executeSqlList.ftl");
    }
    /**
     * sql执行器中的管理功能列表
     */
    public void executeSqlJson(){
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String executeName=getPara("execute_name");
        String executeSql="from t_exceute_sql";
        Page<TExceuteSql> pageInfo=null;
        if(StringUtil.isNotNull(executeName)){
        	executeSql+=" where execute_name like '%"+executeName+"%'";
    	}
        if(StringUtil.isNull(sidx)){
            pageInfo=TExceuteSql.dao.paginate(page,pageSize,"select *",executeSql);
        }else{
            pageInfo=TExceuteSql.dao.paginate(page,pageSize,"select *",executeSql+" order by "+sidx+" "+sord);
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (TExceuteSql es:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",es.get("id"));
          //操作列，需要第一列填充空数据
            row.add("");
            row.add(es.get("id"));
            row.add(es.get("execute_name"));
            row.add(es.getStr("sql_str"));
            row.add(es.getStr("sql_page_head"));
            row.add(es.getStr("sql_page_body"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows",rows);
        renderJson(result);
    }
    /**
     * 编辑执行语句
     */
    public void editExecuteSql(){
    	TExceuteSql executeSql = getModel(TExceuteSql.class,"executeSql");
    	TExecuteSqlParam executeSqlParam=new TExecuteSqlParam();
		if("del".equals(getPara("oper"))){
			String id=getPara("id");
    		//多个记录，批量删除
    		if(id.indexOf(",")!=-1){
    			for(String item:id.split(",")){
    				executeSql.set("id", item);
        			executeSql.delete();
    	    		executeSqlParam.deleteExecuteSqlParam(Integer.valueOf(item));
    			}
    		}else{
    			executeSql.set("id", getParaToInt("id"));
    			executeSql.delete();
        		executeSqlParam.deleteExecuteSqlParam(getParaToInt("id"));
    		}
		}else if("edit".equals(getPara("oper"))){
			executeSql.update();
    	}else if("add".equals(getPara("oper"))){
    		executeSql.save();
    	}
		redirect("/execute/executeSqlList");
    }
    public void executeSqlParamList(){
    	setAttr("id",getPara("id"));
    	render(AppConst.PATH_MANAGE_PC + "/tool/executeSqlParam.ftl");
    }
    /**
     * sql执行器参数列表
     */
    public void executeSqlParamJson(){
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String executeSql="from t_execute_sql_param where execute_id="+getPara("id");
        Page<TExecuteSqlParam> pageInfo=null;
        if(StringUtil.isNull(sidx)){
            pageInfo=TExecuteSqlParam.dao.paginate(page,pageSize,"select *",executeSql);
        }else{
            pageInfo=TExecuteSqlParam.dao.paginate(page,pageSize,"select *",executeSql+" order by "+sidx+" "+sord);
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (TExecuteSqlParam es:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",es.get("id"));
          //操作列，需要第一列填充空数据
            row.add("");
            row.add(es.get("id"));
            row.add(es.getStr("param_cn_name"));
            row.add(es.getStr("param_name"));
            row.add(es.getStr("default_value"));
            row.add(es.getStr("param_type"));
            row.add(es.get("order_des"));
            row.add(es.get("execute_id"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows",rows);
        renderJson(result);
    }
    /**
     * 编辑执行参数
     */
    public void editExecuteSqlParam(){
    	TExecuteSqlParam executeSqlParam = getModel(TExecuteSqlParam.class,"executeSqlParam");
		if("del".equals(getPara("oper"))){
			String id=getPara("id");
    		//多个记录，批量删除
    		if(id.indexOf(",")!=-1){
    			for(String item:id.split(",")){
    				executeSqlParam.set("id", item);
    				executeSqlParam.delete();
    			}
    		}else{
    			executeSqlParam.set("id", getParaToInt("id"));
    			executeSqlParam.delete();
    		}
		}else if("edit".equals(getPara("oper"))){
			executeSqlParam.update();
    	}else if("add".equals(getPara("oper"))){
    		executeSqlParam.set("execute_id", getPara("executeId"));
    		executeSqlParam.save();
    	}
		redirect("/execute/executeSqlParamList?id="+getPara("executeId"));
    }
    public void doSelect(){
    	TExceuteSql excSql=TExceuteSql.dao.findById(getPara("id"));
    	List<TExecuteSqlParam> excSqlParams= new TExecuteSqlParam().findExecuteSqlParam(getParaToInt("id"));
    	setAttr("executeSql",excSql);
    	setAttr("executeSqlParams",excSqlParams);
    	int size=excSqlParams.size();
    	Object[] excSqlParamObjs=new Object[size];
    	for(int i=0;i<size;i++){
    		TExecuteSqlParam item=excSqlParams.get(i);
    		excSqlParamObjs[i]=item.get("default_value");
    	}
    	Record result= Db.findFirst(excSql.getStr("sql_str"), excSqlParamObjs);
    	//列类型
    	setAttr("columnNames", result.getColumnNames());
    	render(AppConst.PATH_MANAGE_PC + "/tool/executeSql.ftl");
    }
    /**
     * 具体执行语句
     */
    public void execute(){
    	TExceuteSql executeSql = getModel(TExceuteSql.class,"executeSql");
    	
    	TExceuteSql excSql=TExceuteSql.dao.findById(executeSql.getInt("id"));
    	List<TExecuteSqlParam> excSqlParams= new TExecuteSqlParam().findExecuteSqlParam(executeSql.getInt("id"));
    	if(excSql.getStr("sql_page_head").toUpperCase().indexOf("INSERT")!=-1||
    	   excSql.getStr("sql_page_head").toUpperCase().indexOf("UPDATE")!=-1||
    	   excSql.getStr("sql_page_head").toUpperCase().indexOf("DELETE")!=-1||
    	   excSql.getStr("sql_page_body").toUpperCase().indexOf("INSERT")!=-1||
    	   excSql.getStr("sql_page_body").toUpperCase().indexOf("UPDATE")!=-1||
    	   excSql.getStr("sql_page_body").toUpperCase().indexOf("DELETE")!=-1){
    		JSONObject result=new JSONObject();
            result.put("total",0);
            result.put("page",1);
            result.put("records",0);
            renderJson(result);
    	}
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<Record> pageInfo=null;
        int size=excSqlParams.size();
        //执行参数
        Object[] excSqlParamObjs=new Object[size];
    	for(int i=0;i<size;i++){
    		TExecuteSqlParam item=excSqlParams.get(i);
    		if(StringUtil.isNull(executeSql.getStr("execute_name"))){
    			excSqlParamObjs[i]=item.getStr("default_value");
    		}else{
    			excSqlParamObjs[i]=getPara(item.getStr("param_name"));
    		}
    	}
        if(StringUtil.isNull(sidx)){
            pageInfo=Db.paginate(page,pageSize,excSql.getStr("sql_page_head"),
            		excSql.getStr("sql_page_body"),excSqlParamObjs);
        }else{
            pageInfo=Db.paginate(page,pageSize,excSql.getStr("sql_page_head"),
            		excSql.getStr("sql_page_body")+" order by "+sidx+" "+sord,excSqlParamObjs);
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record es:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",0);
            for(String columnName:es.getColumnNames()){
            	row.add(es.get(columnName));
            }
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows",rows);
        renderJson(result);
    }
    /**
     * 导出
     */
    public void export(){
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	int executeSqlId=0;
    	for(int j=0;j<formDataJson.size();j++){
        	JSONObject dataItem=formDataJson.getJSONObject(j);
        	if("executeSql.id".equals(dataItem.getString("name"))){
        		executeSqlId=dataItem.getIntValue("value");
        		break;
        	}
    	}
    	TExceuteSql excSql=TExceuteSql.dao.findById(executeSqlId);
    	List<TExecuteSqlParam> excSqlParams= new TExecuteSqlParam().findExecuteSqlParam(executeSqlId);
    	String excSqlStr=excSql.getStr("sql_str");
    	if(excSqlStr.toUpperCase().indexOf("INSERT")!=-1||
    	   excSqlStr.toUpperCase().indexOf("UPDATE")!=-1||
    	   excSqlStr.toUpperCase().indexOf("DELETE")!=-1){
    		return;
    	}
    	
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
    	
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        
        int size=excSqlParams.size();
        //执行参数
        Object[] excSqlParamObjs=new Object[size];
    	for(int i=0;i<size;i++){
    		TExecuteSqlParam item=excSqlParams.get(i);
    		for(int j=0;j<formDataJson.size();j++){
            	JSONObject dataItem=formDataJson.getJSONObject(j);
            	if(item.getStr("param_name").equals(dataItem.getString("name"))){
            		excSqlParamObjs[i]=dataItem.getString("value");
            		break;
            	}
        	}
    	}
    	
    		
    	
    	List<Record> list = Db.find(excSqlStr,excSqlParamObjs);
   
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName=StringUtil.getPingYin(excSql.getStr("execute_name"))+".xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName("导出数据结果").columns(columns);
        render(poirender);
    }
}
