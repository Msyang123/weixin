package com.sgsl.controller;

import java.util.*;

import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.TOrder;
import com.sgsl.model.TUser;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;


/**
 *微后台回复管理
 */
public class MinSysController extends BaseController {
    protected final static Logger logger = Logger.getLogger(MinSysController.class);
    @Before(OAuth2Interceptor.class)
    public void initRepList() {
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	//存在加载不到

    	tUserSession=tUserSession.findTUserInfo(tUserSession.getInt("id"));
    	if(tUserSession.getInt("store_id")==null){
    		render(AppConst.PATH_ERROR + "/noPermission.html");
    		return;
    	}
    	if(tUserSession.getInt("store_id")==9999){
	    	List<Record> msgList=Db.find("select m.*,u.user_img_id,u.nickname from m_wxmsg m left join t_user u on m.msg_from=u.open_id where m.rep_id is null and m.is_replyed='N'");
	    	setAttr("msgList",msgList);
	    	render(AppConst.PATH_MANAGE_PC + "/client/minsys/repList.ftl");
    	}else{
    		render(AppConst.PATH_ERROR + "/noPermission.html");
    	}
        
    }
    /**
     * 微后台订单
     */
    @Before(OAuth2Interceptor.class)
    public void initMinsysOrderList(){
    	//获取到当前登录微信帐号的管理员信息
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	//存在加载不到

    	tUserSession=tUserSession.findTUserInfo(tUserSession.getInt("id"));
    	if(tUserSession.getInt("store_id")==null){
    		render(AppConst.PATH_ERROR + "/noPermission.html");
    		return;
    	}
    	if(tUserSession.getInt("store_id")>0){
    		//只查当前管理员内部的店铺订单
        	setAttr("orderList",new TOrder().getOrderByStoreId(tUserSession.getInt("store_id")));
        	render(AppConst.PATH_MANAGE_PC + "/client/minsys/orderList.ftl");
    	}else{
    		render(AppConst.PATH_ERROR + "/noPermission.html");
    	}
    }

}
