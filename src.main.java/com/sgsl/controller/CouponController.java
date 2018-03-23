package com.sgsl.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MActivity;
import com.sgsl.model.TCouponReal;
import com.sgsl.model.TImage;
import com.sgsl.model.TUser;
import com.sgsl.model.TUserCoupon;
import com.sgsl.util.DateUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;

/**
 * 
 * @author yjw 优惠券
 */
public class CouponController extends BaseController{

	protected final static Logger logger = Logger.getLogger(CouponController.class);
	
	/**
     * H5页主动发券活动入口
     */
	@Before(OAuth2Interceptor.class)
    public void sendCoupon(){
    	MActivity activity=MActivity.dao.findById(getPara("acid"));
    	if(activity.getInt("img_id")!=null){
    		TImage image=TImage.dao.findById(activity.getInt("img_id"));
    		setAttr("activity_image", image.getStr("save_string"));//活动图片
    	}
    	TUser tUserSession = UserStoreUtil.get(getRequest());
    	if(StringUtil.isNotNull(activity.getStr("receive_code"))){
    		setAttr("isCode",0);
    	}
    	setAttr("user_id", tUserSession.get("id"));
    	setAttr("activity_id",  getPara("acid"));//活动id
    	render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_sendcoupon.ftl");
    }
	
	/**
	 * 口令验证
	 */
	public void confirmation(){
		String code=getPara("code");
		JSONObject result = new JSONObject();
		
		//判断输入口令是否为空
		if(StringUtil.isNull(code)){
			result.put("success", false);
			result.put("msg", "口令不能为空！");
			renderJson(result);
			return;
		}
		
	    //TODO 更严谨点需要判断activity_id是否为空 可能有空指针异常
		int activity_id=getParaToInt("activity_id");
		MActivity activity=MActivity.dao.findById(activity_id);
		
		if(activity==null){
			result.put("success", false);
			result.put("msg", "活动不存在！");
			renderJson(result);
			return;
		}
		
		if(activity.getStr("yxbz").equals("N")){
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    	String currentTime = df.format(new Date());//当前时间
	    	String startTime=df.format(activity.getDate("yxq_q"));
	    	String endTime=df.format(activity.getDate("yxq_z"));
	    	
			//当前时间小于有效期起
			if(currentTime.compareTo(startTime)<0){
				result.put("success", false);
				result.put("msg", "活动未开启！");
				renderJson(result);
				return;
			}
			
			//当前时间大于有效期止
			if(currentTime.compareTo(endTime)>0){
				result.put("success", false);
				result.put("msg", "活动已结束！");
				renderJson(result);
				return;
			}
			
			//活动区间内手动修改状态为N 紧急下架情况
			if(currentTime.compareTo(startTime)>=0 &&
			   currentTime.compareTo(endTime)<=0){
				result.put("success", false);
				result.put("msg", "活动已失效！");
				renderJson(result);
				return;
			}
		}
		
		if(!code.equals(activity.getStr("receive_code"))){
			result.put("success", false);
			result.put("msg", "您输入的口令有误，请重新输入！");
			renderJson(result);
			return;
		}
		
		result.put("success", true);
		renderJson(result);
	}
	
