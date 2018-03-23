<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/masterArticleManage/editArticleAjax" class="form-horizontal" role="form" method="post" id="article_form">
    <input type="hidden" name="article_id" id="article_id" value="${(article.id)!}"/>
    <input type="hidden" name="article.article_content" id="article_content"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="type">文章分类 </label>
        <div class="col-sm-9">
            <select id="category_name" name="category_name">
            	<#if (article.category_name)??>
	        		<option value="营养菜单" <#if (article.category_name)=="营养菜单">selected</#if>>营养菜单</option>
	        		<option value="食鲜常识" <#if (article.category_name)=="食鲜常识">selected</#if>>食鲜常识</option>
	        		<option value="经验分享" <#if (article.category_name)=="经验分享">selected</#if>>经验分享</option>
        		<#else>
        			<option value="营养菜单"  >营养菜单</option>
	        		<option value="食鲜常识"  >食鲜常识</option>
	        		<option value="经验分享"  >经验分享</option>
        		</#if>
        	</select>        
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="title">文章名称 </label>
        <div class="col-sm-9">
            <input type="text" id="title" name="title" value="${(article.title)!}" placeholder="文章名称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="edit_penson">编辑</label>
        <div class="col-sm-9">
            <input type="text" id="edit_penson" name="edit_penson" placeholder="编辑" value="${(article.edit_penson)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
    	<input type="hidden" name="master_id" id="master_id" value="${(article.master_id)!}"></input>
        <label class="col-sm-3 control-label no-padding-right mr12" for="contribution_penson">投稿人</label>
        <div class="col-sm-2 input-group">
	        <input type="text" class="form-control" name="contribution_penson" id="contribution_penson" value="${(article.contribution_penson)!}" />
	        <span class="input-group-btn">
	           <button type="button" class="btn btn-info btn-sm" onclick="$('#select-dialog').modal();" >
	           <i class="fa fa-search"></i></button>
	        </span>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">banner </label>
        <div class="col-sm-9">
        	<input type="hidden" name="image.id" value=""/>
	        <input type="text" id="url" name="head_image" value="${(article.head_image)!}" />
			<input type="button" id="image" value="选择图片" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">图片预览 </label>
        <div class="col-sm-9">
	            <img id="url2" style="width:50%;" src="${(article.head_image)!}"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right mr12" for="article_intro">内容简介 </label>
        <textarea id="article_intro" name="article_intro" style="width:700px;height:150px;" >${(article.article_intro)!}</textarea>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right mr12" for="url">url链接 </label>
        <textarea id="url" name="url" style="width:700px;height:150px;" >${(article.url)!}</textarea>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right mr12" for="editor">详细内容</label>
        <textarea id="editor" style="width:700px;height:300px;" name="article.article_content"></textarea>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">推荐商品标题 </label>
        <div class="col-sm-9">
            <input type="text" id="recommend_product_name" name="recommend_product_name" placeholder="推荐商品标题" value="${(article.recommend_product_name)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="status">内容状态： </label>
		<div class="col-sm-9">
            <select id="status" name="status">
            	<#if (article.status)??>
	        		<option value=0 <#if (article.status)==0>selected</#if>>下架</option>
	        		<option value=1 <#if (article.status)==1>selected</#if>>正常</option>
        		<#else>
        			<option value=0  >正常</option>
	        		<option value=1  >下架</option>
        		</#if>
        	</select>        
        </div>
    </div>
  
    <div class="col-sm-12 col-md-12 col-lg-12 text-center form-actions">
        <button class="btn btn-info" type="button" onclick="whenSubmit();">
            <i class="icon-ok bigger-110"></i> 提交
        </button>
        <button class="btn" type="button" onclick="history.go(-1);">
            <i class="icon-undo bigger-110"></i>  取消
        </button>
    </div>
</form>

