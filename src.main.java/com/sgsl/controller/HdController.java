package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppProps;
import com.sgsl.model.*;
import com.sgsl.util.DadaUtil;
import com.sgsl.util.HdUtil;
import com.sgsl.util.RedisUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.util.XNode;
import com.sgsl.wechat.util.XPathParser;
import com.xgs.model.XAchievementRecord;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;

import java.io.*;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by yj 海鼎接收数据处理
 */
public class HdController extends BaseController {
	protected final static Logger logger = Logger.getLogger(HdController.class);

	/**
	 * 退货海鼎数据返回接口
	 * @throws Exception
	 */
	public void backOrder() throws Exception {
		InputStream input = this.getRequest().getInputStream();
		// 转换成utf-8格式输出
		BufferedReader in = new BufferedReader(new InputStreamReader(input, "UTF-8"));
		List<String> lst = IOUtils.readLines(in);
		IOUtils.closeQuietly(input);
		String resultStr = StringUtils.join(lst, "");
		logger.info("backOrder-jsonData:" + resultStr);
		JSONObject getJsonVal = JSONObject.parseObject(resultStr);
		JSONObject content = JSONObject.parseObject(getJsonVal.getString("content"));
		String orderId = content.getString("front_order_id");
		String currentDate = DateFormatUtil.format1(new Date());
		// 所有订单推送类消息
		if ("order".equals(getJsonVal.getString("group"))) {
			TOrder oper = new TOrder();
			// 订单备货
			if ("order.shipped".equals(getJsonVal.getString("topic"))) {
				TOrder orderResult = oper.findTOrderByOrderId(orderId);
				// 门店自提订单 送货上门由达达配送回调修改状态
				if (orderResult != null && !"4".equals(orderResult.getStr("order_status"))
						&& "1".equals(orderResult.getStr("deliverytype"))) {
					//如果是兑换订单需要给兑换商品记录加上取货时间
					if(orderResult.getInt("order_style")==2){
						TExchangeOrderLog exchangeOrderLog = TExchangeOrderLog.dao.findFirst("select * from t_exchange_order_log where order_id=? ", orderId);
						String now = DateFormatUtil.format1(new Date());
						exchangeOrderLog.set("recieve_time", now);
						exchangeOrderLog.update();
					}
					// 确认收货
					orderResult.set("order_status", "4");
					orderResult.update();
				} else if (orderResult != null && !"4".equals(orderResult.getStr("order_status"))
						&& "2".equals(orderResult.getStr("deliverytype"))) {
					// 送货上门-发送蜂鸟订单
					//通过redis获取蜂鸟配送token 因为app端会刷新token
					logger.info("addr:"+AppProps.get("addr")+"port:"+AppProps.getInt("port"));
					String  fengniaoAccessToken=new RedisUtil(AppProps.get("addr"), AppProps.getInt("port")).getToken();//new RedisUtil(AppProps.get("addr"), AppProps.getInt("port")).getToken();
					logger.info("accessToken的值："+fengniaoAccessToken);
					JSONObject addOrderResult = new DadaUtil().sendFn(orderId,fengniaoAccessToken,null);
					logger.info(addOrderResult.toJSONString());
					if (addOrderResult != null && addOrderResult.getIntValue("code") == 200) {
						new TDeliverNote().findByOrderId(orderId).set("deliver_status", "0").update();//待配送
						// 修改订单状态为12.配送中
						orderResult.set("order_status", "12");
						orderResult.update();
					}else if(addOrderResult.getIntValue("code") == 50012){//处理订单预计送达时间小于当前时间问题
						 new DadaUtil().sendFn(orderId,fengniaoAccessToken,currentDate);
					}else{
						//将超过距离的配送记录到配送表中，用于手工处理
						new TDeliverNote().findByOrderId(orderId).set("deliver_status", "6")
						.set("failure_cause", addOrderResult.get("msg")).update();
						// 蜂鸟系统拒单之后发达达
	                	long time = 30*60*1000;//30分钟
	                	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	                	Date now=new Date(new Date().getTime()+time);
	                	String e=orderResult.getStr("deliverytime");
	                	String[] b=e.split(" ");
	                	String date=b[0];//日期 2018-02-28
	                	String[] d=b[1].split("-");
	                	String time1=d[0];//时间 15:55
	                	String deliverytime = date + " "+ time1+":00";
	                	//送货上门的单  当前时间加30钟大于等于开始配送时间
	                	if("2".equals(orderResult.getStr("deliverytype"))&&(sdf.format(now)).compareTo(deliverytime)>=0){
	                		logger.info("蜂鸟拒单发送达达");
	                		JSONObject addOrderResult1 = new DadaUtil().send(orderId);
	                		logger.info("发达达返回状态"+addOrderResult1);
	                		if(addOrderResult1!=null&&addOrderResult1.getIntValue("code") == 0){//达达接单成功
	                			logger.info(addOrderResult1.toJSONString());
	                			new TDeliverNote().saveDeliverNote(orderResult.getStr("order_id"),orderResult.getStr("order_store"),2,"1",null,orderResult.getInt("delivery_fee"));
	                			orderResult.set("order_status", "12");//改变订单状态
	                			orderResult.update();
	                		}
	                	}else{
	                		logger.info("延时发送达达");
	                		new TDeliverNote().saveDeliverNote(orderResult.getStr("order_id"),orderResult.getStr("order_store"),2,"5","延时配送",orderResult.getInt("delivery_fee"));
	                	}
	  	    	    }
				}
				// 订单取消
			} else if ("order.canceled".equals(getJsonVal.getString("topic"))) {
				// 订单签收(确认收货)
			} else if ("order.signed".equals(getJsonVal.getString("topic"))) {

				TOrder orderResult = oper.findTOrderByOrderId(orderId);
				if (orderResult != null && !"4".equals(orderResult.getStr("order_status"))) {
					// 确认收货
					orderResult.set("order_status", "4");
					orderResult.update();
				}
				// 订单拒收
			} else if ("order.refused".equals(getJsonVal.getString("topic"))) {
				// 退货单收货(客户退货)
			} else if ("return.received".equals(getJsonVal.getString("topic"))) {
				TOrder orderResult = oper.findTOrderByOrderId(orderId);
				// 海鼎退货完成
				if (orderResult != null && "8".equals(orderResult.getStr("order_status"))) {
					StringBuffer sql = new StringBuffer();
					sql.append(
							"select t.order_type,t.order_user,t.order_store,t.order_id,t.need_pay,t.delivery_fee,t.deliverytype,p.out_trade_no,p.source_type,p.source_table,p.total_fee from t_order t ");
					sql.append(" left join t_pay_log p ");
					sql.append(" on t.order_id=p.out_trade_no ");
					sql.append(" where t.order_id=? or t.old_order_id=? ");
					Record pay = Db.findFirst(sql.toString(), orderId, orderId);
					// 查找需要退货的商品
					Record orderPartProducts = Db.findFirst(
							"select count(*) as c  from t_order_products op left join t_order "
									+ "t on op.order_id=t.id  "
									+ " where (t.order_id=?  or t.old_order_id=?) and op.is_back='N'",
							orderId, orderId);
					// 默认全部退金额
					long needPay = pay.getInt("need_pay");
					// 部分退货标志
					boolean isPartBack = false;
					if (!orderPartProducts.getLong("c").equals(new Long(0))) {
						// 赠送和购买计算部分退货退款金额方式不一致
						isPartBack = true;
						needPay = 0L;
						List<Record> order_products = Db.find(
								"select op.*  from t_order_products op left join t_order "
										+ "t on op.order_id=t.id  where (t.order_id=? or t.old_order_id=?) and op.is_back='Y'",
								orderId, orderId);
						for (Record item : order_products) {
							// 仓库提货
							if ("2".equals(orderResult.getStr("order_type"))) {
								needPay += item.getLong("unit_price");
							} else {
								// 直接购买 获取实际支付金额
								needPay += item.getInt("pay_price");
							}
						}
		    		}
		    		if(isPartBack){
		    			//修改订单为已退款
		    			orderResult.updateStatus(orderResult.getInt("id"), orderResult.getInt("order_user"),"8", "6");
		    			//加果币
		    			Db.update("update t_user set balance=balance+? where id=?",
		    					needPay,
		    					pay.getInt("order_user"));
		    			//增加加果币记录
		    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
		    			tBlanceRecord.set("store_id", pay.getStr("order_store"));
		    			tBlanceRecord.set("user_id", orderResult.getInt("order_user"));
		    			tBlanceRecord.set("blance", needPay);
		    			tBlanceRecord.set("ref_type", "orderBack");
		    			tBlanceRecord.set("create_time",currentDate);
		    			tBlanceRecord.set("order_id", orderId);
		    			tBlanceRecord.save();
		    			logger.info("赠送提货订单或者余额支付订单，直接转成用户余额:"+orderId+"-blance:"+needPay);
		    		}else{
		    			//送货上门需要扣除配送费 1.门店自提  2.送货上门
		    			long totalFee=pay.getInt("total_fee");
		    			long partPayBack=totalFee;
		    			if("2".equals(pay.getStr("deliverytype"))){
		    				partPayBack=needPay;
		    			}
			    		//赠送提货订单或者余额支付订单，直接转成用户余额 并且如果是部分退货也只退鲜果币
			    		if("2".equals(pay.getStr("order_type"))||("t_user".equals(pay.getStr("source_table"))&&"balance".equals(pay.getStr("source_type"))&&
			    					StringUtil.isNotNull(pay.getStr("out_trade_no"))&&pay.getStr("out_trade_no").length()==18)){

			    			//修改订单为已退款
			    			orderResult.updateStatus(orderResult.getInt("id"), orderResult.getInt("order_user"),"8", "6");
			    			// 是别人的客户，此时就需要添加一条支出明细记录
							Record orderRecord = Db.findFirst("select * from t_order where id = ?",
									orderResult.getInt("id"));
							if (StringUtil.isNotNull(String.valueOf(orderRecord.getInt("master_id")))) {
								XAchievementRecord.dao.addXAchievementRecord(orderRecord, 4);
								logger.info("退货订单：" + orderResult.getInt("id") + "======归属的鲜果师id："
										+ String.valueOf(orderRecord.getInt("master_id")));
							}
			    			//加果币
			    			Db.update("update t_user set balance=balance+? where id=?",
			    					partPayBack,
			    					pay.getInt("order_user"));
			    			//增加加果币记录
			    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
			    			tBlanceRecord.set("store_id", pay.getStr("order_store"));
			    			tBlanceRecord.set("user_id", orderResult.getInt("order_user"));
			    			tBlanceRecord.set("blance", partPayBack);
			    			tBlanceRecord.set("ref_type", "orderBack");
			    			tBlanceRecord.set("create_time", currentDate);
			    			tBlanceRecord.set("order_id", orderId);
			    			tBlanceRecord.save();
			    			logger.info("赠送提货订单或者余额支付订单，直接转成用户余额:"+orderId+"-blance:"+needPay);
			    		}else{
			    			//直接支付订单 调货订单取原始订单编号
			    			String payOrderId=StringUtil.isNotNull(orderResult.getStr("old_order_id"))?orderResult.getStr("old_order_id"):orderResult.getStr("order_id");

			    			String weixinResult=WeChatUtil.refund(payOrderId,payOrderId,
			    					(int)totalFee,(int)needPay,
			    					new File(getRequest().getSession().getServletContext().getRealPath("/WEB-INF/classes/apiclient_cert.p12")));
			    			logger.info("直接支付订单result:"+weixinResult);
			    			if(weixinResult.indexOf("SUCCESS")!=-1){
			    				logger.info("直接支付订单已经申请微信退款");
			    				orderResult.updateStatus(orderResult.getInt("id"), orderResult.getInt("order_user"),"8", "6");
			    				//添加退款记录
			    				XPathParser xpath=new XPathParser(weixinResult);
			    				XNode refund_fee = xpath.evalNode("//refund_fee");
			    				XNode transaction_id = xpath.evalNode("//transaction_id");
			    				TRefundLog refundLog = new TRefundLog();
			    				refundLog.set("user_id", orderResult.getInt("order_user"));
			    				refundLog.set("refund_fee", refund_fee.body());
			    				refundLog.set("transaction_no", transaction_id.body());
			    				refundLog.set("refund_time", DateFormatUtil.format1(new Date()));
			    				refundLog.set("order_id",orderResult.getStr("order_id") );
			    				refundLog.save();
			    			}else{
			    				orderResult.updateStatus(orderResult.getInt("id"), orderResult.getInt("order_user"),"8", "10");
			    				logger.info("直接支付订单申请微信退款失败");
			    			}
			    		}
		    		}
				}
			} else if ("store.order.operation".equals(getJsonVal.getString("topic"))) {
				// 门店配送作业
				// shipping：门店集货
				// cancalShipping：门店取消集货
				orderId = content.getString("order_id");
				String operation = content.getString("operation");

				TOrder orderResult = oper.findTOrderByOrderId(orderId);
				if ("shipping".equals(operation) && orderResult != null
						&& !"4".equals(orderResult.getStr("order_status"))) {
					// 确认收货
					orderResult.set("order_status", "4");
					orderResult.update();
					logger.info("门店集货:" + orderId);
				} else if ("cancalShipping".equals(operation) && orderResult != null
						&& "4".equals(orderResult.getStr("order_status"))) {
					// 待收货 可取消订单
					orderResult.set("order_status", "3");
					orderResult.update();
					logger.info("门店取消集货:" + orderId);
				}
			}
		}
		// 返回结果
		JSONObject resultJson = new JSONObject();
		resultJson.put("success", true);
		renderJson(resultJson);
	}

