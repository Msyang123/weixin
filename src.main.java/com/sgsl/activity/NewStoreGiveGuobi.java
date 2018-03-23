package com.sgsl.activity;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
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

public class NewStoreGiveGuobi {
	public void giveGuobi(HttpServletRequest req){
		String id=req.getParameter("orderId");
		TUser sessionUser = UserStoreUtil.get(req);
		//紫金国际店铺送果币活动
		TBlanceRecord blanceRecordOper=new TBlanceRecord();
		TBlanceRecord result= blanceRecordOper.getRecordByOrderId(sessionUser.getInt("id"),0);//id);
		//查看订单所在的店铺 只有旗舰店才行
		TOrder order=TOrder.dao.findFirst("select * from t_order where order_id=? and order_store=?",id,"07310109");
		//查找送果币活动
		List<Record> res= Db.find("select p.* from t_balance_percent p left join m_activity m on m.id=p.activity_id where m.id=12 and m.yxbz='Y' ");
		//没有才抽奖 并且是旗舰店
		if(result==null&&order!=null&&res.size()==4){
			GiveGuobi giveGuobi=new GiveGuobi(res.get(0).getDouble("percent").toString(),
					res.get(1).getDouble("percent").toString(),
					res.get(2).getDouble("percent").toString(),
					res.get(3).getDouble("percent").toString());
			Record re=res.get(giveGuobi.get());
			double gb=giveGuobi.getBlanceByRandom(re.getDouble("min_count"),re.getDouble("max_count"));
			//加果币
			Db.update("update t_user set balance=balance+? where id=?",(int)(gb*100),sessionUser.get("id"));
		//	sessionUser.update();
			//增加加果币记录
			TBlanceRecord tBlanceRecord=new TBlanceRecord();
			tBlanceRecord.set("store_id", "07310109");
			tBlanceRecord.set("user_id", sessionUser.getInt("id"));
			tBlanceRecord.set("blance", gb*100);
			tBlanceRecord.set("ref_type", "order");
			tBlanceRecord.set("create_time", DateFormatUtil.format1(new Date()));
			tBlanceRecord.set("order_id", id);
			tBlanceRecord.save();
			req.setAttribute("bonus",gb);
		}
	}
}
