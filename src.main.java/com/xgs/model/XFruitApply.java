package com.xgs.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;

public class XFruitApply extends Model<XFruitApply>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static final XFruitApply dao = new XFruitApply();
	   /**
	    * 鲜果师资料
	    * @param master_id
	    * @return
	    */
	public XFruitApply findXFruitApply(int master_id){
		   return dao.findFirst("select * from x_fruit_appy where master_id = ?",master_id);
	   }
	
}
