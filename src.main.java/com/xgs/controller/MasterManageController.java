package com.xgs.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.util.PushUtil;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.xgs.model.XFruitApply;
import com.xgs.model.XFruitMaster;
import com.xgs.model.XMasterUser;

public class MasterManageController extends BaseController{
	protected final static Logger logger = Logger.getLogger(MasterManageController.class);

	/**
	 * 初始化鲜果师审核页面
	 */
	public void initCherkMasterList(){
		render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/cherkMasterList.ftl");
	}
	
	public void cherkMasterList(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
		int master_status=-1;
		if(StringUtil.isNotNull(getPara("master_status"))){
			master_status=getParaToInt("master_status");
		}
		String createDateBegin=getPara("createDateBegin");
		String createDateEnd=getPara("createDateEnd");
		String masterName=getPara("maserName");
		
		XFruitMaster xFruitMaster = new XFruitMaster();
		Page<Record> pageInfo=xFruitMaster.findCherkList(pageSize, page, master_status,
				masterName, createDateBegin, createDateEnd);
		
		JSONObject result=new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		
		JSONArray rows=new JSONArray();
		for(Record rc:pageInfo.getList()){
			JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getStr("create_time"));
            row.add(rc.getStr("master_name"));
            row.add(rc.get("mobile"));
            row.add(rc.getStr("idcard"));
            
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
	}
	
	public void masterDetail(){
		int id = getParaToInt("id");
		List<Record> masterDetailList=XFruitMaster.dao.findmasterDetailById(id);
		Map<String, Object> masterDetail = new HashMap<String, Object>();
		for(Record rc:masterDetailList){
			masterDetail.put("id", rc.get("id"));
			masterDetail.put("master_name", rc.get("master_name"));
			masterDetail.put("mobile", rc.get("mobile"));
			masterDetail.put("idcard", rc.get("idcard"));
			masterDetail.put("idcard_face", rc.get("idcard_face"));
			masterDetail.put("idcard_opposite", rc.get("idcard_opposite"));
			masterDetail.put("qualification", rc.get("qualification"));
			Record record=Db.findFirst("select master_name as recommend_person from x_fruit_master where id="+rc.get("master_recommend")+" ");
			masterDetail.put("recommend_person", record);
		}
		setAttr("masterDetail", masterDetail);
		render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/cherkMaster.ftl");
	}
	
	public void cherkPass(){
		int id=getParaToInt("id");
		String mobileNum=getPara("mobileNum");
		Db.update("update x_fruit_master set master_status=1 where id=?", id);
		Map<String, Object> mes = new HashMap<String, Object>();
		mes.put("status", "success");
		Map<String, String> map = PushUtil.sendMsgToMaster(mobileNum, "通过");
		mes.put("mobileInfo", map.get("status"));
		renderJson(mes);
	}
	
	public void cherkNotPass(){
		int id=getParaToInt("masterId");
		String reason=getPara("reason");
		String mobileNum=getPara("mobileNum");
		XFruitApply xFruitApply = XFruitApply.dao.findFirst("select *from x_fruit_apply where master_id=?", id);
		if(xFruitApply!=null){
			int result = Db.update("update x_fruit_master set master_status=2 where id=? ", id);
			if(result>0){
				Db.update("update x_fruit_apply set cause='"+reason+"' where master_id=?", id);
			}
		}
		Map<String, Object> mes = new HashMap<String, Object>();
		Map<String, String> map = PushUtil.sendMsgToMaster(mobileNum, "不通过");
		mes.put("mobileInfo", map.get("status"));
		mes.put("status", "success");
		renderJson(mes);
	}
	
	public void trainIsPass(){	
		int id=getParaToInt("id");
		int master_status=getParaToInt("master_status");
		String master_nc=getPara("master_nc");
		Map<String, Object> mes = new HashMap<String, Object>();
		//申请成功让自己成为自己的客户
		if(master_status==3){//不是别人的客户，直接申请的，成功后把自己添加为自己的客户
			Db.update("update x_fruit_master set master_status="+master_status+""
					+ ",master_nc='"+master_nc+"' where id=?", id);
			XFruitMaster xFruitMaster = XFruitMaster.dao.findById(id);
			int user_id = xFruitMaster.getInt("user_id");
			XMasterUser xMasterUser = XMasterUser.dao.findFirst("select * from x_master_user where user_id = ?",user_id);
			if(xMasterUser==null){
				Record record = new Record();
				record.set("master_id", id);
				record.set("master_desc", xFruitMaster.get("master_name"));
				record.set("user_id", user_id);
				Db.save("x_master_user", record);
				record.clear();
				System.out.println("======添加");
			}else{//以前是别人的客户，更改记录，成为自己的客户
				xMasterUser.set("master_id", id);
				xMasterUser.update();
			}
			mes.put("status", "操作成功！");
		}else if(master_status==-1){
			XFruitApply xFruitApply = XFruitApply.dao.findFirst("select *from x_fruit_apply where master_id=?", id);
			Db.deleteById("x_fruit_master", id);
			xFruitApply.delete();
			mes.put("status", "移除成功！");
		}else{
			mes.put("status", "操作失败！");
		}
		
		renderJson(mes);
	}
	
