package com.sgsl.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.log.Logger;
import com.revocn.controller.BaseController;
import com.sgsl.util.StringUtil;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.MWxmsg;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.SubmitMsg;
import com.sgsl.model.SysUser;
import com.sgsl.model.TUser;
import com.sgsl.model.UserDefinedMenu;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.utils.HttpUtil;
import com.sgsl.wechat.Token;
import com.sgsl.wechat.WeChatUtil;

import org.marker.weixin.DefaultSession;
import org.marker.weixin.HandleMessageAdapter;
import org.marker.weixin.MySecurity;
import org.marker.weixin.msg.Data4Item;
import org.marker.weixin.msg.Msg4Event;
import org.marker.weixin.msg.Msg4Image;
import org.marker.weixin.msg.Msg4ImageText;
import org.marker.weixin.msg.Msg4Location;
import org.marker.weixin.msg.Msg4Text;
import org.marker.weixin.msg.Msg4Voice;


/**
 * 官网
 * 
 * @author YangTao
 * 
 *         一日之计在于晨
 */
public class WeiXinController extends BaseController {

	protected final static Logger logger = Logger.getLogger(WeiXinController.class);
	public void sign(){
		String signature = getPara("signature");// 微信加密签名
		String timestamp = getPara("timestamp");// 时间戳
		String nonce = getPara("nonce");// 随机数
		String echostr = getPara("echostr");// 随机字符串

		// 重写totring方法，得到三个参数的拼接字符串
		List<String> list = new ArrayList<String>(3) {
			private static final long serialVersionUID = 2621444383666420433L;

			public String toString() {
				return this.get(0) + this.get(1) + this.get(2);
			}
		};
		list.add("wamwifi");//正式环境要修改下
		list.add(timestamp);
		list.add(nonce);
		Collections.sort(list);// 排序
		String tmpStr = new MySecurity().encode(list.toString(),
				MySecurity.SHA_1);// SHA-1加密

        if (signature.equals(tmpStr)) {
            if ("GET".equals(getRequest().getMethod())) {
                renderText(echostr);
            } else if ("POST".equals(getRequest().getMethod())) {
                try{
                    getResponse().setContentType("text/html; charset=utf-8");
                    InputStream is = getRequest().getInputStream();
                    OutputStream os = getResponse().getOutputStream();
                    final DefaultSession session = DefaultSession.newInstance();

                    session.addOnHandleMessageListener(new HandleMessageAdapter() {
                        //自动回复消息
                        @Override
                        public void onTextMsg(Msg4Text msg) {
                        	//保存客户的消息到数据库中
                        	MWxmsg mWxmsg=new MWxmsg();
                        	mWxmsg.set("msg_from", msg.getFromUserName());
                        	mWxmsg.set("msg_to",msg.getToUserName());
                        	mWxmsg.set("create_time",msg.getCreateTime());
                        	mWxmsg.set("content",msg.getContent());
                        	mWxmsg.save();
                        	
                            SubmitMsg sm= SubmitMsg.dao.findApproximationMsgBySendUser(msg.getToUserName(),msg.getContent());
                            if(sm==null){
                                /*Msg4Text reMsg = new Msg4Text();
                                reMsg.setFromUserName(msg.getToUserName());
                                reMsg.setToUserName(msg.getFromUserName());
                                reMsg.setCreateTime(msg.getCreateTime());

                                reMsg.setContent("没有找到任何关于("+msg.getContent()+")的消息，谢谢您的支持！");
                                session.callback(reMsg);*/// 回传消息
                            }else{
                                switch (sm.getInt("message_type")){
                                    case 1:
                                        Msg4Text reMsg = new Msg4Text();
                                        reMsg.setFromUserName(msg.getToUserName());
                                        reMsg.setToUserName(msg.getFromUserName());
                                        reMsg.setCreateTime(msg.getCreateTime());
                                        reMsg.setContent(sm.getStr("content"));
                                        session.callback(reMsg);// 回传消息
                                        break;
                                    case 2:
                                        // 回复一条消息
                                        Data4Item d1 = new Data4Item(
                                                //sm.getStr("key_word"),
                                                "",
                                        		sm.getStr("content"),
                                                sm.getStr("pic_url"),
                                                sm.getStr("url"));
                                    /*Data4Item d2 = new Data4Item(
                                            "雨林博客",
                                            "发布各种技术文章",
                                            "http://www.yl-blog.com/template/ylblog/images/logo.png",
                                            "www.yl-blog.com");*/

                                        Msg4ImageText mit = new Msg4ImageText();
                                        mit.setFromUserName(msg.getToUserName());
                                        mit.setToUserName(msg.getFromUserName());
                                        mit.setCreateTime(msg.getCreateTime());
                                        mit.addItem(d1);
                                        //mit.addItem(d2);
                                        session.callback(mit);
                                        break;
                                    case 3:
                                        Msg4Image rmsg = new Msg4Image();
                                        rmsg.setFromUserName(msg.getToUserName());
                                        rmsg.setToUserName(msg.getFromUserName());
                                        rmsg.setPicUrl(sm.getStr("pic_url"));
                                        session.callback(rmsg);
                                        break;
                                    default:
                                        /*Msg4Text defaultReMsg = new Msg4Text();
                                        defaultReMsg.setFromUserName(msg.getToUserName());
                                        defaultReMsg.setToUserName(msg.getFromUserName());
                                        defaultReMsg.setCreateTime(msg.getCreateTime());

                                        defaultReMsg.setContent("没有找到任何关于("+msg.getContent()+")的消息，谢谢您的支持！");
                                        session.callback(defaultReMsg);*/// 回传消息
                                }
                            }

                        /*if ("1".equals(msg.getContent())) {// 菜单选项1

                        } else if ("2".equals(msg.getContent())) {

                        } else if ("3".equals(msg.getContent())) {

                        } else {
                            Msg4Text reMsg = new Msg4Text();
                            reMsg.setFromUserName(msg.getToUserName());
                            reMsg.setToUserName(msg.getFromUserName());
                            reMsg.setCreateTime(msg.getCreateTime());

                            reMsg.setContent("消息命令错误，谢谢您的支持！@me:"+msg.getContent());

                            session.callback(reMsg);// 回传消息
                        }*/
                        }
                    });

                    // 语音识别消息
                    session.addOnHandleMessageListener(new HandleMessageAdapter() {

                        public void onVoiceMsg(Msg4Voice msg) {
                            Msg4Text reMsg = new Msg4Text();
                            reMsg.setFromUserName(msg.getToUserName());
                            reMsg.setToUserName(msg.getFromUserName());
                            reMsg.setCreateTime(msg.getCreateTime());
                            reMsg.setContent("识别结果: " + msg.getRecognition());
                            session.callback(reMsg);// 回传消息
                        }
                    });

                    // 处理事件
                    session.addOnHandleMessageListener(new HandleMessageAdapter() {
                        public void onEventMsg(Msg4Event msg) {
                           
                            //根据当期接收人自定义消息给予回复
                            String eventType = msg.getEvent();
                            if (Msg4Event.SUBSCRIBE.equals(eventType)) {// 订阅
                                //查找当前接收人设置的订阅消息
                                List<SubmitMsg> sms= SubmitMsg.dao.findSubmitMsgBySendUserAndMessageType(msg.getToUserName(),4);
                                System.out.println("关注人：" + msg.getFromUserName());

                                //循环发送，可能存在问题
                                for(SubmitMsg sm:sms) {
                                    /*Msg4Text reMsg = new Msg4Text();
                                    reMsg.setFromUserName(msg.getToUserName());
                                    reMsg.setToUserName(msg.getFromUserName());
                                    reMsg.setCreateTime(msg.getCreateTime());

                                    reMsg.setContent(sm.getStr("content"));
                                    session.callback(reMsg);// 回传消息*/
                                    Data4Item d = new Data4Item(
                                            sm.getStr("key_word"),
                                            sm.getStr("content"),
                                            sm.getStr("pic_url"),
                                            sm.getStr("url"));

                                    Msg4ImageText mit = new Msg4ImageText();
                                    mit.setFromUserName(msg.getToUserName());
                                    mit.setToUserName(msg.getFromUserName());
                                    mit.setCreateTime(msg.getCreateTime());
                                    mit.addItem(d);
                                    session.callback(mit);


                                }

                            } else if (Msg4Event.UNSUBSCRIBE.equals(eventType)) {// 取消订阅
                                System.out.println("取消关注：" + msg.getFromUserName());

                            } else if (Msg4Event.CLICK.equals(eventType)) {// 点击事件
                                //查找当前接收人
                                PublicAccount pa=PublicAccount.dao.findUserByOldNum(msg.getToUserName());
                                UserDefinedMenu udm=UserDefinedMenu.dao.findByMenuItemSignAndUuid(msg.getEventKey(),pa.getStr("uuid"));
                                System.out.println("用户：" + msg.getFromUserName());
                                System.out.println("点击Key：" + msg.getEventKey());
                                Msg4Text reMsg = new Msg4Text();
                                reMsg.setFromUserName(msg.getToUserName());
                                reMsg.setToUserName(msg.getFromUserName());
                                reMsg.setCreateTime(msg.getCreateTime());
                                reMsg.setContent(udm.getStr("received_info"));
                                switch (udm.getInt("msg_type")){
                                    case 1:
                                        session.callback(reMsg);
                                        break;
                                    case 2:
                                        Data4Item d1 = new Data4Item(
                                                udm.getStr("menu_name"),
                                                udm.getStr("received_info"),
                                                udm.getStr("pic_url"),
                                                udm.getStr("url"));
                                    /*Data4Item d2 = new Data4Item(
                                            "雨林博客",
                                            "发布各种技术文章",
                                            "http://www.yl-blog.com/template/ylblog/images/logo.png",
                                            "www.yl-blog.com");*/

                                        Msg4ImageText mit = new Msg4ImageText();
                                        mit.setFromUserName(msg.getToUserName());
                                        mit.setToUserName(msg.getFromUserName());
                                        mit.setCreateTime(msg.getCreateTime());
                                        mit.addItem(d1);
                                        //mit.addItem(d2);
                                        session.callback(mit);
                                        break;

                                    case 3:
                                        Msg4Image rmsg = new Msg4Image();
                                        rmsg.setFromUserName(msg.getToUserName());
                                        rmsg.setToUserName(msg.getFromUserName());
                                        rmsg.setPicUrl(udm.getStr("pic_url"));
                                        session.callback(rmsg);
                                        break;
                                    default:
                                        session.callback(reMsg);
                                }
                            }
                        }
                    });

                    // 处理地理位置
                    session.addOnHandleMessageListener(new HandleMessageAdapter() {
                        public void onLocationMsg(Msg4Location msg) {
                            System.out.println("收到地理位置消息：");
                            System.out.println("X:" + msg.getLocation_X());
                            System.out.println("Y:" + msg.getLocation_Y());
                            System.out.println("Scale:" + msg.getScale());
                        }

                    });

                    session.process(is, os);// 处理微信消息
                    session.close();// 关闭Session
                } catch (UnsupportedEncodingException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                } catch (IOException e) {
                    // TODO: handle exception
                }
                renderNull();
            }
        } else {
            renderText("");
        }

	}

