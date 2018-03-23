<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form id="submitForm1" >
	  <div class="pull-left">
	  <input type="text" id="activity_id_table" hidden>
		    <input class="form-control" id="productName" name="productName" type="text" placeholder="商品名称"/>
		    <div class="input-group">
				  <input type="text" id="up_time" placeholder="拼团开始时间" name="up_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	        	至 <input type="text" id="down_time" placeholder="拼团结束时间" name="down_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
		    </div>
			<select  id="productStatus" name="productStatus" class="form-control">
				<option value="">商品状态</option>
				<option value="0">上架</option>
				<option value="1">下架</option>
			</select>
		    <button class="btn btn-primary btn-sm" type="button"  onclick="jQuery('#grid-table1')
                .setGridParam({postData:{'productName':$('#productName').val(),
	                'up_time':$('#up_time').val(),'down_time':$('#down_time').val(),
	                'productStatus':$('#productStatus').val()}})
	                .trigger('reloadGrid');">
		        <i class="fa fa-search bigger-110"></i> 搜索    
		    </button> 
	    </div>
	    <div class="pull-right">
	    	<button class="btn btn-warning btn-sm" type="button"  onclick="eidtTeamProduct()">
			   <i class="fa fa-plus bigger-110"></i>
			         新增
			</button>	
	    	<button class="btn btn-danger btn-sm" type="button"  onclick="delProAndScaleRelevance()">
			   <i class="fa fa-close bigger-110"></i>      
			         删除
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

<!--活动查看详情Model-->
<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">活动信息预览</h4>
      </div>
      <div class="modal-body">
      	    <div class="form-horizontal detail-form">
			     <div class="form-group">
                    <label class="col-md-3">活动名称 ：</label>
			        <div class="col-md-9 activity-name1"></div> 
			     </div>  				     
			     <div class="form-group">
                    <label class="col-md-3">活动规则 ：</label>
			        <div class="col-md-9 activity-rule1"></div> 
			     </div> 
			     <div class="form-group">
                    <label class="col-md-3">活动banner ：</label>
			        <div class="col-md-9">
				        <img id="preview"  width="100%" />
			        </div> 
			     </div>
			</div>
      </div>
    </div>
  </div>
</div>

<!--编辑Model-->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="width: 800px;">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">活动信息编辑</h4>
      </div>
      <div class="modal-body text-center rows clearfix">
      	    <form id="activity_form" method="Post" class="form-horizontal col-md-10" action="${CONTEXT_PATH}/teamBuyManage/eidtGroup" >
	      	    <div class="form-horizontal detail-form">
				     <div class="form-group">
	                       <label class="col-md-3 no-padding-right">活动名称 ：</label>
				           <div class="col-md-9">
				           		<input type="hidden" id="activity_id" name="activity_id1" />
				            	<input type="text"  id="activity_name1" name="activity.main_title" class="activity-name form-control" />
				            	<!-- <input type="text" id="activity_name1" > -->
				           </div>
				     </div>  				     
				     <div class="form-group">
	                       <label class="col-md-3 no-padding-right">活动规则 ：</label>
				           <div class="col-md-9">
				           		<input type="hidden" name="activity.content" id="editorText" />
								<textarea id="editor" name="activity.content"   class="activity-rule form-control" style="width:300px;"></textarea>
				           </div>
				     </div> 
					 <div class="form-group">
					       <label class="col-md-3 no-padding-right control-label" for="url">活动banner：</label>
					
					       <div class="col-sm-9">
						        <input type="text" id="image_src" name="image_src" value="" class="col-md-8"/>
						        <input type="hidden" id="image_id" name="activity.img_id" value=""/>
								<input type="button" id="image" value="选择图片" class="col-md-2 nopd-lr btn btn-info"/>
					       </div>
					 </div>
					 <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="url">banner预览：</label>
				        <div class="col-sm-9">
					         <img id="url" style="width:100%;" />
				        </div>
				    </div>
				    <div class="clearfix form-actions">
				        <div class="col-md-offset-3 col-md-9">
				        	<button class="btn" type="button" data-dismiss="modal" aria-hidden="true">
				                <i class="icon-undo bigger-110"></i> 取消
				            </button>
				            <button class="btn btn-info" type="button" onclick="whenSubmit();">
				                <i class="icon-ok bigger-110"></i>提交
				            </button>
				        </div>
	   				 </div>
				</div>
 			</form>
       </div>
    </div>
  </div>
