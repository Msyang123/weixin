package com.xgs.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.core.io.FileSystemResource;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.util.FileUpload;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.ObjectToJson;
import com.xgs.model.TProduct;
import com.xgs.model.XArticle;
import com.xgs.model.XFruitMaster;
import com.xgs.model.XReleProducts;

public class MasterArticleManageController extends BaseController {

	protected final static Logger logger = Logger.getLogger(MasterArticleManageController.class);

	// 文章列表
	public void articleList() {
		render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/articleList.ftl");
	}

	/**
	 * ajax查询
	 */
	public void articleListAjax() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String articleName = "";// 文章名称
		if (StringUtil.isNotNull(getPara("articleName"))) {
			articleName = getPara("articleName");
		}
		String article_categroy = "";// 文章种类，不传默认所有
		if (StringUtil.isNotNull(getPara("article_categroy"))) {
			article_categroy = getPara("article_categroy");
		}
		int status = 3;// 文章状态 0审核中，1审核通过
		if (StringUtil.isNotNull(getPara("articleStatus"))) {
			status = getParaToInt("articleStatus");
		}
		Page<XArticle> xArticleList = XArticle.dao.findXArticleList(page, pageSize, article_categroy, status,
				articleName);
		setAttr("articleList", xArticleList.getList());

		JSONObject result = new JSONObject();
		result.put("total", xArticleList.getTotalPage());
		result.put("page", xArticleList.getPageNumber());
		result.put("records", xArticleList.getPageSize());

