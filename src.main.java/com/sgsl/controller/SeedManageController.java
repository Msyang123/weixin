package com.sgsl.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.ext.render.excel.PoiRender;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.render.Render;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.JsonPojo;
import com.sgsl.model.MActivity;
import com.sgsl.model.MInterval;
import com.sgsl.model.MPackage;
import com.sgsl.model.MPackageInstance;
import com.sgsl.model.MPackageProduct;
import com.sgsl.model.MPackageSeedR;
import com.sgsl.model.MProductSeedR;
import com.sgsl.model.MSeedInstance;
import com.sgsl.model.MSeedProduct;
import com.sgsl.model.MSeedProductInstance;
import com.sgsl.model.MSeedType;
import com.sgsl.model.TImage;
import com.sgsl.model.TUser;
import com.sgsl.util.DateUtil;
import com.sgsl.util.ExcelUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;

public class SeedManageController extends BaseController {

	protected final static Logger logger = Logger.getLogger(SeedManageController.class);
	
	/**
	 * 种子活动后台管理
	 */
	public void seed() {
		// 初始化种子类型列表
		setAttr("seedType",MSeedType.dao.find("select * from m_seed_type where status='Y'"));
		//种子周期活动
		setAttr("allActivity", Db.find("select id,main_title from m_activity where activity_type=18"));
		render(AppConst.PATH_MANAGE_PC + "/activity/seed.ftl");
	}

	/**
	 * 种子活动后台编辑
	 */
	public void seedEdit() {
		MActivity activity = MActivity.dao.findById(getPara("id"));
		if (activity == null) {
			activity = new MActivity();
		} else {
			TImage image = new TImage();
			setAttr("image", image.findById(activity.getInt("img_id")));
		}
		setAttr("activity", activity);
		// 初始化种子类型列表
		setAttr("seedType", MSeedType.dao.find("select * from m_seed_type where status='Y' and activity_id=22"));
		// 初始化套餐类型
		setAttr("package", MPackage.dao.find("select * from m_package where status='Y' and activity_id=22"));
		// 初始化单品类型
		setAttr("single", Db.find(
				"select s.*,p.product_name from m_seed_product s left join t_product p on s.product_id=p.id where status='Y' and activity_id=22"));
		render(AppConst.PATH_MANAGE_PC + "/activity/editSeed.ftl");
	}
	
	/**
	 * 异步加载活动列表
	 */
	public void getSeedActivitysJson() {
		// 再传一个id
		String activity_type = getPara("activity_type");
		String main_title = getPara("main_title");
		String yxbz = getPara("yxbz");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<MActivity> pageInfo = null;
		String sqlStr ="from m_activity where activity_type="+activity_type;
		
	    if (StringUtil.isNull(main_title)) {
			if (StringUtil.isNull(yxbz)) {
				if (StringUtil.isNull(sidx)) {
				} else {
					sqlStr = sqlStr+" order by " + sidx + " " + sord;
				}
			} else {
				if (StringUtil.isNull(sidx)) {
					sqlStr = sqlStr+" and yxbz='" + yxbz + "'";
				} else {
					sqlStr = sqlStr+" and yxbz='" + yxbz + "' order by "
							+ sidx + " " + sord;
				}
			}
		} else {
			if (StringUtil.isNull(yxbz)) {
				if (StringUtil.isNull(sidx)) {
					sqlStr =sqlStr +" and main_title like '%" + main_title
							+ "%'";
				} else {
					sqlStr =sqlStr+" and main_title like '%" + main_title
							+ "%' order by " + sidx + " " + sord;
				}
			} else {
				if (StringUtil.isNull(sidx)) {
					sqlStr =sqlStr +" and main_title like '%" + main_title
							+ "%' and yxbz='" + yxbz + "'";
				} else {
					sqlStr =sqlStr+" and main_title like '%" + main_title
							+ "%' and yxbz='" + yxbz + "' order by " + sidx + " " + sord;
				}
			}
		}
	    
		pageInfo = MActivity.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MActivity pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("main_title"));
			row.add(pa.get("subheading"));
			row.add(pa.get("yxq_q"));
			row.add(pa.get("yxq_z"));
			row.add(pa.get("url"));
			row.add(pa.get("yxbz"));
			// 操作列，需要第一列填充空数据
			row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * 手动给用户送种子
	 */
	public void sendSeed(){
		String file_path = getPara("file_path");
		String seedArray =  getPara("seedArray");
		JSONObject result = new JSONObject();
		JSONArray seedArrayJson = JSONArray.parseArray(seedArray);
		// 存储发放成功名单
		List<String> success_phone = new ArrayList<String>();
		// 存储发放失败名单
		List<String> fail_phone = new ArrayList<String>();
		//取出文件电话号码
		List<String> phone_nums = ExcelUtil.getColData(file_path);
		MSeedInstance seedInstance = new MSeedInstance();
		for(String phoneNum:phone_nums){
			TUser user = TUser.dao.findFirst("select * from t_user where phone_num = ?", phoneNum);
			if(user != null){
				for(int i=0;seedArrayJson.size()>i;i++){
					int seedCount=seedArrayJson.getJSONObject(i).getInteger("seedNum");//赠送的种子数
					int seedTypeId=seedArrayJson.getJSONObject(i).getInteger("seedType");//种子类型
					for(int j=0;seedCount>j;j++){
						seedInstance.set("seed_type_id", seedTypeId);
						seedInstance.set("status", 1);
						seedInstance.set("get_time", DateFormatUtil.format1(new Date()));
						seedInstance.set("get_type", 8);
						seedInstance.set("user_id", user.getInt("id"));
						seedInstance.save();
						seedInstance.remove("id");
					}
				}
				success_phone.add(phoneNum);
			}else {
				// 存入号码
				fail_phone.add(phoneNum);
			}
		}
		
		result.put("successNum", success_phone.size());
		result.put("failNum", fail_phone.size());
		result.put("fail_phone", fail_phone);
		renderJson(result);
	}
	
