package com.sgsl.controller;

import java.util.HashMap;
import java.util.Map;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.IPlugin;
import com.sgsl.utils.HttpUtil;

/**
 * 初始化微信菜单
 */
public class InitMenuPlugin implements IPlugin {
	@Override
	public boolean start() {
		JSONObject menu=new JSONObject();
        JSONArray menuArr=new JSONArray();
        JSONObject base=new JSONObject();
        base.put("name", "基本信息");
  
        JSONArray baseArr=new JSONArray();
        
        JSONObject cookbook=new JSONObject();
        cookbook.put("name", "每周食谱");
        cookbook.put("type", "view");
        cookbook.put("url", "http://www.baidu.com");
        baseArr.add(cookbook);
        
        JSONObject medical=new JSONObject();
        medical.put("name", "医疗情况");
        medical.put("type", "view");
        medical.put("url", "http://www.baidu.com");
        baseArr.add(medical);
        
        JSONObject convenient=new JSONObject();
        convenient.put("name", "便民信息");
        convenient.put("type", "view");
        convenient.put("url", "http://www.baidu.com");
        baseArr.add(convenient);
        
        JSONObject busRoute=new JSONObject();
        busRoute.put("name", "乘车路线");
        busRoute.put("type", "view");
        busRoute.put("url", "http://www.baidu.com");
        baseArr.add(busRoute);
        
        JSONObject contact=new JSONObject();
        contact.put("name", "联系方式 ");
        contact.put("type", "view");
        contact.put("url", "http://www.baidu.com");
        baseArr.add(contact);
        
        base.put("sub_button", baseArr);
        
        menuArr.add(base);
        
        
        JSONObject subscribe=new JSONObject();
        subscribe.put("name", "预约");
        JSONArray subscribeArr=new JSONArray();
        
        JSONObject meet=new JSONObject();
        meet.put("name", "预约会见");
        meet.put("type", "click");
        meet.put("key", "meet");
        subscribeArr.add(meet);

        JSONObject arraignment=new JSONObject();
        arraignment.put("name", "预约提审");
        arraignment.put("type", "click");
        arraignment.put("key", "arraignment");
        subscribeArr.add(arraignment);
        
        subscribe.put("sub_button", subscribeArr);
        
        menuArr.add(subscribe);
        
        JSONObject activity=new JSONObject();
        activity.put("name", "活动通知");
        JSONArray activityArr=new JSONArray();
        
        JSONObject actNotice=new JSONObject();
        actNotice.put("name", "活动预告");
        actNotice.put("type", "view");
        actNotice.put("url", "http://www.baidu.com");
        activityArr.add(actNotice);

        JSONObject notice=new JSONObject();
        notice.put("name", "通知预告");
        notice.put("type", "view");
        notice.put("url", "http://www.baidu.com");
        activityArr.add(notice);
        
        JSONObject fate=new JSONObject();
        fate.put("name", "去向说明");
        fate.put("type", "view");
        fate.put("url", "http://www.baidu.com");
        activityArr.add(fate);
        
        activity.put("sub_button", activityArr);
        
        menuArr.add(activity);
        
        menu.put("button", menuArr);
        Map<String, String> postParams=new HashMap<String,String>();
		postParams.put("body",menu.toJSONString());
		HttpUtil.post("https://api.weixin.qq.com/cgi-bin/menu/create?access_token="+HttpUtil.getAccessToken(HttpUtil.appid,HttpUtil.secret).get("access_token"),postParams);
		return true;
	}
	@Override
	public boolean stop() {
		HttpUtil.get("https://api.weixin.qq.com/cgi-bin/menu/delete?access_token="+HttpUtil.getAccessToken(HttpUtil.appid,HttpUtil.secret).get("access_token"));
		return true;
	}

}
