package com.sgsl.wechat.oauth2;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.jfinal.aop.Interceptor;
import com.jfinal.core.ActionInvocation;
import com.jfinal.core.Controller;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.wechat.UserStoreUtil;

public class OAuth2Interceptor implements Interceptor {
	protected final static Log logger = LogFactory.getLog(OAuth2Interceptor.class);
	public void intercept(ActionInvocation ai) {
		Controller ctrl = ai.getController();
		HttpServletRequest request = ctrl.getRequest();
		if(!"get".equalsIgnoreCase(request.getMethod())){//忽略非GET请求
			ai.invoke();
			return;
		}
		TUser user = UserStoreUtil.get(request);
		if(user != null){
			ai.invoke();
			return;
		}
		/*else{
			//模拟登陆用户
			//request.getSession().setAttribute(AppConst.WEIXIN_USER, new TUser().findById(12872));//13028
		}*/

		//开始鉴权
		String qStr = request.getQueryString();
		String url = request.getRequestURL() + (StringUtil.isNull(qStr) ? "" : "?" + qStr );
		ctrl.setSessionAttr("oldUrl", url);
		logger.info("OAuth2Interceptor oldUrl:"+ctrl.getSessionAttr("oldUrl"));
		ctrl.redirect("/wx_oauth2_servlet?step=1");
	}
}
