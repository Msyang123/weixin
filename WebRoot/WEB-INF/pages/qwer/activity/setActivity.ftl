<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js",
"${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js",
"${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css",
"${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"]>

	<ul class="nav nav-tabs mt20" role="tablist">
		  <li class="nav-item active">
		    <a class="nav-link" data-toggle="tab" href="#activity_interval" role="tab">活动时间段管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#activity_pro" role="tab">添加活动商品</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#activity_expro" role="tab">排除活动商品</a>
		  </li>			 
	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
	
		<!--Begain interval-->
		<div class="tab-pane active clearfix" id="activity_interval" role="tabpanel">
		    <div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="interval_name" name="interval_name" type="text" placeholder="段区间名称"/>
					    <div class="input-group">
							  <input type="text" id="interval_begin_time" placeholder="开始时间" name="begin_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'end_time\')}'})" />
				        	至 <input type="text" id="interval_end_time" placeholder="结束时间" name="end_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'begin_time\')}'})" />
					    </div>
					    <select id="status" name="status" class="form-control">
				    	    <option value="">请选择状态</option>
					    	<option value="1">开启</option>
					    	<option value="0">关闭</option>
					    </select>
					    <button class="btn btn-info btn-sm btn-clear" type="button">
					        <i class="fa fa-remove bigger-110"></i>     
					    </button>
					     <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-interval-table">
					        <i class="fa fa-search bigger-110"></i> 搜索     
					    </button>
				    </div>
				    				    
				    <div class="pull-right">
					    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" data-target="#add-interval">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
						<button class="btn btn-danger btn-sm btn-del" type="button" data-acid="${activity.id!}" onclick="confrimDel('#grid-interval-table','${CONTEXT_PATH}/seedManage/delIntervalAjax',this)">
					        <i class="fa fa-trash bigger-110"></i> 删除
					    </button>	
					</div>
				</form>
		    </div>
		    
		    <div class="col-xs-12">
		        <!-- PAGE CONTENT BEGINS -->
		        <!--活动时间段-->
				<table id="grid-interval-table"></table>
		        <div id="grid-interval-pager"></div>
		     </div>
		</div>
        
        <!--Begain addPro-->
		<div class="tab-pane clearfix" id="activity_pro" role="tabpanel">
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
					<div class="pull-left">
						<div class="form-group">
						    <div class="input-group">
						        <input id="categoryIdValue" type="hidden" value=""/>
								<input id="categoryId" type="text" class="form-control" placeholder="商品分类" readonly/>
						        <span class="input-group-btn">
							        <button class="btn btn-info btn-sm" id="menuBtn" 
							                onclick="showMenu('categoryId','menuContent');return false;">
							        <i class="fa fa-search"></i>
							        </button>
						        </span>
							</div>
							
							<select  id="productStatus" name="productStatus" class="form-control">
								<option value="01">正常</option>
								<option value="02">禁采</option>
								<option value="03">停止下单</option>
							</select>
							
							<input id="productName" name="productName"  class="form-control" placeholder="商品名称"/>
							
							<button class="btn btn-info btn-sm btn-clear" type="button">
							        <i class="fa fa-remove bigger-110"></i>     
							</button>
					        <button class="btn btn-info btn-sm btn-search" type="button" data-grid="#grid-select_product-table">
					               <i class="fa fa-search bigger-110"></i>搜索
					        </button>
						</div>
					</div>
					<div class="pull-right">
						<button class="btn btn-warning btn-sm" type="button"  onclick="addToActivity();">
						    <i class="fa fa-plus bigger-110"></i> 批量添加
						</button>
					</div>
				</form> 
	        </div>
	        
		    <div class="col-xs-12">
		        <!-- PAGE CONTENT BEGINS -->
		        <!--待添加商品-->
				<div class="mb10">
					<table id="grid-select_product-table"></table>
			        <div id="grid-select_product-pager"></div>
				</div>
				<div class="mb10">
					<table id="grid-select_product-table"></table>
			        <div id="grid-select_product-pager"></div>
				</div>
					<table id="grid-product-table"></table>
		        	<div id="grid-product-pager"></div>
		     </div>
        </div>
      
        <!--Begain exceptPro-->
		<div class="tab-pane clearfix" id="activity_expro" role="tabpanel">
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
					<div class="pull-left">
						<div class="form-group">
						    <div class="input-group">
						        <input id="categoryIdExceptValue" type="hidden" value="" />
								<input id="categoryIdExcept" type="text" class="form-control" placeholder="商品分类" readonly />
						        <span class="input-group-btn">
							        <button class="btn btn-info btn-sm" id="menuBtn" 
							                onclick="showMenu('categoryIdExcept','menuExceptContent');return false;">
							        <i class="fa fa-search"></i>
							        </button>
						        </span>
							</div>
							
							<select  id="productExceptStatus" name="productExceptStatus" class="form-control">
								<option value="01">正常</option>
								<option value="02">禁采</option>
								<option value="03">停止下单</option>
							</select>
							
							<input id="productExceptName" name="productExceptName" class="form-control" placeholder="商品名称" />
							
							<button class="btn btn-info btn-sm btn-clear" type="button">
							        <i class="fa fa-remove bigger-110"></i>     
							</button>
					        <button class="btn btn-info btn-sm btn-search" type="button" data-grid="#grid-except_product-table">
					            <i class="fa fa-search bigger-110"></i>搜索
					        </button>
					     </div>
				     </div>
				     <div class="pull-right">
					     <button class="btn btn-warning btn-sm" type="button"  onclick="exceptFromActivity();">
						    <i class="fa fa-plus bigger-110"></i> 批量排除
						</button>
				     </div>
				</form>
		   </div>     

		    <div class="col-xs-12">
		        <!--待排除商品-->
		        <div class="mb10">
		        	<table id="grid-except_product-table"></table>
		        	<div id="grid-except_product-pager"></div>
		        </div>
		        <!--活动排除商品-->
		        <div class="pbb40">
		        	<table id="grid-excepted_product-table"></table>
		        	<div id="grid-excepted_product-pager" class="mb10"></div>
		        </div>
		    </div><!-- /.col -->
       </div>

	</div>
	       
	<!--select tree-->
	<div id="menuContent" class="menuContent" style="display:none; position: absolute;">
		<ul id="category" class="ztree" style="margin-top:0; width:160px;"></ul>
	</div>
	
	<div id="menuExceptContent" class="menuContent" style="display:none; position: absolute;">
		<ul id="categoryExcept" class="ztree" style="margin-top:0; width:160px;"></ul>
	</div>
	
	<!--新增/更改活动区间段-->
	<div class="modal fade" id="add-interval" tabindex="-1" role="dialog" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content clearfix">
		            <div class="modal-header">
		                <h4 class="modal-title pull-left">新增/更改种子发放周期</h4>
		                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <div class="clearfix"></div>
		            </div>
				    <div class="modal-body clearfix">
					    <form action="${CONTEXT_PATH}/activityManage/saveInterval" class="form-horizontal" id="seedInstAndInterval" method="post">
						    <input type="hidden" id="activityId" name="activityId" value="${activity.id!}" />
						    <input type="hidden" id="intervalId" name="intervalId" value="0" />
						    
						    <div class="form-group">
						        <label class="col-sm-3 control-label no-padding-right" for="interval_name">时间段区间名称</label>
						        <div class="col-sm-9">
						            <input type="text" id="interval_name" name="interval.interval_name" class="col-xs-10 col-sm-5" />
						        </div>
						    </div>
						    
						    <div class="form-group">
			        			<label class="col-sm-3 control-label no-padding-right" for="yxq_q">开始时间节点</label>
						        <div class="col-sm-9">
						            <input type="text" id="begin_time" name="interval.begin_time" 
						            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'end_time\')}'})" class="col-xs-10 col-sm-5" required/>
						            <span class="tip">(*)</span>
						        </div>
					    	</div>
					    	
						    <div class="form-group">
						        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">结束时间节点 </label>
						        <div class="col-sm-9">
						            <input type="text" id="end_time" name="interval.end_time"   
						            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'begin_time\')}'})" class="col-xs-10 col-sm-5" required/>
						            <span class="tip">(*)</span>
						        </div>
						    </div>
						    
						    <div class="form-group">
						        <label class="col-sm-3 control-label no-padding-right" for="interval_name">商品价格</label>
						        <div class="col-sm-9">
						            <input type="text" id="activity_good_price" name="interval.activity_good_price" class="col-xs-10 col-sm-5" />
						        </div>
						    </div>
		                </form>    
				    </div> 
				    <div class="modal-footer text-center">
		           		<button class="btn btn-info" type="button" id="btn-confirm">确认</button>
		            </div> 
		        </div><!--/END Modal-content -->
		  </div><!--/END Modal-Dialog-->
	</div><!--/END Modal-->
