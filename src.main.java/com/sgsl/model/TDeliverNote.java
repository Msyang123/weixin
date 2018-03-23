package com.sgsl.model;

import java.util.Date;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;

/**
 * 配送单信息
 * 
 * @author yijun
 *
 */
public class TDeliverNote extends Model<TDeliverNote> {
	private static final long serialVersionUID = 1L;

	public static final TDeliverNote dao = new TDeliverNote();
	public void updateStatusByOrderId(String status,String orderId,int deliverType){
		Db.update("update t_deliver_note set deliver_status=? where order_id=? and deliver_type=? and failure_cause is null",status,orderId,deliverType);
	}
	public void updateNoteToAccept(String dadaDeliverName,String dadaDeliverPhone,String orderId){
		Db.update("update t_deliver_note set deliver_status='1',dada_deliver_name=?,dada_deliver_phone=? where order_id=? and deliver_type=1",
				dadaDeliverName,dadaDeliverPhone,orderId);
	}
	public void updateNoteToFailure(String failureCause,String cancelTime,String orderId){
		Db.update("update t_deliver_note set deliver_status='4',failure_cause=?,cancel_time=? where order_id=?",
				failureCause,cancelTime,orderId);
	}
	public TDeliverNote findByOrderId(String orderId){
		return dao.findFirst("select * from t_deliver_note where order_id=?",orderId);
	}
	/**
	 * 创建配送单
	 */
	public void saveDeliverNote(String orderId,String orderStore,int deliverType
			,String deliverStatus,String systemContent,int deliverFee){
		TDeliverNote deliverNote=new TDeliverNote();
		deliverNote.set("order_id",orderId);
		deliverNote.set("order_store",orderStore);
		deliverNote.set("create_time",DateFormatUtil.format1(new Date()));
		deliverNote.set("deliver_status",deliverStatus);
		deliverNote.set("deliver_type", deliverType);
		deliverNote.set("fee", deliverFee/100.0);
		if(StringUtil.isNotNull(systemContent)){
			deliverNote.set("system_content", systemContent);
		}
		deliverNote.save();
	}
}
