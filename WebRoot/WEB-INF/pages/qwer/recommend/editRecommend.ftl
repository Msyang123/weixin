<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css","${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"]>

<form action="${CONTEXT_PATH}/recommendManage/saveRecommend" class="form-horizontal" role="form" method="post">
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="type_id">类型 </label>

        <div class="col-sm-9">
        	<select id="type_id" name="type_id" class="col-xs-10 col-sm-5">
			  	  <option  value="1" >主推商品</option>
				  <option  value="2" >热门爆款</option>
				  <option  value="3" >热门爆款(客显屏)</option>
				  <option  value="4" >猜你喜欢(客显屏)</option>
				  <option  value="5" >详情页推荐</option>
			</select>
        </div>
    </div>
</form>

<button class="btn btn-info" type="button"  onclick="addToRecommend();">
    <i class="icon-ok bigger-110"></i>
   批量添加到推荐商品
</button>
<form>
	          商品分类<input id="categoryId" type="text" readonly value="" />
	          <a id="menuBtn" href="#" onclick="showMenu(); return false;">选择</a>
				<input id="categoryIdValue" type="hidden" value="" />
		商品状态
		<select  id="productStatus" name="productStatus">
			<option value="01">正常</option>
			<option value="02">禁采</option>
			<option value="03">停止下单</option>
		</select>
		名称
		<input id="productName" name="productName" />
        <button class="btn btn-info" type="button"
                onclick="jQuery('#grid-select_product-table')
                .setGridParam({postData:{'categoryIdValue':$('#categoryIdValue').val(),
                'productStatus':$('#productStatus').val(),
                'productName':$('#productName').val()}})
                .trigger('reloadGrid');">
            <i class="icon-ok bigger-110"></i>
            		查询
        </button>
</form>  
   
<div class="row">
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
		<table id="grid-select_product-table"></table>
        <div id="grid-select_product-pager"></div>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->

<!--select tree-->
<div id="menuContent" class="menuContent" style="display:none; position: absolute;">
	<ul id="category" class="ztree" style="margin-top:0; width:160px;"></ul>
</div>
</@layout>

<script>
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
	
	//选择商品规格到活动中    
	function addToRecommend(){
		var ids=$("#grid-select_product-table").jqGrid("getGridParam","selarrrow");
		console.log(ids);
	    window.location.href="${CONTEXT_PATH}/recommendManage/saveRecommend?type_id="+$('#type_id').val()
	    +"&ids="+ids.join();
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
	var grid_select_product_table = "#grid-select_product-table";
	var grid_select_product_pager = "#grid-select_product-pager";
	jQuery(grid_select_product_table).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/activityManage/productFList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位','规格数量',
        		'单位','规格','价格','特价','赠送商品','有效'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false},
            {name:'save_string',index:'save_string', width:150,editable: false,formatter: productAddPhotoFormatter},
            {name:'base_unitname',index:'base_unitname', width:150,editable: false},
            {name:'product_amount',index:'product_amount',width:150,editable: true},
            {name:'product_unit',index:'product_unit', width:150,editable:true,
            	edittype:"select",editoptions:{value:"${unitList}"}},
            {name:'standard',index:'standard', width:150,editable: true},
            {name:'price',index:'price', width:150,editable: true},
            {name:'special_price',index:'special_price', width:150,editable: true},
            {name:'is_gift',index:'is_gift', width:150,editable: true,
            	edittype:"select",editoptions:{value:"1:是;0:否"}},
            {name:'is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : grid_select_product_pager,
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
                styleCheckbox(table);

                updateActionIcons(table);
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },
        caption: "商品待添加列表",
        autowidth: true
    });
	
    //显示图片渲染函数
    function productAddPhotoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
    
    initNavGrid(grid_select_product_table,grid_select_product_pager);
});
	</script>