</div>

<!--商品信息查看详情Model-->
<div class="modal fade" id="proDetailModal" tabindex="-1" role="dialog" aria-labelledby="proDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="width: 650px;">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">活动信息预览</h4>
      </div>
      <div class="modal-body">
      	    <div class="form-horizontal detail-form clearfix">
			     <div class="form-group">
                    <label class="col-md-3">商品排序 ：</label>
			        <div class="col-md-9 pro-rank"></div> 
			     </div>  				     
			     <div class="form-group">
                    <label class="col-md-3">关联商品 ：</label>
			        <div class="col-md-9 relate-pro"></div> 
			     </div> 
			     <div class="form-group">
                    <label class="col-md-3">商品上架时间 ：</label>
			        <div class="col-md-9 shelves-time"></div> 
			     </div>  				     
			     <div class="form-group">
                    <label class="col-md-3">商品下架时间 ：</label>
			        <div class="col-md-9  unshelve-time"></div> 
			     </div>
			     
			     <hr/>
		    	<!-- 商品规模设置 -->
				<div class="col-xs-12 pbb80">
				    <!-- PAGE CONTENT BEGINS -->
				    <table id="grid-table2"></table>
				    <div id="grid-pager2"></div>
				    <!-- PAGE CONTENT ENDS -->
				</div>	
			</div>
      </div>
    </div>
  </div>
</div>


<!-- 团购数据统计Modal -->
<div class="modal fade" id="dataModal" tabindex="-1" role="dialog" aria-labelledby="dataModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">活动数据查询</h4>
      </div>
      <div class="modal-body">
      	    <div class="clearfix mb20">
				<div class="pull-left">
						<input type="text" id="createBeginTime" placeholder="活动开始时间" name="createBeginTime"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
			        	- <input type="text" id="createEndTime" placeholder="活动结束时间" name="createEndTime"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
					    <button class="btn btn-info btn-sm cm3" type="button" onclick="dataCount()">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
			    </div>
			    <!-- <div class="pull-right">
			    	<button class="btn btn-info btn-sm" type="button">
				        <i class="fa fa-share bigger-110"></i> 导出    
				    </button>
			    </div> -->
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<ul class="list-group data-from">
					    <li class="list-group-item">总销售额<span class="totalNum">12548.7人民币</span></li>
					    <li class="list-group-item">开团数<span class="beginTourNum">1254</span></li>
					    <li class="list-group-item">成团数<span class="successTourNum">255</span></li>
					    <li class="list-group-item">成功订单总数<span class="successOrderTotalNum">606</span></li>
					</ul>
				</div>
				<div class="col-sm-6">
					<ul class="list-group data-from product_xl">
					    <!-- <li class="list-group-item product">拼团商品销售排序（TOP5）<span>销售订单数</span></li> -->
					</ul>
				</div>
			</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 团购商品数据统计Modal -->
<div class="modal fade" id="pro_dataModal" tabindex="-1" role="dialog" aria-labelledby="dataModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" style="width:800px;">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">拼团商品数据查询</h4>
      </div>
      <div class="modal-body">
      	    <div class="clearfix mb20">
				<div class="pull-left">
						<input type="text" id="createBeginTime1" placeholder="活动开始时间" name="createBeginTime1"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
			        	- <input type="text" id="createEndTime1" placeholder="活动结束时间" name="createEndTime1"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
					    <input type="text" id="proId">
					    <button class="btn btn-info btn-sm cm3" type="button" onclick="proDataCount()">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
			    </div>
			</div>
			
			<table class="table table-hover table-bordered f14" id="pro_data">
			    <thead>
				    <tr>
				      <th>拼团规模</th>
				      <th>参与拼团人数</th>
				      <th>开团数</th>
				      <th>成团数</th>
				      <th>失败团数</th>
				      <th>进行中的团数</th>
				      <th>有效订单数</th>
				      <th>产生订单金额（单位：元）</th>
				    </tr>
			    </thead>
			    <tbody id="pro_data tbody">
			    </tbody>
			</table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

