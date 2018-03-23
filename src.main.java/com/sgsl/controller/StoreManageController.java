package com.sgsl.controller;

import java.io.IOException;
import java.util.*;

import org.sqlite.SQLiteConfig.TempStore;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.ext.render.excel.PoiRender;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.render.Render;
import com.revocn.controller.BaseController;
import com.sgsl.components.dada.DadaDeliver;
import com.sgsl.components.dada.DadaProps;
import com.sgsl.components.dada.DadaService;
import com.sgsl.components.dada.vo.ShopParam;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.TProductF;
import com.sgsl.model.TStore;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;


/**
 *店铺管理
 */
public class StoreManageController extends BaseController {
    protected final static Logger logger = Logger.getLogger(StoreManageController.class);

    /**
     * 
     */
    public void initStoreList() {
        render(AppConst.PATH_MANAGE_PC + "/store/storeList.ftl");
    }

    /**
     * ajax查询
     */
    public void storeList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String storeName=getPara("storeName");
        
        TStore store=new TStore();
        StringBuffer sql=new StringBuffer("from t_store");
        if(StringUtil.isNotNull(storeName)){
        	sql.append(" where store_name like'%");
        	sql.append(storeName);
        	sql.append("%'");        	
        }
        if(StringUtil.isNotNull(sidx)){
        	sql.append(" order by ");
        	sql.append(sidx);
        	sql.append(" ");
        	sql.append(sord);
        }
        Page<TStore> stores= store.paginate(page, pageSize, "select *", sql.toString());


        JSONObject result=new JSONObject();
        result.put("total",stores.getTotalPage());
        result.put("page",stores.getPageNumber());
        result.put("records",stores.getPageSize());

        JSONArray rows=new JSONArray();
        for (TStore ts:stores.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",ts.getInt("id"));
            row.add("");
            row.add(ts.getInt("id"));
            row.add(ts.getStr("store_id"));
            row.add(ts.getStr("store_name"));
            row.add(ts.getStr("store_phone"));
            row.add(ts.getStr("store_addr"));
            row.add(ts.getStr("lat"));
            row.add(ts.getStr("lng"));
            row.add(ts.getStr("store_declar"));
            row.add(ts.getInt("qrcode_img"));
            row.add(ts.getInt("wxgroup_img"));
            row.add(ts.getInt("store_img"));
            row.add(ts.getStr("belong_area"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * 店铺增删改
     */
    public void storeSave(){
    	TStore tStore = getModel(TStore.class,"sl");
    	if("del".equals(getPara("oper"))){
    		tStore.set("id", getParaToInt("id"));
    		tStore.delete();
    	}else if("add".equals(getPara("oper"))){
    		tStore.save();
    	}else{
    		tStore.update();
    	}
    	redirect("/storeManage/initStoreList");
    }
    
    public void export(){
    	String orderId=null,createDateBegin=null,createDateEnd=null;
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
        	}
        }
    	
        if(StringUtil.isNull(createDateBegin)){
        	createDateBegin=DateFormatUtil.format5(date);
        }
        if(StringUtil.isNull(createDateEnd)){
        	createDateEnd=DateFormatUtil.format5(date);
        }
        
    	
    	StringBuffer sql=new StringBuffer();
    	sql.append("select t.id,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime, ");
    	sql.append(" date_format(p.time_end,'%H:%i:%s') as time_end,t.order_id,p.transaction_id ,u.phone_num ,u.nickname ,u.balance , ");
    	sql.append(" tp.amount ,tp.unit_price,pr.product_name ,t.order_status ,if(t.order_type=1,'正常购买','仓库提货') as order_type, ");
    	sql.append(" tpf.standard,t.hd_status ");
    	sql.append(" from t_order t ");
    	sql.append(" left join t_store s on t.order_store=s.store_id ");
    	sql.append(" left join t_order_products tp on tp.order_id=t.id ");
    	sql.append(" left join t_product pr on tp.product_id=pr.id ");
    	sql.append(" left join t_product_f tpf on pr.id=tpf.product_id ");
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
        		.headers(header).sheetName(createDateBegin+"至"+createDateEnd+"订单导出").columns(columns);
        render(poirender);
    }

    //门店上传到达达
    public void store2Dada() throws IOException{
    	String storeId = getPara("store_Id");
    	if(StringUtil.isNull(storeId)){
    		return ;
    	}
    	Map<String,Object> result = new HashMap<>();
    	String message;
    	TStore tstore = TStore.dao.getStoreByStoreId(storeId);
    	
    	ShopParam shopparam = new ShopParam();
		shopparam.setOriginShopId(storeId);
		shopparam.setStationName(tstore.get("store_name"));
		shopparam.setCityName("长沙");
		shopparam.setAreaName(tstore.getStr("belong_area"));
		shopparam.setStationAddress(tstore.get("store_addr"));
		shopparam.setPhone(tstore.get("store_phone"));
		shopparam.setContactName("水果熟了");
		shopparam.setLat(Double.valueOf(tstore.get("lat")));
		shopparam.setLng(Double.valueOf(tstore.get("lng")));
    	//构建门店参数，用来上传到达达
    	
		DadaService dada = this.dadaService();
		logger.error("===============================");
		logger.error("上传到达达门店的信息:"+shopparam.toString());
		
		String storeinfo = dada.shopDetail(storeId);
		
		logger.error("========================================");
		logger.error("查询达达里门店详情："+new String(storeinfo.getBytes(),"UTF-8"));
		
		JSONObject jsonobject = JSONObject.parseObject(new String(storeinfo.getBytes(),"UTF-8"));
		
		String status = jsonobject.getString("status");
		boolean flag = "success".equals(status);
		
		if(flag){
			String newshopid = "";
			String storestatus = "1";
			
			String updatestring = dada.updateShop(shopparam, newshopid, Integer.valueOf(storestatus));
			
			logger.error("========================================");
			logger.error("更新门店到达达返回的信息："+new String(updatestring.getBytes(),"UTF-8"));
			JSONObject updatajson = JSONObject.parseObject(new String(updatestring.getBytes(),"UTF-8"));
		
			status = updatajson.getString("status");
			message = updatajson.getString("msg");
		}else{
			String createstring = dada.addShop(shopparam,JSONArray::toJSONString);
			logger.error("========================================");
			logger.error("新建门店到达达返回的信息："+new String(createstring.getBytes(),"UTF-8"));
			JSONObject creatjson = JSONObject.parseObject(new String(createstring.getBytes(),"UTF-8"));
			
			status = creatjson.getString("status");
			message = creatjson.getString("msg");
		}
		result.put("success", status);
		result.put("msg", message);
		
		renderJson(result);
    }
    
    //获取DadaService
    public DadaService dadaService(){
    	DadaService dadaService;
    	
    	DadaProps props = new DadaProps();
    	
    	String appKey = AppProps.get("appKey");
    	String appSecret = AppProps.get("appSecret");
    	String url = AppProps.get("url");
    	String sourceId = AppProps.get("sourceId");
    	String version = AppProps.get("version");
    	String format = AppProps.get("format");
    	String charset = AppProps.get("charset");
    	String backUrl = AppProps.get("backUrl");
    	
    	props.setAppKey(appKey);
    	props.setAppSecret(appSecret);
    	props.setBackUrl(backUrl);
    	props.setCharset(charset);
    	props.setFormat(format);
    	props.setSourceId(sourceId);
    	props.setUrl(url);
    	props.setVersion(version);
    	
    	DadaDeliver dadaDeliver = new DadaDeliver(props);
    	dadaService = new DadaService(dadaDeliver, JSON::toJSONString);
    	
    	return dadaService;
    }
}
