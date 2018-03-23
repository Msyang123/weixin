package com.sgsl.controller;

import java.util.List;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.MShare;
import com.sgsl.model.TCouponScale;
import com.sgsl.util.StringUtil;

/**
 * Created by hufan 分享管理 2017/10/18
 * 初始化分享编辑
 */
public class ShareManageController extends BaseController {
	protected final static Logger logger = Logger.getLogger(ShareManageController.class);
	/**
	 * 分享管理
	 */
	public void initShareList() {
			render(AppConst.PATH_MANAGE_PC + "/share/shareList.ftl");
	}
	
	
	/**
	 * 异步加载分享列表
	 */
	public void getSharesJson() {
		// 再传一个id
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String template=getPara("template");
		String from ="from m_share ";
		if(StringUtil.isNotNull(template)){
			from+="where template like '%"+template+"%' ";
		}
		Page<Record> pageInfo = Db.paginate(page, pageSize, "select *", from);

		JSONObject result = new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("MShares", pageInfo.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record pa : pageInfo.getList()) {
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", pa.get("id"));
			// 操作列，需要第一列填充空数据	
			row.add(pa.getInt("id"));
			row.add(pa.get("template"));
			row.add(pa.get("pages"));
			row.add(pa.get("title"));
			row.add(pa.get("content"));
			row.add(pa.get("status"));
			row.add("");
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		System.out.println(result.toJSONString());
		renderJson(result);
	}
	
	
	
	/**
	 * 初始分享编辑
	 */
	public void initSave() {
		JSONObject mes =new JSONObject();
		MShare mShare = MShare.dao.findById(getPara("id"));
		if (mShare == null) {
			mShare = new MShare();
		}else{
			Record image=Db.findFirst("select * from t_image where id=? ",mShare.getInt("img_id"));
			if(image!=null){
				mes.put("image_src", image.get("save_string"));
			}
		}
		mes.put("mShare", mShare);
		renderJson(mes);
		//setAttr("mShare", mShare);
		//render(AppConst.PATH_MANAGE_PC + "/share/share.ftl");
	}	
	
	/**
	 * 添加修改分享模板
	 */
	public void saveShare() {
		MShare share =getModel(MShare.class,"share");
		String page_type = getPara("share.pages");
		String id=getPara("share_id");
		//String image_src=getPara("image_src");
		
		//TODO 保存不同的url
		if(page_type.equals("0")){
			share.set("url", "");
		}else if(page_type.equals("1")){
			share.set("url", "/weixin/fruitDetial");
		}else if(page_type.equals("2")){
			share.set("url", "/weixin/activity/groupGoodsInfo");
		}else if(page_type.equals("3")){
			share.set("url", "/weixin/fruitKind,/weixin/search");
		}else if(page_type.equals("4")){
			share.set("url", "/weixin/activity/groupBuys");
		}else if(page_type.equals("5")){
			share.set("url", "/weixin/activity/groupBuyInfo");
		}
		if(StringUtil.isNull(id)){
			share.set("status", 1);
			share.save();
		}else{
			TCouponScale.dao.updateInfo(model2map(share), getParaToInt("share_id"), "m_share");
		}
		redirect("/shareManage/initShareList",true);
	}

	/**
	 * 删除分享模板
	 */
	public void shareDelete() {
		String ids = getPara("ids");
		if(StringUtil.isNotNull(ids)){
			for(String id:ids.split(",")){
				MShare share = MShare.dao.findById(id);
				if (share != null) {
					share.delete();
				}
			}
		}
		redirect("/shareManage/initShareList");
	}
	
	/**
	 * 分享模板开启/关闭
	 */
	public void templateOpenOrClose(){
		String id = getPara("id");
		String status=getPara("status");
		String pageType=getPara("pageType");
		JSONObject mes = new JSONObject();
		if(StringUtil.isNotNull(id)&&StringUtil.isNotNull(status)){
			int sta=getParaToInt("status");
			if(getParaToInt("status")==0){
				sta=1;
				mes.put("mes", "已关闭！");
			}else if(getParaToInt("status")==1){
				if(!pageType.equals("6")){//
					//查找该页面类型是否有开启的模板
					List<Record> shareList = Db.find("select *from m_share where pages=?", pageType);
					for(Record share:shareList){
						if(share.getInt("status")==0){
							mes.put("mes", "已有该类型开启的模板，如进行下面操作，请先关闭该类型的其它模板！");
							renderJson(mes);
							return;
						}
					}
				}
				sta=0;
				mes.put("mes", "已开启！");
			}
			int flag = Db.update("update m_share set status=? where id=? ", sta,getParaToInt("id"));
			if(flag>0){
				renderJson(mes);
			}
		}
	}

}
