<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/> <@layout
scripts=[] styles=[] >
<form role="form" action="m/role/saveRole" method="post">
	<div class="form-group">
		<label for="name">正在修改权限的用户为：${user.user_name}</label> <br>
		
		<lable for="name">正在使用的权限为：
		 <#if userRole?size!=0> 
		 	<#list userRole as item>
			 	 ${item.role_id}, 
			</#list> 更新权限会删除原有权限
			<#else> 无 
		</#if>   
		</lable><br> 
		
		<label for="role">权限列表：</label> <br> 
			<input type="hidden" name="sysrole.user_id" value="${user.id}" /> 
		<#list role as item> 
			<input type="checkbox" name="sysrole.role_id" value="${item.id}">${item.role_desc}</input>
		</#list>
	</div>

	<input type="submit" class="btn btn-primary" value="baocun"></input>
</form>

</@layout>
