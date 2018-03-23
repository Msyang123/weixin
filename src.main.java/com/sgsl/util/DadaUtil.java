package com.sgsl.util;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.components.FengniaoService;
import com.sgsl.components.config.ElemeOpenConfig;
import com.sgsl.components.dada.DadaApis;
import com.sgsl.components.dada.DadaDeliver;
import com.sgsl.components.dada.DadaProps;
import com.sgsl.components.dada.DadaService;
import com.sgsl.components.dada.vo.OrderParam;
import com.sgsl.components.request.FengNiaoData;
import com.sgsl.components.request.Item;
import com.sgsl.components.request.Receiver;
import com.sgsl.components.request.Transport;
import com.sgsl.config.AppProps;
import com.sgsl.model.TOrder;
import com.sgsl.model.TProductF;
import com.sgsl.model.TStore;
import com.sgsl.utils.MapUtil;
import com.sgsl.wechat.BaiduMapUtil;

public class DadaUtil {
	private DadaProps config=null;
	private ElemeOpenConfig fnconfig=null;
	protected final static Logger logger = Logger.getLogger(DadaUtil.class);
	public DadaUtil(){
		//dada读取配置信息
		config=new DadaProps();
		config.setAppKey(AppProps.get("appKey"));
		config.setAppSecret(AppProps.get("appSecret"));
		config.setCharset(AppProps.get("charset"));
		config.setFormat(AppProps.get("format"));
		config.setSourceId(AppProps.get("sourceId"));
		config.setVersion(AppProps.get("version"));
		config.setUrl(AppProps.get("url"));
		config.setBackUrl(AppProps.get("backUrl"));
		
		//蜂鸟读取配制信息
		fnconfig=new ElemeOpenConfig();
		fnconfig.setAppKey(AppProps.get("fnAppKey"));
		fnconfig.setAppSecret(AppProps.get("fnAppSecret"));
		fnconfig.setCharset("UTF-8");
		fnconfig.setVersion("/v2");
		fnconfig.setUrl(AppProps.get("fnUrl"));
		fnconfig.setBackUrl(AppProps.get("fnBackUrl"));
	}
	/**
	 * 达达配送订单处理
	 * @return
	 */
	public JSONObject send(String ordId){
		TOrder orderOper=new TOrder();
		TOrder order = orderOper.findTOrderByOrderId(ordId);
		order.setOrderProducts(orderOper.findOrderProList(order.getInt("id")));
		String deliveryAddress =order.getStr("address_detail");
    	String orderId=order.getStr("order_id");
    	logger.info("订单达达配送："+order.getInt("order_user")+"-"+orderId);
    	
    		
		//达达处理类
		DadaService dadaService=new DadaService(new DadaDeliver(config),JSON::toJSONString);
		
		OrderParam orderParam=new OrderParam();
		orderParam.setCallback(dadaService.getDadaDeliver().getProps().getBackUrl());
		double weight=0.0;
		TProductF productF=new TProductF();
		for(Record orderProduct:order.getOrderProducts()){
			Record pf= productF.findTProductFAndProductById(orderProduct.getInt("product_f_id"));
			// 数量乘以单位重量
			weight+=pf.getDouble("base_count")* pf.getDouble("product_amount")*orderProduct.getDouble("amount");
		}
		orderParam.setCargoNum(order.getOrderProducts().size());
		orderParam.setCargoPrice(order.getInt("need_pay"));//分
		orderParam.setCargoWeight(weight);
		orderParam.setCityCode("0731");
		orderParam.setInfo(order.getStr("customer_note"));
		
		if(order.getDouble("lat")!=null&&order.getDouble("lng")!=null){
			orderParam.setLat(order.getDouble("lat"));
			orderParam.setLng(order.getDouble("lng"));
		}else{
			// 有地址，则根据地址获取经纬度 此处不能通过前端传递的实时定位经纬度处理 因为可能用户在路上下单
			JSONObject json = null;
				try {
					json = BaiduMapUtil.getLocation(deliveryAddress);
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (json != null) {
					JSONObject addressResultJson = json.getJSONObject("result");
					JSONObject location =addressResultJson.getJSONObject("location");
					if (location != null) {
						orderParam.setLat(Double.valueOf(location.get("lat").toString()));
						orderParam.setLng(Double.valueOf(location.get("lng").toString()));
					}
				}
		}
		logger.info("达达配送经纬度lat"+order.getDouble("lat")+"lng"+order.getDouble("lng"));	
		logger.info("lat:"+orderParam.getLat()+"--lng"+orderParam.getLng());
		TStore store=new TStore().getStoreByStoreId(order.getStr("order_store"));
		double meDistance=Double.valueOf(MapUtil.getDistance(store.getStr("lat"), store.getStr("lng"), ""+orderParam.getLat(), ""+orderParam.getLng()));
		logger.info("自己计算门店到收货地址距离："+meDistance);
		if(meDistance>5.0){
			JSONObject resultJson = new JSONObject();
			resultJson.put("code", -1);
			resultJson.put("msg", "自己计算距离"+meDistance+"超过配送5km范围");
			
			return resultJson;
		}
			orderParam.setOriginId(orderId);
			orderParam.setOriginMark("wsc");//order.getStr("customer_note"));
			orderParam.setReceiverAddress(deliveryAddress);
			orderParam.setReceiverName(order.getStr("receiver_name"));
			orderParam.setReceiverPhone(order.getStr("receiver_mobile"));
			orderParam.setReceiverTel("");
			
			orderParam.setShopNo(order.getStr("order_store"));
			
			//orderParam.setShopNo("11047059");
			
			JSONObject addOrderResult= null;
			try {
				//发送至达达配送 不需要再做转换坐标位置，因为已经使用的是腾讯坐标系，与达达的高德为同一个系
				addOrderResult=JSONObject.parseObject(dadaService.order(orderParam, DadaApis.API_ADD_ORDER, false));//dadaService.addOrder(orderParam)
				//String currentTime=DateFormatUtil.format1(new Date());
				//如果已经发过了，调用重复发单
				if(addOrderResult!=null&&2105==addOrderResult.getIntValue("code")){
					addOrderResult=JSONObject.parseObject(dadaService.order(orderParam,DadaApis.API_RE_ADD_ORDER, false));//.reAddOrder(orderParam);
					logger.debug(addOrderResult.toJSONString());
					//更新订单信息在回调中处理
				}
				logger.info(addOrderResult.toJSONString());
				
			} catch (IOException e) {
				e.printStackTrace();
				logger.error("错了"+e.getMessage());
			}
			return addOrderResult;
	}
	
	/**
	 * 发送订单给蜂鸟
	 * @return
	 * @throws Exception 
	 */
	public JSONObject sendFn(String orderId,String accessToken,String currentTime) throws Exception{
    	FengNiaoData fengNiaoData = new FengNiaoData();
    	TOrder order = TOrder.dao.findTOrderByOrderId(orderId);//订单
		order.setOrderProducts(TOrder.dao.findOrderProList(order.getInt("id")));//订单商品
        //开始设置data中的订单信息
        fengNiaoData.setPartnerRemark(order.getStr("customer_note"));
        fengNiaoData.setPartnerOrderCode(orderId);
        fengNiaoData.setNotifyUrl(fnconfig.getBackUrl());
        fengNiaoData.setOrderType(1);
        fengNiaoData.setChainStoreCode(order.getStr("order_store"));
        //设置transport
        Transport transport = new Transport();
        TStore store = TStore.dao.getStoreByStoreId(order.getStr("order_store"));
        transport.setName("水果熟了-"+store.getStr("store_name"));
        transport.setAddress(store.getStr("store_addr"));
        transport.setLatitude(Double.valueOf(store.getStr("lat")));
        transport.setLongitude(Double.valueOf(store.getStr("lng")));
        transport.setPositionSource(1);
        transport.setTel(store.getStr("store_phone"));
        transport.setRemark("");
        fengNiaoData.setTransport(transport);
        //订单明细
        List<Item> items = new ArrayList<>();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(order.getStr("createtime")));
        fengNiaoData.setOrderAddTime(calendar.getTimeInMillis());
        fengNiaoData.setOrderTotalAmount((double)(order.getInt("total")/100.0));
        fengNiaoData.setOrderActualAmount((double)(order.getInt("need_pay")/100.0));
        
        fengNiaoData.setOrderRemark(order.getStr("customer_note"));
        fengNiaoData.setInvoiced(0);
        fengNiaoData.setOrderPaymentStatus(1);
        fengNiaoData.setOrderPaymentMethod(1);
        fengNiaoData.setAgentPayment(0);

        //设置receiver
        Receiver receiver = new Receiver();
        receiver.setName(order.getStr("receiver_name"));
        receiver.setPrimaryPhone(order.getStr("receiver_mobile"));
        receiver.setAddress(order.getStr("address_detail"));
        
        //经度
        receiver.setLongitude(order.getDouble("lng"));
        //纬度
        receiver.setLatitude(order.getDouble("lat"));
        receiver.setPositionSource(1);
        fengNiaoData.setReceiver(receiver);
      //设置items
        double orderWeight=0.0;
		TProductF productF=new TProductF();
		for(Record orderProduct:order.getOrderProducts()){
			Item item = new Item();
			Record pf= productF.findTProductFAndProductById(orderProduct.getInt("product_f_id"));
			// 数量乘以单位重量
			orderWeight+=pf.getDouble("base_count")* pf.getDouble("product_amount")*orderProduct.getDouble("amount");
			item.setId(pf.getStr("product_code"));
			item.setName(pf.getStr("product_name"));
			item.setQuantity((new Double(orderProduct.getDouble("amount"))).intValue());//订单商品数量
			item.setPrice((double)pf.getInt("real_price"));
			item.setActualPrice((double)order.getInt("need_pay"));
		    item.setNeedPackage(0);
            item.setAgentPurchase(0);
            items.add(item);
		}
        //订单重量
        fengNiaoData.setOrderWeight(orderWeight);
        fengNiaoData.setItems(items);
        fengNiaoData.setGoodsCount(items.size());
        String deliveryTimeStart=null;
        if(StringUtil.isNotNull(currentTime)){
        	deliveryTimeStart=currentTime;
        }else{
        	String a = order.getStr("deliverytime");
        	String[] b=a.split(" ");
        	String date=b[0];//日期 2018-02-28
        	String[] d=b[1].split("-");
        	String time=d[1];//时间 15:55:00
        	deliveryTimeStart = date + " "
        			+ time+":00";
        }
        logger.info(deliveryTimeStart);
        // 配送到达时间加1小时
        long times = DateUtil.convertString2Date(deliveryTimeStart).getTime() + 60 * 60 * 1000;
        fengNiaoData.setRequireReceiveTime(times);
        FengniaoService service=new FengniaoService(fnconfig);
        JSONObject obj=JSON.parseObject(service.addOrder(fengNiaoData,accessToken));
		return obj;
	}
}
