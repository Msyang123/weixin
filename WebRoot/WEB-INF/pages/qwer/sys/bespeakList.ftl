<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
        
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
        url:"${CONTEXT_PATH}/bespeak/searchBespeaks",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','预约人姓名','预约人年龄', '预约人职业', '会见对象姓名','预约时间'],
        colModel:[
            {name:'id',index:'id', width:60, sorttype:"int", editable: true},
            {name:'submit_name',index:'username',width:90, editable:true},
            {name:'age',index:'app_id', width:70,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'job',index:'app_key',width:150,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'meet',index:'valid_flag', width:150,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'date',index:'date',width:90, editable:true, sorttype:"date",unformat: pickDate}
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
        caption: "预约管理",
        autowidth: true
    });
    initNavGrid(grid_selector,pager_selector);
});
</script>