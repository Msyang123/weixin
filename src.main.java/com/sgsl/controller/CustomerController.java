package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.ResourceShow;
import com.sgsl.model.SysUser;
import com.sgsl.model.UserDefinedMenu;
import com.sgsl.util.MD5Util;
import com.sgsl.util.StringUtil;
import com.xgs.model.XFruitApply;
import com.xgs.model.XFruitMaster;

import java.util.List;
import java.util.UUID;

/**
 * Created by Tao on 2014-07-17.
 */
public class CustomerController extends BaseController {
    protected final static Logger logger = Logger.getLogger(CustomerController.class);

    /**
     * 注册公共平台账号
     */
    public void register() {
        UUID uuid = UUID.randomUUID();
        PublicAccount model = getModel(PublicAccount.class,"pa");
        String password=MD5Util.md5(getPara("pa.password"));
        Record record = new Record();
        record.set("uuid",uuid.toString());
        record.set("valid_flag","2");
        record.set("user_kind","1");

        record.set("password", password);
        record.setColumns(model2map(model));
        if(Db.save("public_account",record)){
            //保存到系统账号
            SysUser.dao.set("user_name",getPara("pa.username")).set("pwd",password).set("valid_flag","1").set("user_kind","1").set("real_name",getPara("real_name")).save();
            redirect("/m");
            return;
        }else{
            render(AppConst.PATH_WEB_CUSTOMER + "/register.ftl");
        }
    }
    public void initRegister(){
        render(AppConst.PATH_WEB_CUSTOMER + "/register.ftl");
    }
    
	/**
	 * 初始化鲜果师申请页面
	 */
	public void initfruitRegister(){
		XFruitMaster xFruitMaster = XFruitMaster.dao.findById(getPara("id"));
		if(xFruitMaster == null){
			xFruitMaster = new XFruitMaster();
		}
		setAttr("xFruitMaster", xFruitMaster);
		XFruitApply xFruitApply = XFruitApply.dao.findById(getPara("id"));
		if(xFruitApply == null){
			xFruitApply = new XFruitApply();
		}
		setAttr("xFruitApply",xFruitApply);
    	render(AppConst.PATH_MANAGE_PC + "/client/fruitmaster/register1.ftl");
    }

    /**
     * 手机浏览便民服务信息列表
     */
    public void initResourceShowList(){
        String uuid=getPara("uuid");
        List<ResourceShow> resourceShowList=ResourceShow.dao.find("select * from resource_show where uuid=? order by layout_time desc",uuid);
        setAttr("resourceShowList",resourceShowList);
        render(AppConst.PATH_MANAGE_PC + "/client/resourceShowList.ftl");
    }

    /**
     * 手机浏览便民服务信息详情
     */
    public void detialResourceShow(){
        setAttr("detialResourceShow",ResourceShow.dao.findById(getPara("id")));
        render(AppConst.PATH_MANAGE_PC+"/client/detialResourceShow.ftl");
    }
    /**
     * 手机浏览自定义详细信息
     */
    public void selfMessage(){
    	setAttr("message",UserDefinedMenu.dao.findById(getParaToInt("id")));
    	render(AppConst.PATH_MANAGE_PC+"/client/selfMessage.ftl");
    }
}
