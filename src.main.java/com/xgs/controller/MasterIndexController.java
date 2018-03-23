package com.xgs.controller;

import java.util.List;
import com.jfinal.plugin.activerecord.Page;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.MCarousel;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.ObjectToJson;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.xgs.model.XFruitMaster;

/**
 * 
 * @author TW 鲜果师项目首页
 */
public class MasterIndexController extends BaseController {

	//访问次数标记
	private AtomicInteger viewTimes= new AtomicInteger(0);
	
	private Map<String,Object> cacheMap=new ConcurrentHashMap<String,Object>(20);
		
	/**
	 * 鲜果师项目首页
	 */
	@Before(OAuth2Interceptor.class)
	public void index() {
		int viewTimesLocal = viewTimes.get();
		//设置用户入口的来源，默认为空，也可能是code(二维码入口)
		setSessionAttr("from", getPara("from"));
		if(viewTimesLocal==100){
			viewTimes.set(0);
		}else{
			viewTimes.addAndGet(1);
		}
		JSONObject json =new JSONObject();
		// 鲜果师首页轮播图
		List<MCarousel> mCarousels=(List<MCarousel>)cacheMap.get("mCarousels");
		JSONArray bannerList = new JSONArray();
		if(mCarousels==null||viewTimesLocal==0){
			MCarousel mCarousel = new MCarousel();
			mCarousels = mCarousel.dao.find("select c.*,i.save_string from m_carousel c left join t_image i on c.img_id=i.id "
					+ "where c.type_id=? order by c.order_id asc",1);
			for (MCarousel item:mCarousels) {
				JSONObject mc =new JSONObject();
				mc.put("id", item.getInt("id"));
				mc.put("url", item.get("url"));
				mc.put("img", item.get("save_string"));
				bannerList.add(mc);
			}
			cacheMap.putIfAbsent("mCarousels",mCarousels);
		}
		json.put("bannerList", bannerList);
		
		//明星鲜果师
		List<Record> xFruitMasters=(List<Record>)cacheMap.get("xFreshFruit");
		JSONArray starMasterList = new JSONArray();
		if(xFruitMasters==null||viewTimesLocal==0){
			XFruitMaster xFruitMaster = new XFruitMaster();
			xFruitMasters = xFruitMaster.findMasterStar();
			for(Record item:xFruitMasters){
				JSONObject xf = new JSONObject();
				xf.put("id", item.getInt("id"));
				xf.put("img", item.get("star_head_image"));
				xf.put("name", item.get("master_name"));
				xf.put("level", item.get("master_nc"));
				starMasterList.add(xf);
			}
			cacheMap.putIfAbsent("xFreshFruits",xFruitMasters);
		}
		json.put("starMasterList", starMasterList);
		
		//食鲜之味文章
		List<Record> xArticles=(List<Record>)cacheMap.get("xArticle");
		JSONArray artList = new JSONArray();
		if(xArticles==null||viewTimesLocal==0){
			xArticles = Db.find("select a.*,x.head_image as xg_headPictrue ,x.master_name,x.master_nc,x.master_image from x_article a "
					+ "LEFT JOIN x_fruit_master x on a.master_id=x.id where a.is_sxzw=1");
			for(Record item:xArticles){
				JSONObject xa = new JSONObject();
				xa.put("name", item.get("master_name"));
				xa.put("level", item.get("master_nc"));
				xa.put("xg_headPictrue", item.get("xg_headPictrue"));
				xa.put("title", item.get("title"));
				xa.put("info", item.get("article_intro"));
				xa.put("bgImg", item.get("head_image"));
				//xa.put("url", item.get("url"));
				xa.put("article_id", item.get("id"));
				artList.add(xa);
			}
			cacheMap.putIfAbsent("xArticles",xArticles);
		}
		json.put("artList", artList);
		//设置分享所需参数
		FoodFreshController.setShareParams(getRequest(),json);
		
		setAttr("indexData",JSONObject.toJSONString(json));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/index.ftl");
	}

