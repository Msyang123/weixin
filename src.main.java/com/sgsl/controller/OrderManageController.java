package com.sgsl.controller;

import java.io.File;
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
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPayLog;
import com.sgsl.model.TPresent;
import com.sgsl.model.TRefundLog;
import com.sgsl.model.TStore;
import com.sgsl.model.TUser;
import com.sgsl.util.DateUtil;
import com.sgsl.util.HdUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.TwitterIdWorker;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.util.XNode;
import com.sgsl.wechat.util.XPathParser;


/**
 *订单管理
 */
public class OrderManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(OrderManageController.class);

    /**
     * 
     */
    public void initOrderList() {
    	Date date= new Date();
    	setAttr("createDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("createDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
        render(AppConst.PATH_MANAGE_PC + "/order/orderList.ftl");
    }

    /**
     * ajax查询
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
            row.add(rc.get("delivery_fee"));
            row.add(rc.getInt("order_style"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * 查询订单详情
     */
    public void orderDetial(){
    	String sql="select t.*, tp.amount, if(tp.is_back='Y','退货','正常') as isBack,tp.unit_price/100 as unit_price,pr.product_name, "
    			+ "tpf.standard ,s.store_name,pl.transaction_id,u.* "
    			+ "from t_order t "
    			+ "left join t_order_products tp on tp.order_id=t.id "
    			+ "left join t_product pr on tp.product_id=pr.id "
    			+ "left join t_product_f tpf on tp.product_id=tpf.product_id and tp.product_f_id=tpf.id "
    			+ "left join t_store s on t.order_store=s.store_id "
    			+ "left join t_pay_log pl on pl.out_trade_no=t.order_id "
    			+ "left join t_user u on u.id=t.order_user "
    			+ "where t.id=?";
		Record orderDetial=Db.findFirst(sql,getPara("id"));
    	setAttr("orderDetial", orderDetial);
		render(AppConst.PATH_MANAGE_PC + "/order/orderDetial.ftl");
    }
    
    /**
     * 退货
     * 退货成功将状态改成6
     */
    public void orderReject(){
    	int id=getParaToInt("id");
    	TOrder orderOper=new TOrder();
    	TOrder order=orderOper.findById(id);
    	String orderId=order.getStr("order_id");
    	JSONObject jsonRresult=new JSONObject();
    	jsonRresult.put("msg", "订单编号："+orderId+"操作失败");
    	if("4".equals(order.getStr("order_status"))||"5".equals(order.getStr("order_status"))){
	    	if(HdUtil.orderRejected(orderId)){
	    		order.set("order_status","8");
	    		logger.info("订单编号："+orderId+"发送海鼎退货成功");
	    		jsonRresult.put("msg", "订单编号："+orderId+"发送海鼎退货成功");
	    	}else{
	    		order.set("order_status","9");
	    		logger.info("订单编号："+orderId+"发送海鼎退货失败");
	    		jsonRresult.put("msg", "订单编号："+orderId+"发送海鼎退货失败");
	    	}
	    	order.update();
    	}
    	renderJson(jsonRresult);
    }
    /**
     * 将订单状态从7(取消中)改成6（退货完成）
     * @throws Exception 
     */
    public void orderCancel() throws Exception{
    	int id=getParaToInt("id");
    	TOrder orderOper=new TOrder();
    	TOrder order=orderOper.findById(id);
    	JSONObject jsonResult=new JSONObject();
    	jsonResult.put("success", false);
		jsonResult.put("message", "未找到订单或者订单为其他状态");
		if(order==null||!"7".equals(order.getStr("order_status"))){
			renderJson(jsonResult);
			return;
		}
		String hdCancelOrderResult= HdUtil.orderCancel(order.getStr("order_id"),order.getStr("reason"));
		//code=200{...}
		if(hdCancelOrderResult!=null){
			//去掉 code=200
			hdCancelOrderResult=hdCancelOrderResult.substring(8);
			jsonResult=JSONObject.parseObject(hdCancelOrderResult);
			//调用成功
			if(jsonResult.getBooleanValue("success")){
				StringBuffer sql=new StringBuffer();
	    		sql.append("select t.order_type,t.order_user,t.order_store,t.order_id,t.need_pay,p.out_trade_no,p.source_type,p.source_table from t_order t ");
	    		sql.append(" left join t_pay_log p ");
	    		sql.append(" on t.order_id=p.out_trade_no ");
	    		sql.append(" where t.order_id=? ");
	    		
	    		Record pay= Db.findFirst(sql.toString(),order.getStr("order_id"));
	    		//赠送提货订单或者余额支付订单，直接转成用户余额
	    		if("2".equals(pay.getStr("order_type"))||("t_user".equals(pay.getStr("source_table"))&&"balance".equals(pay.getStr("source_type"))&&
	    					StringUtil.isNotNull(pay.getStr("out_trade_no"))&&pay.getStr("out_trade_no").length()==18)){
	    			//修改订单为已退款
	    			if(orderOper.updateStatus(order.getInt("id"), order.getInt("order_user"),"7", "6")==1){
		    			//加果币
		    			Db.update("update t_user set balance=balance+? where id=?",
		    					pay.getInt("need_pay"),
		    					pay.getInt("order_user"));
		    			//增加加果币记录
		    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
		    			tBlanceRecord.set("store_id", pay.getStr("order_store"));
		    			tBlanceRecord.set("user_id", order.getInt("order_user"));
		    			tBlanceRecord.set("blance", pay.getInt("need_pay"));
		    			tBlanceRecord.set("ref_type", "orderBack");
		    			tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
		    			tBlanceRecord.set("order_id", order.getStr("order_id"));
		    			tBlanceRecord.save();
		    			logger.info("赠送提货订单或者余额支付订单，直接转成用户余额:"+order.getStr("order_id")+"-blance:"+pay.getInt("need_pay"));
		    			jsonResult.put("success", false);
	    				jsonResult.put("message", "取消订单成功，直接转成用户余额");
	    			}else{
	    				jsonResult.put("success", false);
	    				jsonResult.put("message", "修改订单状态失败");
	    			}
	    		}else{
	    			//直接支付订单
	    			String result=WeChatUtil.refund(order.getStr("order_id"),pay.getInt("need_pay"),
	    					new File(getRequest().getSession().getServletContext().getRealPath("/WEB-INF/classes/apiclient_cert.p12")));
	    			logger.info("直接支付订单result:"+result);
	    			if(result.indexOf("SUCCESS")!=-1){
	    				jsonResult.put("success", true);
	    				jsonResult.put("message", "取消订单成功，直接支付订单已经申请微信退款");
	    				orderOper.updateStatus(order.getInt("id"), order.getInt("order_user"),"7", "6");	
	    				//添加退款记录
	    				XPathParser xpath = WeChatUtil.getParametersByWeChatCallback(getRequest());
	    				XNode refund_fee = xpath.evalNode("//refund_fee");
	    				XNode transaction_id = xpath.evalNode("//transaction_id");
	    				TRefundLog refundLog = new TRefundLog();
	    				refundLog.set("user_id", order.getInt("order_user"));
	    				refundLog.set("refund_fee", refund_fee.body());
	    				refundLog.set("transaction_no", transaction_id.body());
	    				refundLog.set("refund_time", DateFormatUtil.format1(new Date()));
	    				refundLog.save();
	    			}else{
	    				jsonResult.put("success", false);
	    				jsonResult.put("message", "直接支付订单申请微信退款失败");
	    			}
	    		}
	    		logger.info("订单编号："+order.getStr("order_id")+"发送海鼎取消订单成功");
		  }
		}else{
			jsonResult.put("message", "调用接口失败，请联系管理员");
		}
		renderJson(jsonResult);
    }
    /**
     * 手动发送订单到海鼎
     */
    public void orderReduce(){
    	int id=getParaToInt("id");
    	TOrder orderOper=new TOrder();
    	TOrder order=orderOper.findById(id);
    	JSONObject jsonRresult=new JSONObject();
    	if(HdUtil.orderReduce(order.getStr("order_id"))){
    		Db.update("update t_order set hd_status = '0' where order_id = ?", order.getStr("order_id"));
    		jsonRresult.put("msg", "海鼎订单发送成功");
    	}else{
    		jsonRresult.put("msg", "海鼎订单发送失败");
    	}
    	renderJson(jsonRresult);
    }
    public void export(){
    	String orderId=null,createDateBegin=null,createDateEnd=null,phoneNum=null;
    	int orderStatus=-1,hdStatus=-1;
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
    	
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        Date date=new Date(); 
    	for(int i=0;i<formDataJson.size();i++){
        	JSONObject item=formDataJson.getJSONObject(i);
        	if("createDateBegin".equals(item.getString("name"))){
        		createDateBegin=item.getString("value");
        	}else if("createDateEnd".equals(item.getString("name"))){
        		createDateEnd=item.getString("value");
        	}else if("orderId".equals(item.getString("name"))){
        		orderId=item.getString("value");
        	}else if("orderStatus".equals(item.getString("name"))){
        		orderStatus=item.getIntValue("value");
        	}else if("hdStatus".equals(item.getString("name"))){
        		hdStatus=item.getIntValue("value");
        	}else if("phoneNum".equals(item.getString("phoneNum"))){
        		phoneNum=item.getString("value");
        	}
        }
    	
        if(StringUtil.isNull(createDateBegin)){
        	createDateBegin=DateFormatUtil.format5(date)+" 00:00:00";
        }
        if(StringUtil.isNull(createDateEnd)){
        	createDateEnd=DateFormatUtil.format5(date)+" 23:59:59";
        }
        
    	
    	StringBuffer sql=new StringBuffer();
    	sql.append("select t.id,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime, ");
    	sql.append(" date_format(p.time_end,'%H:%i:%s') as time_end,t.order_id,p.transaction_id,if(p.transaction_id is null,'否','是') as wx_pay,t.total,t.discount,t.need_pay,u.phone_num ,u.nickname ,u.balance , ");
    	sql.append(" tp.amount ,tp.unit_price/100 as unit_price,pr.product_name,if(t.order_type=1,'正常购买','仓库提货') as order_type,if(t.deliverytype=1,'门店自提','送货上门') as deliverytype,t.reason, ");
    	sql.append(" tpf.standard,t.hd_status,t.old_order_id,t.delivery_fee,");
    	sql.append("CASE t.order_status ");
    	sql.append("when '1' then '待付款' ");
    	sql.append("when '2' then '支付中' ");
    	sql.append("when '3' then '待收货' ");
    	sql.append("when '4' then '已收货' ");
    	sql.append("when '5' then '退货中' ");
    	sql.append("when '6' then '退货完成' ");
    	sql.append("when '7' then '取消中' ");
    	sql.append("when '8' then '海鼎退货中' ");
    	sql.append("when '9' then '海鼎退货失败' ");
    	sql.append("when '10' then '微信退款失败' ");
    	sql.append("when '11' then '订单成功' ");
    	sql.append("when '12' then '配送中' ");
    	sql.append("when '0' then '已失效' end as order_status");
    	sql.append(" from t_order t ");
    	sql.append(" left join t_store s on t.order_store=s.store_id ");
    	sql.append(" left join t_order_products tp on tp.order_id=t.id ");
    	sql.append(" left join t_product pr on tp.product_id=pr.id ");
    	sql.append(" left join t_product_f tpf on pr.id=tpf.product_id and tp.product_f_id=tpf.id ");
    	sql.append(" left join t_pay_log p on t.order_id=p.out_trade_no ");
    	sql.append(" left join t_user u on t.order_user=u.id ");
    	sql.append(" where  t.createtime between '"+createDateBegin+"' and '"+createDateEnd+"'");
    	if(orderStatus!=-1){
    		sql.append(" and t.order_status=");
    		sql.append(orderStatus);
    	}
    	if(hdStatus!=-1){
    		sql.append(" and t.hd_status=");
    		sql.append(hdStatus);
    	}
    	if(StringUtil.isNotNull(orderId)){
    		sql.append(" and t.order_id like'%");
    		sql.append(orderId);
    		sql.append("%'");
    	}
    	if(StringUtil.isNotNull(phoneNum)){
    		sql.append(" and u.phone_num like'%");
    		sql.append(phoneNum);
    		sql.append("%'");
    	}
    	sql.append(" order by t.createtime");
    	
    	
    	List<Record> list = Db.find(sql.toString());
        /*String[] header={"序号","店铺名称","创建日期","创建时间","支付","订单编号","商户单号",
        		"手机号","昵称","鲜果币","商品数量","价格","商品名称","订单状态","订单类型","规格","海鼎状态"};
        String[] columns={"id","store_name","createtime","commitTime","time_end","order_id","transaction_id",
        			"phone_num","nickname","balance","amount",
        			"unit_price","product_name","order_status","order_type","standard","hd_status"};*/
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="orderList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(createDateBegin.substring(0,10)+"至"+createDateEnd.substring(0,10)+"订单导出").columns(columns);
        render(poirender);
    }
    public void exportPresent(){
    	String presentDateBegin=null,presentDateEnd=null;
    	int presentStatus=-1;
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        Date date=new Date(); 
    	for(int i=0;i<formDataJson.size();i++){
        	JSONObject item=formDataJson.getJSONObject(i);
        	if("presentDateBegin".equals(item.getString("name"))){
        		presentDateBegin=item.getString("value");
        	}else if("presentDateEnd".equals(item.getString("name"))){
        		presentDateEnd=item.getString("value");
        	}else if("presentStatus".equals(item.getString("name"))){
        		presentStatus=item.getIntValue("value");
        	}
        }
    	
        if(StringUtil.isNull(presentDateBegin)){
        	presentDateBegin=DateFormatUtil.format5(date)+" 00:00:00";
        }
        if(StringUtil.isNull(presentDateEnd)){
        	presentDateEnd=DateFormatUtil.format5(date)+" 23:59:59";
        }
        
    	StringBuffer sql=new StringBuffer();
    	sql.append("select (select nickname from t_user where id=t.present_user) present_user,(select nickname from t_user where id=t.target_user) target_user,present_time,present_status,need_pay,present_msg,discount");
    	sql.append(" from t_present t ");
    	sql.append(" where  t.present_time between '"+presentDateBegin+"' and '"+presentDateEnd+"' ");
    	if(presentStatus>-1){
    		sql.append(" and t.present_status ="+presentStatus);
    	}
    	sql.append(" order by t.present_time desc");
    	List<Record> list = Db.find(sql.toString());
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="presentList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(presentDateBegin.substring(0,10)+"至"+presentDateEnd.substring(0,10)+"赠送导出").columns(columns);
        render(poirender);
    }
    private TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);
    //调货
    public void initRechange(){
    	//查询到店铺列表
    	TStore store=new TStore();
    	setAttr("stores", store.findAllStores());
    	//根据订单编号获取订单信息
    	StringBuffer sql=new StringBuffer();
    	sql.append("select t.id,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime, ");
    	sql.append(" t.order_id,u.phone_num ,u.nickname , ");
    	sql.append(" if(t.order_type=1,'正常购买','仓库提货') as order_type,if(t.deliverytype=1,'门店自提','送货上门') as deliverytype,t.reason, ");
    	sql.append(" t.hd_status,");
    	sql.append("CASE t.order_status ");
    	sql.append("when '1' then '待付款' ");
    	sql.append("when '2' then '支付中' ");
    	sql.append("when '3' then '待收货' ");
    	sql.append("when '4' then '已收货' ");
    	sql.append("when '5' then '退货中' ");
    	sql.append("when '6' then '退货完成' ");
    	sql.append("when '7' then '取消中' ");
    	sql.append("when '8' then '海鼎退货中' ");
    	sql.append("when '9' then '海鼎退货失败' ");
    	sql.append("when '10' then '微信退款失败' ");
    	sql.append("when '11' then '订单成功' ");
    	sql.append("when '0' then '已失效' end as order_status");
    	sql.append(" from t_order t ");
    	sql.append(" left join t_store s on t.order_store=s.store_id ");
    	sql.append(" left join t_user u on t.order_user=u.id ");
    	sql.append(" where t.id=");
    	sql.append(getPara("id"));
    	//查找到当前订单
    	setAttr("order", Db.findFirst(sql.toString()));
    	render(AppConst.PATH_MANAGE_PC + "/order/rechange.ftl");
    }
    public void rechange(){
    	TOrder order=new TOrder();
    	order=order.findTOrderByOrderId(getPara("order_id"));
    	if(order==null){
    		redirect("/orderManage/initOrderList");
    		return;
    	}
    	String newOrderId=orderNoGenerator.nextId();
    	//将原来店铺订单发送退单处理
    	HdUtil.orderCancel(getPara("order_id"),"订单选错店铺了");
    	HdUtil.orderRejected(getPara("order_id"));
    	//在新的店铺发送海鼎订单
    	order.set("order_store", getPara("order_store"));
    	order.set("hd_status", "1");
    	order.set("old_order_id", order.get("order_id"));
    	order.set("order_id", newOrderId);
    	order.update();
    	//修改日志表中的订单编号
    	/*TPayLog payLog=new TPayLog();
    	payLog.findTPayLogByOrderId(order.get("order_id"));
    	payLog.set("out_trade_no", newOrderId);
    	payLog.update();*/
    	redirect("/orderManage/initOrderList");
    }
    /**
     * 初始化订单统计页面
     */
    public void orderStat(){
    	Date date= new Date();
    	//将服务器端的初始化时间放到页面
    	setAttr("payDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("payDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
        render(AppConst.PATH_MANAGE_PC + "/order/orderStat.ftl");
    }
    public void orderStatResult(){
    	String payDateBegin=getPara("payDateBegin");
    	String payDateEnd=getPara("payDateEnd");
    	Date payDateBeginData= DateUtil.convertString2Date(payDateBegin);
    	Date payDateEndData= DateUtil.convertString2Date(payDateEnd);
    	String dateBegin=DateFormatUtil.format3(payDateBeginData);
    	String dateEnd=DateFormatUtil.format3(payDateEndData);
    	List<Record> result=Db.find("select case source_type when 'order' then '微信支付金额' "
    			+ "when 'recharge' then '充值金额' when 'balance' "
    			+ "then '鲜果币支付金额' when 'present' "
    			+ "then '赠送订单金额' end as source_type,"
    			+ "sum(total_fee) as total_fee "
    			+ " from t_pay_log where time_end BETWEEN ? and ? group by source_type",dateBegin,dateEnd);
    	//Record orderStat = Db.findFirst("select sum(need_pay) total from t_order where order_status in(3,4,11) and createtime between ? and ?",payDateBegin,payDateEnd);
    	//setAttr("orderStat",orderStat);
    	String sql="select case order_status when 3 then '已付款订单金额' "
    			+ "when 4 then '已收货订单金额' "
    			+ "when 11 then '已完成订单金额' "
    			+ "when 6 then '退货订单金额' end as orderStatus,"
    			+ "sum(need_pay) as total from t_order where order_status in(3,4,11,6) "
    			+ "and createtime between ? and ? group by orderStatus";
    	List<Record> orderStat=Db.find(sql, payDateBegin,payDateEnd);
    	setAttr("orderStat",orderStat);
    	setAttr("result", result);
    	setAttr("payDateBegin",payDateBegin);
    	setAttr("payDateEnd",payDateEnd);
    	render(AppConst.PATH_MANAGE_PC + "/order/orderStat.ftl");
    }
    //赠送页面初始化
    public void initPresent(){
    	//t_present
    	Date date= new Date();
    	//将服务器端的初始化时间放到页面
    	setAttr("presentDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("presentDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
    	render(AppConst.PATH_MANAGE_PC +"/order/present.ftl");
    }
    //json返回赠送记录
    public void presentList(){
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String presentDateBegin=getPara("presentDateBegin");
        String presentDateEnd=getPara("presentDateEnd");
        if(StringUtil.isNull(presentDateBegin)){
        	presentDateBegin=DateFormatUtil.format5(new Date());
        }
        if(StringUtil.isNull(presentDateEnd)){
        	presentDateEnd=DateFormatUtil.format5(new Date());
        }
        int presentStatus=-1;
        if(StringUtil.isNotNull(getPara("presentStatus"))){
        	presentStatus=getParaToInt("presentStatus");
        }
        
        TPresent present=new TPresent();
        Page<Record> pageInfo=present.presentList(presentStatus, presentDateBegin,presentDateEnd, pageSize, page, sidx, sord);


        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            row.add(rc.getStr("present_user"));
            row.add(rc.getStr("target_user"));
            row.add(rc.getStr("present_time"));
            row.add(rc.get("present_status"));
            row.add(rc.get("need_pay"));
            row.add(rc.getStr("present_msg"));
            row.add(rc.get("discount"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
  //充值查询页面初始化
    public void initRecharge(){
    	Date date= new Date();
    	//将服务器端的初始化时间放到页面
    	setAttr("rechargeDateBegin",DateFormatUtil.format5(date)+" 00:00:00");
    	setAttr("rechargeDateEnd",DateFormatUtil.format5(date)+" 23:59:59");
    	render(AppConst.PATH_MANAGE_PC +"/order/rechargeList.ftl");
    }
    //json返回赠送记录
    public void rechargeList(){
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String rechargeDateBegin=getPara("rechargeDateBegin");
        String rechargeDateEnd=getPara("rechargeDateEnd");
        
    	
        if(StringUtil.isNull(rechargeDateBegin)){
        	rechargeDateBegin=DateFormatUtil.format5(new Date())+"000000";
        }else{
        	Date rechargeDateBeginData= DateUtil.convertString2Date(rechargeDateBegin);
        	rechargeDateBegin=DateFormatUtil.format3(rechargeDateBeginData);
        }
        if(StringUtil.isNull(rechargeDateEnd)){
        	rechargeDateEnd=DateFormatUtil.format5(new Date())+"235959";
        }else{
        	Date rechargeDateEndData= DateUtil.convertString2Date(rechargeDateEnd);
        	rechargeDateEnd=DateFormatUtil.format3(rechargeDateEndData);
        }
        
        TPayLog payLog=new TPayLog();
        
        Page<Record> pageInfo=payLog.payLogList(rechargeDateBegin,rechargeDateEnd, pageSize, page, sidx, sord);


        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            row.add(rc.getStr("transaction_id"));
            row.add(rc.getInt("total_fee"));
            row.add(rc.getInt("give_fee"));
            row.add(rc.get("time_end"));
            row.add(rc.getStr("nickname"));
            row.add(rc.getStr("phone_num"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * 充值记录导出
     */
    public void exportRecharge(){
    	String rechargeDateBegin=null,rechargeDateEnd=null;
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        Date date=new Date(); 
    	for(int i=0;i<formDataJson.size();i++){
        	JSONObject item=formDataJson.getJSONObject(i);
        	if("rechargeDateBegin".equals(item.getString("name"))){
        		rechargeDateBegin=item.getString("value");
        	}else if("rechargeDateEnd".equals(item.getString("name"))){
        		rechargeDateEnd=item.getString("value");
        	}
        }
    	
        if(StringUtil.isNull(rechargeDateBegin)){
        	rechargeDateBegin=DateFormatUtil.format5(date)+"000000";
        }else{
        	Date rechargeDateBeginData= DateUtil.convertString2Date(rechargeDateBegin);
        	rechargeDateBegin=DateFormatUtil.format3(rechargeDateBeginData);
        }
        if(StringUtil.isNull(rechargeDateEnd)){
        	rechargeDateEnd=DateFormatUtil.format5(date)+"235959";
        }else{
        	Date rechargeDateEndData= DateUtil.convertString2Date(rechargeDateEnd);
        	rechargeDateEnd=DateFormatUtil.format3(rechargeDateEndData);
        }
        String sql="select t.*,u.nickname "+
		" from t_pay_log t left join t_user u on t.openid=u.open_id "+
		" where  t.source_type='recharge' and t.time_end between '"+rechargeDateBegin+"' and '"+rechargeDateEnd+"'  order by t.time_end desc";
    	List<Record> list = Db.find(sql);
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="rechargeList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(rechargeDateBegin.substring(0,10)+"至"+rechargeDateEnd.substring(0,10)+"充值 导出").columns(columns);
        render(poirender);
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
    	List<Record> payStatBySex= payLog.payStatBySex();
    	setAttr("payStatBySex",payStatBySex);
    	//按照店铺统计
    	TOrder orderOper=new TOrder();
    	List<Record> statByStore= orderOper.orderStatByStore();
    	setAttr("statByStore",statByStore);
    	
    	//根据订单类型统计
    	List<Record> statByType=orderOper.orderStatByType();
    	setAttr("statByType",statByType);
    	
    	//根据水果类型统计
    	List<Record> orderStatByFruitType=orderOper.getOrderStatByFruitType();
    	setAttr("orderStatByFruitType",orderStatByFruitType);
    	
    	//根据干果类型统计
    	List<Record> orderStatByUntsType=orderOper.getOrderStatByUntsType();
    	setAttr("orderStatByUntsType",orderStatByUntsType);
        
        //未消费 已消费统计
        TUser tUserOper=new TUser();
        Record xf= tUserOper.findTUserBalanceTotal();
        setAttr("xf",xf);
        
        //查询海鼎发送失败的订单
        TOrder failOrder=new TOrder();
        setAttr("orderFailCount", failOrder.findFailOrder().getLong("orderFailCount"));
        render(AppConst.PATH_MANAGE_PC + "/order/allStatOverview.ftl");
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
    
    /**
     * 订单退款
     * @throws Exception 
     */
    public void orderRefuse() throws Exception{
    	String id=getPara("id");
    	TOrder order = TOrder.dao.findById(id);
    	JSONObject result = new JSONObject();
    	if(order!=null){
    		if("4".equals(order.getStr("order_status"))){
    			String sql="select t.order_type,t.order_user,t.order_store,t.order_id,t.need_pay,p.out_trade_no,p.source_type,p.source_table "
    					+ "from t_order t left join t_pay_log p on t.order_id=p.out_trade_no where t.order_id=? ";
	    		Record pay= Db.findFirst(sql,order.getStr("order_id"));
	    		//余额支付订单，直接转成用户余额
	    		if("t_user".equals(pay.getStr("source_table"))&&"balance".equals(pay.getStr("source_type"))){
	    			//修改订单为已退款
	    			if(order.updateStatus(order.getInt("id"), order.getInt("order_user"),"4", "6")==1){
		    			//加果币
		    			Db.update("update t_user set balance=balance+? where id=?",
		    					pay.getInt("need_pay"),
		    					pay.getInt("order_user"));
		    			//增加加果币记录
		    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
		    			tBlanceRecord.set("store_id", pay.getStr("order_store"));
		    			tBlanceRecord.set("user_id", order.getInt("order_user"));
		    			tBlanceRecord.set("blance", pay.getInt("need_pay"));
		    			tBlanceRecord.set("ref_type", "orderBack");
		    			tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
		    			tBlanceRecord.set("order_id", order.getStr("order_id"));
		    			tBlanceRecord.save();
		    			logger.info("赠送提货订单或者余额支付订单，直接转成用户余额:"+order.getStr("order_id")+"-blance:"+pay.getInt("need_pay"));
		    			result.put("success", false);
		    			result.put("msg", "取消订单成功，直接转成用户余额");
	    			}else{
	    				result.put("success", false);
	    				result.put("msg", "修改订单状态失败");
	    			}
	    		}else{
	    			//直接支付订单
	    			String xml=WeChatUtil.refund(order.getStr("order_id"),order.getInt("need_pay"),
	    					new File(getRequest().getSession().getServletContext().getRealPath("/WEB-INF/classes/apiclient_cert.p12")));
	    			logger.info("直接支付订单result:"+xml);
	    			if(xml.indexOf("SUCCESS")!=-1){
	    				result.put("success", true);
	    				result.put("msg", "取消订单成功，直接支付订单已经申请微信退款");
	    				order.updateStatus(order.getInt("id"), order.getInt("order_user"),"4", "6");
	    				//添加退款记录
	    				XPathParser xpath=new XPathParser(xml);
	    				XNode refund_fee = xpath.evalNode("//refund_fee");
	    				XNode transaction_id = xpath.evalNode("//transaction_id");
	    				TRefundLog refundLog = new TRefundLog();
	    				refundLog.set("user_id", order.getInt("order_user"));
	    				refundLog.set("refund_fee", refund_fee.body());
	    				refundLog.set("transaction_no", transaction_id.body());
	    				refundLog.set("refund_time", DateFormatUtil.format1(new Date()));
	    				refundLog.set("order_id",order.getStr("order_id") );
	    				refundLog.save();
	    			}else{
	    				result.put("success", false);
	    				result.put("msg", "直接支付订单申请微信退款失败");
	    			}
	    		}
    		}else{
    			result.put("success", false);
    			result.put("msg", "该订单状态无法操作退款");
    		}
    	}else{
    		result.put("success", false);
    		result.put("msg", "没有此订单");
    	}
    	renderJson(result);
    }
    
    
}
