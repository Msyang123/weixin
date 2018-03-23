package com.sgsl.wechat;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jfinal.core.JFinal;
import com.sgsl.config.AppConst;
import com.sgsl.model.TUser;
//import com.xgs.model.XFruitMaster;

public class UserStoreUtil {
	public static final String DEFAULT_COOKIE_PATH = "/";

	/**
	 * 缓存用户信息
	 * 
	 * @param request
	 * @param response
	 * @param user
	 */
	public static void cache(HttpServletRequest request, HttpServletResponse response, TUser user) {
		request.getSession().setAttribute(AppConst.WEIXIN_USER, user);
		Cookie cookie = new Cookie(AppConst.WEIXIN_USER, user.getStr("open_id"));
		cookie.setPath(DEFAULT_COOKIE_PATH);
		response.addCookie(cookie);
	}

	/**
	 * 获取用户信息
	 * 
	 * @param request
	 * @return
	 */
	public static TUser get(HttpServletRequest request,HttpServletResponse response) {
		if(JFinal.me().getConstants().getDevMode()){
			return (TUser) request.getSession().getAttribute(AppConst.WEIXIN_USER);
		}
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (AppConst.WEIXIN_USER.equals(cookie.getName())) {
					// 从cookie获取open_id, session就必须有用户信息，否则重新授权
					TUser user=(TUser) request.getSession().getAttribute(AppConst.WEIXIN_USER);
					if(user == null){
						clear(request, response);
						return null;
					}else{
						return user;
					}
				}
			}
		}
		return null; //返回null时，用户需要重新走授权流程
	}
	public static TUser get(HttpServletRequest request) {
		if(JFinal.me().getConstants().getDevMode()){
			return (TUser) request.getSession().getAttribute(AppConst.WEIXIN_USER);
		}
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (AppConst.WEIXIN_USER.equals(cookie.getName())) {
					// 从cookie获取open_id, session就必须有用户信息，否则重新授权
					return (TUser) request.getSession().getAttribute(AppConst.WEIXIN_USER);
				}
			}
		}
		return null; //返回null时，用户需要重新走授权流程
	}
	
	/**
	 * 根据缓存里取用户id找到对应的鲜果师
	 * @param request
	 * @return
	 */
	/*public static XFruitMaster getFruitMaster(HttpServletRequest request){
		int user_id= get(request).getInt("id");
		return XFruitMaster.dao.findMasterByUserId(user_id);
	}*/
	/**
	 * 清空缓存用户信息
	 * 
	 * @param request
	 * @param response
	 */
	public static void clear(HttpServletRequest request, HttpServletResponse response) {
		request.getSession().removeAttribute(AppConst.WEIXIN_USER);
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (AppConst.WEIXIN_USER.equals(cookie.getName())) {
					cookie.setValue(null);
					cookie.setMaxAge(0);
					cookie.setPath(DEFAULT_COOKIE_PATH);
					response.addCookie(cookie);
				}
			}
		}
	}
}
