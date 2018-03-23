package com.xgs.controller;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import javax.imageio.ImageIO;
import org.apache.log4j.Logger;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.util.Base64;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.TUser;
import com.sgsl.util.DateUtil;
import com.sgsl.util.PushUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.swetake.util.Qrcode;
import com.xgs.model.TOrder;
import com.xgs.model.XAchievementRecord;
import com.xgs.model.XApplyMoney;
import com.xgs.model.XBonusPercentage;
import com.xgs.model.XFruitApply;
import com.xgs.model.XFruitMaster;
import com.xgs.model.XMasterUser;

public class FruitMasterController extends BaseController {
	protected final static Logger logger = Logger.getLogger(FruitMasterController.class);

	/**
	 * 鲜果师申请
	 */
	@Before(OAuth2Interceptor.class)
	public void fruitregister() {
		Map<String, Object> result = new HashMap<String, Object>();
		String verifyCode = getPara("authCode");
		String sessionVerify = getSessionAttr("verifyCode");
		if(sessionVerify==null){
			result.put("result", "failed");
			result.put("msg", "请先点击获取验证码！");
			renderJson(result);
		}else{
			if(verifyCode.equals(sessionVerify)){
				String master_name = getPara("xFruitMaster.master_name");
				String master_recommend=getPara("xFruitMaster.master_recommend");
				System.out.println("======="+master_recommend);
				Map<String, Object> masterMap = new HashMap<>();
				TUser tUserSession = UserStoreUtil.get(getRequest());
				int userId = tUserSession.get("id");
				XFruitMaster xFruitMaster = new XFruitMaster();
				if(StringUtil.isNotNull(master_recommend)){
					xFruitMaster.set("master_recommend", master_recommend);
				}
				xFruitMaster.set("master_name", master_name);
				xFruitMaster.set("user_id", userId);
				masterMap.put("master_name", master_name);
				
				XFruitApply xFruitApply = getModel(XFruitApply.class, "xFruitApply");
				Record record = new Record();
				record.setColumns(model2map(xFruitApply));
				if (StringUtil.isNull(getPara("xFruitMaster.id"))) {
					String now = DateFormatUtil.format1(new Date());
					xFruitMaster.set("create_time", now);
					xFruitMaster.set("master_status", 0);
					xFruitMaster.save();
					record.set("master_id", xFruitMaster.get("id"));
					Db.save("x_fruit_apply", record);
				} else {
				   // xFruitMaster.set("master_status", 0);
				    masterMap.put("master_status", 0);
					xFruitMaster.updateMaster(masterMap, getParaToInt("xFruitMaster.id"),"x_fruit_master");
					xFruitMaster.updateMaster(model2map(xFruitApply), getParaToInt("xFruitApply.id"), "x_fruit_apply");
				}
				result.put("result", "success");
				result.put("status", xFruitMaster.getInt("master_status"));
				renderJson(result);
			}else{
				result.put("result", "failed");
				result.put("msg", "验证码错误！");
				renderJson(result);
			}
		}
	}

	/**
	 * 获取成为鲜果师注册验证码
	 */
	@Before(OAuth2Interceptor.class)
	public void getVerifyCode() {
		TUser tUserSession = UserStoreUtil.get(getRequest());
		int userId = tUserSession.get("id");
		String phone_num = getPara("phone_num");
		XFruitMaster master = XFruitMaster.dao.findFirst("select a.mobile,m.user_id,m.master_status,m.master_name from x_fruit_master m "
				+ "LEFT JOIN x_fruit_apply a on m.id=a.master_id left join t_user u on u.id=m.user_id "
				+ "where m.master_status=2 and a.mobile='"+phone_num+"' and m.user_id=? ", userId);
		Map<String, String> result = new HashMap<String, String>();
		if (master == null || master.getInt("master_status")==2 ) {
			System.out.println(phone_num);
			int verifyNum = 0;
			if (getSessionAttr("verifyNum") != null) {
				verifyNum = getSessionAttr("verifyNum");
			}
			if (verifyNum >= 5) {
				result.put("result", "failed");
				result.put("msg", "超过发送限制");
			} else {
				Map<String, String> map = PushUtil.sendMsgToUser(phone_num, "美味食鲜");
				if ("success".equals(map.get("status"))) {
					setSessionAttr("verifyCode", map.get("verifyCode"));
					result.put("result", "success");
					setSessionAttr("verifyNum", verifyNum + 1);
				} else {
					result.put("result", "failed");
					result.put("msg", "系统发送短信中，请稍等！");
				}

			}
		} else {
			result.put("result", "failed");
			result.put("msg", "手机号已存在！");
		}

		renderJson(result);
	}

	/**
	 * 鲜果师推广二维码
	 * 
	 * @throws IOException
	 */
	public void printTwoBarCode() throws IOException {
		// 关注鲜果师二维码
		// 鲜果师id
		String master_id = getPara("master_id");
		if (StringUtil.isNull(master_id)) {
			renderNull();
		}
		String url=AppProps.get("app_domain")+"mall/shopIndex";
		if(getParaToBoolean("recommend")){
			// 推广客户成为鲜果师
			url = AppProps.get("app_domain") + "/fruitmaster/masterIndex?master_recommend=" + getPara("master_recommend");
		}else{
			// 鲜果师商城推广链接，用作吸收客户粉丝
			url = AppProps.get("app_domain") + "/mall/shareShopIndex?master_id=" + master_id;
		}
		// 制作二维码
		Qrcode testQrcode = new Qrcode();
		testQrcode.setQrcodeErrorCorrect('M');
		testQrcode.setQrcodeEncodeMode('B');
		testQrcode.setQrcodeVersion(7);
		byte[] d = url.getBytes("gbk");
		BufferedImage image = new BufferedImage(98, 98, BufferedImage.TYPE_BYTE_BINARY);
		Graphics2D g = image.createGraphics();
		g.setBackground(Color.WHITE);
		g.clearRect(0, 0, 98, 98);
		g.setColor(Color.BLACK);
		if (d.length > 0 && d.length < 120) {
			boolean[][] s = testQrcode.calQrcode(d);
			for (int i = 0; i < s.length; i++) {
				for (int j = 0; j < s.length; j++) {
					if (s[j][i]) {
						g.fillRect(j * 2 + 3, i * 2 + 3, 2, 2);
					}
				}
			}
		}
		g.dispose();
		image.flush();
		ImageIO.write(image, "jpg", getResponse().getOutputStream());
		renderNull();
	}

