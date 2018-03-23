<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/masterProductManage/recommentSave" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="mActivity.id" id="mActivity_id" value="${(mActivity.id)!}"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="product_name">主题名称</label>
        <div class="col-sm-9">
            <input type="text" id="product_name" name="mActivity.main_title" 
            value="${(mActivity.main_title)!}"
             placeholder="名称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">banner</label>
        <div class="col-sm-9">
        	<input type="hidden" name="image.id" value="${(image.id)!}"/>
	        <input type="text" id="url" name="image.save_string" value="${(image.save_string)!}" />
			<input type="button" id="image" value="选择图片" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">banner预览 </label>
        <div class="col-sm-9">
	         <img id="url2" style="width:50%;" src="${(image.save_string)!}"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">URL</label>
        <div class="col-sm-9">
	        <input type="text" id="url" name="mActivity.url" 
            value="${(mActivity.url)!}"
             placeholder="名称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">有效状态 </label>
        <div class="col-sm-9">
            <select id="product_status" name="mActivity.yxbz">
            	<#if mActivity.yxbz??>
	       			<option value="Y" <#if mActivity.yxbz=='Y'>selected</#if>>有效</option>
	        		<option value="N" <#if mActivity.yxbz=='N'>selected</#if>>无效</option>
        		<#else>
	        		<option value="Y" >有效</option>
	        		<option value="N" >无效</option>
        		</#if>
        	</select>
        </div>
    </div>
	
    <div class="clearfix form-actions">
        <div class="text-center">
            <button class="btn btn-info btn-sm" type="button" onclick="whenSubmit();">
               	 提交
            </button>
            <button class="btn btn-sm ml12" type="button" onclick="history.go(-1);">
              	  取消
            </button>
        </div>
    </div>
</form>

<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form id="submitForm1">
	   <div class="pull-left">
		  <div class="form-group">
			    <input id="productName" name="productName" class="form-control" placeholder="商品名称"/>
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
			<button class="btn btn-warning btn-sm" type="button"  onclick="relevance()">
			    关联
			</button>
		</div>
	</form>
</div>
<!--product_f table-->
	<div class="row pbb80">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table"></table>
            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
<!--product_f table-->

<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form id="submitForm1">
	    <div class="pull-right">	    	   
			<button class="btn btn-danger btn-sm" type="button"  onclick="canselRelevance()">
			    取消关联
			</button>
		</div>
	</form>
</div>

<!--product_f table-->
	<div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table1"></table>
            <div id="grid-pager1"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
<!--product_f table-->


</@layout>

<script>
//编辑器和单独图片上传
var editor;
var K=window.KindEditor;
KindEditor.ready(function (K) {
	//这里是kindeditor编辑器的基本初始化配置
	var editor = K.editor({
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=foodRecomment',
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=foodRecomment',
			allowFileManager : true,
		});
		//给按钮添加click事件
		K('#image').click(function() {
			editor.loadPlugin('image', function() {
				//图片弹窗的基本参数配置
				editor.plugin.imageDialog({
					imageUrl : K('#url').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
					//点击弹窗内”确定“按钮所执行的逻辑
					clickFn : function(url, title, width, height, border, align) {
						K('#url').val(url);//获取图片地址
						K('#url2').attr("src",url);
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
});

//取消关联
function canselRelevance(){
	var ids=$("#grid-table1").jqGrid("getGridParam","selarrrow");
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterProductManage/cancleRecommendProduct?ids="+ids.join()+"&activity_id="+$('#mActivity_id').val(),
        success: function(data) {
        	jQuery("#grid-table").trigger("reloadGrid");
        	jQuery("#grid-table1").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

//关联商品
function relevance(){
	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterProductManage/recommendProductRelate?type=15&ids="+ids.join()+"&activity_id="+$("#mActivity_id").val(),
        success: function(data) {
        	jQuery("#grid-table").trigger("reloadGrid");
        	jQuery("#grid-table1").trigger("reloadGrid");
        },
        error: function(request) {
            //alert("Connection error");
        },
    });
}

//提交表单
function whenSubmit(){
	var html=$(".ke-edit-iframe").contents().find("body").html(); 
    $(".form-horizontal").submit();
}
    
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
	var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterProductManage/recommendProductList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:["操作",'编号','产品编码','条码','规格数量',  '单位','规格','价格','特价','赠送商品','有效','二维码'],
        colNames:['编号','商品状态','商品名称','商品分类','首图', '基础单位','规格数量','单位','规格','价格','特价','二维码','是否有效'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false},
            {name:'save_string',index:'save_string', width:150,editable: false,formatter: photoFormatter1},
            {name:'unit_name',index:'unit_name', width:150,editable: false},
            {name:'product_amount',index:'product_amount', width:150,editable: false},
            {name:'product_unit',index:'product_unit', width:150,editable: false},
            {name:'standard',index:'standard', width:150,editable: false},
            {name:'price',index:'price', width:150,editable: false},
            {name:'special_price',index:'special_price', width:150,editable: false},
            {name:'id',index:'id', width:150,editable: true,formatter:erweimaPhotoFormatter1},
            {name:'is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
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
		editurl: "${CONTEXT_PATH}/productManage/productFSave",
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
    function photoFormatter1(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
  
  //显示二维码图片渲染函数
    function erweimaPhotoFormatter1(cellvalue, options, rowdata){
    	var _url=encodeURIComponent("${app_domain}/fruitDetial?pf_id="+rowdata[1]);
    	 return "<img src='${CONTEXT_PATH}/activityManage/printTwoBarCode?code="+_url+"' style='width:40px;height:40px;' />";
    }
});


jQuery(function($) {
	var grid_selector = "#grid-table1";
    var pager_selector = "#grid-pager1";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        postData:{'isRecommend':true,activity_id:$("#mActivity_id").val()},
        url:"${CONTEXT_PATH}/masterProductManage/recommendProductList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','商品状态','商品名称','商品分类','首图', '基础单位','规格数量','单位','规格','价格','特价','二维码','是否有效'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false},
            {name:'save_string',index:'save_string', width:150,editable: false,formatter: photoFormatter},
            {name:'unit_name',index:'unit_name', width:150,editable: false},
            {name:'product_amount',index:'product_amount', width:150,editable: false},
            {name:'product_unit',index:'product_unit', width:150,editable: false},
            {name:'standard',index:'standard', width:150,editable: false},
            {name:'price',index:'price', width:150,editable: false},
            {name:'special_price',index:'special_price', width:150,editable: false},
            {name:'id',index:'id', width:150,editable: true,formatter:erweimaPhotoFormatter},
            {name:'is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
        ],
        viewrecords : true,
        rowNum:5,
        rowList:[5,10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        //toppager: true,

        multiselect: true,
        //multikey: "ctrlKey",
        multiboxonly: true,
		editurl: "${CONTEXT_PATH}/productManage/productFSave",
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "已关联商品列表",
        autowidth: true
    });

  //显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
  
  //显示二维码图片渲染函数
    function erweimaPhotoFormatter(cellvalue, options, rowdata){
    	var _url=encodeURIComponent("${app_domain}/fruitDetial?pf_id="+rowdata[1]);
    	 return "<img src='${CONTEXT_PATH}/activityManage/printTwoBarCode?code="+_url+"' style='width:40px;height:40px;' />";
    }
});
</script>