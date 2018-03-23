<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<script type="text/javascript" >
	
	
    function check(){
		
    	var uname = document.getElementById("userName").value;
    	
    	var reg = /^[a-zA-Z]\w{1,15}$/;
    	
    	if (!reg.test(uname))
    		{
    		document.getElementById("unameMsg").innerHTML = "*请输入有效的用户名!长度为2 ~ 16位！";
    		$("#unameMsg").css('color','red');
    			return false;
    		}
    	$.ajax({ // 一个Ajax过程
    		type : "post", // 以post方式与后台沟通
    		url : "/m/role/checkUserName",
    		dataType : 'json',// 
    		data : {username:uname},
    		success : function(json) {
    			document.getElementById("unameMsg").innerHTML = json.error;
    			$('#unameMsg').css('color','red');
    		},
    		error : function(json) {
    			alert("系统错误，请重试");
    		}
    	})
    	var password = document.getElementById("password").value;
		var reg2 = /[a-zA-Z0-9]\w{5,15}/;
		if (!reg2.test(password))
			{
			document.getElementById("pwdMsg").innerHTML = "*请输入有效密码!长度为6 ~ 16位！";
    		$("#pwdMsg").css('color','red');
    		return false;
			}else{
    		document.getElementById("pwdMsg").innerHTML = "";
    	}
    }
</script>

<form class="form-horizontal" action="m/role/addUser" method="post" onsubmit="return check();">
<input id="userId" type="hidden" name="user.id" />
<label for="userName" style="width:100px">用户名</label><span id="unameMsg"></span>
<input id="userName" type="text" name="user.user_name" placeholder="请输入用户名" class="form-control" onblur="check();"/><br>
<label for="password" style="width:100px">密码</label><span id="pwdMsg"></span>
<input id="password" type="password" name="user.pwd" placeholder="请输入密码" class="form-control" onblur="check();"/><br>
<label for="address" style="width:100px">地址</label>
<input id="address" type="text" name="user.address" class="form-control"/><br>
<label for="realname" style="width:100px">真实姓名</label>
<input id="realname" type="text" name="user.real_name" class="form-control"/><br>
<label for="address" style="width:100px">用户角色</label>

<select name="role_id" class="form-control">
<#list rolelist as role>
<option value="${role.id}">${role.role_desc}</option>
</#list>
</select>
<br>
<label for="userkind" style="width:100px">用户类型</label>
<select id="userkind" name="user.user_kind" class="form-control">
	<#if session['sessionUser'].user_kind == "1">
    <option value="2">管理员</option>
    <option value="3">普通用户</option>
    <#else>
    <option value="3">普通用户</option>
    </#if>
</select>
<br>
<div class="clearfix form-actions">
	<button class="btn btn-info" type="submit"><i class="icon-ok bigger-110"></i>新增</button>
	<button class="btn" type="reset"><i class="icon-undo bigger-110"></i>重置</button>
</div>
</form>

</@layout>