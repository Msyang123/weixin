<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >

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
	var $path_base = "/";
	
	jQuery(function($) {
	    var grid_selector = "#grid-table";
	    var pager_selector = "#grid-pager";
	
	    jQuery(grid_selector).jqGrid({
	        //data: grid_data,
	        url:"${CONTEXT_PATH}/activityManage/teamBuyScaleListJson?activityProductId=${id}",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['操作','编号','商品名称','拼团人数','拼团价格','每日开团数','用户限制次数','是否有效','顺序','团购商品编号'],
	        colModel:[
	            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
	                formatter:'actions',
	                formatoptions:{
	                    keys:false,
	                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
	                    //editformbutton:true, editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
	                }
	            },
	            {name:'teamBuyScale.id',index:'id', width:90, editable: true},
	            {name:'product_name',index:'product_name',width:90, editable: false},
	            {name:'teamBuyScale.person_count',index:'person_count',width:90, editable:true},
	            {name:'teamBuyScale.activity_price_reduce',index:'activity_price_reduce', width:150,editable:true},
	            {name:'teamBuyScale.team_open_times',index:'team_open_times',width:90, editable:true},
	            {name:'teamBuyScale.team_buy_times',index:'team_buy_times',width:90, editable:true},
	            {name:'teamBuyScale.yxbz',index:'yxbz',width:90, editable:true,
	            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}},
	            {name:'teamBuyScale.dis_order',index:'dis_order',width:90, editable:true},
	            {name:'teamBuyScale.activity_product_id',index:'activity_product_id', width:90,editable: true}
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
	
	        editurl: "${CONTEXT_PATH}/activityManage/editTeamBuyScale?activityProductId=${id}",
	        caption: "团购规模管理",
	        autowidth: true
	    });
	    
	    initNavGrid(grid_selector,pager_selector);
	});
</script>