	/**
	 * 关注鲜果师（绑定）
	 */
	public static void bindingMaster(int user_id, int master_id) {
		// 看用户是否绑定
		XMasterUser user = XMasterUser.dao.findFirst("select * from x_master_user where user_id = ?",user_id);
		
		if (user != null) {// 找到记录说明已经绑定，不执行下面操作
			return;
		}
		logger.info("====有用户绑定鲜果师====");
		// 关联到鲜果师
		XMasterUser xuser = new XMasterUser();
		xuser.addXMasterUser(master_id, user_id);
	}

	/**
	 * 分享链接进入鲜果师商城
	 */
	@Before(OAuth2Interceptor.class)
	public void enterMasterIndex() {
		if(StringUtil.isNotNull(getPara("master_id"))){//master_id不为空的时候说明是鲜果师分享出来的链接，此时需要
			int master_id = getParaToInt("master_id");
			TUser tUserSession = UserStoreUtil.get(getRequest());
			// 绑定鲜果师
			FruitMasterController.bindingMaster(tUserSession.getInt("id"), master_id);
		}
		// 可能会报空指针
		if (StringUtil.isNotNull(getPara("product_id"))) {
			// 如果带有商品id则跳转到商品详情页
			redirect(AppProps.get("app_domain") +  "/mall/foodDetail?product_id=" + getParaToInt("product_id") + "&product_fid=" + getParaToInt("product_fid"));
		} else if (StringUtil.isNotNull(getPara("article_id"))) {
			// 如果带有文章id则跳转到文章详情页
			redirect(AppProps.get("app_domain") + "/mall/articleDetail?article_id=" + getParaToInt("article_id"));
		}
	}
	
	/**
	 * 提交申请后回调方法
	 */
	public void sbtCallbackSuccess(){
		JSONObject mes = new JSONObject();
		mes.put("master_status", 0);
		mes.put("message", "审核中，会在1~3工作日内给您答复哦~");
		setAttr("result", mes);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/applyInform.ftl");
	}

	/**
	 * 鲜果师后台首页信息
	 */
	@Before(OAuth2Interceptor.class)
	public void masterIndex() {
		
		int user_id = UserStoreUtil.get(getRequest()).getInt("id");
		//TODO 需要取消屏蔽
		/*XFruitMaster master = UserStoreUtil.getFruitMaster(getRequest());
		if (master == null) {// 不是鲜果师，直接进入鲜果师申请界面
			XFruitMaster xFruitMaster=new XFruitMaster();
			//如果该用户没有跟任何鲜果师绑定，则绑定
			if(StringUtil.isNotNull(getPara("master_recommend"))){//没有推荐码说明是自己点击的申请，此时不绑定
				FruitMasterController.bindingMaster(user_id, getParaToInt("master_recommend"));
			}
			xFruitMaster.set("master_recommend", getPara("master_recommend"));//推荐鲜果师的id
			setAttr("masterDetail", xFruitMaster);
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterApply.ftl");
			return;
		}
		// 鲜果师个人信息
		int master_id = master.getInt("id");
		int master_status = master.getInt("master_status");// 鲜果师状态
		JSONObject mes = new JSONObject();
		mes.put("mes_status", "success");
		if (master_status == 0) {// 鲜果师申请
			mes.put("master_status", 0);
			mes.put("message", "审核中，会在1~3工作日内给您答复哦~");
			setAttr("result", mes);
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/applyInform.ftl");
		} else if (master_status == 1) {// 鲜果师申请通过，待培训
			mes.put("master_status", 1);
			mes.put("message", "您的申请已经通过，工作人员会在1日内与您取得联系，您也可主动联系我们的工作人员~");
			setAttr("result", mes);
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/applyInform.ftl");
		}else if(master_status == 2){
			XFruitApply xFruitApply = XFruitApply.dao.findFirst("select * from x_fruit_apply where master_id=? ", master_id);
			setSessionAttr("verifyCode", null);
			mes.put("reason", xFruitApply.get("cause"));
			mes.put("master_id", master_id);
			mes.put("master_status", 2);
			mes.put("message", "申请失败了哦~");
			setAttr("result", mes);
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/applyInform.ftl");
		}else if (master_status == 3) {// 鲜果师通过培训成为真正的鲜果师
			// 将鲜果师信息放入json对象中
			JSONObject master_info = ObjectToJson.modelConvert(master);
			// 单日交易订单数及总金额
			Record oneDay = XFruitMaster.dao.findOneDayStatisticByMasterId(master_id);
			master_info.put("today_amount", oneDay.get("order_numbers"));
			master_info.put("today_total", oneDay.get("order_total"));
			// 总交易额
			Record total = XFruitMaster.dao.findTotalByMasterId(master_id);
			master_info.put("all_total", total.get("total"));

			setAttr("master_info", JSONObject.toJSONString(master_info));
			render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterIndex.ftl");
		}else if(master_status == 4){
		    mes.put("master_status", 4);
            mes.put("message", "您的鲜果师资格已被停用，若有疑问，请电话咨询客服中心");
            setAttr("result", mes);
            render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/applyInform.ftl");
		}
		*/
	}
	
