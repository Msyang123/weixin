<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>
<!--product_f table-->
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table"></table>
            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
<!--product_f table-->
</@layout>

<script>
jQuery(function($) {
	
	var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/indexSetting/indexSettingList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:["操作",'编号','名称','内容'],
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
            {name:'is.id',index:'id',width:90, editable:true},
            {name:'is.index_name',index:'index_name',width:90, editable:true},
            {name:'is.index_value',index:'index_value', width:150,editable: true}
        ],

        viewrecords : true,
        rowNum:5,
        rowList:[5,10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        multiselect: true,
        multiboxonly: true,
		editurl: "${CONTEXT_PATH}/indexSetting/editIndexSetting",
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },
        caption: "设置管理",
        autowidth: true
    });
	
    initNavGrid(grid_selector,pager_selector);
});
</script>