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
        colNames:['微信交易编号','充值金额','赠送金额', '支付时间', '用户昵称'],
        colModel:[
            {name:'transaction_id',index:'transaction_id', width:200, sorttype:"int", editable: false},
            {name:'total_fee',index:'total_fee',width:200, editable:false},
            {name:'give_fee',index:'give_fee', width:150,editable: false},
            {name:'time_end',index:'time_end',width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        //toppager: true,
        multiselect: true,
        //multikey: "ctrlKey",
        multiboxonly: true,

        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "充值管理",
        autowidth: true
    });

    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }

    //navButtons
    jQuery(grid_selector).jqGrid('navGrid',pager_selector,
            { 	//navbar options
                edit: false,
                editicon : 'icon-pencil blue',
                add: false,
                addicon : 'icon-plus-sign purple',
                del: false,
                delicon : 'icon-trash red',
                search: false,
                searchicon : 'icon-search orange',
                refresh: true,
                refreshicon : 'icon-refresh green',
                view: true,
                viewicon : 'icon-zoom-in grey'
            }
	)
    //replace icons with FontAwesome icons like above
    function updatePagerIcons(table) {
        var replacement =
         {
            'ui-icon-seek-first' : 'fa fa-angle-double-left bigger-140',
            'ui-icon-seek-prev' : 'fa fa-angle-left bigger-140',
            'ui-icon-seek-next' : 'fa fa-angle-right bigger-140',
            'ui-icon-seek-end' : 'fa fa-angle-double-right bigger-140'
        };
        $('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
            var icon = $(this);
            var $class = $.trim(icon.attr('class').replace('ui-icon', ''));

            if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
        })
    }

});
</script>