</@layout>

<script type="text/javascript">
	var $path_base = "/";
	var is_load=false;
	jQuery(function($) {
	    var grid_selector = "#grid-table";
	    var pager_selector = "#grid-pager";
	
	    jQuery(grid_selector).jqGrid({
	        url:"${CONTEXT_PATH}/teamBuyManage/groupActivity",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['活动编号','活动名称','活动链接','活动状态','操作'],
	        colModel:[
	        	{name:'id',index:'id',sorttype:"int", editable: false},
	            {name:'main_title',index:'main_title',editable: false},
	            {name:'url',index:'url', editable:false},
	            {name:'status',index:'status',editable: false,
	            	formatter: function(cellvalue,options,rowObject){
	            		if(rowObject[3]==0){
	        	    		return "开启";
	        	    	}else{
	        	    		return "关闭";
	        	    	}
	    		     }
	    		},
	            {name:'myac',index:'',width:200, fixed:true, sortable:false, resize:false,
	                formatter: function(cellvalue,options,rowObject){
	                	var myacStr;
	                	var value = rowObject[3];
	                	var id = rowObject[0];
	                	$("#activity_id_table").val(id);
	                	if(0 == value){
	                		myacStr = '<a class="btn btn-danger btn-xs mr5" title="下架" onclick=activityOpenOrClose('+id+','+value+')><i class="fa fa-cloud-download"></i></a>'+
	                		 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#detailModal" data-id="'+id+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
					         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" data-toggle="modal" data-target="#editModal" data-id="'+id+'" ><i class="fa fa-edit"></i></a>'+
					         '<a class="btn btn-default btn-xs mr5" title="数据统计" data-toggle="modal" data-target="#dataModal" data-id="'+id+'"><i class="fa fa-line-chart"></i></a>';
	                	}else{
	                		myacStr = '<a class="btn btn-success btn-xs mr5" title="上架" onclick=activityOpenOrClose('+id+','+value+')><i class="fa fa-cloud-upload"></i></a>'+
	                		 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#detailModal" data-id="'+id+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
					         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" data-toggle="modal" data-target="#editModal" data-id="'+id+'"><i class="fa fa-edit"></i></a>'+
					         '<a class="btn btn-default btn-xs mr5" title="数据统计" data-toggle="modal" data-target="#dataModal" data-id="'+id+'"><i class="fa fa-line-chart"></i></a>';
	                	}
					    return myacStr;
				    }
	            }
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
	        caption: "活动控制",
	        autowidth: true
	    });
	    
	    initNavGrid(grid_selector,pager_selector);
	    
	});

	jQuery(function($) {
	    var grid_selector = "#grid-table1";
	    var pager_selector = "#grid-pager1";
	    jQuery(grid_selector).jqGrid({
	    	postData:{'activity_id':$('#activity_id_table').val()},
	    	url:"${CONTEXT_PATH}/teamBuyManage/productActivity",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['','','商品排序','商品创建时间','商品名称','商品上架时间','商品下架时间', '商品状态','','操作'],
	        colModel:[
	        	{name:'id',index:'id', width:150, sorttype:"int", editable: false,hidden:true},
	        	{name:'product_id',index:'product_id', width:150, sorttype:"int", editable: false,hidden:true},
	        	{name:'dis_order',index:'dis_order', width:150, sorttype:"int", editable: false},
	            {name:'create_time',index:'create_time',width:150,editable: false},
	            {name:'product_name',index:'product_name',width:90, editable:false},
	            {name:'up_time',index:'up_time', width:150,editable: false},
	            {name:'down_time',index:'down_time', width:150,editable: false},
	            {name:'status',index:'status', width:150,editable: false,
	            	formatter: function(cellvalue,options,rowObject){
	            		if(rowObject[7]==0){
	        	    		return "上架";
	        	    	}else if(rowObject[7]==1){
	        	    		return "关闭";
	        	    	}else{
	        	    		return "下架";
	        	    	}
	    		    }
	    		},
	    		{name:'product_f_id',index:'product_f_id', width:150, sorttype:"int", editable: false,hidden:true},
	            {name:'myac',index:'', width:200,fixed:true, sortable:false, resize:false,
	                formatter: function(cellvalue,options,rowObject){
	                	var myacStr;
	                	var value = rowObject[7];
	                	var id = rowObject[0];
	                	var productid = rowObject[1];
	                	var productFId= rowObject[8];
	                	if("0" == value){
	                		myacStr = '<a class="btn btn-success btn-xs mr5" title="下架" onclick=productOpenOrClose('+id+','+value+','+productFId+')><i class="fa fa-cloud-download"></i></a>'+
	                		 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#proDetailModal" data-id="'+id+'" data-pid="'+productid+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
					         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" onclick="editHtml('+id+','+value+');"><i class="fa fa-edit"></i></a>'+
					         '<a class="btn btn-default btn-xs mr5" title="数据统计" data-toggle="modal" data-target="#pro_dataModal" data-id="'+id+'"><i class="fa fa-line-chart"></i></a>';
	                	}else if("1" == value){
	                		myacStr = '<a class="btn btn-defalut btn-xs mr5" title="开启上架" onclick=productOpenOrClose('+id+','+value+','+productFId+')><i class="glyphicon glyphicon-tags"></i></a>'+
	                		 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#proDetailModal" data-id="'+id+'" data-pid="'+productid+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
					         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" onclick="editHtml('+id+','+value+');"><i class="fa fa-edit"></i></a>'+
					         '<a class="btn btn-default btn-xs mr5" title="数据统计" data-toggle="modal" data-target="#pro_dataModal" data-id="'+id+'"><i class="fa fa-line-chart"></i></a>';
	                	}else{
	                		myacStr = '<a class="btn btn-danger btn-xs mr5" title="上架" onclick=productOpenOrClose('+id+','+value+','+productFId+')><i class="fa fa-cloud-upload"></i></a>'+
	               		 	 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#proDetailModal" data-id="'+id+'" data-pid="'+productid+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
					         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" onclick="editHtml('+id+','+value+');"><i class="fa fa-edit"></i></a>'+
					         '<a class="btn btn-default btn-xs mr5" title="数据统计" data-toggle="modal" data-target="#pro_dataModal" data-id="'+id+'"><i class="fa fa-line-chart"></i></a>';
	               		}
					    return myacStr;
				    }
	            }
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
	        caption: "拼团商品管理",
	        autowidth: true
	    });
	    initNavGrid(grid_selector,pager_selector);
	});


	$(function(){
		//编辑器和单独图片上传
		var editor;
		var K=window.KindEditor;
		KindEditor.ready(function (K) {
			//这里是kindeditor编辑器的基本初始化配置
				editor = K.create('textarea[id="editor"]', {
				resizeType: 1,
				fullscreenMode: 0, //是否全屏显示
				designMode: 1,
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?idName=groupImage',
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName=groupImage',
				allowPreviewEmoticons: false,
				allowImageUpload: true,
				allowFileManager: true,
				width : "100%", //编辑器的宽度
			});
			
			//editor.html($("#editor").val());
			//给按钮添加click事件
			K('#image').click(function() {
				editor.loadPlugin('image', function() {
					//图片弹窗的基本参数配置
					editor.plugin.imageDialog({
						imageUrl : K('#image_src').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
						//点击弹窗内”确定“按钮所执行的逻辑
						clickFn : function(url, title, width, height, border, align) {
							K('#image_src').val(url);//获取图片地址
							K('#url').attr("src",url);
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
		});
		
		 //查看详情
	    $('#detailModal').on('show.bs.modal',function(e){
	          var $button=$(e.relatedTarget);
	          var id=$button.data("id");
	          var modal = $(this);
	          
	          //发送ajax回去查询单条数据
	          $.ajax({
	                url:'${CONTEXT_PATH}/teamBuyManage/eidtGroupActivity',
	                type:'Get',
	                data:{id:id},
	                success:function(result){
	                    if(result){
	                        //回填数据
	                        modal.find('.activity-name1').text(result.group.main_title);
	                        modal.find('.activity-rule1').text(result.group.content);
	                        $("#preview").attr('src',result.image_name); 
	                    }
	                    else
	                    {
	                        alert('提示','查看详情失败 ！');
	                    }
	                }
	          });
	    });
		
	    //编辑回填数据
	    $('#editModal').on('show.bs.modal',function(e){
	          var $button=$(e.relatedTarget);
	          var id=$button.data("id");
	          var modal = $(this);
	          //发送ajax回去查询单条数据
	          $.ajax({
	                url:'${CONTEXT_PATH}/teamBuyManage/eidtGroupActivity',
	                type:'Get',
	                data:{id:id},
	                success:function(result){
	                    if(result){
	                        //回填数据
	                        modal.find('#activity_id').val(result.group.id);
	                        modal.find('#image_src').val(result.image_name);
	                        modal.find('#activity_name1').val(result.group.main_title);
	                        $("#url").attr('src',result.image_name); 
	                        $("#image_id").val(result.group.img_id);
	                        KindEditor.html("#editor",result.group.content);//给kindEditor文本编辑器赋值
	                    }
	                    else
	                    {
	                        alert('提示','查看详情失败 ！');
	                    }
	                }
	          });
	          
	    });
	    
		//商品信息查看详情
	    $('#proDetailModal').on('show.bs.modal',function(e){
	    	 var $button=$(e.relatedTarget);
	          var id=$button.data("id");
	          var modal = $(this);
	          //发送ajax回去查询单条数据
	           $.ajax({
	                 url:'${CONTEXT_PATH}/teamBuyManage/productDetail',
	                 async:false,
	                 type:'Get',
	                 data:{id:id},
	                 success:function(result){
	                     if(result){
	                    	 console.log(result);
	                         //回填数据
	                            modal.find('.pro-rank').html(result.activityProduct.dis_order);
	 	                        modal.find('.relate-pro').html(result.product.product_name);
	 	                        modal.find('.shelves-time').html(result.activityProduct.up_time);
	 	                        modal.find('.unshelve-time').html(result.activityProduct.down_time);
	 	                       //jQuery("#grid-table2").trigger("reloadGrid");
	 	                       //jQuery("#grid-table2").jqGrid("clearGridData");
	 	                     		var apid = result.activityProduct.id;
	 	                     		var grid_selector = "#grid-table2";
	 	                     	    var pager_selector = "#grid-pager2";
	 	                     	    if(is_load==false){
		                     	    	is_load=true;
		                     	    	jQuery(grid_selector).jqGrid({
		                     	        //postData:{'activity_product_id':apid},
		                     	        url:"${CONTEXT_PATH}/teamBuyManage/teamProductScal?activity_product_id="+apid,
		                     	        //mtype: "get",
		                     	        datatype: "json",
		                     	        height: '100%',
		                     	        colNames:["","顺序",'商品名称','拼团人数','商品单价','每日开团数',  '用户限制次数','规模状态'],
		                     	        colModel:[
		                     	            {name:'id',index:'id',editable: true,hidden:true},
		                     	            {name:'dis_order',index:'dis_order',width:70, editable:true},
		                     	            {name:'product_name',index:'product_name', width:70,editable: true},
		                     	            {name:'person_count',index:'person_count',width:70,editable: true},
		                     	            {name:'activity_price_reduce',index:'activity_price_reduce', width:70,editable:true},
		                     	            {name:'team_open_times',index:'team_open_times', width:80,editable: true},
		                     	            {name:'team_buy_times',index:'team_buy_times', width:80,editable: true},
		                     	            {name:'yxbz',index:'yxbz', width:150,editable: true,
		                     	            	formatter: function(cellvalue,options,rowObject){
		                     			            		if(rowObject[7]=='Y'){
		                     			        	    		return "开启";
		                     			        	    	}else{
		                     			        	    		return "关闭";
		                     			        	    	}
		                     	            	}
		                     	           },
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
	 	                     			editurl: "",
	 	                     	        loadComplete : function() {
	 	                     	            var table = this;
	 	                     	            setTimeout(function(){
	 	                     	            	updatePagerIcons(table);
	 	                     	                //enableTooltips(table);
	 	                     	            }, 0);
	 	                     	        },
	 	                     	        caption: "规模列表",
	 	                     	        autowidth: true
	 	                     	    }).trigger('reloadGrid');
		                     	    	
		                     	    initNavGrid(grid_selector,pager_selector);
		                     	    
	 	                     	    }else{
	 	                     	    	$(grid_selector).setGridParam( //G,P要大写
	                     	    		    {
	                     	    		    	url:"${CONTEXT_PATH}/teamBuyManage/teamProductScal?activity_product_id="+apid
	                     	    		    }
	 	                     	    	) .trigger("reloadGrid");
	 	                     	    }
		                     } else{
		                         $.alert('提示','查看详情失败 ！');
		                     }
	                 }
	           	});
	   		});	
	
	    
		//团购活动查看统计
	    $('#dataModal').on('show.bs.modal',function(e){
	        var $button=$(e.relatedTarget);
	        var id=$button.data("id");
	        var modal = $(this);
	        dataCount();
	    });
		
		//团购商品查看统计
	    $('#pro_dataModal').on('show.bs.modal',function(e){
	        var $button=$(e.relatedTarget);
	        var id=$button.data("id");
	        var modal = $(this);
	        $("#proId").val(id);
	        proDataCount(id);
	    });
	})

	function activityOpenOrClose(id,status){
		 $.ajax({
	        url:'${CONTEXT_PATH}/teamBuyManage/activityOpenOrClose',
	        type:'Get',
	        data:{id:id,status:status},
	        success:function(result){
	            if(result){
	            	alert(result.mes);
	            	jQuery("#grid-table").trigger("reloadGrid");
	            	jQuery("#grid-table1").trigger("reloadGrid");
	            }
	            else
	            {
	                alert('提示','查看详情失败 ！');
	            }
	        }
	     });  
	}
	
	function delProAndScaleRelevance(){
		var ids=$("#grid-table1").jqGrid("getGridParam","selarrrow");
		var rowData = $("#grid-table1").jqGrid('getRowData',ids);
		var status=rowData.status;
		if(status=="上架"||status=="下架"){
			alert("上架和下架的商品不能删除！");
			return;
		}
		if(ids==0){
	        alert("请先选择一行数据再进行操作！");
	        return;
	    }
		$.ajax({
	        type: "POST",
	        url:"${CONTEXT_PATH}/teamBuyManage/delProAndScaleRelevance?ids="+ids.join(),
	        success: function(data) {
	        	alert(data.mes);
	        	jQuery("#grid-table").trigger("reloadGrid");
	        	jQuery("#grid-table1").trigger("reloadGrid");
	        },
	        error: function(request) {
	            alert("Connection error");
	        },
	    });   
	}
	
	function productOpenOrClose(id,status,pro_f_id){
		if(pro_f_id==""||pro_f_id==null){
			alert("商品规格为空！");
			return;
		}else{
			$.ajax({
			       url:'${CONTEXT_PATH}/teamBuyManage/isSuccessTeam',
			       type:'Get',
			       data:{pf_id:pro_f_id},
			       success:function(result){
			           if(result){
				           	if(result.groupBooking.teamNum>0){
				           		var message=confirm("该商品当前有"+result.groupBooking.teamNum+"个团正在拼团,确认要下架吗?");
				           		if(message==false){
				           			return;
				           		}
				           	}else{
				           		if(status==0){
				           			var message=confirm("确定要下架此商品吗?");  
				           			if(message==false){
				           				return;
				           			}
				           		}
				           	}
			           	
				            $.ajax({
					            url:'${CONTEXT_PATH}/teamBuyManage/productOpenOrClose',
					            type:'Get',
					            data:{id:id,status:status},
					            success:function(result){
					                if(result){
					                	alert(result.mes);
					                	jQuery("#grid-table").trigger("reloadGrid");
					                	jQuery("#grid-table1").trigger("reloadGrid");
					                }
					                else
					                {
					                    alert('提示','查看详情失败 ！');
					                }
					          	 }
			       		    });   
			            }
			       }
			 });  
		}
	}
	
	function whenSubmit(){
		$("#editorText").val($(".ke-edit-iframe").contents().find("body").html());
		$("#activity_form").submit();
		//var editor=$("#editor").val();
		//var editor=K('#editor').html(111);
		//console.log(editor);
	}
	
	function eidtTeamProduct(){
		var activity_id=$("#activity_id_table").val();
		window.location.href="${CONTEXT_PATH}/teamBuyManage/initTeamProduct?activity_id="+activity_id;
	}
	
	function editHtml(id,status){
		if(status==1){
			window.location.href="${CONTEXT_PATH}/teamBuyManage/initTeamProduct?id="+id;
		}else{
			alert("上架和下架后的商品不能编辑数据！");
		}
	}
	
	
	function dataCount(){
		//统计
	    var createBeginTime=$("#createBeginTime").val();
	   	var createEndTime=$("#createEndTime").val();
	   	//查询统计数据
	  	$.ajax({
	         url:'${CONTEXT_PATH}/teamBuyManage/groupCount',
	         type:'Get',
	         data:{createBeginTime:createBeginTime,createEndTime:createEndTime},
	         success:function(result){
	             if(result){
	          	   $(".beginTourNum").html(result.beginTourNum);
	          	   $(".successTourNum").html(result.successTourNum);
	          	   $(".totalNum").html((result.totalNum)/100+"人民币");
	          	   $(".successOrderTotalNum").html(result.successOrderTotalNum);
	          	   var li="";
	          	   $.each( result.productOrderCount, function( key, obj ) {
	          		   var str="<li class='list-group-item'>"+obj.product_name+"<span>"+obj.xl+"</span></li>";
	          		   li+=str;
	          		 });
	          	   var lis="<li class='list-group-item'>拼团商品销售排序（TOP5）<span>销售订单数</span></li>"+li;
	          	   $(".product_xl").html(lis);
	             }
	             else
	             {
							
	             }
	          }
	     });
	}
	
	function proDataCount(id){
        var id1=$("#proId").val();
	    var createBeginTime=$("#createBeginTime1").val();
	   	var createEndTime=$("#createEndTime1").val();
	   	var data={};
	   	if(id!=undefined){
	   	 	data={id:id,createBeginTime:createBeginTime,createEndTime:createEndTime};
	   	}else{
	   		data={id:id1,createBeginTime:createBeginTime,createEndTime:createEndTime};
	   	} 
	   	//查询统计数据
 	  	 $.ajax({
 	         url:'${CONTEXT_PATH}/teamBuyManage/proSaltCount',
 	         type:'Get',
 	         data:data,
 	         success:function(result){
 	        	 if(result){
 	        		var str=""; 
                       $.each( result.teamBuyList, function( key, obj ) {
                             var markup="<tr><td>"+obj.person_count+"人团</td>"+
  							           "<td>"+obj.attendNum+"</td>"+
  							           "<td>"+obj.teamNum+"</td>"+
  							           "<td>"+obj.successNum+"</td>"+
  							           "<td>"+obj.failureNum+"</td>"+
 							           "<td>"+obj.teamingNum+"</td>"+
 							           "<td>"+obj.orders+"</td>"+
 							           "<td>"+obj.totalMoney+"</td>"+
  									   "</tr>"; 
  							 str+=markup;
                       });
  			              $('#pro_data tbody').html(str);
 	             }else{
 	                  $('#pro_data tbody').html('<td colspan="5" class="text-center">暂无数据</td>');
 	             }
 	         }
 	     }); 
	}
</script>