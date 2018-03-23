package com.sgsl.routes;

import com.jfinal.config.Routes;
import com.sgsl.controller.*;
import com.xgs.controller.FruitShopController;
import com.xgs.controller.FoodFreshController;
import com.xgs.controller.FreshFruitMallController;
import com.xgs.controller.FruitMasterController;
import com.xgs.controller.MasterIndexController;
import com.xgs.controller.MasterOrderManageController;
import com.xgs.controller.MyselfController;

/**
 * Created by Tao on 2014-07-18.
 */
public class WebRoute extends Routes {


    @Override
    public void config() {
        add("/",ShopIndexController.class);
        add("/pay",PaymentController.class);
        add("/bespeak", BespeakController.class);
        add("/customer",CustomerController.class);
        add("/activity",ActivityController.class);
        add("/weixinApi",WeiXinController.class);
        add("/hdApi",HdController.class);
        add("/dada",DadaDeliverController.class);
        add("/masterIndex",MasterIndexController.class);
        add("/myself",MyselfController.class);
        add("/fruitMaster", FruitMasterController.class);
        add("/mall",FreshFruitMallController.class);
        
        add("/fruitShop", FruitShopController.class);
        add("/foodFresh",FoodFreshController.class);
        add("/masterOrderManage",MasterOrderManageController.class);
        add("/coupon",CouponController.class);
        add("/team",TeamController.class);
    }
}
