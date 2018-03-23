package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.core.JFinal;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.revocn.mapping.RoleMapping;
import com.revocn.model.SysRole;
import com.revocn.model.SysRoleMenu;
import com.revocn.model.SysUserRole;
import com.sgsl.config.AppConst;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.SysMenu;
import com.sgsl.model.SysUser;
import com.sgsl.model.TOrder;
import com.sgsl.util.BlankUtil;
import com.sgsl.util.MD5Util;
import com.sgsl.util.StringUtil;
import com.xgs.model.XFruitMaster;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Tao on 2014-07-17.
 */
public class AdminController extends BaseController {
    protected final static Logger logger = Logger.getLogger(AdminController.class);
    
    public void index() {
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        if(BlankUtil.isBlankModel(user)){
            if(JFinal.me().getConstants().getDevMode()){//开发模式，默认登录用户名
                setAttr("uuu","admin");
            }
            render(AppConst.PATH_MANAGE_PC + "/login.ftl");
        }else{
        	
            
            //查询海鼎发送失败的订单
            TOrder failOrder=new TOrder();
            setAttr("orderFailCount", failOrder.findFailOrder().getLong("orderFailCount"));
            render(AppConst.PATH_MANAGE_PC + "/index.ftl");
        }
    }
    
    /**
     * 登录
     */
    public void login() {
        if (StringUtil.isNull(getPara("user_name"))) {
            redirect("/m/index");
            return;
        }
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        if (user != null) {
            redirect("/m/index");
            return;
        }

        String username = getPara("user_name");
        String pwd = MD5Util.md5(getPara("pwd"));
        String rememberme = getPara("rememberme");
        String errormsg = "";

        user = SysUser.dao.findUserByLoginName(username);

        if (user == null) {
            errormsg = "用户名或密码错误";
        } else {
            PublicAccount pa=PublicAccount.dao.findUserByLoginName(username);
            if (!pa.getStr("valid_flag").equals("1")) {
                errormsg = "账户状态异常，可能已被锁定，或者未审核";
                render(AppConst.PATH_ERROR+"/noPermission.html");
                return;
            }
            if (user.getStr("pwd").equals(pwd)
                    && user.getStr("user_name").equals(username)) {
                // 通过
                setSessionAttr(AppConst.KEY_SESSION_USER, user);
                StringBuffer menu=new StringBuffer();
                new SysMenu().sortMenu(true,user,null,menu);
                setSessionAttr("sessionMenu", menu.toString());// 菜单
                setSessionAttr("sessionRight", RoleMapping.getRightMap());
                redirect("/m/index");
                return ;
            } else {
                errormsg = "用户名或密码错误";
            }
        }
        setAttr("errormsg", errormsg);
        render(AppConst.PATH_MANAGE_PC + "/login.ftl");
    }

    public void logout() {
        removeSessionAttr(AppConst.KEY_SESSION_USER);
//        setAttr("errormsg", "您已成功登出系统");
        alertMsg("您已成功登出系统");
        removeSessionAttr(AppConst.KEY_SESSION_MENU);
        removeSessionAttr(AppConst.KEY_SESSION_RIGHT);
        render(AppConst.PATH_MANAGE_PC + "/login.ftl");
    }
    
    //初始化角色列表
    public void initRoleList(){
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/adminManage/roleList.ftl");
    }
    
