package com.sgsl.controller;

import java.util.*;


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
import com.sgsl.model.SysUser;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TOrder;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;


/**
 *会员管理
 */
public class UserManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(UserManageController.class);

    /**
     * 
     */
    public void initUserList() {
    	Date date=new Date(); 
    	setAttr("registTimeBegin","2010-01-01 00:00:00");
        setAttr("registTimeEnd",DateFormatUtil.format1(date));
        render(AppConst.PATH_MANAGE_PC + "/user/userList.ftl");
    }

    public void userInfosList(){
    	setAttr("id",getPara("id"));
    	render(AppConst.PATH_MANAGE_PC + "/user/userInfosList.ftl");
    }

    /**
     * ajax查询
     */
    public void userList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String phoneNum=getPara("phoneNum");
        String registTimeBegin=getPara("registTimeBegin");
        String registTimeEnd=getPara("registTimeEnd");
        StringBuffer execSql=new StringBuffer("from t_user u left join t_store s on u.store_id=s.id ");
        Date date=new Date(); 
        if(StringUtil.isNull(registTimeBegin)){
        	registTimeBegin=DateFormatUtil.format5(date)+" 00:00:00";
        }
        if(StringUtil.isNull(registTimeEnd)){
        	registTimeEnd=DateFormatUtil.format1(date);
        }
        execSql.append(" where regist_time between ");
        execSql.append("'");
        execSql.append(registTimeBegin);
        execSql.append("'");
        execSql.append(" and ");
        execSql.append("'");
        execSql.append(registTimeEnd);
        execSql.append("' ");
        if(StringUtil.isNotNull(phoneNum)){
        	boolean flag=false;
        	StringBuffer phoneNums=new StringBuffer();
        	 for (String p : phoneNum.split(",")) {
        		 if(StringUtil.isNull(p))
        			 continue;
        	       if (flag){  
        	    	   phoneNums.append(", ");  
        	       }
        	       phoneNums.append("'");
        	       phoneNums.append(p); 
        	       phoneNums.append("'");
        	       flag=true;
        	   }  
        	execSql.append(" and phone_num in("+phoneNums.toString()+") ");
        }
        
        if(StringUtil.isNotNull(sidx)){
        	execSql.append(" order by "+sidx+" "+sord);
        }
        Page<Record> pageInfo=Db.paginate(page, pageSize, "select u.*,if(u.sex='1','男','女') as sexDisplay,if(u.status='0','不可用','正常') as statusDisplay,s.store_name ", execSql.toString());


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
            row.add(rc.getStr("open_id"));
            row.add(rc.getStr("sexDisplay"));
            row.add(rc.getStr("phone_num"));
            row.add(rc.getStr("nickname"));
            row.add(rc.getStr("birthday"));
            row.add(rc.getStr("realname"));
            row.add(rc.getStr("user_address"));
            row.add(rc.getStr("regist_time"));
            row.add(rc.getStr("user_img_id"));
            row.add(rc.getInt("balance"));
            row.add(rc.getInt("member_points"));
            row.add(rc.getStr("statusDisplay"));
            row.add(rc.getStr("store_name"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    /**
     * ajax查询用户仓库
     */
    public void userStockList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String id=getPara("id");
        StringBuffer execSql=new StringBuffer("from t_stock s left join t_stock_product sp on s.id=sp.stock_id ");
        execSql.append(" left join t_product p on sp.product_id=p.id ");
        execSql.append(" left join t_image i on p.img_id=i.id where s.user_id=?");
        
        if(StringUtil.isNotNull(sidx)){
        	execSql.append(" order by "+sidx+" "+sord);
        }
         
        Page<Record> pageInfo=Db.paginate(page, pageSize, "select sp.id,sp.unit_price,sp.amount,sp.get_time,if(sp.status='Y','有效','无效') as status,p.product_name,i.save_string", 
        		execSql.toString(),id);

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
            row.add(rc.getStr("save_string"));
            row.add(rc.getStr("product_name"));
            row.add(rc.getInt("unit_price"));
            row.add(rc.getDouble("amount"));
            row.add(rc.getStr("get_time"));
            row.add(rc.getStr("status"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * ajax查询用户订单
     */
    public void userOrderList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        int id=getParaToInt("id");
        
         
        Page<Record> pageInfo=new TOrder().findOrderByUserIdList(id,pageSize,page,sidx,sord);

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
            row.add(rc.getStr("store_name"));
            row.add(rc.getStr("createtime"));
            row.add(rc.get("commitTime"));
            row.add(rc.getStr("time_end"));
            row.add(rc.getStr("order_id"));
            row.add(rc.getStr("transaction_id"));
            row.add(rc.getStr("phone_num"));
            row.add(rc.getStr("nickname"));
            row.add(rc.getInt("balance"));
            row.add(rc.getDouble("amount"));
            row.add(rc.getLong("unit_price"));
            row.add(rc.getStr("product_name"));
            row.add(rc.getStr("order_status"));
            row.add(rc.getStr("order_type"));
            row.add(rc.getStr("standard"));
            row.add(rc.getStr("hd_status"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    public void export(){
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
    	
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        Date date=new Date(); 
        String registTimeBegin=null,registTimeEnd=null,phoneNum=null;
        for(int i=0;i<formDataJson.size();i++){
        	JSONObject item=formDataJson.getJSONObject(i);
        	if("phoneNum".equals(item.getString("name"))){
        		phoneNum=item.getString("value");
        	}else if("registTimeBegin".equals(item.getString("name"))){
        		registTimeBegin=item.getString("value");
        	}else if("registTimeEnd".equals(item.getString("name"))){
        		registTimeEnd=item.getString("value");
        	}
        }
        if(StringUtil.isNull(registTimeBegin)){
        	registTimeBegin=DateFormatUtil.format5(date);
        }
        if(StringUtil.isNull(registTimeEnd)){
        	registTimeEnd=DateFormatUtil.format5(date);
        }
    	
    	StringBuffer execSql=new StringBuffer();
        execSql.append("select *,if(sex='1','男','女') as sexDisplay,if(status='0','不可用','正常') as statusDisplay from t_user where regist_time between ");
        execSql.append("'");
        execSql.append(registTimeBegin);
        execSql.append("'");
        execSql.append(" and ");
        execSql.append("'");
        execSql.append(registTimeEnd);
        execSql.append("' ");
        if(StringUtil.isNotNull(phoneNum)){
        	execSql.append(" and phone_num like'%"+phoneNum+"%' ");
        }
    	
    	
    	List<Record> list = Db.find(execSql.toString());
    	String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        /*{"序号","微信用户标示", "性别", "手机号","昵称","生日","真实姓名",
        			"用户地址","注册时间","用户头像","会员余额","会员积分","状态"};*/
        
        /*String[] columns={"id","open_id","sexDisplay","phone_num","nickname","birthday","realname",
        			"user_address","regist_time","user_img_id","balance",
        			"member_points","statusDisplay"};*/
        String fileName="userList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(registTimeBegin.substring(0, 10)+"至"+registTimeEnd.substring(0, 10)+"用户导出").columns(columns);
        render(poirender);
    }
    /**
     * 添加鲜果币
     */
    public void addCoin(){
    	SysUser sysUser = getSessionAttr(AppConst.KEY_SESSION_USER);
    	if(sysUser==null){
    		renderNull();
    	}
    	TUser user=new TUser();
    	user=user.findById(getPara("id"));
    	user.set("balance", user.getInt("balance")+getParaToInt("balance"));
    	user.update();
    	TBlanceRecord blanceRecord=new TBlanceRecord();
    	
    	blanceRecord.set("user_id", getParaToInt("id"));
    	blanceRecord.set("blance",getPara("balance"));
    	blanceRecord.set("ref_type", "manager");
    	blanceRecord.set("create_time",DateFormatUtil.format1(new Date()));
    	blanceRecord.set("account_id",sysUser.get("id"));
    	blanceRecord.set("order_id", getPara("orderId"));
    	blanceRecord.save();
    	redirect("/userManage/initUserList");
    }
    
}
