package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Model;

/**
 * Created by yj on 2014/7/28.
 */
public class Article extends Model<Article> {

        /**
         *
         */
        private static final long serialVersionUID = 1L;


        public static final Article dao = new Article();

        public Article findArticleByUuid(String uuid) {
            return dao.findFirst("select * from article where uuid=?",uuid);
        }
    }