package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by zouzhangqing on 2014/7/28.
 */
public class UserDefinedMenu extends Model<UserDefinedMenu> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final UserDefinedMenu dao = new UserDefinedMenu();

    /**
     * 得到当前节点下一级所有节点
     * @param parentId
     * @param uuid
     * @return
     */
        public List<UserDefinedMenu> findByParentId(int parentId,String uuid) {
            return dao.find("select * from user_defined_menu where pid=? and uuid=? order by order_id", new Object[]{parentId,uuid});
        }

        private void doSearchChild(List<UserDefinedMenu> current,List<UserDefinedMenu> result,String uuid){
            if(current.size()==0){
                return;
            }
            result.addAll(current);
            for(UserDefinedMenu item: current){
                List<UserDefinedMenu> children=this.findByParentId(item.getInt("id"),uuid);
                if(children.size()==0){
                    continue;
                }
                doSearchChild(children,result,uuid);
            }
        }

    /**
     * 得到当前节点下所有的子节点
     * @param parentId
     * @param uuid
     * @return
     */
        public List<UserDefinedMenu> getChildern(int parentId,String uuid){
            List<UserDefinedMenu> current=findByParentId(parentId,uuid);
            List<UserDefinedMenu> result=new ArrayList<UserDefinedMenu>();
            doSearchChild(current,result,uuid);
            return result;
        }

    /**
     * 查找当前节点是否拥有子节点
     * @param id
     * @param uuid
     * @return
     */
        public int isParent(int id,String uuid){
            return this.findByParentId(id,uuid).size();
        }

    /**
     * 根据uuid 和menu_sign查找菜单项
     * @param menuSign
     * @param uuid
     * @return
     */
        public UserDefinedMenu findByMenuItemSignAndUuid(String menuSign,String uuid){
               return dao.findFirst("select * from user_defined_menu where menu_sign=? and uuid=?",new Object[]{menuSign,uuid});
        }
    }