</@layout>

<script>
	var editor;
	var K=window.KindEditor;
	<#if activity.main_title?? >
		KindEditor.ready(function(K) {
	
			   editor = K.editor({
					cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
					uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+$('#main_title').val(),
					fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+$('#main_title').val(),
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
	
	<#else>
		K('#main_title').blur(function (){
			 editor = K.editor({
					cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
					uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+$('#main_title').val(),
					fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+$('#main_title').val(),
					allowFileManager : true,
			});
		});	
			
		K('#image').click(function () {
			if($('#main_title').val()==''){
				alert("请先填写活动主标题");
				return;
			}
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
	</#if>
	 
	//选择商品规格到活动中    
	function addToActivity(){
		var ids=$("#grid-select_product-table").jqGrid("getGridParam","selarrrow");
	    window.location.href="${CONTEXT_PATH}/activityManage/addActivityProduct?activityId="+${activity.id}
	    +"&ids="+ids.join();
	}    
	
	//选取排除的活动商品
	function exceptFromActivity(){
		var ids=$("#grid-except_product-table").jqGrid("getGridParam","selarrrow");
	    window.location.href="${CONTEXT_PATH}/activityManage/exceptActivityProduct?activityId="+${activity.id}
	    +"&ids="+ids.join();
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
	
	var settingExcept = {
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
			onClick: onClickExcept
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
	
	function onClickExcept(e, treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("categoryExcept"),
		nodes = zTree.getSelectedNodes(),
		v = "";
		nodes.sort(function compare(a,b){return a.id-b.id;});
		for (var i=0, l=nodes.length; i<l; i++) {
			v += nodes[i].name + ",";
		}
		if (v.length > 0 ) v = v.substring(0, v.length-1);
		var cityObj = $("#categoryIdExcept");
		cityObj.attr("value", v);
		$("#categoryIdExceptValue").val(treeNode.id);
	}
	
	function showMenu(id,menuContent) {
		var categoryId = $("#"+id);
		var categoryIdOffset = categoryId.offset();
		$("#"+menuContent).css({left:categoryIdOffset.left-180 + "px", 
		top:categoryIdOffset.top-60 + "px",
		zIndex:999}).slideDown("fast");
	
		$("body").bind("mousedown", onBodyDown);
	}
	
	function hideMenu() {
		$("#menuContent").fadeOut("fast");
		$("#menuExceptContent").fadeOut("fast");
		$("body").unbind("mousedown", onBodyDown);
	}
	
	function onBodyDown(event) {
		if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0
			|| event.target.id == "menuExceptContent" || $(event.target).parents("#menuExceptContent").length>0)) {
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
		$.fn.zTree.init($("#categoryExcept"), settingExcept);
		
		var grid_interval_table ="#grid-interval-table";
		var grid_interval_pager="#grid-interval-pager";
		
		var grid_product_selector = "#grid-product-table";
		var pager_product_selector = "#grid-product-pager";
		
		var grid_select_product_table = "#grid-select_product-table";
		var grid_select_product_pager = "#grid-select_product-pager";
		
		var grid_except_product_table = "#grid-except_product-table";
		var grid_except_product_pager = "#grid-except_product-pager";
		
		var grid_excepted_product_table = "#grid-excepted_product-table";
		var grid_excepted_product_pager = "#grid-excepted_product-pager";
				
		jQuery(grid_interval_table).jqGrid({
	        url:"${CONTEXT_PATH}/activityManage/getIntervalListJson?activity_id=${activity.id}",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','时间区间名称','开始时间','结束时间','商品价格','状态','操作'],
	        colModel:[
	        	{name:'interval.id',index:'id', sorttype:"int", editable: false},
	            {name:'interval.interval_name',index:'interval_name',editable: true},
	            {name:'interval.begin_time',index:'begin_time', editable:true},
	            {name:'interval.end_time',index:'end_time',editable: true,sorttype:"date",unformat: pickDate},
	            {name:'interval.activity_good_price',index:'activity_good_price', editable:true},
	            {name:'interval.status',index:'status',editable: true,
                    formatter:function(cellvalue,options,rows){
                    	 if(rows[5]==0){
                    		 return "关闭";
                         }else if(rows[5]>0){
                        	 return "开启";
                         }else{
                        	 return "N/A";
                         }
                     }
		        },
		        {name:'myac',index:'', fixed:true, sortable:false, resize:false,
	                formatter:function(cellvalue, options, rows) { 
	                    var acid=$('#activity_id').val();
		               	if(rows[5] == 1){
		               		return  '<a class="btn btn-danger btn-xs mr5" title="关闭发放" data-grid="grid-interval-table" onclick =ChangeStatus('+rows[0]+',"'+rows[5]+'",this,"${CONTEXT_PATH}/activityManage/changeIntervalStatus")><i class="fa fa-cloud-download"></i></a>'+
				                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已开启的活动,需先关闭再编辑")><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>';
		               	}else{
						    	return  '<a class="btn btn-success btn-xs mr5" title="开启发放" data-grid="grid-interval-table" onclick = ChangeStatus('+rows[0]+',"'+rows[5]+'",this,"${CONTEXT_PATH}/activityManage/changeIntervalStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
				                '<a class="btn btn-warning btn-xs mr5" title="修改" data-id="'+rows[0]+'" data-toggle="modal" data-target="#add-interval"><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" data-acid="'+acid+'" onclick=confrimDel("#grid-interval-table","${CONTEXT_PATH}/activityManage/delIntervalAjax",this)><i class="fa fa-trash"></i></a>';
		               	}
				    }
	            }
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : grid_interval_pager,
	        emptyrecords : "未找到任何数据",
	        pgtext: "第{0}页 共{1}页",
	        altRows: true,
	        multiselect: true,
	        multiboxonly: true,
	        loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	                enableTooltips(table);
	            }, 0);
	        },
	        editurl: "${CONTEXT_PATH}/activityManage/saveInterval?activityId=${activity.id}",
	        caption: "活动时间段列表",
	        autowidth: true
	    });
		
		jQuery(grid_select_product_table).jqGrid({
	        url:"${CONTEXT_PATH}/activityManage/productFList",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位','规格数量',
	        		'单位','规格','价格','特价','赠送商品','有效'],
	        colModel:[
	        	{name:'id',index:'id', sorttype:"int", editable: false},
	            {name:'product_status',index:'product_status',editable: false},
	            {name:'product_name',index:'product_name', editable:false},
	            {name:'category_name',index:'category_name',editable: false},
	            {name:'save_string',index:'save_string',editable: false,
		            formatter:function(cellvalue, options, rowdata){
		            	 return '<img src="'+cellvalue+'" width="40" height="40" onerror="imgLoad(this)"/>';
			        }
		        },
	            {name:'base_unitname',index:'base_unitname',editable: false},
	            {name:'product_amount',index:'product_amount',editable: true},
	            {name:'product_unit',index:'product_unit',editable:true,edittype:"select",editoptions:{value:"${unitList}"}},
	            {name:'standard',index:'standard',editable: true},
	            {name:'price',index:'price',editable: true},
	            {name:'special_price',index:'special_price',editable: true},
	            {name:'is_gift',index:'is_gift',editable: true,edittype:"select",editoptions:{value:"1:是;0:否"}},
	            {name:'is_vlid',index:'is_vlid',editable: true,edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : grid_select_product_pager,
	        emptyrecords : "未找到任何数据",
	        pgtext: "第{0}页 共{1}页",
	        altRows: true,
	        multiselect: true,
	        multiboxonly: true,
	        loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	                enableTooltips(table);
	            }, 0);
	        },
	        caption: "商品待添加列表",
	        autowidth: false,
	        width:1327
	    });
	    
	    jQuery(grid_except_product_table).jqGrid({
	        url:"${CONTEXT_PATH}/activityManage/productFExceptList",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位','规格数量',
	        		'单位','规格','价格','特价','赠送商品','有效'],
	        colModel:[
	        	{name:'id',index:'id', sorttype:"int", editable: false},
	            {name:'product_status',index:'product_status',editable: false},
	            {name:'product_name',index:'product_name', editable:false},
	            {name:'category_name',index:'category_name',editable: false},
	            {name:'save_string',index:'save_string',editable: false,
		            formatter:function(cellvalue, options, rowdata){
		            	 return '<img src="'+cellvalue+'" width="40" height="40" onerror="imgLoad(this)"/>';
			        }
		        },
	            {name:'base_unitname',index:'base_unitname',editable: false},
	            {name:'product_amount',index:'product_amount',editable: true},
	            {name:'product_unit',index:'product_unit',editable:true,edittype:"select",editoptions:{value:"${unitList}"}},
	            {name:'standard',index:'standard',editable: true},
	            {name:'price',index:'price',editable: true},
	            {name:'special_price',index:'special_price',editable: true},
	            {name:'is_gift',index:'is_gift',editable: true,edittype:"select",editoptions:{value:"1:是;0:否"}},
	            {name:'is_vlid',index:'is_vlid',editable: true,edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : grid_except_product_pager,
	        emptyrecords : "未找到任何数据",
	        pgtext: "第{0}页 共{1}页",
	        altRows: true,
	        multiselect: true,
	        multiboxonly: true,
	        loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	                enableTooltips(table);
	            }, 0);
	        },
	        caption: "商品待排除列表",
	        autowidth: false,
	        width:1327
	    });
	    
	    jQuery(grid_excepted_product_table).jqGrid({
	        url:"${CONTEXT_PATH}/activityManage/productFExceptedList?activityId=${activity.id}",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['序号','首图', '商品名称', '价格','特价','商品编号','规格编号','规格','单位'],
	        colModel:[
	            {name:'apid',index:'apid', sorttype:"int", editable: false},
	            {name:'save_string',index:'save_string', 
		            formatter:function(cellvalue, options, rowdata){
	            	   return '<img src="'+cellvalue+'" width="40" height="40" onerror="imgLoad(this)"/>';
		            }
		        },
	            {name:'product_name',index:'product_name',editable: false},
	            {name:'price',index:'price',editable: false},
	            {name:'special_price',index:'special_price',editable: false},
	            {name:'id',index:'id',editable: false},
	            {name:'pf_id',index:'pf_id',editable: false},
	            {name:'standard',index:'standard',editable: false},
	            {name:'unit_name',index:'unit_name',editable: false}
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30,100,500],
	        pager : grid_excepted_product_pager,
	        emptyrecords : "未找到任何数据",
	        pgtext: "第{0}页 共{1}页",
	        altRows: true,
	        multiselect: true,
	        multiboxonly: true,
			editurl: "${CONTEXT_PATH}/activityManage/delActivityExceptProduct?activityId=${activity.id}",					
	        loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	                enableTooltips(table);
	            }, 0);
	        },
	        caption: "商品已排除列表",
	        autowidth: false,
	        width:1327
	    });
	    	    	
		jQuery(grid_product_selector).jqGrid({
	        url:"${CONTEXT_PATH}/activityManage/mActivityProducts?activityId=${activity.id}",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['操作','序号','活动价格','限购数量','首图', '商品名称', '价格','特价','商品编号','规格编号','规格','单位'],
	        colModel:[
	        	{name:'myac',index:'', fixed:true, sortable:false, resize:false,
	                formatter:'actions',
	                formatoptions:{
	                    keys:false,
	                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
	                }
	            },
	            {name:'apid',index:'apid', sorttype:"int", editable: false},
	            {name:'activity_price',index:'activity_price', editable: true},
	            {name:'product_count',index:'product_count', editable: true},
	            {name:'save_string',index:'save_string',
		            formatter:function(cellvalue, options, rowdata){
	            	   return '<img src="'+cellvalue+'" width="40" height="40" onerror="imgLoad(this)"/>';
		            }
			    },
	            {name:'product_name',index:'product_name',editable: false},
	            {name:'price',index:'price',editable: false},
	            {name:'special_price',index:'special_price',editable: false},
	            {name:'id',index:'id',editable: false},
	            {name:'pf_id',index:'pf_id',editable: false},
	            {name:'standard',index:'standard',editable: false},
	            {name:'unit_name',index:'unit_name',editable: false}
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30,100,500],
	        pager : pager_product_selector,
	        emptyrecords : "未找到任何数据",
	        pgtext: "第{0}页 共{1}页",
	        altRows: true,
	        multiselect: true,
	        multiboxonly: true,
			editurl: "${CONTEXT_PATH}/activityManage/delActivityProduct?activityId=${activity.id}",	        
			loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	                enableTooltips(table);
	            }, 0);
	        },
	        //双击表格行回调函数
	        ondblClickRow:function(rowid, iRow, iCol, e){
	        	window.open("${CONTEXT_PATH}/activityManage/teamBuyScale?id="+rowid);
	        },
	        caption: "活动商品信息",
	        autowidth: false,
	        width:1327
	    });
	    
		initNavGrid(grid_product_selector,pager_product_selector);
		initNavGrid(grid_select_product_table,grid_select_product_pager);
		initNavGrid(grid_except_product_table,grid_except_product_pager);

		//时间段管理新增或修改
	    $('#add-interval').on('show.bs.modal',function(e){
	     	   var $button=$(e.relatedTarget);
	           var modal=$(this);
	           var id=$button.data("id");
	           
	           //如果有id值则为修改,否则为新增
	           if(id==null||id==""){
	               //添加直接show
	               $('#seedInstAndInterval')[0].reset();
	 		       $('#intervalId').val("0");
	               return;
	           }else{
	 	          //发送ajax回去查询单条数据
	 	          $.ajax({
	 	                url:'${CONTEXT_PATH}/activityManage/intervalDetial',
	 	                type:'Get',
	 	                data:{id:id},
	 	                success:function(result){
	 	                    if(result.success){
	 	                        //回填数据
	 	                        modal.find('#intervalId').val(result.data.id);
	 	                        modal.find("#send_percent").val(result.data.send_percent);
	 	                        modal.find("#interval_name").val(result.data.interval_name);
	 	                        modal.find("#begin_time").val(result.data.begin_time);
	 	                        modal.find("#end_time").val(result.data.end_time);
	 	                        modal.find("#end_time").val(result.data.end_time); 
	 	                        modal.find("#activity_good_price").val(result.data.activity_good_price);   
	 	                    }
	 	                    else
	 	                    {
	 	                    	modal.modal('hide');
	 	                        $.alert('提示',result.msg);
	 	                    }
	 	                }
	 	          });
	           }
	   });
	     
	   //时间段管理编辑提交 
       $('#btn-confirm').on('click',function(){
            //校验
            var validetor=$('#seedInstAndInterval').validate();
            if(!validetor.form()){
                 return false;
            }
	        $('#seedInstAndInterval').submit();
	    });                         
    });
	</script>