    /**
     * 角色列表
     */
    public void roleList(){
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        
        Page<Record> pageInfo = Db.paginate(page, pageSize, "select * ", "from sys_role");
        
        JSONObject result=new JSONObject();
        result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		
		JSONArray rows = new JSONArray();
		for (Record rc : pageInfo.getList()) {
			JSONObject json=new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", rc.getInt("id"));
			row.add(rc.getInt("id"));
			row.add(rc.get("role_name"));
			row.add(rc.get("role_desc"));
			json.put("cell", row);
			 rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    //初始化角色添加页面
    public void initSave(){
    	String role_id=getPara("id");
    	Record sysRole=new Record();
    	if(StringUtil.isNotNull(role_id)){
    		sysRole = Db.findById("sys_role", role_id);
    	}
    	setAttr("sysRole", sysRole);
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/adminManage/addRole.ftl");
    }
    
    //功能树
    public void initTree(){
    	String id=getPara("id");
    	String role_id=getPara("role_id");
    	JSONArray result=new JSONArray();
    	
    	SysMenu sysMenu = new SysMenu();
    	List<SysMenu> info = sysMenu.find("select *from sys_menu  ");
    	//存储用户选中的菜单项
    	List<Record> list=new ArrayList<Record>();
    	if(StringUtil.isNotNull(role_id)){
    		list = Db.find("select * from sys_role_menu where role_id=? ", role_id);
    	}
    	boolean checkedFlag=false;
    	for (SysMenu sm : info) {
			JSONObject jsobj =  new JSONObject();
			jsobj.put("id", sm.getInt("id"));
			jsobj.put("pId", sm.getInt("pid"));
			jsobj.put("name", sm.get("menu_name"));
			jsobj.put("isParent", true);
			jsobj.put("checked", false);
			
			for(Record item:list){
				if(item.getInt("menu_id")==sm.getInt("id")){
					jsobj.put("checked", true);
					checkedFlag=true;
					break;
				}
			}
			result.add(jsobj);
		}
    	//添加根节点
    	if(StringUtil.isNull(id)){
    		id="-1";
    		//添加一个全部节点
        	JSONObject root=new JSONObject();
        	root.put("id", 0);
        	root.put("pId", -1);
        	root.put("name", "全部");
        	root.put("isParent", true);
        	root.put("checked", checkedFlag);
    		result.add(root);
    	}
    	
    	renderJson(result);
    }
    
    /**
     * 角色权限设置
     */
    public void addRole(){
    	String role_name=getPara("sysRole.role_name");
    	String role_desc=getPara("role_desc");
    	String mid=getPara("mid");
    	String roleId=getPara("sysRole.id");
    	System.out.println(mid);
    	//Map<String,Object> mes = new HashMap<>();
    	SysRole sysRole = new SysRole();
    	SysRoleMenu sysRoleMenu = new SysRoleMenu();
    	if(StringUtil.isNotNull(role_name)){
	    	if(StringUtil.isNull(roleId)){
	    			sysRole.set("role_name", role_name);
	    			sysRole.set("role_desc", role_desc);
	    			sysRole.save();
	    	}else{
	    		Record sr = Db.findFirst("select *from sys_role where id=?", roleId);
	    		Db.update("update sys_role set role_name='"+role_name+"' "
	    				+ ",role_desc='"+role_desc+"' where id=? ", sr.getInt("id"));
	    		
	    		List<Record> list = Db.find("select *from sys_role_menu where role_id=?", roleId);
	    		
	    		if(list!=null){
	    			for(Record item:list){
	    				Db.deleteById("sys_role_menu", item.getInt("id"));
	    			}
	    		}
	    		
	    	}
	    	
	    	Record record = Db.findFirst("select *from sys_role where role_name=? ", role_name);
			if(StringUtil.isNotNull(mid)){
				for(String id:mid.split(",")){
					System.out.println(Integer.parseInt(id));
					sysRoleMenu.set("menu_id", id);
					sysRoleMenu.set("role_id", record.getInt("id"));
					sysRoleMenu.save();
					sysRoleMenu.clear();
				}
			}
			
    	}
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/adminManage/roleList.ftl");
    }
    
    /**
     * 删除角色权限
     */
    public void deleteRole(){
    	String role_id=getPara("id");
    	Map<String, Object> mes = new HashMap<String,Object>();
    	if(StringUtil.isNotNull(role_id)){
    		boolean falg = Db.deleteById("sys_role", getParaToInt("id"));
    		if(falg==true){
    			List<Record> list = Db.find("select *from sys_role_menu where role_id=? ", 
    					getParaToInt("id"));
    			if(list!=null){
    				for(Record item:list){
    					Db.delete("sys_role_menu", item);
    				}
    				mes.put("message", "操作成功！");
    			}
    		}
    	}else{
    		mes.put("message", "操作失败！");
    	}
    	renderJson(mes);
    }
    
    //初始化用户角色关联列表
    public void initUserRoleList(){
    	render(AppConst.PATH_MANAGE_PC + "/masterSys/adminManage/userRoleList.ftl");
    }

    /**
     * 菜单list
     */
    public void menuList(){
    	render(AppConst.PATH_MANAGE_PC + "/sys/menuList.ftl");
    }
    
    public void menuListAjax(){
    	int pageSize = getParaToInt("rows");
		int pageNumber = getParaToInt("page");
		// 管理系统菜单
		String select = "select * ";
		String sqlExceptSelect = "from sys_menu ";
		Page<Record> articleList = Db.paginate(pageNumber, pageSize, select, sqlExceptSelect);

		JSONObject result = new JSONObject();
		result.put("total", articleList.getTotalPage());
		result.put("page", articleList.getPageNumber());
		result.put("records", articleList.getPageSize());

		JSONArray rows = new JSONArray();
		for (Record record : articleList.getList()) {
			Record parentRecord = Db.findFirst("select * from sys_menu where id=?",record.getInt("pid"));
			if(parentRecord==null){
				record.set("parent_name", "无上级菜单");
			}else{
				record.set("parent_name", parentRecord.get("menu_name"));
			}
			JSONObject json = new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", record.getInt("id"));
			row.add("");
			row.add(record.getInt("id"));
			row.add(record.getStr("menu_name"));
			row.add(record.get("pid"));
			row.add(record.getStr("parent_name"));
			row.add(record.getStr("href"));
			row.add(record.getStr("valid_flag"));
			row.add(record.getStr("ico_path"));
			row.add(record.getInt("dis_order"));
			row.add(record.get("menu_type"));
			json.put("cell", row);
			rows.add(json);
		}
		result.put("rows", rows);
		renderJson(result);
    }
    /**
     * 初始化
     */
    public void initMenu(){
    	List<SysMenu> menuList = SysMenu.dao.find("select * from sys_menu where pid=0");
    	SysMenu parent_menu=new SysMenu();
    	parent_menu.set("id", 0);
    	parent_menu.set("menu_name", "新建一级菜单（无上级菜单）");
    	parent_menu.set("href", "#");
    	menuList.add(parent_menu);
    	setAttr("menus",menuList);
    	if(StringUtil.isNotNull(getPara("id"))){
    		SysMenu menu = SysMenu.dao.findById(getParaToInt("id"));
    		setAttr("menu",menu);
    	}
    	render(AppConst.PATH_MANAGE_PC + "/sys/addMenu.ftl");
    }
    
    public void editMenu(){
    	SysMenu parent_menu=getModel(SysMenu.class,"menu");
    	Record record = new Record();
    	record.setColumns(model2map(parent_menu));
    	System.out.println(parent_menu);
    	if(StringUtil.isNull(getPara("menu.id"))){//新增
    		Db.save("sys_menu",record);
    	}else{
    		Db.update("sys_menu",record);
    	}
    	redirect("/m/menuList");
    }
    
    /**
     * 删除菜单
     */
    public void deleteMenu(){
    	boolean flag = Db.deleteById("sys_menu", getParaToInt("id"));
    	Map<String,String> result = new HashMap<String,String>();
    	if(flag){
    		result.put("success", "删除成功");
    	}else{
    		result.put("failure", "删除失败");
    	}
    	renderJson(result);
    }

    public void userRoleList(){
    	int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        
        Page<Record> pageInfo = SysUser.dao.findSysUser(pageSize, page);
        
        JSONObject result=new JSONObject();
        result.put("total", pageInfo.getTotalPage());
		result.put("page", pageInfo.getPageNumber());
		result.put("records", pageInfo.getPageSize());
		
		JSONArray rows = new JSONArray();
		for (Record rc : pageInfo.getList()) {
			JSONObject json=new JSONObject();
			JSONArray row = new JSONArray();
			json.put("id", rc.getInt("id"));
			row.add(rc.getInt("id"));
			row.add(rc.get("user_name"));
			row.add(rc.get("real_name"));
			row.add(rc.get("role_name"));
			row.add(rc.get("user_kind"));
			json.put("cell", row);
			 rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }
    
    public void initEidtSysUser(){
    	String user_id=getPara("id");
    	Record sysUser = new Record();
    	List sysRole = new ArrayList<>();
    	if(StringUtil.isNotNull(user_id)){
    		 sysUser = Db.findFirst("select su.*,sr.role_name as role_name,sr.id as role_id from sys_user su "
    		 		+ "left join sys_user_role sur on su.id=sur.user_id left join sys_role sr on sur.role_id=sr.id "
    		 		+ "where su.id=? ", user_id);
    		 List<Record> sysRoleList = Db.find("select *from sys_role ");
    		 
			 for(Record item:sysRoleList){
				Map<String,Object> sr = new HashMap<String,Object>(); 
				sr.put("role_id", item.get("id"));
				sr.put("role_name", item.get("role_name"));
				sysRole.add(sr);
			 }
    		setAttr("sysRole", sysRole);
    		setAttr("sysUser",sysUser);
    		render(AppConst.PATH_MANAGE_PC + "/masterSys/adminManage/editUserRole.ftl");
    	}
    }
    
    public void savePower(){
    	Map<String, Object> mes = new HashMap<String,Object>();
    	SysUser sysUser=getModel(SysUser.class, "sysUser");
    	System.out.println(sysUser.toString());
    	int id = getParaToInt("user_id");
    	int role_id = getParaToInt("role_id");
    	int result=XFruitMaster.dao.updateMaster(model2map(sysUser), id, "sys_User");
    	if(result>0){
    		Record record = Db.findFirst("select * from sys_user_role where user_id=?", id);
    		if(record==null){
    			SysUserRole sysUserRole = new SysUserRole();
    			sysUserRole.set("user_id", id);
    			sysUserRole.set("role_id", role_id);
    			sysUserRole.save();
    		}else{
    			Db.update("update sys_user_role set role_id="+role_id+" where user_id=?", id);
    		}
    		mes.put("message", "操作成功！");
    	}else{
    		mes.put("message", "操作失败！");
    	}
    	renderJson(mes);
    }
    
}
