<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<form  role="form" action="m/editMenu" method="post">
			<div class="form-group">
				<input class="form-control" type="hidden" id="id" name="menu.id" value="${(menu.id)!}"/>
				<label for="upname">上级菜单</label> 
				<select id="upname" class="form-control" name="menu.pid">
					<#list menus as item >
					  <option value="${item.id}" <#if ((menu.pid)!0)==item.id>selected</#if> >${item.menu_name}</option>
					</#list>
				</select>
				 <label for="name" >菜单名称</label><input class="form-control" id="name" name="menu.menu_name" value="${(menu.menu_name)!}" />
				 <label for="href" >菜单链接</label><input class="form-control" id="href" name="menu.href" value="${(menu.href)!}" />
				 <label for="order" >显示顺序</label><input class="form-control" id="order" name="menu.dis_order" value="${(menu.dis_order)!}" />
				 <label for="ico_path" >图标</label><input class="form-control" id="ico_path" name="menu.ico_path" value="${(menu.ico_path)!}" />
				 <label for="menuType">有效标志</label>
				 <select id="menuType" class="form-control" name="menu.menu_type" value="${(menu.menu_type)!}">
				  <option value="1" selected="selected">菜单</option>
				  <option value="2">权限</option>
				</select>
				
				 <label for="flag">有效标志</label>
				 <select id="flag" class="form-control" name="menu.valid_flag" value="${(menu.valid_flag)!}">
				  <option value="1" selected="selected">有效</option>
				  <option value="2">无效</option>
				</select>
			</div>
			
		<input type="submit" class="btn btn-primary" onclick="whenSubmit()" value="提交"></input>
	</form>
				
</@layout>

<script type="text/javaScript">
	function whenSubmit(){
		var nameBoo = checkNull($("#name").val());
		var hrefBoo = checkNull($("#href").val());
		var orderBoo = checkNull($("#order").val());
		var icoBoo = checkNull($("#ico_path").val());
		var TypeBoo = checkNull($("#menuType").val());
		var flagBoo = checkNull($("#flag").val());
		var boo = (nameBoo&&hrefBoo&&orderBoo&&icoBoo&&TypeBoo&&flagBoo);
		if(!boo){
			alert("不能有空值");
			return;
		}else{
			$("#content").val($(".ke-edit-iframe").contents().find("body").html());
	        $(".form-horizontal").submit();
		}
		
	}
	
	function checkNull(value){
		if(value==null||value==""){
			return false;
		}else{
			return true;
		}
	}
</script>
