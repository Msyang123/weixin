package com.sgsl.model;

import java.util.Date;
import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.DateUtil;
import com.sgsl.util.PushUtil;
import com.sgsl.utils.DateFormatUtil;

/**
 * 团购成员
 * 
 * @author yijun
 *
 */
public class MTeamMember extends Model<MTeamMember> {
	private static final long serialVersionUID = 1L;

	private final static Logger logger = Logger.getLogger(MTeamMember.class);
	public static final MTeamMember dao = new MTeamMember();

	/**
	 * 查找我参与的团
	 * 
	 * @param userId
	 * @return
	 */
	public List<Record> myJoinTeamList(int userId, int activityId) {
		return Db.find(
				"select m.*,s.person_count,b.id as bid,b.status,b.create_time,p.product_name,"
						+ "(select nickname from t_user where id=b.tour_user_id) as nickname,"
						+ "(select s.person_count-count(*) from m_team_member mt where mt.team_buy_id=b.id and mt.is_pay in('Y','D')) as left_count "
						+ "from m_team_member m " + "left join m_team_buy b on m.team_buy_id=b.id "
						+ "left join m_team_buy_scale s on b.m_team_buy_scale_id=s.id "
						+ "left join m_activity_product ap on s.activity_product_id=ap.id "
						+ "left join t_product p on ap.product_id=p.id "
						+ "where m.team_user_id=? and ap.activity_id=? and m.is_pay in('Y','D') order by m.id desc",
				userId, activityId);
	}

	/**
	 * 根据团编号查找我参与的团
	 * 
	 * @param userId
	 * @param teamBuyId
	 * @return
	 */
	public MTeamMember myJoinTeam(int userId, int teamBuyId) {
		return dao.findFirst(
				"select * from m_team_member where team_user_id=? and team_buy_id=? and is_pay in('Y','D')", userId,
				teamBuyId);
	}

	/**
	 * 根据团规模编号查找我当天参与的团 用户现在用户参团次数
	 * 
	 * @param userId
	 * @param teamBuyScaleId
	 * @return
	 */
	public long todayMyJoinTimes(int userId, int teamBuyScaleId) {
		String currentDate = DateFormatUtil.format5(new Date());
		Record totayJoinTimes = Db.findFirst(
				"select count(*) as c from m_team_member tm left join m_team_buy tb on tm.team_buy_id=tb.id"
						+ " where team_user_id=? and m_team_buy_scale_id=? and is_pay in('Y','D') and join_time between ? and ?",
				userId, teamBuyScaleId, currentDate + " 00:00:00", currentDate + " 23:59:59");
		return totayJoinTimes.getLong("c");
	}

	/**
	 * 根据团编号查找我已经参与的团，已支付状态
	 * 
	 * @param userId
	 * @param teamBuyId
	 * @return
	 */
	public MTeamMember myAlreadyJoinTeam(int userId, int teamBuyId) {
		return dao.findFirst("select * from m_team_member where team_user_id=? and team_buy_id=? and is_pay ='Y'",
				userId, teamBuyId);
	}

	/**
	 * 查看拼团是否已满
	 * 
	 * @return
	 */
	public boolean isFull(int teamBuyId) {
		MTeamBuy teamBuy = MTeamBuy.dao.findById(teamBuyId);
		// 团购规模
		MTeamBuyScale teamBuyScale = MTeamBuyScale.dao.findById(teamBuy.getInt("m_team_buy_scale_id"));
		// 团购人数大于等于总人数
		return dao.find("select * from m_team_member where team_buy_id=? and is_pay in('Y','D')", teamBuyId)
				.size() >= teamBuyScale.getInt("person_count");
	}

	/**
	 * 检查是否允许支付团购订单
	 * 
	 * @param userId
	 * @param teamBuyId
	 * @return
	 */
	public boolean payCheckIsFull(int userId, int teamBuyId) {
		MTeamBuy teamBuy = MTeamBuy.dao.findById(teamBuyId);
		// 团购规模
		MTeamBuyScale teamBuyScale = MTeamBuyScale.dao.findById(teamBuy.getInt("m_team_buy_scale_id"));
		// 如果当前用户有带支付的记录，那么就允许支付
		if (dao.find("select * from m_team_member where team_buy_id=? and is_pay ='D' and team_user_id=?", teamBuyId,
				userId).size() == 1) {
			return false;
		}
		// 团购人数大于等于总人数
		return dao.find("select * from m_team_member where team_buy_id=? and is_pay in('Y','D')", teamBuyId)
				.size() >= teamBuyScale.getInt("person_count");
	}

