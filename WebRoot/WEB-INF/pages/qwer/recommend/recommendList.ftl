<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head">
	<div class="pull-right">
		<button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/recommendManage/initSaveRecommend'"/>
		    <i class="fa fa-plus bigger-110"></i> 添加
		</button>
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

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/recommendManage/getRecommendRecordJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','编号','类型','排序序号','商品名称','商品状态','数量','计量单位','规格','价格','特价','是否有效','图片地址'],
            	
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                    editformbutton:true, 
                    editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
                }
            },
            {name:'id',index:'id', width:90, editable:false},
            {name:'type_id',index:'type_id',width:90, editable:false,formatter:dataFormatter},
            {name:'order_id',index:'order_id',width:90, editable:true},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'product_status',index:'product_status',width:90, editable:false},
            {name:'product_amount',index:'product_amount',width:90, editable:false},
            {name:'product_unit',index:'product_unit',width:90, editable:false},
            {name:'standard',index:'standard',width:90, editable:false},
            {name:'price',index:'price',width:90, editable:false},
            {name:'special_price',index:'special_price',width:90, editable:false},
            {name:'is_vlid',index:'is_vlid',width:90, editable:false},
            {name:'recomm_img',index:'recomm_img',width:90, editable:false}
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

        editurl: "${CONTEXT_PATH}/recommendManage/delRecommend",//delete data /recommendManage/delRecommend
        caption: "推荐商品管理",
        autowidth: true
    });
    
    initNavGrid(grid_selector,pager_selector);
    
	function dataFormatter(cellvalue, options, rowdata){
		if(rowdata[2]==1){
			return "主推商品";
		}else if(rowdata[2]==2){
		    return "热门爆款";
		}else if(rowdata[2]==3){
			return "主推商品(客显屏)";
		}else if(rowdata[2]==4){
		    return "猜你喜欢(客显屏)";
		}else{
		    return "详情页推荐";
		}
    }
});
</script>