<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<div class="col-xs-12 seed-buy">

      <!--Begin Seed-->
	  <div class="clearfix" id="seed">
	      <div class="col-xs-12 nopd-lr wigtbox-head form-inline">
				<form id="submitForm">
				    <input type="hidden" id="activity_type" name="activity_type" value="18" />
				    <div class="pull-left">
					    <input type="text" name="seed_name" id="seed_name" class="form-control" placeholder="种子名称"/>
					    <button class="btn btn-info btn-sm btn-clear" type="button">
						        <i class="fa fa-remove bigger-110"></i>     
						</button>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-seed">
					        <i class="fa fa-search bigger-110"></i> 搜索     
					    </button>
				    </div>
				    
				    <div class="pull-right">
					    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" data-target="#add_seed">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
					</div>
				</form>
			</div>
			
			<div class="col-xs-12 nopd-lr">
			    <!--Table Begin -->
			    <table id="grid-table-seed"></table>
			    <div id="grid-pager-seed"></div>			   
			</div><!--/.col -->   
	  
	  </div><!--/End Seed-->
	  
	  <!--Begin Activity-->
	  <div class="mt20 clearfix" id="activity">
		     <div class="col-xs-12 nopd-lr wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="main_title" name="main_title" type="text" placeholder="活动标题"/>
					    
					    <div class="input-group">
							  <input type="text" id="yxq_q" placeholder="开始时间" name="yxq_q"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
				        	至 <input type="text" id="yxq_z" placeholder="结束时间" name="yxq_z"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
					    </div>
					    
					    <select id="yxbz" name="yxbz" class="form-control">
				    	    <option value="">请选择状态</option>
					    	<option value="Y">开启</option>
					    	<option value="N">关闭</option>
					    </select>
					    <button class="btn btn-info btn-sm btn-clear" type="button">
						        <i class="fa fa-remove bigger-110"></i>     
						</button>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-activity">
					        <i class="fa fa-search bigger-110"></i> 搜索     
					    </button>
				    </div>
				    
				    <div class="pull-right">
					    <button class="btn btn-warning btn-sm" type="button"  onclick="initEdit()">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>	
						<button class="btn btn-danger btn-sm" type="button" id="btn-del" onclick="confrimDel('#grid-table-activity','${CONTEXT_PATH}/seedManage/delActivityAjax',this)">
						    <i class="fa fa-trash bigger-110"></i> 删除
						</button>			
					</div>
				</form>
			</div>
			
			<div class="col-xs-12 nopd-lr">
			    <!--Table Begain -->
			    <table id="grid-table-activity"></table>
			    <div id="grid-pager-activity"></div>			   
			</div><!-- /.col --> 
			
	  </div><!--/End Activity>
	  
	  <!--Begin ExchangeRecord-->
	  <div class="mt20 clearfix" id="exchange_records">
		     <div class="col-xs-12 nopd-lr wigtbox-head form-inline">
		     <form id="submitForm">
				   <div class="pull-left">
					    <input class="form-control" id="nickname" name="nickname" type="text" placeholder="用户昵称"/>
					    <div class="input-group">
							  <input type="text" id="createBeginTime" placeholder="开始时间" name="createBeginTime"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
				        	至 <input type="text" id="createEndTime" placeholder="结束时间" name="createEndTime"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
					    </div>
					    <select id="activity_id" name="activity_id" class="form-control">
				    	    <option value="" selected>活动名称</option>
				    	    <#list allActivity as item>
				    	        <option value="${item.id}">${item.main_title}</option>
				    	    </#list>
					    </select>
					    <select id="exchange_type" name="exchange_type" class="form-control">
				    	    <option value="" selected>兑换种类</option>
				    	    <option value="D">单品</option>
				    	    <option value="T">套餐</option>
					    </select>
					    <button class="btn btn-info btn-sm btn-clear" type="button">
						    <i class="fa fa-remove bigger-110"></i>     
						</button>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-exchange">
					        <i class="fa fa-search bigger-110"></i> 搜索     
					    </button>
				    </div>
				    
				    <div class="pull-right">
					    <button class="btn btn-success btn-sm btn-export" type="button"  id="btn-export" target="_blank" data-grid="#grid-table-exchange">
						    <i class="fa fa-download bigger-110"></i> 导出
						</button>	
					</div>
				</form>
			</div>
			
			<div class="col-xs-12 nopd-lr">
			    <!--Table Begain -->
			    <table id="grid-table-exchange"></table>
			    <div id="grid-pager-exchange"></div>			   
			</div><!-- /.col --> 
			
	  </div><!--/End ExchangeRecord -->
	  
	  <div class="panel panel-primary text-center mt20">
		      <div class="panel-heading">手动发放种子</div>
			  <div class="panel-body">
			       <form id="excelForm" calss="form-horzital" method="post" enctype="multipart/form-data" target="frmright">
						<a href="发种子模板.xlsx" download="发种子模板.xlsx" class="form-group">下载excel文件模版</a>
						<div style="color:red">注意：下载好模板后，在模板里加完名单后，记得将“电话号码”列设置为“文本”格式，否则将无法发放！！！</div>
						<div class="form-group"  style="padding-top:40px">
							<label class="col-sm-3 control-label text-right" for="file_path">导入发放名单：</label>
							<div class="col-sm-4 text-left input-group">
					       		<input class="form-control" id="file_path" name="file_path" readonly="true" value="${(image.save_string)!}" required/>				       
								<span class="input-group-btn"><button class="btn btn-sm" type="button" id="export_excel">导入excel</button></span>
				        	</div>
						</div>
				  </form>
				  
				  <div class="form-group form-inline">
				        <label class="col-sm-3 control-label text-right">发放种子： </label>
				        <div class="col-sm-9 seed-exchanges nopd-lr text-left">
				            <div class="seed-exchange">
					            <select id="seed_type" class="seed-type form-control" name="seed_type">
					        		<#list seedType as item>
					        			<option value="${item.id}">${item.seed_name}</option>
					        		</#list>    		
					        	</select>
					        	<div class="input-group">
					        	    <input type="text" name="seed_num" class="form-control" placeholder="数量" required/>
					        	</div>
					         </div>
					         
					         <div class="text-left"><button type="button" class="btn btn-info btn-sm" id="btn-seed"><i class="fa fa-plus"></i></button></div>
				          </div>
				    </div>
				    
					<div class="form-group">
						<div class="col-12 text-center">
							<button class="btn btn-info" type="button" id="release_coupon">
								提交
							</button>
							<button class="btn" data-dismiss="modal" aria-hidden="true">
								取消
							</button>
						</div>
					</div>
			  </div>
		  </div>