	/**
	 * 编辑鲜果师页面
	 */
	public void masterDetail(){
		int id = getParaToInt("id");
		List<Record> masterDetailList=XFruitMaster.dao.findmasterDetailById(id);
		JSONObject masterDetail = new JSONObject();
		for(Record rc:masterDetailList){
			masterDetail.put("id", rc.get("id"));
			masterDetail.put("master_name", rc.get("master_name"));
			masterDetail.put("mobile", rc.get("mobile"));
			masterDetail.put("idcard", rc.get("idcard"));
			masterDetail.put("idcard_face", rc.get("idcard_face"));
			masterDetail.put("idcard_opposite", rc.get("idcard_opposite"));
			masterDetail.put("qualification", rc.get("qualification"));
			masterDetail.put("apply_id", rc.get("apply_id"));
		}
		setAttr("masterDetail", masterDetail);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterApply.ftl");
	}


	/**
	 * 鲜果师信息
	 */
	public void masterInfo() {
		int master_id = getParaToInt("master_id");
		XFruitMaster msterInfo = XFruitMaster.dao.findXFruitMasterById(master_id);
		JSONObject masterInfoJson = ObjectToJson.modelConvert(msterInfo);
		setAttr("masterInfo", JSONObject.toJSONString(masterInfoJson));
		System.out.println("=====" + JSONObject.toJSONString(masterInfoJson));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterInfo.ftl");

	}

	/**
	 * 鲜果师修改个人简介
	 */
	public void updateMasterDescription() {
		String description = getPara("description");
		JSONObject result = new JSONObject();
		int master_id = getParaToInt("master_id");
		// 修改鲜果师信息
		Map<String, Object> columnInfo = new HashMap<String, Object>();
		columnInfo.put("description", description);
		int row = XFruitMaster.dao.updateMaster(columnInfo, master_id,"x_fruit_master");
		if(row>0){
			result.put("msg", "修改成功");
		}else{
			result.put("msg", "修改失败");
		}
		renderJson(result);
	}

	/**
	 * 鲜果师修改个人照片
	 */
	public void updateMasterPhoto() {
       logger.info("========开始上传照片=========");    
        int masterId = getParaToInt("master_id");    
        Map<String,Object> map = new HashMap<String,Object>();
        String ret_fileName = null;// 返回给前端已修改的图片名称    
        String savePath = AppProps.get("filePath") + "/resource/image/master_headImg/";
        logger.info("上传地址=====:"+savePath);
		// 文件保存目录URL
		//String saveUrl = getRequest().getContextPath() + "/resource/fruitmaster/headImg";
        String base64Img = getPara("head_image");    
        // 临时文件路径    
        File file_normer = new File(savePath);    
        if (!file_normer.exists()) {    
            file_normer.mkdirs();    
        }    
        if (base64Img == null){// 图像数据为空      
			renderJson("请选择图片");
			return;
		}
		base64Img = base64Img.replaceAll("data:image/jpeg;base64,", "");      
        try {      
            // Base64解码      
            byte[] b = Base64.decodeFast(base64Img);      
            for (int i = 0; i < b.length; ++i) {      
                if (b[i] < 0) {// 调整异常数据      
                    b[i] += 256;      
                }      
            }      
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
			String newFileName = df.format(new Date()) + "_" + new Random().nextInt(1000) ;

            // 生成jpeg图片      
            ret_fileName = new String((newFileName+".jpg").getBytes("gb2312"), "ISO8859-1" ) ;     
            
            File file = new File(savePath+ret_fileName);   

            file.createNewFile();
            	
            OutputStream out = new FileOutputStream(file);     
            
            out.write(b);      
            out.flush();      
            out.close();    
            map.put("head_image", "/weixin/resource/image/master_headImg/"+ret_fileName);
            int result = XFruitMaster.dao.updateMaster(map,masterId,"x_fruit_master");
            if(result>0){// 将已修改的图片url对应的id返回前端    
            	map.put("msg","上传图片成功");
            	renderJson(map);
            }else{
            	map.clear();
            	map.put("msg","上传图片失败");
            	renderJson(map);
            }
        } catch (Exception e) {      
            e.printStackTrace();
            logger.error("======上传失败======");
            map.clear();
        	map.put("msg","上传图片失败");
        }      
        logger.info("======上传结束======");
        renderJson(map);
    }    

	/**
	 * 进入鲜果师业绩页
	 */
	@Before(OAuth2Interceptor.class)
	public void achievement() {
		// 订单成交总数为已付款，已收获，已完成
		int user_id = UserStoreUtil.get(getRequest()).getInt("id");
		int master_id = getParaToInt("master_id");
		int days = getParaToInt("days");
		JSONObject orders = new JSONObject();
		// 分红比例
		XBonusPercentage bonusPercentage = XBonusPercentage.dao.findXBonusPercentage();
		// 分红收入
		if(days==2){//昨日的
			Record twodaysOrder = TOrder.dao.statisticsOrderByDays(master_id,2);
			Record todayOrder = TOrder.dao.statisticsOrderByDays(master_id,1);
			
			orders.put("order_count", twodaysOrder.getLong("count")-todayOrder.getLong("count"));//订单总数
			int order_total = Integer.parseInt(twodaysOrder.get("total").toString())-Integer.parseInt(todayOrder.get("total").toString());
			orders.put("order_total", order_total);//订单总金额
			double bonus =(bonusPercentage.getInt("sale_percentage")
					*order_total)/100.0;
			orders.put("bonus", bonus);//实际收入
		
		}else{
			// 7/30/90天订单的总数
			Record order_result = TOrder.dao.statisticsOrderByDays(master_id,days);
			double bonus = (bonusPercentage.getInt("sale_percentage")
					* Integer.parseInt(order_result.get("total").toString()))/100.0 ;
			orders.put("order_count", order_result.get("count"));//订单总数
			orders.put("order_total", order_result.get("total"));//订单总金额
			orders.put("bonus", bonus);//实际收入
		}
		// 统计的订单业绩, 每一天统计的集合
		List<Map<String, Object>> order_count = statisticAchievement(master_id, days);
		orders.put("order_list",order_count);
		orders.put("days",days);
		orders.put("master_id", master_id);
		setAttr("orders", JSONObject.toJSONString(orders));
		System.out.println("----"+JSONObject.toJSONString(orders));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterStatistic.ftl");
	}

