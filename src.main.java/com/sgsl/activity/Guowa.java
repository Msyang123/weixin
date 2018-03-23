package com.sgsl.activity;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.config.AppConst;
import com.sgsl.model.AFuwa;
import com.sgsl.model.AFwGet;
import com.sgsl.model.AUserFw;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPresent;
import com.sgsl.model.TUser;
import com.sgsl.util.GiveFuwa;
import com.sgsl.util.GiveGuobi;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.UserStoreUtil;

public class Guowa {
	public void guowa(HttpServletRequest req){
		TUser sessionUser = UserStoreUtil.get(req);
		int activity_id=8;
		//支付成功之后福娃获取抽取
		AFuwa aFuwaOper=new AFuwa();
		AFwGet aFwGetOper=new AFwGet();
		AUserFw aUserFwOper=new AUserFw();
		List<AUserFw> aufs= aUserFwOper.find("select * from a_user_fw where user_id=?",sessionUser.getInt("id"));
		//没有的话自动添加四条记录放用户福娃表中
		if(aufs.size()==0){
			List<AFuwa> aFws= aFuwaOper.find("select * from a_fuwa where activity_id=? and yxbz='Y'",activity_id);
			for(AFuwa af:aFws){
				AUserFw auf=new AUserFw();
				auf.set("fw_id", af.getInt("id"));
				auf.set("user_id", sessionUser.getInt("id"));
				auf.set("fw_count", 0);
				auf.save();
				//添加到内存列表中
				aufs.add(auf);
			}
		}
		String id=req.getParameter("orderId");
		String type = req.getParameter("type");
		AFwGet aFwGet = aFwGetOper.findFirst("select * from a_fw_get where user_id=? and order_id=?",sessionUser.get("id"),id);
		List<Record> afs= Db.find("select a.*,i.save_string from a_fuwa a "
				+ " left join t_image i on a.img_id=i.id"
				+ " left join m_activity m on m.id=a.activity_id where a.activity_id=3 and m.yxbz='Y' ");
		if(aFwGet==null&&afs.size()==4){
			GiveFuwa sg= null;
			//是否赠送
			String sizs="0";
			//赠送类型
			boolean flag = false;
			if(StringUtil.isNotNull(req.getParameter("type"))&&"zs".equals(type)){//如果是赠送
				TPresent tPresent = TPresent.dao.findFirst("select * from t_present where id=? and need_pay>=2017",id);
				if(tPresent!=null){
					sg= new GiveFuwa(afs.get(0).getDouble("probabilityzs").toString(), 
						     afs.get(1).getDouble("probabilityzs").toString(), 
						     afs.get(2).getDouble("probabilityzs").toString(),
						     afs.get(3).getDouble("probabilityzs").toString());
					flag = true;
				}
				sizs="1";
			}else{
				TOrder order=TOrder.dao.findFirst("select * from t_order where order_id=? and need_pay>=2017",id);
				if(order!=null){
					 sg= new GiveFuwa(afs.get(0).getDouble("probability").toString(), 
						     afs.get(1).getDouble("probability").toString(), 
						     afs.get(2).getDouble("probability").toString(),
						     afs.get(3).getDouble("probability").toString());
					 flag = true;
				}
				
			}
			if(flag){
				//抽奖福娃
				Record aFuwa=afs.get(sg.get());
				aFwGet=new AFwGet();
				aFwGet.set("fw_id", aFuwa.getInt("id"));
				aFwGet.set("get_time",DateFormatUtil.format1(new Date()));
				aFwGet.set("user_id",sessionUser.getInt("id"));
				aFwGet.set("is_vaild","0");
				aFwGet.set("order_id",req.getParameter("orderId"));
				aFwGet.set("is_zs", sizs);
				//保存抽奖记录
				aFwGet.save();
				for(AUserFw au:aufs){
					if(au.getInt("fw_id")==aFuwa.getInt("id")){
						//累加抽到的福娃
						au.set("fw_count", au.getInt("fw_count")+1);
						au.update();
						break;
					}
				}
				req.setAttribute("aFuwa", aFuwa);
			}
			
		}else{
			req.setAttribute("aFuwa", aFwGet);
		}
		
		
		//没有抽过才抽 并且订单金额超过20.17
		
		
	}
	
