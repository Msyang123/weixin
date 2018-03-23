<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >

<div class="col-xs-12 wigtbox-head form-inline">
     <div class="pull-left"></div>
	 <div class="pull-right">
		<button class="btn btn-warning btn-sm btn-add" type="button" onclick="window.location.href='${CONTEXT_PATH}/m/initMenu'">
		     <i class="fa fa-plus bigger-110"></i> 添加
		</button>
		<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
		    <i class="fa fa-edit bigger-110"></i> 编辑
		</button>
		<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDelete();">
		    <i class="fa fa-trash bigger-110"></i> 删除
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
function getSelRowToEdit(){
	var id=$('#grid-table').jqGrid('getGridParam','selrow');
	if(id==null){
		alert("请选中一行进行编辑");
		return;
	}
	window.location.href="${CONTEXT_PATH}/m/initMenu?id="+id;
}

function getSelRowToDelete(){
	alert("菜单删除功能慎用");
	var id=$('#grid-table').jqGrid('getGridParam','selrow');
	if(id==null){
		alert("请选中一行进行删除！");
		return;
	}
	var rowData=$('#grid-table').jqGrid('getRowData',id);
	
	//if(rowData.parent_name=='无上级菜单'){
	//	alert("该菜单下可能有子菜单");
	//}
	
	if(confirm("你确定要删除吗？")){
	alert("kaishi ");
		$.ajax({
			url:"${CONTEXT_PATH}/m/deleteMenu?id="+id,
			success:function(data){
				alert(data.success);
				$('#grid-table').trigger("reloadGrid");
			},
			error: function(data) {
            alert("连接错误，请重试");
        	},
		});
	}else{
		return;
	}
}

jQuery(function($) {
    var user_grid_selector = "#grid-table";
    var user_pager_selector = "#grid-pager";

    jQuery(user_grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        url:"${CONTEXT_PATH}/m/menuListAjax",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编辑','编号','菜单名称','上级编号','上级菜单名','链接','有效标志','图标','排序','类型'],
        colModel:[
        	{name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                    //editformbutton:true, editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
                }
            },
        	{name:'id',index:'id', width:10, sorttype:"int", editable: false},
        	{name:'menu_name',index:'menu_name', width:10, sorttype:"String", editable: false},
        	{name:'pid',index:'pid', width:10, sorttype:"int", editable: false},
        	{name:'parent_name',index:'parent_name', width:10, sorttype:"String", editable: false},
        	{name:'href',index:'href', width:50, sorttype:"String", editable: false},
        	{name:'valid_flag',index:'valid_flag', width:10, sorttype:"int", editable: false},
        	{name:'ico_path',index:'ico_path', width:30, sorttype:"String", editable: false},
            {name:'dis_order',index:'dis_order',width:10,editable: false},
            {name:'menu_type',index:'menu_type',width:10, editable:false}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : user_pager_selector,
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
        caption: "系统菜单栏",
        autowidth: true
    });
});

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

function beforeDeleteCallback(e) {
    var form = $(e[0]);
    if(form.data('styled')) return false;

    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
    style_delete_form(form);

    form.data('styled', true);
}
</script>