	public void initMasterList(){
		render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/masterList.ftl");
	}
	/**
	 * 鲜果师列表
	 */
	public void masterList(){
		int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
		int master_status=-1;
		if(StringUtil.isNotNull(getPara("master_status"))){
			master_status=getParaToInt("master_status");
		}
		String createDateBegin=getPara("createDateBegin");
		String createDateEnd=getPara("createDateEnd");
		String masterName=getPara("masterName");
		String master_id=getPara("id");
		String is_fresh_star=getPara("is_fresh_star");
		
		XFruitMaster xFruitMaster = new XFruitMaster();
		Page<Record> pageInfo;
		if(master_id!=null){
			pageInfo=xFruitMaster.findMasterDown(pageSize, page, createDateBegin, createDateEnd,
					master_status, masterName, getParaToInt("id"));
		}else{
			pageInfo=xFruitMaster.findMasterAndUpMaster(pageSize, page, createDateBegin, 
					createDateEnd, master_status, masterName,is_fresh_star);
		}
		
		JSONObject result=new JSONObject();
		result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		result.put("totalRow", pageInfo.getTotalRow());
		
		JSONArray rows=new JSONArray();
		for(Record rc:pageInfo.getList()){
			JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rc.getInt("id"));
            row.add(rc.getInt("id"));
            row.add(rc.getStr("mobile"));
            row.add(rc.get("master_name"));
            row.add(rc.getStr("create_time"));
            row.add(rc.get("head_image"));
            row.add(rc.get("上级鲜果师"));
            row.add(rc.get("master_status"));
            
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
	}
	
