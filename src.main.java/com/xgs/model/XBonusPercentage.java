package com.xgs.model;

import com.jfinal.plugin.activerecord.Model;

public class XBonusPercentage extends Model<XBonusPercentage>{
	private static final long serialVersionUID = 1L;

	public static final XBonusPercentage dao = new XBonusPercentage();
	
	/**
	 * 得到分成利润
	 */
	public XBonusPercentage findXBonusPercentage(){
		return dao.findFirst("select * from x_bonus_percentage");
	}
}
