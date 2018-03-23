<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
		<div class="col-xs-12 wigtbox-head">
			<form id="submitForm">
				<div class="pull-left">
					订单状态
							<select  id="presentStatus" name="presentStatus">
								<option value="-1">全部</option>
								<option value="1">未付款</option>
								<option value="2">支付中</option>
								<option value="3">已付款</option>
								<option value="4">已查收</option>
								<option value="0">已失效</option>
							</select>
					创建时间	
					<input type="text" id="presentDateBegin" name="presentDateBegin" value='${presentDateBegin}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			    	至
			    	<input type="text" id="presentDateEnd" name="presentDateEnd" value='${presentDateEnd}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			    </div>
			    <div class="pull-right">
				    <button class="btn btn-info btn-sm" type="button" onclick="jQuery('#grid-table')
				            .setGridParam({postData:{'presentStatus':$('#presentStatus').val(),'presentDateBegin':$('#presentDateBegin').val(),'presentDateEnd':$('#presentDateEnd').val()}})
				            .trigger('reloadGrid');">
				        <i class="fa fa-search bigger-110"></i>查询
				    </button>
				    <button class="btn btn-warning btn-sm" type="button" onclick="exportExcel();" target="_blank"><i class="fa fa-sign-out"></i>导出</a>
				</div>
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
	encodeURI("${CONTEXT_PATH}/orderManage/exportPresent?formData="+JSON.stringify($("form").serializeArray())
			+"&colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
			+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
	);
}

jQuery(function($) {
    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/orderManage/presentList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['赠送人','被增送人','赠送时间', '赠送状态', '应付金额','赠送附言','优惠金额'],
        colModel:[
            {name:'present_user',index:'present_user', width:200, sorttype:"int", editable: false},
            {name:'target_user',index:'target_user',width:200, editable:false},
            {name:'present_time',index:'present_time', width:150,editable: false},
            {name:'present_status',index:'present_status', width:150,editable: false,
            	edittype:"select",editoptions:
            	{value:"1:未付款;2:支付中;3:已付款;4:已查收;0:已失效"}},
            {name:'need_pay',index:'need_pay', width:150,editable: false},
            {name:'present_msg',index:'present_msg', width:150,editable: false},
            {name:'discount',index:'discount', width:90,editable: false}
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
        caption: "赠送订单管理",
        autowidth: true
    });
    initNavGrid(grid_selector,pager_selector);
});
</script>