package com.sgsl.config;


import com.jfinal.config.*;
import com.jfinal.ext.interceptor.SessionInViewInterceptor;
import com.jfinal.ext.plugin.config.ConfigPlugin;
import com.jfinal.ext.plugin.tablebind.AutoTableBindPlugin;
import com.jfinal.ext.plugin.tablebind.SimpleNameStyles;
import com.jfinal.kit.PathKit;
import com.jfinal.log.Log4jLoggerFactory;
import com.jfinal.plugin.druid.DruidPlugin;
import com.jfinal.render.ViewType;
import com.revocn.config.RevoConfig;
import com.revocn.interceptor.DirectiveInterceptor;
import com.revocn.util.ConfigUtil;
import com.sgsl.routes.AdminRoute;
import com.sgsl.routes.WebRoute;
import com.sgsl.task.*;
import com.sgsl.wechat.oauth2.IgnoreUrlsHandler;

/**
 * Created by Tao on 2014-07-17.
 */
public class AppConfig extends RevoConfig {
	@Override
	public void configConstant(Constants me) {
		// 载入配置文件
		ConfigUtil.loadConfig(loadPropertyFile("application.properties"));
		// ConfigUtil.loadConfig(loadPropertyFile("app_config.txt"));

		me.setDevMode(getPropertyToBoolean("devMode", true));
		me.setEncoding("UTF-8");
		me.setLoggerFactory(new Log4jLoggerFactory());

		// me.setUploadedFileSaveDirectory("");

		me.setViewType(ViewType.FREE_MARKER);
		me.setFreeMarkerViewExtension(".ftl");
		me.setFreeMarkerTemplateUpdateDelay(0); // 缓存刷新时间

		me.setError401View("/WEB-INF/pages/error/noPermission.html");
		me.setError403View("/WEB-INF/pages/error/noPermission.html");
		me.setError404View("/WEB-INF/pages/error/404.html");
		me.setError500View("/WEB-INF/pages/error/500.html");
	}

	@Override
	public void configRoute(Routes me) {
		me.add(new WebRoute());// 前端
		me.add(new AdminRoute());// 后台管理
	}

	@Override
	public void configPlugin(Plugins me) {
		
		DruidPlugin druid = new DruidPlugin(getProperty("jdbcUrl"), getProperty("user"), getProperty("password"));
		me.add(druid);

		// 自动扫描Model
		AutoTableBindPlugin atbp = new AutoTableBindPlugin(druid, SimpleNameStyles.LOWER_UNDERLINE);
		atbp.autoScan(true);
		atbp.setShowSql(true);
		atbp.addJars("framework-1.2.3.jar");

		// atbp.includeAllJarsInLib(true);
		// atbp.addExcludeClass(Class<? extends Model> clazz)
		me.add(atbp);
		// 分优先级加载配置文件 在团队开发中如果自己有测试配置需要长期存在但是又不需要提交中心库的时候 可以采用分级配置加载的策略。
		// 如中心库中有config.properties这个配置，你可以创建
		// config-test.properties文件，配置相同的key，ConfigKit中的方法会优先加载xx-test.properties文件。
		ConfigPlugin configPlugin = new ConfigPlugin();
		configPlugin.addResource(".*.properties");
	}

	@Override
	public void configInterceptor(Interceptors me) {
		me.add(new SessionInViewInterceptor());
		me.add(new DirectiveInterceptor()); // 页面传递数据 拦截器 码表
	}
  
    /**
     * 结束的时候将定时任务关闭
     */
    @Override  
    public void beforeJFinalStop() {  
        super.beforeJFinalStop();  
        //timer.cancel();  
    }
	@Override
	public void configHandler(Handlers me) {
		me.add(new IgnoreUrlsHandler());
		//me.add(new ContextPathHandler());
		System.out.println("server_domain:"+getProperty("server_domain"));
		me.add(new MyContextPathHandler("CONTEXT_PATH",getProperty("server_domain")));
	}

	// 定时任务
	// private Timer timer = new Timer();

	/**
	 * 启动的时候调用定时任务
	 */
	@Override
	public void afterJFinalStart() {
		super.afterJFinalStart();
		if (!getPropertyToBoolean("devMode", true)) {
			new DadaSendTask(getPropertyToInt("dadaSendInterval").intValue()).start();
			new OrderInvalidTask(getPropertyToInt("stockTaskInterval").intValue()).start();
			// 订单状态为已付款2天内短信提醒用户收货任务
			new OrderRemindTask(getPropertyToInt("stockTaskInterval").intValue()).start();
			// 鲜果师定结算定时任务
			//new MasterBonusManageTask(getPropertyToInt("masterBonusTaskInterval").intValue()).start();
			//鲜果师下级红利结算（单纯的生产记录）、结算记录重置
			//new MasterAchievementRecordTask(getPropertyToInt("masterAchievementRecordTaskInterval").intValue()).start();
			//充值200，活动期间每天送抽奖机会送一次
			//new RechangeRaffleTask(getPropertyToInt("rechangeRaffleTaskInterval").intValue()).start();
			// 团购未成功退款任务
			new TeamBuyCancelTask(PathKit.getRootClassPath() + "/apiclient_cert.p12",
				getPropertyToInt("cancelTeamBuyTaskInterval").intValue()).start();
			// 海鼎订单定时发送
			new OrderHdSendTask(getPropertyToInt("stockTaskInterval").intValue()).start();
			// 达达配送定时任务
			new OrderDadaSendTask(getPropertyToInt("dadaSendTaskInterval").intValue()).start();
			//团购商品根据拼团时间上下架定时任务
			new GroupProductUpOrDownTask(getPropertyToInt("groupProductUpOrDownTaskInterval").intValue()).start();
			//种子区间段自动开启关闭定时任务
			new SeedTimeUpOrDownTask(getPropertyToInt("seedTimeUpOrDownTaskInterval").intValue()).start();
			//优惠券兑换码活动过期自动失效定时任务
			new TCouponCategoryTask(getPropertyToInt("couponCategoryTaskInterval").intValue()).start();
		}
		//new DadaSendTask(getPropertyToInt("dadaSendInterval").intValue()).start();
		//new OrderHdSendTask(getPropertyToInt("stockTaskInterval").intValue()).start();
	}
	

}
