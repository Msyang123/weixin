package com.sgsl.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.Authenticator;
import java.net.HttpURLConnection;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Date;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.core.JFinal;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.controller.PaymentController;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TOrder;
import com.sgsl.model.TStore;
import com.sgsl.model.TUser;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.TwitterIdWorker;


public class HdUtil {
	private static String code(String user,String password){  
			  String tok = user + ':' + password;  
			  String hash = Base64.encodeBase64String(tok.getBytes());  
			  return "Basic " + hash;  
	}
	private final static boolean devMode=JFinal.me().getConstants().getDevMode();
	//此处注意，不能用main方法测试接口，因为此处调用main中 devMode=false
	private final static String apiUser=devMode?"test01":"lvhang",
			        apiPass=devMode?"AePq88kJbleNGUDT":"J6SxSkMfH7gbikwLxKo0X2a9",
					operator=devMode?"user":"sgsl",
					apiUrl=devMode?"http://api.sandbox.u.hd123.com/":"http://api.u.hd123.com/",
					shopId=devMode?"10001":"6666",platformName="水果熟了",
					platformId=devMode?"weidianhui":"weidianhui",
					tenantId=devMode?"test01":"cnm3q7mj",
					hdcard=devMode?"http://172.16.10.108:8180/hdcard-services/api":"http://172.16.10.107:8180/hdcard-services/api",//"http://172.16.10.108:8180/hdcard-services/api":"http://172.16.10.107:8180/hdcard-services/api";
					h4rest=devMode?"http://222.240.36.154:7280/h4rest-server/rest/h5rest-server/core/":"http://222.240.36.154:7280/h4rest-server/rest/h5rest-server/core/";
					//h4rest=devMode?"http://172.16.10.109:7280/h4rest-server/rest/h5rest-server/core/":"http://218.77.55.54:7280/h4rest-server/rest/h5rest-server/core/";
	//operator我们这边自定义参数
	/*private final static String apiUser="lvhang",apiPass="J6SxSkMfH7gbikwLxKo0X2a9",operator="sgsl",
			apiUrl="http://api.u.hd123.com/",shopId="6666",platformName="水果熟了",
					platformId="weidianhui",tenantId="cnm3q7mj";*/
	private static final Charset charset = Charset.forName("UTF-8");
	protected final static Logger logger = Logger.getLogger(PaymentController.class);
	/**
	 * 店铺商品减库存接口
	 * @param orderId 订单编号
	 * @param storeId 店铺id
	 * @return
	 */
	public static boolean orderReduce(String orderId){
		try {
			TOrder tOrder=new TOrder().findFirst("select * from t_order where order_id=? and hd_status in ('1','')  ",orderId);
			if(tOrder==null){
				return false;
			}
			TStore tStore=new TStore().findFirst("select * from t_store where store_id=?",tOrder.getStr("order_store"));
			TUser tUser= new TUser().findById(tOrder.getInt("order_user"));
			
			JSONObject order=new JSONObject();
			order.put("id", orderId);
			JSONObject shop=new JSONObject();
			
			shop.put("id",shopId);
			shop.put("name", tStore.getStr("store_name"));
			order.put("shop", shop);
			order.put("state", "confirmed");
			JSONObject customer=new JSONObject();
			customer.put("id", tOrder.getInt("order_user"));
			JSONObject contact=new JSONObject();
			contact.put("name", tUser.getStr("nickname"));
			contact.put("mobile", tUser.getStr("phone_num"));
			customer.put("contact", contact);
			order.put("customer", customer);
			
			JSONObject invoice=new JSONObject();
			invoice.put("required", false);
			order.put("invoice", invoice);
			
			JSONObject payment=new JSONObject();
			payment.put("type", "online");
			payment.put("state","paid");
			payment.put("freight", 0);
			payment.put("amount", tOrder.getInt("need_pay")/100.0);
			payment.put("pay_time", tOrder.getStr("pay_time"));
			payment.put("cod_amount", 0);
			payment.put("earnest_amount", 0);
			order.put("payment", payment);
			
			JSONObject delivery=new JSONObject();
			//默认取值:deliver。取值范围:selftake(到店自提)、deliver(送货上门)
			String type=null;
			String customerNote=tOrder.getStr("customer_note");
			if(customerNote!=null){
				customerNote=customerNote.trim();
			}
			if("1".equals(tOrder.getStr("deliverytype"))){
				type="selftake";
			}else{
				type="deliver";
				customerNote+="配送时间："+tOrder.getStr("deliverytime");
			}
			delivery.put("type", type);
			order.put("customer_note", customerNote);//customer_note 客户备注
			
			JSONObject station=new JSONObject();
			station.put("id", tStore.getStr("store_id"));
			station.put("name", tStore.getStr("store_name"));
			delivery.put("station", station);
			delivery.put("state","none");
			//收货地址可能为空 为自提
			if("2".equals(tOrder.getStr("deliverytype"))||"3".equals(tOrder.getStr("deliverytype"))){
				JSONObject receiver=new JSONObject();
			
				JSONObject receiver_contact=new JSONObject();
				receiver_contact.put("name", tOrder.getStr("receiver_name"));
				receiver_contact.put("mobile", tOrder.getStr("receiver_mobile"));
				receiver.put("contact", receiver_contact);
				JSONObject address=new JSONObject();
				//湖南省 长沙市 开福区 凯乐国际城 华声在线三楼
				address.put("province","湖南省");
				address.put("city", "长沙市");
				address.put("district", "");
				address.put("street", tOrder.getStr("address_detail"));
				receiver.put("address", address);
			delivery.put("receiver", receiver);
			}else{
				//提货用户也需要显示用户信息
				JSONObject receiver=new JSONObject();
				
				JSONObject receiver_contact=new JSONObject();
				receiver_contact.put("name", tUser.getStr("nickname"));
				receiver_contact.put("mobile", tUser.getStr("phone_num"));
				receiver.put("contact", receiver_contact);
				delivery.put("receiver", receiver);
			}
			//配送时间需要调整下
			String deliverytime=tOrder.getStr("deliverytime");
			if(StringUtil.isNotNull(deliverytime)){
				delivery.put("pre_start_delivery_time", deliverytime.substring(0,deliverytime.lastIndexOf("-"))+":00");
				delivery.put("pre_end_delivery_time",deliverytime.substring(0,deliverytime.indexOf(" "))+" "+deliverytime.substring(deliverytime.lastIndexOf("-")+1)+":00");
			}
			order.put("delivery", delivery);
			
			JSONObject front=new JSONObject();
				JSONObject platform=new JSONObject();
				platform.put("id", platformId);
				platform.put("name", platformName);
			front.put("platform", platform);
			front.put("order_id", orderId);	
			front.put("created", tOrder.getStr("pay_time"));
			order.put("front", front);
			JSONArray items=new JSONArray();
			List<Record> order_products=Db.find("select op.*,tp.product_name,tpf.sku_id,tpf.product_code,tpf.bar_code,ifnull(tpf.special_price,tpf.price) as price,tpf.product_amount  from t_order_products op left join t_order "+
					"t on op.order_id=t.id left join t_product_f tpf on op.product_f_id=tpf.id "+
					"left join t_product tp on tp.id=tpf.product_id where t.order_id=?",orderId);
			
			Integer discount=tOrder.getInt("discount");//订单优惠价格
			int total=(tOrder.getInt("total")==null)?tOrder.getInt("need_pay"):tOrder.getInt("total");//订单总价 赠送订单不会存储总价
			
			//==========单品优惠券调整部分============/
			// 查看是否是用的单品优惠券
			double apported_discount_amount=0;
			boolean is_singleCoupon = false;
			if (tOrder.get("order_coupon")!=null) {
				is_singleCoupon = TCouponReal.dao.isSingleCoupon(tOrder.getInt("order_coupon"));
			}
			int singlePFId = 0;//单品优惠券商品规格id
			int singleVal = 0;//单品优惠券价值
			if (is_singleCoupon) {
				// 此处使用了单品优惠券，单品优惠券单独分摊到单独的商品上
				Record productCouponRecord = Db.findFirst(
						"select pc.*,cs.* from t_product_coupon pc left join t_coupon_scale cs on pc.coupon_scale_id = cs.id where pc.coupon_scale_id in (SELECT coupon_scale_id from t_coupon_real cr where cr.id=?)",
						tOrder.getInt("order_coupon"));
				singlePFId = productCouponRecord.getInt("product_f_id");
				singleVal = productCouponRecord.getInt("coupon_val");
				/*//只使用了单品优惠券
				if(tOrder.getInt("discount") == singleVal){
					discount = (tOrder.getInt("discount") == null) ? 0 : tOrder.getInt("discount");// 订单优惠价格
				}else{}*/
				//还有其他优惠,其他优惠需要均摊，减去单品优惠券的，单品优惠券不做均摊
				discount = (tOrder.getInt("discount") == null) ? 0 : tOrder.getInt("discount")-productCouponRecord.getInt("coupon_val");// 订单优惠价格
				
				if(discount!=null&&discount>0){
					apported_discount_amount=discount;
				}
			}else{//没有使用单品优惠券，折扣是所有商品均摊
				discount = (tOrder.getInt("discount") == null) ? 0 : tOrder.getInt("discount");// 订单优惠价格
				if(discount!=null&&discount>0){
					apported_discount_amount=discount;
				}
			}
			
			//==========单品优惠券调整部分============/
			//单位折扣率
			double unitDiscount=apported_discount_amount/total;
			double need_pay=0.00;
			double pay_amount=0.0d;
			double pay_price=0d;
			//仓库提货(仓库商品价格为0)
			if("2".equals(tOrder.getStr("order_type"))){
				//整单优惠分摊金额
				/*real_total	BigDecimal	必须	120.01	实际销售金额(扣除所有优惠)，等于items中pay_amount之和
				item中
				discount_amount	BigDecimal	必须	12.02	商品优惠金额
				apported_discount_amount	BigDecimal	必须	12.02	整单优惠分摊金额
				unit_price	BigDecimal	必须	122.34	商品销售价格（扣除优惠券前的价格）
				quantity	BigDecimal	必须	122	数量
				total	BigDecimal	必须	122	商品金额，等于unit_price  *   quantity
				pay_amount	BigDecimal	必须	122	实付金额，等于total  - apported_discount_amount  -  discount_amount
				*/
				
				order_products=Db.find("select op.*,tp.product_code,tp.product_name,tp.base_barcode as bar_code, "+
					" tp.sku_id,0 as price "+
					" from t_order_products op "+
					" left join t_order t on op.order_id=t.id "+
					" left join t_product tp on tp.id=op.product_id "+
					" where t.order_id=?",orderId);
				for(Record item:order_products){
					JSONObject order_products_json=new JSONObject();
					order_products_json.put("sku_id", item.getStr("product_code").trim());
					order_products_json.put("quantity", item.getDouble("amount"));
					order_products_json.put("unit_price", item.getLong("unit_price")/(100.0*item.getDouble("amount")));
					order_products_json.put("total", item.getLong("unit_price")/100.0);
					if(is_singleCoupon&&item.getInt("product_f_id")==singlePFId){
						//每个单品独立优惠
						order_products_json.put("discount_amount",singleVal);
						//每个单品分摊的优惠
						order_products_json.put("apported_discount_amount", 
								new BigDecimal(unitDiscount*item.getLong("unit_price")+singleVal/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue());
						//减去优惠后的实付金额
						pay_amount=new BigDecimal((item.getLong("unit_price")-unitDiscount*item.getLong("unit_price")-singleVal)/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
						if(pay_amount<0){
							pay_price=0d;
						}else{
							pay_price=pay_amount;
						}
						order_products_json.put("pay_amount",pay_price);
						need_pay+=new BigDecimal((item.getLong("unit_price")-unitDiscount*item.getLong("unit_price"))/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue()-singleVal/100.0;
					}else{
						order_products_json.put("discount_amount",0);
						//每个单品分摊的优惠
						order_products_json.put("apported_discount_amount", 
								new BigDecimal(unitDiscount*item.getLong("unit_price")/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue());
						//减去优惠后的实付金额
						pay_amount= new BigDecimal((item.getDouble("amount")*item.getInt("price")-unitDiscount*item.getDouble("amount")*item.getInt("price"))/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
						pay_price=0d;
						if(pay_amount<0){
							pay_price=0d;
						}else{
							pay_price=pay_amount;
						}
						order_products_json.put("pay_amount", pay_price);
						need_pay+= pay_amount;
					}
					order_products_json.put("item_title", item.getStr("product_name"));
					order_products_json.put("barcode", item.getStr("bar_code"));
					items.add(order_products_json);
				}
				order.put("items", items);
				order.put("real_total", need_pay);
			}else{
				//整单优惠分摊金额
				//double apported_discount_amount=tOrder.getInt("discount")/(100.0*order_products.size());
				for(Record item:order_products){
					JSONObject order_products_json=new JSONObject();
					order_products_json.put("sku_id", item.getStr("product_code").trim());
					order_products_json.put("quantity", item.getDouble("amount")*item.getDouble("product_amount"));
					order_products_json.put("unit_price", item.getInt("price")/(100.0*item.getDouble("product_amount")));
					order_products_json.put("total", item.getDouble("amount")*item.getInt("price")/100.0);
					if(is_singleCoupon&&item.getInt("product_f_id")==singlePFId){
						//每个单品独立优惠
						order_products_json.put("discount_amount",singleVal);
						//每个单品分摊的优惠
						order_products_json.put("apported_discount_amount", 
								new BigDecimal(unitDiscount*item.getDouble("amount")*item.getInt("price")+singleVal/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue());
						//减去优惠后的实付金额
						pay_amount= new BigDecimal((item.getLong("unit_price")-unitDiscount*item.getLong("unit_price")-singleVal)/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
						pay_price=0d;
						if(pay_amount<0){
							pay_price=0d;
						}else{
							pay_price=pay_amount;
						}
						order_products_json.put("pay_amount", pay_price);
						need_pay+=new BigDecimal((item.getLong("unit_price")-unitDiscount*item.getLong("unit_price"))/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue()-singleVal/100.0;
					}else{
						order_products_json.put("discount_amount",0);
						//每个单品分摊的优惠
						order_products_json.put("apported_discount_amount", 
								new BigDecimal(unitDiscount*item.getDouble("amount")*item.getInt("price")/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue());
						//减去优惠后的实付金额
						pay_amount= new BigDecimal((item.getDouble("amount")*item.getInt("price")-unitDiscount*item.getDouble("amount")*item.getInt("price"))/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
						pay_price=0d;
						if(pay_amount<0){
							pay_price=0d;
						}else{
							pay_price=pay_amount;
						}
						order_products_json.put("pay_amount", pay_price);
						need_pay+= pay_amount;
					}/*
					order_products_json.put("discount_amount",0);
					order_products_json.put("apported_discount_amount", 
							new BigDecimal(unitDiscount*item.getDouble("amount")*item.getInt("price")/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue());
					order_products_json.put("pay_amount", 
							new BigDecimal((item.getDouble("amount")*item.getInt("price")-unitDiscount*item.getDouble("amount")*item.getInt("price"))/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue());
					*/
					order_products_json.put("item_title", item.getStr("product_name"));
					order_products_json.put("barcode", item.getStr("bar_code"));
					items.add(order_products_json);
					/*need_pay+=new BigDecimal((item.getDouble("amount")*item.getInt("price")-unitDiscount*item.getDouble("amount")*item.getInt("price"))/100.0).setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
*/				}
				order.put("items", items);
				
				order.put("real_total", need_pay);
			}
				logger.info(order.toJSONString());
				String postResult=post(order,"/soms/orderservice/order?operator="+operator);
				logger.info(postResult);
				//返回200就认为成功了 400表示订单已经存在了
			if(postResult.indexOf("code=200")!=-1||postResult.indexOf("code=400")!=-1){
				return true;
			}else{
				return false;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
			return false;
		}
		
	}
	/**
	 * 已经到海鼎的单退单
	 */
	public static boolean orderRejected(String orderId){
		JSONObject order=new JSONObject();
		JSONObject shop=new JSONObject();
		Record orderRecord=Db.findFirst("select t.*,ts.store_name from t_order t left join t_store ts on t.order_store=ts.store_id where t.order_id=? and t.order_status in('5','4')",
				orderId);
		//如果找不到要退的单，直接返回
		if(orderRecord==null){
			return false;
		}
		TUser tUser= new TUser().findById(orderRecord.getInt("order_user"));
		shop.put("id", orderRecord.getStr("order_store"));
		shop.put("name", orderRecord.getStr("store_name"));
		order.put("shop", shop);
		order.put("type", "refundAndRtn");//退货单类型,取值范围：refund(仅退款)、refundAndRtn(退款退货)；为空默认为退款退货
		order.put("state", "finished");//退货单状态,取值范围：confirmed(已生成)、finished(已完成)、canceled(已取消),为空时取默认值confirmed
		JSONObject customer=new JSONObject();
			JSONObject contact=new JSONObject();
			JSONObject address=new JSONObject();
			//收货地址可能为空 为自提
			if("2".equals(orderRecord.getStr("deliverytype"))){
				
				contact.put("name", orderRecord.getStr("receiver_name"));
				contact.put("mobile", orderRecord.getStr("receiver_mobile"));
				
				address.put("city", "长沙市");
				address.put("country", "");
				address.put("street", orderRecord.getStr("address_detail"));

			}else{
				//提货用户也需要显示用户信息
				contact.put("name", tUser.getStr("nickname"));
				contact.put("mobile", tUser.getStr("phone_num"));
			}
			customer.put("contact", contact);
		order.put("customer", customer);
		
		order.put("customer_note", orderRecord.getStr("reason"));
		order.put("order_id", orderRecord.getStr("order_id"));
		order.put("approve_state", "serviceApproved");//审批状态，取值范围:none(未审核)、serviceApproved(客服已审核)、serviceRefuse(客服已拒绝)、financeApproved(财务已审核)、financeRefuse(财务已拒绝)
		
		JSONObject delivery=new JSONObject();
				JSONObject station=new JSONObject();
				station.put("id", orderRecord.getStr("order_store"));
				station.put("name", orderRecord.getStr("store_name"));
			delivery.put("station", station);
			delivery.put("state", "received");//退货状态，取值范围:none(未退货)、customerShipped(客户已发货)、received(已收货)
				JSONObject returner=new JSONObject();
				JSONObject rcontact=new JSONObject();
				if("2".equals(orderRecord.getStr("deliverytype"))){
					rcontact.put("name", orderRecord.getStr("receiver_name"));
					rcontact.put("mobile", orderRecord.getStr("receiver_mobile"));

				}else{
					//提货用户也需要显示用户信息
					rcontact.put("name", tUser.getStr("nickname"));
					rcontact.put("mobile", tUser.getStr("phone_num"));
				}
				returner.put("contact",rcontact);
				returner.put("address",address);
				
			delivery.put("returner", returner);
		order.put("delivery", delivery);	
		JSONArray items=new JSONArray();
		//获取到需要退货的商品is_back=Y表示需要退的
		List<Record> order_products=Db.find("select op.*,tp.product_name,tpf.sku_id,tpf.product_code,tpf.bar_code,ifnull(tpf.special_price,tpf.price) as price,tpf.product_amount  from t_order_products op left join t_order "+
				"t on op.order_id=t.id left join t_product_f tpf on op.product_f_id=tpf.id "+
				"left join t_product tp on tp.id=tpf.product_id where t.order_id=? and op.is_back='Y'",orderId);
	
		//仓库提货(仓库商品价格为0)
		if("2".equals(orderRecord.getStr("order_type"))){
			
			order_products=Db.find("select op.*,tp.product_code,tp.product_name,tp.base_barcode as bar_code, "+
				" tp.sku_id,0 as price "+
				" from t_order_products op "+
				" left join t_order t on op.order_id=t.id "+
				" left join t_product tp on tp.id=op.product_id "+
				" where t.order_id=? and op.is_back='Y'",orderId);
			for(Record item:order_products){
				JSONObject productItem=new JSONObject();
				productItem.put("quantity", item.getDouble("amount"));
				productItem.put("total", item.getLong("unit_price")/100.0);
				productItem.put("sku_id", item.getStr("product_code").trim());
				productItem.put("item_title", item.getStr("product_name"));
				productItem.put("unit_price", item.getLong("unit_price")/(100.0*item.getDouble("amount")));
				productItem.put("refund_amount", item.getLong("unit_price")/100.0);
				items.add(productItem);
			}
		}else{
			for(Record item:order_products){
				JSONObject productItem=new JSONObject();
				
				productItem.put("quantity", new BigDecimal(item.getDouble("amount")*item.getDouble("product_amount")).setScale(2,BigDecimal.ROUND_HALF_UP));
				productItem.put("total", item.getDouble("amount")*item.getInt("price")/100.0);
				productItem.put("sku_id", item.getStr("product_code").trim());
				productItem.put("item_title", item.getStr("product_name"));
				productItem.put("unit_price", item.getInt("price")/(100.0*item.getDouble("product_amount")));
				//productItem.put("refund_amount",item.getDouble("amount")*item.getInt("price")/100.0);
				//计算单品退款金额 此处有均摊优惠价格
				productItem.put("refund_amount",item.getInt("pay_price")/100.0);
				items.add(productItem);
			}
		}
		order.put("items", items);
		//平台信息
		JSONObject front=new JSONObject();
			JSONObject platform=new JSONObject();
			platform.put("id", platformId);
			platform.put("name", platformName);
			front.put("platform", platform);
		order.put("front", front);
		try {
			logger.info(order.toJSONString());
			String postResult=post(order,"/soms/returnservice/rtn?operator="+operator);
			logger.info(postResult);
			if(postResult.indexOf("code=200")!=-1){
				return true;
			}else{
				return false;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
			return false;
		}
		
	}
	/**
	 * 取消海鼎库存订单(非退货)
	 * @param orderId
	 * @return
	 */
	public static String orderCancel(String orderId,String reason){
		String result=null;
		try {
			JSONObject cancelJson=new JSONObject();
			cancelJson.put("type", "customerCancel");
			cancelJson.put("reason", reason);
			 result=post(cancelJson,"/soms/orderservice/order/"+orderId+"/action/cancel?operator="+operator);
			
			logger.info("海鼎取消订单:"+result);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return result;
	}
	/**
	 * 订阅海鼎消息
	 * @return
	 */
	/*public static String subscribe(){
		
		String result=null;
		try {
			JSONObject subscribeJson=new JSONObject();
			subscribeJson.put("type", "customerCancel");
			
			String callbackUrl="https://weixin.shuiguoshule.com.cn/weixin/hdApi/backOrder";
			 result=post(subscribeJson,"/notify/notifyservice/subscribe?app_id=soms&callback_url="+callbackUrl
					 +"&operator="+operator);
			
			logger.info("海鼎订阅消息返回结果:"+result);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return result;
	}*/
	public static String post(JSONObject postData,String api) throws Exception {
		//配置服务器地址
		URL url = new URL(apiUrl+tenantId+api);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("POST");
		connection.setDoOutput(true);
		connection.addRequestProperty("Authorization", code(apiUser,apiPass));
		connection.addRequestProperty("Content-Type", "application/json;charset=UTF-8");
		connection.addRequestProperty("Accept", "application/json");
		connection.addRequestProperty("charset", charset.name());
		connection.connect();
		
		IOUtils.write(postData.toJSONString().getBytes(charset), connection.getOutputStream());
		InputStream result = connection.getResponseCode() == 200 ? connection.getInputStream() : connection.getErrorStream();
		//转换成utf-8格式输出
		BufferedReader in = new BufferedReader(new InputStreamReader(result,charset));
		List<String> lst = IOUtils.readLines(in);
		
		IOUtils.closeQuietly(result);
		IOUtils.close(connection);
		return "code="+connection.getResponseCode()+StringUtils.join(lst, "");
	}
	
	/**
	 * 
	 * @param postData
	 * https://api.u.hd123.com/4y2n8u7j/soms/returnservice/rtn?operator=eshop
	 * @param api="/soms/orderservice/order/front/100001021953895?platform_id=jdo2o"
	 * @throws Exception
	 */
	public static String get(String api) throws Exception {
		//配置服务器地址
		URL url = new URL(apiUrl+tenantId+api);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");
		connection.addRequestProperty("Authorization", code(apiUser,apiPass));
		connection.addRequestProperty("Content-Type", "application/json;charset=UTF-8");
		connection.addRequestProperty("Accept", "application/json");
		connection.addRequestProperty("charset", charset.name());
		connection.connect();
		InputStream result = connection.getResponseCode() == 200 ? connection.getInputStream() : connection.getErrorStream();
		List<String> lst = IOUtils.readLines(result, charset);
		
		IOUtils.closeQuietly(result);
		IOUtils.close(connection);
		return StringUtils.join(lst, "");
	}
	public static void main(String[] args) {
		registUser("07310109","12311","13900112356");
	}
	public static String registUser(String shopId,String name,String phoneNum) {
    	TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);
    	Authenticator.setDefault(new MyAuthenticator());
    	try {
            URL url = new URL(hdcard+"/member/regist?xid="+orderNoGenerator.nextId()+"&orgcode="+shopId);
            logger.info("海鼎注册会员url:"+url.toString());
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.addRequestProperty("Accept", "application/json");
            conn.addRequestProperty("Content-Type", "application/json;charset=UTF-8");
            conn.setRequestMethod("PUT");
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream(); 
            JSONObject getData=new JSONObject();
    		getData.put("name", name);
    		getData.put("paperType","OTHERPAPER");
    		getData.put("paperTypeCh","其它证件");
    		getData.put("paperCode","1234567890");
    		getData.put("cellPhone", phoneNum);
    		getData.put("appName","水果熟了微商城");
    		getData.put("registerDate", DateFormatUtil.format1(new Date()));
			getData.put("memberGradeOrder", 0);
			getData.put("sex", "male");//可选值: male("男"), female("女"), privacy("保密")
			getData.put("wedding", "K");// 婚否(必填,不能为空) 可选值: Y("是"), N("否"), K("保密")
			JSONObject org=new JSONObject();
    			org.put("code", shopId);
    			//org.put("name", "");
    		getData.put("org", org);	
    		logger.info("海鼎注册会员发送数据:"+getData.toJSONString()); 
            os.write(getData.toJSONString().getBytes("utf-8")); 
            os.flush();
            os.close();         
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";
            while( (line =br.readLine()) != null ){
                result += line;
            }
            br.close();
            logger.info("海鼎注册会员返回信息:"+result);
            return result;
       } catch (Exception e) {
    	   logger.info("海鼎注册会员返回失败信息:"+e.getMessage()); 
    	   return "";
       }
    }
	public static void main222(String[] args) {
		//orderRejected("817986278703235072");

		//orderReduce("E1482400408082");
		//orderCancel("814727581650649088");
		//String x="2017-1-1 09:00-12:00";
		//System.out.println(x.substring(0,x.lastIndexOf("-"))+":00");
		//System.out.println(x.substring(0,x.indexOf(" "))+" "+x.substring(x.lastIndexOf("-")+1)+":00");
	}
	public static void main111(String[] args) {
		String json1="{"+
			    "\"id\": \"100001021953896\","+
			    "\"shop\": {"+
			        "\"id\": \"0001\","+
			        "\"name\": \"海鼎测试店01\""+
			    "},"+
			    "\"state\": \"confirmed\","+
			    "\"customer\": {"+
			        "\"id\": \"JD_125h2e4565e18\","+
			        "\"contact\": {"+
			            "\"name\": \"陈\","+
			            "\"mobile\": \"18459278840\""+
			        "}"+
			    "},"+
			    "\"invoice\": {"+
			        "\"required\": false"+
			    "},"+
			    "\"payment\": {"+
			        "\"type\": \"cod\","+
			        "\"state\": \"notPay\","+
			        "\"freight\": 0,"+
			        "\"amount\": 20,"+
			        "\"pay_time\": \"2016-03-03 10:00:00\","+
			        "\"cod_amount\": 20,"+
			        "\"earnest_amount\": 0"+
			    "},"+
			    "\"delivery\": {"+
			        "\"type\": \"deliver\","+
			        "\"station\": {"+
			            "\"id\": \"0001\","+
			            "\"name\": \"海鼎测试店01\""+
			        "},"+
			        "\"state\": \"none\","+
			        "\"receiver\": {"+
			            "\"contact\": {"+
			                "\"name\": \"陈\","+
			                "\"mobile\": \"18459278840\""+
			            "},"+
			            "\"address\": {"+
			                "\"country\": \"平谷区\","+
			                "\"city\": \"北京市\","+
			                "\"street\": \"北京市平谷区梨树沟村5号\""+
			            "}"+
			        "},"+
			        "\"carrier\": {"+
			            "\"carrier\": {"+
			                "\"id\": \"9966\","+
			                "\"name\": \"京东众包\""+
			            "}"+
			        "}"+
			    "},"+
			    "\"front\": {"+
			        "\"platform\": {"+
			            "\"id\": \"jdo2o\","+
			            "\"name\": \"京东到家\""+
			        "},"+
			        "\"created\": \"2016-03-03 10:00:00\","+
			        "\"modified\": \"2016-03-03 10:00:00\","+
			        "\"state\": \"等待出库\","+
			        "\"order_id\": \"100001021953896\""+
			    "},"+
			    "\"items\": ["+
			        "{"+
			            "\"quantity\": 1,"+
			            "\"total\": 20,"+
			            "\"front\": {"+
			                "\"sku_id\": \"2001150251\","+
			                "\"item_id\": \"1000010219538892001150251\""+
			            "},"+
			            "\"item_no\": \"1\","+
			            "\"sku_id\": \"011202\","+
			            "\"item_title\": \"测试商品->海鼎绿茶\","+
			            "\"unit_price\": 20,"+
			            "\"pay_amount\": 20,"+
			            "\"discount_amount\": 0,"+
			            "\"apported_discount_amount\": 0"+
			        "}"+
			    "],"+
			    "\"print_bills\":[],"+
			    "\"real_total\": 20"+
			"}";
		try {
			//System.out.println(post(JSONObject.parseObject(json1),"/soms/orderservice/order?operator="+operator));
		System.out.println(get("/soms/orderservice/order/front/E1482400408082?platform_id=10001"));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}


/**
 * 查询海鼎门店实时库存接口
 * @throws Exception
 */
public static JSONObject querySku(String storeId,String[] skuIds) throws Exception{
	String url="invservice/businv/query";
	JSONObject condition=new JSONObject();
	condition.put("operation", "store code equals");
	JSONArray parameters=new JSONArray();
	JSONObject parameter=new JSONObject();
	parameter.put("type", "java.lang.String");
	parameter.put("value", storeId);
	parameters.add(parameter);
	condition.put("parameters", parameters);
	JSONArray conditions=new JSONArray();
	conditions.add(condition);
	
	JSONObject conditionSku=new JSONObject();
	conditionSku.put("operation", "skuid in");
	JSONArray parametersSku=new JSONArray();
	for(String skuId:skuIds){
    	JSONObject parameterSku=new JSONObject();
    	parameterSku.put("type", "java.lang.String");
    	parameterSku.put("value", skuId);
    	parametersSku.add(parameterSku);
	}
	conditionSku.put("parameters", parametersSku);
	
	conditions.add(conditionSku);
	
	JSONObject sendData=new JSONObject();
	sendData.put("conditions", conditions);
	JSONArray orders=new JSONArray();
	JSONObject order=new JSONObject();
	order.put("field", "order by skuid");
	order.put("direction", "asc");
	orders.add(order);
	sendData.put("orders", orders);
	sendData.put("pageSize", 10000);
	sendData.put("page", 0);
	sendData.put("probePages", -1);
	String result=h4Request("post",url,sendData);
	String returnCodeFlag="code=200";
	System.out.println("===="+result);
	JSONObject resultJson=null;
	if(result.startsWith(returnCodeFlag)&&result.indexOf("\"echoCode\":\"0\"")!=-1){
		System.out.println("-=-="+result.substring(returnCodeFlag.length(), result.length()-1));
		resultJson=JSONObject.parseObject(result.substring(returnCodeFlag.length(), result.length()));
	}else{
		resultJson=new JSONObject();
		resultJson.put("echoCode", "1");
	}
	return resultJson;
}

/**
 * 查询海鼎H4	
 * @param method
 * @param api
 * @param data
 * @return
 * @throws Exception
 */
public static String h4Request(String method, String api, JSONObject data) throws Exception {
	Authenticator.setDefault(
    		new MyAuthenticator());
    URL url = new URL(h4rest+api);
    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    connection.setRequestMethod(method.toUpperCase());
    connection.setDoOutput(true);
    String tok = apiUser + ':' + apiPass;
    String hash = Base64.encodeBase64String(tok.getBytes(charset));
    connection.addRequestProperty("Authorization", "Basic " + hash);
    connection.addRequestProperty("Content-Type", "application/json;charset=UTF-8");
    connection.addRequestProperty("Accept", "application/json");
    connection.addRequestProperty("charset", "UTF-8");
    connection.connect();

    if (data != null) {
        IOUtils.write(data.toString().getBytes(charset), connection.getOutputStream());
    }

    InputStream result = connection.getResponseCode() == 200 ? connection.getInputStream() : connection.getErrorStream();
    List<String> lst = null;
    if (method.equalsIgnoreCase("get")) {
        lst = IOUtils.readLines(result, charset);
    } else {
        lst = IOUtils.readLines(new BufferedReader(new InputStreamReader(result, charset)));
    }
    IOUtils.closeQuietly(result);
    IOUtils.close(connection);

    String str = String.join("", lst);
    return method.equalsIgnoreCase("get") ? str : "code=" + connection.getResponseCode() + str;
}

/**
 * @param productList
 * @param hdQueryProductData
 * @return
 */
public static void productInv(String store_id,List<Record> productList){
	//要查询的商品的base_barcode
	String[] productCodes = new String[productList.size()];
	for (int i=0;i<productList.size();i++) {
		productCodes[i] = productList.get(i).getStr("base_barcode");
	}
	for (Record product : productList) {
		//默认库存不足、查询失败
		product.set("inv_enough", "false");
		product.set("queryStatus", "false");
	}

	try {
		JSONObject hDQueryResult = HdUtil.querySku(store_id, productCodes);
		if(hDQueryResult.getIntValue("echoCode")==0 && hDQueryResult.getJSONArray("businvs")!=null && hDQueryResult.getJSONArray("businvs").size()>0){
			//查询正确，且有结果
			JSONArray productArr = hDQueryResult.getJSONArray("businvs");
			for (Record product : productList) {
				for (Object object : productArr) {
					JSONObject jsonObject = (JSONObject)object;
					if(product.getStr("base_barcode").equals(jsonObject.getString("barCode"))){
						product.set("queryStatus", "true");
						if(jsonObject.getDoubleValue("qty") >= product.getDouble("safe_qty")){
							//库存充足
							product.set("inv_enough", "true");
						}
					}
				}
			}
		}
	} catch (Exception e) {
		logger.error(e.getMessage());
		e.printStackTrace();
	}
	
}
public static String request(String method, String api, JSONObject data) throws Exception {
    URL url = new URL(apiUrl + tenantId + api);
    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    connection.setRequestMethod(method.toUpperCase());
    connection.setDoOutput(true);
    String tok = apiUser + ':' + apiPass;
    String hash = Base64.encodeBase64String(tok.getBytes(charset));
    connection.addRequestProperty("Authorization", "Basic " + hash);
    connection.addRequestProperty("Content-Type", "application/json;charset=UTF-8");
    connection.addRequestProperty("Accept", "application/json");
    connection.addRequestProperty("charset", charset.name());
    connection.connect();

    if (data != null) {
        IOUtils.write(data.toString().getBytes(charset), connection.getOutputStream());
    }

    InputStream result = connection.getResponseCode() == 200 ? connection.getInputStream() : connection.getErrorStream();
    List<String> lst = null;
    if (method.equalsIgnoreCase("get")) {
        lst = IOUtils.readLines(result,charset);
    } else {
        lst = IOUtils.readLines(new BufferedReader(new InputStreamReader(result, charset)));
    }
    IOUtils.closeQuietly(result);
    IOUtils.close(connection);

    String str = String.join("", lst);
    return method.equalsIgnoreCase("get") ? str : "code=" + connection.getResponseCode() + str;
}
/**
 * 海鼎订单状态查询
 * 
 */
public static String orderDetail(String orderId){
	String hdOrderState = null;
	  try{
	    JSONObject data = new JSONObject();
	    data.put("type", "customerCancel");
	    String result = request("get", "/soms/orderservice/order/" + orderId + "?parts=items", null);
	    JSONObject jsonResult = (JSONObject)JSONObject.parse(result);
	    hdOrderState = jsonResult.getString("state");
	  }catch (Exception e){
		  e.printStackTrace();
	  }
	  return hdOrderState;
}
}


class MyAuthenticator extends Authenticator {
	protected PasswordAuthentication getPasswordAuthentication() {
	 boolean devMode=JFinal.me().getConstants().getDevMode();
	 String username = devMode?"guest":"guest",password = devMode?"guest":"guest";
	 return new PasswordAuthentication(username, password.toCharArray());
	}
}
	