	/**
	 * 用户领取优惠券
	 * @throws UnsupportedEncodingException 
	 */
	public void receiveCoupon() throws UnsupportedEncodingException{
		int activity_id=getParaToInt("activity_id");
		int user_id=getParaToInt("userId");
		TUser user = TUser.dao.findTUserInfo(user_id);
		JSONObject result=new JSONObject();
		result.put("user_img_id", user.get("user_img_id"));//用户头像	
		//判断用户是否有手机号码
		if(StringUtil.isNull(user.getStr("phone_num"))){
			setAttr("flag", 1);//发券活动链到注册页的标志
			setAttr("activity_id", activity_id);
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/member_mobile.ftl");
		}else{
			//TODO(可能要传有效的活动id)查询活动是否有效
			MActivity activity = MActivity.dao.findById(activity_id);
			if(activity!=null){
				//该活动下的优惠券礼包
				List<Record> couponCategorys = Db.find("select * from t_coupon_category where activity_id=? ",activity.getInt("id"));
				//判断用户是否领取过优惠券
				List<Record> isReceive = Db.find("select uc.* from t_user_coupon uc left join t_coupon_real cr on uc.coupon_id=cr.id "
						+ "left join t_coupon_category cc on cr.coupon_category_id=cc.id where uc.user_id=? and uc.activity_id=?", user.getInt("id"),activity_id);
				int user_receive_num=activity.getInt("user_receive_num");
				int coupon_max_mum=(couponCategorys.size())*user_receive_num;//优惠券最大领取数量
				//TODO 用户限领次数是否已达到优惠券最大领取数
				if(isReceive.size()>=coupon_max_mum){
					//url="/coupon/activityGetcoupon?status=2";
					//redirect(url, true);
					result.put("status", 2);
					setAttr("result", result);
					render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_getcoupon.ftl");
					return;
				}else{
					//TODO 是否限制优惠券的数量(1.限制了数量,2.无数量限制)
					if(activity.getInt("coupon_isLimt")==1){//限制了数量
						if(activity.getInt("coupon_count")>0){//领取码使用次数限制一定要大于零才可以领取
							activity.set("coupon_count", activity.getInt("coupon_count")-1);//优惠券数量减1
							activity.update();
						}else{
							/*url="/coupon/activityGetcoupon?status=1";
							redirect(url, true);
							return;*/
							result.put("status", 1);
							setAttr("result", result);
							render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_getcoupon.ftl");
							return;
						}
					}
					
					TCouponReal tCouponReal = new TCouponReal();
					TUserCoupon tUserCoupon = new TUserCoupon();
					Date now=new Date();
					//当前领取时间加上有效期时间即为优惠券有效期
					int yxq=Integer.parseInt(activity.getStr("yxq"));
					String validateTime=DateFormatUtil.format1(DateUtil.dayAdd(yxq));
					for(Record couponCategory:couponCategorys){
						tCouponReal.set("activity_id", activity.getInt("id"));
						tCouponReal.set("coupon_category_id", couponCategory.getInt("id"));
						tCouponReal.set("give_type", 3);
						tCouponReal.set("coupon_desc", couponCategory.get("coupon_desc"));
						tCouponReal.set("user_gain_times", couponCategory.get("user_gain_times"));
						Record couponScale = Db.findFirst("select *from t_coupon_scale where id=? ", couponCategory.getInt("coupon_scale_id"));
						tCouponReal.set("coupon_val", couponScale.get("coupon_val"));
						tCouponReal.set("min_cost", couponScale.get("min_cost"));
						tCouponReal.set("single_use", 0);
						tCouponReal.set("other_use", 0);
						tCouponReal.set("start_time", DateFormatUtil.format1(now));
						tCouponReal.set("end_time", validateTime);
						tCouponReal.set("status", 1);
						tCouponReal.set("yxbz", "Y");
						tCouponReal.set("coupon_scale_id", couponCategory.getInt("coupon_scale_id"));
						tCouponReal.save();//添加一条有效可领取的优惠券
						
						tUserCoupon.set("user_id", user.getInt("id"));
						tUserCoupon.set("coupon_id", tCouponReal.getInt("id"));
						tUserCoupon.set("is_expire", 0);
						tUserCoupon.set("title", couponCategory.get("coupon_desc"));
						tUserCoupon.set("activity_id", activity.get("id"));
						tUserCoupon.set("create_time", DateFormatUtil.format1(new Date()));
						tUserCoupon.save();//用户领取优惠券
						tCouponReal.remove("id");
						tUserCoupon.remove("id");
					}
					JSONArray data=ObjectToJson.recordListConvert(couponCategorys);
					JSONObject real=new JSONObject();
					real.put("start_time", DateFormatUtil.format1(now));
					real.put("end_time", validateTime);
					real.put("data", data);
					result.put("couponCategorys", real);
					result.put("status", 0);
					result.put("useUrl", activity.getStr("use_url"));
				}
			}else{
				result.put("status", 3); //没有此活动
			}
			setAttr("result", result);
			render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_getcoupon.ftl");
		}
		
	}
	
	/**
	 * 领取成功刷新界面(暂且不用)
	 * @throws UnsupportedEncodingException 
	 */
	public void activityGetcoupon() throws UnsupportedEncodingException{
		int status = getParaToInt("status");
		JSONObject result=new JSONObject();
		result.put("status", getParaToInt("status"));//成功状态
		TUser tUserSession = UserStoreUtil.get(getRequest());
		TUser user = TUser.dao.findTUserInfo(tUserSession.get("id"));
		result.put("user_img_id", user.get("user_img_id"));//用户头像	
		if(status==0){
			String couponCategorys=getPara("couponCategorys");
			JSONObject couponCategoryJson=JSONObject.parseObject(URLDecoder.decode(couponCategorys, "UTF-8"));
			System.out.println(couponCategoryJson.toJSONString());
			result.put("couponCategorys", couponCategoryJson);
		}
		setAttr("result", result);
		render(AppConst.PATH_MANAGE_PC + "/client/mobile/activity_getcoupon.ftl");
	}
	
	
    
}