	/**
	 * 查询购物车中库存不足的商品
	 * @throws UnsupportedEncodingException
	 */
	public void queryCartProductsInv() throws UnsupportedEncodingException{
		JSONObject resultJson = new JSONObject();
		// 直接单独购买1或者购物车购买0
		int isSingle = StringUtil.isNull(getPara("isSingle")) ? 0 : getParaToInt("isSingle");
		String cartInfo = isSingle == 0 ? getCookie("cartInfo") : getCookie("productInfo");// 从cookie中取得商品信息
		resultJson.put("isSingle", isSingle);
		//库存不足的商品
		List<Record> unEnoughInvProducts = new ArrayList<Record>();
		if (StringUtil.isNotNull(cartInfo)) {
			cartInfo = cartInfo.replaceAll("#", ",");
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			String product_f_ids = "(";
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				product_f_ids = product_f_ids + item.getInteger("pf_id")+",";
			}
			product_f_ids = product_f_ids.substring(0, product_f_ids.length()-1)+")";
			List<Record> productList = Db.find("select pf.product_amount,p.id,p.product_name,p.base_barcode,p.base_count"
					+ ",p.safe_qty from t_product_f pf left join t_product p on pf.product_id = p.id "
					+ "where pf.id in "+product_f_ids);
			String[] product_barCodes = new String[cartInfoJson.size()];//商品base_barcode
			int j=0;
			for (Record barcodeRecord : productList) {
				product_barCodes[j]=barcodeRecord.get("base_barcode");
				j++;
				double query_total=0.0;
				//需要购买的总出库量
				for (int i = 0; i < cartInfoJson.size(); i++) {
					JSONObject item = cartInfoJson.getJSONObject(i);
					if(item.getIntValue("product_id")==barcodeRecord.getInt("id")){
						query_total += barcodeRecord.getDouble("product_amount")*item.getInteger("product_num");
					}
				}
				//该种商品购买的总量
				barcodeRecord.set("query_total", query_total);
			}

			try {
				//查询需要购买的商品的库存
				JSONObject hDQueryResult = HdUtil.querySku(getCookie("store_id")==null?"07310109":getCookie("store_id"), product_barCodes);

				if(hDQueryResult.getIntValue("echoCode")==0 && hDQueryResult.getJSONArray("businvs")!=null && hDQueryResult.getJSONArray("businvs").size()>0){
					resultJson.put("status",true);
					resultJson.put("msg", "查询成功");
					JSONArray productArr = hDQueryResult.getJSONArray("businvs");
					TFailureLog failureLog = new TFailureLog();
					//根据海鼎查询到的商品信息，判定库存是否足够
					for (Record productRecord : productList) {
						String sku_id = productRecord.getStr("base_barcode");
						for (Object object : productArr) {
							JSONObject jsonObject = (JSONObject)object;
							if(sku_id.equals(jsonObject.getString("barCode"))){
								if(jsonObject.getDoubleValue("qty")<productRecord.getDouble("query_total")+productRecord.getDouble("safe_qty")){
									//小于安全库存的商品
									unEnoughInvProducts.add(productRecord);
									TUser tUserSession = UserStoreUtil.get(getRequest());
									failureLog.set("product_id", productRecord.get("id"));
									failureLog.set("create_time", DateFormatUtil.format1(new Date()));
									failureLog.set("store_id", getCookie("store_id"));
									failureLog.set("user_id", tUserSession.getInt("id"));
									failureLog.set("failure_type", 0);
									failureLog.save();
								}
							}
						}
					}
				}else{
					resultJson.put("status",false);
					resultJson.put("msg", "查询失败");
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				resultJson.put("status",false);
				resultJson.put("msg", "查询失败");
				e.printStackTrace();
				renderJson(resultJson);
			}
			//所有商品库存都不足
			if(product_barCodes.length==unEnoughInvProducts.size()){
				resultJson.put("clearAllPro", true);
			}else{
				resultJson.put("clearAllPro", false);
			}
		} else {
			resultJson.put("status",false);
			resultJson.put("msg", "购物车中没有商品");
		}
		resultJson.put("unEnoughInvProducts",unEnoughInvProducts);
		renderJson(resultJson);
	}