	/**
	 * 鲜果师详情
	 */
	public void masterDetail() {   
		//鲜果师详情
		int master_id = getParaToInt("master_id");
		XFruitMaster xFruitMaster = XFruitMaster.dao.findById(master_id);
		JSONObject masterDetail = new JSONObject();
		masterDetail.put("master_image", xFruitMaster.get("master_image"));
		masterDetail.put("master_name", xFruitMaster.get("master_name"));
		masterDetail.put("description", xFruitMaster.get("description"));
		masterDetail.put("is_fresh_star", xFruitMaster.get("is_fresh_star"));

		//原创文章
		List<Record> xArticles = Db.find("select * from x_article where status=0 and file_type='0' and master_id=? ", xFruitMaster.getInt("id"));
		JSONArray xArt = new JSONArray();
		for (Record item:xArticles) {
		    JSONObject xa = new JSONObject();
			xa.put("title", item.get("title"));
			xa.put("article_intro", item.get("article_intro"));
			xa.put("content_image", item.get("content_image"));
			xa.put("article_id", item.get("id"));
			xa.put("head_image", item.get("head_image"));
			xArt.add(xa);
		}
		masterDetail.put("xArticles", xArt);
		setAttr("masterDetail",JSONObject.toJSONString(masterDetail));
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterDetail.ftl");
	}


	/**
	 * 鲜果师列表
	 */
	public void masterList() {
		int pageSize=getParaToInt("size");
        int page=getParaToInt("page");
        XFruitMaster xFruitMaster = new XFruitMaster();
		Page<Record> xFruitMasters = xFruitMaster.findMasterList(pageSize, page);
		JSONObject masters = new JSONObject();
		List<Record> list = xFruitMasters.getList();
		JSONArray arry = ObjectToJson.recordListConvert(list);
		masters.put("masterList", arry);
	    setAttr("data",masters);
		render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterList.ftl");
	}
	
   public void LoadDetail()
   {
      int pageSize=getParaToInt("size");
      int page=getParaToInt("page");
     
      XFruitMaster xFruitMaster = new XFruitMaster();
      Page<Record> xFruitMasters = xFruitMaster.findMasterList(pageSize, page);
      JSONObject masters = new JSONObject();
	  List<Record> list = xFruitMasters.getList();
	  JSONArray arry = new JSONArray();
	  for(Record item:list){
			JSONObject mas = new JSONObject();
			mas.put("description", item.get("description"));
			mas.put("id", item.getInt("id"));
			mas.put("is_fresh_star", item.get("is_fresh_star"));
			mas.put("master_image", item.get("master_image"));
			mas.put("master_name", item.get("master_name"));
			mas.put("master_nc", item.get("master_nc"));
			mas.put("master_status", item.getInt("master_status"));
			mas.put("remaining_balance", item.getInt("remaining_balance"));
			arry.add(mas);
		}
		masters.put("masterList", arry);
        renderJson(masters);
   }
   
   public void masterSearch(){
       render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/masterSearch.ftl");
   }
	
	/**
	 * 鲜果师模糊搜索
	 */
	public void searchMasterList(){
		int pageSize = getParaToInt("pageSize");
		int pageNumber = getParaToInt("pageNumber");
		String keywords = getPara("keywords");
		JSONArray master ;
		if(keywords==null||keywords.equals("")){
			master = new JSONArray();
		}else{
			Page<Record> xFruitMaster = XFruitMaster.dao.findMasterAndContent(pageNumber,pageSize,keywords.trim());
			master = ObjectToJson.recordListConvert(xFruitMaster.getList());
		}
		renderJson(master);
	}

	/**
	 * 首页分享
	 */
	@Before(OAuth2Interceptor.class)
	public void shareIndex(){
		//type1   绑定鲜果师
		if(StringUtil.isNotNull(getPara("master_id"))){//master_id不为空的时候说明是鲜果师分享出来的链接，此时需要绑定一次用户
			int master_id = getParaToInt("master_id");
			TUser tUserSession = UserStoreUtil.get(getRequest());
			// 绑定鲜果师，被绑定过的不会再被绑定
			FruitMasterController.bindingMaster(tUserSession.getInt("id"), master_id);
		}
		//type2 跳转首页
		redirect(AppProps.get("app_domain") + "/masterIndex/index");
	}
}