<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-left">
		    <input class="form-control" id="productName" name="productName" type="text" placeholder="商品名称"/>
		      	 商品状态
				<select  id="productStatus" name="productStatus" class="form-control">
					<option value="01">正常</option>
					<option value="02">禁采</option>
					<option value="03">停止下单</option>
				</select>
		    <button class="form-control" type="button" onclick="jQuery('#grid-table-product')
                .setGridParam({postData:{'productStatus':$('#productStatus').val(),
	                'productName':$('#productName').val()}})
	                .trigger('reloadGrid');">
		        <i class="fa fa-search bigger-110"></i> 搜索    
		    </button> 
	    </div>
	    
	    <div class="pull-right">	    	   
		    <button class="btn btn-warning btn-sm" type="button"  onclick="relevance()"/>
			    关联
			</button>
		</div>
	</form>
</div>

<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table-product"></table>
    <div id="grid-pager-product"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->


<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form id="submitForm1">
	    <div class="pull-right">	    	   
			<button class="btn btn-danger btn-sm" type="button"  onclick="canselRelevance()">
			    取消关联
			</button>
		</div>
	</form>
</div>
<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table-relate"></table>
    <div id="grid-pager-relate"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<div class="modal fade" id="detail-dialog" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                 <h4 class="modal-title pull-left">文章详情</h4>
	                 <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				     </button>
				     <div class="clearfix"></div>
	            </div>
	            <!-- PAGE CONTENT BEGINS -->
			    <table id="grid-table-relate"></table>
			    <div id="grid-pager-relate"></div>
			    <!-- PAGE CONTENT ENDS -->
	        </div>
	    </div>
</div><!--/End detail-dialog-->

<div class="modal fade" id="select-dialog" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content" style="width:700px">
	            <div class="modal-header">
	                 <h4 class="modal-title pull-left">选择鲜果师</h4>
	                 <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				     </button>
				     <div class="clearfix"></div>
	            </div>
	            
	            <div class="modal-body z-hidden">
		             <form id="search_form" class="form-inline mb10 z-hidden" method="Post">
					    <div class="pull-left mb20">
					        <input type="text" class="form-control" name="masterName" id="masterName" placeholder="鲜果师姓名"/>
					        
						    <button class="btn btn-primary btn-sm" type="button" id="btn-modal-search" onclick="jQuery('#grid-table-master')
                .setGridParam({postData:{'masterName':$('#masterName').val()}}).trigger('reloadGrid');">
						        <i class="fa fa-search bigger-110"></i> 搜索     
						    </button>
					    </div>
					 </form>
					 
            	     <div class="col-xs-12 nopd-lr normal-grid">
					    <table id="grid-table-master"></table>
					    <div id="grid-pager-master"></div>
					</div>
				</div>
				
	            <br/>
		        <div class="modal-footer">
	                <button type="button" class="btn btn-info btn-sm btn-ok modal-center" data-dismiss="modal" onclick="choseMaster();">确认</button>
		        </div>
	        </div>
	    </div>
</div>



</@layout>

