<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"] >
<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-left">
		    <div class="form-group">
				    <input id="masterName" name="masterName" class="form-control" placeholder="鲜果师名称"/>
					  创建时间	
					<input type="text" id="createDateBegin" name="createDateBegin" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	            	至
	            	<input type="text" id="createDateEnd" name="createDateEnd" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			        <button class="btn btn-primary btn-sm" type="button" 
			         onclick="jQuery('#grid-table')
			                .setGridParam({postData:{
			                'createDateBegin':$('#createDateBegin').val(),
			                'createDateEnd':$('#createDateEnd').val(),
			                'masterName':$('#masterName').val()}})
			                .trigger('reloadGrid');">
			            <i class="fa fa-search bigger-110"></i>查询
			        </button>
		       </div>
	    </div>
	    
	    <div class="pull-right">
	    	<input type="text" id="star_image" hidden/>  	
		    <button class="btn btn-warning btn-sm" type="button" onclick="setButton()"/>
			    设置
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
	    <div class="pull-left">
		    <div class="form-group">
				    <input id="masterName" name="masterName" class="form-control" placeholder="鲜果师名称"/>
					  创建时间	
					<input type="text" id="createDateBegin" name="createDateBegin" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	            	至
	            	<input type="text" id="createDateEnd" name="createDateEnd" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			        <button class="btn btn-primary btn-sm" type="button" 
			         onclick="jQuery('#grid-table')
			                .setGridParam({postData:{
			                'createDateBegin':$('#createDateBegin').val(),
			                'createDateEnd':$('#createDateEnd').val(),
			                'masterName':$('#masterName').val()}})
			                .trigger('reloadGrid');">
			            <i class="fa fa-search bigger-110"></i>查询
			        </button>
		       </div>
	    </div>
	    <div class="pull-right">	    	   
			<button class="btn btn-danger btn-sm" type="button"  onclick="canselMasterStarSet()">
			    取消设置
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

<div class="modal fade" id="add-star" tabindex="-1" role="dialog" aria-hidden="true">
    <input type="hidden" id="saleId" name="id" value=""/>
    <div class="modal-dialog">
        <div class="modal-content pd20">
	    	<h4>设置成为明星鲜果师并添加头像</h4>
	    	<div class="text-center mt10">
	        	<img id="url2" style="width:30%;border-radius: 50%;"/>
	         	<input type="hidden" id="url" name="star_head_image" value="" />
		     	<a id="uploadStarMaster" class="btn-a">上传</a>
	         </div>
	         
	         <div class="col-12 text-center">
           		<button class="btn btn-secondary btn-sm" type="button" data-dismiss="modal">
                	<i class="fa fa-close bigger-110"></i>取消
            	</button>
           		<button class="btn btn-info btn-sm" type="button" id="btn-confirm">
                	<i class="fa fa-check bigger-110"></i>确认
            	</button>
           </div>
		 </div>    
    </div>
</div>

</@layout>

<script type="text/javascript">
//编辑器和单独图片上传
var editor;
var K=window.KindEditor;
KindEditor.ready(function (K) {
	//这里是kindeditor编辑器的基本初始化配置
	var editor = K.editor({
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName=masterImage',
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName=masterImage',
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
		
		K('#uploadStarMaster').click(function() {
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

function setButton(){
	 var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
	 if(ids.length==0){
		alert("请先选择一条数据在进行操作！");
		//$('#add-star').modal('hide');
		return;
	}
	$("#add-star").find('#url').val("");
	$("#add-star").find('#url2').attr("src","resource/image/icon-master/default_icon.png");
	$('#add-star').modal('show');
}

$("#btn-confirm").click(function(){
	var img=$("#url").val();
	$("#star_image").val(img);
	$('#add-star').modal('hide');
	masterStarSet();
}); 

//取消设置
function canselMasterStarSet(){
	var ids=$("#grid-table1").jqGrid("getGridParam","selarrrow");
	var rowData=$("#grid-table1").jqGrid("getRowData");
	if(rowData.length<=1){
		alert("明星鲜果师必须至少有一人！");
		return;
	}
	if(ids.length==rowData.length){
		alert("明星鲜果师必须至少有一人！");
		return;
	}
	 $.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/masterStarSet?is_fresh_star=0&ids="+ids.join(),
        success: function(data) {
        	alert(data.message);
        	jQuery("#grid-table").trigger("reloadGrid");
        	jQuery("#grid-table1").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

//设置
function masterStarSet(){
	var star_head_image=$("#star_image").val();
	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
	var rowData=$("#grid-table1").jqGrid("getRowData");
	if(rowData.length >= 10){
		alert("明星鲜果师只能有10个人！");
		return;
	}
 	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/masterStarSet?is_fresh_star=1&ids="+ids.join()+"&star_head_image="+star_head_image,
        success: function(data) {
        	alert(data.message);
        	jQuery("#grid-table").trigger("reloadGrid");
        	jQuery("#grid-table1").trigger("reloadGrid");
        },
        error: function(request) {
            //alert("Connection error");
        },
    }); 
}

//enable datepicker
function pickDate( cellvalue, options, cell ) {
    setTimeout(function(){
        $(cell) .find('input[type=text]')
                .datepicker({format:'yyyy-mm-dd' , autoclose:true});
    }, 0);
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
        postData:{'master_status':3,'is_fresh_star':'0'},
        url:"${CONTEXT_PATH}/masterManage/masterList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','手机号码','姓名','加盟时间','头像' ,'上级鲜果师'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'mobile',index:'product_status',width:150,editable: false},
            {name:'master_name',index:'product_name',width:90, editable:false},
            {name:'create_time',index:'category_name', width:70,editable: false},
            {name:'head_image',index:'save_string', width:150,editable: false,formatter: photoFormatter},
            {name:'upName',index:'unit_name', width:150,editable: false},
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
        caption: "可关联鲜果师列表",
        autowidth: true
    });
    
  //显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
});

jQuery(function($) {
    var grid_selector = "#grid-table1";
    var pager_selector = "#grid-pager1";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,?activity_type=5
         postData:{'master_status':3,'is_fresh_star':'1'},
        url:"${CONTEXT_PATH}/masterManage/masterList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','手机号码','姓名','加盟时间','头像' ,'上级鲜果师'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'mobile',index:'product_status',width:150,editable: false},
            {name:'master_name',index:'product_name',width:90, editable:false},
            {name:'create_time',index:'category_name', width:70,editable: false},
            {name:'head_image',index:'save_string', width:150,editable: false,formatter: photoFormatter1},
            {name:'upName',index:'unit_name', width:150,editable: false},
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
        caption: "明星鲜果师列表",
        autowidth: true
    });
    
  //显示图片渲染函数
    function photoFormatter1(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
});
</script>