<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >

<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-left">
		    <input class="form-control" id="main_title" name="main_title" type="text" placeholder="活动主标题"/>
		    <select id="yxbz" name="yxbz" class="form-control">
		    	<option value="">活动状态</option>
		    	<option value="Y">有效</option>
		    	<option value="N">无效</option>
		    </select>
		    <select id="activity_type" name="activity_type" class="form-control">
	            <option value="" >活动类型</option>
	            <option value="1" >抢购活动</option>
        		<option value="2" >底部活动</option>
        		<option value="3" >特殊活动</option>
        		<option value="4" >其他活动</option>
        		<option value="5" >优惠券活动</option>
        		<option value="6" >返券活动</option>
        		<option value="7" >满立减活动</option>
        		<option value="8" >排名活动</option>
        		<option value="9" >banner活动</option>
        		<option value="10" >团购活动</option>
        		<option value="11" >首单立送鲜果币活动</option>
        		<option value="12" >手动发券活动</option>
        		<option value="13" >九宫格活动</option>
        		<option value="14" >首页滚动公告通知</option>
        		<option value="17" >H5页发券活动</option>
        		<option value="18" >种子购活动</option>
        		<option value="19" >优惠券兑换码活动</option>
		    </select>
		    <button class="btn btn-info btn-sm btn-clear" type="button">
				<i class="fa fa-remove bigger-110"></i>     
			</button>
		    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table">
		        <i class="fa fa-search bigger-110"></i> 搜索     
		    </button>
	    </div>
	    
	    <div class="pull-right">	    
		    <button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/activityManage/initEdit'">
			    <i class="fa fa-plus bigger-110"></i> 添加
			</button>
			<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
			    <i class="fa fa-edit bigger-110"></i> 编辑
			</button>
			<button class="btn btn-success btn-sm" type="button"  onclick="getSelRowToSetting();">
			    <i class="fa fa-cog bigger-110"></i> 设置
			</button>
		</div>
	</form>
</div>

<div class="col-xs-12">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<script>
    function getSelRowToEdit(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再编辑");
            return;
        }
        window.location.href="${CONTEXT_PATH}/activityManage/initEdit?id="+selr;
    }
    
    function getSelRowToSetting(){
    	var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再设置");
            return;
        }
        window.location.href="${CONTEXT_PATH}/activityManage/initSetting?id="+selr;
    }
</script>
</@layout>

<script type="text/javascript">
$(function() {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    $(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getActivitysJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','编号','活动主标题','活动副标题', '链接地址','有效标志','活动类型'],
        colModel:[
            {name:'myac',index:'', fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                }
            },
            {name:'id',index:'id', editable: true},
            {name:'main_title',index:'main_title', editable:true, sorttype:"date"},
            {name:'subheading',index:'subheading',editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'url',index:'url',editable: true},
            {name:'yxbz',index:'yxbz',editable: false,
                formatter:function(cellvalue,options,rows){
                    //console.log(cellvalue);
                    if(cellvalue=="Y"){
                    	return "有效";
                    }else if(cellvalue=="N"){
                    	return "无效";
                    }else{
                    	return "N/A";
                    }
                }
            },
            {name:'activity_type',index:'activity_type',editable: false,
            	formatter:function(cellvalue,options,rows){
            		return switchType(cellvalue);
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
                enableTooltips(table);
            }, 0);
        },
        editurl: "${CONTEXT_PATH}/activityManage/e",
        caption: "活动管理",
        autowidth: true,
        sortname:'id',
        sortorder:'desc'
    });

    initNavGrid(grid_selector,pager_selector);
 
});
</script>