package com.xgs.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONArray;
import com.jfinal.aop.Before;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.MActivity;
import com.sgsl.model.MActivityProduct;
import com.sgsl.model.MCarousel;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.ObjectToJson;
import com.xgs.model.TProduct;
import com.xgs.model.TProductF;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;
import com.xgs.model.XArticle;
import com.xgs.model.XBonusPercentage;
import com.xgs.model.XFruitMaster;

/**
 * 
 * @author tw
 *	鲜果师商城
 */
public class FreshFruitMallController extends BaseController{
	protected final static Logger logger = Logger.getLogger(FreshFruitMallController.class);
	//访问次数标记,使用缓存，提速加载
	private AtomicInteger viewTimes= new AtomicInteger(0);
		
	private Map<String,Object> cacheMap=new ConcurrentHashMap<String,Object>(20);
	/**
	 * 商城首页
	 */
	@Before(OAuth2Interceptor.class)
	public void shopIndex(){
		//访问次数
		//int viewTimesLocal = viewTimes.get();
		JSONObject data = new JSONObject();
		//设置分享所需参数
		FoodFreshController.setShareParams(getRequest(),data);
		//首页banner轮播图
		List<Record> carousels = MCarousel.dao.findMCarousels(2);
		
		JSONArray carouselsArr = ObjectToJson.recordListConvert(carousels);
		
		data.put("bannerList", carouselsArr);
		
		//营养精选
		List<TProduct> tProducts = TProduct.dao.findMasterTProduct();
		JSONArray tProductArr = ObjectToJson.modelListConvert(tProducts);
		data.put("comboList", tProductArr);
		
		//=========食鲜推荐========
		// 最底下活动商品
		JSONArray recomendSection = new JSONArray();
		// 活动列表数据
		List<Record> bottomActivityList = MActivity.dao.findMActivitys(15);
		MActivityProduct mActivityProduct = new MActivityProduct();
		for (Record acRecord : bottomActivityList) {
			JSONObject recomend = new JSONObject();
			recomend.put("id", acRecord.getInt("id"));
			recomend.put("save_string", acRecord.getStr("save_string"));
			List<Record> products = mActivityProduct.findMasterMActivityProducts(acRecord.getInt("id"));
			JSONArray prJsonArr = ObjectToJson.recordListConvert(products);
			recomendSection.add(recomend);
			recomend.put("product_list", prJsonArr);
		}
		data.put("recomendSection", recomendSection);

		setAttr("data",JSONObject.toJSONString(data));

		render(AppConst.PATH_MANAGE_PC+"/client/fruitmaster/shopIndex.ftl");
	}
	
	/**
	 * 商城搜索跳转页
	 */
	public void searchShow(){
		render(AppConst.PATH_MANAGE_PC+"/client/fruitmaster/articleSearch.ftl");
	}
	