	/**
	 * 查询订单中库存不足的商品
	 * @param
	 * @throws UnsupportedEncodingException
	 */
	public void queryOrderProductsInv() throws UnsupportedEncodingException{
		JSONObject resultJson = new JSONObject();
		List<Record> orderProducts = Db.find("select op.product_id,op.amount,op.product_f_id,p.base_barcode,"
					+ " p.safe_qty,pf.product_amount from t_order_products op "
					+ " LEFT JOIN t_product_f pf on OP.product_f_id=pf.id "
					+ " LEFT JOIN t_product p on OP.product_id=p.id "
					+ " where op.order_id = (select id from t_order o where o.order_id=?)",getPara("order_id"));
		//库存不足的商品
		List<Record> unEnoughInvProducts = new ArrayList<Record>();
		if (orderProducts!=null) {
			String[] product_barCodes = new String[orderProducts.size()];//商品base_barcode
			int j=0;
			for (Record barcodeRecord : orderProducts) {
				product_barCodes[j]=barcodeRecord.get("base_barcode");
				j++;
				double query_total=0.0;
				//需要购买的总出库量
				for (Record barcodeRecord1 : orderProducts) {
					if(barcodeRecord.getInt("product_id")==barcodeRecord1.getInt("product_id")){
						query_total += barcodeRecord.getDouble("product_amount")*barcodeRecord.getDouble("amount");
					}
				}
				//该种商品购买的总量
				barcodeRecord.set("query_total", query_total);
			}
			Record store = Db.findFirst("select order_store from t_order where order_id =?",getPara("order_id"));
			try {
				//查询需要购买的商品的库存
				JSONObject hDQueryResult = HdUtil.querySku(store.getStr("order_store"), product_barCodes);

				if(hDQueryResult.getIntValue("echoCode")==0 && hDQueryResult.getJSONArray("businvs")!=null && hDQueryResult.getJSONArray("businvs").size()>0){
					JSONArray productArr = hDQueryResult.getJSONArray("businvs");
					//根据海鼎查询到的商品信息，判定库存是否足够
					for (Record productRecord : orderProducts) {
						String sku_id = productRecord.getStr("base_barcode");
						for (Object object : productArr) {
							JSONObject jsonObject = (JSONObject)object;
							if(sku_id.equals(jsonObject.getString("barCode"))){
								if(jsonObject.getDoubleValue("qty")<productRecord.getDouble("query_total")+productRecord.getDouble("safe_qty")){
									//小于安全库存的商品
									unEnoughInvProducts.add(productRecord);
								}
							}
						}
					}
				}else{
					resultJson.put("status",false);
					resultJson.put("msg", "查询失败");
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				resultJson.put("status",false);
				resultJson.put("msg", "查询失败");
				e.printStackTrace();
				renderJson(resultJson);
			}
		} else {
			resultJson.put("status",false);
			resultJson.put("msg", "购物车中没有商品");
		}
		resultJson.put("unEnoughInvProducts",unEnoughInvProducts);
		List<Record> productList = Db.find("select product_id from t_order_products op where op.order_id = (select id from t_order o where o.order_id=?) group by product_id ",getPara("order_id"));
		//所有商品库存都不足
		if(unEnoughInvProducts.size()==productList.size()){
			resultJson.put("clearAllProducts", true);
		}else{
			resultJson.put("clearAllProducts", false);
		}
		renderJson(resultJson);
	}

	/**
	 * 提货订单查询库存
	 * @throws UnsupportedEncodingException
	 */
	public void queryTXProductsInv() throws UnsupportedEncodingException{
		JSONObject resultJson = new JSONObject();
		String cartInfo =  getCookie("basketInfo");// 从cookie中取得商品信息
		//库存不足的商品
		List<Record> unEnoughInvProducts = new ArrayList<Record>();
		if (StringUtil.isNotNull(cartInfo)) {
			cartInfo = cartInfo.replaceAll("#", ",");
			JSONArray cartInfoJson = JSONArray.parseArray(URLDecoder.decode(cartInfo, "UTF-8"));
			String product_f_ids = "(";
			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				product_f_ids = product_f_ids + item.getInteger("product_id")+",";
			}
			product_f_ids = product_f_ids.substring(0, product_f_ids.length()-1)+")";
			List<Record> productList = Db.find("select p.id,p.product_name,p.base_barcode,p.base_count,p.safe_qty from t_product p where p.id in "+product_f_ids);
			String[] product_barCodes = new String[cartInfoJson.size()];//商品base_barcode
			int j=0;
			for (Record barcodeRecord : productList) {
				product_barCodes[j]=barcodeRecord.get("base_barcode");
				j++;
				double query_total=0.0;
				//需要购买的总出库量
				for (int i = 0; i < cartInfoJson.size(); i++) {
					JSONObject item = cartInfoJson.getJSONObject(i);
					if(item.getIntValue("product_id")==barcodeRecord.getInt("id")){
						query_total += item.getDouble("amount");
					}
				}
				//该种商品购买的总量
				barcodeRecord.set("query_total", query_total);
			}

			try {
				//查询需要购买的商品的库存
				JSONObject hDQueryResult = HdUtil.querySku(getCookie("store_id")==null?"07310109":getCookie("store_id"), product_barCodes);

				if(hDQueryResult.getIntValue("echoCode")==0 && hDQueryResult.getJSONArray("businvs")!=null && hDQueryResult.getJSONArray("businvs").size()>0){
					resultJson.put("status",true);
					resultJson.put("msg", "查询成功");
					JSONArray productArr = hDQueryResult.getJSONArray("businvs");
					TFailureLog failureLog = new TFailureLog();
					//根据海鼎查询到的商品信息，判定库存是否足够
					for (Record productRecord : productList) {
						String sku_id = productRecord.getStr("base_barcode");
						for (Object object : productArr) {
							JSONObject jsonObject = (JSONObject)object;
							if(sku_id.equals(jsonObject.getString("barCode"))){
								if(jsonObject.getDoubleValue("qty")<productRecord.getDouble("query_total")+productRecord.getDouble("safe_qty")){
									//小于安全库存的商品
									unEnoughInvProducts.add(productRecord);
									//记录库存不足下单失败的日志
									TUser tUserSession = UserStoreUtil.get(getRequest());
									failureLog.set("product_id", productRecord.get("id"));
									failureLog.set("create_time", DateFormatUtil.format1(new Date()));
									failureLog.set("store_id", getCookie("store_id"));
									failureLog.set("user_id", tUserSession.getInt("id"));
									failureLog.set("failure_type", 0);
									failureLog.save();
								}
							}
						}
					}
				}else{
					resultJson.put("status",false);
					resultJson.put("msg", "查询失败");
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				resultJson.put("status",false);
				resultJson.put("msg", "查询失败");
				e.printStackTrace();
				renderJson(resultJson);
			}
			//所有商品库存都不足
			if(product_barCodes.length==unEnoughInvProducts.size()){
				resultJson.put("clearAllPro", true);
			}else{
				resultJson.put("clearAllPro", false);
			}
		} else {
			resultJson.put("status",false);
			resultJson.put("msg", "购物车中没有商品");
		}
		resultJson.put("unEnoughInvProducts",unEnoughInvProducts);
		renderJson(resultJson);
	}
}
