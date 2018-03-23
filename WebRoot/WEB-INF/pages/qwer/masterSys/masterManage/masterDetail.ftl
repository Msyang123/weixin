<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form id="masterFrom" action="${CONTEXT_PATH}/masterManage/eidtMasterInfo" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="detail.id" value="${detail.id}"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="master_name">鲜果师名称:</label>
        <div class="col-sm-9">
            <input type="text" id="master_name" name="detail.master_name" value="${detail.master_name!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="master_phone">手机号码:</label>
        <div class="col-sm-9">
        	<input type="text" id="master_phone" name="detail.mobile" value="${detail.mobile!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="master_phone">鲜果师头衔:</label>
        <div class="col-sm-9">
        	<input type="text" id="master_nc" name="detail.master_nc" value="${detail.master_nc!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">公式照:</label>
        <div class="col-sm-9">
	        <input type="text" id="master_image" name="detail.master_image" value="${(detail.master_image)!}" />
			<input type="button" id="image" value="选择图片" />
        </div>
    </div>
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">公式照预览:</label>
        <div class="col-sm-9">
	         <img id="master_image2" style="width:50%;" src="${(detail.master_image)!}"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">头像:</label>
        <div class="col-sm-9">
	        <input type="text" id="head_image" name="detail.head_image" value="${(detail.head_image)!}" />
			<input type="button" id="image1" value="选择图片" />
        </div>
    </div>
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">头像预览:</label>
        <div class="col-sm-9">
	         <img id="head_image2" style="width:10%;border-radius: 50%;" src="${(detail.head_image)!}"/>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="editor">个人简介: </label>
        <textarea id="editor" style="width:500px;height:150px;" name="detail.description" value="${(detail.description)!}"  class="ml12">${(detail.description)!}</textarea>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">鲜果师状态: </label>
        <div class="col-sm-9">
            <select id="master_status" name="detail.master_status">
       			<option value="3" >正常</option>
        		<option value="4" >停用</option>
        	</select>
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
        	<button class="btn" type="button" onclick="history.go(-1);">
                <i class="icon-undo bigger-110"></i> 取消
            </button>
            <button class="btn btn-info" type="button" onclick="whenSubmit();">
                <i class="icon-ok bigger-110"></i>提交
            </button>
        </div>
    </div>
    
</form>