<script type="text/javascript">
	//编辑器和单独图片上传
	var editor;
	var K=window.KindEditor;
	<#if (article.title)?? >
		KindEditor.ready(function (K) {
		//这里是kindeditor编辑器的基本初始化配置
		
		editor = K.create('textarea[id="editor"]', {
			resizeType: 1,
			fullscreenMode: 0, //是否全屏显示
			designMode: 1,
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=product&idName='+'article',//$('#title').val()
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=product&idName='+$('#title').val(),
			allowPreviewEmoticons: false,
			allowImageUpload: true,
			allowFileManager: true
		});
		editor.html('${article.article_content!}');
		//这里是监听按钮点击事件 然后在初始化点击按钮弹窗上传图片的基本配置
		K('#image').click(function () {
			editor.loadPlugin('image', function () {
				editor.plugin.imageDialog({
					imageUrl: K('#url').val(),
					clickFn: function (url, title, width, height, border, align) {
						K('#url').val(url);//获取图片地址
						K('#url2').attr("src",url);
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
	});
	<#else>
		K('#title').blur(function (){
			if($('#title').val()==''){
				alert("请先填写文章标题");
				return;
			}
			 editor = K.create('textarea[id="editor"]', {
				resizeType: 1,
				fullscreenMode: 0, //是否全屏显示
				designMode: 1,
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=product&idName='+'article',//$('#title').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=product&idName='+$('#title').val(),
				allowPreviewEmoticons: false,
				allowImageUpload: true,
				allowFileManager: true
			});
		});	
		
		K('#image').click(function () {
			if($('#title').val()==''){
				alert("请先填写文章标题");
				return;
			}
			editor.loadPlugin('image', function () {
				editor.plugin.imageDialog({
					imageUrl: K('#url').val(),
					clickFn: function (url, title, width, height, border, align) {
						K('#url').val(url);//获取图片地址
						K('#url2').attr("src",url);
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
	</#if>

	function whenSubmit(){
		var html=$(".ke-edit-iframe").contents().find("body").html();
		$("#article_content").val(html);
    	$(".form-horizontal").submit();
    	//var _form = $('#article_form');
	}
	
	function choseMaster(){
		var selr = $("#grid-table-master").getGridParam('selrow');
		var rowData = $('#grid-table-master').jqGrid('getRowData',selr);
		$("#master_id").val(selr);
		$("#contribution_penson").val(rowData.master_name);
		$("master-modal").hide();
	}
	
//取消关联
function canselRelevance(){
	var product_ids=$("#grid-table-relate").jqGrid("getGridParam","selarrrow");
	if(product_ids.length==0){
		alert("请至少选择一种商品取消关联");
		return;
	}
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterArticleManage/removeRelationAjax?article_id="+$("#article_id").val()+"&product_ids="+product_ids.join(),
        success: function(data) {
        	alert("取消成功");
        	jQuery("#grid-table-product").trigger("reloadGrid");
        	jQuery("#grid-table-relate").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

//关联商品
function relevance(){
	var ids=$("#grid-table-product").jqGrid("getGridParam","selarrrow");//准备关联的商品
	if(ids.length==0){
		alert("请至少选择一种商品进行关联。");
		return;
	}
	var relate_ids = $("#grid-table-relate").jqGrid("getRowData");//已经关联的商品
	if(ids.length+relate_ids.length>5){
		alert("最多只能关联5种商品，您已关联"+relate_ids.length+"种。");
		return;
	}
	var article_id = $("#article_id").val();
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterArticleManage/relateProductAjax?article_id="+article_id+"&product_ids="+ids.join(),
        success: function(data) {
        	alert("关联成功");
        	jQuery("#grid-table-product").trigger("reloadGrid");
        	jQuery("#grid-table-relate").trigger("reloadGrid");
        },
        error: function(request) {
            //alert("Connection error");
        },
    });
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
var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table-product";
    var pager_selector = "#grid-pager-product";
	var ids=$("#grid-table-relate").jqGrid("getGridParam","selarrrow");
	//alert(ids);return;
    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        postData:{'article_id':$("#article_id").val()},
        url:"${CONTEXT_PATH}/masterArticleManage/UnReleProductList",
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
        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "待关联商品列表",
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

jQuery(function($) {
    var grid_selector = "#grid-table-relate";
    var pager_selector = "#grid-pager-relate";

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,?activity_type=5
        postData:{'article_id':$('#article_id').val()},
        url:"${CONTEXT_PATH}/masterArticleManage/releProductList",
        mtype: "post",
        datatype: "json",
        height: '100%',
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

        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "已关联商品列表",
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
    var grid_selector = "#grid-table-master";
    var pager_selector = "#grid-pager-master";

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        postData:{'isNutritionPage':false},
        url:"${CONTEXT_PATH}/masterArticleManage/masterList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','姓名','头像','鲜果师状态'],
        colModel:[
        	{name:'id',index:'id',sorttype:"int", editable: false},
            {name:'master_name',index:'product_name',editable:false},
            {name:'head_image',index:'save_string',editable: false,formatter: photoFormatter},
            {name:'master_status',index:'unit_name',editable: false}
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
        caption: "鲜果师列表",
        autowidth: true
    });
	//显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
});

</script>