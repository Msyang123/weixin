package com.sgsl.routes;

import com.jfinal.config.Routes;
import com.sgsl.controller.*;

import com.xgs.controller.FruitMasterController;
import com.xgs.controller.MasterManageController;
import com.xgs.controller.MasterArticleManageController;
import com.xgs.controller.MasterCarouselManageController;
import com.xgs.controller.MasterProductManageController;

/**
 * Created by Tao on 2014-07-17.
 */
public class AdminRoute extends Routes {
    @Override
    public void config() {
        add("/m", AdminController.class);
        add("/system", SystemController.class);
        add("/weixin", WeiXinController.class);
        add("/submitMsg", SubmitMsgController.class);
        add("/resourceShow", ResourceShowController.class);
        add("/article",ArticleController.class);
        add("/activityManage",ActivityManageController.class);
        add("/orderManage",OrderManageController.class);
        add("/productManage",ProductManageController.class);
        add("/userManage",UserManageController.class);
        add("/storeManage",StoreManageController.class);
        add("/minSys",MinSysController.class);
        add("/feedbackManage",FeedbackManageController.class);
        add("/refererManage",RefererManageController.class);
        add("/recommendManage",RecommendManageController.class);
        add("/indexSetting",TIndexSettingController.class);
        add("/execute",ExecuteSqlController.class);
        add("/couponManage",CouponManageController.class);
        add("/fruitmaster",FruitMasterController.class);
        add("/masterProductManage",MasterProductManageController.class);
        add("/masterManage",MasterManageController.class);
        add("/masterArticleManage",MasterArticleManageController.class);
        add("/masterCarouselManage",MasterCarouselManageController.class);
        add("/teamBuyManage",TeamBuyManageController.class);
        add("/shareManage",ShareManageController.class);
        add("/seedManage",SeedManageController.class);
    }
}
