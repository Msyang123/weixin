<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
	   <div class="col-xs-12 wigtbox-head">
			<form id="submitForm" class="form-inline">
			   <div class="pull-left">
					  <div class="form-group">
						    <input id="productName" name="productName" class="form-control" placeholder="商品名称"/>
						    <div class="input-group">
							    <input id="categoryId" type="text" readonly value="" placeholder="商品分类"/>
						        <span class="input-group-btn"><button class="btn btn-info btn-sm" id="menuBtn" onclick="showMenu(); return false;">选择</button></span>
								<input id="categoryIdValue" type="hidden" value="" />
							</div>
							   商品状态
							<select  id="productStatus" name="productStatus" class="form-control">
								<option value="01">正常</option>
								<option value="02">禁采</option>
								<option value="03">停止下单</option>
							</select>
					        <button class="btn btn-primary btn-sm" type="button" 
					         onclick="jQuery('#grid-table')
					                .setGridParam({postData:{'categoryIdValue':$('#categoryIdValue').val(),
					                'productStatus':$('#productStatus').val(),
					                'productName':$('#productName').val()}})
					                .trigger('reloadGrid');">
					            <i class="fa fa-search bigger-110"></i>查询
					        </button>
				       </div>
		        </div>
		        <div class="pull-right">
					<button class="btn btn-warning btn-sm" type="button"  
					onclick="window.location.href='${CONTEXT_PATH}/masterProductManage/initSave'"/>
					     <i class="fa fa-plus bigger-110"></i> 添加
					</button>
					<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
					    <i class="fa fa-edit bigger-110"></i> 编辑
					</button>
					<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDeleteProduct();">
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

function getSelRowToDeleteProduct(){
	var selr = $("#grid-table").getGridParam("selrow");
    if(!selr){
        alert("请先选择一行数据再删除");
        return;
    }
    if(confirm("您确认要删除该商品吗？")){
        $.ajax({
        	url:"${CONTEXT_PATH}/masterProductManage/delProduct?id="+selr,
        	success:function(data){
        		alert(data.msg);
        		$("#grid-table").trigger("reloadGrid");
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
    window.location.href="${CONTEXT_PATH}/masterProductManage/initSave?id="+selr;
}
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
jQuery(function($) {
	$.fn.zTree.init($("#category"), setting);
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        postData:{'isNutritionPage':false},
        url:"${CONTEXT_PATH}/masterProductManage/productList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false},
            {name:'save_string',index:'save_string', width:150,editable: false,formatter: photoFormatter},
            {name:'unit_name',index:'unit_name', width:150,editable: false}
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
        caption: "商品管理",
        autowidth: true
    });
	//显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
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
});
</script>