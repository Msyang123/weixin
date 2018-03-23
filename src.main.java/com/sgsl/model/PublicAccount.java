package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;

/**
 * Created by zouzhangqing on 2014/7/28.
 */
public class PublicAccount extends Model<PublicAccount> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final PublicAccount dao = new PublicAccount();

        public PublicAccount findUserByLoginName(String username) {
            return dao.findFirst("select * from public_account where username=?",username);
        }
        public PublicAccount findUserByOldNum(String oldNum) {
            return dao.findFirst("select * from public_account where old_num=?",oldNum);
        }
    }