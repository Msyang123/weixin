<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
   
   <div class="col-xs-12 wigtbox-head">
		<form id="submitForm" class="form-inline">
	        <div class="pull-right">
				<button class="btn btn-warning btn-sm" type="button" onclick="addRole();">
				     <i class="fa fa-plus bigger-110"></i> 添加
				</button>
				<button class="btn btn-info btn-sm" type="button" onclick="editRole();">
				     <i class="fa fa-edit bigger-110"></i> 编辑
				</button>
				<button class="btn btn-danger btn-sm" type="button"  onclick="deleteRole();">
				    <i class="fa fa-trash bigger-110"></i> 删除
				</button>
		    </div>  
	    </form>   
    </div>
   
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        	<table id="grid-table"></table>
        	<div id="grid-pager"></div>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->

    <!--select tree-->
    <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
		<ul id="category" class="ztree" style="margin-top: -12px;width: 180px; margin-left: -18px;"></ul>
	</div>
</@layout>

<script type="text/javascript">
function addRole(){
    window.location.href='${CONTEXT_PATH}/m/initSave';
}

 function editRole(){
	 var selr = jQuery("#grid-table").getGridParam('selrow');
	 if(!selr){
	        alert("请先选择一行数据再编辑");
	        return;
	    }
	window.location.href="${CONTEXT_PATH}/m/initSave?id="+selr;
} 
function deleteRole(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再删除！");
        return;
    }
    $.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/m/deleteRole?id="+selr,
        success: function(data) {
        	alert(data.message);
        	jQuery("#grid-table").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
       // postData:{'isNutritionPage':false},
        url:"${CONTEXT_PATH}/m/roleList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','角色名称','描述'],
        colModel:[
        	{name:'id',index:'id', width:80, sorttype:"int", editable: false},
            {name:'roll_name',index:'roll_name',width:150,editable: false},
            {name:'roll_desc',index:'roll_desc',width:150, editable:false}
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
        caption: "角色管理列表",
        autowidth: true
    });

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