	/**
	 * 我待加入的团
	 * 
	 * @param userId
	 * @param teamBuyId
	 * @return
	 */
	public MTeamMember myBeginJoinTeam(int userId, int teamBuyId) {
		return dao.findFirst("select * from m_team_member where team_user_id=? and team_buy_id=?", userId, teamBuyId);
	}

	/**
	 * 根据订单编号查找我加入的团
	 * 
	 * @param userId
	 * @param orderId
	 * @return
	 */
	public MTeamMember getMyJoinTeamBuyOrderId(int userId, String orderId) {
		return dao.findFirst("select * from m_team_member where team_user_id=? and order_id=?", userId, orderId);
	}

	/**
	 * 指定团内成员信息 只有支付成功的才算,用于界面显示
	 * 
	 * @param teamBuyId
	 * @return
	 */
	public List<Record> personInTeam(int teamBuyId) {
		return Db.find("select m.*,t.user_img_id,b.tour_user_id "
				+ "from m_team_buy b left join m_team_member m  on b.id=m.team_buy_id left join t_user t "
				+ "on m.team_user_id=t.id where b.id=? and m.is_pay in('Y','D')", teamBuyId);
	}

	/**
	 * 指定团内成员信息 只有支付成功的才算,用于内部查询
	 * 
	 * @param teamBuyId
	 * @return
	 */
	public List<MTeamMember> getTeamMembers(int teamBuyId) {
		return dao.find("select m.* " + " from  m_team_member m " + " where m.team_buy_id=? and m.is_pay='Y'",
				teamBuyId);
	}

