CREATE TABLE `bespeak` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `submit_name` varchar(50) DEFAULT NULL,
  `age` int(3) DEFAULT NULL,
  `job` varchar(20) DEFAULT NULL,
  `meet` varchar(50) DEFAULT NULL,
  `date` varchar(32) DEFAULT NULL,
  `create_time` varchar(32) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `public_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(50) DEFAULT NULL,
  `valid_flag` char(1) DEFAULT NULL,
  `user_kind` int(1) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `weixin_num` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `app_id` varchar(50) DEFAULT NULL,
  `app_key` varchar(50) DEFAULT NULL,
  `old_num` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

CREATE TABLE `resource_show` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key_word` varchar(100) DEFAULT NULL,
  `layout_time` varchar(32) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE `submit_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_type` int(1) DEFAULT NULL,
  `key_word` varchar(100) DEFAULT NULL,
  `pic_url` varchar(100) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `send_user` varchar(32) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `sys_code_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` varchar(45) DEFAULT NULL COMMENT '与code_type.id对应',
  `code_value` varchar(45) DEFAULT NULL COMMENT '值 ',
  `code_name` varchar(45) DEFAULT NULL COMMENT '显示的名字',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='码表明细';

CREATE TABLE `sys_code_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(45) DEFAULT NULL COMMENT '与其他表的对应字段（英文）',
  `type_name` varchar(45) DEFAULT NULL COMMENT '中文说明',
  `sql` text COMMENT '优先从该字段检索数据，为空则到detail表检索',
  `valid_flag` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='码表';

CREATE TABLE `sys_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `menu_name` varchar(50) DEFAULT NULL,
  `href` varchar(200) DEFAULT NULL,
  `valid_flag` varchar(1) DEFAULT NULL,
  `ico_path` varchar(200) DEFAULT NULL,
  `dis_order` int(3) DEFAULT NULL,
  `menu_type` varchar(1) DEFAULT NULL COMMENT '1 菜单 2 权限',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `sys_operate_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(45) DEFAULT NULL,
  `method` varchar(45) DEFAULT NULL,
  `params` varchar(300) DEFAULT NULL,
  `op_time` timestamp NULL DEFAULT NULL,
  `op_staff_id` int(11) DEFAULT NULL,
  `LogLevel` varchar(10) DEFAULT NULL,
  `msg` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='操作日志';

CREATE TABLE `sys_param` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `value` varchar(200) DEFAULT NULL,
  `valid_flag` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统参数表';

CREATE TABLE `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(20) DEFAULT NULL,
  `role_desc` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

CREATE TABLE `sys_role_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色权限对应表';

CREATE TABLE `sys_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `user_name` varchar(45) DEFAULT NULL COMMENT '登录名',
  `pwd` varchar(64) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `tel` varchar(20) DEFAULT NULL COMMENT '电话',
  `mobile` varchar(11) DEFAULT NULL COMMENT '手机',
  `legal_person` varchar(45) DEFAULT NULL COMMENT '法人',
  `valid_flag` varchar(1) DEFAULT NULL,
  `real_name` varchar(45) DEFAULT NULL COMMENT '真实姓名',
  `user_kind` varchar(1) DEFAULT NULL COMMENT '用户类型（1超级管理 2 一般管理员 3 用户 4 代理商）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='用户表';

