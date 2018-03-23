package com.sgsl.model;


import java.io.File;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.DateUtil;
import com.sgsl.util.PushUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.TwitterIdWorker;
import com.sgsl.wechat.WeChatUtil;
import com.sgsl.wechat.util.XNode;
import com.sgsl.wechat.util.XPathParser;

/**
 * 团购信息
 * @author yijun
 *
 */
public class MTeamBuy extends Model<MTeamBuy> {
	private static final long serialVersionUID = 1L;

	private final static Logger logger = Logger.getLogger(MTeamBuy.class);
    public static final MTeamBuy dao = new MTeamBuy();
    private TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);
    
    /**
     * 查找单个团购详情
     */
    public Record searchBeginTeamById(int teamBuyId){
    	return Db.findFirst("select b.*,(select ifnull(pf.special_price,pf.price)  from t_product_f pf where pf.id=map.product_f_id and pf.product_id=map.product_id ) real_price,"
    			+ " s.activity_price_reduce,(select s.person_count-count(*) from m_team_member mt where mt.team_buy_id=b.id and mt.is_pay in('Y','D')) as left_count from m_team_buy b"
    			+ " left join m_team_buy_scale s on b.m_team_buy_scale_id=s.id "
    			+ " left join m_activity_product map on map.id=s.activity_product_id where b.id=? ", teamBuyId);
    }
    /**
     * 查找指定商品的已经开始团购，并且未成功的团
     * @param activityProductId 团购活动关联商品中间表主键
     * @param limit 显示数量
     * @return
     */
    public List<Record> alreadyBeginTeam(int activityProductId,int limit){
    	return Db.find("select s.*,b.id as bid,b.create_time,(select u.nickname from t_user u where u.id=b.tour_user_id) as nickname,"+
    			" (select s.person_count-count(*) from m_team_member mt where mt.team_buy_id=b.id  and mt.is_pay in('Y','D')) as left_count "+
    			" from m_team_buy_scale s left join m_team_buy b "+
    			" on s.id=b.m_team_buy_scale_id "+
    			" where b.status=1 and (select count(*) from m_team_member t where t.is_pay in('Y','D') and t.team_buy_id=b.id )>0 "+
    			" and s.activity_product_id=? order by b.id limit ?",activityProductId,limit);
    }
    
    /**
     * 查找指定商品的已经开始团购，并且未成功的团 点击更多的时候加载的数据
     * @param activityProductId 团购活动关联商品中间表主键
     * @param limit 显示数量
     * @return
     */
    public List<Record> alreadyBeginTeam(int activityProductId,int limit,int exc1,int exc2){
    	return Db.find("select s.*,b.id as bid,b.create_time,(select u.nickname from t_user u where u.id=b.tour_user_id) as nickname,"+
    			" (select s.person_count-count(*) from m_team_member mt where mt.team_buy_id=b.id and mt.is_pay in('Y','D')) as left_count "+
    			" from m_team_buy_scale s left join m_team_buy b "+
    			" on s.id=b.m_team_buy_scale_id "+
    			" where b.status=1 and (select count(*) from m_team_member t where t.is_pay in('Y','D') and t.team_buy_id=b.id )>0 "+
    			" and s.activity_product_id=? and b.id!=? and b.id!=?  order by b.id limit ?",activityProductId,exc1,exc2,limit);
    }
    /**
     * 查找所有已经开团并且成功支付并且未成功的团，用于超时处理
     * @return
     */
    public List<MTeamBuy> alreadBeginTeam(){
    	return dao.find("select m.* from m_team_buy m left join m_team_buy_scale bs on "+
					"m.m_team_buy_scale_id=bs.id  "+
					"left join m_activity_product ap "+
					"on bs.activity_product_id=ap.id "+
					"where m.status=1 and ap.activity_id in (select id from m_activity where activity_type=10)");
    }
    /**
     * 团购详细介绍
     * @param teamBuyId
     * @return
     */
    public Record teamProductDetial(int teamBuyId){
    	return Db.findFirst("select tbs.*,map.up_time,map.down_time,map.activity_id,map.product_id,map.product_f_id,p.product_name,(select save_string from t_image t where t.id=p.img_id) as save_string, "+ 
		 "pf.product_amount,pf.standard,ifnull(pf.special_price,pf.price) as real_price, "+
		 "(select unit_name from t_unit where unit_code=p.base_unit) as unit_name,  "+
		 "(select count(*) from m_team_member m where m.team_buy_id=b.id and m.is_pay in('Y','D')) as total  "+
		 "from m_team_buy b left join m_team_buy_scale tbs on b.m_team_buy_scale_id=tbs.id left join m_activity_product map on tbs.activity_product_id=map.id  "+
		 "left join t_product p on map.product_id=p.id  "+
		 "left join t_product_f pf on map.product_id=pf.product_id and map.product_f_id=pf.id where b.id=?",teamBuyId);
    }
    /**
     * 团购详细介绍
     * @param teamBuyId
     * @return
     */
    public Record teamProductDetialBuyProId(int activityProductId){
    	return Db.findFirst("select activity_product_id,up_time,down_time,product_id,product_f_id,product_name,product_detail,save_string,product_amount,standard,real_price,unit_name,base_unit_name,sum(total) as total  "+
    	"from (select tbs.*,map.product_id,map.up_time,map.down_time,map.product_f_id,p.product_name,p.product_detail,(select save_string from t_image t where t.id=p.img_id) as save_string, "+ 
		"pf.product_amount,pf.standard,ifnull(pf.special_price,pf.price) as real_price,  "+
		"(select unit_name from t_unit where unit_code=pf.product_unit) as unit_name,  "+
		"(select unit_name from t_unit where unit_code=p.base_unit) as base_unit_name, "+
		"(select count(*) from m_team_member m where m.team_buy_id=b.id and m.is_pay in('Y','D')) as total   "+
		" from  m_team_buy_scale tbs left join m_team_buy b on tbs.id=b.m_team_buy_scale_id left join m_activity_product map on tbs.activity_product_id=map.id  "+ 
		" left join t_product p on map.product_id=p.id   "+
		" left join t_product_f pf on map.product_id=pf.product_id and map.product_f_id=pf.id where tbs.activity_product_id=? "+
    	") t group by activity_product_id,product_id,product_f_id,product_name,product_detail,save_string,product_amount,standard,real_price,unit_name,base_unit_name",activityProductId);
    }
    /**
     * 团购活动首页团购商品列表
     * @param activityId
     * @return
     */
    public List<Record> teamDetial(int activityId){
    			
    	return Db.find("select dis_order1,unit_name,base_unitname,min(activity_price_reduce) as min_price_reduce,activity_product_id,product_name,save_string,product_amount,standard,real_price,sum(total) as total from ( "+
				" select map.`status` as zt, c.unit_name,u.unit_name as base_unitname,tbs.*,p.product_name,(select save_string from t_image t where t.id=p.img_id) as save_string,  "+
				" pf.product_amount,pf.standard,ifnull(pf.special_price,pf.price) as real_price,map.dis_order as dis_order1, "+
				" (select count(*) from m_team_member m left join m_team_buy t on m.team_buy_id=t.id where t.m_team_buy_scale_id=tbs.id and m.is_pay in('Y','D')) as total  "+
				" from m_team_buy_scale tbs left join m_activity_product map on tbs.activity_product_id=map.id  "+
				" left join t_product p on map.product_id=p.id  "+
				" left join t_product_f pf on map.product_id=pf.product_id and map.product_f_id=pf.id "+
				" left join t_unit c on pf.product_unit=c.unit_code "+
        		" left join t_unit u on p.base_unit=u.unit_code "+
				"where map.activity_id=? and map.`status` in(0) "+
				" ) t1 group by unit_name,base_unitname,activity_product_id,product_name,save_string,product_amount,standard,real_price,dis_order1 order by dis_order1",activityId);
    }
    
    /**
     * 开团
     */
    public MTeamMember createTeamBuy(boolean isUpdate,String isPay,
    		String orderStore,String deliverytype,String deliverytime,
    		String receiverName,String receiverMobile,String addressDetail,
    		int userId,int teamBuyScaleId,int delivery_fee,double lat ,double lng){
    	
    	String currentDate=DateFormatUtil.format1(new Date());
    	//保存开团记录
    	MTeamBuy teamBuy=new MTeamBuy();
    	teamBuy.set("tour_user_id", userId);
    	teamBuy.set("create_time",currentDate);
    	teamBuy.set("m_team_buy_scale_id", teamBuyScaleId);
    	teamBuy.set("status",1);
    	teamBuy.save();
    	//也是团成员
    	return new MTeamMember().joinTeamBuy(isUpdate,isPay,orderStore,deliverytype,
    										deliverytime,receiverName,
							    			receiverMobile,addressDetail,userId, teamBuy.getInt("id"),
							    			orderNoGenerator.nextId(),teamBuyScaleId,delivery_fee,lat,lng);
    }
    /**
     * 取消团购 退款
     * @param teamBuyId
     * @param apiclientCertPath 证书路径
     *getRequest().getSession().getServletContext().getRealPath("/WEB-INF/classes/apiclient_cert.p12")
     * @throws Exception 
     */
    public void cancelTeamBuy(int teamBuyId,String apiclientCertPath) throws Exception{
    	//Map<String,Object> jsonResult=new HashMap<String,Object>();
    	
    	MTeamBuy teamBuyOper=new MTeamBuy();
    	MTeamBuy teamBuyResult= teamBuyOper.findById(teamBuyId);
    	if(teamBuyResult==null)
    		return;
    	MTeamBuyScale teamBuyScale=MTeamBuyScale.dao.findById(teamBuyResult.getInt("m_team_buy_scale_id"));
    	MActivityProduct activityProduct=MActivityProduct.dao.findById(teamBuyScale.getInt("activity_product_id"));
    	TProduct product=TProduct.dao.findById(activityProduct.getInt("product_id"));
    	//判定当期时间大于创建时间+24小时并且还是拼团中 就取消拼团并且退款
    	Date createTime = DateUtil.convertString2Date(teamBuyResult.getStr("create_time"));
    	if(System.currentTimeMillis()>(createTime.getTime()+24*60*60*1000)&&teamBuyResult.getInt("status")==1){
    	//设置成取消团购
    		teamBuyResult.set("status", 3);
    		teamBuyResult.update();
    		//查找到所有已经支付的团员
    		List<MTeamMember> members= new MTeamMember().getTeamMembers(teamBuyId);
    		TPayLog payLogOper=new TPayLog();
    		String current= DateFormatUtil.format1(new Date());
    		for(MTeamMember member:members){
    			TPayLog pay=payLogOper.findTPayLogByOrderId(member.getStr("order_id"));
	    		//余额支付订单，直接转成用户余额
	    		if(("t_user".equals(pay.getStr("source_table"))&&"balance".equals(pay.getStr("source_type"))&&
	    					StringUtil.isNotNull(pay.getStr("out_trade_no"))&&pay.getStr("out_trade_no").length()==18)){
	    			//修改订单为已退款 现在不修改支付状态，发送订单的时候先检查拼团状态为1的才进行发货
	    			/*member.set("is_pay", "N");
	    			member.update();*/
	    			TBlanceRecord blanceRecord= new TBlanceRecord().getRecordByOrderId(
	    					member.getInt("team_user_id"),
	    					pay.getStr("out_trade_no"));
	    			//查找到当期用户没有此次退款鲜果币日志记录
	    			if(blanceRecord==null){
		    			//加果币
		    			Db.update("update t_user set balance=balance+? where id=?",
		    					pay.getInt("total_fee"),
		    					member.getInt("team_user_id"));
		    			//增加加果币记录
		    			TBlanceRecord tBlanceRecord=new TBlanceRecord();
		    			tBlanceRecord.set("store_id", pay.getStr("order_store"));
		    			tBlanceRecord.set("user_id", member.getInt("team_user_id"));
		    			tBlanceRecord.set("blance", pay.getInt("total_fee"));
		    			tBlanceRecord.set("ref_type", "teamBuyBack");
		    			tBlanceRecord.set("create_time",current);
		    			tBlanceRecord.set("order_id",pay.getStr("out_trade_no"));
		    			tBlanceRecord.save();
		    			logger.info("团购退款-余额支付订单，直接转成用户"+member.getInt("team_user_id")+"余额:"+pay.getInt("total_fee"));
		    			/*jsonResult.put("success", true);
	    				jsonResult.put("message", "团购退款订单成功，直接退款到用户鲜果币");*/
	    			}	
	    		}else{
	    			//直接支付订单
	    			String result=WeChatUtil.refund(pay.getStr("out_trade_no"),pay.getInt("total_fee"),
	    					new File(apiclientCertPath));
	    			logger.info("团购退款-直接支付订单result:"+result);
	    			//退款日志记录
	    			XPathParser xpath=new XPathParser(result);
    				XNode refund_fee = xpath.evalNode("//refund_fee");
    				XNode transaction_id = xpath.evalNode("//transaction_id");
    				TRefundLog refundLog = new TRefundLog();
    				refundLog.set("user_id", member.getInt("team_user_id"));
    				refundLog.set("refund_fee", refund_fee.body());
    				refundLog.set("transaction_no", transaction_id.body());
    				refundLog.set("refund_time", DateFormatUtil.format1(new Date()));
    				refundLog.set("order_id",member.getStr("order_id"));
    				refundLog.save();
	    			/*if(result.indexOf("SUCCESS")!=-1){
	    				jsonResult.put("success", true);
	    				jsonResult.put("message", "团购退款订单成功，直接支付已经申请微信退款");
	    			}else{
	    				jsonResult.put("success", false);
	    				jsonResult.put("message", "团购退款直接支付订单申请微信退款失败");
	    			}*/
	    		}
	    		//发送拼团失败信息到手机
	    		PushUtil.sendFaildMsgToTeamUser(TUser.dao.findById(member.getInt("team_user_id")).getStr("phone_num"),
	    				teamBuyScale.getInt("person_count").toString(),product.getStr("product_name"));
    		}
    	}
    	
    }
    /**
     * 今天此规模开团数
     * @param teamBuyScaleId
     * @return
     */
    public long todayBeginTour(int teamBuyScaleId){
    	String currentDate=DateFormatUtil.format5(new Date());
    	return Db.findFirst("select count(*) as c from m_team_buy tb where tb.m_team_buy_scale_id=? and tb.create_time between ? and ?",
    	teamBuyScaleId,currentDate+" 00:00:00",currentDate+" 23:59:59").getLong("c");
    }
    
    /**
     * 开团总数
     * @return
     */
    public long beginTourNum(String createBeginTime,String createEndTime){
    	String sql="select count(*) as c from m_team_buy ";
    	if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
			sql+="where create_time between '"+createBeginTime+"' and '"+createEndTime+"' ";
		}
    	return Db.findFirst(sql).getLong("c");
    }
    
    /**
     * 成团总数
     * @return
     */
    public long successTourNum(String createBeginTime,String createEndTime){
    	String sql="select count(*) as c from m_team_buy where status in(2) ";
    	if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
			sql+="and create_time between '"+createBeginTime+"' and '"+createEndTime+"' ";
		}
    	return Db.findFirst(sql).getLong("c");
    }
    
    /**
     * 成功订单总数
     * @return
     */
    public BigDecimal successOrderTotalNum(String createBeginTime,String createEndTime){
    	String sql="select SUM(t5.xl) as total from (";
			sql+= "select t4.product_name,count(t1.id) as xl  from ";
			sql+= "( select * from t_order  where order_id in(select order_id from m_team_member where is_pay='Y') ";
			sql+= "and order_status in('3','4','5','11')) t1 ";
			sql+= "left join t_order_products t2 on t1.id=t2.order_id ";
			sql+= "left join t_product_f t3 on t2.product_f_id=t3.id ";
			sql+= "left join t_product t4 on t3.product_id=t4.id ";
			sql+= "where t2.is_back='N' ";
			if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
				sql+="and t1.createtime between '"+createBeginTime+"' and '"+createEndTime+"' ";
			}
			sql+= "group by t4.product_name ) t5 ";
    	return Db.findFirst(sql).getBigDecimal("total");
    }
    
    /**
     * 销售额统计
     * @return
     */
    public BigDecimal totalNum(String createBeginTime,String createEndTime){
    	String sql="select SUM(t1.need_pay) as total from (";
			sql+= "select * from t_order  where order_id in(";
			sql+= "select order_id from m_team_member where is_pay='Y') and ";
			sql+= "order_status in('3','4','5','11')";
			sql+= ") t1 left join t_order_products t2 on t1.id=t2.order_id ";
			sql+= "left join t_product_f t3 on t2.product_f_id=t3.id ";
			sql+= "left join t_product t4 on t3.product_id=t4.id ";
    		sql+= "where t2.is_back='N' ";
    		if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
				sql+="and t1.createtime between '"+createBeginTime+"' and '"+createEndTime+"' ";
			}
    	return Db.findFirst(sql).getBigDecimal("total");
    }
    
    /**
     * 商品销量排行TOP5（订单数仅统计成功订单数，不包括退货订单）
     * @return
     */
    public List<Record> productOrderCount(String createBeginTime,String createEndTime){
    	String sql="select t4.product_name,count(t1.id) as xl  from ";
    		sql+="( select * from t_order  where order_id in(select order_id from m_team_member where is_pay='Y') ";
    		sql+="and order_status in('3','4','5','11')) t1 ";
    		sql+="left join t_order_products t2 on t1.id=t2.order_id ";
    		sql+="left join t_product_f t3 on t2.product_f_id=t3.id ";
    		sql+="left join t_product t4 on t3.product_id=t4.id ";
    		sql+="where t2.is_back='N' ";
			if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
				sql+="and t1.createtime between '"+createBeginTime+"' and '"+createEndTime+"' ";
			}
    		sql+="group by t4.product_name order by xl desc  limit 5; ";
    	return Db.find(sql);
    }
    
    /**
     * 团购商品统计
     * @param activity_product_id
     * @param createBeginTime
     * @param createEndTime
     * @return
     */
    public List<Record> proSaltCount(int activity_product_id,String createBeginTime,String createEndTime){
    	String sql="select tbs.id,tbs.person_count,";
    			sql+= "(select count(*) from m_team_member tm left join m_team_buy tb on tm.team_buy_id=tb.id ";
				sql+= "where tb.m_team_buy_scale_id=tbs.id)as attendNum,";
				sql+= "(select count(*) from m_team_buy where status in(1,2,3) and m_team_buy_scale_id in(tbs.id))as teamNum,";
				sql+= "(select count(*) from m_team_buy where status=2 and m_team_buy_scale_id in(tbs.id))as successNum, ";
				sql+= "(select count(*) from m_team_buy where status=3 and m_team_buy_scale_id in(tbs.id))as failureNum,";
				sql+= "(select count(*) from m_team_buy where status=1 and m_team_buy_scale_id in(tbs.id))as teamingNum,";
				sql+= "(select count(*) from m_team_member tm left join m_team_buy tb on tm.team_buy_id=tb.id ";
				sql+= "where tb.m_team_buy_scale_id=tbs.id and tm.is_pay='Y')as orders,";
				sql+="(select format(IFNULL(sum(t2.need_pay/100.0),0),2)as totalMoney ";
				sql+="from m_team_member t ";
				sql+="left join m_team_buy t1 on t.team_buy_id=t1.id ";
				sql+="left join t_order t2 on t.order_id=t2.order_id ";
				sql+="where t1.m_team_buy_scale_id=tbs.id and t.is_pay='Y')as totalMoney ";
				sql+="from m_activity_product ap ";
				sql+="left join m_team_buy_scale tbs on ap.id=tbs.activity_product_id ";
				sql+="where tbs.activity_product_id=? ";
    		   if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
    	        	sql+="and '"+createBeginTime+"' >=ap.up_time and '"+createBeginTime+"'<=ap.down_time "
    	    			+ "and '"+createEndTime+"' >=ap.up_time and '"+createEndTime+"'<=ap.down_time  ";
    	        }
    	return Db.find(sql,activity_product_id);
    }
}
