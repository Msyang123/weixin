CREATE TABLE `sys_code_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` varchar(45) DEFAULT NULL COMMENT '与code_type.id对应',
  `code_value` varchar(45) DEFAULT NULL COMMENT '值 ',
  `code_name` varchar(45) DEFAULT NULL COMMENT '显示的名字',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COMMENT='码表明细';

CREATE TABLE `sys_code_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(45) DEFAULT NULL COMMENT '与其他表的对应字段（英文）',
  `type_name` varchar(45) DEFAULT NULL COMMENT '中文说明',
  `sql` text COMMENT '优先从该字段检索数据，为空则到detail表检索',
  `valid_flag` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='码表';

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
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=881 DEFAULT CHARSET=utf8 COMMENT='操作日志';

CREATE TABLE `sys_param` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `value` varchar(200) DEFAULT NULL,
  `valid_flag` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='系统参数表';

CREATE TABLE `sys_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(20) DEFAULT NULL,
  `role_desc` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='角色表';

CREATE TABLE `sys_role_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8 COMMENT='角色权限对应表';

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name_UNIQUE` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='用户表';

CREATE TABLE `sys_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='用户角色表';
