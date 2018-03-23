<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
	   <div class="col-xs-12 wigtbox-head">
			<form id="submitForm" class="form-inline">
			   <div class="pull-left">
					  <div class="form-group">
						    <input id="articleName" name="articleName" class="form-control mr12" placeholder="文章名称"/>
						     	文章分类
						    <div class="input-group mr12">
						        <select  id="article_category" name="article_category" class="form-control">
									<option value="营养菜单">营养菜单</option>
									<option value="食鲜常识">食鲜常识</option>
									<option value="经验分享">经验分享</option>
								</select>
							</div>
							  文章状态
							<select  id="articleStatus" name="articleStatus" class="form-control mr12">
								<option value="2">全部</option>
								<option value="0">正常</option>
								<option value="1">下架</option>
							</select>
					        <button class="btn btn-primary btn-sm" type="button" 
					         onclick="jQuery('#grid-table')
					                .setGridParam({postData:{'article_category':$('#article_category').val(),
					                'articleStatus':$('#articleStatus').val(),
					                'articleName':$('#articleName').val()}})
					                .trigger('reloadGrid');">
					            <i class="fa fa-search bigger-110"></i>查询
					        </button>
				       </div>
		        </div>
		        <div class="pull-right">
					<button class="btn btn-warning btn-sm" type="button"  
					onclick="relateArticle()"/>
					     <i class="fa fa-plus bigger-110"></i> 关联
				    </button>
			    </div>  
		    </form>   
	    </div>
	   
        <div class="col-xs-12 pbb80">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table"></table>
            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
        
        <div class="text-right col-xs-12 mt10">
			<button class="btn btn-danger btn-sm" type="button"  onclick="unRelateArticle();">
			    <i class="fa fa-remove bigger-110"></i> 取消关联
			</button>
  		</div>  
  		
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table-relatedArticle"></table>
            <div id="grid-pager-relatedArticle"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
 
        <!--select tree-->
        <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
			<ul id="category" class="ztree" style="margin-top: -12px;width: 180px; margin-left: -18px;"></ul>
		</div>
</@layout>


<script type="text/javascript">
function relateArticle(){
	var sxzw_ids = $("#grid-table-relatedArticle").jqGrid("getRowData");//食鲜之味
    if(sxzw_ids.length>=5){
    	alert("食鲜之味文章最多为5篇");
        return;
    }
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一篇的文章再关联");
        return;
    }
    
    $.ajax({
		type: 'get',
		url: "${CONTEXT_PATH}/masterArticleManage/relateSXZWAjax?article_id="+selr,
		success: function(data){
			$("#grid-table").trigger("reloadGrid");
			$("#grid-table-relatedArticle").trigger("reloadGrid");
			alert(data.msg);
		},
	});
}

function unRelateArticle(){
    var selr = jQuery("#grid-table-relatedArticle").getGridParam('selrow');
    if(!selr){
        alert("请先选择一篇食鲜之味的文章再取消关联");
        return;
    }
   $.ajax({
		type: 'get',
		url: "${CONTEXT_PATH}/masterArticleManage/removeSXZWAjax?article_id="+selr,
		success: function(data){
			$("#grid-table").trigger("reloadGrid");
			$("#grid-table-relatedArticle").trigger("reloadGrid");
			alert(data.msg);
		},
	});
}

var $path_base = "/";
var setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url:"${CONTEXT_PATH}/productManage/category",
		autoParam:["id", "name=n", "level=lv"],
		otherParam:{"otherParam":""},
		dataFilter: filter
	},
	callback: {
		onClick: onClick
	}
};
function onClick(e, treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj("category"),
	nodes = zTree.getSelectedNodes(),
	v = "";
	nodes.sort(function compare(a,b){return a.id-b.id;});
	for (var i=0, l=nodes.length; i<l; i++) {
		v += nodes[i].name + ",";
	}
	if (v.length > 0 ) v = v.substring(0, v.length-1);
	var cityObj = $("#categoryId");
	cityObj.attr("value", v);
	$("#categoryIdValue").val(treeNode.id);
}

function showMenu() {
	var categoryId = $("#categoryId");
	var categoryIdOffset = categoryId.offset();
	alert(categoryIdOffset);
	$("#menuContent").css({left:categoryIdOffset.left-180 + "px", 
	top:categoryIdOffset.top-60 + "px",
	zIndex:999}).slideDown("fast");

	$("body").bind("mousedown", onBodyDown);
}
function hideMenu() {
	$("#menuContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
		hideMenu();
	}
}
function filter(treeId, parentNode, childNodes) {
		if (!childNodes) return null;
		for (var i=0, l=childNodes.length; i<l; i++) {
			childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
		}
		return childNodes;
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
	$.fn.zTree.init($("#category"), setting);
	
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterArticleManage/unSXZWArticleListAjax",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','文章名称','文章分类','投稿人','文章状态' ,'url'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'title',index:'title',width:150,editable: false},
            {name:'category_name',index:'category_name',width:90, editable:false},
            {name:'contribution_penson',index:'contribution_penson', width:70,editable: false},
            {name:'status',index:'status', width:150,editable: false,formatter:function(cellvalue,options,rowObject){
            							var statusStr;
					            		switch(cellvalue){
					            		case 0:
					            			statusStr = "正常";
					            			break;
					            		case 1:
					            			statusStr = "下架";
					            			break;
					            		default:
					                		statusStr = "N/A";
					            			break;
					            		}
            							return statusStr;}},
            {name:'url',index:'url', width:150,editable: false}
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
        caption: "未关联文章列表",
        autowidth: true
    });
});


jQuery(function($) {
	$.fn.zTree.init($("#category"), setting);
    var grid_selector_relatedArticle = "#grid-table-relatedArticle";
    var pager_selector_relatedArticle = "#grid-pager-relatedArticle";
    
    jQuery(grid_selector_relatedArticle).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterArticleManage/sXZWArticleListAjax",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','文章名称','文章分类','投稿人','文章状态' ,'url'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'title',index:'title',width:150,editable: false},
            {name:'category_name',index:'category_name',width:90, editable:false},
            {name:'contribution_penson',index:'contribution_penson', width:70,editable: false},
            {name:'status',index:'status', width:150,editable: false,
            		formatter:function(cellvalue,options,rowObject){
            							var statusStr;
					            		switch(cellvalue){
					            		case 0:
					            			statusStr = "正常";
					            			break;
					            		case 1:
					            			statusStr = "下架";
					            			break;
					            		default:
					                		statusStr = "N/A";
					            			break;
					            		}
            							return statusStr;}},
            {name:'url',index:'url', width:150,editable: false}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_relatedArticle,
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
        caption: "已关联文章列表",
        autowidth: true
    });
});
</script>