	public void registerMessage() {
		try {

			getResponse().setContentType("text/html; charset=utf-8");
			InputStream is = getRequest().getInputStream();
			OutputStream os = getResponse().getOutputStream();

			final DefaultSession session = DefaultSession.newInstance();

			session.addOnHandleMessageListener(new HandleMessageAdapter() {
				//自动回复消息
				@Override
				public void onTextMsg(Msg4Text msg) {
                    SubmitMsg sm= SubmitMsg.dao.findApproximationMsgBySendUser(msg.getToUserName(),msg.getContent());
                    if(sm==null){
                        /*Msg4Text reMsg = new Msg4Text();
                        reMsg.setFromUserName(msg.getToUserName());
                        reMsg.setToUserName(msg.getFromUserName());
                        reMsg.setCreateTime(DateFormatUtil.format1(new Date()));

                        reMsg.setContent("没有找到任何关于("+msg.getContent()+")的消息，谢谢您的支持！");
                        session.callback(reMsg);*/// 回传消息
                    }else{
                        switch (sm.getInt("message_type")){
                            case 1:
                                Msg4Text reMsg = new Msg4Text();
                                reMsg.setFromUserName(msg.getToUserName());
                                reMsg.setToUserName(msg.getFromUserName());
                                reMsg.setCreateTime(msg.getCreateTime());
                                reMsg.setContent(sm.getStr("content"));
                                session.callback(reMsg);// 回传消息
                                break;
                            case 2:
                                // 回复一条消息
                                Data4Item d1 = new Data4Item(
                                        "",//sm.getStr("key_word"),
                                        sm.getStr("content"),
                                        sm.getStr("pic_url"),
                                        sm.getStr("url"));
                                /*Data4Item d2 = new Data4Item(
                                        "雨林博客",
                                        "发布各种技术文章",
                                        "http://www.yl-blog.com/template/ylblog/images/logo.png",
                                        "www.yl-blog.com");*/

                                Msg4ImageText mit = new Msg4ImageText();
                                mit.setFromUserName(msg.getToUserName());
                                mit.setToUserName(msg.getFromUserName());
                                mit.setCreateTime(msg.getCreateTime());
                                mit.addItem(d1);
                                //mit.addItem(d2);
                                session.callback(mit);
                                break;
                            case 3:
                                Msg4Image rmsg = new Msg4Image();
                                rmsg.setFromUserName(msg.getToUserName());
                                rmsg.setToUserName(msg.getFromUserName());
                                rmsg.setPicUrl(sm.getStr("pic_url"));
                                session.callback(rmsg);
                                break;
                            default:
                                /*Msg4Text defaultReMsg = new Msg4Text();
                                defaultReMsg.setFromUserName(msg.getToUserName());
                                defaultReMsg.setToUserName(msg.getFromUserName());
                                defaultReMsg.setCreateTime(msg.getCreateTime());

                                defaultReMsg.setContent("没有找到任何关于("+msg.getContent()+")的消息，谢谢您的支持！");
                                session.callback(defaultReMsg);*/// 回传消息
                        }
                    }
                    renderNull();

					/*if ("1".equals(msg.getContent())) {// 菜单选项1

					} else if ("2".equals(msg.getContent())) {

					} else if ("3".equals(msg.getContent())) {

					} else {
						Msg4Text reMsg = new Msg4Text();
						reMsg.setFromUserName(msg.getToUserName());
						reMsg.setToUserName(msg.getFromUserName());
						reMsg.setCreateTime(msg.getCreateTime());

						reMsg.setContent("消息命令错误，谢谢您的支持！@me:"+msg.getContent());

						session.callback(reMsg);// 回传消息
					}*/
				}
			});

			// 语音识别消息
			session.addOnHandleMessageListener(new HandleMessageAdapter() {

				public void onVoiceMsg(Msg4Voice msg) {
					Msg4Text reMsg = new Msg4Text();
					reMsg.setFromUserName(msg.getToUserName());
					reMsg.setToUserName(msg.getFromUserName());
					reMsg.setCreateTime(msg.getCreateTime());
					reMsg.setContent("识别结果: " + msg.getRecognition());
					session.callback(reMsg);// 回传消息
                    renderNull();
				}
			});

			// 处理事件
			session.addOnHandleMessageListener(new HandleMessageAdapter() {
				public void onEventMsg(Msg4Event msg) {

                    //根据当期接收人自定义消息给予回复

					String eventType = msg.getEvent();
					if (Msg4Event.SUBSCRIBE.equals(eventType)) {// 订阅
                        //查找当前接收人设置的订阅消息
                        List<SubmitMsg> sms= SubmitMsg.dao.findSubmitMsgBySendUserAndMessageType(msg.getToUserName(),4);
						System.out.println("关注人：" + msg.getFromUserName());

                        //循环发送，可能存在问题
                        for(SubmitMsg sm:sms) {
                            Msg4Text reMsg = new Msg4Text();
                            reMsg.setFromUserName(msg.getToUserName());
                            reMsg.setToUserName(msg.getFromUserName());
                            reMsg.setCreateTime(msg.getCreateTime());

                            reMsg.setContent(sm.getStr("content"));

                            session.callback(reMsg);// 回传消息
                        }

					} else if (Msg4Event.UNSUBSCRIBE.equals(eventType)) {// 取消订阅
						System.out.println("取消关注：" + msg.getFromUserName());

					} else if (Msg4Event.CLICK.equals(eventType)) {// 点击事件
                        //查找当前接收人
                        PublicAccount pa=PublicAccount.dao.findUserByOldNum(msg.getToUserName());
                        UserDefinedMenu udm=UserDefinedMenu.dao.findByMenuItemSignAndUuid(msg.getEventKey(),pa.getStr("uuid"));
						System.out.println("用户：" + msg.getFromUserName());
						System.out.println("点击Key：" + msg.getEventKey());
						Msg4Text reMsg = new Msg4Text();
						reMsg.setFromUserName(msg.getToUserName());
						reMsg.setToUserName(msg.getFromUserName());
						reMsg.setCreateTime(msg.getCreateTime());

						reMsg.setContent(udm.getStr("received_info"));
						session.callback(reMsg);
					}

				}
			});

			// 处理地理位置
			session.addOnHandleMessageListener(new HandleMessageAdapter() {
				public void onLocationMsg(Msg4Location msg) {
					System.out.println("收到地理位置消息：");
					System.out.println("X:" + msg.getLocation_X());
					System.out.println("Y:" + msg.getLocation_Y());
					System.out.println("Scale:" + msg.getScale());
				}

			});

			session.process(is, os);// 处理微信消息
			session.close();// 关闭Session
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO: handle exception
		}
        renderNull();
	}

