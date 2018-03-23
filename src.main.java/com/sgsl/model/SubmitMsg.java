package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

import java.util.List;

/**
 * Created by zouzhangqing on 2014/7/28.
 */
public class SubmitMsg extends Model<SubmitMsg> {

    /**
     *
     */
    private static final long serialVersionUID = 1L;


    public static final SubmitMsg dao = new SubmitMsg();

    /**
     * 查找订阅消息 MessageType=4(通过发送人为公众账号微信号的)
     * @param
     * @return
     */
    public List<SubmitMsg> findSubmitMsgBySendUserAndMessageType(String sendUser,int messageType) {
        return dao.find("select * from submit_msg where send_user=? and message_type=?", new Object[]{sendUser,messageType});
    }
    /**
     * 查找预设回复信息（只查找一条）
     */

    public SubmitMsg findApproximationMsgBySendUser(String sendUser,String sendMsg){
        return dao.findFirst("select * from submit_msg where send_user=? and key_word like '%"+sendMsg+"%' limit 1",sendUser);
    }
}