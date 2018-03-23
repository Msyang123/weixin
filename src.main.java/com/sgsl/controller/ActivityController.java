package com.sgsl.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.AFwGet;
import com.sgsl.model.AUserFw;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MAward;
import com.sgsl.model.MHdAward;
import com.sgsl.model.MHdParam;
import com.sgsl.model.MHdUserAward;
import com.sgsl.model.MInterval;
import com.sgsl.model.MPackage;
import com.sgsl.model.MPackageInstance;
import com.sgsl.model.MPackageProduct;
import com.sgsl.model.MPackageSeedR;
import com.sgsl.model.MProductSeedR;
import com.sgsl.model.MRank;
import com.sgsl.model.MRecommend;
import com.sgsl.model.MSeedInstance;
import com.sgsl.model.MSeedProduct;
import com.sgsl.model.MSeedProductInstance;
import com.sgsl.model.MTeamBuy;
import com.sgsl.model.MTeamBuyScale;
import com.sgsl.model.MTeamMember;
import com.sgsl.model.TCouponCategory;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TCouponScale;
import com.sgsl.model.TExchangeOrderLog;
import com.sgsl.model.TGiftProduct;
import com.sgsl.model.TImage;
import com.sgsl.model.TIndexSetting;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPayLog;
import com.sgsl.model.TProductF;
import com.sgsl.model.TRefererRecord;
import com.sgsl.model.TStock;
import com.sgsl.model.TStore;
import com.sgsl.model.TUser;
import com.sgsl.model.TUserAwardRecord;
import com.sgsl.model.TUserCoupon;
import com.sgsl.model.TUserWhite;
import com.sgsl.model.TWhiteGift;
import com.sgsl.model.TPayLog.PaySourceTypes;
import com.sgsl.util.DateUtil;
import com.sgsl.util.GiveSeed;
import com.sgsl.util.HdUtil;
import com.sgsl.util.PushUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.wechat.TwitterIdWorker;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;


/**
 * Created by yj 
 * 手机活动
 */
public class ActivityController extends BaseController {
    protected final static Logger logger = Logger.getLogger(ActivityController.class);
    private TwitterIdWorker orderNoGenerator = new TwitterIdWorker(0, 0);

    protected static final int ORDER_TIMEFRAME = 6;// 订单时限，单位分钟
	protected String encoding = "UTF-8";	
	/**
     * 活动展示
     */
    public void show(){
        MActivity activity=MActivity.dao.findById(getPara("id"));
        if(activity==null){
        	activity=new MActivity();
        }
        setAttr("activity", activity);
        render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity.ftl");
    }
    /**
     * 活动表单
     */
    public void activityForm(){
    	MActivity activity=MActivity.dao.findById(getPara("id"));
        if(activity==null){
        	activity=new MActivity();
        }
        setAttr("activity", activity);
        render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity.ftl");
    }

    /**
	 * 优惠券活动详情页
	 */
    @Before(OAuth2Interceptor.class)
	public void yhq() {
    	setSessionAttr("from", getPara("from"));
		MActivity activity=MActivity.dao.findById(getPara("id"));
        if(activity==null){
        	activity=new MActivity();
        }
        setAttr("activity", activity);
        TImage image=TImage.dao.findById(activity.get("img_id"));
        setAttr("image", image);
        //客显屏优惠券
        //TCoupon coupon=new TCoupon();
        //List<Record> couponList= coupon.findTCouponKind((getPara("id"));
        //setAttr("couponList",couponList);
        //客显屏优惠券种类
        TCouponCategory coupon=new TCouponCategory();
        List<Record> couponList= coupon.findTCouponCategoryByActivityId(getPara("id"));
        setAttr("couponList",couponList);
        //客显屏活动商品
        /*MActivityProduct activityProduct=new MActivityProduct();
        List<Record> productList=activityProduct.findMActivityProducts(getParaToInt("id"));
        setAttr("productList", productList);*/
        
        // 热门爆款(客显屏)
		List<Record> mRecommends = new MRecommend().findMRecommendsByTypeId(3);
		setAttr("mRecommends", mRecommends);
		// 猜你喜欢(客显屏)
		List<Record> mRecommends1 = new MRecommend().findMRecommendsByTypeId(4);
		setAttr("mRecommends1", mRecommends1);
     			
        setSessionAttr("referer", "activity/yhq?id="+getPara("id"));
        //将记录存到数据库中
        TRefererRecord refererRecord=new TRefererRecord();
        refererRecord.set("referer", "activity/yhq?id="+getPara("id"));
        TUser tUserSession = UserStoreUtil.get(getRequest());
        refererRecord.set("user_id", tUserSession.get("id"));
        refererRecord.set("create_time", DateFormatUtil.format1(new Date()));
        refererRecord.save();
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_yhq.ftl");
	}
	/**
	 * 获取优惠券
	 */
	public void getYhq(){
		//TCoupon couponOper=new TCoupon();
		//TUser tUserSession = UserStoreUtil.get(getRequest());
		//renderJson(couponOper.getOneTCoupon(getPara("title"),getPara("activityId"),tUserSession.get("id")));
		TCouponReal couponOper=new TCouponReal();
		TUser tUserSession = UserStoreUtil.get(getRequest());
		renderJson(couponOper.getOneCoupon(getPara("coupon_category_id"),getPara("activityId"),tUserSession.get("id")));

	}
	
	/**
	 * 兑换码兑换真实优惠券
	 */
	public void exchangeCoupon(){
		//前台传过来兑换码
		String code=getPara("coupon_code");
		String orderMoney=getPara("order_money");
		TCouponReal coupon=new TCouponReal();
		TUser tUserSession = UserStoreUtil.get(getRequest());	
		renderJson(coupon.exchangeCouponByCode(code,tUserSession.get("id").toString(),orderMoney));
	}
	
	public void initFruitPackage(){	
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/fruit_package.ftl");
	}
	/**
	 * 发送水果礼包
	 */
	public void personGift(){
		Map<String,Object> result =new HashMap<String,Object>();
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId= tUserSession.get("id");
		Record isWhite = new TUserWhite().isWhite(userId, 15);
		/*if(isWhite==null){
			result.put("status","failed");
			result.put("msg", "您已经领取过礼品了！");
		}else{*/
			String sql = "select a.id,a.product_f_id,a.remain_num,a.product_f_amount*b.product_amount as total_amount,b.product_amount,c.id as pro_id,ifnull(b.special_price,b.price) as real_price,c.product_name,u.unit_name,i.save_string "
					+"from t_gift_product a left join t_product_f b on a.product_f_id=b.id left join t_product c on b.product_id=c.id "
					+"left join t_unit u on c.base_unit = u.unit_code "
					+"left join t_image i on c.img_id=i.id "
					+"where a.remain_num>0";
			List<Record> giftList = Db.find(sql);
			Random random = new Random();
			Record gift = giftList.get(random.nextInt(giftList.size()));
			result.put("giftProduct",gift);
			TStock stock = new TStock().getStockByUser(userId);
			int stockId = stock.getInt("id");
			Record stockProduct = new Record();
			stockProduct.set("stock_id", stockId);
			stockProduct.set("product_f_id", gift.get("product_f_id"));
			stockProduct.set("product_id", gift.get("pro_id"));
			stockProduct.set("unit_price", gift.getInt("real_price")/gift.getDouble("product_amount"));
			stockProduct.set("amount", gift.getDouble("total_amount"));
			stockProduct.set("get_time", DateFormatUtil.format1(new Date()));
			Db.save("t_stock_product", stockProduct);
			TGiftProduct giftProduct = new TGiftProduct();
			giftProduct.set("id", gift.get("id"));
			giftProduct.set("remain_num", gift.getInt("remain_num")-1);
			giftProduct.update();
			TWhiteGift whiteGift =new TWhiteGift();
			whiteGift.set("user_id", userId);
			whiteGift.set("activity_id", 15);
			whiteGift.set("gift_type", "1");
			whiteGift.set("gift_no", gift.get("product_f_id"));
			whiteGift.set("gift_amount", gift.getDouble("total_amount"));
			whiteGift.set("get_time", DateFormatUtil.format1(new Date()));
			whiteGift.save();
			result.put("status","success");
		//}
		renderJson(result);
	}