	/**
	 * 商城搜索内容
	 */
	public void search(){
		JSONObject search_result = new JSONObject();
		int pageNumber = getParaToInt("pageNumber");
		int pageSize = getParaToInt("pageSize");
		int type = getParaToInt("type");
		if(StringUtil.isNotNull(getPara("content"))){
			String content = getPara("content");
			if(type==1){
				//模糊精确搜索 1.搜索商品   TODO 模糊程度
				Page<TProduct> products = TProduct.dao.findMasterProductByContent(content,pageNumber,pageSize);
				JSONArray productArr = ObjectToJson.modelListConvert(products.getList());
				search_result.put("productList", productArr);
			}else{
				//2.搜索文章 
				Page<XArticle> articles =  XArticle.dao.findMasterArticleByContent(content,pageNumber,pageSize);
				JSONArray articleArr = ObjectToJson.modelListConvert(articles.getList());
				search_result.put("articleList", articleArr);
			}		
		}else{
			JSONArray productList = new JSONArray();
			JSONArray articleArr = new JSONArray();
			search_result.put("productList", productList);
			search_result.put("articleList", articleArr);
		}

		renderJson(search_result);
	}
	/**
	 * 文章详情
	 * @throws UnsupportedEncodingException 
	 */
	@Before(OAuth2Interceptor.class)
	public void articleDetail() throws UnsupportedEncodingException{
		int article_id = getParaToInt("article_id");
		JSONObject result = new JSONObject();
		//文章详情
		XArticle article= XArticle.dao.findMasterArctileById(article_id);
		result.put("article", ObjectToJson.modelConvert(article));
		//关联的商品
		List<TProduct> products = TProduct.dao.findArticleProduct(article_id); 
		result.put("products",ObjectToJson.modelListConvert(products));
		int productNum = 0;//缓存中商品总数
		if(getCookie("xgCartInfo")!=null){
			JSONArray xgCartInfo_number = JSONArray.parseArray(URLDecoder.decode(getCookie("xgCartInfo"), "UTF-8"));//获取购物车信息
			Iterator<Object> object =  xgCartInfo_number.iterator();
			JSONObject jsonObject;
			while(object.hasNext()){//累加购物车中总数
				jsonObject = (JSONObject) object.next();
				productNum+=jsonObject.getIntValue("product_num");
			}
		}
		result.put("productNum",productNum);//购物车商品总数
		//设置分享所需参数
		FoodFreshController.setShareParams(getRequest(),result);
		setAttr("result",result);
		System.out.println("====="+result);
		render(AppConst.PATH_MANAGE_PC+"/client/fruitmaster/contentDetail.ftl");
	}
	/**
	 * 商品详情
	 * @throws UnsupportedEncodingException
	 */
	@Before(OAuth2Interceptor.class)
	public void foodDetail() throws UnsupportedEncodingException {
		//TODO
		int product_id = getParaToInt("product_id");
		int product_fid = getParaToInt("product_fid");
		setAttr("pf_id",product_fid);
		
		//先找到这款商品信息
		TProduct product = TProduct.dao.findMasterProductById(product_id);
		
		JSONObject masterProduct=JSONObject.parseObject(product.toString());
		
		String[] imgs = product.getStr("save_string").split(",");
		masterProduct.put("detailList", imgs);
		XBonusPercentage bonusPercentage = XBonusPercentage.dao.findXBonusPercentage();
		//找到所有该商品的规格
		List<TProductF> productFs = TProductF.dao.findMasterTProductFByProductId(product.getInt("id"));
		for(TProductF item:productFs){
		  item.put("price", item.getInt("price"));
		  if(item.getInt("id")==product_fid){
		    masterProduct.put("money", item.getInt("price"));
		    masterProduct.put("bonus",(item.getInt("price")*bonusPercentage.getInt("sale_percentage"))/100);
		  }
		}
		masterProduct.put("standardList", ObjectToJson.modelListConvert(productFs));
		// 获取cookie中购物车商品数据
		String xgCartInfo = getCookie("xgCartInfo");
		if (StringUtil.isNotNull(xgCartInfo)) {
		  JSONArray xgCartInfoJson = JSONArray.parseArray(URLDecoder.decode(xgCartInfo, "UTF-8"));
		  int productNum = 0;
		  for (int i = 0; i < xgCartInfoJson.size(); i++) {
		    JSONObject item = xgCartInfoJson.getJSONObject(i);
		    productNum += item.getInteger("product_num");
		  }
		  masterProduct.put("proNum",productNum);  
		} else {
		  masterProduct.put("proNum",0);  
		}
		//设置分享所需参数
		FoodFreshController.setShareParams(getRequest(),masterProduct);
		//一种商品（包含所有规格）
		setAttr("product",JSONObject.toJSONString(masterProduct));
		render(AppConst.PATH_MANAGE_PC+"/client/fruitmaster/foodDetail.ftl");
  }
	  
	 /**
	 * 分享商城
	 */
	@Before(OAuth2Interceptor.class)
	public void shareShopIndex(){
		//step1   绑定鲜果师
		if(StringUtil.isNotNull(getPara("master_id"))){//master_id不为空的时候说明是鲜果师分享出来的链接，此时需要绑定一次用户
			int master_id = getParaToInt("master_id");
			TUser tUserSession = UserStoreUtil.get(getRequest());
			// 绑定鲜果师，被绑定过的不会再被绑定
			FruitMasterController.bindingMaster(tUserSession.getInt("id"), master_id);
		}
		//step2  跳转商城首页
		redirect(AppProps.get("app_domain") + "/mall/shopIndex");
	}
}

