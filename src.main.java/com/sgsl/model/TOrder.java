package com.sgsl.model;

import java.util.ArrayList;
import java.util.List;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.base.Objects;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;

/**
 * Created by yj on 2014/7/28. 微网站订单信息
 */
public class TOrder extends Model<TOrder> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public static final TOrder dao = new TOrder();

	private List<Record> orderProducts;// 订单中的商品
	private JSONArray orderProductsJson;
	private int totalProduct;// 订单中商品总数统计
	
	private boolean isTeamOrder;//是否为团购订单

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
	
	public boolean isTeamOrder() {
		return isTeamOrder;
	}

	public void setTeamOrder(boolean isTeamOrder) {
		this.isTeamOrder = isTeamOrder;
	}

	/**
	 * 统计用户的订单（包括全部订单、待付款、待发货、待收货、退货）
	 * 
	 * @param uuid
	 * @return
	 */
	public Record findTOrderTotal(int userId) {
		return Db.findFirst(
				"select (select count(*) from t_order where order_user=? and order_status ='1' and order_source is null)as dfk,"
						+ "(select count(*) from t_order where order_user=? and order_status ='3' and order_source is null)as dsh from dual",
				userId, userId);
	}

	public TOrder findTOrderByOrderId(String orderId) {
		return dao.findFirst("select * from t_order where order_id=?", orderId);
	}

	
	
	/**
	 * 根据状态查询订单
	 * 
	 * @param status
	 *            0全部1待付款2待发货3待收货4退货
	 * @return
	 */
	public List<TOrder> findTOrdersByUserId(int userId) {
		String sql = "select * from t_order where order_user=? and order_source is null order by createtime desc";
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
	 * 根据状态查询订单
	 * 
	 * @param status
	 *            0全部1待付款2待发货3待收货4退货
	 * @return
	 */
	public List<TOrder> findTOrdersByUserId1(int userId) {
		String sql = "select t.*,("
				+ "select count(1) from m_team_member t1 where t1.order_id = t.order_id) as teamOrder "
				+ "from t_order t where t.order_user=? and t.order_source is null order by t.createtime desc";
		List<TOrder> tOrders = dao.find(sql, userId);
		StringBuilder s = new StringBuilder("select op.order_id, p.*,i.save_string from t_order_products op ")
				.append("left join t_product p on op.product_id=p.id ")
				.append("left join t_image i on p.img_id=i.id where op.order_id in(");
		List<Integer> orderIds = new ArrayList<>(tOrders.size());
		String subSql = null;
		if(tOrders.size()>0){
			for (TOrder item : tOrders) {
				s.append("?").append(",");
				orderIds.add(item.getInt("id"));
//			// 查找订单中所拥有的商品信息
//			// ?不同规格的同个商品是否分开展示，如果需要还需要查询t_product_f
//			List<Record> orderProducts = Db.find(""
//					+ ""
//					+ "=? ", orderId);
//			item.setOrderProducts(orderProducts);
//			//查看是否是单线订单（非团购订单）
//			item.setTeamOrder(item.getLong("teamOrder")>0);
//			// 统计当前订单中
//			item.setTotalProduct(orderProducts.size());
			}
			subSql = s.substring(0, s.length() - 1) + ")";
		}else{
			s.append("0");
			subSql = s.substring(0, s.length()) + ")";
		}
		 
		List<Record> allProducts = Db.find(subSql, orderIds.toArray());
		System.out.println("=============" + subSql);
		System.out.println("=============" + orderIds);
		for (TOrder item : tOrders) {
			int id = item.getInt("id");
			List<Record> myProducts = new ArrayList<>();
			for(Record record: allProducts){
				int orderId = record.getInt("order_id");
				if(orderId == id){
					myProducts.add(record);
				}
			}
			item.setOrderProducts(myProducts);
			//查看是否是单线订单（非团购订单）
			item.setTeamOrder(item.getLong("teamOrder")>0);
			// 统计当前订单中
			item.setTotalProduct(myProducts.size());
		}
		return tOrders;
	}

	public Record findTOrderById(long orderId, int user) {
		String sql = "";
		sql += "select a.*," + "CASE a.order_status " + "when '1' then '待付款' " + "when '2' then '支付中' "
				+ "when '3' then '待收货' " + "when '4' then '已收货' " + "when '5' then '退货中' " + "when '6' then '退货完成' "
				+ "when '7' then '退货中' " + "when '8' then '店铺处理中' " + "when '9' then '店铺退货失败' "
				+ "when '10' then '微信退款失败' " 
				+ "when '11' then '订单成功' " 
				+ "when '12' then '配送中' " 
				+ "when '0' then '已失效' end as status_cn," + "c.store_name,tc.coupon_val "
				+ "from t_order a " + "LEFT JOIN t_store c on a.order_store=c.store_id "
				+ "left join t_coupon_real tc on a.order_coupon=tc.id "
				+ "where a.order_status='1'and a.id=? and a.order_user=?";
		return Db.findFirst(sql, orderId, user);
	}

	public Record findTOrderDetail(long orderId, int user) {
		String sql = "";
		sql += "select a.*,cou.coupon_desc," + "date_format(a.pay_time ,'%Y-%m-%d %H:%i:%s') as pay_time_display,"
				+ "date_format(a.createtime ,'%Y-%m-%d %H:%i:%s') as createtime_display," + "CASE a.order_status "
				+ "when '1' then '待付款' " + "when '2' then '支付中' " + "when '3' then '待收货' " + "when '4' then '已收货' "
				+ "when '5' then '退货中' " + "when '6' then '退货完成' " + "when '7' then '退货中' " + "when '8' then '店铺处理中' "
				+ "when '9' then '店铺退货失败' " + "when '10' then '微信退款失败' " + "when '11' then '成功' "
				+ "when '12' then '配送中' "
				+ "when '0' then '已失效' end as status_cn," + "c.store_name,c.store_phone " + "from t_order a "
				+ "LEFT JOIN t_store c on a.order_store=c.store_id "
				+ "LEFT JOIN t_coupon_real cou on a.order_coupon=cou.id " + "where a.id=? and a.order_user=?";
		return Db.findFirst(sql, orderId, user);
	}

	public int updateStatus(int orderId, int user, String before_status, String after_status) {
		String sql = "update t_order set order_status = ? where order_status=? and id=? and order_user=?";
		return Db.update(sql, after_status, before_status, orderId, user);
	}

	/**
	 * 退货原因
	 * 
	 * @param orderId
	 * @param user
	 * @param before_status
	 * @param after_status
	 * @param reason
	 * @return
	 */
	public int updateReason(int orderId, int user, String before_status, String after_status, String reason) {
		String sql = "update t_order set order_status = ?,reason=? where order_status=? and id=? and order_user=?";
		return Db.update(sql, after_status, reason, before_status, orderId, user);
	}

	/**
	 * 普通订单或者提货订单
	 * 
	 * @param orderId
	 * @param orderType
	 *            1普通订单 其他 提货订单
	 * @return
	 */
	public List<Record> findOrderProList(int orderId, String orderType) {
		String sql = "select a.*,a.unit_price as price,a.amount as product_amount,c.product_name,d.save_string,u.unit_name from t_order_products a ";
		sql += "left join t_product c on a.product_id = c.id ";
		if (orderType.equals("1")) {
			sql += "left join t_product_f b on a.product_f_id = b.id ";
		}
		sql += "left join t_image d on c.img_id = d.id ";
		if (orderType.equals("1")) {
			sql += "left join t_unit u on b.product_unit = u.unit_code ";
		} else {
			sql += "left join t_unit u on c.base_unit = u.unit_code ";
		}
		sql += "where a.order_id=?";
		return Db.find(sql, orderId);
	}

	public List<Record> findOrderProList(int orderId) {
		String sql = "select * from t_order_products where order_id=?";
		return Db.find(sql, orderId);
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
		String sql="select t.id,t.order_style,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime,t.order_source,t.master_id, "
				+ " date_format(p.time_end,'%H:%i:%s') as time_end,t.order_id,p.transaction_id,if(p.transaction_id is null,'否','是') as wx_pay,t.total,t.discount,t.need_pay,u.phone_num ,u.nickname ,u.balance , "
				+ " if(t.order_type=1,'正常购买','仓库提货') as order_type,if(t.deliverytype=1,'门店自提','送货上门') as deliverytype,t.reason,t.customer_note, "
				+ " t.hd_status,t.old_order_id," + "CASE t.order_status " + "when '1' then '待付款' "
				+ "when '2' then '支付中' " + "when '3' then '待收货' " + "when '4' then '已收货' "
				+ "when '5' then '退货中' " + "when '6' then '退货完成' " + "when '7' then '取消中' "
				+ "when '8' then '海鼎退货中' " + "when '9' then '海鼎退货失败' " + "when '10' then '微信退款失败' "
				+ "when '11' then '订单成功' " 
				+ "when '12' then '配送中' "
				+ "when '0' then '已失效' end as order_status";
		String where=" from t_order t " + " left join t_store s on t.order_store=s.store_id "
				+ " left join t_pay_log p on t.order_id=p.out_trade_no "
				+ " left join t_user u on t.order_user=u.id " + " where t.order_source is null and t.createtime between '"
				+ createDateBegin + "' and '" + createDateEnd + "' " ; 
				if(StringUtil.isNotNull(orderId)){
					where +="and t.order_id like'%" + orderId + "%' ";
				}
				if(StringUtil.isNotNull(phoneNum)){
					where +="and u.phone_num like'%" + phoneNum + "%' ";
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
	 * 根据用户编号查询订单
	 * 
	 * @param userId
	 * @param pageSize
	 * @param page
	 * @param sidx
	 * @param sord
	 * @return
	 */
	public Page<Record> findOrderByUserIdList(int userId, int pageSize, int page, String sidx, String sord) {

		Page<Record> pageInfo = null;

		if (StringUtil.isNull(sidx)) {
			pageInfo = Db.paginate(page, pageSize,
					"select t.id,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime, "
							+ " date_format(p.time_end,'%H:%i:%s') as time_end,t.order_id,p.transaction_id ,u.phone_num ,u.nickname ,u.balance , "
							+ " tp.amount ,tp.unit_price,pr.product_name ,t.order_status ,if(t.order_type=1,'正常购买','仓库提货') as order_type, "
							+ " tpf.standard,t.hd_status",
					" from t_order t " + " left join t_store s on t.order_store=s.store_id "
							+ " left join t_order_products tp on tp.order_id=t.id "
							+ " left join t_product pr on tp.product_id=pr.id "
							+ " left join t_product_f tpf on pr.id=tpf.product_id "
							+ " left join t_pay_log p on t.order_id=p.out_trade_no "
							+ " left join t_user u on t.order_user=u.id " + " where  u.id=? order by t.createtime",
					userId);
		} else {
			pageInfo = Db.paginate(page, pageSize,
					"select t.id,s.store_name,date_format(t.createtime,'%Y-%m-%d') as createtime, date_format(t.createtime,'%H:%i:%s') as commitTime, "
							+ " date_format(p.time_end,'%H:%i:%s') as time_end,t.order_id,p.transaction_id ,u.phone_num ,u.nickname ,u.balance , "
							+ " tp.amount ,tp.unit_price,pr.product_name ,t.order_status ,if(t.order_type=1,'正常购买','仓库提货') as order_type, "
							+ " tpf.standard,t.hd_status",
					" from t_order t " + " left join t_store s on t.order_store=s.store_id "
							+ " left join t_order_products tp on tp.order_id=t.id "
							+ " left join t_product pr on tp.product_id=pr.id "
							+ " left join t_product_f tpf on pr.id=tpf.product_id "
							+ " left join t_pay_log p on t.order_id=p.out_trade_no "
							+ " left join t_user u on t.order_user=u.id " + " where  u.id=? order by " + sidx + " "
							+ sord,
					userId);
		}
		return pageInfo;
	}

	/**
	 * 店铺订单比
	 */
	public List<Record> orderStatByStore() {
		return Db.find("select count(*) count,s.store_name from t_order o left join t_store s "
				+ " on o.order_store=s.store_id where o.order_source not in('1') and o.order_status in('3','4','5','11') group by s.store_name");
	}

	/**
	 * 根据订单类型统计订单数
	 * 
	 * @return
	 */
	public List<Record> orderStatByType() {
		return Db.find(
				"select count(order_type) count,order_type from t_order where order_source is null and order_status in('3','4') group by order_type");
	}

	/**
	 * 根据水果类型统计订单中的下单水果数量
	 */
	public List<Record> getOrderStatByFruitType() {
		return Db.find("select sum(tp.amount) amount,p.product_name from t_order t left join t_order_products tp "
				+ " on t.id=tp.order_id " + " left join t_product p " + " on tp.product_id=p.id "
				+ " where t.order_source not in('1') and order_status in('3','4','5','11') " + " and p.category_id not like '03%' "
				+ " group by product_name " + " limit 10 ");
	}

	/**
	 * 根据干果类型统计订单中的下单干果数量
	 * 
	 * @return
	 */
	public List<Record> getOrderStatByUntsType() {
		return Db.find("select sum(tp.amount) amount,p.product_name from t_order t left join t_order_products tp "
				+ " on t.id=tp.order_id " + " left join t_product p " + " on tp.product_id=p.id "
				+ " where t.order_source not in('1') and order_status in('3','4','5','11') " + " and p.category_id like '03%' "
				+ " group by product_name " + " limit 10 ");
	}

	public List<TOrder> getOrderByStoreId(int storeId) {
		if (storeId == 9999) {
			return TOrder.dao.find("select o.*," + "CASE o.order_status " + "when '1' then '待付款' "
					+ "when '2' then '支付中' " + "when '3' then '待收货' " + "when '4' then '已收货' " + "when '5' then '退货中' "
					+ "when '6' then '退货完成' " + "when '7' then '退货中' " + "when '8' then '店铺处理中' "
					+ "when '9' then '海鼎退货失败' " + "when '10' then '微信退款失败' " + "when '11' then '订单成功' "
					+ "when '12' then '配送中' "
					+ "when '0' then '已失效' end as status_cn,t.phone_num,t.nickname,s.store_name"
					+ "  from t_order o left join t_user t on o.order_user=t.id left join t_store s "
					+ " on o.order_store=s.store_id where o.order_source is null and o.order_status ='5' ");
		} else {
			return TOrder.dao.find("select o.*," + "CASE o.order_status " + "when '1' then '待付款' "
					+ "when '2' then '支付中' " + "when '3' then '待收货' " + "when '4' then '已收货' " + "when '5' then '退货中' "
					+ "when '6' then '退货完成' " + "when '7' then '退货中' " + "when '8' then '店铺处理中' "
					+ "when '9' then '海鼎退货失败' " + "when '10' then '微信退款失败' " + "when '11' then '订单成功' "
					+ "when '12' then '配送中' "
					+ "when '0' then '已失效' end as status_cn,t.phone_num,t.nickname,s.store_name"
					+ "  from t_order o left join t_user t on o.order_user=t.id left join t_store s "
					+ " on o.order_store=s.store_id where o.order_source not in('1') and order_status ='5' and s.id=? ", storeId);
		}
	}

	/**
	 * 未付款数量
	 * 
	 * @param userId
	 * @return
	 */
	public Record findTUnpayOrderTotal(int userId) {
		return Db.findFirst("select count(*) as dfk from t_order where order_user=? and order_status ='1'", userId);
	}

	/**
	 * 海鼎发送失败数
	 * 
	 * @return
	 */
	public Record findFailOrder() {
		return Db.findFirst("select count(*) as orderFailCount from t_order where order_source is null and hd_status ='1'");
	}

	/**
	 * 查询是否用户第一次消费并且送货上门的
	 * 
	 * @param userId
	 * @return
	 */
	public boolean isUserFirstBuy(int userId) {
		Record record = Db.findFirst(
				"select count(*) as orderCount from t_order where order_user=? and deliverytype='2' and order_status in (3,4)",
				userId);
		if (record != null && record.getLong("orderCount") == 1) {
			return true;
		}
		return false;
	}

	/**
	 * 个人消费排行
	 * 
	 * @param userId
	 *            如果用户编号传0 就是排行榜
	 * @param
	 */
	public List<Record> consume(int userId, String beginTime, String endTime) {
		StringBuffer sql = new StringBuffer(
				"select * from(select order_user,sum(need_pay) as need_pay from t_order where order_status in(3,4,5,11) ");
		if (userId > 0) {
			sql.append(" and order_user=");
			sql.append(userId);
		}
		sql.append(" and createtime between ? and ? group by order_user) t ");
		sql.append(" order by need_pay desc");
		return Db.find(sql.toString(), beginTime, endTime);
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
	public Record findMonthOrderByUserId(int user_id) {
		return Db.findFirst(
				"select count(*) count ,ifnull(sum(need_pay),0) total from t_order "
						+ "where order_user = ? and order_source = '1' and DATE_ADD(curdate(),interval -day(curdate())+1 day)< pay_time and pay_time < NOW()",
				user_id);
	}

	/**
	 * 客户在鲜果师商城当月消费次数及消费金额
	 */
	public Record findAllOrderByUserId(int user_id) {
		return Db.findFirst(
				"select ifnull(count(*),0) count ,ifnull(sum(need_pay),0) total from t_order where order_user = ? and order_source = '1'",
				user_id);
	}

	/**
	 * 查询鲜果师业绩订单（根据天数）
	 */
	public List<TOrder> findAllOrderByDays(int master_id, int days) {
		// 按照传入的天数统计订单数量及交易金额
		List<TOrder> orders = dao.find(
				"select id,need_pay,DATE_FORMAT(pay_time,'%Y-%m-%d') pay_time from t_order where order_status in (3,4,11) "
						+ "and DATE_FORMAT(date_sub(now(),interval ? day),'%Y-%m-%d 00:00:00') <= pay_time "
						+ "and pay_time <= now() and master_id = ?  and order_source = '1' order by pay_time desc",
				days, master_id);
		return orders;
	}

	/**
	 * 鲜果师业绩统计
	 */
	public Record statisticsOrderByDays(int master_id, int days) {
		// 按照传入的天数统计订单数量及交易金额
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
			order_type = " and order_status in ('5','6','7','8','9','10') ";
			break;
		case 5:// 已完成
			order_type = " and order_status = '11' ";
			break;
		}
		String select = "select o.*,ifnull(mu.master_desc,u.nickname) customer_name ";
		String sqlExceptSelect = " from t_order o left join t_user u on o.order_user = u.id "
				+ "left join x_master_user mu on o.order_user = mu.user_id "
				+ "where o.order_source = '1' and o.master_id = " + master_id + " and o.order_status" + order_type;
		// 分页加载
		Page<TOrder> page_orders = dao.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		for (TOrder item : page_orders.getList()) {
			int orderId = item.getInt("id");
			// 查找订单中所拥有的商品信息
			// 不同规格的同个商品是否分开展示，如果需要还需要查询t_product_f
			List<Record> orderProducts = Db.find("select p.*,i.save_string from t_order_products op "
					+ "left join t_product p on op.product_id=p.id "
					+ "left join t_image i on p.img_id=i.id where op.order_id=? ", orderId);
			item.setOrderProducts(orderProducts);
			// 统计当前订单中
			item.setTotalProduct(orderProducts.size());
		}
		return page_orders;

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
	public TOrder findMasterTOrderByOrderId(String orderId){
		return dao.findFirst("select * from t_order where order_source = '1' and order_id=?",orderId);
	}
}