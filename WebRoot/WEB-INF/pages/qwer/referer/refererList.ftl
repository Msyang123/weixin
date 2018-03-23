<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
		<div class="col-xs-12 wigtbox-head">
            <div class="pull-right">
               <button class="btn btn-info btn-sm" type="button" onclick="exportExcel();" target="_blank"><i class="fa fa-sign-out"></i>导出</button>
            </div>  
        </div>
        
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table"></table>
            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
</@layout>


<script type="text/javascript">
var $path_base = "/";

var grid_selector = "#grid-table";
var pager_selector = "#grid-pager";
function exportExcel(){
	window.location.href=
	encodeURI("${CONTEXT_PATH}/refererManage/export"
			+"?colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
			+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
	);
}

jQuery(function($) {
    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/refererManage/getRefererRecordJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','浏览地址','创建时间', '用户编号', '当前路径','订单编号','订单类型','客户昵称','客户手机'],
        colModel:[
            {name:'id',index:'id', width:200, sorttype:"int", editable: false},
            {name:'referer',index:'referer',width:200, editable:false},
            {name:'create_time',index:'create_time', width:150,editable: false},
            {name:'user_id',index:'user_id',width:150,editable: false},
            {name:'current_url',index:'current_url', width:150,editable: false},
            {name:'order_id',index:'order_id', width:150,editable: false},
            {name:'order_type',index:'order_type', width:90,editable: false,edittype:"select",editoptions:{value:"zs:赠送;gm:购买"}},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'phone_num',index:'phone_num', width:150,editable: false}
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
        caption: "浏览记录管理",
        autowidth: true
    });
    
    initNavGrid(grid_selector,pager_selector);
});
</script>