package com.sgsl.model;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Model;

/**
 * 首页设置
 * @author yijun
 *
 */
public class TIndexSetting extends Model<TIndexSetting> {
	private static final long serialVersionUID = 1L;


    public static final TIndexSetting dao = new TIndexSetting();
    
    public Map<String,String> getIndexSettingMap(){
    	List<TIndexSetting> result=dao.find("select * from t_index_setting");
    	Map<String,String> resultMap=new HashMap<String, String>();
    	for(TIndexSetting item:result){
    		resultMap.put(item.getStr("index_name"), item.getStr("index_value"));
    	}
    	return resultMap;
    }
}
