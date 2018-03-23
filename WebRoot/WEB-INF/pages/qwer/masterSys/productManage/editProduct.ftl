<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/masterProductManage/productSave" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="product.id" value="${(product.id)!}"/>
    <input type="hidden" name="product.product_detail" id="product_detail" />
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title"> 商品分类</label>
        <div class="col-sm-9">
            <input id="categoryId" type="text" readonly value="${(category.category_name)!}" />
		          <a id="menuBtn" href="#" onclick="showMenu(); return false;">选择</a>
				  <input id="categoryIdValue" type="hidden" name="product.category_id" 
					value="${(category.category_id)!}" />
        </div>
    </div>	
    			
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="product_name">名称</label>
        <div class="col-sm-9">
            <input type="text" id="product_name" name="product.product_name" 
            value="${(product.product_name)!}"
             placeholder="名称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">产品编码 </label>
        <div class="col-sm-9">
            <input type="text" id="product_code" name="product.product_code" placeholder="产品编码" 
            value="${(product.product_code)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">商品状态 </label>
        <div class="col-sm-9">
            <select id="product_status" name="product.product_status">
            	<#if product.product_status??>
	        		<option value="01" <#if product.product_status=='01'>selected</#if>>正常</option>
	        		<option value="02" <#if product.product_status=='02'>selected</#if>>禁采</option>
	        		<option value="03" <#if product.product_status=='03'>selected</#if>>下架</option>
        		<#else>
        			<option value="01" >正常</option>
	        		<option value="02" >禁采</option>
	        		<option value="03" >下架</option>
        		</#if>
        	</select>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">商品图片</label>
        <div class="col-sm-9">
        	<input type="hidden" name="image.id" value="${(image.id)!}"/>
	        <input type="text" id="url" name="image.save_string" value="${(image.save_string)!}" />
			<input type="button" id="image" value="选择图片" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">图片预览 </label>
        <div class="col-sm-9">
	        <img id="url2" style="width:50%;" src="${(image.save_string)!}"/>
        </div>
    </div>
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">基础单位</label>
        <div class="col-sm-9">
	        <select name="product.base_unit" >
	          <#list unitList as item>
					<option value="${(item.unit_code)!}" <#if (product.base_unit!)=='${(item.unit_code)!}'>selected</#if>>${(item.unit_name)!}</option>
			  </#list>
			</select>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">基础条码</label>
        <div class="col-sm-9">
            <input type="text" id="activity_type" name="product.base_barcode" 
            placeholder="基础条码" value="${(product.base_barcode)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="editor">商品简介 </label>
        <textarea id="description" name="product.description" class="ml12 col-sm-5" rows="6" value="${(product.description)!}">${(product.description)!}</textarea>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="editor">商品详情 </label>
        <textarea id="editor" name="product.product_detail" class="ml12 col-sm-5" rows="6"></textarea>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
        	<button class="btn " type="button" onclick="history.go(-1);">
              		  取消
            </button>
            <button class="btn btn-info ml12" type="button" onclick="whenSubmit();">
               		 提交
            </button>
        </div>
    </div>
    
</form>
<!--product_f table-->
	<div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->


            <table id="grid-table"></table>

            <div id="grid-pager"></div>

            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
<!--product_f table-->
<!--select tree-->
<div id="menuContent" class="menuContent" style="display:none; position: absolute;">
	<ul id="category" class="ztree" style="margin-top:0; width:160px;"></ul>
</div>
<!--select tree-->

</@layout>