CREATE TABLE `sys_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户角色表';

CREATE TABLE `user_defined_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `received_info` longtext,
  `menu_name` varchar(100) DEFAULT NULL,
  `menu_sign` varchar(100) DEFAULT NULL,
  `menu_type` varchar(10) DEFAULT NULL,
  `msg_type` int(1) DEFAULT NULL,
  `pic_url` varchar(100) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `is_parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;





INSERT INTO `sys_menu` VALUES (1, 0, '系统管理', '#', '1', 'menu-icon fa fa-tachometer', 0, '0');
INSERT INTO `sys_menu` VALUES (2, 1, '系统用户', '/system/sysuserList', '1', 'dropdown-header', 1, '1');
INSERT INTO `sys_menu` VALUES (3, 0, '微信管理', '#', '1', 'menu-icon fa fa-tachometer', 1, '0');
INSERT INTO `sys_menu` VALUES (4, 3, '微信菜单', '/system/initShowWeixinMenu', '1', 'dropdown-header', 2, '1');
INSERT INTO `sys_menu` VALUES (5, 3, '消息管理', '/submitMsg/initSubmitMsg', '1', 'dropdown-header', 3, '1');
INSERT INTO `sys_menu` VALUES (6, 3, '资讯信息', '/resourceShow/initResourceShow', '1', 'dropdown-header', 4, '1');
INSERT INTO `sys_menu` VALUES (7, 3, '网上预约', '/bespeak/initBespeakList', '1', 'dropdown-header', 5, '1');


INSERT INTO `sys_user` VALUES (1, NULL, 'admin', '88EA39439E74FA27C09A4FC0BC8EBE6D00978392', NULL, NULL, NULL, NULL, '1', '湖南盛鼎科技', '1');
INSERT INTO `sys_user` VALUES (8, NULL, 'as', 'DF211CCDD94A63E0BCB9E6AE427A249484A49D60', NULL, NULL, NULL, NULL, '1', 'asda', '1');


INSERT INTO `user_defined_menu` VALUES (1, 0, '2d2cad79-f632-4de7-8a30-a1a62b361fb0', 2, 'asddd', '测试菜单', 'asdasd', 'click', 1, 'http://www.asdasd/com', 'http://www.bbbbb/com', 0);
INSERT INTO `user_defined_menu` VALUES (2, 0, '2d2cad79-f632-4de7-8a30-a1a62b361fb0', 5, 'asddd', '测试1', 'asdasd', 'click', 1, 'http://www.asdasd/com', 'http://www.bbbbb/com', NULL);
INSERT INTO `user_defined_menu` VALUES (3, 2, '2d2cad79-f632-4de7-8a30-a1a62b361fb0', 5, 'asddd', '我是一只小小鸟', 'asdasd', 'view', 3, 'http://www.asdasd/com', 'http://www.bbbbb/com', NULL);


INSERT INTO `public_account` VALUES (6, 'a7a6c0af-58ed-4671-887b-998246cb4d9c', '1', 1, '123123123', 'sadasfsdf', 'admin', '123', '12312', 'gh_b9cf800c1f70');
INSERT INTO `public_account` VALUES (9, '2d2cad79-f632-4de7-8a30-a1a62b361fb0', '1', 1, 'as', 'sdfsdf', 'as', 'asda', 'sdfsdf', 'safsdf');


INSERT INTO `resource_show` VALUES (1, 'asda撒的', '2014-10-22 11:49:34.996', 'http://www.sina.com.cn', '很好吃吧<img src=\"/attached/8/image/20141022/20141022114744_728.jpg\" alt=\"\" />', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (2, 'asfd', '2014-10-23 10:28:08.79', 'asfasdg', 'sdgdsfg', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (3, 'sdfg', '2014-10-23 10:28:13.955', 'asdff', 'dfhgdfhdf', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (4, 'dfgdf', '2014-10-23 10:28:19.275', 'asgdf', 'hdfh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (5, 'fghfg', '2014-10-23 10:28:23.567', 'dfhgdfh', 'hfghfgh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (6, 'dfhgdf', '2014-10-23 10:28:28.539', 'dfhdfh', 'hdfhdfh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (7, 'fdhfgjh', '2014-10-23 10:28:33.492', 'dfhgdfhdfh', 'fdhfdh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (8, 'sdfhdfh', '2014-10-23 10:28:38.253', 'dfhgdfh', 'fdhdfh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (9, 'dfhh', '2014-10-23 10:28:43.543', 'sdgsdgds', 'dfhgsdfgds', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (10, 'sfdghdfh', '2014-10-23 10:28:50.192', 'dfhdfhfdh', 'dsfhdfh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');
INSERT INTO `resource_show` VALUES (11, 'fdgdfh', '2014-10-23 10:28:57.774', 'dfhdfh', 'dfhdfh', '2d2cad79-f632-4de7-8a30-a1a62b361fb0');


INSERT INTO `submit_msg` VALUES (3, 2, '文字想', '2131', '231423423', 'safsdf', '2d2cad79-f632-4de7-8a30-a1a62b361fb0', 'sdfsdfsd阿萨德的', 1);
