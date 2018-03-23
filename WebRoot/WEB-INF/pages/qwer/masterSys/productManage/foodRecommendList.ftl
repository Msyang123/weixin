<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
  <div class="col-xs-12 wigtbox-head">
	<form id="submitForm" class="form-inline">
        <div class="pull-right">
			<button class="btn btn-warning btn-sm" type="button"  
			onclick="window.location.href='${CONTEXT_PATH}/masterProductManage/initRecommendSave'"/>
			     <i class="fa fa-plus bigger-110"></i> 添加
			</button>
			<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
			    <i class="fa fa-edit bigger-110"></i> 编辑
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDeleteRecommend();">
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
</@layout>


<script type="text/javascript">
var $path_base = "/";
function getSelRowToDeleteRecommend(){
	var selr = $("#grid-table").getGridParam("selrow");

    if(!selr){
        alert("请先选择一行数据再删除");
        return;
    }
    
    if(confirm("您确认要删除该条食鲜推荐吗？")){
    $.ajax({
    	url:"${CONTEXT_PATH}/masterProductManage/delRecommend?activity_id="+selr,
    	success:function(data){
    		jQuery("#grid-table").trigger("reloadGrid");
    		alert("成功");
    	}
    });
    }
}

function getSelRowToEdit(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
    window.location.href="${CONTEXT_PATH}/masterProductManage/initRecommendSave?id="+selr;
}

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        postData:{'isNutritionPage':false},
        url:"${CONTEXT_PATH}/masterProductManage/recommentList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','主题名称','商品数量','有效状态'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'main_title',index:'main_title',width:150,editable: false},
            {name:'num',index:'num',width:90, editable:false},
            {name:'yxbz',index:'yxbz', width:150,editable: false}
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
            }, 0);
        },
        caption: "食鲜推荐列表",
        autowidth: true
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
});
</script>