<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
		<div class="col-xs-12 wigtbox-head">
			<form id="submitForm" style="margin-bottom:5px">
				创建时间	
				<input type="text" id="rechargeDateBegin" name="rechargeDateBegin" value='${rechargeDateBegin}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
            	至
            	<input type="text" id="rechargeDateEnd" name="rechargeDateEnd" value='${rechargeDateEnd}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	            <button class="btn btn-info btn-sm" type="button"
	                    onclick="jQuery('#grid-table')
	                    .setGridParam({postData:{'rechargeDateBegin':$('#rechargeDateBegin').val(),'rechargeDateEnd':$('#rechargeDateEnd').val()}})
	                    .trigger('reloadGrid');">
	                  <i class="fa fa-search"></i>查询
	            </button>
	            <button class="btn btn-warning btn-sm" type="button" onclick="exportExcel();" target="_blank"><i class="fa fa-sign-out"></i>导出</a></button>
	        </form>  
        </div>
           
        <div class="row">
            <div class="col-xs-12">
                <!-- PAGE CONTENT BEGINS -->
                <table id="grid-table"></table>
                <div id="grid-pager"></div>
                <!-- PAGE CONTENT ENDS -->
            </div><!-- /.col -->
        </div><!-- /.row -->
</@layout>

<script type="text/javascript">
var $path_base = "/";

var grid_selector = "#grid-table";
var pager_selector = "#grid-pager";
function exportExcel(){
	window.location.href=
	encodeURI("${CONTEXT_PATH}/orderManage/exportRecharge?formData="+JSON.stringify($("form").serializeArray())
			+"&colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
			+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
	);
}

jQuery(function($) {
    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/orderManage/rechargeList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['微信交易编号','充值金额','赠送金额', '支付时间', '用户昵称','用户手机号码'],
        colModel:[
            {name:'transaction_id',index:'transaction_id', width:200, sorttype:"int", editable: false},
            {name:'total_fee',index:'total_fee',width:100, editable:false},
            {name:'give_fee',index:'give_fee', width:100,editable: false},
            {name:'time_end',index:'time_end',width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'phone_num',index:'phone_num', width:100,editable: false}
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
        caption: "充值管理",
        autowidth: true
    });
    
    initNavGrid(grid_selector,pager_selector);
});
</script>