	public void sendGuowaToAll(){
		TUser user=new TUser();
		//查找白名单
		List<TUser>  whiteList=user.find("select * from t_user where store_id is not null");
		//清空数据
		Db.update("delete from a_fw_get");
		Db.update("delete from a_user_fw");
		Db.update("update m_activity set yxbz='Y' where id=8");
		//给每个人初始化数据信息
		for(TUser u:whiteList){
			//0-9之间的果娃数
			int r=(int)(Math.random()*10),s=(int)(Math.random()*10),t=(int)(Math.random()*10),q=(int)(Math.random()*10);
			int[] m=new int[]{r,s,t,q};
			int x=m[0];
			for(int i=1;i<m.length;i++){
				if(m[i]<x){
					x=m[i];
				}
			}
			for(int i=0;i<r&&x!=r;i++){
				AFwGet aFwGet=new AFwGet();
				aFwGet.set("fw_id", 1);
				aFwGet.set("get_time",DateFormatUtil.format1(new Date()));
				aFwGet.set("user_id",u.getInt("id"));
				aFwGet.set("is_vaild","0");
				aFwGet.set("order_id", "");
				aFwGet.set("is_zs", "N");
				//保存抽奖记录
				aFwGet.save();
			}
			if(x!=r&&r>0){
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 1);
				userFw.set("fw_count", r);
				userFw.save();
			}else{
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 1);
				userFw.set("fw_count", 0);
				userFw.save();
			}
			for(int i=0;i<s&&x!=s;i++){
				AFwGet aFwGet=new AFwGet();
				aFwGet.set("fw_id", 2);
				aFwGet.set("get_time",DateFormatUtil.format1(new Date()));
				aFwGet.set("user_id",u.getInt("id"));
				aFwGet.set("is_vaild","0");
				aFwGet.set("order_id", "");
				aFwGet.set("is_zs", "N");
				//保存抽奖记录
				aFwGet.save();
			}
			if(x!=s&&s>0){
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 2);
				userFw.set("fw_count", s);
				userFw.save();
			}else{
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 2);
				userFw.set("fw_count", 0);
				userFw.save();
			}
			for(int i=0;i<t&&x!=t;i++){
				AFwGet aFwGet=new AFwGet();
				aFwGet.set("fw_id", 3);
				aFwGet.set("get_time",DateFormatUtil.format1(new Date()));
				aFwGet.set("user_id",u.getInt("id"));
				aFwGet.set("is_vaild","0");
				aFwGet.set("order_id", "");
				aFwGet.set("is_zs", "N");
				//保存抽奖记录
				aFwGet.save();
			}
			if(x!=t&&t>0){
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 3);
				userFw.set("fw_count", t);
				userFw.save();
			}else{
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 3);
				userFw.set("fw_count", 0);
				userFw.save();
			}
			for(int i=0;i<q&&x!=q;i++){
				AFwGet aFwGet=new AFwGet();
				aFwGet.set("fw_id", 4);
				aFwGet.set("get_time",DateFormatUtil.format1(new Date()));
				aFwGet.set("user_id",u.getInt("id"));
				aFwGet.set("is_vaild","0");
				aFwGet.set("order_id", "");
				aFwGet.set("is_zs", "N");
				//保存抽奖记录
				aFwGet.save();
			}
			if(x!=q&&q>0){
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 4);
				userFw.set("fw_count", q);
				userFw.save();
			}else{
				AUserFw userFw=new AUserFw();
				userFw.set("user_id", u.getInt("id"));
				userFw.set("fw_id", 4);
				userFw.set("fw_count", 0);
				userFw.save();
			}
		}
		
		//统计用户
		Map result=new HashMap();
		result.put("r", 0);
		renderJson(result);
	}
	//ajax返回用户限购的数量
	public void restrict() throws UnsupportedEncodingException{
		boolean isLimit=false;
		int productFId= getParaToInt("productFId");
		int count=getParaToInt("count");
		MActivity activity=new MActivity();
		//找到所有限购活动的商品限制每天的数量
		List<Record> products= activity.findMActivityProducts(1);
		//获取当天时间
		String currentDate=DateFormatUtil.format5(new Date());
		//当前用户
		TUser tUserSession = UserStoreUtil.get(getRequest());
		//返回结果
		HashMap<String, Boolean> resultJson=new HashMap<String, Boolean>();
		//查找用户当天赠送和购买订单
		Record result= Db.findFirst("select product_f_id,sum(amount) as amount from( "+
				"select product_f_id,amount,buy_time from t_order_products op left join t_order t on op.order_id=t.id "+
				"where buy_time like '"+currentDate+"%' and product_f_id=? and t.order_user=? and t.order_status<>0 "+
				"union select pf_id as product_f_id,amount,buy_time from t_present_products pp left join t_present p on pp.present_id=p.id "+
				"where buy_time like '"+currentDate+"%' and pf_id=? and p.present_user=?) x  group by product_f_id",productFId,tUserSession.get("id"),productFId,tUserSession.get("id"));
		if(result!=null){
			for(Record item:products){
				int productFid=item.getInt("product_f_id");
				Integer restrict=item.getInt("restrict");
				if(restrict==null)
					continue;
				//当期购买数量+以前购买数量<=限制数量
				if(productFId==productFid&&(count+result.getDouble("amount").doubleValue())>restrict){
					isLimit=true;
					resultJson.put("isLimit", isLimit);
					renderJson(resultJson);
					return;
				}
			}
		}
		//当前抢购商品在购物车中的份数,默认0份
		int cart_tj_product_number = 0;
		if(getCookie("cartInfo")!=null){//购物车
			JSONArray xgCartInfo_number = JSONArray.parseArray(URLDecoder.decode(getCookie("cartInfo"), "UTF-8"));//获取购物车信息
			JSONObject jsonObject;
			MInterval interval = new MInterval();
			//所有抢购商品
			for (Record qgProduct : products) {
				MActivity qgActivity = MActivity.dao.findYxActivityById(qgProduct.getInt("activity_id"));
				if(qgActivity!=null&&interval.isInInterval(qgActivity.getInt("id"))!=null){
					//只有当前抢购活动的商品与需要添加的商品一致时才需要检测是否满足
					if(qgProduct.getInt("product_f_id").equals(getParaToInt("productFId"))){
						int productFid=qgProduct.getInt("product_f_id");
						Integer restrict=qgProduct.getInt("restrict");
						if(restrict==null)
							continue;
						//找到当前抢购商品在购物车中的份数
						for (Object object2 : xgCartInfo_number) {
							jsonObject = (JSONObject)object2;
							if(jsonObject.getIntValue("pf_id")==productFid){
								cart_tj_product_number = jsonObject.getIntValue("product_num");
							}
						}
						//购物车限时抢购的商品数量<=限制数量
						if(cart_tj_product_number>=restrict){
							if(getParaToInt("productFId")==productFid){//即将添加的商品是该限时抢购的商品
								isLimit=true;
								break;
							}
						}
					}
				}
			}
				
		}

		resultJson.put("isLimit", isLimit);
		renderJson(resultJson);
	}
	/**
	 * 购物车购买之前判定购物车中是否有限时抢购商品（超出限购数量）
	 * @throws UnsupportedEncodingException 
	 */
	public void orderRestrict() throws UnsupportedEncodingException{
		TUser tUserSession = UserStoreUtil.get(getRequest());
		String currentDate=DateFormatUtil.format5(new Date());
		JSONObject result = new JSONObject();
		JSONArray limit_product_arr = new JSONArray();
		result.put("isLimit",false);
		result.put("msg","可以购买");
		if(getCookie("cartInfo")!=null){
			JSONArray xgCartInfo_number = JSONArray.parseArray(URLDecoder.decode(getCookie("cartInfo"), "UTF-8"));//获取购物车信息
			// 抢购活动
			MActivity activity = new MActivity();
			List<Record> activitys = activity.findMActivitys(1);
			MActivityProduct activityProOper = new MActivityProduct();
			if(activitys!=null){
				for (Record item : activitys) {
					//是否在限购时间段内
					MInterval xgInterval = MInterval.dao.isInInterval(item.getInt("id"));
					if(xgInterval!=null){
						// 查找活动商品
						List<MActivityProduct> activityProducts = activityProOper.findMActivityProductList(item.getInt("id"));
						for (Object object: xgCartInfo_number) {
							JSONObject cartProduct = (JSONObject)object;
							for (MActivityProduct mp : activityProducts) {
								if(cartProduct.getInteger("product_id").equals(mp.getInt("product_id"))){
									//查找用户当天赠送和购买订单
									Record order= Db.findFirst("select product_f_id,sum(amount) as amount from( "+
											"select product_f_id,amount,buy_time from t_order_products op left join t_order t on op.order_id=t.id "+
											"where buy_time like '"+currentDate+"%' and product_f_id=? and t.order_user=? and t.order_status<>0 "+
											"union select pf_id as product_f_id,amount,buy_time from t_present_products pp left join t_present p on pp.present_id=p.id "+
											"where buy_time like '"+currentDate+"%' and pf_id=? and p.present_user=?) x  group by product_f_id",cartProduct.getInteger("pf_id"),tUserSession.get("id"),cartProduct.getInteger("pf_id"),tUserSession.get("id"));
									//已经购买的商品+购物车中的数量
									int product_num = order==null?cartProduct.getInteger("product_num"):cartProduct.getInteger("product_num")+order.getInt("amount");
									//超出限购数量，记录超过限购的商品规格编号
									if(item.getInt("restrict")<product_num){
										JSONObject limit_product = new JSONObject();
										limit_product.put("product_f_id", cartProduct.getString("pf_id"));
										limit_product.put("restrict_num", item.get("restrict"));
										result.put("isLimit",true);
										result.put("msg","购物车中有商品超过限时抢购数量");
										limit_product_arr.add(limit_product);
									}
								}
							}
						}
					}
				}
			}
		}else{
			result.put("isLimit",true);
			result.put("msg","购物车已被清空，请重新添加商品至购物车");
		}
		result.put("limit_product_arr", limit_product_arr);
		System.out.println(result);
		renderJson(result);
	}
	//需要鉴权
	@Before(OAuth2Interceptor.class)
    public void seedBuy(){	
    	//查找我的种子
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	Record mActivity = Db.findFirst("select t.*,t1.save_string from m_activity t left join t_image t1 on t.img_id=t1.id where activity_type=18 and yxbz='Y' ");
    	List<Record> mySeeds= new MSeedInstance().getMySeedInstance(tUserSession.get("id"));
    	setAttr("mySeeds", mySeeds);
    	int activityId=-1;
    	if(mActivity!=null){
    		activityId=mActivity.getInt("id");
    		if(mActivity.get("share_send")!=null || !("".equals(mActivity.get("share_send")))){
        		JSONObject share_send = JSONObject.parseObject(mActivity.getStr("share_send"));
        		if(share_send.getBoolean("isShare")){
        			setAttr("seedNum",share_send.get("seedNum"));
         			setAttr("frequence",share_send.get("frequence"));//Frequence-0：仅一次 1：每日刷新
    			}
        	}
    	}
    	setAttr("mActivity", mActivity);
    	//套餐即套餐兑换商品与兑换需要种子
    	List<Map> mPackages= new MPackage().packageList(activityId);
    	System.out.println("=========="+JSONObject.toJSON(mPackages));
    	setAttr("mPackages", mPackages);
    	//单品即单品需要的种子
    	List<Map> mSeedProducts=new MSeedProduct().seedProductList(activityId);
    	System.out.println("--------"+JSONObject.toJSON(mSeedProducts));
    	setAttr("mSeedProducts",mSeedProducts);
    	setAttr("activity_id",mActivity.getInt("id"));
    	
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_seedbuy.ftl");
	}
    /**
     * 种子兑换套餐
     */
    public void seedExchangePackage(){
    	HashMap<String, Object> resultJson=new HashMap<String, Object>();
    	//查找我的种子
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	MSeedInstance instOper=new MSeedInstance();
    	int packageid=getParaToInt("packageid");
    	int activity_id=getParaToInt("activity_id");
    	//兑换
    	List<MPackageSeedR> mpsr=  new MPackageSeedR().getPackageSeedR(packageid);
    	//先查询出用户有多少神秘种子
    	List<MSeedInstance> mysteriousSeed=MSeedInstance.dao.find("select * from m_seed_instance where seed_type_id=5 and status=1 and user_id=? ",userId);
    	//需要的神秘种子
    	int needMysteriousSeed=0;
    	boolean flag=true;
    	List<Map<String,Integer>> need=new ArrayList<Map<String,Integer>>();
    	for(MPackageSeedR psr:mpsr){
    		Record count=Db.findFirst("select count(*) as c from m_seed_instance where seed_type_id=? and status=1 and user_id=? ",
    				psr.getInt("seed_type_id"),userId);
    		//用户的种子数是否大于套餐所需的种子数
    		if(count.getLong("c").intValue()>=psr.getInt("amount").intValue()){
    			Map<String,Integer> seedType=new HashMap<String,Integer>();
    			seedType.put("id", psr.getInt("seed_type_id"));
    			seedType.put("amount", psr.getInt("amount"));
    			need.add(seedType);
    			continue;
    		}else{
    			//需要神秘种子累积
    			needMysteriousSeed+=psr.getInt("amount")-count.getLong("c");
    			//优先普通种子抵扣
    			if(count.getLong("c").intValue()>0){
    				Map<String,Integer> seedType=new HashMap<String,Integer>();
        			seedType.put("id", psr.getInt("seed_type_id"));
        			seedType.put("amount", count.getLong("c").intValue());
        			need.add(seedType);
    			}
    		}
    		//连神秘种子都不够抵扣
    		if(mysteriousSeed.size()<needMysteriousSeed){
    			flag=false;
    			break;
    		}
    	}
    	//需要神秘种子抵扣
    	if(needMysteriousSeed>0){
    		Map<String,Integer> seedType=new HashMap<String,Integer>();
			seedType.put("id", 5);
			seedType.put("amount", needMysteriousSeed);
			need.add(seedType);
    	}
    	//符合条件，已经收集齐了
    	String currentTime=DateFormatUtil.format1(new Date());
    	//检查是否满足兑换
    	if(flag){
    		MPackage mPackage=MPackage.dao.getPackage(packageid);
    		if(mPackage.getInt("isLimit")==1&&mPackage.getInt("max_num")<=0){
   			 	 resultJson.put("success", false);
      			 resultJson.put("message", "兑换的套餐份数不够了~");
      			 renderJson(resultJson);
      			 return;
   		 	}
    		
			resultJson.put("seedTypeList", need);
			//查找此套餐所有的商品
			List<MPackageProduct> packageProducts=
				MPackageProduct.dao.find("select mp.*,ifnull(pf.special_price,pf.price) as real_price,pf.product_amount,i.save_string  "
						+ "from m_package_product mp "
						+ "left join t_product_f pf on mp.product_f_id=pf.id and mp.product_id=pf.product_id "
						+ "left join m_package m on m.id=mp.package_id "
						+ "left join t_image i on m.image_id=i.id "
						+ "where mp.package_id=? and mp.status='Y'",packageid);
			
			resultJson.put("packageid", packageid);
			
			resultJson.put("packageProducts", packageProducts);
			resultJson.put("success", true);
			resultJson.put("message", "兑换的套餐成功");
			renderJson(resultJson);
    	}else{
    		resultJson.put("success", false);
			resultJson.put("message", "您的种子不够，请继续收集相应的种子");
			renderJson(resultJson);
    	}
    }
    /**
     * 种子兑换单品
     */
    public void seedExchangeProduct(){
    	HashMap<String, Object> resultJson=new HashMap<String, Object>();
    	//查找我的种子
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	int activity_id=getParaToInt("activity_id");
    	MSeedInstance instOper=new MSeedInstance();
    	int singleid=getParaToInt("singleid");
    	//兑换
    	List<MProductSeedR> mpsr= new MProductSeedR().getMProductSeedR(singleid);
    	//先查询出用户有多少神秘种子
    	List<MSeedInstance> mysteriousSeed=MSeedInstance.dao.find("select * from m_seed_instance where seed_type_id=5 and status=1 and user_id=? ",userId);
    	//需要的神秘种子
    	int needMysteriousSeed=0;
    	boolean flag=true;
    	List<Map<String,Integer>> need=new ArrayList<Map<String,Integer>>();
    	for(MProductSeedR psr:mpsr){
    		Record count=Db.findFirst("select count(*) as c from m_seed_instance where seed_type_id=? and status=1 and user_id=? ",
    				psr.getInt("seed_type_id"),userId);
    		if(count.getLong("c").intValue()>=psr.getInt("amount").intValue()){
    			Map<String,Integer> seedType=new HashMap<String,Integer>();
    			seedType.put("id", psr.getInt("seed_type_id"));
    			seedType.put("amount", psr.getInt("amount"));
    			need.add(seedType);
    			continue;
    		}else{
    			//需要神秘种子累积
    			needMysteriousSeed+=psr.getInt("amount")-count.getLong("c");
    			//优先普通种子抵扣
    			if(count.getLong("c").intValue()>0){
    				Map<String,Integer> seedType=new HashMap<String,Integer>();
        			seedType.put("id", psr.getInt("seed_type_id"));
        			seedType.put("amount", count.getLong("c").intValue());
        			need.add(seedType);
    			}
    		}
    		//连神秘种子都不够抵扣
    		if(mysteriousSeed.size()<needMysteriousSeed){
    			flag=false;
    			break;
    		}
    	}
    	//需要神秘种子抵扣
    	if(needMysteriousSeed>0){
    		Map<String,Integer> seedType=new HashMap<String,Integer>();
			seedType.put("id", 5);
			seedType.put("amount", needMysteriousSeed);
			need.add(seedType);
    	}
    	//检查是否满足兑换
    	/*List<Record> need= Db.find("select t1.*,t2.amount from "+
					" (select m.id,(select count(s.id) from m_seed_instance s where s.seed_type_id=m.id and s.status=1 and s.user_id=? ) as total_instance "+
					"  from m_seed_type m where  m.activity_id=? and m.status='Y'  group by m.id) as t1 left join m_product_seed_r t2 "+
					" on t1.id=t2.seed_type_id "+
					"  where t1.total_instance>=t2.amount and t2.seed_product_id=? ",
					userId,22,singleid);*/
    	//符合条件，已经收集齐了
    	String currentTime=DateFormatUtil.format1(new Date());
    	if(flag){
    		//查看单品
    		MSeedProduct mSeedProduct = MSeedProduct.dao.getSingle(singleid);
    		 if(mSeedProduct==null){
    			resultJson.put("success", false);
     			resultJson.put("message", "没有可兑换的单品");
     			renderJson(resultJson);
     			return;
    		 }
    		 
    		 if(mSeedProduct.getInt("isLimit")==1&&mSeedProduct.getInt("max_num")<=0){
    			 resultJson.put("success", false);
       			 resultJson.put("message", "兑换的单品份数不够了~");
       			 renderJson(resultJson);
       			 return;
    		 }
    		 
    		 resultJson.put("seedTypeList", need);
 			//查找此单品所有的商品
			List<MSeedProduct> seedProducts=
					MSeedProduct.dao.find("select msp.*,ifnull(pf.special_price,pf.price) as real_price,pf.product_amount,pf.id from m_seed_product msp "+
										"left join t_product_f pf on msp.product_f_id=pf.id and msp.product_id=pf.product_id where msp.id=? and msp.status='Y'",singleid);
			resultJson.put("singleid", singleid);
			resultJson.put("seedProducts", seedProducts);
			resultJson.put("success", true);
			renderJson(resultJson);
    	}else{
    		resultJson.put("success", false);
			resultJson.put("message", "您的种子不够，请继续收集相应的种子");
			renderJson(resultJson);
    	}
    }
	
    /**
     * ajax随机发放种子
     */
    public void getSeed(){
    	String count=getPara("count");
    	String type=getPara("type");
    	int seedCount=-1;
    	int getType=-1;
    	if(StringUtil.isNotNull(count)){
    		seedCount=getParaToInt("count");
    	}
    	if(StringUtil.isNotNull(type)){
    		getType=getParaToInt("type");
    	}
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId = tUserSession.get("id");
		//设置一个随机种子用于页面冒泡
    	Record mActivity = Db.findFirst("select *from m_activity where activity_type=18 and yxbz='Y' ");
		renderJson(new GiveSeed().get1(mActivity.getInt("id"),userId,seedCount,getType));
    }
    /**
     *  种子活动开放时间段
     */
    public void getMInterval(){
    	Record mActivity = Db.findFirst("select *from m_activity where activity_type=18 and yxbz='Y' ");
    	if(mActivity!=null){
    		renderJson(new MInterval().getLest10Min(mActivity.getInt("id")));
    	}else{
    		renderJson(new MInterval());
    	}
    }
    
    /**
     * 排行榜活动页显示
     */
    @Before(OAuth2Interceptor.class)
    public void rankingList(){
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	MRank rankOper=new MRank();
    	//总排行
    	setAttr("feeRank", rankOper.feeRankV2());
    	//我的排行
    	setAttr("myFeeRank", rankOper.myFeeRankV2(userId));
        render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_rankingList.ftl");
    }
    /*************团购活动**************************************************/
    /**
     * 团购活动--F
     */
    @Before(OAuth2Interceptor.class)
    public void groupBuys(){
    	
    	MActivity act=new MActivity();
    	MActivity actResult=act.findYxActivityByType(10);
    	setAttr("actResult", actResult);
    	TImage image=TImage.dao.findById(actResult.getInt("img_id"));
    	setAttr("image", image);
    	//获取团购中商品信息
    	MTeamBuy teamBuy=new MTeamBuy();
    	setAttr("teamDetial",teamBuy.teamDetial(actResult.getInt("id")));
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_groupbuy.ftl");
    }
    
    /**
     * 团购信息页--F
     */
    @Before(OAuth2Interceptor.class)
    public void groupBuyInfo(){
    	int teamBuyId=getParaToInt("teamBuyId");
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	//查找当前团下面的成员
    	MTeamMember memberOper=new MTeamMember();
    	MTeamBuy teamBuyOper=new MTeamBuy();
    	List<Record> members= memberOper.personInTeam(teamBuyId);
    	setAttr("members", members);
    	//查看我是否参加了当前团 
    	MTeamMember isMyJoin= memberOper.myJoinTeam(userId,teamBuyId);
    	setAttr("isMyJoin", isMyJoin);
    	TOrder myOrder=new TOrder();
    	if(isMyJoin!=null){
    		myOrder= myOrder.findTOrderByOrderId(isMyJoin.getStr("order_id"));
    	}
    	setAttr("myOrder", myOrder);
    	MTeamBuy teamBuy=teamBuyOper.findById(teamBuyId);
    	int buyScaleId= teamBuy.getInt("m_team_buy_scale_id");
    	//查找所属规模
    	MTeamBuyScale teamBuyScaleOper=new MTeamBuyScale();
    	MTeamBuyScale teamBuyScale=teamBuyScaleOper.findById(buyScaleId);
    	setAttr("teamBuyScale",teamBuyScale);
    	Record beginTeam=teamBuyOper.searchBeginTeamById(teamBuyId);
    	setAttr("beginTeam",beginTeam);
    	//团购商品详情
    	Record productDetial=teamBuyOper.teamProductDetial(teamBuyId);
    	setAttr("productDetial",productDetial);
    	
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_groupbuyinfo.ftl");
    }
    /**
     * 查看拼团是否已满
     */
    public void isFull(){
    	Map result=new HashMap();
    	MTeamMember memberOper=new MTeamMember();
    	result.put("isFull", memberOper.isFull(getParaToInt("teamBuyId")));
    	renderJson(result);
    }
    /**
     * 查看当前用户在此团购规模中当天是否超过指定的份数
     *
     */
    public void isUserJoinOver(){
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	int teamBuyScaleId=getParaToInt("teamBuyScaleId");
    	MTeamBuyScale teamBuyScale= MTeamBuyScale.dao.findById(teamBuyScaleId);
    	//查询规定可参团数
    	int teamBuyTimes=teamBuyScale.getInt("team_buy_times");
    	//获取用户参团数
    	MTeamMember memberOper=new MTeamMember();
    	long todayMyJoinTimes=memberOper.todayMyJoinTimes(userId, teamBuyScaleId);
    	Map result=new HashMap();
    	
    	result.put("isFull", todayMyJoinTimes>=teamBuyTimes);
    	renderJson(result);
    }
    /**
     * 团购商品详情--F
     */
    @Before(OAuth2Interceptor.class)
    public void groupGoodsInfo(){
    	//团购商品主键
    	int activityProductId=getParaToInt("id");
    	MTeamBuy teamBuy=new MTeamBuy();
    	MTeamBuyScale teamBuyScale=new MTeamBuyScale();
    	//查找指定商品的已经开始团购，并且未成功的团 最多50个
    	setAttr("beginTeams", teamBuy.alreadyBeginTeam(activityProductId, 2));
    	setAttr("activityProductId",activityProductId);
    	Record productDetial=teamBuy.teamProductDetialBuyProId(activityProductId);
    	setAttr("productDetial",productDetial);
    	//查找团规模
    	List<Record> teamBuyScales=teamBuyScale.getMTeamBuyScale(activityProductId);
    	setAttr("teamBuyScales", teamBuyScales);
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_groupgoodsinfo.ftl");
    }
    /**
     * ajax调用加载更多
     */
    public void teamBuyMore(){
    	int activityProductId=getParaToInt("id");
    	int exc1=getParaToInt("exc1");
    	int exc2=getParaToInt("exc2");
    	MTeamBuy teamBuy=new MTeamBuy();
    	List<Record> beginTeams= teamBuy.alreadyBeginTeam(activityProductId,48,exc1,exc2);
    	JSONArray resultArray=new JSONArray();
    	for(Record item: beginTeams){
    		JSONObject jsonItem=new JSONObject();
    		jsonItem.put("personCount", item.getInt("person_count"));
    		jsonItem.put("nickname", item.getStr("nickname"));
    		jsonItem.put("leftCount", item.getLong("left_count"));
    		jsonItem.put("createTime", item.getStr("create_time"));
    		jsonItem.put("bid", item.getInt("bid"));
    		jsonItem.put("id",item.getInt("id"));
    		resultArray.add(jsonItem);
    	}
    	renderJson(resultArray);
    }
    
    /**
     * 我的团购--F
     */
    @Before(OAuth2Interceptor.class)
    public void myGroup(){
    	//查找我参加的团
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	//查找指定有效的团购活动
    	MActivity activity=new MActivity().findYxActivityByType(10);
    	MTeamMember memberOper=new MTeamMember();
    	List<Record> myJoinTeams=memberOper.myJoinTeamList(userId,activity.getInt("id"));
    	setAttr("myJoinTeams",myJoinTeams);
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_mygroup.ftl");
    }
    /**
     * 团购订单--F
     * */
    @Before(OAuth2Interceptor.class)
    public void groupOrder(){
    	//团购规模编号
    	int teamBuyScaleId=getParaToInt("teamBuyScaleId");
    	
    	//团购编号
    	setAttr("teamBuyId",getPara("teamBuyId"));

    	String currDate = DateFormatUtil.format4(new Date());
		setAttr("currDate", currDate);
		//查询店铺列表
		List<Record> storeList = new TStore().findStores();
		setAttr("storeList", storeList);
		
		//只是买一个商品
		String productInfo=getCookie("productInfo");
		if(StringUtil.isNotNull(productInfo)){
			removeCookie("productInfo");
		}
		setCookie("productInfo","[{'product_id':"+getPara("pId")+"#'product_num':'1'#'pf_id':"+getPara("pfId")+"}]",604800);
		
		Record teamBuyScale=new MTeamBuyScale().getMTeamBuyScaleById(teamBuyScaleId);
		setAttr("teamBuyScale", teamBuyScale);
		setAttr("storeId",getCookie("store_id")==null?"07310109":getCookie("store_id"));
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_group_order.ftl");
    }
    
    /*************九宫格抽奖活动*************************************************/
    /**
     * 九宫格抽奖活动--F
     * */
    @Before(OAuth2Interceptor.class)
    public void lottery(){
    	//查找有效的九宫格活动
    	String activityId=getPara("activityId");
    	MActivity activity=MActivity.dao.findFirst("select * from m_activity where activity_type=13 and yxbz='Y' and id=? ",activityId);
    	if(activity==null){
    		renderNull();
    		return;
    	}
    	setAttr("activity", activity);
    	//查找所有中间名单
    	List<Record> userAwardRecordList=Db.
    			find("select t1.*,CONCAT(INSERT(t2.phone_num,4,8,'****'),RIGHT(t2.phone_num,4)) as phone_num,t3.award_name "
    					+ " from t_user_award_record t1 left join t_user t2 on t1.user_id=t2.id"
    					+ " left join m_award t3 on t1.award_id=t3.id "
    					+ " where t1.is_valid='0' and t3.award_type!='4' and t3.activity_id=? order by t1.award_time desc  limit 50 ",activityId);
    	setAttr("userAwardRecordList",userAwardRecordList);
    	//查找配置的九宫格抽奖奖品信息
    	List<Record> awardList=new MAward().findMAwardsByActivityId(activityId);
    	setAttr("awardList",awardList);
    	//查找我现在拥有的抽奖次数
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	long myHaveAwardChance=new TUserAwardRecord().myHaveAwardChance(userId,activityId);
    	setAttr("myHaveAwardChance",myHaveAwardChance);
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_lottery.ftl");
    }
    /**
     * ajax查找所有中间名单
     */
    public void getAllUserAwardRecordListJson(){
    	//查找所有中间名单
    	String activityId=getPara("activityId");
    	List<Record> userAwardRecordList=Db.
    			find("select t1.*,CONCAT(INSERT(t2.phone_num,4,8,'****'),RIGHT(t2.phone_num,4)) as phone_num,t3.award_name "
    					+ " from t_user_award_record t1 left join t_user t2 on t1.user_id=t2.id"
    					+ " left join m_award t3 on t1.award_id=t3.id "
    					+ " where t1.is_valid='0' and t3.award_type!='4' and t3.activity_id=? order by t1.award_time desc limit 50 ",activityId);
    	JSONArray resultList=new JSONArray();
    	resultList.addAll(userAwardRecordList);
    	renderJson(resultList);
    }
    /**
     * 转动转盘获得九宫格抽奖
     */
    public void getAward(){
    	JSONObject result=new JSONObject();
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	String activityId=getPara("activityId");
    	MActivity activity=MActivity.dao.findFirst("select * from m_activity where activity_type='13' and yxbz='Y' and id=? ",activityId);
    	Date current=new Date();
    	if(activity==null){
    		result.put("resultCode", false);
    		result.put("msg", "活动已结束或者未开启");
    		renderJson(result);
    		return;
    	}else if(DateUtil.convertString2Date(activity.getStr("cjjh_q")).after(current)){
    		result.put("resultCode", false);
    		result.put("msg", "未到抽奖时间");
    		renderJson(result);
    		return;
    	}else if(DateUtil.convertString2Date(activity.getStr("cjjh_z")).before(current)){
    		result.put("resultCode", false);
    		result.put("msg", "活动已结束");
    		renderJson(result);
    		return;
    	}
    	MAward awardOper= new MAward();
    	long myHaveAwardChance=new TUserAwardRecord().myHaveAwardChance(userId,activityId);
    	if(myHaveAwardChance>0){
    		//获取九宫格奖品列表
			double number = Math.random();
			int awardSequence=0;
			List<Record> awardList=awardOper.findMAwardsByActivityId(activityId);
			if (number >= 0 && number <= awardList.get(0).getDouble("award_percent")/100.0) {
				awardSequence= 0;
			} else if (number >= awardList.get(0).getDouble("award_percent")/100.0 && 
					number <= (awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue())/100.0) {
				awardSequence= 1;
			} else if (number >= (awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue())/100.0
					&& number <= (awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue())/100.0) {
				awardSequence= 2;
			} else if (number >= (awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue())/100.0
					&& number <= (awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue())/100.0) {
				awardSequence= 3;
			} else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue())/100.0){
				awardSequence= 4;
			}else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue()+
					awardList.get(4).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue()+
							awardList.get(5).getDouble("award_percent").intValue())/100.0){
				awardSequence= 5;
			}else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue()+
					awardList.get(4).getDouble("award_percent").intValue()+
					awardList.get(5).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue()+
							awardList.get(5).getDouble("award_percent").intValue()+
							awardList.get(6).getDouble("award_percent").intValue())/100.0){
				awardSequence= 6;
			}else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue()+
					awardList.get(4).getDouble("award_percent").intValue()+
					awardList.get(5).getDouble("award_percent").intValue()+
					awardList.get(6).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue()+
							awardList.get(5).getDouble("award_percent").intValue()+
							awardList.get(6).getDouble("award_percent").intValue()+
							awardList.get(7).getDouble("award_percent").intValue())/100.0){
				awardSequence= 7;
			}
			
    		//查找中奖的具体内容
			MAward award=MAward.dao.findFirst("select * from m_award where award_sequence=? and activity_id=?",awardSequence,activityId);
			int remainingNum=award.getInt("remaining_num");
			award.set("remaining_num", remainingNum-1);
			MAward awardNext=null;
			//实际奖励的商品，先设置用户抽取到的是谢谢惠顾，然后将此商品的中奖概率设置到谢谢惠顾的上面
			if(award.getInt("remaining_num")<0){
				
				awardNext=MAward.dao.findFirst("select * from m_award where award_type='4' and activity_id=? limit 1",activityId);
				awardNext.set("award_percent", awardNext.getDouble("award_percent")+award.getDouble("award_percent"));
				awardNext.update();
				award.set("award_percent", 0);
			}
			award.update();
			//如果此处谢谢惠顾不是空的，说明抽取到的里面没有了，需要用谢谢惠顾代替原礼品
			award=awardNext==null?award:awardNext;
			//将鲜果币或者优惠券发放到用户的账户下
			TUserAwardRecord awardRecord=new TUserAwardRecord().findOneValidUserAwardRecord(userId, activityId);
			//1鲜果币，2优惠券，3实物奖品，4谢谢惠顾
			if("1".equals(award.getStr("award_type"))){
				int blance=award.getInt("coin_count");
				// 赠送鲜果币,获取后台赠送的鲜果币个数
				Record record = new Record();
				record.set("user_id", userId);
				record.set("blance", blance);
				record.set("ref_type", "jgg_award");
				record.set("create_time", DateFormatUtil.format1(new Date()));
				// 向表中增加一条记录
				Db.save("t_blance_record", record);

				// 给用户鲜果币余额加上所赠送的鲜果币数，此处必须再次查询数据库真实数据，防止内存数据不准
				TUser tUser = new TUser().findById(userId);
				int new_balance =  tUser.getInt("balance") + blance;
				Db.update("update t_user set balance = ? where id = ?", new_balance, userId);
				awardRecord.set("is_get", "1");
			}else if("2".equals(award.getStr("award_type"))){
				//用户返券统一调用返券方法
				int couponValiDate=award.getInt("coupon_vali_date");//优惠券有效期
				int couponCount=award.getInt("coupon_count");//返券张数
				int couponScaleId=award.getInt("coupon_scale_id");//优惠券规模id
				
				Date currentDate=new  Date();//取时间 
			    Calendar   calendar   =   new   GregorianCalendar(); 
			    calendar.setTime(currentDate); 
			    calendar.add(calendar.DATE,couponValiDate);//把日期往后增加x天.整数往后推,负数往前移动 
			    currentDate=calendar.getTime();   //这个时间就是日期往后推一天的结果
				//找到优惠券规模
				TCouponScale couponScale=TCouponScale.dao.findById(couponScaleId);
				// 找到优惠券种类
				
				// 用来保存的优惠券
				TCouponReal couponReal = new TCouponReal();
				couponReal.set("coupon_scale_id", couponScaleId);
				couponReal.set("give_type", 3);// 手动发券
				couponReal.set("coupon_desc", couponScale.get("coupon_desc"));
				couponReal.set("user_gain_times", "/");
				couponReal.set("coupon_val", couponScale.get("coupon_val"));
				couponReal.set("min_cost", couponScale.get("min_cost"));
				couponReal.set("start_time", DateFormatUtil.format1(new Date()));
				
				couponReal.set("end_time", DateFormatUtil.format1(currentDate));
				couponReal.set("status", 1);
				couponReal.set("yxbz", "Y");
				
				//领多张券
				for(int i=0;i<couponCount;i++){
					// 用户优惠券记录
					TUserCoupon userCoupon = new TUserCoupon();
					userCoupon.set("is_expire", 0);
					userCoupon.set("title", couponReal.get("coupon_desc"));
					userCoupon.set("activity_id", activityId);
					// userCoupon.set("order_id", "");
					userCoupon.set("order_type", "/");
					// userCoupon.set("used_order_id", "");
					userCoupon.set("used_order_type", "/");
					userCoupon.set("create_time", new Date());
					userCoupon.set("used_time", "");
					
					couponReal.save();
					userCoupon.set("user_id", userId);
					userCoupon.set("coupon_id", couponReal.get("id"));
					userCoupon.save();
					couponReal.remove("id");
					userCoupon.remove("id");
					
				}
				awardRecord.set("is_get", "1");
			}else if("3".equals(award.getStr("award_type"))){
				awardRecord.set("is_get", "0");
			}else{
				awardRecord.set("is_get", "1");
			}
			//减少用户一次抽奖机会
			awardRecord.set("award_id", award.getInt("id"));
			awardRecord.set("is_valid", "0");
			awardRecord.set("award_time",DateFormatUtil.format1(new Date()));
			awardRecord.update();
			//返回显示抽奖结果
    		result.put("resultCode", true);
    		result.put("msg", award.getStr("award_name"));
    		//我剩余的抽奖次数
    		result.put("awardChance", new TUserAwardRecord().myHaveAwardChance(userId,activityId));
    		//当前抽中的格子
    		result.put("awardSequence", awardSequence);
    		//中奖类型
    		result.put("awardType", award.getStr("award_type"));
    		//获取抽中的奖品图片地址
    		TImage image= TImage.dao.findById(award.getInt("img_id"));
    		String imageUrl=image.getStr("save_string").replaceAll("\\\\", "");
    		result.put("imageUrl", imageUrl);
        	renderJson(result);
    	}else{
    		result.put("resultCode", false);
    		result.put("msg", "您的抽奖机会已用完");
    		renderJson(result);
    		return;
    	}
    }
    /**
     * 我的奖品--F
     */
    @Before(OAuth2Interceptor.class)
    public void myLottery(){
    	//查找所有我的奖品
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	String activityId=getPara("activityId");
    	List<Record> currentUserAwardRecord= new TUserAwardRecord().findCurrentUserAwardRecord(userId,activityId);
    	setAttr("currentUserAwardRecord", currentUserAwardRecord);
    	setAttr("activityId",activityId);
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_mylottery.ftl");
    }
    /**
     * 点击领取
     */
    public void setInvalid(){
    	JSONObject result=new JSONObject();
    	String userAwardRecordId=getPara("id");
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	int userId=tUserSession.get("id");
    	TUserAwardRecord userAwardRecord=TUserAwardRecord.dao.findFirst(
    			"select * from t_user_award_record where user_id=? and id=? and is_get='0' ",userId,userAwardRecordId);
    	if(userAwardRecord==null){
    		result.put("resultCode", false);
    		result.put("msg", "未找到用户领奖记录");
    	}else{
    		userAwardRecord.set("is_get", "1");
    		userAwardRecord.update();
    		result.put("resultCode", true);
    		result.put("msg", "领取成功");
    	}
    	renderJson(result);
    }

    public void test() {
        render(AppConst.PATH_MANAGE_PC + "/client/mobile/codeLottery.ftl");
    }
    
    /***************************************************二维码抽奖***************************************************/
    
    /**
     * 扫二维码链接抽奖页面
     */
    @Before(OAuth2Interceptor.class)
    public void twoCodeLottery(){
    	JSONObject result=new JSONObject();
    	String twoCode=getPara("twoCode");
    	TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		//加载抽奖奖品信息
		List<Record> awardList=MHdAward.dao.findMHdAwardsByActivityId();
		setAttr("awardList",awardList);
		MHdParam hdParam=MHdParam.dao.findFirst("select * from m_hd_param where lottery_code=? ", twoCode);
		if(hdParam!=null){
			if("Y".equals(hdParam.getStr("yxbz"))){
				List<MHdUserAward> isHave=MHdUserAward.dao.find("select * from m_hd_user_award where award_name is null and user_id=?",user.getInt("id"));
				if(isHave.size()==0){
					//用户获取一次抽奖机会
					MHdUserAward userAward=new MHdUserAward();
					userAward.set("user_id", user.get("id"));
					userAward.set("order_id", hdParam.getStr("order_id"));
					userAward.save();
				}
			}else{
				result.put("code", 0);
				result.put("msg", "抽奖码无效！");
			}
		}else{
		    result.put("code", 1);
			result.put("msg", "抽奖码不存在！");
		}
		setAttr("result", result);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/codeLottery.ftl");
    }
    
    /**
     * 转动九宫格获取随机奖品
     */
    @Before(OAuth2Interceptor.class)
    public void getRandomAward(){
    	JSONObject result = new JSONObject();
    	TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		Record isLottery=MHdUserAward.dao.isLotteryCode(user.getInt("id"));//抽奖码是否有效
		if(isLottery!=null){
			//获取九宫格奖品列表
			double number = Math.random();
			int awardSequence=0;
			List<Record> awardList=MHdAward.dao.findMHdAwardsByActivityId();
			if (number >= 0 && number <= awardList.get(0).getDouble("award_percent")/100.0) {
				awardSequence= 0;
			} else if (number >= awardList.get(0).getDouble("award_percent")/100.0 && 
					number <= (awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue())/100.0) {
				awardSequence= 1;
			} else if (number >= (awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue())/100.0
					&& number <= (awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue())/100.0) {
				awardSequence= 2;
			} else if (number >= (awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue())/100.0
					&& number <= (awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue())/100.0) {
				awardSequence= 3;
			} else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue())/100.0){
				awardSequence= 4;
			}else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue()+
					awardList.get(4).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue()+
							awardList.get(5).getDouble("award_percent").intValue())/100.0){
				awardSequence= 5;
			}else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue()+
					awardList.get(4).getDouble("award_percent").intValue()+
					awardList.get(5).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue()+
							awardList.get(5).getDouble("award_percent").intValue()+
							awardList.get(6).getDouble("award_percent").intValue())/100.0){
				awardSequence= 6;
			}else if (number >=(awardList.get(0).getDouble("award_percent").intValue()+
					awardList.get(1).getDouble("award_percent").intValue()+
					awardList.get(2).getDouble("award_percent").intValue()+
					awardList.get(3).getDouble("award_percent").intValue()+
					awardList.get(4).getDouble("award_percent").intValue()+
					awardList.get(5).getDouble("award_percent").intValue()+
					awardList.get(6).getDouble("award_percent").intValue())/100.0
					&&number <=(awardList.get(0).getDouble("award_percent").intValue()+
							awardList.get(1).getDouble("award_percent").intValue()+
							awardList.get(2).getDouble("award_percent").intValue()+
							awardList.get(3).getDouble("award_percent").intValue()+
							awardList.get(4).getDouble("award_percent").intValue()+
							awardList.get(5).getDouble("award_percent").intValue()+
							awardList.get(6).getDouble("award_percent").intValue()+
							awardList.get(7).getDouble("award_percent").intValue())/100.0){
				awardSequence= 7;
			}
			//查找中奖的具体内容
			MHdAward award=MHdAward.dao.findFirst("select * from m_hd_award where award_sequence=? ",awardSequence);
			
			//在用户奖品里加条奖品记录
			MHdUserAward userAward=MHdUserAward.dao.findFirst("select * from m_hd_user_award where user_id=? and award_name is null ", user.getInt("id"));
			MHdUserAward param=new MHdUserAward();
			param.put("user_id", userAward.get("user_id"));
			param.put("award_name", award.getStr("award_name"));
			param.put("award_time", DateFormatUtil.format1(new Date()));
			param.put("expire_time",DateFormatUtil.format5(DateUtil.dayAdd(7)));//过期时间
			param.put("image_id", award.getInt("img_id"));
			TImage image=TImage.dao.findById(award.getInt("img_id"));
			result.put("image_url", image.getStr("save_string"));
			result.put("awardSequence", awardSequence);
			//奖品类型：1鲜果币，2优惠券，3实物奖品，4谢谢惠顾
			if("1".equals(award.getStr("award_type"))){
				param.put("is_get", 0);
				param.put("coin", award.getInt("coin_count"));
				param.put("award_type", 1);
				result.put("coin", award.getInt("coin_count"));
				result.put("award_type", 1);
			}else if("2".equals(award.getStr("award_type"))){
				param.put("is_get", 0);
				param.put("award_type", 2);
				param.put("coupon_scals_id", award.getInt("coupon_scale_id"));
				param.put("coupon_vali_date", award.getInt("coupon_vali_date"));
				TCouponScale scal=TCouponScale.dao.findById(award.getInt("coupon_scale_id"));
				result.put("coupon_val", scal.getInt("coupon_val"));
				result.put("award_type", 2);
			}else if("3".equals(award.getStr("award_type"))){
				param.put("is_get", 0);
				param.put("award_type", 3);
				param.put("pf_id", award.getInt("pf_id"));
				Record re = Db.findFirst("select t.product_name,f.product_amount,u.unit_name from t_product_f f left join t_product t on f.product_id=t.id "
						+ "left join t_unit u  on u.unit_code=f.product_unit where f.id=? ", award.getInt("pf_id"));
				result.put("product_name", re.get("product_name"));
				result.put("product_amount", re.get("product_amount"));
				result.put("unit_name", re.get("unit_name"));
				result.put("award_type", 3);
			}else{
				param.put("award_type", 4);
				result.put("award_type", 4);
			}
			TCouponScale.dao.updateInfo(model2map(param), userAward.getInt("id"), "m_hd_user_award");
			//param.save();
			MHdParam hd_param=MHdParam.dao.findById(isLottery.get("id"));
			hd_param.set("yxbz", "N");
			hd_param.update();
		}else{
			result.put("flag", false);
			result.put("msg", "抽奖码无效！");
		}
		renderJson(result);
    }
    
    /**
     * 我的奖品
     */
    @Before(OAuth2Interceptor.class)
    public void myTwoCodeLottery(){
    	JSONObject result=new JSONObject();
    	TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		List<MHdUserAward> myLotterys=MHdUserAward.dao.find("select t.*,t1.save_string from m_hd_user_award t left join t_image t1 on t.image_id=t1.id "
				+ "where t.award_type not in(4) and t.user_id=? ", user.getInt("id"));
		if(myLotterys.size()>0){
			JSONArray lotterys = ObjectToJson.modelListConvert(myLotterys);
			result.put("lotterys", lotterys);
			result.put("code", 0);
		}else{
			result.put("code", 1);//该用户没有奖品
		}
		setAttr("result", result);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/myLottery.ftl");
    }
    
    /**
     * 点击领取奖品
     */
    @Before(OAuth2Interceptor.class)
    public void receiveGift(){
    	JSONObject result = new JSONObject();
    	String id=getPara("id");
    	TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		if(StringUtil.isNull(user.getStr("phone_num"))){
			//setAttr("id", id);
			//render(AppConst.PATH_MANAGE_PC + "/client/mobile/member_mobile.ftl");
			result.put("receiveId", id);
			result.put("isUser", false);
			result.put("param", 1);//非会员
		}else{
			MHdUserAward userAward=MHdUserAward.dao.findFirst("select * from m_hd_user_award where id=? and user_id=?", id,user.getInt("id"));
			String now = DateFormatUtil.format1(new Date());
			//奖品类型：1鲜果币，2优惠券，3实物奖品，4谢谢惠顾
			if(userAward.getInt("award_type")==1){
				int blance=userAward.getInt("coin");
				// 赠送鲜果币,获取后台赠送的鲜果币个数
				Record record = new Record();
				record.set("user_id", user.getInt("id"));
				record.set("blance", blance);
				record.set("ref_type", "twocode_jgg_award");
				record.set("create_time", DateFormatUtil.format1(new Date()));
				// 向表中增加一条记录
				Db.save("t_blance_record", record);

				// 给用户鲜果币余额加上所赠送的鲜果币数，此处必须再次查询数据库真实数据，防止内存数据不准
				TUser tUser = new TUser().findById(user.getInt("id"));
				int new_balance =  tUser.getInt("balance") + blance;
				Db.update("update t_user set balance = ? where id = ?", new_balance, user.getInt("id"));
				userAward.set("is_get", "1");
				userAward.set("get_time", now);
				userAward.update();
				result.put("award_type", 1);
				result.put("param", 0);
				result.put("msg", "领取成功！");
			}else if(userAward.getInt("award_type")==2){
				TCouponReal couponReal = new TCouponReal();
				couponReal.set("coupon_scale_id", userAward.getInt("coupon_scals_id"));
				TCouponScale scale=TCouponScale.dao.findById(userAward.getInt("coupon_scals_id"));
				couponReal.set("give_type", 4);// 抽奖发券
				couponReal.set("coupon_desc", scale.get("coupon_desc"));
				couponReal.set("user_gain_times", "/");
				couponReal.set("coupon_val", scale.get("coupon_val"));
				couponReal.set("min_cost", scale.get("min_cost"));
				couponReal.set("start_time", DateFormatUtil.format1(new Date()));
				couponReal.set("end_time", DateFormatUtil.format1(DateUtil.dayAdd(userAward.getInt("coupon_vali_date"))));
				couponReal.set("status", 1);
				couponReal.set("yxbz", "Y");
				couponReal.save();
				
				TUserCoupon userCoupon = new TUserCoupon();
				userCoupon.set("is_expire", 0);
				userCoupon.set("title", couponReal.get("coupon_desc"));
				userCoupon.set("order_type", "/");
				userCoupon.set("used_order_type", "/");
				userCoupon.set("create_time", new Date());
				userCoupon.set("used_time", "");
				userCoupon.set("user_id", user.getInt("id"));
				userCoupon.set("coupon_id", couponReal.get("id"));
				userCoupon.save();
				userAward.set("is_get", "1");
				userAward.set("get_time", now);
				userAward.update();
				result.put("award_type", 2);
				result.put("param", 0);
				result.put("msg", "领取成功！");
			}else if(userAward.getInt("award_type")==3){
				result.put("pf_id", userAward.getInt("pf_id"));
				result.put("award_type", 3);
				/*userAward.set("is_get", "1");
				userAward.set("get_time", now);
				userAward.update();*/
				result.put("user_award_id", id);
			}
		}
		renderJson(result);
    }
    
    /**
     * 新用户注册
     */
    public void newUserRegister(){
    	String receiveId = getPara("receiveId");
    	setAttr("receiveId", receiveId);
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/member_mobile.ftl");
    }
    
    /**
     * 实物兑换
     */
    public void lotteryOrder(){
    	int pf_id=getParaToInt("pf_id");
    	int user_award_id=getParaToInt("user_award_id");
    	TProductF productf = TProductF.dao.findFirst("select ifnull(special_price,price) as real_price,product_id,id from t_product_f where id=?  ",pf_id);
		String pro="[{'product_id':" + productf.getInt("product_id") + ",'product_num':'1','pf_id':" + productf.getInt("id") + ",'real_price':"+productf.getInt("real_price")+"}]";
		setAttr("proList", pro);
		setAttr("storeId",getCookie("store_id")==null?"07310109":getCookie("store_id"));
		List<Record> storeList = new TStore().findStores();
		setAttr("storeList", storeList);
		setAttr("user_award_id", user_award_id);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/lotteryOrder.ftl");
    }
    
    /**
	 * 提货订单提交
	 * 
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void cjOrderCmt() throws UnsupportedEncodingException {
		String now = DateFormatUtil.format1(new Date());
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		int user_award_id = getParaToInt("user_award_id");
		TOrder order = getModel(TOrder.class, "order");
		Record record = new Record();
		record.setColumns(model2map(order));
		record.set("createtime", now);
		String proList = getPara("proList");
		 int totalPrice = 0;// 商品总金额
		List<Map<String, Object>> orderProducts = new ArrayList<Map<String, Object>>();
		int need_pay = 0;
		int price=0;
		if (StringUtil.isNotNull(proList)) {
			JSONArray cartInfoJson = JSONArray.parseArray(proList);

			for (int i = 0; i < cartInfoJson.size(); i++) {
				JSONObject item = cartInfoJson.getJSONObject(i);
				int product_id = item.getInteger("product_id");
				double productNum = item.getDouble("product_num");
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("productId", product_id);
				map.put("productNum", productNum);
				map.put("pf_id", item.getInteger("pf_id"));
				price=(int) (item.getInteger("real_price") * productNum);
				need_pay += (int) (item.getInteger("real_price") * productNum);
				// 此处修改为单价的 writeBy yj
				map.put("unitPrice", price);
				orderProducts.add(map);
			}
		} else {
			return;
		}
		totalPrice=need_pay;
		record.set("order_user", userId);
		 record.set("total", totalPrice);
		record.set("order_id", orderNoGenerator.nextId());
		record.set("order_status", "3");
		record.set("order_type", "1");//兑换类型
		record.set("need_pay", need_pay);
		record.set("order_style", 2);//
		Db.save("t_order", record);
		long id = record.getLong("id");
		for (Map<String, Object> pro : orderProducts) {
			Record orderPro = new Record();
			orderPro.set("order_id", id);
			orderPro.set("product_id", pro.get("productId"));
			orderPro.set("amount", pro.get("productNum"));
			orderPro.set("unit_price", pro.get("unitPrice"));//这里有问题
			orderPro.set("product_f_id", pro.get("pf_id"));
			// orderPro.set("buy_time", now);
			Db.save("t_order_products", orderPro);
		}
		setAttr("id",id);
		setAttr("user_award_id", user_award_id);
		txSuccess();
	}
	
	/**
	 * 提货成功页
	 * 
	 * @throws UnsupportedEncodingException
	 */
	//@Before(OAuth2Interceptor.class)
	public void txSuccess() throws UnsupportedEncodingException {
		long id = (Long)getAttr("id");// getParaToLong("id");
	    int user_award_id = getParaToInt("user_award_id");
	    String now = DateFormatUtil.format1(new Date());
	    MHdUserAward userAward=MHdUserAward.dao.findById(user_award_id);
	    userAward.set("is_get", "1");
	    userAward.set("get_time", now);
	    userAward.update();//实物改成已领取
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		Record order = new TOrder().findTOrderDetail(id, userId);
		setAttr("order", order);
		//removeCookie("basketInfo");
		logger.info("===========仓库提货海鼎减商品库存start==============");
		String orderId = order.getStr("order_id");
		if (HdUtil.orderReduce(orderId)) {
			Db.update("update t_order set hd_status = '0' where order_id = ?", orderId);
		} else {
			// 发送消息给指定的管理员
			TIndexSetting setting = new TIndexSetting();
			Map<String, String> map = setting.getIndexSettingMap();
			PushUtil.sendMsgToManager(map.get("managerPhone"), orderId);
			Db.update("update t_order set hd_status = '1' where order_id = ?", orderId);
		}
		logger.info("===========仓库提货海鼎减商品库存end==============");
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/successPay.ftl");
	}
    
	/***************************************************二维码抽奖***************************************************/
}
