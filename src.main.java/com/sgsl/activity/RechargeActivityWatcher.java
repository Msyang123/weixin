package com.sgsl.activity;

import java.util.List;

import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.TPayLog;

//具体的主题角色 充值活动
public class RechargeActivityWatcher implements Watcher
{
	protected final static Logger logger = Logger.getLogger(RechargeActivityWatcher.class);
    @Override
    public void update(TransmitDataInte data)
    {
    	RechargeTransmitData rechargeTransmitData=(RechargeTransmitData)data;
        System.out.println(rechargeTransmitData.getUserId()+"充值了"+rechargeTransmitData.getRecharge());
        
        int give = 0;
		
		logger.info("========微信支付成功，修改用户余额=======");
		try {
			List<Record> gives = Db.find("select * from t_user_recharge_gift where on_off = '1' order by give_fee desc");
			for (Record record : gives) {
				int recharge_fee = record.getInt("recharge_fee");
				if(rechargeTransmitData.getRecharge() >= recharge_fee){
					give = record.getInt("give_fee");
					break;
				}
			}
		} catch (Exception e) {
			logger.error("========充值赠送活动异常，赠送失败。=======", e);
		}
		
		int i = Db.update("update t_user set balance =balance+ ? where id = ?",
				give, rechargeTransmitData.getUserId());
		System.out.println("额外赠送了"+give+"鲜果币");
		if(i>0){
			TPayLog payLog=new TPayLog();
			payLog.update(rechargeTransmitData.getOutTradeNo(),give);
		}
    }

}