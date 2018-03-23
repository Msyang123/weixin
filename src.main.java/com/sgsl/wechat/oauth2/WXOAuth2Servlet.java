package com.sgsl.wechat.oauth2;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.Date;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONObject;
import com.sgsl.config.AppProps;
import com.sgsl.model.TStock;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.WeChatUtil;

//wx_oauth2_servlet
public class WXOAuth2Servlet extends HttpServlet {
	private static final long serialVersionUID = 8752747609578338007L;
	protected final static Log logger = LogFactory.getLog(WXOAuth2Servlet.class);
	public static final String FILTER_EMOJI = "filterEmoji";

	private String filterEmoji;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.filterEmoji = config.getInitParameter(FILTER_EMOJI);
		if (StringUtil.isNull(this.filterEmoji)) {
			this.filterEmoji = "byte";
		}
	}

	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String step = request.getParameter("step");
		if (step.equals("1")) {
			String re_url = AppProps.get("app_domain") + "/wx_oauth2_servlet?step=2";
			String url = MessageFormat.format(WeChatUtil.OAUTH2_URL, AppProps.get("appid"), re_url, "snsapi_base");
			logger.debug("=======微信授权======step：1 " + url);
			response.sendRedirect(url);
			return;
		}
		if (step.equals("2")) {
			logger.debug("=======微信授权======step：2");
			String code = request.getParameter("code");
			JSONObject userInfo = WeChatUtil.getInfoByCode(AppProps.get("appid"), AppProps.get("app_secrect"), code);
			String openid = (String) userInfo.get("openid");
			TUser user = new TUser().findTUserByOpenId(openid);
			if (user == null) {
				logger.debug("=======数据库没有此用户，开始网页授权======");
				// 网页授权
				String re_url = AppProps.get("app_domain") + "/wx_oauth2_servlet?step=3";
				String url = MessageFormat.format(WeChatUtil.OAUTH2_URL, AppProps.get("appid"), re_url,
						"snsapi_userinfo");
				response.sendRedirect(url);
				return;
			} else {
				logger.debug("=======数据库已存在此用户，从微信刷新数据======");
				// 每次登录都刷新用户数据
				String accessToken = userInfo.getString("access_token");
				try {
					JSONObject userJson = WeChatUtil.getOauth2UserInfo(openid, accessToken);
					String access_token = (String) request.getServletContext()
							.getAttribute("_wechat_access_token_");
					if (null != userJson.get("errcode")) {
						if (access_token != null) {
							userJson = WeChatUtil.getUserInfo(openid, access_token);
							//是否关注过0未关注1已关注
							if(userJson.containsKey("subscribe")&&userJson.get("subscribe")!=null){
								int subscribe=userJson.getInteger("subscribe");
								user.set("subscribe", subscribe);
							}
						}
					}else{
						//更新用户是否关注了公众号信息
						JSONObject userInfoJson  = WeChatUtil.getUserInfo(openid, access_token);
						//是否关注过0未关注1已关注
						if(userInfoJson.containsKey("subscribe")&&userInfoJson.get("subscribe")!=null){
							int subscribe=userInfoJson.getInteger("subscribe");
							user.set("subscribe", subscribe);
						}
						
					}
					user = convert(user, userJson);
					
					
					user.update();
					logger.debug("=======更新用户数据成功======" + userJson);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
				this.createStock(user.getInt("id"));
				UserStoreUtil.cache(request, response, user);
				String oldUrl = (String) request.getSession().getAttribute("oldUrl");
				logger.info("WXOAuth2Servlet oldUrl:"+request.getSession().getAttribute("oldUrl"));
				if (oldUrl == null) {
					throw new RuntimeException("oldUrl为空!");
					//oldUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx11f30fb91a70fc89&redirect_uri=http://weixin.shuiguoshule.com.cn/weixin/wx_oauth2_servlet?step=2&response_type=code&scope=snsapi_base&state=1#wechat_redirect";
				}
				response.sendRedirect(oldUrl);// 重定向到原页面
				return;
			}
		}
		if (step.equals("3")) {
			logger.debug("=======微信授权======step：3");
			String code = request.getParameter("code");
			JSONObject userInfo = WeChatUtil.getInfoByCode(AppProps.get("appid"), AppProps.get("app_secrect"), code);
			String openId = userInfo.getString("openid");
			String accessToken = userInfo.getString("access_token");
			JSONObject userJson = WeChatUtil.getOauth2UserInfo(openId, accessToken);
			TUser user = new TUser();
			user.set("open_id", openId);
			user = convert(user, userJson);
			user.set("regist_time", DateFormatUtil.format1(new Date()));
			//查看用户是否关注了公众号信息
			String access_token = (String) request.getServletContext()
					.getAttribute("_wechat_access_token_");
			JSONObject userInfoJson  = WeChatUtil.getUserInfo(openId, access_token);
			//是否关注过0未关注1已关注
			if(userInfoJson.containsKey("subscribe")&&userInfoJson.get("subscribe")!=null){
				int subscribe=userInfoJson.getInteger("subscribe");
				user.set("subscribe", subscribe);
			}
			
			// 添加用户同时给用户分配一个仓库
			TUser existUser = new TUser().findTUserByOpenId(openId);
			String oldUrl = (String) request.getSession().getAttribute("oldUrl");
			if (existUser==null) {
				if(user.save()){
					logger.debug("=======从微信获取用户信息，并成功添加到数据库======");
					this.createStock(user.getInt("id"));
					UserStoreUtil.cache(request, response, user);
					if (oldUrl == null) {
						throw new RuntimeException("oldUrl为空!");
					}
					response.sendRedirect(oldUrl);// 重定向到原页面
				}else {
					throw new RuntimeException("oauth2授权 - 获取用户信息失败");
				}
			}else{
				//不为空就直接返回查到的用户对象
				UserStoreUtil.cache(request, response, existUser);
				response.sendRedirect(oldUrl);// 重定向到原页面
			}
		}
	}

	void createStock(Integer userId) {
		TStock stock = new TStock();
		if (stock.getStockByUser(userId) != null) {
			return;
		}
		UUID uuid = UUID.randomUUID();
		stock.set("stock_id", uuid.toString());
		stock.set("user_id", userId);
		// stock.set("gb", 0);
		stock.save();
		logger.debug("=======成功为用户创建水果仓库======");
	}

	TUser convert(TUser user, JSONObject userJson) {
		String nickname = userJson.getString("nickname");
		if (StringUtil.isNull(nickname)) {
			return user;
		}
		if ("byte".equals(this.filterEmoji)) {
			nickname = replaceByte4(nickname);
		}
		if ("regular".equals(this.filterEmoji)) {
			nickname = replaceEmoji(nickname);
		}

		if(StringUtil.isNotNull(nickname)){
			user.set("nickname", nickname);
			logger.debug("=======授权用户：" + nickname + "======");
		}
		if(StringUtil.isNotNull(userJson.get("sex")+"")){
			user.set("sex", userJson.get("sex"));
		}
		if(StringUtil.isNotNull(userJson.get("headimgurl")+"")){
			user.set("user_img_id", userJson.get("headimgurl"));
		}
		String address = userJson.get("country") + " " + userJson.get("province") + " " + userJson.get("city");
		if(StringUtil.isNotNull(address)){
			user.set("user_address", address);
		}
		return user;
	}

	static String replaceByte4(String nickname) {
		if (StringUtil.isNull(nickname)) {
			return "";
		}
		try {
			byte[] conbyte = nickname.getBytes();
			for (int i = 0; i < conbyte.length; i++) {
				if ((conbyte[i] & 0xF8) == 0xF0) {// 如果是4字节字符
					for (int j = 0; j < 4; j++) {
						conbyte[i + j] = 0x30;// 将当前字符变为“0000”
					}
					i += 3;
				}
			}
			nickname = new String(conbyte);
			return nickname.replaceAll("0000", "");
		} catch (Throwable e) {
			logger.error(e.getMessage(), e);
			return "";
		}
	}

	static String replaceEmoji(String nickname) {
		if (StringUtil.isNull(nickname)) {
			return "";
		}
		try {
			Pattern emoji = Pattern.compile("[\ud83c\udc00-\ud83c\udfff]|[\ud83d\udc00-\ud83d\udfff]|[\u2600-\u27ff]",
					Pattern.UNICODE_CASE | Pattern.CASE_INSENSITIVE);
			Matcher emojiMatcher = emoji.matcher(nickname);
			if (emojiMatcher.find()) {
				String temp = nickname.substring(emojiMatcher.start(), emojiMatcher.end());
				nickname = nickname.replaceAll(temp, "");
			}
			return nickname;
		} catch (Throwable e) {
			logger.error(e.getMessage(), e);
			return "";
		}
	}
}
