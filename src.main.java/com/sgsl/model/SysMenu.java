package com.sgsl.model;

import com.jfinal.plugin.activerecord.Model;
import com.sgsl.model.SysUser;

import java.util.List;

public class SysMenu extends Model<SysMenu> {
	private static final long serialVersionUID = 1L;
	public static final SysMenu dao = new SysMenu();

	public List<SysMenu> getParentMenu() {
		return dao.find("select * from sys_menu where pid=0 order by dis_order");
	}

	public List<SysMenu> getMenuById(Integer id) {
		return dao.find("select * from sys_menu where pid=" + id + " order by dis_order");
	}

	public List<SysMenu> getMenu(Integer user_id, Integer pid) {
		StringBuffer sb = new StringBuffer();
		sb.append(" select c.* from sys_user_role a,sys_role_menu b,sys_menu c ");
		sb.append(" where a.role_id = b.role_id and b.menu_id = c.id ");
		sb.append("  and c.valid_flag = '1'  ");
		sb.append("  and a.user_id = " + user_id);

		sb.append("  and c.pid = " + pid);
		return dao.find(sb.toString());
	}

	public List<SysMenu> getStoreMenu(Integer pid) {
		StringBuffer sb = new StringBuffer();
		sb.append(" select b.* from sys_menu b, sys_role_menu c ");
		sb.append(" where c.role_id = 4 and c.menu_id  = b.id and b.valid_flag <> 2 and b.pid = " + pid);
		return dao.find(sb.toString());
	}

	public SysMenu findMenuById(Integer id) {
		return (SysMenu) dao.findById(id);
	}

	public List<SysMenu> getRightMenu(int roleId) {
		return dao.find(
				"select a.*, ifnull( b.id,0) chk from sys_menu a left join sys_role_menu b on a.id = b.menu_id and b.role_id = ?",
				new Object[] { Integer.valueOf(roleId) });
	}

	public void sortMenu(boolean root, SysUser user, List<SysMenu> childMenu, StringBuffer menu) {
		if (root) {
			/*if (user.getStr("user_kind").equals("1"))
				childMenu = dao.getParentMenu();
			else {*/
				childMenu = dao.getMenu(user.getInt("id"), Integer.valueOf(0));
			//}
			menu.append("<ul class=\"nav nav-list\">");
		} else if (childMenu.size() > 0) {
			menu.append("<ul class=\"submenu\" >\n");
		} else {
			return;
		}

		root = false;
		for (SysMenu item : childMenu) {
			List _childMenu = null;

			/*if (user.getStr("user_kind").equals("1"))
				_childMenu = new SysMenu().getMenuById(item.getInt("id"));
			else {*/
				_childMenu = new SysMenu().getMenu(user.getInt("id"), item.getInt("id"));
			//}
			menu.append("<li>\n");
			menu.append("<a href=\"");
			menu.append(item.getStr("href"));
			menu.append("\" ");

			if ("#".equals(item.getStr("href"))) {
				menu.append("class=\"dropdown-toggle\">");
			}
			menu.append("\n");
			menu.append("<i class=\"" + item.getStr("ico_path") + "\"></i>\n");
			menu.append("<span class=\"menu-text\">");
			menu.append(item.getStr("menu_name"));
			menu.append("</span>\n");
			menu.append("</a>\n");

			sortMenu(root, user, _childMenu, menu);
			menu.append("</li>\n");
		}
		menu.append("</ul>");
	}
}