		JSONArray rows = new JSONArray();
		for (XArticle article : xArticleList.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", article.getInt("id"));
			row.add(article.getInt("id"));
			row.add(article.getStr("title"));
			row.add(article.getStr("category_name"));
			row.add(article.getStr("contribution_penson"));
			row.add(article.getInt("status"));
			row.add(article.getStr("url"));
			row.add(article.getStr("recommend_product_name"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}

	public void editArticle() {
		render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/editArticle.ftl");
	}

	public void initArticle() {
		String jsContent = "";
		String cssContent = "";
		int articleId = getParaToInt("article_id");
		Record article = Db.findFirst(
				"select a.*,ac.category_name from x_article a left join x_article_category ac on a.category_id = ac.id where a.id =?",
				articleId);
		String relCssFile = article.getStr("relation_cssfile");
		String relJsFile = article.getStr("relation_jsfile");
		if (StringUtil.isNotNull(relCssFile)) {
			XArticle cssArticle = XArticle.dao.findById(Integer.valueOf(relCssFile));
			cssContent = cssArticle.getStr("article_content");
		}

		if (StringUtil.isNotNull(relJsFile)) {
			XArticle jsArticle = XArticle.dao.findById(Integer.valueOf(relJsFile));
			jsContent = jsArticle.getStr("article_content");
		}

		article.set("css_content", cssContent);
		article.set("js_content", jsContent);
		setAttr("article", article);
		render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/editArticle.ftl");
	}

	/**
	 * 添加或者编辑文章（生成html并上传到文件服务器上，方案暂时未采用）
	 * 
	 * @throws IOException
	 */
	/*
	 * public void editArticleAjax() throws IOException { Map<String, Object>
	 * result = new HashMap<String, Object>(); XArticle xii =
	 * getModel(XArticle.class, "article"); String articleContent =
	 * xii.getStr("article_content");
	 * 
	 * String jsContent = getPara("js_content"); String cssContent =
	 * getPara("css_content"); String title = getPara("title"); String id =
	 * getPara("article_id"); String headImage = getPara("head_image");
	 * 
	 * Record record = Db .findFirst(
	 * "select * from x_article_category where category_name = '" +
	 * getPara("category_name") + "'");
	 * 
	 * // 参数里获取值并且构建增加和修改的record Record articleRecord = new Record();
	 * articleRecord.set("category_id", record.getInt("id"));
	 * articleRecord.set("title", title); articleRecord.set("edit_penson",
	 * getPara("edit_penson")); articleRecord.set("article_content",
	 * articleContent); articleRecord.set("master_id", getPara("master_id"));//
	 * 可有可无 articleRecord.set("contribution_penson",
	 * getPara("contribution_penson")); articleRecord.set("content_image",
	 * getPara("content_image")); articleRecord.set("article_intro",
	 * getPara("article_intro")); articleRecord.set("recommend_product_name",
	 * getPara("recommend_product_name")); articleRecord.set("status",
	 * getPara("status")); articleRecord.set("head_image", headImage);
	 * 
	 * if (StringUtil.isNull(id)) {// 没有id则是添加
	 * 
	 * Map<String, Object> parmaMap = new HashMap<>(); String cssUrl = "";
	 * String jsUrl = ""; long cssId = 0l; long jsId = 0l; if
	 * (StringUtil.isNotNull(cssContent)) { cssUrl =
	 * this.upload2Remote(cssContent, ".css"); Record cssRecord =
	 * this.construtRecord(cssContent, cssUrl, title, "1");
	 * XArticle.dao.addXArticle(cssRecord);
	 * 
	 * cssId = cssRecord.getLong("id"); String relCssUrl =
	 * this.findHtmlReUrl(cssUrl, "css"); parmaMap.put("CSS", relCssUrl); } if
	 * (StringUtil.isNotNull(jsContent)) { jsUrl = this.upload2Remote(jsContent,
	 * ".js"); Record jsRecord = this.construtRecord(jsContent, jsUrl, title,
	 * "2"); XArticle.dao.addXArticle(jsRecord);
	 * 
	 * jsId = jsRecord.getLong("id"); String relJsUrl =
	 * this.findHtmlReUrl(jsUrl, "js"); parmaMap.put("JS", relJsUrl); }
	 * parmaMap.put("HTML_TITLE", title); parmaMap.put("HTML_CONTENT",
	 * articleContent); String htmlContent = this.constructHtml(parmaMap);
	 * String htmlUrl = this.upload2Remote(htmlContent, ".html");
	 * 
	 * articleRecord.set("file_type", "0"); articleRecord.set("relation_jsfile",
	 * jsId); articleRecord.set("relation_cssfile", cssId);
	 * articleRecord.set("url", htmlUrl); articleRecord.set("create_time",
	 * DateFormatUtil.format2(new Date()));
	 * 
	 * boolean flag = XArticle.dao.addXArticle(articleRecord); if (flag) {
	 * render(AppConst.PATH_MANAGE_PC +
	 * "/masterSys/contentManage/articleList.ftl"); } } else { XArticle xArticle
	 * = XArticle.dao.findById(id);
	 * 
	 * String relCssId = xArticle.getStr("relation_cssfile"); String reljsId =
	 * xArticle.getStr("relation_jsfile"); String htmlContent =
	 * xArticle.getStr("article_content"); String jsContentDb = ""; String
	 * cssContentDb = ""; String newCssUrl = ""; String newJsUrl = ""; String
	 * newHtmlUrl = ""; String relCssUrl = ""; String reljsUrl = ""; boolean
	 * cssFlag = false; boolean jsFlag = false; boolean flag = false;
	 * 
	 * if (StringUtil.isNotNull(relCssId) && StringUtil.isNotNull(cssContent)) {
	 * XArticle cssArticle = XArticle.dao.findById(Integer.valueOf(relCssId));
	 * cssContentDb = cssArticle.getStr("article_content"); if
	 * (!cssContent.equals(cssContentDb)) { newCssUrl =
	 * this.upload2Remote(cssContent, ".css"); Record paramCss = new Record();
	 * paramCss.set("article_content", cssContent); paramCss.set("url",
	 * newCssUrl); paramCss.set("id", Integer.valueOf(relCssId));
	 * 
	 * Db.update("x_article", paramCss); } else { newCssUrl =
	 * cssArticle.getStr("url"); cssFlag = true; } } else if
	 * (StringUtil.isNull(relCssId) && StringUtil.isNotNull(cssContent)) {
	 * newCssUrl = this.upload2Remote(cssContent, ".css"); Record cssRecord =
	 * this.construtRecord(cssContent, newCssUrl, title, "1");
	 * XArticle.dao.addXArticle(cssRecord); relCssId = cssRecord.getLong("id") +
	 * ""; }
	 * 
	 * if (StringUtil.isNotNull(reljsId) && StringUtil.isNotNull(jsContent)) {
	 * XArticle jsArticle = XArticle.dao.findById(Integer.valueOf(reljsId));
	 * jsContentDb = jsArticle.getStr("article_content"); if
	 * (!jsContent.equals(jsContentDb)) { newJsUrl =
	 * this.upload2Remote(jsContent, ".js"); Record paramJs = new Record();
	 * paramJs.set("article_content", jsContent); paramJs.set("url", newJsUrl);
	 * paramJs.set("id", Integer.valueOf(reljsId));
	 * 
	 * Db.update("x_article", paramJs); } else { newJsUrl =
	 * jsArticle.getStr("url"); jsFlag = true; } } else if
	 * (StringUtil.isNull(reljsId) && StringUtil.isNotNull(jsContent)) {
	 * newJsUrl = this.upload2Remote(jsContent, ".js"); Record jsRecord =
	 * this.construtRecord(jsContent, newJsUrl, title, "2");
	 * XArticle.dao.addXArticle(jsRecord); relCssId = jsRecord.getLong("id") +
	 * ""; }
	 * 
	 * boolean htmlFlag = articleContent.equals(htmlContent); if (jsFlag &&
	 * cssFlag && htmlFlag) { flag = Db.update("x_article", articleRecord); }
	 * else { relCssUrl = this.findHtmlReUrl(newCssUrl, "css"); reljsUrl =
	 * this.findHtmlReUrl(newJsUrl, "js");
	 * 
	 * Map<String, Object> parmaMap = new HashMap<>(); parmaMap.put("CSS",
	 * relCssUrl); parmaMap.put("JS", reljsUrl); parmaMap.put("HTML_TITLE",
	 * title); parmaMap.put("HTML_CONTENT", articleContent);
	 * 
	 * String html = this.constructHtml(parmaMap); newHtmlUrl =
	 * this.upload2Remote(html, ".html"); } articleRecord.set("url",
	 * newHtmlUrl); articleRecord.set("id", id); flag = Db.update("x_article",
	 * articleRecord); if (flag) { render(AppConst.PATH_MANAGE_PC +
	 * "/masterSys/contentManage/articleList.ftl"); } } }
	 */

	public void editArticleAjax() {
		Map<String, Object> result = new HashMap<String, Object>();
		XArticle xii = getModel(XArticle.class, "article");
		String articleContent = xii.getStr("article_content");

		String title = getPara("title");
		String id = getPara("article_id");
		String headImage = getPara("head_image");
		Record record = Db
				.findFirst("select * from x_article_category where category_name = '" + getPara("category_name") + "'");
		// 参数里获取值并且构建增加和修改的record
		Record articleRecord = new Record();
		articleRecord.set("category_id", record.getInt("id"));
		articleRecord.set("title", title);
		articleRecord.set("edit_penson", getPara("edit_penson"));
		articleRecord.set("article_content", articleContent);
		articleRecord.set("master_id", getPara("master_id"));// 可有可无
		articleRecord.set("contribution_penson", getPara("contribution_penson"));
		articleRecord.set("content_image", getPara("content_image"));
		articleRecord.set("url", getPara("url"));
		articleRecord.set("article_intro", getPara("article_intro"));
		articleRecord.set("recommend_product_name", getPara("recommend_product_name"));
		articleRecord.set("status", getPara("status"));
		articleRecord.set("head_image", headImage);
		if (StringUtil.isNull(id)) {// 没有id则是添加
			articleRecord.set("file_type", "0");
			articleRecord.set("create_time", DateFormatUtil.format1(new Date()));
			boolean flag = XArticle.dao.addXArticle(articleRecord);
			if (flag) {
				render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/articleList.ftl");
			} else {
				renderNull();
			}
		} else {
			boolean flag = false;
			articleRecord.set("id",id);
			flag = Db.update("x_article", articleRecord);
			if (flag) {
				render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/articleList.ftl");
			} else {
				renderNull();
			}
		}
	}

	/**
	 * 文章删除
	 */
	public void deleteArticleAjax() {
		Map<String, Object> result = new HashMap<String, Object>();
		int id = getParaToInt("id");
		List<Record> list = Db.find("select * from x_rele_products where article_id=" + id);
		for (Record record : list) {
			Db.delete("x_rele_products", record);
		}

		boolean flag = Db.deleteById("x_article", id);
		if (flag) {
			result.put("msg", "删除成功");
			result.put("result", true);
		} else {
			result.put("msg", "删除失败，请重试");
			result.put("result", false);
		}
		renderJson(result);
	}

	// 根据id查看文章详情
	public void articleDetail() {
		int id = getParaToInt("id");
		XArticle article = XArticle.dao.findById(id);
		renderJson(ObjectToJson.modelConvert(article));
	}

	// 文章上下架
	public void switchStatus() {
		Map<String, Object> result = new HashMap<>();
		int articleId = getParaToInt("articleId");
		String status = getPara("status");

		String sql = "update x_article set status=" + status + " where id=" + articleId;
		int code = Db.update(sql);
		if (code > 0) {
			result.put("success", true);
			result.put("msg", "操作成功");
		} else {
			result.put("success", false);
			result.put("msg", "操作失败");
		}
		renderJson(result);
	}

	/**
	 * 未关联的商品列表查询
	 */
	public void UnReleProductList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");
		String sord = getPara("sord");
		String sql = "";
		if (StringUtil.isNotNull(getPara("article_id"))) {
			sql = "select product_id from x_rele_products where article_id=" + getPara("article_id");
		} else {
			sql = "select product_id from x_rele_products where article_id=-1";
		}
		List<XReleProducts> product_ids_list = XReleProducts.dao.find(sql);
		String product_ids = "";
		product_ids += "(";
		for (int i = 0; i < product_ids_list.size(); i++) {
			if (i == product_ids_list.size() - 1) {
				product_ids += product_ids_list.get(i).getInt("product_id");
			} else {
				product_ids += product_ids_list.get(i).getInt("product_id") + ",";
			}
		}
		product_ids += ")";
		if (product_ids.equals("()")) {
			product_ids = "";
		}

		String productName = "";
		if (StringUtil.isNotNull(getPara("productName"))) {
			productName = getPara("productName");
		}
		String productStatus = "01";
		if (StringUtil.isNotNull(getPara("productStatus"))) {
			productStatus = getPara("productStatus");
		}
		int categoryId = -1;
		if (StringUtil.isNotNull(getPara("categoryIdValue"))) {
			categoryId = getParaToInt("categoryIdValue");
		}
		TProduct product = new TProduct();
		Page<Record> pageInfo = product.findUnReleProductByArticleId(productName, productStatus, categoryId, pageSize,
				page, sidx, sord, product_ids);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record rc : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", rc.getInt("id"));
			row.add(rc.getInt("id"));
			row.add(rc.getStr("product_status"));
			row.add(rc.getStr("product_name"));
			row.add(rc.getStr("category_name"));
			row.add(rc.getStr("save_string"));
			row.add(rc.getStr("unit_name"));
			row.add(rc.getDouble("product_amount"));
			row.add(rc.getStr("product_unit"));
			row.add(rc.getStr("standard"));
			row.add(rc.getInt("price"));
			row.add(rc.getInt("special_price"));
			row.add(rc.getStr("is_vlid"));
			json.put("cell", row);
			rows.add(json);
		}

		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 已关联此篇文章的商品
	 */
	public void releProductList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");
		String sidx = getPara("sidx");
		String sord = getPara("sord");
		String sql = "";
		if (StringUtil.isNotNull(getPara("article_id"))) {
			sql = "select product_id from x_rele_products where article_id=" + getPara("article_id");
		} else {
			sql = "select product_id from x_rele_products where article_id=-1";
		}
		List<XReleProducts> product_ids_list = XReleProducts.dao.find(sql);
		String product_ids = "";
		product_ids += "(";
		for (int i = 0; i < product_ids_list.size(); i++) {
			if (i == product_ids_list.size() - 1) {
				product_ids += product_ids_list.get(i).getInt("product_id");
			} else {
				product_ids += product_ids_list.get(i).getInt("product_id") + ",";
			}
		}
		product_ids += ")";
		String productStatus = "01";
		if (StringUtil.isNotNull(getPara("productStatus"))) {
			productStatus = getPara("productStatus");
		}
		if (product_ids.equals("()")) {
			product_ids = "";
		}
		TProduct product = new TProduct();
		Page<Record> pageInfo = product.findReleProductByArticleId(productStatus, pageSize, page, sidx, sord,
				product_ids);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record rc : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", rc.getInt("id"));
			row.add(rc.getInt("id"));
			row.add(rc.getStr("product_status"));
			row.add(rc.getStr("product_name"));
			row.add(rc.getStr("category_name"));
			row.add(rc.getStr("save_string"));
			row.add(rc.getStr("unit_name"));
			row.add(rc.getDouble("product_amount"));
			row.add(rc.getStr("product_unit"));
			row.add(rc.getStr("standard"));
			row.add(rc.getInt("price"));
			row.add(rc.getInt("special_price"));
			row.add(rc.getStr("is_vlid"));
			json.put("cell", row);
			rows.add(json);
		}