</div>

<div class="modal fade" id="add_seed" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
			<div class="modal-content">
	            <div class="modal-header">
	                <h4 class="modal-title pull-left">新增/更改种子</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	            </div>
	            <div class="modal-body">
	               <form id="seed_types" class="form-horizontal" method="post" action="${CONTEXT_PATH}/seedManage/saveSeedType">
	    	            <input type="hidden" name="seedType.activity_id" value="22"/>
	    	            <input type="hidden" name="seedType.id"  id="seed_id" />
	    	            
				        <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right" for="seed_name">名称</label>
					        <div class="col-sm-9">
					            <input type="text" id="seed_name" name="seedType.seed_name" class="form-control" />
					        </div>
					    </div>
					    
				        <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right" for="order_id">显示顺序 </label>
					        <div class="col-sm-9">
					            <input type="text" id="order_id" name="seedType.order_id" class="col-xs-10 col-sm-5" />
					        </div>
					    </div>
					    
					    <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right" for="url">种子图片</label>
					        <div class="col-sm-9 clearfix">
						        <input type="hidden" id="image_src" name="image_src" onerror="imgLoad(this)" />
						        <img id="url" src=""/>
						        <p class="text-muted">推荐使用尺寸为200X200 (单位:px)</p>
								<input type="button" id="image" value="选择图片" />
					        </div>
					    </div>	
					    				   
				    </form>  
			   </div>
			    <div class="modal-footer text-center">	           		
	           		<button class="btn btn-info" type="button" id="btn-save">确认</button>
		        </div>
	        </div>                                    
                                                       
    </div>