	/**
	 * 鲜果师业绩统计 
	 */
	@Before(OAuth2Interceptor.class)
	public void achievementAjax() {
		// 订单成交总数为已付款，已收获，已完成
		int user_id = UserStoreUtil.get(getRequest()).getInt("id");
		int master_id = getParaToInt("master_id");
		int days = getParaToInt("days");
		JSONObject orders = new JSONObject();
		// 分红比例
		XBonusPercentage bonusPercentage = XBonusPercentage.dao.findXBonusPercentage();
		if(days==2){//昨日的
			Record twodaysOrder = TOrder.dao.statisticsOrderByDays(master_id,2);
			Record todayOrder = TOrder.dao.statisticsOrderByDays(master_id,1);
			
			orders.put("order_count", twodaysOrder.getLong("count")-todayOrder.getLong("count"));//订单总数
			int order_total = Integer.parseInt(twodaysOrder.get("total").toString())-Integer.parseInt(todayOrder.get("total").toString());
			orders.put("order_total", order_total);//订单总金额
			double bonus =(bonusPercentage.getInt("sale_percentage")
					*order_total)/100.0;
			orders.put("bonus", bonus);//实际收入
		}else{
			// 7/30/90天订单的总数
			Record order_result = TOrder.dao.statisticsOrderByDays(master_id, days);
			// 分红收入
			int bonus = bonusPercentage.getInt("sale_percentage")
					* Integer.parseInt(order_result.get("total").toString()) / 100;
			orders.put("order_count", order_result.get("count"));//订单总数
			orders.put("order_total", order_result.get("total"));//订单总金额
			orders.put("bonus", bonus);//实际收入
		}
		// 统计的订单业绩, 每一天统计的集合
		List<Map<String, Object>> order_count = statisticAchievement(master_id, days);
		orders.put("order_list",order_count);
		orders.put("days",days);
		orders.put("master_id", master_id);
		renderJson(orders);
	}

	/**
	 * 鲜果师业绩统计
	 */
	public List<Map<String, Object>> statisticAchievement(int master_id, int days) {

		// 所有要统计的订单
		List<TOrder> orders = TOrder.dao.findAllOrderByDays(master_id, days);
		// 设置当前时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");// 设置日期格式
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(new Date());
		calendar.add(calendar.DATE, -days+1);// n天前
		String time = df.format(calendar.getTime());// 某一天时间
		
		Map<String, Object> map = null;
		List<Map<String, Object>> order_count = new ArrayList<Map<String, Object>>();
		double total = 0.0;// 交易总金额
		int count = 0;// 订单总数

		if (orders.size() == 0) {// 鲜果师无业绩
			for (int i = 1; i <= days; i++) {
				if (days == 2) {// 查看昨日数据
					time = df.format(calendar.getTime());// 格式化时间
					if (i == 1) {// 查看昨日数据，只添加昨日数据，不要今日数据
						map = new HashMap<String, Object>();
						map.put("time", time.substring(5, time.length()));// 支付时间
						map.put("count", count);// 订单数量
						map.put("total", total);// 交易总价
						order_count.add(map);
					}
					calendar.add(calendar.DATE, +1);// 1天后
					continue;
				}
				map = new HashMap<String, Object>();
				time = df.format(calendar.getTime());// 格式化时间
				map.put("time", time.substring(5, time.length()));// 支付时间
				map.put("count", count);// 订单数量
				map.put("total", total);// 交易总价
				calendar.add(calendar.DATE, +1);// 1天后
				order_count.add(map);
			}

			return order_count;// 返回每天的交易都是0
		}

		String today = time;
		// 统计每一天成功的订单数和销售额
		for (int i = 1; i <= days; i++) {
			time = df.format(calendar.getTime());// 格式化时间
			// 方法一：效率低，每次循环都要遍历所有
			// for (TOrder tOrder : orders) {//统计一天的数据
			// if(time.equals(tOrder.getStr("pay_time"))){
			// count++;//满足的订单数累加
			// total+=tOrder.getDouble("need_pay")/100.0;//满足的订单金额累加
			// //FIXME 移除次订单,这样集合会越来越小，速度也会快（？？？是否会导致集合变小，数据出错？？？）
			// //当没有匹配的时间就跳过循环
			// }
			// }
			// 方法二：效率高，每次循环只有满足条件的记录+1
			TOrder tOrder = null;
			Iterator<TOrder> iterator = orders.iterator();
			while (iterator.hasNext()) {// 统计一天的数据
				tOrder = iterator.next();
				if (time.equals(tOrder.getStr("pay_time"))) {
					count++;// 满足的订单数累加
					total += tOrder.getInt("need_pay");// 满足的订单金额累加
					iterator.remove();// 加完后移除该元素
					continue;// 数据已经按照时间排序，只要有一个不匹配,后面的也不会匹配
				}
			}
			// 只查看昨日数据时，不添加今天的数据
			if (days == 2) {
				if (i == 1) {
//					System.out.println("==========第几次：" + i);
					map = new HashMap<String, Object>();
					map.put("time", time.substring(5, time.length()));
					map.put("count", count);
					map.put("total", total);
					order_count.add(map);// 添加到集合中
				}
				total = 0.0;// 重新统计
				count = 0;// 重新统计
				calendar.add(calendar.DATE, +1);// 1天后
			} else {
				map = new HashMap<String, Object>();
				map.put("time", time.substring(5, time.length()));
				map.put("count", count);
				map.put("total", total);
				order_count.add(map);// 添加到集合中
				total = 0.0;// 重新统计
				count = 0;// 重新统计
				calendar.add(calendar.DATE, +1);// 1天后

			}
		}
		return order_count;
	}

