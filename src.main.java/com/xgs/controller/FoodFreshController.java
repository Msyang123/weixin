package com.xgs.controller;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Page;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.xgs.model.XArticle;
import com.xgs.model.XFruitMaster;

public class FoodFreshController extends BaseController {

	/**
	 * 食鲜模块
	 */
	@Before(OAuth2Interceptor.class)
	public void foodFresh() {

		String categroy_name;
		int type = getParaToInt("type");
		if (type == 1) {
			categroy_name = "营养菜单";
		} else if (type == 2) {
			categroy_name = "食鲜常识";
		} else {
			categroy_name = "经验分享";
		}

		int pageNum = getParaToInt("pageNumber");
		int pageSize = getParaToInt("pageSize");
		JSONObject resultJson = new JSONObject();
		// 设置分享所需参数
		FoodFreshController.setShareParams(getRequest(), resultJson);

		Page<XArticle> xArticles = XArticle.dao.findArticlesByCategoryId(categroy_name, pageSize, pageNum);
		JSONArray articleArr = ObjectToJson.modelListConvert(xArticles.getList());
		resultJson.put("articleList", articleArr);
		// 种类
		resultJson.put("type", type);
		setAttr("xactiles", JSONObject.toJSONString(resultJson));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/foodFresh.ftl");
	}

	/**
	 * 食鲜模块
	 */
	public void foodFreshAjax() {
		String categroy_name;
		int type = getParaToInt("type");
		if (type == 1) {
			categroy_name = "营养菜单";
		} else if (type == 2) {
			categroy_name = "食鲜常识";
		} else {
			categroy_name = "经验分享";
		}
		int pageNum = getParaToInt("pageNumber");
		int pageSize = getParaToInt("pageSize");
		JSONObject resultJson = new JSONObject();
		// 分页查询文章
		Page<XArticle> xArticles = XArticle.dao.findArticlesByCategoryId(categroy_name, pageSize, pageNum);
		JSONArray articleArr = ObjectToJson.modelListConvert(xArticles.getList());
		resultJson.put("articleList", articleArr);
		// 种类
		resultJson.put("type", type);
		setAttr("xactiles", JSONObject.toJSONString(resultJson));
		renderJson(JSONObject.toJSONString(resultJson));
	}

	/**
	 * 分享食鲜模块
	 */
	@Before(OAuth2Interceptor.class)
	public void shareFoodFresh(){
		//type1   绑定鲜果师
		if(StringUtil.isNotNull(getPara("master_id"))){//master_id不为空的时候说明是鲜果师分享出来的链接，此时需要绑定一次用户
			int master_id = getParaToInt("master_id");
			TUser tUserSession = UserStoreUtil.get(getRequest());
			// 绑定鲜果师，被绑定过的不会再被绑定
			FruitMasterController.bindingMaster(tUserSession.getInt("id"), master_id);
		}
		//type2 跳转首页
		redirect(AppProps.get("app_domain") + "/foodFresh/foodFresh?type=1&pageNumber=1&pageSize=4");
	}
	
	/**
	 * 设置分享所需参数
	 * 
	 * @param request
	 * @param resultJson
	 */
	public static void setShareParams(HttpServletRequest request, JSONObject resultJson) {
		// 设置分享所需参数
		TUser user = UserStoreUtil.get(request);// 用户
		XFruitMaster master = XFruitMaster.dao.findSuccessMasterByUserId(user.getInt("id"));// 鲜果师
		if (master != null) {
			resultJson.put("share_name", master.get("master_name"));// 分享者名称
			resultJson.put("master_id", master.getInt("id"));// 设置master_id
		} else {// 不是成功鲜果师
			resultJson.put("share_name", user.get("nickname"));// 分享者名称
			resultJson.put("master_id", null);
		}
	}
}