	/**
	 * 兑奖记录列表
	 */
	public void exchangeRecord(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String activity_id=getPara("activity_id");
        String nickname=getPara("nickname");
        String exchangeType=getPara("exchange_type");
        String createBeginTime=getPara("createBeginTime");
        String createEndTime=getPara("createEndTime");
        
        String sql="select t.id,t1.nickname,t1.phone_num,t.exchange_type,t.create_time,ifnull(t.recieve_time,'/')as recieve_time,t2.main_title,t.record_name ";
        String where = "from t_exchange_order_log t ";
        	   where+= "left join t_user t1 on t.user_id=t1.id ";
        	   where+= "left join m_activity t2 on t2.id=t.activity_id where 1=1 ";
        	   
        if(StringUtil.isNotNull(activity_id)){
        	where += "and t2.id="+getParaToInt("activity_id")+" ";
        }
        
        if(StringUtil.isNotNull(nickname)){
        	where += "and t1.nickname like '%"+nickname+"%' ";
        }
        
        if(StringUtil.isNotNull(exchangeType)){
        	where += "and t.exchange_type='"+exchangeType+"' ";
        }
        
        if(StringUtil.isNotNull(createBeginTime)&&StringUtil.isNotNull(createEndTime)){
        	where += "and t.create_time between '"+createBeginTime+"' and '"+createEndTime+"' ";
        }
        
        where += "order by t.create_time desc ";
        
        Page<Record> pageInfo = Db.paginate(page, pageSize, sql, where);
        
        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getInt("id"));
            row.add(rc.getStr("nickname"));
            row.add(rc.getStr("phone_num"));
            row.add(rc.getStr("create_time"));
            row.add(rc.getStr("recieve_time"));
            row.add(rc.getStr("main_title"));
            row.add(rc.getStr("exchange_type"));
            row.add(rc.getStr("record_name"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	
	 /**
     * 充值记录导出
     */
    public void exportExchange(){
    	String createBeginTime=null,createEndTime=null,nickName=null,activityId=null,exchangeType=null;
    	String formData=getPara("formData");
    	JSONArray formDataJson=JSONArray.parseArray(formData);
    	String colNames=getPara("colNames");
    	JSONArray colNamesJson=JSONArray.parseArray(colNames);
    	colNamesJson.remove(0);
        String colModel=getPara("colModel");
        JSONArray colModelJson=JSONArray.parseArray(colModel);
        
        Date date=new Date(); 
    	for(int i=0;i<formDataJson.size();i++){
        	JSONObject item=formDataJson.getJSONObject(i);
        	String name=item.getString("name");
        	String value=item.getString("value");
        	
        	if("createBeginTime".equals(name)){
        		createBeginTime=value;
        	}else if("createEndTime".equals(name)){
        		createEndTime=value;
        	}else if("nickname".equals(name)){
        		nickName=value;
        	}else if("activity_id".equals(name)){
        		activityId=value;
        	}else if("exchange_type".equals(name)){
        		exchangeType=value;
        	}
        }
    	
        if(StringUtil.isNull(createBeginTime)){
        	createBeginTime=DateFormatUtil.format5(date)+"000000";
        }else{
        	Date createBeginTimeData= DateUtil.convertString2Date(createBeginTime);
        	createBeginTime=DateFormatUtil.format3(createBeginTimeData);
        }
        
        if(StringUtil.isNull(createEndTime)){
        	createEndTime=DateFormatUtil.format5(date)+"235959";
        }else{
        	Date createEndTimeData= DateUtil.convertString2Date(createEndTime);
        	createEndTime=DateFormatUtil.format3(createEndTimeData);
        }
        
        String sql="select t.id,t1.nickname,t1.phone_num,t.exchange_type,t.create_time,ifnull(t.recieve_time,'/')as recieve_time,t2.main_title,t.record_name ";
		sql+= "from t_exchange_order_log t ";
		sql+= "left join t_user t1 on t.user_id=t1.id ";
		sql+= "left join m_activity t2 on t2.id=t.activity_id where 1=1 and t.create_time between '"+createBeginTime+"' and '"+createEndTime+"'";
		
		if(StringUtil.isNotNull(nickName)){
			sql+=" and t1.nickname like '%"+nickName+"%' ";
		}
		
		if(StringUtil.isNotNull(activityId)){
			sql += " and t2.id="+Integer.parseInt(activityId)+" ";
        }
		
		if(StringUtil.isNotNull(exchangeType)){
			sql += " and t.exchange_type='"+exchangeType+"' ";
	    }
		
		sql += "order by t.create_time desc ";
		
    	List<Record> list = Db.find(sql);
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="seedExchangeList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(createBeginTime.substring(0,10)+"至"+createEndTime.substring(0,10)+"种子兑换记录 导出").columns(columns);
        render(poirender);
    }
	
	/**
	 * 种子活动数据统计图
	 */
	public void seedCount(){
		try {
			String createBegainTime=getPara("start_time");
			String createEndTime=getPara("end_time");
			int activity_id=getParaToInt("id");
			JSONObject result = new JSONObject();
			JSONArray staTotalList=new JSONArray();
			JsonPojo jsonPojo = new JsonPojo();
			//List<Map<Object,Object>> result = new ArrayList<Map<Object,Object>>();
			//种子发放领取总数
			long receiveTotal=MSeedType.dao.receiveSeedNum(createBegainTime, createEndTime, activity_id);
			jsonPojo.setName("receiveTotal");
			jsonPojo.setValue(receiveTotal);
			staTotalList.add(jsonPojo);
			
			//分享赠送种子总数
			long shareTotal=MSeedType.dao.shareSeedNum(createBegainTime, createEndTime, activity_id);
			JsonPojo jsonPojo1 = new JsonPojo();
			jsonPojo1.setName("shareTotal");
			jsonPojo1.setValue(shareTotal);
			staTotalList.add(jsonPojo1);
			
			//购物赠送种子总数
			long purchaseTotal=MSeedType.dao.shopSeedNum(createBegainTime, createEndTime, activity_id);
			JsonPojo jsonPojo2 = new JsonPojo();
			jsonPojo2.setName("purchaseTotal");
			jsonPojo2.setValue(purchaseTotal);
			staTotalList.add(jsonPojo2);
			
			//兑换单品总份数
			long singleTotal=MSeedType.dao.exchangeSingleNum(createBegainTime, createEndTime, activity_id);
			JsonPojo jsonPojo3 = new JsonPojo();
			jsonPojo3.setName("singleTotal");
			jsonPojo3.setValue(singleTotal);
			staTotalList.add(jsonPojo3);
			
			//兑换套餐总份数
			long comboTotal=MSeedType.dao.exchangePackageNum(createBegainTime, createEndTime, activity_id);
			JsonPojo jsonPojo4 = new JsonPojo();
			jsonPojo4.setName("comboTotal");
			jsonPojo4.setValue(comboTotal);
			staTotalList.add(jsonPojo4);
			
			//兑换商品总金额
			BigDecimal moneyTotal=MSeedType.dao.totalMoney(createBegainTime, createEndTime, activity_id);
			JsonPojo jsonPojo5 = new JsonPojo();
			jsonPojo5.setName("moneyTotal");
			jsonPojo5.setValue(moneyTotal.longValue());
			staTotalList.add(jsonPojo5);
			result.put("staTotalList", staTotalList);
			
			JSONArray staSeedGetList=new JSONArray();
			JSONArray seedType=new JSONArray();
			//种子具体领取情况统计
			List<Record> receiveSeedCount=MSeedType.dao.receiveSeedCount(createBegainTime, createEndTime, activity_id);
			for(int i=0;receiveSeedCount.size()>i;i++){
				JsonPojo jsonPojo6 = new JsonPojo();
				jsonPojo6.setName(receiveSeedCount.get(i).getStr("seed_name"));
				jsonPojo6.setValue(receiveSeedCount.get(i).getLong("seed_count"));
				staSeedGetList.add(jsonPojo6);
				seedType.add(receiveSeedCount.get(i).getStr("seed_name"));
			}
			result.put("staSeedGetList", staSeedGetList);
			result.put("seedType", seedType);
			
			JSONArray staSeedSingleList = new JSONArray();
			JSONArray singleList = new JSONArray();
			//单品具体领取情况统计
			List<Record> receiveSingleCount=MSeedType.dao.receiveSingleCount(createBegainTime, createEndTime, activity_id);
			for(int i=0;receiveSingleCount.size()>i;i++){
				JsonPojo jsonPojo7 = new JsonPojo();
				jsonPojo7.setName(receiveSingleCount.get(i).getStr("single_name"));
				jsonPojo7.setValue(receiveSingleCount.get(i).getLong("seedCount"));
				staSeedSingleList.add(jsonPojo7);
				singleList.add(receiveSingleCount.get(i).getStr("single_name"));
			}
			result.put("staSeedSingleList", staSeedSingleList);
			result.put("singleList", singleList);
			
			JSONArray staSeedComboList = new JSONArray();
			JSONArray comboList = new JSONArray();
			//套餐具体领取情况统计
			List<Record> receivePackageCount=MSeedType.dao.receivePackageCount(createBegainTime, createEndTime, activity_id);
			for(int i=0;receivePackageCount.size()>i;i++){
				JsonPojo jsonPojo8 = new JsonPojo();
				jsonPojo8.setName(receivePackageCount.get(i).getStr("package_name"));
				jsonPojo8.setValue(receivePackageCount.get(i).getLong("seedCount"));
				staSeedComboList.add(jsonPojo8);
				comboList.add(receivePackageCount.get(i).getStr("package_name"));
			}
			result.put("staSeedComboList", staSeedComboList);
			result.put("comboList", comboList);
			renderJson(result);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	/**
	 * jquery gdview编辑保存活动
	 */
	public void gDSaveSeedActivity() {
		MActivity activity = getModel(MActivity.class, "ac");
		if ("add".equals(getPara("oper"))) {
			activity.save();
		} else if ("edit".equals(getPara("oper"))) {
			activity.update();
		}
		redirect("/seedManage/seed");
	}
	
	/**
	 * ajax去修改当前状态  开闭活动有效标志
	 */
	public void changeStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int acid=Integer.parseInt(id);
			//先判断是否有种子时间段在发放
			Record record=Db.findFirst("select * from m_interval where activity_id="+acid+" and status=1");
			if(record!=null){
				result.put("success", false);
				result.put("msg", "正在发放种子中,不允许修改状态");
				renderJson(result);
				return;
			}
			
			if(status.equals("Y")){
				Db.update("update m_activity set yxbz='N' where id="+acid);
			}else{
				//只能开启一个种子活动
				Record records=Db.findFirst("select * from m_activity where activity_type=18 and yxbz='Y' ");
				if(records!=null){
					result.put("success", false);
					result.put("msg", "不能同时开启多个种子活动,请先关闭开启的种子活动");
					renderJson(result);
					return;
				}
				Db.update("update m_activity set yxbz='Y' where id="+acid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}

	/**
	 * ajax去修改当前状态  开闭活动有效标志
	 */
	public void changeIntervalStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int acid=Integer.parseInt(id);	
			if(status.equals("0")){
				Db.update("update m_interval set status=1 where id="+acid);
			}else{
				Db.update("update m_interval set status=0 where id="+acid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * ajax去修改当前状态  开闭活动有效标志
	 */
	public void changeSingleStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int sid=Integer.parseInt(id);
			if(status.equals("Y")){
				Db.update("update m_seed_product set status='N' where id="+sid);
			}else{
				Db.update("update m_seed_product set status='Y' where id="+sid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * ajax去修改当前状态  开闭活动有效标志
	 */
	public void changeCmoboStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int pid=Integer.parseInt(id);
			if(status.equals("Y")){
				Db.update("update m_package set status='N' where id="+pid);
			}else{
				Db.update("update m_package set status='Y' where id="+pid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * ajax去修改当前状态  开闭活动有效标志
	 */
	public void changeSeedTypeStatus() {
		String id = getPara("ids");
		String status = getPara("status");
		JSONObject result = new JSONObject();

		if (StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)) {
			int sid=Integer.parseInt(id);
			if(status.equals("Y")){
				Db.update("update m_seed_type set status='N' where id="+sid);
			}else{
				Db.update("update m_seed_type set status='Y' where id="+sid);
			}
			result.put("success", true);
			result.put("msg", "操作成功");
		} else{
			result.put("success", false);
			result.put("msg", "开启失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * Ajax删除活动 
	 */
	public void delActivityAjax() {
	    String ids = getPara("ids");
	    String acid=getPara("acid");
		JSONObject result = new JSONObject();
		String sql = "delete from m_activity where id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
			
			if(StringUtil.isNotNull(acid)){
			    	int aid=Integer.parseInt(acid);
			    	if(isActivityOpen(aid)){
			    		result.put("success", false);
						result.put("msg", "活动进行中,不允许删除相关数据，只可操作状态");
						renderJson(result);
						return;
			    	}
		    }
			
			idArr=ids.split(",");
			if(idArr.length==1){
				Db.update(sql+idArr[0]);
			}else{
				for (int i = 0; i < idArr.length; i++) {
				    Db.update(sql+idArr[i]);
                }
			}
			result.put("success", true);
			result.put("msg", "删除成功");
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * Ajax删除活动时间段 
	 */
	public void delIntervalAjax() {
	    String ids = getPara("ids");
	    String acid=getPara("acid");
		JSONObject result = new JSONObject();
		String sql = "delete from m_interval where id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
			
		    if(StringUtil.isNotNull(acid)){
		    	int aid=Integer.parseInt(acid);
		    	if(isActivityOpen(aid)){
		    		result.put("success", false);
					result.put("msg", "活动进行中,不允许删除相关数据，只可操作状态");
					renderJson(result);
					return;
		    	}
		    }
			
			idArr=ids.split(",");
			if(idArr.length==1){
				Db.update(sql+idArr[0]);
			}else{
				for (int i = 0; i < idArr.length; i++) {
				    Db.update(sql+idArr[i]);
                }
			}
			result.put("success", true);
			result.put("msg", "删除成功");
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * Ajax删除活动单品 
	 */
	public void delSingleAjax() {
	    String ids = getPara("ids");
		String acid=getPara("acid");
		JSONObject result = new JSONObject();
		String sql = "delete from m_seed_product where id=";
		String sql2 = "delete from m_product_seed_r where seed_product_id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
		    if(StringUtil.isNotNull(acid)){
		    	int aid=Integer.parseInt(acid);
		    	if(isActivityOpen(aid)){
		    		result.put("success", false);
					result.put("msg", "活动进行中,不允许删除相关数据，只可操作状态");
					renderJson(result);
					return;
		    	}
		    }
			idArr=ids.split(",");
			if(idArr.length==1){
				//先删除关联的子表数据
				Db.update(sql2+idArr[0]);
				Db.update(sql+idArr[0]);
			}else{
				for (int i = 0; i < idArr.length; i++) {
					//先删除关联的子表数据
					Db.update(sql2+idArr[i]);
				    Db.update(sql+idArr[i]);
                }
			}
			result.put("success", true);
			result.put("msg", "删除成功");
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * Ajax删除活动套餐
	 */
	public void delCmoboAjax() {
	    String ids = getPara("ids");
	    String acid=getPara("acid");
		JSONObject result = new JSONObject();
		String sql = "delete from m_package where id=";
		String sql2 = "delete from m_package_seed_r where package_id=";
		String sql3 = "delete from m_package_product where package_id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
			if(StringUtil.isNotNull(acid)){
		    	int aid=Integer.parseInt(acid);
		    	if(isActivityOpen(aid)){
		    		result.put("success", false);
					result.put("msg", "活动进行中,不允许删除相关数据，只可操作状态");
					renderJson(result);
					return;
		    	}
		    }
			idArr=ids.split(",");
			if(idArr.length==1){
				//先删除关联的子表数据
				Db.update(sql3+idArr[0]);
				Db.update(sql2+idArr[0]);
				Db.update(sql+idArr[0]);
			}else{
				for (int i = 0; i < idArr.length; i++) {
					//先删除关联的子表数据
					Db.update(sql3+idArr[i]);
					Db.update(sql2+idArr[i]);
				    Db.update(sql+idArr[i]);
                }
			}
			result.put("success", true);
			result.put("msg", "删除成功");
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}
	
	/**
	 * 保存种子活动
	 */
	public void saveSeedActivity() {
		UUID uuid = UUID.randomUUID();
		MActivity model = getModel(MActivity.class, "activity");
		String imageSrc = getPara("image_src");
		Record record = new Record();
		record.set("uuid", uuid.toString());
		record.setColumns(model2map(model));

		TImage image = new TImage();
		image.set("save_string", imageSrc);
		image.save();
		record.set("img_id", image.getInt("id"));
		if (StringUtil.isNull(getPara("activity.id"))) {
			Db.save("m_activity", record);
		} else {
			Db.update("m_activity", record);
		}
		redirect("/seedManage/seed");
	}

	/**
	 * 保存活动时间区间和产生种子
	 */
	public void saveSeedInstAndInterval() {
		
		String interId=getPara("intervalId");
		String acid=getPara("activityId");
		// 时间区间段
		MInterval model = getModel(MInterval.class, "interval");
		model.set("activity_id", acid);
		
		if(StringUtil.isNotNull(interId)&&interId.equals("0")){
			model.save();
		}else{
			model.set("id", Integer.parseInt(interId));
			model.update();
		}
		/*String seedInstAndCount = getPara("seedInstAndCount");
		JSONObject seedInstAndCountJson = JSONObject.parseObject(seedInstAndCount);
		JSONArray srr = seedInstAndCountJson.getJSONArray("seedExchange");
		for (int i = 0; i < srr.size(); i++) {
			JSONObject item = srr.getJSONObject(i);
			for (int j = 0; j < item.getIntValue("seedNum"); j++) {
				MSeedInstance inst = new MSeedInstance();
				inst.set("seed_type_id", item.getIntValue("seedType"));
				inst.save();
			}
		}*/
		redirect("/seedManage/seedEdit?id="+acid);
	}
	
	/**
	 * 时间段列表
	 */
	public void getIntervalsJson() {
		int pageSize = getParaToInt("rows");		
		int page = getParaToInt("page");
		int actId=getParaToInt("activity_id");
		
		String interName=getPara("interval_name");
		String status=getPara("status");
		String beginTime=getPara("begin_time");
		String endTime=getPara("end_time");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<MInterval> pageInfo = null;
		String sqlStr = "from m_interval where activity_id="+actId;
		
		if(StringUtil.isNotNull(interName)){
			sqlStr+=" and interval_name like '%"+interName+"%' ";
		}
		
		if(StringUtil.isNotNull(status)){
			sqlStr+=" and status="+status;
		}
		
		if(StringUtil.isNotNull(beginTime)&&StringUtil.isNotNull(endTime)){
			sqlStr+=" and begin_time>='"+beginTime+"' and end_time<='"+endTime+"' ";
		}
		
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		
		pageInfo = MInterval.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MInterval pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("interval_name"));
			row.add(pa.get("begin_time"));
			row.add(pa.get("end_time"));
			row.add(pa.get("send_total"));
			row.add(pa.get("send_type"));
			row.add(pa.get("status"));
			row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 删除修改时间段 修改为ajax更新 暂时弃用
	 */
	public void saveInterval() {
		MInterval interval = getModel(MInterval.class, "inte");
		if ("del".equals(getPara("oper"))) {
			interval.set("id", getPara("id"));
			interval.delete();
		} else if ("edit".equals(getPara("oper"))) {
			interval.update();
		}
		redirect("/seedManage/seed");
	}

	/**
	 * 修改或编辑时间段
	 */
	public void intervalDetial(){
		 String sid=getPara("id");
		 JSONObject result = new JSONObject();
		 
		 if(StringUtil.isNotNull(sid)){
			 int id=Integer.parseInt(sid);
			 String sql="select * from m_interval where id="+id;
			 MInterval interval =MInterval.dao.findFirst(sql);
			 
			 if(interval!=null){
				 
				//先判断此套餐是否已经有业务数据关联（被兑换）
				Record obj=Db.findFirst("select * from m_seed_instance where activity_id=? and exchange_time between ? and ?",interval.getInt("activity_id"),interval.getStr("begin_time"),interval.getStr("end_time"));
			    if(obj!=null){
			    	result.put("success", false);
					result.put("msg", "已产生相关业务数据，无法修改区间段基本信息");
					renderJson(result);
					return;
			    }
				 
				 result.put("success", true);
				 result.put("data", interval);
				 result.put("msg", "查询成功");
			 }else{
				 result.put("success", false);
				 result.put("msg", "未查到此条记录");
			 }
		 }else{
			 result.put("success", false);
			 result.put("msg", "参数id为null");
		 }
		 renderJson(result);
	}
		
	/**
	 * 保存套餐实体
	 */
	public void savePackageInstance() {

		for (int i = 0; i < getParaToInt("combo_number"); i++) {
			MPackageInstance inst = new MPackageInstance();
			inst.set("package_id", getParaToInt("combo_name"));
			inst.set("status", 0);
			inst.save();
		}
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("errcode", 0);

		renderJson(result);
	}

	/**
	 * 保存单品实体
	 */
	public void saveSeedProductInstance() {
		for (int i = 0; i < getParaToInt("single_number"); i++) {
			MSeedProductInstance inst = new MSeedProductInstance();
			inst.set("seed_product_id", getParaToInt("single_name"));
			inst.set("status", 0);
			inst.save();
		}
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("errcode", 0);

		renderJson(result);
	}

	/**
	 * 初始化种子添加编辑
	 */
	public void seedAdd() {
		MActivity activity = MActivity.dao.findById(getPara("id"));
		if (activity == null) {
			activity = new MActivity();
		} else {
			TImage image = new TImage();
			setAttr("image", image.findById(activity.getInt("img_id")));
		}
		setAttr("activity", activity);
		render(AppConst.PATH_MANAGE_PC + "/activity/editSeed.ftl");
	}

	/**
	 * 种子类型列表json
	 */
	public void getSeedTypeList() {
		String seed_name = getPara("seed_name");
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<MSeedType> pageInfo = null;
		String sqlStr = "from m_seed_type";
		if (StringUtil.isNotNull(seed_name)) {
			sqlStr = "from m_seed_type where seed_name like'%" + seed_name + "%'";
		}
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = MSeedType.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MSeedType pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));		
			row.add(pa.get("id"));
			row.add(pa.get("order_id"));
			row.add(pa.get("seed_name"));
			row.add(pa.get("status"));
			// 操作列，需要第一列填充空数据
		    row.add("");
			json.put("cell", row);			
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * 修改种子类型
	 */
	public void gDSaveSeedType() {
		MSeedType seedType = getModel(MSeedType.class, "seed_type");
		if ("edit".equals(getPara("oper"))) {
			seedType.update();
		}
		redirect("/seedManage/seed");
	}
	
	/**
	 * 种子类型编辑初始化
	 */
	public void seedTypeDetail() {
		String pid=getPara("id");
		JSONObject result = new JSONObject();
		MSeedType mSeedType = new MSeedType();
		
		if (StringUtil.isNotNull(pid)) {
			mSeedType = MSeedType.dao.findById(pid);
			if (mSeedType != null) {
				// 查找套餐图片对象
				TImage image = new TImage();
				result.put("image", image.findById(mSeedType.getInt("image_id")));		
				result.put("success", true);
				result.put("data", mSeedType);
				result.put("msg", "查询成功");
			} else {
				result.put("success", false);
				result.put("errmsg", "未查到此条记录");
			}
			
		}else{
			result.put("success", false);
			result.put("errmsg", "参数id为null");
		}
		
		renderJson(result);
	}
	
	/**
	 * 保存种子类型
	 */
	public void saveSeedType() {
		MSeedType model = getModel(MSeedType.class, "seedType");

		TImage image = new TImage();
		String imageSrc = getPara("image_src");
		image.set("save_string", imageSrc);
		image.save();

		Record record = new Record();
		record.setColumns(model2map(model));
		record.set("image_id", image.getInt("id"));
		if (StringUtil.isNull(getPara("seedType.id"))) {
			Db.save("m_seed_type", record);
		} else {
			Db.update("m_seed_type", record);
		}
		redirect("/seedManage/seed");
	}
	
	/**
	 * Ajax删除种子类型--业务上不允许删除种子类型，保留删除接口
	 */
	public void delSeedTypeAjax() {
	    String ids = getPara("ids");
		JSONObject result = new JSONObject();
		String sql = "delete from m_seed_type where id=";
        String[] idArr;
        
		if (StringUtil.isNotNull(ids)) {
			//删除之前先考虑有没有正在进行的种子活动
		    Record obj=Db.findFirst("select * from m_activity where activity_type=18 and yxbz=Y");
			if(obj!=null){
				result.put("success", true);
				result.put("msg", "活动进行中，无法删除种子类型");
				renderJson(result);
				return;
			}
			
			idArr=ids.split(",");
			if(idArr.length==1){
				Db.update(sql+idArr[0]);
			}else{
				for (int i = 0; i < idArr.length; i++) {
				    Db.update(sql+idArr[i]);
                }
			}
			result.put("success", true);
			result.put("msg", "删除成功");
		}else{
			result.put("success", false);
			result.put("msg", "删除失败,参数为空");
		}
		renderJson(result);
	}
	
	
	
	/**
	 * 套餐编辑初始化
	 */
	public void comboDetail() {
		String pid=getPara("id");
		JSONObject result = new JSONObject();
		
		if (StringUtil.isNotNull(pid)) {
			MPackage mPackage = MPackage.dao.findById(pid);
			if (mPackage != null) {
				//先判断此套餐是否已经有业务数据关联（被兑换）
				Record obj=Db.findFirst("select * from m_seed_instance where activity_id=? and exchange_id=?",mPackage.getInt("activity_id"),pid);
			    if(obj!=null){
			    	result.put("success", false);
					result.put("msg", "已产生相关业务数据，无法修改套餐基本信息");
					renderJson(result);
					return;
			    }
			    
				// 查找套餐图片对象
				TImage image = new TImage();
				result.put("image", image.findById(mPackage.getInt("image_id")));
				
				// 查询套餐关联的种子信息
				List<Record> packageSeedR = Db.find("select r.* from m_package_seed_r r where package_id=?",pid);
				JSONArray seedExchangeItems = new JSONArray();
				for (Record r : packageSeedR) {
					JSONObject seedExchangeItem = new JSONObject();
					seedExchangeItem.put("seedType", r.get("seed_type_id"));
					seedExchangeItem.put("seedNum", r.get("amount"));
					seedExchangeItems.add(seedExchangeItem);
				}
				result.put("seedExchangeCombo", seedExchangeItems);
				
				// 查询套餐关联的商品信息
				JSONArray proExchangeItems = new JSONArray();
				List<Record> packageProR = Db.find(
				"select m.*,p.product_name from m_package_product m left join t_product p on m.product_id=p.id where package_id=?",pid);
				for (Record r : packageProR) {
					JSONObject proExchangeItem = new JSONObject();
					proExchangeItem.put("proId", r.get("product_id"));
					proExchangeItem.put("proUnitId", r.get("product_f_id"));
					proExchangeItem.put("proNum", r.get("amount"));
					proExchangeItem.put("proName", r.get("product_name"));
					proExchangeItems.add(proExchangeItem);
				}
				result.put("proExchangeCombo", proExchangeItems);
				
				result.put("success", true);
				result.put("data", mPackage);
				result.put("msg", "查询成功");
			} else {
				result.put("success", false);
				result.put("msg", "未查到此条记录");
			}
			
		}else{
			result.put("success", false);
			result.put("msg", "参数id为null");
		}

		renderJson(result);
	}
	
	//判断当前活动是否有人已经获取种子，用于判定是否允许删除种子活动相关数据
	private boolean isActivityOpen(int activityId){
		Record result=Db.findFirst("select count(1) as c from m_seed_instance where activity_id=?",activityId);
		return result.getLong("c")>0;
	}
	
    /** 
     * 保存种子套餐
     */
	public void savePackage() {
		String seedExchangeCombo = getPara("seedExchangeCombo");
		String proExchangeCombo = getPara("proExchangeCombo");
		String imageSrc = getPara("image_combo_src");
        String acid=getPara("activity_id");
        String pid=getPara("package.id");
        
		MPackage model = getModel(MPackage.class, "package");
		Record record = new Record();
		record.setColumns(model2map(model));
		
        //保存上传的图片-入库
		TImage image = new TImage();
		image.set("save_string", imageSrc);
		image.save();
		record.set("image_id", image.getInt("id"));
		
		if (StringUtil.isNull(pid)) {
			record.set("activity_id",acid);
			Db.save("m_package", record);
		} else {		
			Db.update("m_package", record);
		}
		// 套餐对应的种子
		JSONArray seedExchanges = JSONArray.parseArray(seedExchangeCombo);
		// 先清空数据
		Db.update("delete from m_package_seed_r where package_id=" + record.get("id"));
		for (int i = 0; i < seedExchanges.size(); i++) {
			MPackageSeedR packageSeedR = new MPackageSeedR();
			packageSeedR.set("package_id", record.get("id"));
			packageSeedR.set("seed_type_id", seedExchanges.getJSONObject(i).getInteger("seedType"));
			packageSeedR.set("amount", seedExchanges.getJSONObject(i).getInteger("seedNum"));
			packageSeedR.save();
		}
		// 套餐对应的商品
		JSONArray proExchanges =JSONArray.parseArray(proExchangeCombo);
		Db.update("delete from m_package_product where package_id=" + record.get("id"));
		for (int i = 0; i < proExchanges.size(); i++) {
			MPackageProduct packageProduct = new MPackageProduct();
			packageProduct.set("product_id", proExchanges.getJSONObject(i).getInteger("proId"));
			packageProduct.set("product_f_id", proExchanges.getJSONObject(i).getInteger("proUnitId"));
			packageProduct.set("package_id", record.get("id"));
			packageProduct.set("amount", proExchanges.getJSONObject(i).getInteger("proNum"));
			packageProduct.set("status", "Y");
			packageProduct.save();
		}
		redirect("/seedManage/seedEdit?id="+acid);
	}

	/**
	 * ajax修改单品类型
	 */
	public void gDSavePackage() {
		MPackage mPackage = getModel(MPackage.class, "package");
		if ("edit".equals(getPara("oper"))) {
			mPackage.update();
		}
		redirect("/seedManage/seed");
	}

	/**
	 * 套餐列表
	 */
	public void getPackageList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String package_name = getPara("package_name");
		String acid=getPara("activity_id");
		String status=getPara("status");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		
		Page<MPackage> pageInfo = null;
		String sqlStr = "from m_package where 1=1";
		
		if(StringUtil.isNotNull(acid)){
			sqlStr +=" and activity_id="+acid;
		}
		
		if (StringUtil.isNotNull(package_name)) {
			sqlStr += " and package_name like '%" + package_name + "%' ";
		}
		
		if (StringUtil.isNotNull(status)) {
			sqlStr += " and status='"+status+"' ";
		}
		
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		
		pageInfo = MPackage.dao.paginate(page, pageSize, "select *", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MPackage pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("package_name"));
			row.add(pa.get("order_id"));
			row.add(pa.get("type_id"));
			row.add(pa.get("status"));
			// 操作列，需要第一列填充空数据
			row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 单品编辑初始化
	 */
	public void singleDetial() {
		String sid = getPara("id");
		JSONObject result = new JSONObject();
		MSeedProduct seedProduct = new MSeedProduct();
		MProductSeedR seedPrdouctR= new MProductSeedR();
		
		if (StringUtil.isNotNull(sid)) {
			int pid=Integer.parseInt(sid);
			seedProduct = seedProduct.findById(sid);
			List<MProductSeedR> seedProductList=seedPrdouctR.dao.getMProductSeedR(pid);
			JSONArray seedProArr = new JSONArray();
			if(seedProduct!=null){
				//先判断此单品是否已经有业务数据关联（被兑换）
				Record obj=Db.findFirst("select * from m_seed_instance where activity_id=? and exchange_id=?",seedProduct.getInt("activity_id"),sid);
			    if(obj!=null){
			    	result.put("success", false);
					result.put("msg", "已产生相关业务数据，无法修改此单品基本信息");
					renderJson(result);
					return;
			    }
			    
				for(MProductSeedR m: seedProductList){
					JSONObject json = new JSONObject();
					json.put("seedType",m.get("seed_type_id"));
					json.put("seedNum",m.get("amount"));
					seedProArr.add(json);
				}
				 result.put("seedProList",seedProArr);
				 
				 result.put("success", true);
				 result.put("data", seedProduct);
				 result.put("msg", "查询成功");
			 }else{
				 result.put("success", false);
				 result.put("msg", "未查到此条记录");
			 }
		}else{
			result.put("success", false);
			result.put("msg", "参数id为null");
		}	
		
		renderJson(result);
	}

	/**
	 * 保存单品
	 */
	public void saveSeedProduct() {
		MSeedProduct model = getModel(MSeedProduct.class, "seedProduct");
		String acid=getPara("seedProduct.activity_id");
		String sid=getPara("seedProduct.id");
		Record record = new Record();
		record.setColumns(model2map(model));
		
		if (StringUtil.isNull(sid)) {
			Db.save("m_seed_product", record);
		} else {		
			Db.update("m_seed_product", record);
		}
		
		//获取保存后返回的id
		Number id = record.getNumber("id");
		//先删除以前的种子关系表
		Db.update("delete from m_product_seed_r where seed_product_id=?",id.intValue());
		String seedExchangeSingle = getPara("seedExchangeSingle");
		JSONArray arry = JSONArray.parseArray(seedExchangeSingle);
		for (int i = 0; i < arry.size(); i++) {
			MProductSeedR r = new MProductSeedR();
			JSONObject single = arry.getJSONObject(i);
			r.set("seed_product_id", id.intValue());
			r.set("seed_type_id", single.getIntValue("seedType"));
			r.set("amount", single.getIntValue("seedNum"));
			r.save();
		}
		redirect("/seedManage/seedEdit?id="+acid);
	}

	/**
	 * ajax修改单品类型
	 */
	public void gDSaveSeedProduct() {
		MSeedProduct seedProduct = getModel(MSeedProduct.class, "seed_product");
		if ("edit".equals(getPara("oper"))) {
			seedProduct.update();
		}
		redirect("/seedManage/seed");
	}

	/**
	 * 单品列表
	 */
	public void getSeedProductList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		
		String acid=getPara("activity_id");
		String singleName=getPara("single_name");
		String status=getPara("status");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<MSeedProduct> pageInfo = null;
		
		String sqlStr = "from m_seed_product m left join t_product p on m.product_id=p.id where 1=1";
		
		if(StringUtil.isNotNull(acid)){
			sqlStr += " and m.activity_id="+acid;
		}
		
		if (StringUtil.isNotNull(status)) {
			sqlStr += " and m.status='"+status+"' ";
		}
		
		if (StringUtil.isNotNull(singleName)) {
		    sqlStr +=" and m.single_name like '%" + singleName+ "%' ";
		}
			
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		
		pageInfo = MSeedProduct.dao.paginate(page, pageSize, "select m.*,p.product_name", sqlStr);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (MSeedProduct pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			row.add(pa.get("id"));
			row.add(pa.get("single_name"));
			row.add(pa.get("product_name"));
			row.add(pa.get("order_id"));
			row.add(pa.get("type_id"));
			row.add(pa.get("status"));
			// 操作列，需要第一列填充空数据
		    row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 套餐或者单品需要选择的商品
	 */
	public void seedSelectToAddProductList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");// 排序的字段
		String sord = getPara("sord");// 升序或者降序
		Page<Record> pageInfo = null;
		String sqlStr = null;

		sqlStr = "from  t_product_f pf " + " left join t_product p on pf.product_id=p.id "
				+ " left join t_image i on p.img_id=i.id " + " left join t_unit u on pf.product_unit=u.unit_code "
				+ "  where pf.is_vlid='Y' and p.product_status='01' ";
		if (StringUtil.isNotNull(sidx)) {
			sqlStr += " order by " + sidx + " " + sord;
		}
		pageInfo = Db.paginate(page, pageSize,
				"select i.save_string,p.id,p.product_name,pf.price,pf.special_price,pf.product_unit,pf.standard,pf.id as pf_id,u.unit_name ",
				sqlStr);
		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		JSONArray rows = new JSONArray();
		for (Record r : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", r.get("pf_id"));
			row.add(r.get("pf_id"));
			row.add(r.get("save_string"));
			row.add(r.get("product_name"));
			row.add(r.get("price"));
			row.add(r.get("special_price"));
			row.add(r.get("id"));
			row.add(r.get("pf_id"));
			row.add(r.get("standard"));
			row.add(r.get("unit_name"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
	
	/**
	 * 区间段种子领取情况统计
	 */
	public void intarvalCount(){
		int activity_id=getParaToInt("id");
		String begainTime=getPara("start_time");
		String endTime=getPara("end_time");
		
		JSONObject result = new JSONObject();
		JSONArray legendArr=new JSONArray();
		JSONArray seriesData=new JSONArray();
		
		//各类型种子区间段领取数量
		List<Record> seedTypeCount=MInterval.dao.intervalStatistic(activity_id,begainTime,endTime);
		for(int i=0;seedTypeCount.size()>i;i++){
			JsonPojo json = new JsonPojo();
			json.setName(seedTypeCount.get(i).getStr("seed_name"));
			json.setValue(seedTypeCount.get(i).getLong("seedCount"));
			seriesData.add(json);
			legendArr.add(seedTypeCount.get(i).getStr("seed_name"));
		}
		result.put("seriesData", seriesData);
		result.put("legendArr", legendArr);
		renderJson(result);
	}
}