</div>

<div class="modal fade" id="activity_statistics" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" style="width:800px">
			<div class="modal-content">
	            <div class="modal-header">
	                <h4 class="modal-title pull-left">活动数据统计</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	            </div>
	           <div class="modal-body clearfix">
	               <input type="hidden" name="activity_id" id="activity_id" value="0"/>
	               <div class="col-xs-12 nopd-lr wigtbox-head form-inline">
					    <div class="pull-left">
						    <div class="input-group">
								  <input type="text" id="start_time" placeholder="开始时间" name="start_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
					        	至 <input type="text" id="end_time" placeholder="结束时间" name="end_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
						    </div>
					    </div>
					    <div class="pull-right">
					        <button class="btn btn-primary btn-sm" type="button" id="btn-statistic">
						        <i class="fa fa-search bigger-110"></i> 搜索     
						    </button>
						</div>
					</div>
					
					<table class="table table-hover table-bordered" id="seed_statistic">
					     <thead>
					          <tr>
					            <th>用户领取总数</th>
					            <th>购物赠送总数</th>
					            <th>分享赠送总数</th>
					            <th>兑换单品总数</th>
					            <th>兑换套餐总数</th>
					            <th>兑换商品总金额（元）</th>
					          </tr>
					     </thead>
					     <tbody>
					         <tr>
					            <td>14352</td>
					            <td>2674</td>
					            <td>655</td>
					            <td>18</td>
					            <td>4</td>
					            <td>12415</td>
					         </tr>
					     </tbody>
					</table>
					
					<div class="row">
						<div class="col-sm-6 nopd-lr">
							<div id="seed_chart" style="width:384px; height: 200px; margin: 0 auto; clear: both;"></div>
						</div>
						<div class="col-sm-6">
						    <table class="table table-hover table-bordered" id="seed_receive">
							    <thead>
						          <tr>
						            <th>种子类型</th>
						            <th>用户领取数</th>
						          </tr>
						     </thead>
						     <tbody>
						         <tr>
						            <td>初春种子</td>
						            <td>0</td>
						         </tr>
						          <tr>
						            <td>盛夏种子</td>
						            <td>0</td>
						         </tr>
						          <tr>
						            <td>金秋种子</td>
						            <td>14352</td>
						         </tr> 
						         <tr>
						            <td>暖冬种子</td>
						            <td>0</td>
						         </tr>
						          <tr>
						            <td>神秘种子</td>
						            <td>0</td>
						         </tr>
						     </tbody>
						    </table>
		               </div>
	                </div>
	                
	                <div class="row">
		                <div class="col-sm-6 nopd-lr">
							    <div id="single_chart" style="width:384px; height: 200px; margin: 0 auto; clear: both;"></div>
			            </div>
			            <div class="col-sm-6">
						    <table class="table table-hover table-bordered" id="seed_single">
							    <thead>
						          <tr>
						            <th>单品名称</th>
						            <th>兑换数量</th>
						          </tr>
						     </thead>
						     <tbody>
						         <tr>
						            <td>菠萝蜜一盒</td>
						            <td>2</td>
						         </tr>
						          <tr>
						            <td>炎阳黄桃5KG装</td>
						            <td>5</td>
						         </tr>
						          <tr>
						            <td>安慕希一箱</td>
						            <td>11</td>
						         </tr> 
						     </tbody>
						    </table>
		               </div>
		            </div>
		            
		            <div class="row">
						<div class="col-sm-6 nopd-lr">
						    <div id="combo_chart" style="width:384px; height: 200px; margin: 0 auto; clear: both;"></div>
		                </div>
		                <div class="col-sm-6">
						    <table class="table table-hover table-bordered" id="seed_combo">
							    <thead>
						          <tr>
						            <th>套餐名称</th>
						            <th>兑换数量</th>
						          </tr>
						     </thead>
						     <tbody>
						         <tr>
						            <td>究极无敌套餐</td>
						            <td>2</td>
						         </tr>
						         <tr>
						            <td>心中MMP套餐</td>
						            <td>105205</td>
						         </tr>
						     </tbody>
						    </table>
		               </div>
	                </div>
			   </div>
			   <div class="modal-footer text-center">
	           		<button type="button" class="btn btn-info" data-dismiss="modal" id="btn-close">确认</button>
		      </div>
	        </div>
         
    </div>
