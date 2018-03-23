package com.sgsl.model;


import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

/**
 * 活动排行
 * @author yijun
 *
 */
public class MRank extends Model<MRank> {
	private static final long serialVersionUID = 1L;


    public static final MRank dao = new MRank();
    /**
     * 消费总排名 50名 第一版有趋势分析
     */
    public List<Record> feeRank(){
    	StringBuffer sql=new StringBuffer();
	    	sql.append("select t1.*,t2.rank,t2.current_total,u.phone_num,u.user_img_id from ( ");
	    	sql.append(" select @rownum:=@rownum+1 as day_rank,need_pay,order_user from ( ");
	    	sql.append(" select @rownum:=0,sum(need_pay) need_pay,order_user from t_order where createtime>= ");
	    	sql.append(" (select yxq_q from m_activity where activity_type=8 and yxbz='Y') ");
	    	sql.append(" group by order_user ");
	    	sql.append(" ) t order by need_pay desc) t1 ");
	    	sql.append(" left join m_rank t2 ");
	    	sql.append(" on t1.order_user=t2.user_id ");
	    	sql.append(" left join t_user u ");
	    	sql.append(" on t1.order_user=u.id ");
	    	sql.append(" order by day_rank asc limit 50");
    	return Db.find(sql.toString());
    }
    /**
     * 我的消费排行 第一版有趋势分析
     * @return
     */
    public Record myFeeRank(int userId){
    	StringBuffer sql=new StringBuffer();
    	sql.append("select t1.*,t2.rank,(select user_img_id from t_user where id=t1.order_user) as user_img_id from ( ");
    	sql.append(" select @rownum:=@rownum+1 as day_rank,need_pay,order_user from ( ");
    	sql.append(" select @rownum:=0,sum(need_pay) need_pay,order_user from t_order where createtime>= ");
    	sql.append(" (select yxq_q from m_activity where activity_type=8 and yxbz='Y') ");
    	sql.append(" group by order_user ");
    	sql.append(" ) t order by need_pay desc) t1 ");
    	sql.append(" left join m_rank t2 ");
    	sql.append(" on t1.order_user=t2.user_id ");
    	sql.append(" where t1.order_user=?");
    	Record result=Db.findFirst(sql.toString(),userId);
    	if(result==null){
    		result=Db.findFirst("select 0 as need_pay,0 as day_rank,0 as rank,user_img_id from t_user where id=?",userId);
    	}
	return result;
    }
    /**
     * 消费总排名 10名
     */
    public List<Record> feeRankV2(){
    	StringBuffer sql=new StringBuffer();
    	sql.append("select t.*,u.phone_num,u.user_img_id from(");
    	sql.append("select sum(need_pay) need_pay,order_user from t_order ");
    	sql.append("where order_status in('3','4') and createtime>=(select yxq_q from m_activity where activity_type=8 and yxbz='Y') ");
    	sql.append("group by order_user) t ");
    	sql.append("left join t_user u ");
    	sql.append("on t.order_user=u.id ");
    	sql.append("order by need_pay desc limit 10");
		return Db.find(sql.toString());
    }
    /**
     * 我的消费排行
     * @return
     */
    public Record myFeeRankV2(int userId){
    	StringBuffer sql=new StringBuffer();
    	sql.append("select t1.* from(");
    	sql.append("select @rownum:=@rownum+1 as rank,t.*,u.phone_num,u.user_img_id from(");
    	sql.append("select @rownum:=0,sum(need_pay) need_pay,order_user from t_order ");
    	sql.append("where order_status in('3','4') and createtime>=(select yxq_q from m_activity where activity_type=8 and yxbz='Y') ");
    	sql.append("group by order_user order by need_pay desc) t ");
    	sql.append("left join t_user u ");
    	sql.append("on t.order_user=u.id ) t1 ");
    	sql.append("where t1.order_user=? ");
    	Record result=Db.findFirst(sql.toString(),userId);
    	if(result==null){
    		result=Db.findFirst("select '无' as rank,0 as need_pay,phone_num,user_img_id from t_user where id=?",userId);
    	}
	return result;
    }
}
