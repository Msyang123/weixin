<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/masterProductManage/productSave" class="form-horizontal" role="form" method="post">
    			
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="user_name">登录名</label>
        <div class="col-sm-9">
        <input type="hidden" id="id" name="user_id" 
            value="${(sysUser.id)!}" class="col-xs-10 col-sm-5" />
            <input type="text" id="user_name" name="sysUser.user_name" Readonly
            value="${(sysUser.user_name)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">手机号码</label>
        <div class="col-sm-9">
            <input type="text" id="mobile" name="sysUser.mobile" 
            value="${sysUser.mobile!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">真实姓名</label>
        <div class="col-sm-9">
            <input type="text" id="real_name" name="sysUser.real_name" 
            value="${sysUser.real_name!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">用户类型 </label>
        <div class="col-sm-9">
            <select id="sysUser" name="sysUser.user_kind">
            	<#if sysUser.user_kind??>
	        		<option value="1" <#if sysUser.user_kind=='1'>selected</#if>>超级管理</option>
	        		<option value="2" <#if sysUser.user_kind=='2'>selected</#if>>一般管理员</option>
	        		<option value="3" <#if sysUser.user_kind=='3'>selected</#if>>用户</option>
	        		<option value="4" <#if sysUser.user_kind=='4'>selected</#if>>代理商</option>
        		<#else>
        			<option value="1" >超级管理</option>
	        		<option value="2" >一般管理员</option>
	        		<option value="3" >用户</option>
	        		<option value="4" >代理商</option>
        		</#if>
        	</select>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">角色选择</label>
        <div class="col-sm-9">
           <select id="sysRole" name="role_id">
           	 <#if sysRole??>
	           	 <#if sysUser.role_id ??>
	           	 	<#list sysRole as item>
	           	 	 <option value="${item.role_id!}" <#if (sysUser.role_id!)==(item.role_id!)>selected</#if>>${item.role_name!}</option>
	           	  	</#list>
	           	 <#else>
	           	 	<#list sysRole as item>
	           	 	 <option value="${item.role_id!}">${item.role_name!}</option>
	           	  	</#list>
	           	 </#if>
           	 </#if>
           </select>
        </div>
    </div>
    
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
        	<button class="btn " type="button" onclick="history.go(-1);">
              		  取消
            </button>
            <button class="btn btn-info ml12" type="button" onclick="whenSubmit();">
               		 提交
            </button>
        </div>
    </div>
    
</form>

</@layout>

<script>

	//提交表单
function whenSubmit(){
 var formData= $('.form-horizontal').serializeArray();
 console.log(formData);
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/m/savePower",
        data:formData,
        success: function(data) {
        	alert(data.message);
        	window.location.href="${CONTEXT_PATH}/m/initUserRoleList";
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

</script>