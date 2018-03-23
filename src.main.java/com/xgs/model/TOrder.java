package com.xgs.model;

import java.util.List;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.ObjectToJson;

public class TOrder extends Model<TOrder> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public static final TOrder dao = new TOrder();

	private List<Record> orderProducts;// 订单中的商品
	private JSONArray orderProductsJson;
	private int totalProduct;// 订单中商品总数统计

	public int getTotalProduct() {
		return totalProduct;
	}

	public void setTotalProduct(int totalProduct) {
		this.totalProduct = totalProduct;
	}

	public List<Record> getOrderProducts() {
		return orderProducts;
	}

	public void setOrderProducts(List<Record> orderProducts) {
		this.orderProducts = orderProducts;
		JSONArray list = new JSONArray();
		for (Record r : orderProducts) {
			JSONObject item = JSONObject.parseObject(r.toJson());
			list.add(item);
		}
		this.orderProductsJson = list;
	}

	public JSONArray getOrderProductsJson() {
		return orderProductsJson;
	}

	public void setOrderProductsJson(JSONArray orderProductsJson) {
		this.orderProductsJson = orderProductsJson;
	}

	/**
	 * 鲜果师下级今日下的单
	 */
	public Record findMasterToderOrderByMasterId(int master_id) {
		return Db.findFirst("select count(*) order_numbers,sum(o.need_pay) order_total "
				+ "from t_order o  where o.order_source = '1' and o.order_status in('3','4','11') and master_id = ? "
				+ "and (SELECT CAST((CAST(SYSDATE()AS DATE) - INTERVAL 1 DAY)AS DATETIME))<=createtime and createtime<= (SELECT CAST(CAST(SYSDATE()AS DATE)AS DATETIME)) "
				+ "group by master_id", master_id);
	}

	/**
	 * 客户在鲜果师商城当月消费次数及消费金额
	 */
	public Record findMonthOrderByUserId(int master_id,int user_id) {
		return Db.findFirst(
				"select count(*) count ,ifnull(sum(need_pay),0) total from t_order "
						+ "where order_user = ? and order_source = '1' and DATE_ADD(curdate(),interval -day(curdate())+1 day)< pay_time and pay_time < NOW() and order_status in(3,4,11) and master_id=?",
				user_id,master_id);
	}

	/**
	 * 客户在鲜果师商城所有消费次数及消费金额
	 */
	public Record findAllOrderByUserId(int master_id,int user_id) {
		return Db.findFirst(
				"select ifnull(count(*),0) count ,ifnull(sum(need_pay),0) total from t_order where order_user = ? and order_source = '1' and order_status in(3,4,11) and master_id =? ",
				user_id,master_id);
	}

	/**
	 * 查询鲜果师业绩订单（根据天数）
	 */
	public List<TOrder> findAllOrderByDays(int master_id, int days) {
		// 按照传入的天数统计订单数量及交易金额
		List<TOrder> orders = dao.find(
				"select id,need_pay,DATE_FORMAT(pay_time,'%Y-%m-%d') pay_time from t_order where order_status in (3,4,11) "
						+ "and DATE_FORMAT(date_sub(now(),interval ? day),'%Y-%m-%d 00:00:00') <= pay_time "
						+ "and pay_time <= now() and master_id = ? and order_source = '1' order by pay_time ",
				days, master_id);
		return orders;
	}
	
	/**
	 * 鲜果师业绩统计
	 */
	public Record statisticsOrderByDays(int master_id, int days) {
		// 按照传入的天数统计订单数量及交易金额(包括自身购买及客户购买的)
		Record record = Db.findFirst(
				"select ifnull(count(*),0) count ,ifnull(sum(need_pay),0) total from t_order where order_status in (3,4,11) "
						+ "and DATE_FORMAT(date_sub(now(),interval ? day),'%Y-%m-%d 00:00:00') <= pay_time "
						+ "and pay_time <= now() and master_id = ? and order_source = '1'",
				days-1, master_id);
		return record;
	}
	
	/**
	 * 鲜果师自身订单
	 */
	public Record masterSelfOrderByDays(int user_id, int days){
		// 按照传入的天数统计自身订单数量及交易金额
		Record record = Db.findFirst(
				"select ifnull(count(*),0) count ,ifnull(sum(need_pay),0) total from t_order where order_status in (3,4,11) "
						+ "and DATE_FORMAT(date_sub(now(),interval ? day),'%Y-%m-%d 00:00:00') <= pay_time "
						+ "and pay_time <= now() and order_user = ?  and order_source = '1'",
				days, user_id);
		return record;
	}
	/**
	 * 鲜果师下级订单
	 */
	public Record masterCustomerOrderByDays(int master_id, int days){
		// 按照传入的天数统计客户订单数量及交易金额
		Record record = Db.findFirst(
				"select ifnull(count(*),0) count ,ifnull(sum(need_pay),0) total from t_order where order_status in (3,4,11) "
						+ "and DATE_FORMAT(date_sub(now(),interval ? day),'%Y-%m-%d 00:00:00') <= pay_time "
						+ "and pay_time <= now() and master_id = ?  and order_source = '1'",
				days, master_id);
		return record;
	}
	/**
	 * 鲜果师订单管理（所有自己下级跟自己购买的订单）
	 * 
	 * @param order_status
	 * @param master_id
	 * @param pageNumber
	 * @param pageSize
	 * @return
	 */
	public Page<TOrder> findOrdersByType(int order_status, int master_id, int pageNumber, int pageSize) {
		String order_type = "";
		switch (order_status) {
		case 1:// 进行中 全部
			order_type = " and order_status in ('1','2','3','4','5','6','7','8','9','10') ";
			break;
		case 2:// 待付款
			order_type = " and order_status in ('1','2') ";
			break;
		case 3:// 代收货
			order_type = " and order_status = '3' ";
			break;
		case 4:// 退货
			order_type = " and order_status in ('5','6','8') ";
			break;
		case 5:// 已完成
			order_type = " and order_status = '11' ";
			break;
		}
		String select = "select o.*,case o.order_status  " + "when '1' then '待付款' " + "when '2' then '支付中' "
				+ "when '3' then '待收货' " + "when '4' then '已收货' " + "when '5' then '退货中' " + "when '6' then '退货完成' "
				+ "when '7' then '退货中' " + "when '8' then '店铺处理中' " + "when '9' then '店铺退货失败' "
				+ "when '10' then '微信退款失败' " + "when '11' then '成功' "
				+ "when '0' then '已失效' end as status_name,ifnull(mu.master_desc,u.nickname) customer_name ";
		String sqlExceptSelect = " from t_order o left join t_user u on o.order_user = u.id "
				+ "left join x_master_user mu on o.order_user = mu.user_id "
				+ "where o.order_source = '1' and o.master_id = " + master_id + " and o.order_status" + order_type +" order by createtime desc";
		// 分页加载
		Page<TOrder> page_orders = dao.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		for (TOrder item : page_orders.getList()) {
			int orderId = item.getInt("id");
			// 查找订单中所拥有的商品信息
			// 不同规格的同个商品是否分开展示，如果需要还需要查询t_product_f
			List<Record> orderProducts = Db.find("select p.*,i.save_string from t_order_products op "
					+ "left join t_product p on op.product_id=p.id "
					+ "left join t_image i on p.img_id=i.id where op.order_id=? ", orderId);
			item.put("orderProducts", ObjectToJson.recordListConvert(orderProducts));// 订单中的商品信息
			item.put("totalProduct", orderProducts.size());// 统计当前订单中商品总数

		}

		return page_orders;

	}

	public Record findOrderDetail(int order_id) {
		String sql = "select o.*,s.store_name,case o.order_status   when '1' then '待付款' when '2' then '支付中' "
				+ " when '3' then '待收货'  when '4' then '已收货' when '5' then '退货中'  when '6' then '退货完成' "
				+ " when '7' then '退货中'  when '8' then '店铺处理中' when '9' then '店铺退货失败' "
				+ " when '10' then '微信退款失败'  when '11' then '成功' when '0' then '已失效' end as status_name, "
				+ " case o.deliverytype when '1' then '门店自提' when '2' then '送货上门' end as delivery_name, "
				+ " ifnull(mu.master_desc,u.nickname) customer_name  "
				+ " from t_order o left join t_user u on o.order_user = u.id "
				+ " left join x_master_user mu on o.order_user = mu.user_id  "
				+ " LEFT JOIN t_store s on o.order_store = s.store_id " + " where o.id =  ?";
		Record order_record = Db.findFirst(sql, order_id);
		// 订单下对应的商品信息
		List<Record> orderProducts = Db.find("select p.*,pf.*,u.unit_name,i.save_string from t_order_products op "
				+ "LEFT JOIN t_product_f pf on op.product_f_id = pf.id "
				+ "left join t_product p on op.product_id=p.id " + "left join t_unit u on p.base_unit = u.unit_code "
				+ "left join t_image i on p.img_id=i.id where op.order_id=? ", order_id);
		order_record.set("productList", ObjectToJson.recordListConvert(orderProducts));
		order_record.set("totalProduct", orderProducts.size());// 统计当前订单中商品总数
		
		return order_record;
	}

	/**
	 * 统计鲜果师用户的订单（包括全部订单、待付款、待发货、待收货、退货）
	 * 
	 * @param uuid
	 * @return
	 */
	public Record findMasterTOrderTotal(int userId) {
		return Db.findFirst(
				"select (select count(*) from t_order where order_user=? and order_status ='1' and order_source = '1')as dfk,"
						+ "(select count(*) from t_order where order_user=? and order_status ='3' and order_source = '1')as dsh from dual",
				userId, userId);
	}

	public TOrder findMasterTOrderByOrderId(String orderId) {
		return dao.findFirst("select * from t_order where order_source = '1' and order_id=?", orderId);
	}

	/**
	 * 根据状态查询订单
	 * 
	 * @param status
	 *            0全部1待付款2待发货3待收货4退货
	 * @return
	 */
	public List<TOrder> findTOrdersByUserId(int userId) {
		String sql = "select * from t_order where order_user=? and order_source=1" + " order by createtime desc";
		List<TOrder> tOrders = dao.find(sql, userId);
		for (TOrder item : tOrders) {
			int orderId = item.getInt("id");
			// 查找订单中所拥有的商品信息
			// ?不同规格的同个商品是否分开展示，如果需要还需要查询t_product_f
			List<Record> orderProducts = Db.find("select p.*,i.save_string from t_order_products op "
					+ "left join t_product p on op.product_id=p.id "
					+ "left join t_image i on p.img_id=i.id where op.order_id=? ", orderId);
			item.setOrderProducts(orderProducts);
			// 统计当前订单中
			item.setTotalProduct(orderProducts.size());
		}
		return tOrders;
	}

	/**
	 * 统计用户的订单（包括全部订单、待付款、待发货、待收货、退货）
	 * 
	 * @param uuid
	 * @return
	 */
	public Record findTOrderTotal(int userId) {
		return Db.findFirst(
				"select (select count(*) from t_order where order_user=? and order_status ='1' and order_source ='1')as dfk,"
						+ "(select count(*) from t_order where order_user=? and order_status in ('3',12) and order_source ='1')as dsh,"
						+ "(select count(*) from t_order where order_user=? and order_status in ('5','6','8','9','10') and order_source ='1')as th from dual",
				userId, userId, userId);
	}

	/**
	 * 查询用户订单记录
	 * 
	 * @param orderStatus
	 * @param hdStatus
	 * @param createTime
	 * @return
	 */
	public Page<Record> findOrderList(String orderId, String phoneNum, int orderStatus, int hdStatus,
			String createDateBegin, String createDateEnd, int pageSize, int page, String sidx, String sord) {
		String sql="select t.id,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime,t.order_source,t.master_id, "
				+ " date_format(p.time_end,'%H:%i:%s') as time_end,t.order_id,p.transaction_id,if(p.transaction_id is null,'否','是') as wx_pay,t.total,t.discount,t.need_pay,u.phone_num ,u.nickname ,u.balance , "
				+ " if(t.order_type=1,'正常购买','仓库提货') as order_type,if(t.deliverytype=1,'门店自提','送货上门') as deliverytype,t.reason,t.customer_note, "
				+ " t.hd_status,t.old_order_id," + "CASE t.order_status " + "when '1' then '待付款' "
				+ "when '2' then '支付中' " + "when '3' then '待收货' " + "when '4' then '已收货' "
				+ "when '5' then '退货中' " + "when '6' then '退货完成' " + "when '7' then '取消中' "
				+ "when '8' then '海鼎退货中' " + "when '9' then '海鼎退货失败' " + "when '10' then '微信退款失败' "
				+ "when '11' then '订单成功' " + "when '0' then '已失效' end as order_status";
		String where=" from t_order t " + " left join t_store s on t.order_store=s.store_id "
				+ " left join t_pay_log p on t.order_id=p.out_trade_no "
				+ " left join t_user u on t.order_user=u.id " + " where t.order_source=1 and t.createtime between '"
				+ createDateBegin + "' and '" + createDateEnd + "' " ; 
				if(StringUtil.isNotNull(orderId)){
					where +="and t.order_id like'%" + orderId + "%' ";
				}
				if(StringUtil.isNotNull(phoneNum)){
					where +="and t.order_id like'%" + phoneNum + "%' ";
				}
				//全部
				if(orderStatus != -1 && hdStatus != -1){
					if(hdStatus>-2){
						where +="and t.hd_status="+hdStatus+" ";
					}
					if(orderStatus>-2){
						where +="and t.order_status="+orderStatus+" ";
					}
				}else{
					if(orderStatus!=-1){
						where +="and t.order_status="+orderStatus+" ";
					}
					if(hdStatus!=-1){
						where +="and t.hd_status="+hdStatus+" ";
					}
				}
				if(StringUtil.isNull(sidx)){
					where+= " order by t.createtime desc ";
				}else{
					where+= " order by " + sidx + " " + sord;
				}
				return Db.paginate(page, pageSize, sql, where);
	}

	/**
	 * 根据订单类型统计订单数
	 * 
	 * @return
	 */
	public List<Record> orderStatByType() {
		return Db.find(
				"select count(order_type) count,order_type from t_order where order_source=1 and order_status in('3','4') group by order_type");
	}
	

	/**
	 * 根据水果类型统计订单中的下单水果数量
	 */
	public List<Record> getOrderStatByFruitType() {
		return Db.find("select sum(tp.amount) amount,p.product_name from t_order t left join t_order_products tp "
				+ " on t.id=tp.order_id " + " left join t_product p " + " on tp.product_id=p.id "
				+ " where order_source=1 and order_status in('3','4','5','11') " + " and p.category_id not like '03%' "
				+ " group by product_name " + " limit 10 ");
	}
	
	/**
	 * 海鼎发送失败数
	 * 
	 * @return
	 */
	public Record findFailOrder() {
		return Db.findFirst("select count(*) as orderFailCount from t_order where order_source=1 and hd_status ='1'");
	}


	
}
