package com.sgsl.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.components.config.ElemeOpenConfig;
import com.sgsl.components.dada.DadaDeliver;
import com.sgsl.components.dada.DadaProps;
import com.sgsl.components.dada.DadaService;
import com.sgsl.components.dada.vo.OrderParam;
import com.sgsl.components.sign.OpenSignHelper;
import com.sgsl.config.AppProps;
import com.sgsl.model.TDeliverNote;
import com.sgsl.model.TOrder;
import com.sgsl.model.TProductF;
import com.sgsl.model.TStore;
import com.sgsl.util.DadaUtil;
import com.sgsl.util.DeliverArea;
import com.sgsl.util.RedisUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.MapUtil;
import com.sgsl.wechat.BaiduMapUtil;
import com.sgsl.wechat.TwitterIdWorker;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 达达配送处理类
 * @author User
 *
 */
public class DadaDeliverController extends BaseController {

	protected final static Logger log = Logger.getLogger(DadaDeliverController.class);

	private TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);

	/**
	 * 达达配送回调
	 * 
	 * @param
	 */
	public void callBack() {
		HttpServletRequest request = getRequest();
		log.info("达达配送回调");
		try {
			InputStream result = request.getInputStream();
			// 转换成utf-8格式输出
			BufferedReader in = new BufferedReader(new InputStreamReader(result, "UTF-8"));
			List<String> lst = IOUtils.readLines(in);
			IOUtils.closeQuietly(result);
			String resultStr = StringUtils.join(lst, "");
			log.info("backOrder-jsonData:" + resultStr);

			log.info("传入JSON字符串：" + resultStr);
			JSONObject getJsonVal = JSONObject.parseObject(resultStr);
			log.info("getJsonVal = " + getJsonVal.toString());

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("client_id", getJsonVal.getString("client_id"));
			param.put("order_id", getJsonVal.getString("order_id"));
			param.put("update_time", getJsonVal.getString("update_time"));
			param.put("signature", getJsonVal.getString("signature"));

			// 读取配置信息
			DadaProps config = new DadaProps();
			config.setAppKey(AppProps.get("appKey"));
			config.setAppSecret(AppProps.get("appSecret"));
			config.setCharset(AppProps.get("charset"));
			config.setFormat(AppProps.get("format"));
			config.setSourceId(AppProps.get("sourceId"));
			config.setVersion(AppProps.get("version"));
			config.setUrl(AppProps.get("url"));
			config.setBackUrl(AppProps.get("backUrl"));
			// 达达处理类
			DadaDeliver dadaDeliver = new DadaDeliver(config);
			// 判定签名是否正确 防止被篡改
			if (dadaDeliver.backSginature(param)) {
				String orderId = getJsonVal.getString("order_id");
				TOrder order = new TOrder().findTOrderByOrderId(orderId);
				TDeliverNote deliverNote = new TDeliverNote();
				if (order == null) {
					log.error("未找到达达配送回调订单:" + orderId);
				} else {
					// 修改达达为最新状态
					// 达达配送状态 待接单＝1 待取货＝2 配送中＝3 已完成＝4 已取消＝5 已过期＝7 指派单=8
					// 系统故障订单发布失败=1000 可参考文末的状态说明
					switch (getJsonVal.getIntValue("order_status")) {
					// 待接单
					case 1:
						/*
						 * updateOrderStatusMap=new HashMap<String,Object>();
						 * updateOrderStatusMap.put("N_ORD_STATUS",
						 * showTypeOperator.toMybatisParamter(OrderStatusType.
						 * waitSendOut));
						 * updateOrderStatusMap.put("ORD_NORMAL_CODE", orderId);
						 * //修改订单状态为配送中 sqlSession.update(
						 * "t_order_normal.updateStatusOnlyByOrdCode",
						 * updateOrderStatusMap);
						 */
						// 修改配送信息 0-未接单 1-待取货 2-配送中 3-配送完成 4-配送失败 5-未配送
						deliverNote.updateStatusByOrderId("0", orderId,2);
						break;
					// 待取货
					case 2:
						// 修改订单状态为配送中 已经在海鼎备货回调中改成配送中状态了
						/*order.set("order_status", "12");
						order.update();*/
						// 修改配送信息
						deliverNote.updateNoteToAccept(getJsonVal.getString("dm_name"),
								getJsonVal.getString("dm_mobile"), orderId);
						break;
					// 配送中
					case 3:

						// 修改配送信息
						deliverNote.updateStatusByOrderId("2", orderId,2);
						break;
					// 配送完成
					case 4:
						// 修改订单状态为已收货发货
						order.set("order_status", "4");
						order.update();
						// 修改配送信息
						deliverNote.updateStatusByOrderId("3", orderId,2);
						break;
					// 已取消
					case 5:

						// 已过期
					case 7:

						// 系统故障订单发布失败
					case 1000:
						String currentTime = DateFormatUtil.format1(new Date());
						// 修改配送信息为失败
						deliverNote.updateNoteToFailure(getJsonVal.getString("cancel_reason"), currentTime,
								orderId);
						break;
					default:
						break;
					}
				}
			} else {
				log.error("达达配送回调签名验证错误");
			}

		} catch (Exception e) {
			log.info("message = " + e.getMessage());
		}
		renderNull();
	}

	// 达达配送取消原因列表
	public void cancelReasons() {
		// 读取配置信息
		DadaProps config = new DadaProps();
		config.setAppKey(AppProps.get("appKey"));
		config.setAppSecret(AppProps.get("appSecret"));
		config.setCharset(AppProps.get("charset"));
		config.setFormat(AppProps.get("format"));
		config.setSourceId(AppProps.get("sourceId"));
		config.setVersion(AppProps.get("version"));
		config.setUrl(AppProps.get("url"));
		config.setBackUrl(AppProps.get("backUrl"));
		// 达达处理类
		DadaDeliver dadaDeliver = new DadaDeliver(config);
		DadaService dadaService = new DadaService(dadaDeliver, JSON::toJSONString);

		JSONObject resultList = null;
		try {
			resultList = JSONObject.parseObject(dadaService.cancelOrderReasons());
		} catch (IOException e) {
			log.error(e.getMessage());
		}
		renderJson(resultList);
	}

	// 达达配送取消订单
	public void cancel() {
		String orderId = getPara("orderId");
		int cancelReasonId = getParaToInt("cancelReasonId");
		DadaProps config = new DadaProps();
		config.setAppKey(AppProps.get("appKey"));
		config.setAppSecret(AppProps.get("appSecret"));
		config.setCharset(AppProps.get("charset"));
		config.setFormat(AppProps.get("format"));
		config.setSourceId(AppProps.get("sourceId"));
		config.setVersion(AppProps.get("version"));
		config.setUrl(AppProps.get("url"));
		config.setBackUrl(AppProps.get("backUrl"));
		// 达达处理类
		DadaDeliver dadaDeliver = new DadaDeliver(config);
		DadaService dadaService = new DadaService(dadaDeliver, JSON::toJSONString);
		JSONObject result = null;
		try {
			result = JSONObject.parseObject(dadaService.formalCancel(orderId, cancelReasonId, getPara("cancelReason")));
		} catch (IOException e) {
			log.error(e.getMessage());
		}
		// 取消成功
		if (result.getIntValue("code") == 0) {
			String currentTime = DateFormatUtil.format1(new Date());
			TOrder order = new TOrder().findTOrderByOrderId(orderId);
			// 修改状态为待发货
			order.set("order_status", "3");
			order.update();
			new TDeliverNote().updateNoteToFailure(getPara("cancelReason"), currentTime, order.getStr("order_id"));
		} else {
			// 失败
			log.error("达达取消订单失败："+result.toJSONString());
		}

	}

	// 达达配送依据距离和重量计算收费公式货全国配送
	public void queryDeliverFee() throws UnsupportedEncodingException {
		int amount = 0;// 数量
		double weight = 0.0d;// 重量
		int orderPrice = 0;// 订单价格
		int isSingle=StringUtil.isNull(getPara("isSingle"))?0:getParaToInt("isSingle");
		String cartInfo = isSingle==0?getCookie("cartInfo"):getCookie("productInfo");// 从cookie中取得商品信息
		cartInfo=cartInfo.replaceAll("#", ",");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int pf_Id = item.getInteger("pf_id");
				int productNum = item.getInteger("product_num");
				Record productF = new TProductF().findTProductFAndProductById(pf_Id);
				//计算总价格
				orderPrice += productF.getInt("real_price") * productNum;
				//计算总重量
				weight += productF.getDouble("base_count") * productF.getDouble("product_amount")* productNum;
				amount++;
			}
		}
		String isOrderStore=getPara("isOrderStore");
		log.info("--------"+isOrderStore);
		JSONObject result=null;
		//全国配送 配送费规则：首重10元（不大于3kg，包含3kg），每增加1kg配送费加2元，不足1kg按1kg计算费用。与配送地点无关(后期需求有变，每公斤按2元收配送费)
		if("8888".equals(isOrderStore)){
			log.info("--------quanguopeisong");
			double needPayFee = 0.0;
			/*if(weight>0&&weight<=3.0){
				needPayFee=10.0;
			}else if(weight>3.0){
				double plus=Math.ceil(weight-3.0);//超过3kg部分
				needPayFee=plus*2+10;
			}*/
			double plus=Math.ceil(weight);//超过3kg部分
			needPayFee=plus*2;
			JSONObject resultJson=new JSONObject();
			result=new JSONObject();
			resultJson.put("fee", needPayFee);
			result.put("result", resultJson);
			result.put("code", 0);
			renderJson(result);
		}else{
			log.info("--------dadapeisong");
			DadaProps config = new DadaProps();
			config.setAppKey(AppProps.get("appKey"));
			config.setAppSecret(AppProps.get("appSecret"));
			config.setCharset(AppProps.get("charset"));
			config.setFormat(AppProps.get("format"));
			config.setSourceId(AppProps.get("sourceId"));
			config.setVersion(AppProps.get("version"));
			config.setUrl(AppProps.get("url"));
			config.setBackUrl(AppProps.get("backUrl"));
			// 达达处理类
			DadaDeliver dadaDeliver = new DadaDeliver(config);
			DadaService dadaService = new DadaService(dadaDeliver, JSON::toJSONString);
			// 发送预下单到达达
			OrderParam orderParam = new OrderParam();
			orderParam.setCallback(dadaService.getDadaDeliver().getProps().getBackUrl());

			orderParam.setCargoNum(amount);
			orderParam.setCargoPrice(orderPrice);
			orderParam.setCargoWeight(weight);
			orderParam.setCityCode("0731");
			orderParam.setInfo("");
			boolean isConver=false;
			if(StringUtil.isNotNull(getPara("lat"))&&StringUtil.isNotNull(getPara("lng"))){
				orderParam.setLat(Double.valueOf(getPara("lat")));
				orderParam.setLng(Double.valueOf(getPara("lng")));
				isConver=false;
			}else{
				log.info("没有开启GPS 直接通过地址获取百度定位经纬度");
				JSONObject json = null;
				try {
					json = BaiduMapUtil.getLocation(getPara("deliveryAddress"));
				} catch (Exception e) {
					e.printStackTrace();
				}
				log.info("百度查询地址调用："+json.toJSONString());
				if (json != null) {
					JSONObject addressResultJson = json.getJSONObject("result");
					JSONObject location = addressResultJson.getJSONObject("location");
					if (location != null) {
						orderParam.setLat(Double.valueOf(location.get("lat").toString()));
						orderParam.setLng(Double.valueOf(location.get("lng").toString()));
						isConver=true;
					}
				}
			}
			// 预调用处理，不传递正式订单编号
			orderParam.setOriginId(orderNoGenerator.nextId() + "0");
			orderParam.setOriginMark("sgsl");
			orderParam.setReceiverAddress(getPara("deliveryAddress"));
			orderParam.setReceiverName(getPara("receiverName"));
			orderParam.setReceiverPhone(getPara("receiverMobile"));
			String orderStore=getPara("orderStore");
			orderParam.setShopNo(orderStore);
			TStore store=new TStore().getStoreByStoreId(orderStore);
			log.info("门店的距离和我的距离"+store.getStr("lat")+"=="+ store.getStr("lng")+"=="+orderParam.getLat()+"=="+orderParam.getLng());
			double meDistance=Double.valueOf(MapUtil.getDistance(store.getStr("lat"), store.getStr("lng"), ""+orderParam.getLat(), ""+orderParam.getLng()));
			
			log.info("-------------距离："+meDistance);
			log.info("商品总重量："+weight+"kg;----自己计算门店到收货地址距离："+meDistance+"----"+getPara("deliveryAddress")+"----"+orderStore+
					"---"+orderParam.getLat()+"---"+orderParam.getLng());
			if(meDistance>5.0){
				JSONObject resultJson = new JSONObject();
				resultJson.put("code", -1); 
				resultJson.put("msg", "超过配送5km范围");
				renderJson(resultJson);
				return;
			}
			try {
				result = JSONObject.parseObject(dadaService.queryDeliverFee(orderParam,isConver));
				log.info("达达配送费用查询调用："+result.toJSONString());
			} catch (IOException e) {
				log.error(e.getMessage());
			}
			if (result.getIntValue("code") == 0) {
				double needPayFee = 0.0;
				JSONObject resultBody = result.getJSONObject("result");
				// 配送距离
				double distance = resultBody.getDouble("distance");
				double resultFee = resultBody.getDouble("fee");
				// 配送重量
				JSONObject resultJson = new JSONObject();
				resultJson.put("code", -1);
				if (weight < 5.0) {
					DeliverArea area = DeliverArea.match(distance);
					if(area == null){
						resultJson.put("msg", "超过达达配送5km范围");
						renderJson(resultJson);
						return;
					}
					needPayFee = area.reduceFee(resultFee, new int[]{0, 0, 3, 5, 7});
				} else if(weight >= 5.0 && weight <= 25){
					DeliverArea area = DeliverArea.match(distance);
					if(area == null){
						resultJson.put("msg", "超过配送5km范围");
						renderJson(resultJson);
						return;
					}
					needPayFee = area.reduceFee(resultFee, new int[]{5, 6, 3, 5, 7});
				}else{
					resultJson.put("msg", "超过配送25kg重量范围");
					renderJson(resultJson);
					return;
				}

				//TODO result.getJSONObject("result").put("fee", 0.01);
				result.put("fee", needPayFee<0?0:needPayFee);
				//输出查询的经纬度
				result.put("lat",orderParam.getLat());
				result.put("lng",orderParam.getLng());
				renderJson(result);
				return;
			} else {
				JSONObject resultJson = new JSONObject();
				resultJson.put("code", -1);
				resultJson.put("msg", "请重试");
				renderJson(resultJson);
				return;
			}
		}
		
	}
	
	
	
	/**
	 * 蜂鸟配送回调
	 */
	public void fnCallBack(){
		 log.info("蜂鸟配送回调");
	        try {
	            InputStream result = getRequest().getInputStream();
	            BufferedReader in = new BufferedReader(new InputStreamReader(result, "UTF-8"));
	            List<String> list = IOUtils.readLines(in);
	            IOUtils.closeQuietly(result);
	            String resultStr = StringUtils.join(list, "");
	            log.info("callbackOrder-jsonData:" + resultStr);
	            log.info("传入JSON字符串：" + resultStr);
	            //处理回调结果
	            
	            //通过redis获取蜂鸟配送token
	            String fengniaoAccessToken=new RedisUtil("172.16.10.192", 6379).getToken();//new RedisUtil(AppProps.get("addr"), AppProps.getInt("port")).getToken();
	            log.info("回调的accessToken："+fengniaoAccessToken);
	            DadaDeliverController.dealCallback(resultStr,fengniaoAccessToken);
	        } catch (IOException e) {
	            e.printStackTrace();
	            log.info("message = " + e.getMessage());
	        }
	        renderNull();
	}
	
	/**
	 * 蜂鸟回调业务处理
	 * @param callbackStr
	 * @throws IOException
	 */
	private static void dealCallback(String callbackStr,String accessToken) throws IOException {
        JSONObject callbackJson = JSONObject.parseObject(callbackStr);
		String appId = callbackJson.getString("app_id");
        String data = (String) callbackJson.get("data");
        String signature = callbackJson.getString("signature");
        String salt = callbackJson.getString("salt");
        String calcSignature = OpenSignHelper.getBackSignatureStr(appId, data, salt, accessToken);
        log.info("---获取到的signature："+signature);
        log.info("---得到的calcSignature："+calcSignature);
        // 判断签名是否相等
        if (calcSignature.equals(signature)) {
            String dataBody = URLDecoder.decode(callbackJson.getString("data"), "utf-8");
            JSONObject jsonDataBody = JSONObject.parseObject(dataBody);
            // 返回的订单编码
            String orderCode = jsonDataBody.getString("partner_order_code");
            // 修改蜂鸟为最新状态
            log.info("蜂鸟回调数据： " + jsonDataBody);
            int fengniaoCallbackStatus = jsonDataBody.getIntValue("order_status");
            TDeliverNote deliverNote = new TDeliverNote();
            TOrder order = TOrder.dao.findTOrderByOrderId(orderCode);
            switch (fengniaoCallbackStatus) {
                case 1:
                    // 系统已接单
                    log.info("系统已接单");
                    if("5".equals(order.getStr("order_status"))||"6".equals(order.getStr("order_status"))
                    		||"8".equals(order.getStr("order_status"))){
                    	deliverNote.updateStatusByOrderId("4", orderCode,1);
                    	Db.update("update t_deliver_note set deliver_status=4,system_content='商家取消' where order_id=? and deliver_type=1",orderCode);
                    }else{
                    	deliverNote.updateStatusByOrderId("1", orderCode,1);
                    }
                    break;
                case 20:
                    // 已分配骑手
                    // 修改订单状态为配送中
                    log.info("已分配骑手");
                   // deliverNote.updateStatusByOrderId("1", orderCode,null);
                    Db.update("update t_deliver_note set dada_deliver_name=?,dada_deliver_phone=? where order_id=? and deliver_type=1",
                    		jsonDataBody.getString("carrier_driver_name"),jsonDataBody.getString("carrier_driver_phone"),jsonDataBody.getString("partner_order_code"));
                    break;
                case 80:
                    // 骑手已到店
                    log.info("骑手已到店");
                    break;
                case 2:
                    // 配送中
                    log.info("配送中");
                    deliverNote.updateStatusByOrderId("2", orderCode,1);
                    break;
                case 3:
                    // 已送达
                    // 修改订单状态为已收货
                    log.info("已送达");
                    deliverNote.updateStatusByOrderId("3", orderCode,1);
                    order.set("order_status", "4");//改变订单状态
					order.update();
                    break;
                case 5:
                    log.error("系统拒单");
                	String currentTime = DateFormatUtil.format1(new Date());
                	// 修改配送信息为失败
                	deliverNote.updateNoteToFailure(jsonDataBody.getString("description"), currentTime,
                			orderCode);
                	// 蜂鸟系统拒单之后发达达
                	long time = 30*60*1000;//30分钟
                	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                	Date now=new Date(new Date().getTime()+time);
                	String e=order.getStr("deliverytime");
                	String[] b=e.split(" ");
                	String date=b[0];//日期 2018-02-28
                	String[] d=b[1].split("-");
                	String time1=d[0];//时间 15:55
                	String deliverytime = date + " "+ time1+":00";
                	log.info("==============================看我");
                	//送货上门的单  当前时间加30钟大于等于开始配送时间
                	if("2".equals(order.getStr("deliverytype"))&&(sdf.format(now)).compareTo(deliverytime)>=0){
                		log.info("蜂鸟拒单发送达达");
                		JSONObject addOrderResult = new DadaUtil().send(orderCode);
                		log.info("发达达返回状态"+addOrderResult);
                		if(addOrderResult!=null&&addOrderResult.getIntValue("code") == 0){//达达接单成功
                			log.info(addOrderResult.toJSONString());
                			new TDeliverNote().saveDeliverNote(order.getStr("order_id"),order.getStr("order_store"),2,"1",null,order.getInt("delivery_fee"));
                			order.set("order_status", "12");//改变订单状态
                			order.update();
                		}
                	}else{
                		log.info("延时发送达达");
                		new TDeliverNote().saveDeliverNote(order.getStr("order_id"),order.getStr("order_store"),2,"5","延时配送",order.getInt("delivery_fee"));
                	}
                    break;
                default:
                    log.error("蜂鸟回调返回其他状态");
                    break;
            }
        } else {
            log.error("蜂鸟回调签名不正确" + callbackStr);
        }
    }
	
	
	
	
	/**
	 * 蜂鸟配送费计算
	 * 通过蜂鸟的费用计算公式计算费用        
	 * 4.3 + 距离加价 + 重量加价 + 时段加价 = 蜂鸟配送费        
	 * 配送距离 加价规则（元/单）[0-1)km 0元 [1-2)km 1元 [2-3)km 2元 [3-4]km 4元        
	 * 重量 加价规则（元/单）[0-5] kg 0, (5-15] kg 每增加1KG加0.5元        
	 * 高峰时段 2元 11:00-13:00 22:00-02:00        
	 * 1、即时单以下单时间为区间判断的时间节点；        
	 * 2、预约单以要求送到时间为区间判断的时间节点；        
	 * 3、考虑到消费场景的可行性，暂不建议接02:00-9:00的订单        
	 * 4km以内，15kg以内才配送        
	 * 退货费用：非乙方及其配送团队原因产生的退货，甲方确认退货后要求乙方即时退回的，乙方收取甲方退货费为该订单基本配送费用的50%。       
	 * 基础费用 4.3d 测试费用0.01d
	 * @throws UnsupportedEncodingException 
	 * @throws ParseException 
	 */
	public void queryFnDeliverFee() throws UnsupportedEncodingException, ParseException{
		int amount = 0;// 数量
		double weight = 0.0d;// 重量
		int orderPrice = 0;// 订单价格
		int isSingle=StringUtil.isNull(getPara("isSingle"))?0:getParaToInt("isSingle");
		String cartInfo = isSingle==0?getCookie("cartInfo"):getCookie("productInfo");// 从cookie中取得商品信息
		cartInfo=cartInfo.replaceAll("#", ",");
		if (StringUtil.isNotNull(cartInfo)) {
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int pf_Id = item.getInteger("pf_id");
				int productNum = item.getInteger("product_num");
				Record productF = new TProductF().findTProductFAndProductById(pf_Id);
				//计算总价格
				orderPrice += productF.getInt("real_price") * productNum;
				//计算总重量
				weight += productF.getDouble("base_count") * productF.getDouble("product_amount")* productNum;
				amount++;
			}
		}
		
		ElemeOpenConfig config=new ElemeOpenConfig();
		config.setAppKey(AppProps.get("fnAppKey"));
    	config.setAppSecret(AppProps.get("fnAppSecret"));
    	config.setBackUrl(AppProps.get("fnBackUrl"));
    	config.setCharset(AppProps.get("charset"));
    	config.setUrl(AppProps.get("fnUrl"));
    	config.setVersion(AppProps.get("fnVersion"));
    	//距离换算
    	boolean isConver=false; Double lat=0.0d;Double lng=0.0d;
		if(StringUtil.isNotNull(getPara("lat"))&&StringUtil.isNotNull(getPara("lng"))){
			lat=Double.valueOf(getPara("lat"));
			lng=Double.valueOf(getPara("lng"));
			isConver=false;
		}else{
			log.info("没有开启GPS 直接通过地址获取百度定位经纬度");
			JSONObject json = null;
			try {
				json = BaiduMapUtil.getLocation(getPara("deliveryAddress"));
			} catch (Exception e) {
				e.printStackTrace();
			}
			log.info("百度查询地址调用："+json.toJSONString());
			if (json != null) {
				JSONObject addressResultJson = json.getJSONObject("result");
				JSONObject location = addressResultJson.getJSONObject("location");
				if (location != null) {
					lat=Double.valueOf(location.get("lat").toString());
					lng=Double.valueOf(location.get("lng").toString());
					isConver=true;
				}
			}
		}
		
		String orderStore=getPara("orderStore");
		TStore store=new TStore().getStoreByStoreId(orderStore);
		double odistance=Double.valueOf(MapUtil.getDistance(store.getStr("lat"), store.getStr("lng"), ""+lat, ""+lng));
		log.info("门店到配送终点距离："+odistance);
    	
    	JSONObject result=new JSONObject();
    	Double fee=4.3d;//基础费用
    	//如果金额超过38元，免配送费
    	if(orderPrice>=3800){
    		fee=fee-4.3d;
    	}
    	
    	if(weight<=5){
    		log.info("重量在5kg之内！");
    	}
    	
    	if(weight>5&&weight<=15){
    		log.info("重量在5kg到15kg之内,每增加1KG加0.5元");
    		fee = fee + Math.ceil(weight - 5) * 0.5;
    	}
    	
    	if(odistance>4){
    		log.info("超过配送范围！");
    		result.put("code", -1); 
    		result.put("msg", "超过配送范围！");
    		renderJson(result);
    		return;
    	}
    	
    	if(weight>15){
    		log.info("重量超过15kg,不接受配送");
    		result.put("code", -1); 
    		result.put("msg", "重量超过15kg,不接受配送");
    		renderJson(result);
    		return;
    	}
    	
    	if(odistance<=1){
    		log.info("配送在1km之内，不加钱");
    	}
    	
    	if(odistance>1&&odistance<=2){
    		log.info("配送在1km~2km之间，加1元");
    		fee+=1;
    	}
    	
    	if(odistance>2&&odistance<=3){
    		log.info("配送在2km~3km之间，加2元");
    		fee+=2;
    	}
    	
    	if(odistance>3&&odistance<=4){
    		log.info("配送在3km~4km之间，加4元");
    		fee+=4;
    	}
    	
    	String deliverTime = getPara("deliverTime");
    	log.info("配送时间deliverTime"+deliverTime);
    	SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
    	String[] b=deliverTime.split(" ");
        String[] d=b[1].split("-");
        String time1=d[0];//时间 15:55
        Date deliverStart = sdf.parse(time1);//开始配送时间
        if(deliverStart.after(sdf.parse("11:00"))&&deliverStart.before(sdf.parse("13:00"))){
        	log.info("高峰时段加2元");
        	fee+=2;
        }
	    log.info("------最终蜂鸟配送费："+fee); 
	    result.put("code", 0);
	    result.put("fee", fee);
    	renderJson(result);
    	return;
	}
}