<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form id="submitForm1">
	   <div class="pull-left">
					  <div class="form-group">
						    <input id="masterName" name="masterName" class="form-control" placeholder="鲜果师名称"/>
							  创建时间	
							<input type="text" id="createDateBegin" name="createDateBegin" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			            	至
			            	<input type="text" id="createDateEnd" name="createDateEnd" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			            	  鲜果师状态
							<select  id="master_status" name="master_status" class="form-control">
								<option value="">全部</option>
								<option value="3">正常</option>
								<option value="4">停用</option>
							</select>
					        <button class="btn btn-primary btn-sm" type="button" 
					         onclick="jQuery('#grid-table')
					                .setGridParam({postData:{
					                'master_status':$('#master_status').val(),
					                'createDateBegin':$('#createDateBegin').val(),
					                'createDateEnd':$('#createDateEnd').val(),
					                'masterName':$('#masterName').val()}})
					                .trigger('reloadGrid');">
					            <i class="fa fa-search bigger-110"></i>查询
					        </button>
				       </div>
		        </div>
	    <div class="pull-right">	    	   
			<button class="btn btn-warning btn-sm" type="button"  onclick="masterCanselDownRelevance();">
			    取消关联
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
	   <div class="pull-left">	   
		   <div class="form-group">
		   	 手机号码
		   	<input id="phoneNum" name="phoneNum" class="form-control" />
			  创建时间	
			<input type="text" id="registTimeBegin" name="registTimeBegin" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
           	至
           	<input type="text" id="registTimeEnd" name="registTimeEnd" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
           	<button class="btn btn-primary btn-sm" type="button" 
	         	onclick="jQuery('#grid-table1')
	                .setGridParam({postData:{
	                'phoneNum':$('#phoneNum').val(),
	                'registTimeBegin':$('#registTimeBegin').val(),
	                'registTimeEnd':$('#registTimeEnd').val()}})
	                .trigger('reloadGrid');">
	            <i class="fa fa-search bigger-110"></i>查询
	        </button>
		   </div> 	   
		</div>
	    <div class="pull-right">	    	   
			<button class="btn btn-danger btn-sm" type="button"  onclick="masterCanselUserRelevance();">
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
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName=masterImage',
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName=masterImage',
				allowFileManager : true,
			});
			//给按钮添加click事件
			K('#image').click(function() {
				editor.loadPlugin('image', function() {
					//图片弹窗的基本参数配置
					editor.plugin.imageDialog({
						imageUrl : K('#master_image').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
						//点击弹窗内”确定“按钮所执行的逻辑
						clickFn : function(url, title, width, height, border, align) {
							K('#master_image').val(url);//获取图片地址
							K('#master_image2').attr("src",url);
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
			
			K('#image1').click(function() {
				editor.loadPlugin('image', function() {
					//图片弹窗的基本参数配置
					editor.plugin.imageDialog({
						imageUrl : K('#head_image').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
						//点击弹窗内”确定“按钮所执行的逻辑
						clickFn : function(url, title, width, height, border, align) {
							K('#head_image').val(url);//获取图片地址
							K('#head_image2').attr("src",url);
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
	});
	
	function whenSubmit(){
		$("#masterFrom").submit();
	}
	
	function masterCanselDownRelevance(){
    	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
    	console.log(ids);
    	if(ids.length==0){
            alert("请先选择一行数据再进行操作！");
            return;
        } 
    	/* $.ajax({
            type: "POST",
            url:"${CONTEXT_PATH}/masterManage/masterCanselDownRelevance?ids="+ids.join(),
            success: function(data) {
            	jQuery("#grid-table").trigger("reloadGrid");
            	jQuery("#grid-table1").trigger("reloadGrid");
            },
            error: function(request) {
                alert("Connection error");
            },
        }); */
	}
	
	function masterCanselUserRelevance(){
    	var ids=$("#grid-table1").jqGrid("getGridParam","selarrrow");
    	if(ids==0){
            alert("请先选择一行数据再进行操作！");
            return;
        }
    	$.ajax({
            type: "POST",
            url:"${CONTEXT_PATH}/masterManage/masterCanselUserRelevance?ids="+ids.join(),
            success: function(data) {
            	jQuery("#grid-table").trigger("reloadGrid");
            	jQuery("#grid-table1").trigger("reloadGrid");
            },
            error: function(request) {
                alert("Connection error");
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
    
  	//显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
	jQuery(function($) {
		var grid_selector = "#grid-table";
	    var pager_selector = "#grid-pager";

	    jQuery(grid_selector).jqGrid({
	        //direction: "rtl",
	        //data: grid_data,
	        url:"${CONTEXT_PATH}/masterManage/masterList?id="+${detail.id},
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','手机号码','姓名','加盟时间','头像' ,'上级鲜果师','鲜果师状态'],
	        colModel:[
	        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
	            {name:'mobile',index:'product_status',width:150,editable: false},
	            {name:'master_name',index:'product_name',width:90, editable:false},
	            {name:'create_time',index:'category_name', width:70,editable: false},
	            {name:'head_image',index:'save_string', width:150,editable: false,formatter: photoFormatter},
	            {name:'upName',index:'unit_name', width:150,editable: false},
	            {name:'master_status',index:'unit_name', width:150,editable: false}
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
	        caption: "下级鲜果师列表",
	        autowidth: true
	    });
	});
	
	jQuery(function($) {
		var grid_selector = "#grid-table1";
	    var pager_selector = "#grid-pager1";
	    jQuery(grid_selector).jqGrid({
	        //data: grid_data,
	        postData:{'isRecommend':true},
	        url:"${CONTEXT_PATH}/masterManage/masterUserList?id="+${detail.id},
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['序号','微信用户标示', '性别', '手机号','昵称','生日','真实姓名',
	        			'用户地址','注册时间','用户头像','会员余额','会员积分','状态','所属店铺'],
	        colModel:[
	            {name:'id',index:'id', width:200, sorttype:"int", editable: false},
	            {name:'open_id',index:'open_id',width:200, editable:false},
	            {name:'sexDisplay',index:'sexDisplay', width:150,editable: false},
	            {name:'phone_num',index:'phone_num',width:150,editable: false},
	            {name:'nickname',index:'nickname', width:150,editable: false},
	            {name:'birthday',index:'birthday', width:150,editable: false},
	            {name:'realname',index:'realname', width:150,editable: false},
	            {name:'user_address',index:'user_address', width:150,editable: false},
	            {name:'regist_time',index:'regist_time', width:150,editable: false},
	            {name:'user_img_id',index:'user_img_id', width:150,editable: false,formatter: photoFormatter},
	            {name:'balance',index:'balance', width:150,editable: false},
	            {name:'member_points',index:'member_points', width:150,editable: false},
	            {name:'statusDisplay',index:'statusDisplay', width:150,editable: false},
	            {name:'store_name',index:'store_name', width:150,editable: false}
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
	        caption: "用户管理",
	        autowidth: true
	    });
	});
</script>