</div>

<div class="modal fade" id="result_modal" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog">
			<div class="modal-content">
	            <div class="modal-header">
	                <h4 class="modal-title pull-left">发送结果</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	            </div>
	            <div class="modal-body">
	               <p>已根据名单发放，成功发放 <span class="red js-success" style="font-size:18px;"></span> 条&nbsp;&nbsp;失败 <span class="red js-fail" style="font-size:18px;"></span> 条</p>
			       <p>发放失败号码：</p>
			       <ul class="fail-list"></ul>
			   </div>
			    <div class="modal-footer text-center">	           		
	           		<button class="btn btn-info" type="button" data-dismiss="modal" id="btn-close">确认</button>
		        </div>
	        </div>                                    
    </div>
</div>

<script>
    function editById(id){
        window.location.href="${CONTEXT_PATH}/seedManage/seedEdit?id="+id;
    }
    
    function initEdit(){
    	window.location.href='${CONTEXT_PATH}/seedManage/seedEdit';
    }  
</script>
</@layout>

<script>
KindEditor.ready(function(K) {
 	var editor = K.editor({
		cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
		uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=种子购活动',
		fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=种子购活动',
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
					K('#image_src').val(url);//图片地址存储
					K('#url').attr("src",url);//显示图片
					editor.hideDialog(); //隐藏弹窗
				}
			});
		});
	});

	var fileEditor = K.editor({
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/uploadExcel?dir=file&idName=file',
			//fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=手动发放优惠券活动',
			//allowFileManager : true,
	});
		
	//给按钮添加click事件
	K("#export_excel").click(function(){
		fileEditor.loadPlugin('image', function() {
			//图片弹窗的基本参数配置
			fileEditor.plugin.imageDialog({
				imageUrl : K('#file_path').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
				//点击弹窗内”确定“按钮所执行的逻辑
				clickFn : function(url, title, width, height, border, align) {
					K('#file_path').val(url);//图片地址存储
					fileEditor.hideDialog(); //隐藏弹窗
				}
			});
		});
	});
});