	/**
	 * 收支明细
	 */
	// 完成退货的时候,定时任务需要在业绩表中增加一条记录
	public void inOutDetail() {
		int master_id = getParaToInt("master_id");// 鲜果师ID
		int inout_type = getParaToInt("inout_type");// 收支类型 1收入；2支出
		int pageNumber = getParaToInt("pageNumber");// 第几页
		int pageSize = getParaToInt("pageSize");// 每一页的数量
		// 查询收支明细 最多90天
		List<XAchievementRecord> records = inOutDetailByType(pageNumber, pageSize, master_id, inout_type);
		JSONArray recordArr = ObjectToJson.modelListConvert(records);
		setAttr("recordArr", recordArr);
		setAttr("master_id",master_id);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/salaryRecord.ftl");
	}

	/**
	 * 收支明细 ajax请求
	 */
	public void inOutDetailAjax() {
		int master_id = getParaToInt("master_id");// 鲜果师ID
		int inout_type = getParaToInt("inout_type");// 收支类型 1收入；2支出
		int pageNumber = getParaToInt("pageNumber");// 第几页
		int pageSize = getParaToInt("pageSize");// 每一页的数量
		// 查询收支明细 最多90天
		List<XAchievementRecord> records = inOutDetailByType(pageNumber, pageSize, master_id, inout_type);
		renderJson(records);
	}

	/**
	 * 根据收支类型分页查找数据
	 * 
	 * @param pageNumber
	 * @param pageSize
	 * @param master_id
	 * @param inout_type
	 * @return
	 */
	public List<XAchievementRecord> inOutDetailByType(int pageNumber, int pageSize, int master_id, int inout_type) {
		// 设置当前时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");// 设置日期格式
		Calendar now = Calendar.getInstance();
		now.setTime(new Date());
		String today = df.format(now.getTime());// 今天
		now.set(Calendar.DATE, now.get(Calendar.DATE) - 1);
		String yesterday = df.format(now.getTime());// 昨天
		// 90天的收支明细
		Page<XAchievementRecord> records = XAchievementRecord.dao.findAchievementRecord(pageNumber, pageSize, master_id,
				inout_type);
		// 处理时间显示形式
		for (XAchievementRecord xAchievementRecord : records.getList()) {

			if (today.equals(xAchievementRecord.getStr("time").substring(0, 10))) {// 今天
				if (Integer.parseInt(xAchievementRecord.getStr("time").substring(11, 13)) < 13) {// 上午
					xAchievementRecord.set("time", "上午  " + xAchievementRecord.getStr("time").substring(11, 16));
				} else {// 下午
					xAchievementRecord.set("time", "下午  " + xAchievementRecord.getStr("time").substring(11, 16));
				}

			} else if (yesterday.equals(xAchievementRecord.getStr("time").substring(0, 10))) {// 昨天

				xAchievementRecord.set("time", "昨日  " + xAchievementRecord.getStr("time").substring(11, 16));

			} else {// 其他时间

				xAchievementRecord.set("time", xAchievementRecord.getStr("time").substring(5, 16));
			}
		}
		return records.getList();
	}