	/**
	 * 参团 刚好满员就为拼团成功
	 * 
	 * @param isUpdate
	 *            是否更新 此项判定为微信异步支付还是鲜果币同步支付
	 * @param userId
	 * @param teamBuyScaleId
	 */
	public MTeamMember joinTeamBuy(boolean isUpdate, String isPay, String orderStore, String deliverytype,
			String deliverytime, String receiverName, String receiverMobile, String addressDetail, int userId,
			int teamBuyId, String orderId, int teamBuyScaleId, int delivery_fee,double lat,double lng) {
		String currentDate = DateFormatUtil.format1(new Date());
		// 也是团成员
		MTeamMember member = new MTeamMember();
		if (isUpdate) {
			// 根据订单编号查询我参加的这个团
			member = getMyJoinTeamBuyOrderId(userId, orderId);
			// 更新为支付完成
			member.set("is_pay", isPay);
/*			member.set("delivery_fee", delivery_fee);
			member.set("lat", lat);
			member.set("lng", lng);*/
			member.update();
		} else {

			member.set("team_buy_id", teamBuyId);
			member.set("team_user_id", userId);
			member.set("join_time", currentDate);
			member.set("order_id", orderId);
			member.set("is_pay", isPay);
			member.set("order_store", orderStore);
			member.set("deliverytype", deliverytype);
			member.set("deliverytime", deliverytime);
			member.set("receiver_name", receiverName);
			member.set("receiver_mobile", receiverMobile);
			member.set("address_detail", addressDetail);
			member.set("delivery_fee", delivery_fee);
			member.set("lat", lat);
			member.set("lng", lng);
			member.save();
		}
		// 查看团购规模表
		MTeamBuyScale buyScale = MTeamBuyScale.dao.findById(teamBuyScaleId);
		List<MTeamMember> teamMembers = getTeamMembers(teamBuyId);
		// 设置为拼团成功
		MTeamBuy teamBuy = MTeamBuy.dao.findById(teamBuyId);
		// 人齐了并且没有设置拼团成功
		if (teamMembers.size() == buyScale.getInt("person_count") && teamBuy.getInt("status") == 1) {
			TProductF prodectF = new MTeamBuyScale().getTeamBuyProduct(buyScale.getInt("id"));
			// 构造订单及订单商品
			int totalPrice = prodectF.get("special_price") == null ? prodectF.getInt("price")
					: prodectF.getInt("special_price");
			int needPay = buyScale.getInt("activity_price_reduce");

			teamBuy.set("status", 2);
			teamBuy.update();
			// 给所有成员发送订单
			for (MTeamMember item : teamMembers) {
				TOrder order = new TOrder();
				TUser target = new TUser().findById(item.getInt("team_user_id"));
				order.set("order_id", item.getStr("order_id"));
				order.set("order_user", item.getInt("team_user_id"));
				order.set("order_type", "1");
				order.set("order_store", item.getStr("order_store"));
				order.set("total", totalPrice);
				order.set("createtime", currentDate);
				order.set("deliverytype", item.getStr("deliverytype"));
				order.set("deliverytime", item.getStr("deliverytime"));
				order.set("order_status", "3");// 已付款
				order.set("discount", totalPrice - buyScale.getInt("activity_price_reduce"));
				order.set("need_pay", needPay);
				order.set("lat", item.getDouble("lat"));
				order.set("lng", item.getDouble("lng"));
				order.set("order_style", 1);
				// 送货上门
				if ("2".equals(item.getStr("deliverytype"))) {
					order.set("receiver_name", item.getStr("receiver_name"));
					order.set("receiver_mobile", item.getStr("receiver_mobile"));
					order.set("address_detail", item.getStr("address_detail"));
					order.set("delivery_fee", delivery_fee);
				} else {
					// 门店自提 取用户信息中的手机号
					order.set("receiver_name", target.getStr("nickname"));
					order.set("receiver_mobile", target.getStr("phone_num"));
					order.set("address_detail", "");// 自提不需要填写送货地址
				}

				order.set("pay_time", currentDate);
				order.set("hd_status", "1");// 海鼎状态为失败，这样的话就会定时调用发送订单
				order.save();
				TOrderProducts orderProduct = new TOrderProducts();
				orderProduct.set("product_id", prodectF.getInt("product_id"));
				orderProduct.set("amount", 1);// 所有的都是一份
				orderProduct.set("order_id", order.getInt("id"));
				orderProduct.set("unit_price", needPay);
				orderProduct.set("buy_time", currentDate);
				orderProduct.set("product_f_id", prodectF.getInt("id"));
				orderProduct.set("is_back", "N");
				orderProduct.set("pay_price", needPay);
				orderProduct.save();
				TProduct pd = TProduct.dao.findById(prodectF.getInt("product_id"));
				// 发送成功拼团信息到手机
				if ("2".equals(item.getStr("deliverytype"))) {
					PushUtil.sendSuccessMsgToTeamUser(item.getStr("receiver_mobile"),
							buyScale.getInt("person_count").toString(), pd.getStr("product_name"));
				} else {
					PushUtil.sendSuccessMsgToTeamUser(target.getStr("phone_num"),
							buyScale.getInt("person_count").toString(), pd.getStr("product_name"));
				}

			}
		}
		return member;
	}

	/**
	 * 根据订单编号查找成员信息
	 * 
	 * @param orderId
	 * @return
	 */
	public MTeamMember getMTeamMemberByOrderId(String orderId) {
		return dao.findFirst("select * from m_team_member where order_id=?", orderId);
	}

	/**
	 * 将时间超过十分钟的未支付团购单都设置为无效状态
	 */
	public void cancelTeamMemberUnpay() {
		List<MTeamMember> members = dao.find("select * from m_team_member where is_pay='D' ");

		for (MTeamMember item : members) {
			Date joinTime = DateUtil.convertString2Date(item.getStr("join_time"));
			if (System.currentTimeMillis() > (joinTime.getTime() + 10 * 60 * 1000)) {
				// 团购订单超过10分钟 订单变成无效
				item.set("is_pay", "N");
				item.update();
				logger.info("团购订单超过10分钟 订单变成无效:orderId" + item.getStr("order_id"));
			}
		}
	}

	/**
	 * 根据用户和团购编号查找是待支付团购单
	 * 
	 * @param orderId
	 * @return
	 */
	public MTeamMember getDMTeamMemberByUserId(int userId, int teamBuyId) {
		return dao.findFirst("select * from m_team_member where team_buy_id=? and is_pay='D' and team_user_id=?",
				teamBuyId, userId);
	}
}