		result.put("rows", rows);
		renderJson(result);
	}

	/**
	 * 关联商品
	 */
	public void relateProductAjax() {
		int article_id = getParaToInt("article_id");
		String product_ids = getPara("product_ids");
		String[] ids = product_ids.split(",");
		boolean flag = false;
		for (String product_id : ids) {
			flag = XReleProducts.dao.relateProduct(article_id, Integer.parseInt(product_id));
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (flag) {
			result.put("result", "success");
			result.put("msg", "关联成功");
		} else {
			result.put("result", "failure");
			result.put("msg", "关联失败，请重试");
		}
		renderJson(result);
	}

	/**
	 * 取消关联产品
	 */
	public void removeRelationAjax() {
		int article_id = getParaToInt("article_id");
		String product_ids = getPara("product_ids");
		String[] ids = product_ids.split(",");
		boolean flag = false;
		for (String product_id : ids) {
			flag = XReleProducts.dao.removeRelateProduct(article_id, Integer.parseInt(product_id));
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (flag) {
			result.put("result", "success");
			result.put("msg", "关联成功");
		} else {
			result.put("result", "failure");
			result.put("msg", "关联失败，请重试");
		}
		renderJson(result);
	}

	public void initSXZWArticle() {
		render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/sxzwList.ftl");
	}

	/**
	 * 未关联食鲜之味的文章列表
	 */
	public void unSXZWArticleListAjax() {
		int pageSize = getParaToInt("rows");
		int pageNumber = getParaToInt("page");

		// 未关联食鲜之味的文章
		String select = "select a.*,ac.category_name ";
		String sqlExceptSelect = "from x_article a left join x_article_category ac on a.category_id = ac.id where is_sxzw = 0 and file_type=0 ";

		String article_category = getPara("article_category");
		if (StringUtil.isNotNull(article_category)) {
			Record record = Db.findFirst("select * from x_article_category where category_name =?",
					getPara("article_category"));
			if (record != null) {
				sqlExceptSelect += (" and category_id =" + record.getInt("id"));
			}
		}
		String articleStatus = getPara("articleStatus");
		if (StringUtil.isNotNull(articleStatus) && getParaToInt("articleStatus") != 2) {
			sqlExceptSelect += (" and status = " + articleStatus);
		}
		String articleName = getPara("articleName");
		if (StringUtil.isNotNull(articleName)) {
			sqlExceptSelect += (" and title like '%" + articleName + "%' ");
		}
		Page<Record> articleList = Db.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		JSONObject result = new JSONObject();
		result.put("total", articleList.getTotalPage());
		result.put("page", articleList.getPageNumber());
		result.put("records", articleList.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record record : articleList.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", record.getInt("id"));
			row.add(record.getInt("id"));
			row.add(record.getStr("title"));
			row.add(record.getStr("category_name"));
			row.add(record.getStr("contribution_penson"));
			row.add(record.getInt("status"));
			row.add(record.getStr("url"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(rows);
	}

	/**
	 * 已经关联食鲜之味的文章列表
	 */
	public void sXZWArticleListAjax() {
		int pageSize = getParaToInt("rows");
		int pageNumber = getParaToInt("page");
		// 未关联食鲜之味的文章
		String select = "select a.*,ac.category_name ";
		String sqlExceptSelect = "from x_article a left join x_article_category ac on a.category_id = ac.id where is_sxzw = 1";
		Page<Record> articleList = Db.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		JSONObject result = new JSONObject();
		result.put("total", articleList.getTotalPage());
		result.put("page", articleList.getPageNumber());
		result.put("records", articleList.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record record : articleList.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", record.getInt("id"));
			row.add(record.getInt("id"));
			row.add(record.getStr("title"));
			row.add(record.getStr("category_name"));
			row.add(record.getStr("contribution_penson"));
			row.add(record.getInt("status"));
			row.add(record.getStr("url"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(rows);
	}

	/**
	 * 关联食鲜之味文章
	 */
	public void relateSXZWAjax() {
		int article_id = getParaToInt("article_id");
		Map<String, Object> result = new HashMap<String, Object>();
		int flag = Db.update("update x_article set is_sxzw = 1 where id =? ", article_id);
		if (flag > 0) {
			result.put("result", "success");
			result.put("msg", "关联成功");
		} else {
			result.put("result", "failure");
			result.put("msg", "关联失败");
		}
		renderJson(result);
	}

	/**
	 * 取消关联食鲜之味文章
	 */
	public void removeSXZWAjax() {
		int article_id = getParaToInt("article_id");
		Map<String, Object> result = new HashMap<String, Object>();
		int flag = Db.update("update x_article set is_sxzw = 0 where id =? ", article_id);
		if (flag > 0) {
			result.put("result", "success");
			result.put("msg", "取消关联成功");
		} else {
			result.put("result", "failure");
			result.put("msg", "取消关联失败");
		}
		renderJson(result);
	}

	/**
	 * 初始化FAQ界面
	 */
	public void initFAQ() {
		render(AppConst.PATH_MANAGE_PC + "/masterSys/contentManage/FAQList.ftl");
	}

	/**
	 * 鲜果师用户FAQ列表
	 */
	public void userFAQListAjax() {
		int pageSize = getParaToInt("rows");
		int pageNumber = getParaToInt("page");
		// 鲜果师商城用户FAQ
		String select = "select * ";
		String sqlExceptSelect = "from t_faq_detail where type = 5 ";
		if (StringUtil.isNotNull(getPara("faq_name"))) {
			sqlExceptSelect += " and faq_title like '%" + getPara("faq_name") + "%'";
		}
		sqlExceptSelect += " order by order_num";
		Page<Record> articleList = Db.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		JSONObject result = new JSONObject();
		result.put("total", articleList.getTotalPage());
		result.put("page", articleList.getPageNumber());
		result.put("records", articleList.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record record : articleList.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", record.getInt("id"));
			row.add(record.get("order_num"));
			row.add(record.getStr("faq_title"));
			row.add(record.getStr("faq_content"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(rows);
	}

	/**
	 * 鲜果师用户FAQ添加或者编辑
	 */
	public void editFAQ() {
		Record record = new Record();
		record.set("type", getPara("type"));
		record.set("faq_title", getPara("faq_title"));
		record.set("faq_content", getPara("faq_content"));
		record.set("order_num", getPara("order_num"));
		Map<String, Object> result = new HashMap<String, Object>();
		if (StringUtil.isNull(getPara("faq_id"))) {// 添加
			boolean flag = Db.save("t_faq_detail", record);
			if (flag) {
				result.put("result", "success");
				result.put("msg", "添加成功");
			} else {
				result.put("result", "failure");
				result.put("msg", "添加失败");
			}
		} else {
			record.set("id", getParaToInt("faq_id"));
			boolean flag = Db.update("t_faq_detail", record);
			if (flag) {
				result.put("result", "success");
				result.put("msg", "编辑成功");
			} else {
				result.put("result", "failure");
				result.put("msg", "编辑失败");
			}
		}
		renderJson(result);
	}

	/**
	 * 删除用户FAQ
	 */
	public void removeUserFAQ() {
		int faq_id = getParaToInt("faq_id");
		Map<String, Object> result = new HashMap<String, Object>();
		boolean flag = Db.deleteById("t_faq_detail", faq_id);
		if (flag) {
			result.put("result", "success");
			result.put("msg", "删除成功");
		} else {
			result.put("result", "failure");
			result.put("msg", "删除失败");
		}
		renderJson(result);
	}

	/**
	 * 鲜果师FAQ问题
	 */
	public void masterFAQListAjax() {
		int pageSize = getParaToInt("rows");
		int pageNumber = getParaToInt("page");
		// 鲜果师商城用户FAQ
		String select = "select * ";
		String sqlExceptSelect = "from t_faq_detail where type = 4";
		if (StringUtil.isNotNull(getPara("faq_name"))) {
			sqlExceptSelect += " and faq_title like '%" + getPara("faq_name") + "%'";
		}
		sqlExceptSelect += " order by order_num";

		Page<Record> articleList = Db.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		JSONObject result = new JSONObject();
		result.put("total", articleList.getTotalPage());
		result.put("page", articleList.getPageNumber());
		result.put("records", articleList.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record record : articleList.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", record.getInt("id"));
			row.add(record.get("order_num"));
			row.add(record.getStr("faq_title"));
			row.add(record.getStr("faq_content"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(rows);
	}

	/**
	 * 鲜果师用户FAQ添加或者编辑
	 */
	public void editMasterFAQ() {
		Record record = new Record();
		record.set("type", getPara("type"));
		record.set("faq_title", getPara("faq_title"));
		record.set("faq_detail", getPara("faq_detail"));
		record.set("order_num", getPara("order_num"));
		Map<String, Object> result = new HashMap<String, Object>();
		if (StringUtil.isNull(getPara("faq_id"))) {// 添加
			record.set("type", "4");
			boolean flag = Db.save("t_faq_detail", record);
			if (flag) {
				result.put("result", "success");
				result.put("msg", "添加成功");
			} else {
				result.put("result", "failure");
				result.put("msg", "添加失败");
			}
		} else {
			record.set("order_num", getParaToInt("faq_id"));
			boolean flag = Db.update("t_faq_detail", record);
			if (flag) {
				result.put("result", "success");
				result.put("msg", "添加成功");
			} else {
				result.put("result", "failure");
				result.put("msg", "添加失败");
			}
		}
	}

	/**
	 * 删除用户FAQ
	 */
	public void removeMasterFAQ() {
		int faq_id = getParaToInt("faq_id");
		Map<String, Object> result = new HashMap<String, Object>();
		boolean flag = Db.deleteById("t_faq_detail", faq_id);
		if (flag) {
			result.put("result", "success");
			result.put("msg", "删除成功");
		} else {
			result.put("result", "failure");
			result.put("msg", "删除失败");
		}
		renderJson(result);
	}

	// 上传css和js发送

	// 构建html文件
	public String constructHtml(Map<String, Object> htmlParam) {
		StringBuffer htmlContent = new StringBuffer();

		htmlContent.append("<!DOCTYPE html>");
		htmlContent.append("<html>");
		htmlContent.append("<head>");
		htmlContent.append("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />");
		htmlContent.append("<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />");
		htmlContent
				.append("<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0' />");
		htmlContent.append(htmlParam.get("CSS"));
		htmlContent.append(htmlParam.get("JS"));
		htmlContent.append("<title>");
		htmlContent.append(htmlParam.get("HTML_TITLE"));
		htmlContent.append("</title>");
		htmlContent.append("</head>");
		htmlContent.append("<body>");
		htmlContent.append(htmlParam.get("HTML_CONTENT"));
		htmlContent.append("</body>");
		htmlContent.append("</html>");

		return htmlContent.toString();
	}

	// 获取html所关联css和js对应的url
	public static String findHtmlReUrl(String url, String type) {
		String str = "";
		String preStr = null;
		String sufStr = null;
		if (StringUtil.isNull(url) || StringUtil.isNull(type)) {
			return str;
		}
		if ("css".equals(type)) {
			preStr = "<link rel='stylesheet' href=";
			sufStr = "type='text/css'/>";
		} else if ("js".equals(type)) {
			preStr = "<script language='javascript' type='text/javascript' src=";
			sufStr = "></script>";
		}

		str = preStr + "'" + url + "'" + sufStr;
		return str;
	}

	public static String upload2Remote(String content, String suffix) throws IOException {
		// String filePath = AppProps.get("filePath")+"/resource/file/";
		// String remotePath = AppProps.get("remotePath");
		String filePath = "D:/eclipseWorkspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/weixin/resource/file/";
		String remotePath = "http://resource.shuiguoshule.com.cn/v1/upload/product_image";

		File fileFolder = new File(filePath);
		if (!fileFolder.exists()) {
			fileFolder.mkdirs();
		}

		long currentMills = System.currentTimeMillis();
		String fileName = currentMills + suffix;
		File tempFile = new File(filePath + fileName);
		if (!tempFile.exists()) {
			tempFile.createNewFile();
		}

		FileOutputStream fos = new FileOutputStream(tempFile);
		fos.write(content.getBytes("UTF-8"));
		fos.close();

		FileUpload fup = new FileUpload();
		String result = fup.postFile(tempFile, remotePath);
		String fileUrl = "";

		// 截取返回的url
		if (StringUtil.isNotNull(result)) {
			int firstIndex = result.indexOf("\"fileUrl\"");
			int lastIndex = result.indexOf("\"code\"");
			fileUrl = result.substring(firstIndex + 11, lastIndex - 2);
		}
		return fileUrl;
	}

	// 构建css和js的Record
	public Record construtRecord(String content, String url, String title, String fileType) {
		Record record = new Record();
		record.set("article_content", content);
		record.set("url", url);
		record.set("title", title + System.currentTimeMillis());
		record.set("file_type", fileType);

		return record;
	}

	public static void main(String[] args) throws IOException {
		String content = "接dfaskfjdk;lasfkj;ldksa;lfkd;lsakf;ldksafl;dksal;fkd;lsa";
		upload2Remote(content, ".css");
	}

	/**
	 * 鲜果师列表
	 */
	public void masterList() {
		int pageSize = getParaToInt("rows");
		int page = getParaToInt("page");

		String masterName = getPara("masterName");

		Page<Record> pageInfo = null;
		if (StringUtil.isNotNull(masterName)) {
			pageInfo = Db.paginate(page, pageSize, "select * ",
					" from x_fruit_master where master_name like '%" + masterName + "%'");
		} else {
			pageInfo = Db.paginate(page, pageSize, "select * ", " from x_fruit_master");
		}

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		result.put("totalRow", pageInfo.getTotalRow());

		JSONArray rows = new JSONArray();
		for (Record rc : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", rc.getInt("id"));
			row.add(rc.getInt("id"));
			row.add(rc.get("master_name"));
			row.add(rc.get("head_image"));
			row.add(rc.get("master_status"));

			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
	}
}
