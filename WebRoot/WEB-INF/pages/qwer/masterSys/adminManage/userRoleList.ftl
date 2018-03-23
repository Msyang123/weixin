<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
   <div class="col-xs-12 wigtbox-head">
		<form id="submitForm" class="form-inline">
	        <div class="pull-right">
				<button class="btn btn-info btn-sm" type="button" onclick="userRevelRole();">
				     <i class="fa fa-cogs bigger-110"></i> 用户角色关联
				</button>
				<!--<button class="btn btn-info btn-sm" type="button"  onclick="deleteRole();">
				    <i class="fa fa-close bigger-110"></i> 删除
				</button>-->
		    </div>  
	    </form>   
    </div>
   
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        	<table id="grid-table"></table>
        	<div id="grid-pager"></div>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->

    <!--select tree-->
    <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
		<ul id="category" class="ztree" style="margin-top: -12px;width: 180px; margin-left: -18px;"></ul>
	</div>
</@layout>

<script type="text/javascript">
function userRevelRole(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
	 if(!selr){
	        alert("请先选择一行数据再操作！");
	        return;
	    }
	window.location.href="${CONTEXT_PATH}/m/initEidtSysUser?id="+selr;
}

function deleteRole(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再删除！");
        return;
    }
    $.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/m/deleteRole?id="+selr,
        success: function(data) {
        	alert(data.message);
        	jQuery("#grid-table").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/m/userRoleList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','登录账号','用户名','角色','用户类型'],
        colModel:[
        	{name:'id',index:'id', width:80, sorttype:"int", editable: false},
            {name:'real_name',index:'real_name',width:150,editable: false},
            {name:'user_name',index:'user_name',width:150,editable: false},
            {name:'role_name',index:'role_name',width:150,editable: false},
            {name:'user_kind',index:'user_kind',width:150, editable:false,
                formatter:function(cellvalue, options, rowdata){
                	if(cellvalue==1){
            		  	return "超级管理";
            		  }else if(cellvalue==2){	
            			  return "一般管理员";
            		  }else if(cellvalue==3){
            			  return "用户";
            		  }else if(cellvalue==4){
            			  return "代理商";
            		  }
                }
            }
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        multiselect: true,
        multiboxonly: true,
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "用户角色关联列表",
        autowidth: true
    });

    initNavGrid(grid_selector,pager_selector);
    
});
</script>