	/**
	 * 鲜果师团队
	 */
	public void masterTeam() {
		int master_id = getParaToInt("master_id");
		JSONObject customerJson = new JSONObject();
		customerJson.put("master_id", master_id);
		// 所有有效下级
		List<XFruitMaster> master_team = XFruitMaster.dao.findSubMasterListById(master_id);

		// 当月销售额
		for (XFruitMaster subMaster : master_team) {
			Record month_total = XFruitMaster.dao.findMasterMonthTotal(subMaster.getInt("id"));
			subMaster.put("month_total", month_total.get("total"));
		}
		System.out.println("----------" + master_team.toString());
		// // 鲜果师所有客户
		// List<XMasterUser> masterUsers =
		// XMasterUser.dao.findUsersByMasterId(master_id);
		// List<Map> masterTeam = new ArrayList<Map>();
		// Map<String,Object> map = new HashMap<String,Object>();
		// // 筛选出下级分销商
		// for (XMasterUser xMasterUser : masterUsers) {
		// XFruitMaster fruitMaster =
		// XFruitMaster.dao.findXFruitMasterById(xMasterUser.getInt("master_id"));
		// if (fruitMaster != null) {
		// // 鲜果师id，备注或者名称，当月销售额,手机号
		// map.put("master_id",xMasterUser.getInt("master_id"));
		// //名称备注，没有备注就给名称
		// if(StringUtil.isNotNull(xMasterUser.getStr("master_desc"))){
		// map.put("master_name", xMasterUser.getStr("master_desc"));
		// }else{
		// map.put("master_name", fruitMaster.getStr("master_name"));
		// }
		// //当月销售额
		// XFruitMaster month_total =
		// XFruitMaster.dao.findMasterMonthTotal(master_id);
		// map.put("month_total", month_total);
		// //手机号
		// TUser user = TUser.dao.findFirst(xMasterUser.get("user_id"));
		// map.put("phone_num", user.get("phone_num"));
		// masterTeam.add(map);
		// map.clear();
		// }
		// }
		JSONArray teamArr = ObjectToJson.modelListConvert(master_team);
		customerJson.put("teamList", teamArr);
		setAttr("master_team", customerJson.toJSONString());

		System.out.println("=======" + teamArr.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myTeam.ftl");
	}

	/**
	 * 下级鲜果师信息
	 */
	public void subMaster() {
		int master_id = getParaToInt("master_id");//下级的鲜果师id
		XFruitMaster master = XFruitMaster.dao.findSubMasterById(master_id);

		// 总销售额
		Record total = XFruitMaster.dao.findTotalByMasterId(master_id);
		master.put("total", total.get("total"));
		// 当月销售额
		Record month_total = XFruitMaster.dao.findMasterMonthTotal(master_id);
		master.put("month_total", month_total.get("total"));
		// 本月产生红利
		XBonusPercentage bonus_percentage = XBonusPercentage.dao.findXBonusPercentage();
		double bonus = Integer.parseInt(month_total.get("total").toString())
				* bonus_percentage.getInt("bonus_percentage") / 10000.0;
		master.put("bonus", bonus);
		JSONObject bonusJson = ObjectToJson.modelConvert(master);
		setAttr("subMasterDetail", bonusJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myTeamDetails.ftl");
	}

	/**
	 * 我的客户
	 */
	public void masterCustomer() {
		int master_id = getParaToInt("master_id");
		JSONObject customerJson = new JSONObject();
		customerJson.put("master_id", master_id);
		// 鲜果师所有客户
		List<XMasterUser> customers = XMasterUser.dao.findUsersByMasterId(master_id);
		JSONArray customerArr = ObjectToJson.modelListConvert(customers);
		customerJson.put("customers", customerArr);
		setAttr("customers", customerJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myCustomer.ftl");
	}

	/**
	 * 客户详情
	 */
	public void myCustomerDetail() {
		int user_id = getParaToInt("user_id");//客户的user_id
		// 鲜果师某个客户的详细信息
		XMasterUser master_user = XMasterUser.dao.findCustomerByUserId(user_id);
		// 客户消费次数及金额统计
		Record all_orders = TOrder.dao.findAllOrderByUserId(master_user.getInt("master_id"),user_id);
		master_user.put("all_orders_count", all_orders.get("count"));
		master_user.put("all_orders_total", all_orders.get("total"));
		// 客户当前月消费次数及金额统计
		Record month_orders = TOrder.dao.findMonthOrderByUserId(master_user.getInt("master_id"),user_id);
		master_user.put("month_orders_count", month_orders.get("count"));
		master_user.put("month_orders_total", month_orders.get("total"));
		JSONObject masterUserJson = ObjectToJson.modelConvert(master_user);
		setAttr("master_user_detail", masterUserJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myCustomerDetails.ftl");
	}

	/**
	 * 修改客户备注
	 */
	public void updateMasterUserDescription() {
		int master_id = getParaToInt("master_id");
		int user_id = getParaToInt("user_id");
		String description = getPara("description");
		// 修改客户备注
		XMasterUser.dao.updateMasterUserDescription(master_id, user_id, description);
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("msg", "修改成功");
		renderJson(result);
	}

	/**
	 * 鲜果师收入
	 */
	public void mySalary() {
		int master_id = getParaToInt("master_id");
		JSONObject salaryJson = new JSONObject();
		salaryJson.put("master_id", master_id);
		// 查看是否本月已经提现，用作按钮置灰
		XApplyMoney apply_record = XApplyMoney.dao.findXApplyMoneyByThisMonth(master_id);
		Date date = new Date();
		int day = date.getDate();
		int apply_money = 0;//已提交的申请金额
		if (apply_record == null && day>=15 &&day<=17) {// 可以显示
			salaryJson.put("button_flag", 1);
		} else {// 结算按钮置灰
			salaryJson.put("button_flag", 0);
			if(apply_record!=null){
				apply_money = apply_record.getInt("apply_money");//已提交的申请金额
			}
		}
		// 剩余未提现的金额
		XFruitMaster master = XFruitMaster.dao.findXFruitMasterById(master_id);
		// 是否有银行卡
		if (StringUtil.isNotNull(master.getStr("bank_deposit")) && StringUtil.isNotNull(master.getStr("bank_card"))) {
			//銀行卡已設置
			salaryJson.put("bank_setting", 1);
		}else{
			//銀行卡沒有設置
			salaryJson.put("bank_setting", 0);
		}
		int remaining_balance = master.getInt("remaining_balance");
		
		System.out.println("已经获得红利");
		int bonus_total = caculateBonus(master_id, 1);
		int bonus = caculateBonus(master_id, 2);
		
		int is_caculate = master.getInt("is_caculate");
		
		if(is_caculate==0){//未定时任务结算
			if(apply_record == null){
				bonus_total = caculateBonus(master_id, 1) + remaining_balance;//已经获得红利
				bonus = caculateBonus(master_id, 2) + remaining_balance;
			}else if(apply_record.getInt("status")==0){//0申请未审核
				bonus_total = caculateBonus(master_id, 1) + remaining_balance - apply_money;
				bonus = caculateBonus(master_id, 2) + remaining_balance - apply_money;
			}else if(apply_record.getInt("status")==1){//1申请通过
				bonus_total = caculateBonus(master_id, 1) + remaining_balance - apply_money;
				bonus = caculateBonus(master_id, 2) + remaining_balance - apply_money;
			}
		/*	// 1.已经获得红利
			bonus_total = caculateBonus(master_id, 1) + remaining_balance - apply_money;
			// 2.计算可结算红利
			bonus = caculateBonus(master_id, 2) + remaining_balance - apply_money;*/
		}else{//定时任务结算完毕
			if(apply_record == null){
				bonus_total = caculateBonus(master_id, 1) + remaining_balance - caculateBonus(master_id, 2);
				bonus = remaining_balance;
			}else if(apply_record.getInt("status")==1){//审核通过
				bonus_total = caculateBonus(master_id, 1) + remaining_balance - caculateBonus(master_id, 2);
				bonus = remaining_balance;
			}else if(apply_record.getInt("status")==2){//申请失效
				bonus_total = caculateBonus(master_id, 1) + remaining_balance - caculateBonus(master_id, 2);
				bonus = remaining_balance;
			}
/*			// 1.已经获得红利
			bonus_total = caculateBonus(master_id, 1) + remaining_balance - 2*apply_money;
			// 2.计算可结算红利
			bonus = caculateBonus(master_id, 2) - apply_money;*/
		}
		
		salaryJson.put("bonus_total", bonus_total);
		
		System.out.println("计算可结算红利");
		
		salaryJson.put("bonus", bonus);
		if (bonus == 0) {// 可结算金额为0时按钮置灰
			salaryJson.put("button_flag", 0);
		}
		// 3.历史总收入：已结算+正在结算+已获得红利
		// 已结算金额
		System.out.println("已结算金额");
		int gotMoney = Integer.parseInt(XApplyMoney.dao.findMoney(master_id, 1).get("total").toString());
		salaryJson.put("gotMoney", gotMoney);
		// 正在结算金额
		System.out.println("正在结算金额");
		int gettingMoney = Integer.parseInt(XApplyMoney.dao.findMoney(master_id, 0).get("total").toString());
		salaryJson.put("gettingMoney", gettingMoney);
		// 3.历史总收入：已结算+正在结算+已获得红利
		int all_money= gotMoney + gettingMoney + bonus_total;
		salaryJson.put("all_money", all_money);
		setAttr("salaryInfo", salaryJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/mySalary.ftl");
	}

	/**
	 * 计算红利（type为1计算的是所获得红利，订单状态可以是已支付,已取货，已完成；2为可结算红利,可结算的订单状态需要是已完成）
	 * 
	 * @param master_id
	 * @param type
	 * @return
	 */
	public static int caculateBonus(int master_id, int type) {
		String time;
		String order_status;
		if (type == 1) {//type为1计算的是所获得红利，订单状态可以是已支付,已取货，已完成；
			time = "now()";
			order_status = "('3','4','11')";
		} else {//2为可结算红利,可结算的订单状态需要是已完成
			time = "DATE_FORMAT(date_add(curdate() - day(curdate()) + 1, interval 0 month),'%Y-%m-%d 00:00:00')";
			order_status = "('11')";
		}

		XBonusPercentage bp = XBonusPercentage.dao.findXBonusPercentage();
		int sale_percentage = bp.getInt("sale_percentage");
		int bonus_percentage = bp.getInt("bonus_percentage");
		// 1.计算自身销售额红利(上个月，加上这个月到当前的红利)
		Record masterRecod = Db
				.findFirst("select ifnull(sum(need_pay),0) sale_total from t_order where order_status in "
						+ order_status + " and master_id=? and order_source = '1' "
						+ "and date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m-00 00:00:00') <= pay_time "
						+ "and pay_time < " + time, master_id);
		int sale_bonus = Integer.parseInt(masterRecod.get("sale_total").toString()) * sale_percentage / 100;
		// 2.计算从下级鲜果师销售额所获红利
		// 拼接下级鲜果师 id集合   鲜果师有效
		List<XFruitMaster> subMaster = XFruitMaster.dao.findSubMasterListById(master_id);
		int sub_sale_bonus = 0;
		if(subMaster.size()>0){//有下级鲜果师下级的时候才需要计算从下级获得红利，否则不需要算
			String subMaster_ids = "(";
			System.out.println("<<><><><>"+subMaster.size());
			for (XFruitMaster xFruitMaster : subMaster) {
					subMaster_ids += xFruitMaster.get("id") + ",";
			}
			// 拼接出(1,2,3)这种格式
			subMaster_ids = subMaster_ids.substring(0, subMaster_ids.length() - 1) + ")";
			// 统计下级分销商的订单交易额
			Record subMasterRecod = Db
					.findFirst("select ifnull(sum(need_pay),0) sale_total from t_order where order_status in "
							+ order_status + " and master_id in " + subMaster_ids + " and order_source = '1' "
							+ "and date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m-00 00:00:00') <= pay_time "
							+ "and pay_time <= " + time);
			sub_sale_bonus = Integer.parseInt(subMasterRecod.get("sale_total").toString()) * bonus_percentage / 100;
		}
		
		// 已经获得红利
		int bonus = sale_bonus + sub_sale_bonus;
		return bonus;
	}

	/**
	 * 鲜果师银行卡接口
	 */
	public void myCard() {
		int master_id = getParaToInt("master_id");
		// 查找鲜果师信息
		XFruitMaster bankInfo = XFruitMaster.dao.findXFruitMaster(master_id);
		// 转换为JSON格式
		JSONObject bankJson = ObjectToJson.modelConvert(bankInfo);
		setAttr("master_id", master_id);
		setAttr("bankInfo", bankJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myCard.ftl");
	}

	/**
	 * 修改鲜果师银行卡接口
	 */
	public void updateCardInfo() {
		int master_id = getParaToInt("master_id");
		String bank_card = getPara("bank_card");
		String bank_deposit = getPara("bank_deposit");
		String bank_user = getPara("bank_user");

		Map<String, Object> map = new HashMap<String, Object>();// 需要修改的资料
		map.put("bank_card", bank_card);
		map.put("bank_deposit", bank_deposit);
		map.put("bank_user", bank_user);
		Map<String, Object> result = new HashMap<String, Object>();// 需要修改的资料
		// 查找鲜果师信息
		int result_flag = XFruitMaster.dao.updateMaster(map, master_id,"x_fruit_master");
		if (result_flag == 1) {// 修改成功
			result.put("status", true);
		} else {// 修改失败
			result.put("status", false);
		}
		renderJson(result);
	}

	/**
	 * 申请结算
	 */
	public void applyMoney() {
		int master_id = getParaToInt("master_id");
		Map<String, String> result = new HashMap<String, String>();
		XApplyMoney apply_record = XApplyMoney.dao.findXApplyMoneyByThisMonth(master_id);
		if(apply_record!=null){
			result.put("result", "success");
			result.put("button_flag", "0");
			result.put("msg", "请勿重复提交。");
			renderJson(result);
			return;
		}
		double apply_money1 = Double.parseDouble(getPara("apply_money"));
		int apply_money = (int)(apply_money1*100);
		boolean flag = false;// 是否提交成功
		// 剩余未提现的金额
		XFruitMaster master = XFruitMaster.dao.findXFruitMasterById(master_id);
		int remaining_balance = master.getInt("remaining_balance");
		// 上月可结算红利
		int last_money = caculateBonus(master_id, 2);
		// 计算可结算红利
		int bonus = last_money + remaining_balance;
		if (apply_money > bonus) {
			result.put("result", "failure");
			result.put("button_flag", "1");
			result.put("msg", "提取金额不得大过可提金额");
		} else {
			Record record = new Record();
			record.set("master_id", master_id);
			record.set("apply_time", DateUtil.convertDate2String(new Date(), "YYYY-MM-dd HH:mm:ss"));
			record.set("apply_money", apply_money);
			record.set("status", 0);
			XApplyMoney.dao.addApplyMoneyRecord(record);// 提取记录
			if (apply_money > last_money) {// 提现金额大于上月可结算金额
				// 从多提的金额中减去剩余金额
				int beyond_money = apply_money - last_money;
				remaining_balance = remaining_balance - beyond_money;
				master.set("remaining_balance", remaining_balance);
				flag = master.update();
			} /*else {// 提现金额小于上月可结算金额
				// 从多提的金额中减去剩余金额
				int beyond_money = last_money - apply_money;
				remaining_balance = remaining_balance + beyond_money;
				master.set("remaining_balance", remaining_balance);
				flag = master.update();
			}*/

//			if (flag) {
			result.put("result", "success");
			result.put("button_flag", "0");
			result.put("msg", "申请成功，将于1~3个工作日到账。");
//			} else {
//				result.put("result", "failure");
//				result.put("button_flag", "1");
//				result.put("msg", "申请失败，请重试。");
//			}
		}
		System.out.println("==="+result);
		renderJson(result);
	}

	/**
	 * 进入鲜果师订单管理
	 */
	@Before(OAuth2Interceptor.class)
	public void masterOrders() {
		int order_status = getParaToInt("status");
		int user_id = UserStoreUtil.get(getRequest()).getInt("id");
		//通过用户session 找到对应master_id
		int master_id = XFruitMaster.dao.findMasterByUserId(user_id).getInt("id");
		int pageNumber = getParaToInt("pageNumber");
		int pageSize = getParaToInt("pageSize");
		JSONObject orderJson = new JSONObject();
		orderJson.put("status", order_status);// 前端切换的状态
		orderJson.put("master_id", master_id);
		// 根据订单类型查出订单
		Page<TOrder> torders = TOrder.dao.findOrdersByType(order_status, master_id, pageNumber, pageSize);
		// 格式转换
		JSONArray torderArr = ObjectToJson.modelListConvert(torders.getList());

		orderJson.put("orderList", torderArr);
		setAttr("orders", orderJson.toJSONString());
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/myOrder.ftl");
	}

	/**
	 * 进入鲜果师订单管理Ajax
	 */
	@Before(OAuth2Interceptor.class)
	public void masterOrdersAjax() {
		int order_status = getParaToInt("status");
		TUser user = UserStoreUtil.get(getRequest());
		int user_id = UserStoreUtil.get(getRequest()).getInt("id");
		//通过用户session 找到对应master_id
		int master_id = XFruitMaster.dao.findMasterByUserId(user_id).getInt("id");
		int pageNumber = getParaToInt("pageNumber");
		int pageSize = getParaToInt("pageSize");
		JSONObject orderJson = new JSONObject();
		orderJson.put("status", order_status);// 前端切换的状态
		// 根据订单类型查出订单
		Page<TOrder> torders = TOrder.dao.findOrdersByType(order_status, master_id, pageNumber, pageSize);
		// 格式转换
		JSONArray torderArr = ObjectToJson.modelListConvert(torders.getList());
		orderJson.put("orderList", torderArr);
		renderJson(orderJson);
	}

	/**
	 * 订单详情
	 */
	@Before({ OAuth2Interceptor.class })
	public void masterOrderDetail() {
		int order_id = getParaToInt("order_id");
		//订单详情
		Record order_detail = TOrder.dao.findOrderDetail(order_id);
		//转为json格式传给前端
		setAttr("order_detail", ObjectToJson.recordConvert(order_detail));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/orderDetail.ftl");
	}
	
}