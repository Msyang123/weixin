<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
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
		    <button class="btn btn-primary btn-sm" type="button"  onclick="jQuery('#grid-table')
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
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
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
    <table id="grid-table1"></table>
    <div id="grid-pager1"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->



</@layout>

<script type="text/javascript">
//取消关联
function canselRelevance(){
	var ids=$("#grid-table1").jqGrid("getGridParam","selarrrow");
	alert(ids);
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterProductManage/canselRelevance?ids="+ids.join(),
        success: function(data) {
        	alert(data.success);
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
        url:"${CONTEXT_PATH}/masterProductManage/relevance?type=16&ids="+ids.join(),
        success: function(data) {
        	alert(data.success);
        	jQuery("#grid-table").trigger("reloadGrid");
        	jQuery("#grid-table1").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
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
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        postData:{'isNutritionPage':true},
        url:"${CONTEXT_PATH}/masterProductManage/productList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['规格编号','商品状态','商品名称','商品分类','首图', '基础单位','规格数量','单位','规格','价格','特价','二维码','是否有效'],
        colModel:[
        	{name:'pf_id',index:'pf_id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false,formatter:function(cellvalue,options,rowObject){
            							var statusStr;
					            		if(cellvalue=='01'){
					            			statusStr = "正常";
					            		}else if(cellvalue=='02'){
					            			statusStr = "禁采";
					            		}else if(cellvalue=='03'){
					            			statusStr = "停止下单";
					            		}
            							return statusStr;}},
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

        multiselect: true,
        multiboxonly: true,

        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },

        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "待关联商品列表--营养精选",
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
                //view record form
                recreateForm: true,
                beforeShowForm: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                }
            }
    )
});

jQuery(function($) {
    var grid_selector = "#grid-table1";
    var pager_selector = "#grid-pager1";

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,?activity_type=5
        postData:{'isNutritionPage':true,'isNutrition':'Y'},
        url:"${CONTEXT_PATH}/masterProductManage/productList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['规格编号','商品状态','商品名称','商品分类','首图', '基础单位','规格数量','单位','规格','价格','特价','二维码','是否有效'],
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
        caption: "已关联商品列表--营养精选",


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
                //view record form
                recreateForm: true,
                beforeShowForm: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                }
            }
    )
});

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


function beforeDeleteCallback(e) {
    var form = $(e[0]);
    if(form.data('styled')) return false;

    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
    style_delete_form(form);

    form.data('styled', true);
}

function beforeEditCallback(e) {
    var form = $(e[0]);
    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
    style_edit_form(form);
}
//});
</script>