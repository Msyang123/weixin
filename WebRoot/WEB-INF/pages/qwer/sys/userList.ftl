<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >

<div class="table_box">
	<table class="table table-bordered table-striped table-condensed  table-hover">
		<thead>
			<tr>
				
				<th >用户名</th>
				<th >真实姓名</th>
				<th>上级用户</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			</thead>
			<tbody>
			<#list userPage.getList() as x>
			<tr>
				<td style="text-align:left;" hidden="true">${x.id}</td>
				<td style="text-align:left;">${(x.user_name)!}</td>
				<td style="text-align:left;">${(x.real_name)!}</td>
				<td style="text-align:left;">${(x.pid_name)!}</td>
				<#if x.valid_flag == "1">
				<td style="text-align:left;">有效</td>
				<#else>
				<td style="text-align:left;">无效</td>
				</#if>
				<td style="text-align:left;">
					&nbsp;&nbsp;<a href="m/role/deleteUser?id=${x.id}" onclick='return confirm("你确定删除${(x.real_name)!}?");'>删除</a>
					&nbsp;&nbsp;<a href="m/role/toModifyUser?id=${x.id}">修改</a>
					&nbsp;&nbsp;<a href="m/role/userAddRole?id=${x.id}">增加权限</a>
				</td>
			</tr>
			</#list>
		</tbody>
	</table>
	<#include "/WEB-INF/pages/common/_paginate.html" />
	<@paginate currentPage=userPage.pageNumber totalPage=userPage.totalPage actionUrl="/m/role/userList/" />
</div>
</@layout>