	public void initMasterDetail(){
		int id = getParaToInt("id");
		List<Record> detail= XFruitMaster.dao.findmasterDetailById(id);
		setAttr("detail", detail.get(0));
		render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/masterDetail.ftl");
	}
	
	
	public void eidtMasterInfo(){
		int id = getParaToInt("detail.id");
		String mobile=getPara("detail.mobile");
		String master_name=getPara("detail.master_name");
		String master_image=getPara("detail.master_image");
		String head_image=getPara("detail.head_image");
		String description=getPara("detail.description");
		String master_nc=getPara("detail.master_nc");
		int master_status=getParaToInt("detail.master_status");
		XFruitMaster xFruitMaster = new XFruitMaster();
		xFruitMaster.set("master_name", master_name);
		xFruitMaster.set("master_image", master_image);
		xFruitMaster.set("head_image", head_image);
		xFruitMaster.set("description", description);
		xFruitMaster.set("master_status", master_status);
		xFruitMaster.set("master_nc", master_nc);
		xFruitMaster.dao.updateMaster(model2map(xFruitMaster), id, "x_fruit_master");
		Db.update("update x_fruit_apply set mobile='"+mobile+"' where master_id=? ", id);
		redirect("/masterManage/initMasterList");
	}
	
	
	  public void masterUserList() {
	        int pageSize=getParaToInt("rows");
	        int page=getParaToInt("page");
	        String phoneNum=getPara("phoneNum");
	        String registTimeBegin=getPara("registTimeBegin");
	        String registTimeEnd=getPara("registTimeEnd");
	        int master_id=getParaToInt("id");
	        
	        Page<Record> pageInfo = XFruitMaster.dao.findMasterUser(pageSize, page, registTimeBegin, registTimeEnd,
	        		phoneNum, master_id);

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
	            row.add(rc.getStr("open_id"));
	            row.add(rc.getStr("sexDisplay"));
	            row.add(rc.getStr("phone_num"));
	            row.add(rc.getStr("nickname"));
	            row.add(rc.getStr("birthday"));
	            row.add(rc.getStr("realname"));
	            row.add(rc.getStr("user_address"));
	            row.add(rc.getStr("regist_time"));
	            row.add(rc.getStr("user_img_id"));
	            row.add(rc.getInt("balance"));
	            row.add(rc.getInt("member_points"));
	            row.add(rc.getStr("statusDisplay"));
	            row.add(rc.getStr("store_name"));
	            json.put("cell",row);
	            rows.add(json);
	        }
	        result.put("rows", rows);
	        renderJson(result);
	    }
	  
	  public void masterCanselDownRelevance(){
		  Map<String, Object> mes =new HashMap<String, Object>();
		  String ids = getPara("ids");
			for (String item : ids.split(",")) {
				//Record record = Db.findFirst("select *from m_activity_product where product_id=?", item);
				Db.update("update x_fruit_master set master_recommend = null where id=? ", item);
			}
			mes.put("success", "下级鲜果师取消关联成功！");
			renderJson(mes);
	  }
	  
	  public void masterCanselUserRelevance(){
		  Map<String, Object> mes =new HashMap<String, Object>();
		  String ids = getPara("ids");
			for (String item : ids.split(",")) {
				Record record=Db.findFirst("select * from x_master_user where user_id=?", item);
				if(record!=null){
					Db.delete("x_master_user", record);
					mes.put("status", "success");
				}else{
					mes.put("status", "fail");
				}
			}
			renderJson(mes);
	  }
	  
	  public void initDivideSetList(){
			render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/divideSetList.ftl");
		}
	  
	  /**
	   * 权益设置
	   */
	  public void divideSetList(){
		  int pageSize=getParaToInt("rows");
	      int page=getParaToInt("page");
	      Page<Record> pageInfo=Db.paginate(page, pageSize, "select * ", "from x_bonus_percentage");
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
	            row.add(rc.getInt("sale_percentage"));
	            row.add(rc.getInt("bonus_percentage"));
	            json.put("cell",row);
	            rows.add(json);
	        }
	        result.put("rows", rows);
	        renderJson(result);
	  }
	  
	  public void eidtDivideSet(){
		  Map<String,Object> mes = new HashMap<String,Object>();
		  Record record = Db.findById("x_bonus_percentage", getParaToInt("id"));
		  mes.put("bonusPercentage", record);
		  renderJson(mes);
	  }
	  
	  public void eidtDivide(){
		  Map<String,Object> mes = new HashMap<String,Object>();
		  int id = getParaToInt("saleId");
		  int sale_percentage = getParaToInt("sale_percentage");
		  int bonus_percentage = getParaToInt("bonus_percentage");
		  int result = Db.update("update x_bonus_percentage set sale_percentage="+sale_percentage+""
		  		+ ",bonus_percentage="+bonus_percentage+" where id=?", id);
		  if(result>0){
			  mes.put("status", "修改成功！");
		  }else{
			  mes.put("status", "修改失败！");
		  }
		  renderJson(mes);
	  }
	  
	  
	  public void initMasterStarList(){
		  render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/masterStarList.ftl");
	  }
	  
	  public void masterStarSet(){
		  Map<String,Object> mes = new HashMap<String,Object>();
		  int is_fresh_star = getParaToInt("is_fresh_star");
		  String star_head_image = getPara("star_head_image");
		  String ids = getPara("ids");
		  if(StringUtil.isNotNull(ids)){
			  for (String item : ids.split(",")) {
				  if(is_fresh_star==0){
					  Db.update("update x_fruit_master set is_fresh_star="+is_fresh_star+", "
								+ "star_head_image=null where id=? ", item);
				  }else{
					  Db.update("update x_fruit_master set is_fresh_star="+is_fresh_star+", "
							  + "star_head_image='"+star_head_image+"' where id=? ", item);
				  }
			}
			  if(is_fresh_star==1){
				  mes.put("message", "设置成功！");
			  }else if(is_fresh_star==0){
				  mes.put("message", "取消设置成功！");
			  }
		  }else{
			  mes.put("message", "操作失败！");
		  }
		  renderJson(mes);
	  }
	
	public void initUserList(){
		Date date=new Date(); 
    	setAttr("registTimeBegin","2010-01-01 00:00:00");
        setAttr("registTimeEnd",DateFormatUtil.format1(date));
		render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/userList.ftl");
	}
	
	 /**
     * ajax查询
     */
    public void userList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        String phoneNum=getPara("phoneNum");
        String registTimeBegin=getPara("registTimeBegin");
        String registTimeEnd=getPara("registTimeEnd");
        StringBuffer execSql=new StringBuffer("from t_user u left join x_master_user mu on u.id=mu.user_id left join x_fruit_master fm on mu.master_id=fm.id ");
        Date date=new Date(); 
        if(StringUtil.isNull(registTimeBegin)){
        	registTimeBegin=DateFormatUtil.format5(date)+" 00:00:00";
        }
        if(StringUtil.isNull(registTimeEnd)){
        	registTimeEnd=DateFormatUtil.format1(date);
        }
        execSql.append(" where regist_time between ");
        execSql.append("'");
        execSql.append(registTimeBegin);
        execSql.append("'");
        execSql.append(" and ");
        execSql.append("'");
        execSql.append(registTimeEnd);
        execSql.append("' ");
        if(StringUtil.isNotNull(phoneNum)){
        	boolean flag=false;
        	StringBuffer phoneNums=new StringBuffer();
        	 for (String p : phoneNum.split(",")) {
        		 if(StringUtil.isNull(p))
        			 continue;
        	       if (flag){  
        	    	   phoneNums.append(", ");  
        	       }
        	       phoneNums.append("'");
        	       phoneNums.append(p); 
        	       phoneNums.append("'");
        	       flag=true;
        	   }  
        	execSql.append(" and phone_num in("+phoneNums.toString()+") ");
        }
        
        if(StringUtil.isNotNull(sidx)){
        	execSql.append(" order by "+sidx+" "+sord);
        }
        Page<Record> pageInfo=Db.paginate(page, pageSize, "select u.*,if(u.sex='1','男','女') as sexDisplay,if(u.status='0','不可用','正常') as statusDisplay,fm.master_name ", execSql.toString());


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
            row.add(rc.getStr("open_id"));
            row.add(rc.getStr("sexDisplay"));
            row.add(rc.getStr("phone_num"));
            row.add(rc.getStr("nickname"));
            row.add(rc.getStr("birthday"));
            row.add(rc.getStr("realname"));
            row.add(rc.getStr("user_address"));
            row.add(rc.getStr("regist_time"));
            row.add(rc.getStr("user_img_id"));
            row.add(rc.getInt("balance"));
            row.add(rc.getInt("member_points"));
            row.add(rc.getStr("statusDisplay"));
            row.add(rc.getStr("master_name"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    /**
     * 初始化反馈界面
     */
    public void initFeedbackList(){
    	Date date=new Date(); 
    	setAttr("feedbackTimeBegin","2017-01-01 00:00:00");
        setAttr("feedbackTimeEnd",DateFormatUtil.format1(date));
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/masterManage/feedbackList.ftl");
    }
    
    /**
     * ajax查询
     */
    public void feedbackList() {
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        
        StringBuffer sql=new StringBuffer("from t_feedback f left join t_user u on f.fb_user=u.id where 1=1 ");
    	String phoneNum = getPara("phoneNum");
    	if(StringUtil.isNotNull(phoneNum)){
    		sql.append(" and u.phone_num = '"+ phoneNum +"' ");
    	}
    	String feedbackTimeBegin = getPara("feedbackTimeBegin");
    	if(StringUtil.isNotNull(feedbackTimeBegin)){
    		sql.append(" and f.fb_time >= "+ feedbackTimeBegin);
    	}
    	String feedbackTimeEnd = getPara("feedbackTimeEnd");
    	if(StringUtil.isNotNull(feedbackTimeEnd)){
    		sql.append(" and f.fb_time <= "+ feedbackTimeEnd);
    	}
    	
    	int feedbackType = 0;
    	if(StringUtil.isNotNull(getPara("feedbackType"))){
    		feedbackType = getParaToInt("feedbackType");
    	}
    	switch (feedbackType) {
		case 0:
			sql.append(" and (f.fb_type =1 or f.fb_type =2) ");
			break;
		case 1:
			sql.append(" and f.fb_type =1 ");
			break;	
		case 2:
			sql.append(" and f.fb_type =2 ");
			break;
		default:
			sql.append(" and (f.fb_type =1 or f.fb_type =2) ");
			break;
		}
        if(StringUtil.isNotNull(sidx)){
        	sql.append(" order by ");
        	sql.append(sidx);
        	sql.append(" ");
        	sql.append(sord);
        }
        Page<Record> feedbacks= Db.paginate(page, pageSize, "select f.*,u.user_img_id,u.nickname,u.phone_num", sql.toString());


        JSONObject result=new JSONObject();
        result.put("total",feedbacks.getTotalPage());
        result.put("page",feedbacks.getPageNumber());
        result.put("records",feedbacks.getPageSize());

        JSONArray rows=new JSONArray();
        for (Record fb:feedbacks.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",fb.getInt("id"));
            row.add("");
            row.add(fb.getInt("id"));
            row.add(fb.getStr("fb_title"));
            row.add(fb.getStr("fb_content"));
            row.add(fb.getStr("fb_time"));
            row.add(fb.getStr("nickname"));
            row.add(fb.getStr("user_img_id"));
            row.add(fb.getStr("phone_num"));
            row.add(fb.getInt("fb_type"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    /**
     * 增删改
     */
    public void feedbackSave(){
    	if("edit".equals(getPara("oper"))){
    		Db.update("update t_feedback set is_deal=? where id=?",getPara("is_deal"),getPara("id"));
    	}
    	redirect("/masterManage/initFeedbackList");
    }
    
    /**
     * 搜索
     */

    
}