	public void fuwaSend(HttpServletRequest req) {
		TUser tUserSession = UserStoreUtil.get(req);
		AFwGet fwGet = null;//getModel(AFwGet.class, "fw_get");
		AFwGet fwGetOper = new AFwGet();

		Record record = new Record();
		//record.setColumns(model2map(fwGet));
		record.set("id", null);
		record.set("order_id", "");
		record.set("gift_send_user", tUserSession.getInt("id"));
		record.set("get_time", DateFormatUtil.format1(new Date()));
		record.set("is_vaild", 0);
		if (Db.save("a_fw_get", record)) {
			AFwGet myFwGet = fwGetOper.findFirst(
					"select * from a_fw_get where user_id=? and fw_id=? and is_vaild=0 limit 0,1 ",
					tUserSession.getInt("id"), fwGet.getInt("fw_id"));
			// 设置当前的福娃无效
			myFwGet.set("is_vaild", 1);
			myFwGet.set("user_id", tUserSession.getInt("id"));
			myFwGet.update();
			// 设置我的福娃里面总数减1
			AUserFw aUserFwOper = new AUserFw();
			AUserFw aufMe = aUserFwOper.dao.findFirst("select * from a_user_fw where user_id=? and fw_id=?",
					tUserSession.getInt("id"), fwGet.getInt("fw_id"));
			Record aufMeRecord = new Record();
			//aufMeRecord.setColumns(model2map(aufMe));
			aufMeRecord.set("fw_count", aufMe.getInt("fw_count") - 1);

			// 赠送之后就减掉
			Db.update("update a_user_fw set fw_count=fw_count-1  where user_id=? and fw_id=?",
					tUserSession.getInt("id"), fwGet.getInt("fw_id"));
			// 对方的需要添加
			AUserFw aufFriend = aUserFwOper.dao.findFirst("select * from a_user_fw where user_id=? and fw_id=?",
					fwGet.getInt("user_id"), fwGet.getInt("fw_id"));
			// 如果对方没有获取过任何福娃，就初始化
			if (aufFriend == null) {
				AFuwa aFuwaOper = new AFuwa();
				List<AFuwa> aFws = aFuwaOper.find("select * from a_fuwa where activity_id=3 ");
				for (AFuwa af : aFws) {
					AUserFw auf = new AUserFw();
					auf.set("fw_id", af.getInt("id"));
					auf.set("user_id", record.getInt("user_id"));
					// 给指定用户的指定福娃加1
					if (af.getInt("id") == fwGet.getInt("fw_id")) {
						auf.set("fw_count", 1);
					} else {
						auf.set("fw_count", 0);
					}
					auf.save();
				}
			} else {
				aufFriend.set("fw_count", aufFriend.getInt("fw_count") + 1);
				aufFriend.update();
			}
		}
		//redirect("/myFuwa");
	}
	
	
	/**
	 * 集果娃活动详情页
	 */
	public void collectGw(HttpServletRequest req) {
		Record record = Db.findFirst("select * from m_activity where id = 9");
		req.setAttribute("bonus", record.getInt("activity_money"));
		Record fwCount = Db.findFirst(
				"select sum(fw_count) as totalcount from (select min(fw_count) as fw_count from a_user_fw GROUP BY user_id) a");
		if(fwCount!=null&&fwCount.get("totalcount")!=null){
			req.setAttribute("totalCount", fwCount.get("totalcount"));
		}else{
			req.setAttribute("totalCount", 0);
		}
		Record lastUser = Db.findFirst("select b.nickname,b.phone_num from a_fw_get a " + "LEFT JOIN t_user b "
				+ "ON a.user_id = b.id " + "where user_id in "
				+ "(select user_id from a_user_fw GROUP BY user_id HAVING min(fw_count)>0) "
				+ "ORDER BY get_time desc limit 1");
		String phone_num = "";
		if(lastUser!=null){
			phone_num = lastUser.get("phone_num");
			if (phone_num != null) {
				phone_num = phone_num.substring(0, 3) + "****" + phone_num.substring(7, 11);
			}
		}
		req.setAttribute("phone_num", phone_num);
		//render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_fw.ftl");
	}
}