jQuery(function($) {
	var grid_selector_activity = "#grid-table-activity";
	var pager_selector_activity = "#grid-pager-activity";

	var grid_selector_seed="#grid-table-seed";
	var pager_selector_seed="#grid-pager-seed";

	 //为兑换纪录表渲染准备
	var grid_selector_exchange="#grid-table-exchange";
	var pager_selector_exchange="grid-pager-exchange";
	
    //数据统计模块
	var seedChart = echarts.init(document.getElementById('seed_chart'));
	var singleChart = echarts.init(document.getElementById('single_chart'));
	var comboChart = echarts.init(document.getElementById('combo_chart'));
	var legendArr=[];
	var seriesData=[{name:"初春种子",value:"0"},{name:"盛夏种子",value:"0"},{name:"金秋种子",value:"14352"},
	                {name:"暖冬种子",value:"0"},{name:"神秘种子",value:"0"}];
    var singleData=[{name:"菠萝蜜一盒",value:"2"},{name:"炎阳黄桃5KG装",value:"5"},{name:"安慕希一箱",value:"11"}];
    var comboData=[{name:"究极无敌套餐",value:"2"},{name:"心中MMP套餐",value:"105205"}];

	<#list seedType as item>
	     legendArr.push("${item.seed_name}");
	</#list>
	
	var seedOpt = {
		    title : {
		        text: '种子具体领取情况占比图',
		        subtext: '',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: []
		    },
		    series : [
		        {
		            name: '所占百分比',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data: seriesData,
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
    };

	var singleOpt = {
		    title : {
		        text: '单品兑换明细占比图',
		        subtext: '',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: []
		    },
		    series : [
		        {
		            name: '所占百分比',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data: [],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
     };
	
	 var comboOpt = {
		    title : {
		        text: '套餐兑换明细占比图',
		        subtext: '',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: []
		    },
		    series : [
		        {
		            name: '所占百分比',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data: [],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
    };
		
	seedChart.setOption(seedOpt);
	singleChart.setOption(singleOpt);
	comboChart.setOption(comboOpt);
	
	jQuery(grid_selector_seed).jqGrid({
        url:"${CONTEXT_PATH}/seedManage/getSeedTypeList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','顺序','名称', '是否有效','操作'],
        colModel:[           
            {name:'seed_type.id',index:'id',editable: true},
            {name:'seed_type.order_id',index:'order_id',editable:true},
            {name:'seed_type.seed_name',index:'seed_name',editable:true,editoptions:{size:"20",maxlength:"30"}},
            {name:'seed_type.status',index:'status',editable: false,
            	formatter:function(cellvalue,options,rows){
               	    //console.log(cellvalue);
               	    if(rows[3]=="Y"){
                        return "上架";
                    }else{
                   	    return "下架";
                    }
                }
            },
            {name:'myac', index:'', fixed:true, sortable:false, resize:false,
            	formatter:function(cellvalue,options,rows){
	            	if(rows[3] == "Y"){
	               		return  '<a class="btn btn-danger btn-xs mr5" title="下架种子" data-grid="grid-table-seed" onclick =ChangeStatus('+rows[0]+',"'+rows[3]+'",this,"${CONTEXT_PATH}/seedManage/changeSeedTypeStatus")><i class="fa fa-cloud-download"></i></a>'+
			                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已上架的单品,需先下架再编辑")><i class="fa fa-edit"></i></a>';
	               	}else{
					    	return  '<a class="btn btn-success btn-xs mr5" title="上架种子" data-grid="grid-table-seed" onclick = ChangeStatus('+rows[0]+',"'+rows[3]+'",this,"${CONTEXT_PATH}/seedManage/changeSeedTypeStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
			                '<a class="btn btn-warning btn-xs mr5" title="修改" data-id="'+rows[0]+'" data-toggle="modal" data-target="#add_seed"><i class="fa fa-edit"></i></a>';
	               	}
                }
            }
        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : pager_selector_seed,
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
	        editurl: "${CONTEXT_PATH}/seedManage/gDSaveSeedType",
	        caption: "种子管理",
	        autowidth: true,
	        shrinkToFit:true
	});   
	
	jQuery(grid_selector_activity).jqGrid({
        url:"${CONTEXT_PATH}/seedManage/getSeedActivitysJson?activity_type="+jQuery('#activity_type').val(),
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','活动主标题','活动副标题','开始时间','结束时间', '链接地址','有效标志','操作'],
        colModel:[
            {name:'ac.id',index:'id', editable: true},
            {name:'ac.main_title',index:'main_title', editable:true, sorttype:"date"},
            {name:'ac.subheading',index:'subheading',editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'ac.yxq_q',index:'yxq_q', editable:false, sorttype:"date"},
            {name:'ac.yxq_z',index:'yxq_z', editable:false, sorttype:"date"},
            {name:'ac.url',index:'url',editable: true},
            {name:'ac.yxbz',index:'yxbz',editable: false,
            	formatter:function(cellvalue,options,rows){
               	    //console.log(cellvalue);
               	    if(rows[6]=="Y"){
                        return "开启";
                    }else{
                   	    return "关闭";
                    }
                }
            },
            {name:'ac.myac',index:'', fixed:true, sortable:false, resize:false,
                formatter:function(cellvalue, options, rows) { 
                    //console.log(rows[6]);
	               	if(rows[6] == "Y"){
	               		return  '<a class="btn btn-danger btn-xs mr5" title="关闭活动" data-grid="grid-table-activity" onclick =ChangeStatus('+rows[0]+',"'+rows[6]+'",this,"${CONTEXT_PATH}/seedManage/changeStatus")><i class="fa fa-cloud-download"></i></a>'+
			                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick="editById('+rows[0]+')"><i class="fa fa-edit"></i></a>'+
			                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>'+
			                '<a class="btn btn-default btn-xs" title="数据统计" data-toggle="modal" data-target="#activity_statistics" data-start-time="'+rows[3]+'" data-id="'+rows[0]+'"><i class="fa fa-line-chart"></i></a>';
	               	}else{
					    	return  '<a class="btn btn-success btn-xs mr5" title="开启活动" data-grid="grid-table-activity" onclick = ChangeStatus('+rows[0]+',"'+rows[6]+'",this,"${CONTEXT_PATH}/seedManage/changeStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
			                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick="editById('+rows[0]+')"><i class="fa fa-edit"></i></a>'+
			                '<a class="btn btn-danger btn-xs mr5" title="删除" data-acid="'+rows[0]+'" onclick=confrimDel("#grid-table-activity","${CONTEXT_PATH}/seedManage/delActivityAjax",this)><i class="fa fa-trash"></i></a>'+
			                '<a class="btn btn-default btn-xs" title="数据统计" data-toggle="modal" data-target="#activity_statistics" data-start-time="'+rows[3]+'" data-id="'+rows[0]+'"><i class="fa fa-line-chart"></i></a>';
	               	}
			    }
            }         
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_activity,
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
        editurl: "${CONTEXT_PATH}/seedManage/gDSaveSeedActivity",
        caption: "活动管理",
        autowidth: true
	});
    
    
    	   
    jQuery(grid_selector_exchange).jqGrid({
        url:"${CONTEXT_PATH}/seedManage/exchangeRecord",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','用户昵称','联系电话','兑换时间','领取时间','关联活动名称','兑换种类', '兑换奖品名称'],
        colModel:[
            {name:'id',index:'id',editable: false},
            {name:'nickname',index:'nickname',editable:false},
            {name:'phone_num',index:'phone_num',editable:false,},
            {name:'create_time',index:'create_time',editable:false},
            {name:'recieve_time',index:'recieve_time',editable:false,
	            formatter:function(cellvalue, options, rows){
		            //console.log(cellvalue);
                          if(cellvalue.indexOf('/')>=0){
                             return "N/A";
                          }else{
                             return cellvalue;
                          }
		        }
		    },
            {name:'main_title',index:'main_title',editable:false},
            {name:'exchange_type',index:'exchange_type',editable:false,
            	 formatter:function(cellvalue, options, rows){
                           if(cellvalue=="D"){
                              return "单品";
                           }else{
                              return "套餐";
                           }
			     }
	        },
            {name:'record_name',index:'record_name',editable: false}
        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : pager_selector_exchange,
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
	        editurl: "",
	        caption: "兑奖记录管理",
	        autowidth: true,
	        shrinkToFit:true
        });
        
		initNavGrid(grid_selector_seed,pager_selector_seed);
		initNavGrid(grid_selector_activity,pager_selector_activity);		  
	    initNavGrid(grid_selector_exchange,pager_selector_exchange);

         $('#btn-export').on('click',function(e){
                var _this=$(this);
                var gridName=_this.data('grid');
                var formData=JSON.stringify(_this.parents("form#submitForm").serializeArray());
                var colNames=JSON.stringify($(gridName).getGridParam().colNames);
                var colModel=JSON.stringify($(gridName).getGridParam().colModel);
       	        window.location.href=
           	    encodeURI("${CONTEXT_PATH}/seedManage/exportExchange?formData="+formData
       					+"&colNames="+colNames
       					+"&colModel="+colModel
       			);
         });
		
		 //种子发放管理新增或修改
	     $('#add_seed').on('show.bs.modal',function(e){
	     	   var $button=$(e.relatedTarget);
	           var modal=$(this);
	           var id=$button.data("id");
	           
	           //如果有id值则为修改,否则为新增
	           if(id==null||id==""){
	               //添加直接show
	               $('#seed_types')[0].reset();
	 		       //隐藏字段也清除掉
	 		       $('#seed_id').val("");
	 		       $('#image_src').val("");
	               return;
	           }else{
	 	          //发送ajax回去查询单条数据
	 	          $.ajax({
	 	                url:'${CONTEXT_PATH}/seedManage/seedTypeDetail',
	 	                type:'Get',
	 	                data:{id:id},
	 	                success:function(result){
	 	                    if(result.success){
	 	                        //回填种子数据
	 	                        modal.find('#seed_id').val(result.data.id);
	 	                        modal.find("#seed_name").val(result.data.seed_name);
	 	                        modal.find("#order_id").val(result.data.order_id);
	 	                        modal.find("#image_src").val(result.image.save_string);
	 	                        modal.find("#url").attr("src",result.image.save_string);
	 	                    }
	 	                    else
	 	                    {
	 	                        $.alert('提示','查看失败 ');
	 	                    }
	 	                }
	 	          });
	           }
	    });
	       
		//种子类型管理编辑提交 
	    $('#btn-save').on('click',function(){
		    $('#seed_types').submit();
		}); 
		
		$('#release_coupon').on('click',function(){
			var file_path = $("#file_path").val();
			if(file_path==""||$('input[name^="seed_num"]').val()==""){
                $.alert("提示","请先上传excel文件和填写完整发送的种子信息");
                return false;
		    }
			//兑换种子数组
		    var seedArray=new Array();
		    var seedNodes=$(this).parents('.panel-body').find('.seed-exchange');
		    var len=seedNodes.length;
		    var seed=new Object();
		    for(var i=0;i<len;i++){
		        var obj=new Object();
		        var seedType=seedNodes.eq(i).find('.seed-type').val();
		        var seedNum=seedNodes.find('input[name="seed_num"]').val();
		        if(seedNum==''){
		        	seedNum=0;
		        	continue;
		        }
		        obj.seedType=seedType;
		        obj.seedNum=seedNum;
		        seedArray.push(obj);
		    }
		    console.log(JSON.stringify(seedArray));
		   
		    $.ajax({
				url:"${CONTEXT_PATH}/seedManage/sendSeed",
				data:{file_path:file_path,seedArray:JSON.stringify(seedArray)},
				success:function(result){
					 //后台返回发送结果
					 if(result){
						 var list=result.fail_phone;
						 var markup="";
						 $('#result_modal').find('.js-success').text(result.successNum);
						 $('#result_modal').find('.js-fail').text(result.failNum);
						 for(let i=0;i<list.length;i++){
                             markup+='<li>'+list[i]+'</li>';
					     }
					     $('#result_modal').find('.fail-list').append(markup);
				     }
					 $('#result_modal').modal('show');
		       	}
			}); 
		});
		
		$('.seed-exchanges').on('click','.btn-remove',function(e){
            var $remove=$(e.currentTarget);
            $remove.parents('.seed-exchange').remove();
        });

		$('#btn-seed').on('click',function(){
            var existNum=$('.seed-exchange').length;
            var removeBtn='<span class="input-group-btn">'+
		        	        '<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>'+
		        	     '</span>';
		        	     
            var markup='<div class="seed-exchange">'+
		            '<select id="seed_type" class="seed-type form-control" name="seed_type">'+
		        		<#list seedType as item>
		        			'<option value="${item.id}">${item.seed_name}</option>'+
		        		</#list>       		
		        	'</select> '+
		        	'<div class="input-group">'+
		        	    '<input type="text" name="seed_num" class="form-control" placeholder="数量" required />'+
		        	     (existNum>=1?removeBtn:"")+
		        	'</div>'+
		         '</div>';
		         
		      if(existNum>=10){
		        $.dialog.alert('请不要超过10个');
		         return false;
		      }   
		      $(this).parent().before(markup);	          
       });

       $('#activity_statistics').on('show.bs.modal',function(e){
              var $button=$(e.relatedTarget);
              var modal=$(this);
              var now=new Date().pattern("yyyy-MM-dd HH:mm:ss");
              var startTimeDef=$button.data("start-time");
              var id=$button.data("id");
              console.log(id);
              modal.find('#start_time').val(startTimeDef);
              modal.find('#end_time').val(now);
              modal.find('#activity_id').val(id);
              //默认搜索从活动开始时间到当前系统时间的数据
              $('#btn-statistic').trigger("click");
       });

       $('#btn-statistic').on('click',function(e){
              var startTime=$('#start_time').val();
              var endTime=$('#end_time').val();
              var acid=$(this).parents('.modal-body').find('#activity_id').val();
              console.log(acid);
              //可能需要校验开始和结束时间
              //发送Ajax回去请求数据
              $.ajax({
	                url:'${CONTEXT_PATH}/seedManage/seedCount',
	                type:'Get',
	                data:{start_time:startTime,end_time:endTime,id:acid},
	                success:function(result){
	                	var totalTable=$('#seed_statistic').find('tbody');
	                	var seedGetTable=$('#seed_receive').find('tbody');
	                	var singleTable=$('#seed_single').find('tbody');
		                var comboTable=$('#seed_combo').find('tbody');
                        debugger;
	                    if(result){
	                    	var markup="",markup2="",markup3="",markup4="";
	                    	var legendArr=[],legendSingle=[],legendCombo=[];
	 		                var seriesData=[],singleData=[],comboData=[];
		                   //清除上次查询结果
		                   totalTable.find('tr').html("");
		                   seedGetTable.html("");
		                   singleTable.html("");
		                   comboTable.html("");
		                   //领取总数统计
		                   for(let i=0;i<result.staTotalList.length;i++){
		                	   markup+='<td>'+result.staTotalList[i].value+'</td>';
			               }
		                 
			               for(let x=0;x<result.staSeedGetList.length;x++){
			            	   markup2+='<tr><td>'+result.staSeedGetList[x].name+'</td>'+
			            	   '<td>'+result.staSeedGetList[x].value+'</td></tr>';
			            	   seriesData.push(result.staSeedGetList[x]);
				           }

				           for(let y=0;y<result.staSeedSingleList.length;y++){
				        	   markup3+='<tr><td>'+result.staSeedSingleList[y].name+'</td>'+
			            	   '<td>'+result.staSeedSingleList[y].value+'</td></tr>';
				        	   singleData.push(result.staSeedSingleList[y]);
					       }

					       for(let z=0;z<result.staSeedComboList.length;z++){
					    	   markup4+='<tr><td>'+result.staSeedComboList[z].name+'</td>'+
			            	   '<td>'+result.staSeedComboList[z].value+'</td></tr>';
					    	   comboData.push(result.staSeedComboList[z]);
						   }
			               //填充表格数据
		                   totalTable.find('tr').append(markup);
		                   seedGetTable.append(markup2);
		                   singleTable.append(markup3);
		                   comboTable.append(markup4);

		                   //绘制饼图
		                   seedOpt.series[0].data=seriesData;
		                   seedOpt.legend.data=result.seedType;
		                   
			               singleOpt.series[0].data=singleData;
			               singleOpt.legend.data= result.singleList;
			               
				           comboOpt.series[0].data=comboData;
				           comboOpt.legend.data=result.comboList;
				           
		                   seedChart.setOption(seedOpt);
		        		   singleChart.setOption(singleOpt);
		        		   comboChart.setOption(comboOpt);
	                    }
	                    else
	                    {
	                        $.alert('提示','查询失败 ！');
	                    }
	                }
	          }); 
       });
		
});
</script>
