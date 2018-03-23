<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head">
    <div class="pull-right">
		<button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/activityManage/initEditMCarousel'">
		    <i class="fa fa-plus bigger-110"></i> 添加
		</button>
		<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
		    <i class="fa fa-edit bigger-110"></i> 编辑
		</button>
	</div>
</div>

<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<div class="col-xs-12 wigtbox-head">
    <div class="pull-right">
    	<button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/activityManage/editRechargeBanner'">
		    <i class="fa fa-plus bigger-110"></i> 添加
		</button>
		<button class="btn btn-info btn-sm" type="button" onclick="editRechargeBanner();">
		    <i class="fa fa-edit bigger-110"></i> 编辑
		</button>
	</div>
</div>

<div class="col-xs-12">
    <table id="grid-table1"></table>
    <div id="grid-pager1"></div>
</div>

<script>
function getSelRowToEdit(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
    window.location.href="${CONTEXT_PATH}/activityManage/initEditMCarousel?id="+selr;
}

function editRechargeBanner(){
    var selr = jQuery("#grid-table1").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
    window.location.href="${CONTEXT_PATH}/activityManage/editRechargeBanner?id="+selr;
}
</script>
</@layout>

<script type="text/javascript">
$(function() {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    $(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getMCarouselJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','编号','链接地址','图片编号', '排序序号','类型','轮播图名称','图片预览'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                }
            },
            {name:'id',index:'id', width:90, editable: false},
            {name:'url',index:'url', width:90, editable: false},
            {name:'img_id',index:'img_id', width:90, editable: false},
            {name:'order_id',index:'order_id', width:90, editable: false},
            {name:'type_id',index:'type_id', width:90, editable: false},
            {name:'carousel_name',index:'carousel_name', width:90, editable: false},
            {name:'save_string',index:'save_string', width:90, editable: false,
            	formatter:function(value,grid,rows,state){
                	return "<img src='"+value+"' style='width:40px;height:40px;' onerror='imgLoad(this)' />";
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
        editurl: "${CONTEXT_PATH}/activityManage/delCarousel",
        caption: "轮播图管理",
        autowidth: true
    });

    var grid_selector1 = "#grid-table1";
    var pager_selector1 = "#grid-pager1";

    jQuery(grid_selector1).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getRechargeMCarouselJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','编号','链接地址','图片编号', '排序序号','类型','轮播图名称','图片预览'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                }
            },
            {name:'id',index:'id', width:90, editable: false},
            {name:'url',index:'url', width:90, editable: false},
            {name:'img_id',index:'img_id', width:90, editable: false},
            {name:'order_id',index:'order_id', width:90, editable: false},
            {name:'type_id',index:'type_id', width:90, editable: false},
            {name:'carousel_name',index:'carousel_name', width:90, editable: false},
            {name:'save_string',index:'save_string', width:90, editable: false,
                formatter:function(value,grid,rows,state){
                	return "<img src='"+value+"' style='width:40px;height:40px;' onerror='imgLoad(this)' />";
                }
            }
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector1,
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
        editurl: "${CONTEXT_PATH}/activityManage/delCarousel",
        caption: "充值页面banner管理",
        autowidth: true
    });

    initNavGrid(grid_selector,pager_selector);
});
</script>