package com.xgs.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.ext.render.excel.PoiRender;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.render.Render;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.TUser;
import com.sgsl.util.DateUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.xgs.model.TOrder;
import com.xgs.model.TPayLog;
import com.xgs.model.XApplyMoney;

public class MasterOrderManageController extends BaseController{

	
	public void initMasterOrder(){
		Date date= new Date();
    	setAttr("createDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("createDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
		render(AppConst.PATH_MANAGE_PC + "/masterSys/orderManage/orderList.ftl");
	}
	
	/**
     * 鲜果师后台用户订单查询
     */
    public void orderList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String orderId=getPara("orderId");
        String phoneNum=getPara("phoneNum");
        String createDateBegin=getPara("createDateBegin");
        String createDateEnd=getPara("createDateEnd");
        if(StringUtil.isNull(createDateBegin)){
        	createDateBegin=DateFormatUtil.format5(new Date());
        }
        if(StringUtil.isNull(createDateEnd)){
        	createDateEnd=DateFormatUtil.format5(new Date());
        }
        int orderStatus=-1;
        if(StringUtil.isNotNull(getPara("orderStatus"))){
        	orderStatus=getParaToInt("orderStatus");
        }
        int hdStatus=-1;
        if(StringUtil.isNotNull(getPara("hdStatus"))){
        	hdStatus=getParaToInt("hdStatus");
        }
        
        TOrder order=new TOrder();
        Page<Record> pageInfo=order.findOrderList(orderId,phoneNum,orderStatus, hdStatus, createDateBegin,createDateEnd, pageSize, page, sidx, sord);


        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getStr("store_name"));
            row.add(rc.getStr("createtime"));
            row.add(rc.get("commitTime"));
            row.add(rc.getStr("time_end"));
            row.add(rc.getStr("order_id"));
            row.add(rc.getStr("transaction_id"));
            row.add(rc.getStr("wx_pay"));
            row.add(rc.getInt("total"));
            row.add(rc.getInt("discount"));
            row.add(rc.getInt("need_pay"));
            row.add(rc.getStr("phone_num"));
            row.add(rc.getStr("nickname"));
            row.add(rc.getInt("balance"));
            row.add(rc.getStr("order_status"));
            row.add(rc.getStr("order_type"));
            row.add(rc.getStr("hd_status"));
            row.add(rc.getStr("deliverytype"));
            row.add(rc.getStr("reason"));
            row.add(rc.getStr("customer_note"));
            row.add(rc.getStr("old_order_id"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    /**
     * 初始化订单统计页面
     */
    public void orderStat(){
    	Date date= new Date();
    	//将服务器端的初始化时间放到页面
    	setAttr("payDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("payDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
        render(AppConst.PATH_MANAGE_PC + "/masterSys/orderManage/orderStat.ftl");
    }
    
    //充值查询页面初始化
    public void initRecharge(){
    	Date date= new Date();
    	//将服务器端的初始化时间放到页面
    	setAttr("rechargeDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("rechargeDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
    	render(AppConst.PATH_MANAGE_PC +"/masterSys/orderManage/rechargeList.ftl");
    }
    
    /**
     * 初始化薪资结算
     */
    public void initPayrollSettlement(){
    	render(AppConst.PATH_MANAGE_PC +"/masterSys/orderManage/payrollSettlement.ftl");
    }
    
    /**
     * 鲜果师申请金额结算处理列表
     */
    public void findNotRealSettlement(){
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String masterName=getPara("masterName");
        String createDateBegin=getPara("createDateBegin");
        String createDateEnd=getPara("createDateEnd");
        int status=-1;
        if(StringUtil.isNotNull(getPara("status"))){
        	status=getParaToInt("status");
        }
        XApplyMoney xApplyMoney = new XApplyMoney();
        Page<Record> pageInfo = xApplyMoney.findNotReal(page, pageSize,status,masterName,
        		createDateBegin,createDateEnd);

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getStr("apply_time"));
            row.add(rc.getStr("master_name"));
            row.add(rc.get("apply_money"));
        	row.add(rc.getInt("status"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    /**
     * 处理未结算
     */
    public void realSettlement(){
    	String ids=getPara("ids");
    	Map<String, Object> mes = new HashMap<String,Object>();
    	for (String item : ids.split(",")) {
    		XApplyMoney applyMoneyRecord = XApplyMoney.dao.findById(Integer.parseInt(item));
    		
    		Record record = new Record();
    		record.set("master_id", applyMoneyRecord.get("master_id"));
    		record.set("money", applyMoneyRecord.getInt("apply_money"));
    		record.set("type", "3");
    		record.set("time", DateFormatUtil.format1(new Date()));
    		boolean flag = Db.save("x_achievement_record", record);
    		if(flag==true){
    			applyMoneyRecord.set("status", 1);
    			applyMoneyRecord.set("success_time", DateFormatUtil.format1(new Date()));
    			applyMoneyRecord.update();
        		mes.put("message", "处理成功！"); 
    		}else{
    			mes.put("message", "处理失败！");
    		}
		}
    	renderJson(mes);
    }
    
    public void exportSettlement(){
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
    	StringBuffer sql=new StringBuffer();
    	sql.append("select a.id,m.master_name ,a.apply_money,a.apply_time,a.status ");
    	sql.append("from x_fruit_master m ");
    	sql.append("left join x_apply_money a on m.id=a.master_id where a.apply_money is not null ");
    	sql.append("order by a.apply_time desc");
    	List<Record> list = Db.find(sql.toString());
    	list.get(0).set("apply_money", list.get(0).getInt("apply_money")/100);
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="payrollSetelmentList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName("导出结算未处理数据").columns(columns);
        render(poirender);
    }
    
    /**
     * 订单统计
     */
    public void orderStatResult(){
    	String payDateBegin=getPara("payDateBegin");
    	String payDateEnd=getPara("payDateEnd");
    	Date payDateBeginData= DateUtil.convertString2Date(payDateBegin);
    	Date payDateEndData= DateUtil.convertString2Date(payDateEnd);
    	String dateBegin=DateFormatUtil.format3(payDateBeginData);
    	String dateEnd=DateFormatUtil.format3(payDateEndData);
    	List<Record> result=Db.find("select l.source_type,sum(l.total_fee) as total_fee  from t_pay_log l left join t_order t on t.order_id=l.out_trade_no where time_end BETWEEN ? and ? group by l.source_type",dateBegin,dateEnd);
    	setAttr("result", result);
    	setAttr("payDateBegin",payDateBegin);
    	setAttr("payDateEnd",payDateEnd);
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/orderManage/orderStat.ftl");
    }
    
    public void allStatOverview(){
    	//初始化查询统计订单和销售相关信息
    	TPayLog payLog=new TPayLog();
    	Date date=new Date();
    	
    	List<Record> payStatTody=payLog.payStat(DateFormatUtil.format5(date)+" 00:00:00",
    			DateFormatUtil.format1(date));
    	boolean balance=false,order=false,present=false,recharge=false,give=false;
    	//填充为空的数据
    	for(Record item:payStatTody){
    		String sourceType=item.getStr("source_type");
    		if(sourceType.equals("balance")){
    			balance=true;
    			continue;
    		}else if(sourceType.equals("order")){
    			order=true;
    			continue;
    		}else if(sourceType.equals("present")){
    			present=true;
    			continue;
    		}else if(sourceType.equals("recharge")){
    			recharge=true;
    			continue;
    		}else if(sourceType.equals("give")){
    			give=true;
    			continue;
    		}
    	}	
    	if(!balance){
    		Record r=new Record();
    		r.set("source_type", "balance");
    		r.set("total_fee", "0");
    		r.set("give_fee", "0");
    		payStatTody.add(r);
    	}
    	if(!order){
    		Record r=new Record();
    		r.set("source_type", "order");
    		r.set("total_fee", "0");
    		r.set("give_fee", "0");
    		payStatTody.add(r);
    	}
    	if(!present){
    		Record r=new Record();
    		r.set("source_type", "present");
    		r.set("total_fee", "0");
    		r.set("give_fee", "0");
    		payStatTody.add(r);
    	}
    	if(!recharge){
    		Record r=new Record();
    		r.set("source_type", "recharge");
    		r.set("total_fee", "0");
    		r.set("give_fee", "0");
    		payStatTody.add(r);
    	}
    	if(!give){
    		Record r=new Record();
    		r.set("source_type", "give");
    		r.set("total_fee", "0");
    		r.set("give_fee", "0");
    		payStatTody.add(r);
    	}
    	setAttr("payStatTody", payStatTody);
    	setAttr("payStat", payLog.payStat(null,null));
    	List<Record> payStayByTime=	payLog.payStatByTime(DateFormatUtil.format5(date), false);
    	setAttr("payStayByTimeMap",conver(payStayByTime));
    	
    	Calendar calendar = Calendar.getInstance(); //得到日历
    	calendar.setTime(date);//把当前时间赋给日历
    	calendar.add(Calendar.DAY_OF_MONTH, -1);  //设置为前一天
    	List<Record> payStayByTimeYesterday=	payLog.payStatByTime(DateFormatUtil.format5(calendar.getTime()), false);
    	setAttr("payStayByTimeYesterday",conver(payStayByTimeYesterday));
    	//每天每小时销售情况统计
    	List<Record> payStayByAvgTime=	payLog.payStatByTime(null, true);
    	setAttr("payStayByAvgTime",conver(payStayByAvgTime));
    	//按照性别统计销售情况
    	/*List<Record> payStatBySex= payLog.payStatBySex();
    	setAttr("payStatBySex",payStatBySex);*/
    	
    	TOrder orderOper=new TOrder();
    	
    	//根据订单类型统计
    	List<Record> statByType=orderOper.orderStatByType();
    	setAttr("statByType",statByType);
    	
    	//根据水果类型统计
    	List<Record> orderStatByFruitType=orderOper.getOrderStatByFruitType();
    	setAttr("orderStatByFruitType",orderStatByFruitType);
    	
        
        //未消费 已消费统计
        TUser tUserOper=new TUser();
        Record xf= tUserOper.findTUserBalanceTotal();
        setAttr("xf",xf);
        
        //查询海鼎发送失败的订单
        TOrder failOrder=new TOrder();
        setAttr("orderFailCount", failOrder.findFailOrder().getLong("orderFailCount"));
        render(AppConst.PATH_MANAGE_PC + "/masterSys/orderManage/allStatOverview.ftl");
    }
    
    private List<Map> conver(List<Record> payStayByTime){
    	List<Map> payStayByTimeMap=new ArrayList<Map>();
    	//创建一个24小时的数组
    	for(int i=0;i<24;i++){
    		Map item=new HashMap();
    		String keyStr=(i<10?"0"+i:""+i);
    		item.put("h", keyStr);
    		boolean flag=false;
    		for(Record r:payStayByTime){
    			if(keyStr.equals(r.getStr("h"))){
    				item.put("total_fee", r.getBigDecimal("total_fee"));
    				flag=true;
    				break;
    			}
    		}
    		if(!flag){
    			item.put("total_fee", 0);
    		}
    		payStayByTimeMap.add(item);
    	}
    	return payStayByTimeMap;
    }
    
}
