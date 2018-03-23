<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head">
    <div class="pull-right">
		<button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/masterCarouselManage/initEditMCarousel?type_id=1'"/>
		    <i class="fa fa-plus bigger-110"></i> 添加
		</button>
		<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit('#grid-table-index')">
		    <i class="fa fa-edit bigger-110"></i> 编辑
		</button>
	</div>
</div>

<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table-index"></table>
    <div id="grid-pager-index"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<div class="col-xs-12 wigtbox-head">
    <div class="pull-right">
		<button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/masterCarouselManage/initEditMCarousel?type_id=2'"/>
		    <i class="fa fa-plus bigger-110"></i> 添加
		</button>
		<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit('#grid-table-shop')">
		    <i class="fa fa-edit bigger-110"></i> 编辑
		</button>
	</div>
</div>
<div class="col-xs-12">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table-shop"></table>
    <div id="grid-pager-shop"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

</@layout>

<script type="text/javascript">
var $path_base = "/";

//显示图片渲染函数
function photoFormatter(cellvalue, options, rowdata){
	 return "<img src='"+rowdata[7]+"' style='width:40px;height:40px;' />";
}

//编辑某一条数据
function getSelRowToEdit(grid_table_name){
    var selr = jQuery(grid_table_name).getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
    var rowData = $(grid_table_name).jqGrid("getRowData",selr);//行数据
	var type_id= rowData.type_id;//type_id的值

    window.location.href="${CONTEXT_PATH}/masterCarouselManage/initEditMCarousel?id="+selr+"&type_id="+type_id;
}

function style_delete_form(form) {
    var buttons = form.next().find('.EditButton .fm-button');
    buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
    buttons.eq(0).addClass('btn-danger').prepend('<i class="icon-trash"></i>');
    buttons.eq(1).prepend('<i class="icon-remove"></i>')
}

function beforeDeleteCallback(e) {
    var form = $(e[0]);
    if(form.data('styled')) return false;

    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
    style_delete_form(form);

    form.data('styled', true);
}

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

jQuery(function($) {
    var grid_selector = "#grid-table-index";
    var pager_selector = "#grid-pager-index";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterCarouselManage/getMCarouselJson?type_id=1",
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
            {name:'save_string',index:'save_string', width:90, editable: false,formatter: photoFormatter}
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

        editurl: "${CONTEXT_PATH}/masterCarouselManage/delCarousel",//delete
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "首页轮播图管理",
        autowidth: true
    });
});

jQuery(function($) {
    var grid_selector = "#grid-table-shop";
    var pager_selector = "#grid-pager-shop";

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        url:"${CONTEXT_PATH}/masterCarouselManage/getMCarouselJson?type_id=2",
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
                    //editformbutton:true, editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
                }
            },
            {name:'id',index:'id', width:90, editable: false},
            {name:'url',index:'url', width:90, editable: false},
            {name:'img_id',index:'img_id', width:90, editable: false},
            {name:'order_id',index:'order_id', width:90, editable: false},
            {name:'type_id',index:'type_id', width:90, editable: false},
            {name:'carousel_name',index:'carousel_name', width:90, editable: false},
            {name:'save_string',index:'save_string', width:90, editable: false,formatter: photoFormatter}
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
        editurl: "${CONTEXT_PATH}/masterCarouselManage/delCarousel",//delete
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "鲜果师商城轮播图管理",
        autowidth: true
    });
});
</script>