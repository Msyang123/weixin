package com.sgsl.model;


import com.jfinal.plugin.activerecord.Model;

/**
 * 充值送果币概率
 * @author yijun
 *
 */
public class TBalancePercent extends Model<TBalancePercent> {
	private static final long serialVersionUID = 1L;

    public static final TBalancePercent dao = new TBalancePercent();
    
    public TBalancePercent getRecordByPercentId(int activityId,int percentId){
    	return this.findFirst("select * from t_balance_percent where activity_id=? and percent_id=? ",activityId,percentId);
    }
}
