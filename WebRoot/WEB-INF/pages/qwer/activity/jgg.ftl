<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-left">
		    <input class="form-control" id="main_title" name="main_title" type="text" placeholder="活动主标题"/>
		    <select id="yxbz" name="yxbz" class="form-control">
		    	<option value="">全部</option>
		    	<option value="Y">有效</option>
		    	<option value="N">无效</option>
		    </select>
	    </div>
	    
	    <div class="pull-right">
		    <button class="btn btn-primary btn-sm" type="button" 
		    onclick="jQuery('#grid-table').setGridParam({postData:{'main_title':$('#main_title').val(),'yxbz':$('#yxbz').val()}}).trigger('reloadGrid');">
		        <i class="fa fa-search bigger-110"></i> 搜索     
		    </button>
		    <button class="btn btn-warning btn-sm" type="button"  
		    	onclick="window.location.href='${CONTEXT_PATH}/activityManage/editJggActivity'"/>
			    <i class="fa fa-plus bigger-110"></i> 添加
			</button>
			<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
			    <i class="fa fa-edit bigger-110"></i> 编辑
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDelete();">
			    <i class="fa fa-close bigger-110"></i> 删除
			</button>
		</div>
	</form>
</div>
<div class="row pbb80">
	<div class="col-xs-12">
	    <!-- PAGE CONTENT BEGINS -->
	    <table id="grid-table"></table>
	    <div id="grid-pager"></div>
	    <!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div><!-- /.row -->

<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form>
		<div class="pull-left">
			<input id="phoneNum" name="phoneNum" class="form-control" placeholder="请输入用户手机号码"/>
			<select  id="activityId" name="activityId"  class="form-control">
				<option value="">选择你想查找的活动</option>
				<#list yxActivitys as item>
					<option value="${item.id}">${item.main_title}</option>
				</#list>
			</select>
		</div>
		<div class="pull-right">
        	<button class="btn btn-primary btn-sm" type="button"
                onclick="jQuery('#grid-user-award-table')
                .setGridParam({postData:{'phoneNum':$('#phoneNum').val(),
                'activityId':$('#activityId').val()}})
                .trigger('reloadGrid');">
            	<i class="fa fa-search bigger-110"></i> 搜索     
        	</button>
        </div>	
	</form> 
</div>	    
<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        <table id="grid-user-award-table"></table>

        <div id="grid-user-award-pager"></div>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->

<script>
    function getSelRowToEdit(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再编辑");
            return;
        }
        	window.location.href="${CONTEXT_PATH}/activityManage/editJggActivity?id="+selr;
    }
    
    function getSelRowToDelete(){
    	var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再删除");
            return;
        }
        if(confirm("确定删除此活动?")){
        	window.location.href="${CONTEXT_PATH}/activityManage/jggDelete?id="+selr;
        }	
    }
</script>
</@layout>


<script type="text/javascript">
var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";
    
	var grid_user_award_selector = "#grid-user-award-table";
    var pager_user_award_selector = "#grid-user-award-pager";
    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/activityManage/getJggActivityListJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','编号','活动开始时间','活动结束时间','活动名称', '链接地址','有效标志'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,

                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                    //editformbutton:true, editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
                }
            },
            {name:'id',index:'id', width:90, editable: true},
            {name:'yxq_q',index:'yxq_q',width:90, editable:true,sorttype:"date"},
            {name:'main_title',index:'main_title',width:90, editable:true,sorttype:"date"},
            {name:'main_title',index:'main_title',width:90, editable:true},
            {name:'url',index:'url', width:90,editable: true},
            {name:'yxbz',index:'yxbz', width:90,editable: false,edittype:"select",
            editoptions:{value:"'Y':有效;'N':无效"},
            formatter:function(cellvalue, options, rowObject){if(cellvalue=='Y'){return "有效"}else{return "无效"}}
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
        //multikey: "ctrlKey",
        multiboxonly: true,

        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },

        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "抽奖活动管理",
        autowidth: true

    });
    jQuery(grid_user_award_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/activityManage/userAwardRecordListJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['手机号码','奖品类型','奖品名称','中奖时间','归属活动名','领取状态'],
        colModel:[
            {name:'phone_num',index:'phone_num',width:90, editable:true,sorttype:"date"},
            {name:'award_type',index:'award_type',width:90, editable:true,sorttype:"date"},
            {name:'award_name',index:'award_name',width:90, editable:true},
            {name:'award_time',index:'award_time', width:90,editable: true},
            {name:'main_title',index:'main_title', width:90,editable: true},
            {name:'is_get',index:'is_get', width:90,editable: false,edittype:"select",
            editoptions:{value:"'0':未领取;'1':已经领取"},
            formatter:function(cellvalue, options, rowObject){if(cellvalue=='0'){return "未领取"}else{return "已经领取"}}
        	}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_user_award_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        multiselect: true,
        multiboxonly: true,

        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },

        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "用户中奖记录查询",
        autowidth: true
    });
    initNavGrid(grid_selector,pager_selector);
	initNavGrid(grid_user_award_selector,pager_user_award_selector);
});
</script>