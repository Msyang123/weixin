<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<form action="m/role/modifyUser" method="post">
<input id="id" type="hidden" name="user.id" value=${user.id}><br>
<label for="userName" style="width:100px">名字：</label>
<input id="name"type="text" name="user.user_name" value="${(user.user_name)!}" class="form-control"><br>
<label for="userName" style="width:100px">地址:</label>
<input id="address"type="text" name="user.address" value="${(user.address)!}" class="form-control"><br>
<label for="userName" style="width:100px">真实姓名:</label>
<input id="realname"type="text" name="user.real_name" value="${(user.real_name)!}" class="form-control"><br>

<label for="address" style="width:100px">用户角色</label>

<select name="role_id" class="form-control" >
<#list rolelist as role>
	<#if role.id == user.role_id>
	<option value="${role.id}" selected="selected">${role.role_desc}</option>
	<#else>
	<option value="${role.id}" >${role.role_desc}</option>
	</#if>
</#list>
</select>
<br>

<input type="submit" value="修改">
</form>
</@layout>