    /**
     * 重新构建微信菜单树
     */
    public void rebulidWeixinMenu(){
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        JSONObject menu=new JSONObject();
        JSONArray menuArr=new JSONArray();
        for (UserDefinedMenu firstLevel: UserDefinedMenu.dao.findByParentId(0,publicAccount.getStr("uuid"))){
            JSONObject firstLevelMenuItem=new JSONObject();
            firstLevelMenuItem.put("name",firstLevel.get("menu_name"));
            //检测是否是拥有子节点
            if(UserDefinedMenu.dao.isParent(firstLevel.getInt("id"),publicAccount.getStr("uuid"))>0) {
                JSONArray menuSecondArr=new JSONArray();
                for (UserDefinedMenu secondLevel : UserDefinedMenu.dao.findByParentId(firstLevel.getInt("id"), publicAccount.getStr("uuid"))) {
                    JSONObject secondLevelMenuItem=new JSONObject();
                    secondLevelMenuItem.put("name",secondLevel.get("menu_name"));
                    if(secondLevel.get("menu_type").equals("click")){
                        secondLevelMenuItem.put("key", secondLevel.get("menu_sign"));
                    }else{
                    	String url=null;
                    	if(secondLevel.getInt("msg_type")==4){
                    		url=secondLevel.getStr("url")+
                                    (secondLevel.getStr("url").indexOf("?")>0?"&":"?")+"uuid="+publicAccount.getStr("uuid")+"&id="+secondLevel.getInt("id");
                    	}else{
                    		url=secondLevel.getStr("received_info")+
                                    (secondLevel.getStr("received_info").indexOf("?")>0?"&":"?")+"uuid="+publicAccount.getStr("uuid")+"&id="+secondLevel.getInt("id");
                    	}
                        //追加参数标记
                        secondLevelMenuItem.put("url", url);
                    }
                    secondLevelMenuItem.put("type", secondLevel.get("menu_type"));
                    menuSecondArr.add(secondLevelMenuItem);
                }
                firstLevelMenuItem.put("sub_button", menuSecondArr);
            }else{
                if(firstLevel.get("menu_type").equals("click")){
                    firstLevelMenuItem.put("key", firstLevel.get("menu_sign"));
                }else{
                    String url=null;
                	if(firstLevel.getInt("msg_type")==4){
                		url=firstLevel.getStr("url")+
                                (firstLevel.getStr("url").indexOf("?")>0?"&":"?")+"uuid="+publicAccount.getStr("uuid")+"&id="+firstLevel.getInt("id");
                	}else{
                		url=firstLevel.getStr("received_info")+
                                (firstLevel.getStr("received_info").indexOf("?")>0?"&":"?")+"uuid="+publicAccount.getStr("uuid")+"&id="+firstLevel.getInt("id");
                	}
                	//追加参数标记
                	firstLevelMenuItem.put("url",url);
                }
                firstLevelMenuItem.put("type", firstLevel.get("menu_type"));
            }
            menuArr.add(firstLevelMenuItem);
        }
        menu.put("button", menuArr);
        Map<String, String> postParams=new HashMap<String,String>();
        postParams.put("body",menu.toJSONString());
        //发送生成菜单命令
        renderJson(HttpUtil.post("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + HttpUtil.getAccessToken(publicAccount.getStr("app_id"), publicAccount.getStr("app_key")).get("access_token"), postParams));
    }
    
    /**
     * 发送客服信息
     */
    public void sendCustomMessage(){
    	MWxmsg mWxmsg=null;
    	String msgFrom=null;
    	String ids=null;
    	String s=null;
    	String type=getPara("type");
    	if(StringUtil.isNotNull(getPara("id"))){
    		mWxmsg=new MWxmsg().findById(getPara("id"));
    		msgFrom=mWxmsg.get("msg_from");
    	}else if(StringUtil.isNotNull(getPara("msgFrom"))){
    		msgFrom=getPara("msgFrom");
    	}else{
    		ids=getPara("ids");
    	}
    	/*String appid = AppProps.get("appid");
		String appsecrect = AppProps.get("app_secrect");
		
		Object accessToken=getSessionAttr("accessToken");
		if(accessToken==null){
			accessToken=HttpUtil.getAccessToken(appid, appsecrect).getString("access_token");
			setSessionAttr("accessToken",accessToken);
		}*/
    
    	
    	
    	
		String accessToken=(String)getRequest().getSession().getServletContext().getAttribute("_wechat_access_token_");//getAttr("access_token");
        //群发
        if(StringUtil.isNotNull(ids)){
        	StringBuffer sql=new StringBuffer("select * from t_user where id in(");
        	boolean flag=false;
        	for(String id:ids.split(",")){
        		if(flag){
        			sql.append(",");
        		}
        		sql.append(id);
        		flag=true;
        	}
        	sql.append(")");
        	
        	List<TUser> users=TUser.dao.find(sql.toString());
        	
        	for(TUser u:users){
        		try{
        			Map<String, String> postParams=new HashMap<String,String>();
                    JSONObject message=new JSONObject();
                	message.put("touser",u.getStr("open_id"));
                    message.put("msgtype", "text");
                    	JSONObject text=new JSONObject();
                    	text.put("content", getPara("content"));
                    message.put("text",text);     
                    postParams.put("body",message.toString());
                    s=HttpUtil.post("https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=" +
                    accessToken, postParams);
                    System.out.println(s);
        		}catch(Exception e){
        			logger.error(e.getMessage());
        			continue;
        		}
        	}
        }else{
        	Map<String, String> postParams=new HashMap<String,String>();
            JSONObject message=new JSONObject();
        	message.put("touser",msgFrom);
            message.put("msgtype", "text");
            	JSONObject text=new JSONObject();
            	text.put("content", getPara("content"));
            message.put("text",text);     
            postParams.put("body",message.toString());
            s=HttpUtil.post("https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=" +
            accessToken, postParams);
            if(StringUtil.isNotNull(getPara("id"))){
            	//将单个问题回复结果保存
            	MWxmsg msgRep=new MWxmsg();
            	msgRep.set("rep_id", getPara("id"));
            	msgRep.set("msg_from", mWxmsg.get("msg_to"));
            	msgRep.set("msg_to", mWxmsg.get("msg_from"));
            	msgRep.set("create_time", DateFormatUtil.format1(new Date()));
            	msgRep.set("content", getPara("content"));
            	msgRep.save();
            	//更新原来的回复为已回复
            	mWxmsg.set("is_replyed", "Y");
            	mWxmsg.update();
            	if(StringUtil.isNull(type)){
            		setAttr("msg", s);
            		render(AppConst.PATH_MANAGE_PC + "/client/minsys/repList.ftl");
            	}else{
            		renderJson(s);
            		return;
            	}
            }
        } 
        setAttr("msg", s);
        //render(AppConst.PATH_MANAGE_PC + "/sys/repWxmsg.ftl");
        redirect("/submitMsg/initWxmsg");
    }
    public void shorturl(){
    	if(StringUtil.isNull(getPara("langUrl"))){
    		render(AppConst.PATH_MANAGE_PC + "/tool/shorturl.ftl");
    		return;
    	}
    	JSONObject params=new JSONObject();
		params.put("action", "long2short");
		params.put("long_url", getPara("langUrl"));
		setAttr("langUrl", getPara("langUrl"));
		Map<String, String> postParams=new HashMap<String, String>();
		postParams.put("body",params.toString());
		String accessToken=(String)getRequest().getSession().getServletContext().getAttribute("_wechat_access_token_");
		String s=HttpUtil.post("https://api.weixin.qq.com/cgi-bin/shorturl?access_token="+accessToken, postParams);
    	if(s!=null){
    		JSONObject resultJson=JSONObject.parseObject(s);
    		if(resultJson.getIntValue("errcode")==0){
    			String shortUrl=resultJson.getString("short_url");
    			shortUrl=shortUrl.replaceAll("\\\\", "");
    			setAttr("result", shortUrl);
    		}else{
        		setAttr("result", "调用失败");
        	} 
    	}else{
    		setAttr("result", "调用失败");
    	}
    	render(AppConst.PATH_MANAGE_PC + "/tool/shorturl.ftl");
    }
    
    
    /**
     * 微信第三方平台参数封装
     * @param request
     */
    public void getAppProps(){
    	try {
    		JSONObject resultParam = new JSONObject();
			String appid = AppProps.get("appid");
			String access_token = (String)getRequest().getServletContext().getAttribute("_wechat_access_token_");
			String jsapi_ticket = (String)getRequest().getServletContext().getAttribute("_wechat_jsapi_ticket_");
			String timestamp = Long.toString(System.currentTimeMillis() / 1000);
			String nonce_str = UUID.randomUUID().toString();
			String url = getPara("url");
			String decodedUrl = URLDecoder.decode(url.trim(), "UTF-8");
			String signature = WeChatUtil.getSignature(jsapi_ticket, timestamp, nonce_str, decodedUrl);
			resultParam.put("appid", appid);
			resultParam.put("access_token", access_token);
			resultParam.put("jsapi_ticket", jsapi_ticket);
			resultParam.put("timestamp", timestamp);
			resultParam.put("nonce_str", nonce_str);
			resultParam.put("signature", signature);
			renderJson(resultParam);
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}  
    }
    
    
    public static void main(String[] args) {
		Object accessToken=HttpUtil.getAccessToken("wx6174647d21319128", "ca0a3a393b387f6f023e37e53302d590").getString("access_token");
    	//String s=HttpUtil.get("https://api.weixin.qq.com/cgi-bin/user/info?access_token="+accessToken+"&openid=oKqRHwUDjKQodlPmNJYs82PIlSAA&lang=zh_CN");
		JSONObject params=new JSONObject();
		params.put("action", "long2short");
		params.put("long_url", "http://weixin.shuiguoshule.com.cn/weixin/main");
		Map<String, String> postParams=new HashMap<String, String>();
		postParams.put("body",params.toJSONString());
		String s=HttpUtil.post("https://api.weixin.qq.com/cgi-bin/shorturl?access_token="+accessToken, postParams);
    	System.out.println(s);
	}
}