<script>
	//编辑器和单独图片上传
	var editor;
	var K=window.KindEditor;
	<#if product.product_name?? >
		KindEditor.ready(function (K) {
		//这里是kindeditor编辑器的基本初始化配置
		
		editor = K.create('textarea[id="editor"]', {
			resizeType: 1,
			fullscreenMode: 0, //是否全屏显示
			designMode: 1,
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=product&idName='+$('#product_name').val(),
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=product&idName='+$('#product_name').val(),
			allowPreviewEmoticons: false,
			allowImageUpload: true,
			allowFileManager: true
		});
		editor.html('${product.product_detail!}');
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
		K('#product_name').blur(function (){
			if($('#product_name').val()==''){
				alert("请先填写商品名称");
				return;
			}
			 editor = K.create('textarea[id="editor"]', {
				resizeType: 1,
				fullscreenMode: 0, //是否全屏显示
				designMode: 1,
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=product&idName='+$('#product_name').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=product&idName='+$('#product_name').val(),
				allowPreviewEmoticons: false,
				allowImageUpload: true,
				allowFileManager: true
			});
		});	

		K('#image').click(function () {
			if($('#product_name').val()==''){
				alert("请先填写商品名称");
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

	//提交表单
function whenSubmit(){
   	var html=$(".ke-edit-iframe").contents().find("body").html(); 
	$("#product_detail").val(html);
   	if($('#categoryIdValue').val()==''){alert('商品分类不能为空'); return false;}
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


jQuery(function($) {
	$.fn.zTree.init($("#category"), setting);
	
	var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterProductManage/productFList?productId=${product.id!0}",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:["操作",'编号','产品编码','条码','基础数量单位',  '单位','规格','价格','特价','客户规格显示','规格状态','二维码'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                    editformbutton:true, 
                    editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
                }
            },
            
            {name:'pf.id',index:'id', width:150,editable: true},
            {name:'pf.product_code',index:'product_code',width:90, editable:true},
            {name:'pf.bar_code',index:'bar_code', width:70,editable: true},
            {name:'pf.product_amount',index:'product_amount',width:150,editable: true},
            {name:'pf.product_unit',index:'product_unit', width:150,editable:true,
            	edittype:"select",editoptions:{value:"${unitList1}"}},
            {name:'pf.standard',index:'standard', width:150,editable: true},
            {name:'pf.price',index:'price', width:150,editable: true},
            {name:'pf.special_price',index:'special_price', width:150,editable: true},
            {name:'pf.show_standard',index:'show_standard', width:150,editable: true},
            {name:'pf.is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}},
            {name:'pf.id',index:'id', width:150,editable: false,formatter: photoFormatter}
            
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
		editurl: "${CONTEXT_PATH}/productManage/productFSave?productId=${product.id!0}",
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "商品管理",
        autowidth: true
    });

    //enable search/filter toolbar
    //jQuery(grid_selector).jqGrid('filterToolbar',{defaultSearch:true,stringResult:true})

    //switch element when editing inline
    function aceSwitch( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=checkbox]')
                    .wrap('<label class="inline" />')
                    .addClass('ace ace-switch ace-switch-5')
                    .after('<span class="lbl"></span>');
        }, 0);
    }
    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }
	//显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	var _url=encodeURIComponent("${app_domain}/fruitDetial?pf_id="+rowdata[1]);
    	 return "<img src='${CONTEXT_PATH}/activityManage/printTwoBarCode?code="+_url+"' style='width:40px;height:40px;' />";
    }

    //navButtons
    jQuery(grid_selector).jqGrid('navGrid',pager_selector,
            { 	//navbar options
                edit: true,
                editicon : 'icon-pencil blue',
                add: true,
                addicon : 'icon-plus-sign purple',
                del: true,
                delicon : 'icon-trash red',
                search: false,
                searchicon : 'icon-search orange',
                refresh: true,
                refreshicon : 'icon-refresh green',
                view: true,
                viewicon : 'icon-zoom-in grey'
            },
            {
                //edit record form
                //closeAfterEdit: true,
                recreateForm: true,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_edit_form(form);
                }
            },
            {
                //new record form
                closeAfterAdd: true,
                recreateForm: true,
                viewPagerButtons: false,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_edit_form(form);
                }
            },
            {
                //delete record form
                recreateForm: true,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    if(form.data('styled')) return false;

                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_delete_form(form);

                    form.data('styled', true);
                },
                onClick : function(e) {
                    alert(1);
                }
            },
            {
                //search form
                recreateForm: true,
                afterShowSearch: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                    style_search_form(form);
                },
                afterRedraw: function(){
                    style_search_filters($(this));
                }
                ,
                multipleSearch: true
            },
            {
                //view record form
                recreateForm: true,
                beforeShowForm: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                }
            }
    )



    function style_edit_form(form) {
        //enable datepicker on "sdate" field and switches for "stock" field
        form.find('input[name=sdate]').datepicker({format:'yyyy-mm-dd' , autoclose:true})
                .end().find('input[name=stock]')
                .addClass('ace ace-switch ace-switch-5').wrap('<label class="inline" />').after('<span class="lbl"></span>');

        //update buttons classes
        var buttons = form.next().find('.EditButton .fm-button');
        buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
        buttons.eq(0).addClass('btn-primary').prepend('<i class="icon-ok"></i>');
        buttons.eq(1).prepend('<i class="icon-remove"></i>')

        buttons = form.next().find('.navButton a');
        buttons.find('.ui-icon').remove();
        buttons.eq(0).append('<i class="icon-chevron-left"></i>');
        buttons.eq(1).append('<i class="icon-chevron-right"></i>');
    }

    function style_delete_form(form) {
        var buttons = form.next().find('.EditButton .fm-button');
        buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
        buttons.eq(0).addClass('btn-danger').prepend('<i class="icon-trash"></i>');
        buttons.eq(1).prepend('<i class="icon-remove"></i>')
    }

    function style_search_filters(form) {
        form.find('.delete-rule').val('X');
        form.find('.add-rule').addClass('btn btn-xs btn-primary');
        form.find('.add-group').addClass('btn btn-xs btn-success');
        form.find('.delete-group').addClass('btn btn-xs btn-danger');
    }
    function style_search_form(form) {
        var dialog = form.closest('.ui-jqdialog');
        var buttons = dialog.find('.EditTable')
        buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'icon-retweet');
        buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'icon-comment-alt');
        buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'icon-search');
    }

    function beforeDeleteCallback(e) {
        var form = $(e[0]);
        if(form.data('styled')) return false;

        form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
        style_delete_form(form);

        form.data('styled', true);
    }

    function beforeEditCallback(e) {
    console.log(e);
        var form = $(e[0]);
        form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
        style_edit_form(form);
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
  
    function enableTooltips(table) {
        $('.navtable .ui-pg-button').tooltip({container:'body'});
        $(table).find('.ui-pg-div').tooltip({container:'body'});
    }

    //var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');
});
</script>