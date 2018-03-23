<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<script type="text/javascript">
	function checkOldPwd(){
		var oldPwd = $("#oldPwd").val();
		var oriPwd = $("#pwd").val();
		if(oldPwd==null || oldPwd==""){
			$("#oldMsg").text("请输入旧密码！").css('color','red');
		}  else {
		 $("#oldMsg").text("");
			$.ajax({
				type : "post",
				url : "/m/role/checkPwd",
				dataType : 'json',
				data : {old : oldPwd},
				success : function(json){
					var jsons = json.error;
					if("" != jsons){
						document.getElementById("oldMsg").innerHTML = jsons;
						$("#oldMsg").css('color','red');
					}
				},
				error : function(json){
					alert("系统错误，请重试");
				}
			}) 
		}	
	}
	
	function checkNewPwd(){
		var password = document.getElementById("newPwd").value;
		var reg2 = /[a-zA-Z0-9]\w{5,15}/;
		if (!reg2.test(password))
			{
			document.getElementById("newMsg").innerHTML = "*请输入有效密码!长度为6 ~ 16位！";
    		$("#newMsg").css('color','red');
			}else{
    		document.getElementById("newMsg").innerHTML = "";
    	}
	}
	function checkRePwd(){
		var newPwd = $("#newPwd").val();
		var rePwd = $("#rePwd").val();
		if(rePwd != newPwd){
			$("#reMsg").text("两次输入的密码不一致！").css('color','red');
		} else {
			$("#reMsg").text("");
			$("#pwd").val(rePwd);
		}
	}
	
	function checkAll(){
		 var oldMsg = $("#oldMsg").text();
		 var newMsg = $("#newMsg").text();
		 var reMsg = $("#reMsg").text();
		 if("" != oldMsg || "" != newMsg || "" != reMsg){
			 return false;
		 } else {
			 return true;
		 }
	}
</script>
	<form action="m/role/saveNewPwd" method="post" onsubmit="return checkAll();">
	<!-- 隐藏正确的原始密码 -->
		<input type="hidden" name="id" id="id" value="${user.id}"/>
		<input type="hidden" name="pwd" id="pwd" value="${user.pwd}"/>
		<label style="width:100px">原始密码：</label><span id="oldMsg"></span>
		<input type="password" name="oldPwd" id="oldPwd" class="form-control" onblur="checkOldPwd();"/><br>
		<label style="width:100px">设置新密码：</label><span id="newMsg"></span>
		<input type="password" id="newPwd" class="form-control" onblur="checkNewPwd();"/><br>
		<label style="width:100px">重复新密码：</label><span id="reMsg"></span>
		<input type="password" id="rePwd" class="form-control" onblur="checkRePwd();"/><br>
		<input type="submit" value="提交" class="btn btn-primary"/>
	</form>
</@layout>