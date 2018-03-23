<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<form action="m/role/modifyMenu" method="post">
<input id="id" type="hidden" name="menu.id" value=${menu.id}><br>
<label for="userName" style="width:100px">名字：</label>
<input id="name"type="text" name=menu.menu_name value="${(menu.menu_name)!}" class="form-control"><br>
<label for="userName" style="width:100px">地址:</label>
<input id="address"type="text" name="menu.href" value="${(menu.href)!}" class="form-control"><br>
<label for="userName" style="width:100px">标识:</label>
<!-- <input id="address"type="text" name="menu.valid_flag" value="${(menu.valid_flag)!}" class="form-control"> -->
<br>
<select name=menu.valid_flag>
	<option value="1">有效</option>
	<option value="2">无效</option>
</select>

<input type="submit" value="修改">
</form>
</@layout>