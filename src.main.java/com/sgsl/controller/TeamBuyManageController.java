package com.sgsl.controller;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MTeamBuy;
import com.sgsl.model.MTeamBuyScale;
import com.sgsl.model.TCouponScale;
import com.sgsl.model.TImage;
import com.sgsl.util.DateUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.ObjectToJson;
import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;

public class TeamBuyManageController extends BaseController {

	protected final static Logger logger = Logger.getLogger(TeamBuyManageController.class);
	
	public void groupBooking(){
		render(AppConst.PATH_MANAGE_PC + "/teamBuy/groupBooking.ftl");
	}
	
	/**
	 * 拼团活动列表
	 */
	public void groupActivity(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        Page<Record> pageInfo = Db.paginate(page, pageSize, "select *", "from m_activity where activity_type=10 and yxbz='Y'");
        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber()); 
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            row.add(rc.getInt("id"));
            row.add(rc.getStr("main_title"));
            row.add(rc.getStr("url"));
            row.add(rc.getInt("status"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	 /**
     * 充值记录导出
     */
    public void exportRecharge(){
    	String rechargeDateBegin=null,rechargeDateEnd=null;
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
        	if("rechargeDateBegin".equals(item.getString("name"))){
        		rechargeDateBegin=item.getString("value");
        	}else if("rechargeDateEnd".equals(item.getString("name"))){
        		rechargeDateEnd=item.getString("value");
        	}
        }
    	
        if(StringUtil.isNull(rechargeDateBegin)){
        	rechargeDateBegin=DateFormatUtil.format5(date)+"000000";
        }else{
        	Date rechargeDateBeginData= DateUtil.convertString2Date(rechargeDateBegin);
        	rechargeDateBegin=DateFormatUtil.format3(rechargeDateBeginData);
        }
        if(StringUtil.isNull(rechargeDateEnd)){
        	rechargeDateEnd=DateFormatUtil.format5(date)+"235959";
        }else{
        	Date rechargeDateEndData= DateUtil.convertString2Date(rechargeDateEnd);
        	rechargeDateEnd=DateFormatUtil.format3(rechargeDateEndData);
        }
        String sql="select t.*,u.nickname "+
		" from t_pay_log t left join t_user u on t.openid=u.open_id "+
		" where  t.source_type='recharge' and t.time_end between '"+rechargeDateBegin+"' and '"+rechargeDateEnd+"'  order by t.time_end desc";
    	List<Record> list = Db.find(sql);
        String[] header=new String[colNamesJson.size()];
        colNamesJson.toArray(header);
        
        colModelJson.remove(0);
        String[] columns=new String[colModelJson.size()];
        for(int i=0;i<colModelJson.size();i++){
        	columns[i]=colModelJson.getJSONObject(i).getString("name");
        }
        String fileName="rechargeList.xls";
        Render poirender = PoiRender.me(list).fileName(fileName)
        		.headers(header).sheetName(rechargeDateBegin.substring(0,10)+"至"+rechargeDateEnd.substring(0,10)+"充值 导出").columns(columns);
        render(poirender);
    }
	
	/**
	 * 活动编辑或者查看
	 */
	public void eidtGroupActivity(){
		int id = getParaToInt("id");
		JSONObject result=new JSONObject();
		Record groupActivity = Db.findById("m_activity", id);
		JSONObject group = ObjectToJson.recordConvert(groupActivity);
		System.out.println(groupActivity.get("image_id")+"=========");
		Record image =Db.findById("t_image", groupActivity.getInt("img_id"));
		if(image!=null){
			result.put("image_name", image.get("save_string"));
		}
		result.put("group", group);
		renderJson(result);
	}
	
	public void eidtGroup(){
		MActivity activity = getModel(MActivity.class,"activity");
		String save_string = getPara("image_src");
		String img_id=getPara("activity.img_id");
		TImage image=TImage.dao.findById(getPara("activity.img_id"));
		image.set("save_string", save_string);
		image.update();
		activity.set("img_id", img_id);
		TCouponScale.dao.updateInfo(model2map(activity), getParaToInt("activity_id1"), "m_activity");
		redirect("/teamBuyManage/groupBooking");
	}
	
	/**
	 * 活动开启或关闭
	 */
	public void activityOpenOrClose(){
		int id=getParaToInt("id");
		JSONObject mes = new JSONObject();
		MActivity mActivity=MActivity.dao.findById(id);
		List<Record> activityProductList = Db.find("select * from m_activity_product where activity_id=? and status=0", mActivity.getInt("id"));
		int status=getParaToInt("status");
		if(status==0){
			if(activityProductList.size()>0){
				mes.put("mes", "团购存在上架的商品，不能关闭活动，请先下架商品在操作！");
				renderJson(mes);
				return;
			}
			mActivity.set("status",1);
			mes.put("mes", "关闭成功！");
		}else if(status==1){
			mActivity.set("status", 0);
			mes.put("mes", "启动成功！");
		}
		mActivity.update();
		renderJson(mes);
	}
	
	/**
	 * 拼团活动数据统计
	 */
	public void groupCount(){
		String createBeginTime=getPara("createBeginTime");
		String createEndTime=getPara("createEndTime");
		JSONObject result = new JSONObject();
		//开团数
		long beginTourNum=MTeamBuy.dao.beginTourNum(createBeginTime,createEndTime);
		result.put("beginTourNum", beginTourNum);
		//成团数
		long successTourNum= MTeamBuy.dao.successTourNum(createBeginTime,createEndTime);
		result.put("successTourNum",successTourNum);
		//销售额统计
		BigDecimal totalNum = MTeamBuy.dao.totalNum(createBeginTime,createEndTime);
		result.put("totalNum", totalNum);
		//成功订单总数
		BigDecimal successOrderTotalNum = MTeamBuy.dao.successOrderTotalNum(createBeginTime,createEndTime);
		result.put("successOrderTotalNum", successOrderTotalNum);
		//商品销量排行TOP5（订单数仅统计成功订单数，不包括退货订单）
		List<Record> productOrderCount=MTeamBuy.dao.productOrderCount(createBeginTime,createEndTime);
		result.put("productOrderCount", productOrderCount);
		renderJson(result);
	}
	
	/**
	 * 拼团商品列表
	 */
	public void productActivity(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String product_name=getPara("productName");
        String up_time=getPara("up_time");
        String down_time=getPara("down_time");
        String productStatus=getPara("productStatus");
        //int activity_id=getParaToInt("activity_id");
        // DOTO 活动Id是传的常量
        String select = "select map.id,map.dis_order,map.product_id"
        		+ ",map.create_time,tp.product_name,map.up_time,map.down_time,map.status,map.product_f_id ";
        String from = "from m_activity ma left join m_activity_product map on ma.id=map.activity_id "
        		+ "left join t_product tp on tp.id=map.product_id left join t_product_f tpf on tpf.id=map.product_f_id"
        		+ " where map.activity_id in (select id from m_activity where activity_type=10 and yxbz='Y') ";
        if(StringUtil.isNotNull(product_name)){
        	from+="and tp.product_name like '%"+product_name+"%' ";
        }
        if(StringUtil.isNotNull(up_time)&&StringUtil.isNotNull(down_time)){
        	from+="and '"+up_time+"' >=map.up_time and '"+up_time+"'<=map.down_time "
    			+ "and '"+down_time+"' >=map.up_time and '"+down_time+"'<=map.down_time  ";
        }
        if(StringUtil.isNotNull(productStatus)){
        	from+="and map.status="+productStatus;
        }
        from +=" order by map.create_time desc";
        Page<Record> pageInfo = Db.paginate(page, pageSize, select, from);
        
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
            row.add(rc.getInt("product_id"));
            row.add(rc.getInt("dis_order"));
            row.add(rc.getStr("create_time"));
            row.add(rc.getStr("product_name"));
            row.add(rc.getStr("up_time"));
            row.add(rc.getStr("down_time"));
            row.add(rc.getInt("status"));
            row.add(rc.getInt("product_f_id"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	
	/**
	 * 判断团购商品是否有正在开拼团数
	 */
	public void isSuccessTeam(){
		JSONObject result = new JSONObject();
		String sql = "select count(*) as teamNum from m_team_buy mtb "
				+" LEFT JOIN m_team_buy_scale tbs on mtb.m_team_buy_scale_id=tbs.id "
				+" LEFT JOIN m_activity_product map on tbs.activity_product_id = map.id "
				+" LEFT JOIN m_team_member tm on tm.team_buy_id=mtb.id and tm.team_user_id=mtb.tour_user_id "
				+" where mtb.`status`=1 and map.product_f_id=? and map.status=0 and tm.is_pay in('Y','D')";
		result.put("groupBooking", Db.findFirst(sql, getParaToInt("pf_id")));
		renderJson(result);
	}
	
	/**
	 * 商品上下架
	 */
	public void productOpenOrClose(){
		int id=getParaToInt("id");
		JSONObject mes = new JSONObject();
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentTime = df.format(new Date());//当前时间
		MActivityProduct mActivityProduct=MActivityProduct.dao.findById(id);
		int status=getParaToInt("status");
		if(status==0){
			mActivityProduct.set("status", 2);
			mActivityProduct.set("down_time", DateFormatUtil.format1(new Date()));
			mes.put("mes", "下架成功！");
		}else if(status==1||status==2){
			if(currentTime.compareTo(mActivityProduct.getStr("down_time"))>0){
				mes.put("mes", "拼团结束时间不能小于当前时间！");
				renderJson(mes);
				return;
			}
			
			if(currentTime.compareTo(mActivityProduct.getStr("up_time"))<0){
				mes.put("mes", "团购商品不能提前上架！");
				renderJson(mes);
				return;
			}
			
			List<Record> teamBuyScaleList = Db.find("select * from m_team_buy_scale where activity_product_id=? and yxbz='Y' ", id);
			if(teamBuyScaleList.size()==0){
				mes.put("mes", "商品团购规模不能为空或者没有开启！");
				renderJson(mes);
				return;
			}
			mActivityProduct.set("status", 0);
			mes.put("mes", "上架成功！");
		}
		mActivityProduct.update();
		renderJson(mes);
	}
	
	/**
	 * 删除团购商品
	 */
	public void delProAndScaleRelevance(){
		JSONObject mes = new JSONObject();
		String ids=getPara("ids");
		for(String id:ids.split(",")){
			MActivityProduct activityProduct= MActivityProduct.dao.findById(id);
			if(activityProduct!=null){
				MTeamBuyScale teamBuyScale = MTeamBuyScale.dao.findFirst("select *from m_team_buy_scale where activity_product_id=?", activityProduct.getInt("product_id"));
				if(teamBuyScale!=null){
					teamBuyScale.delete();
				}
			}
			activityProduct.delete();
		}
		mes.put("mes", "商品删除成功！");
		renderJson(mes);
	}
	
	/**
	 * 活动商品
	 */
	public void initTeamProduct(){
		String id=getPara("id");
		String activity_id=getPara("activity_id");
		if(StringUtil.isNotNull(id)){
			Record activityProduct = Db.findById("m_activity_product", getParaToInt("id"));
			Record product = Db.findById("t_product", activityProduct.getInt("product_id"));
			setAttr("activityProduct", activityProduct);
			setAttr("product_name", product.get("product_name"));
		}else{
			setAttr("activity_id", activity_id);
		}
		render(AppConst.PATH_MANAGE_PC + "/teamBuy/editTeamProduct.ftl");
	}
	
	/**
	 * 拼团商品查看
	 */
	public void productDetail(){
		String id=getPara("id");
		JSONObject result = new JSONObject();
		if(StringUtil.isNotNull(id)){
			Record activityProduct = Db.findById("m_activity_product", getParaToInt("id"));
			Record product = Db.findById("t_product", activityProduct.getInt("product_id"));
			result.put("activityProduct", activityProduct);
			result.put("product", product);
	        renderJson(result);
		}
	}
	
	/**
	 * 搜索查询关联商品
	 */
	public void initSelectTeamProduct(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String product_name=getPara("product_name");
        String product_code=getPara("product_code");
        //int activity_id=getParaToInt("activity_id");

        String select = "select t.id,pf.id product_fid, t.product_code,t.product_name,u.unit_name,pf.price,pf.is_vlid ";
        String from = "from t_product_f pf "
        		+ "left join t_product t on t.id=pf.product_id left join t_unit u on pf.product_unit=u.unit_code "
        		+ "where t.product_status='01' and t.fresh_format is NULL ";
        if(StringUtil.isNotNull(product_name)){
        	from+="and t.product_name like '%"+product_name+"%' ";
        }
        if(StringUtil.isNotNull(product_code)){
        	from+="and t.product_code like '%"+product_code+"%' ";
        }
        /*if(StringUtil.isNotNull(up_time)&&StringUtil.isNotNull(down_time)){
        	from+="and map.up_time between '"+up_time+"' and '"+down_time+"' ";
        }*/
        Page<Record> pageInfo = Db.paginate(page, pageSize, select, from);
        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record rc:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            row.add(rc.get("id"));
            row.add(rc.get("product_fid"));
            row.add(rc.get("product_code"));
            row.add(rc.get("product_name"));
            row.add(rc.get("unit_name"));
            row.add(rc.getInt("price"));
            row.add(rc.get("is_vlid"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	
	/**
	 * 拼团商品修改/添加
	 */
	public void saveTeamProduct(){
		MActivityProduct activityProduct = getModel(MActivityProduct.class,"activityProduct");
		String id=getPara("activity_product_id");
		int activity_product_id=-1;
		if(StringUtil.isNull(id)){
			activityProduct.set("create_time", DateFormatUtil.format1(new Date()));
			activityProduct.set("activity_price", getParaToInt("activity_price"));
			activityProduct.save();
			activity_product_id=activityProduct.getInt("id");
		}else{
			activity_product_id=getParaToInt("activity_product_id");
			TCouponScale.dao.updateInfo(model2map(activityProduct), getParaToInt("activity_product_id"), "m_activity_product");
		}
		redirect("/teamBuyManage/initTeamProduct?id="+activity_product_id);
	}
	
	/**
	 * 团购规模设置
	 */
	public void teamProductScal(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        int activity_product_id=getParaToInt("activity_product_id");
        String select = "select tgm.id,tgm.dis_order,t.product_name,tgm.person_count,tgm.activity_price_reduce,tgm.team_open_times,tgm.team_buy_times,tgm.yxbz ";
        String from = "from m_team_buy_scale tgm left join m_activity_product ap on ap.id=tgm.activity_product_id left join t_product t on ap.product_id=t.id ";
        	from+= "where tgm.activity_product_id= ?";
        Page<Record> pageInfo = Db.paginate(page, pageSize, select, from,activity_product_id);
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
            row.add(rc.get("product_name"));
            row.add(rc.getInt("dis_order"));
            row.add(rc.getInt("person_count"));
            row.add(rc.getInt("activity_price_reduce"));
            row.add(rc.getInt("team_open_times"));
            row.add(rc.getInt("team_buy_times"));
            row.add(rc.get("yxbz"));
            json.put("cell",row);
            rows.add(json);
        }
        
        result.put("rows", rows);
        renderJson(result);
	}
	
	/**
	 * 团购规模编辑
	 */
	public void eidtProductScals(){
		String id=getPara("id");
		
		JSONObject result = new JSONObject();
		if(StringUtil.isNotNull(id)){
			Record teamScals=Db.findById("m_team_buy_scale", getParaToInt("id"));
			result.put("teamScals", teamScals);
		}
		renderJson(result);
	}
	
	/**
	 * 添加/修改团购规模
	 */
	public void saveProduct(){
		MTeamBuyScale teamBuyScale = new MTeamBuyScale();
		JSONObject mes =new JSONObject();
		Map<String,Object> map = new HashMap<String,Object>();
		String id=getPara("team_scale_id");
		String product_id=getPara("product_id");
		if(StringUtil.isNull(product_id)){
			mes.put("mes", "拼团商品不能为空！");
			renderJson(mes);
			return;
		}
		int team_open_times=0;
		int team_buy_times=0;
		if(StringUtil.isNull(getPara("team_open_times"))){
			 team_open_times=9999;
		}else{
			 team_open_times = getParaToInt("team_open_times");
		}
		if(StringUtil.isNull(getPara("team_buy_times"))){
			 team_buy_times=9999;
		}else{
			 team_buy_times=getParaToInt("team_buy_times");
		}
		
		int dis_order=getParaToInt("dis_order");
		int person_count=getParaToInt("person_count");
		int activity_price_reduce=getParaToInt("activity_price_reduce");
		int activity_product_id = getParaToInt("activity_product_id");
		
		if(StringUtil.isNull(id)){
			teamBuyScale.set("dis_order", dis_order);
			teamBuyScale.set("person_count", person_count);
			teamBuyScale.set("activity_price_reduce", activity_price_reduce);
			teamBuyScale.set("team_open_times", team_open_times);
			teamBuyScale.set("team_buy_times", team_buy_times);
			teamBuyScale.set("activity_product_id", activity_product_id);
			teamBuyScale.set("yxbz", "Y");
			teamBuyScale.save();
			mes.put("mes", "拼团规模添加成功！");
		}else{
			map.put("dis_order", dis_order);
			map.put("person_count", person_count);
			map.put("activity_price_reduce", activity_price_reduce);
			map.put("team_open_times", team_open_times);
			map.put("team_buy_times", team_buy_times);
			map.put("team_buy_times", team_buy_times);
			map.put("activity_product_id", activity_product_id);
			TCouponScale.dao.updateInfo(map, 
					getParaToInt("team_scale_id"), "m_team_buy_scale");
			mes.put("mes", "拼团规模修改成功！");
		}
		mes.put("id", activity_product_id);
		renderJson(mes);
	}
	
	/**
	 * 团购规模设置开启/关闭
	 */
	public void scaleOpenOrClose(){
		int id=getParaToInt("id");
		JSONObject mes = new JSONObject();
		MTeamBuyScale teamBuyScale=MTeamBuyScale.dao.findById(id);
		String status=getPara("status");
		if("Y".equals(status)){
			teamBuyScale.set("yxbz", "N");
			mes.put("mes", "已关闭！");
		}else if("N".equals(status)){
			teamBuyScale.set("yxbz", "Y");
			mes.put("mes", "已开启！");
		}
		teamBuyScale.update();
		renderJson(mes);
	}
	
	/**
	 * 删除团购规模
	 */
	public void delScale(){
		JSONObject mes = new JSONObject();
		String ids=getPara("ids");
		for(String id:ids.split(",")){
			Db.deleteById("m_team_buy_scale", id);
		}
		mes.put("mes", "删除成功！");
		renderJson(mes);
	}
	
	/**
	 * 商品数据统计
	 */
	public void proSaltCount(){
		int id=getParaToInt("id");
		String createBeginTime=getPara("createBeginTime");
		String createEndTime=getPara("createEndTime");
		JSONObject result = new JSONObject();
		List<Record> teamBuyList = MTeamBuy.dao.proSaltCount(id, createBeginTime, createEndTime);
		result.put("teamBuyList", teamBuyList);
		renderJson(result);
	}
	
}
