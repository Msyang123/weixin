<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >

	<div class="text-left" id="manual-send">
		<button class="btn btn-info btn-sm"
		onclick="window.location.href='${CONTEXT_PATH}/activityManage/manualReleaseCoupon'"> 手动发放优惠券</button>
	</div>
	
	<ul class="nav nav-tabs mt20" role="tablist">
		  <li class="nav-item active">
		    <a class="nav-link" data-toggle="tab" href="#coupon_scale" role="tab">优惠券规模管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#coupon_code" role="tab">优惠券兑换码管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#coupon_get" role="tab">领券活动管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#coupon_give" role="tab">返券活动管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#coupon_send" role="tab">发券活动管理</a>
		  </li>
	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
	
		<!--Begain coupon_scale-->
		<div class="tab-pane active clearfix" id="coupon_scale" role="tabpanel">
		
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="coupon_desc" name="coupon_desc" type="text" placeholder="请输入优惠券描述"/>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
				    </div>
				    
				    <div class="pull-right">	    	   
					    <button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/activityManage/initEditCouponScale'">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
						<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit('#grid-table');">
						    <i class="fa fa-edit bigger-110"></i> 编辑
						</button>
						<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDeleteCouponScale('#grid-table');">
						    <i class="fa fa fa-trash bigger-110"></i> 删除
						</button>
					</div>
				</form>
			</div>
			
			<div class="col-xs-12">
			    <!-- PAGE CONTENT BEGINS -->
			    <table id="grid-table"></table>
			    <div id="grid-pager"></div>
			    <!-- PAGE CONTENT ENDS -->
			</div><!-- /.col -->
		
		</div><!--/End coupon_scale-->

        <!--Begain coupon_code-->
        <div class="tab-pane clearfix" id="coupon_code" role="tabpanel">
		
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="main_title" name="main_title" type="text" placeholder="请输入活动名称"/>
					    <div class="input-group">
							  <input type="text" id="yxq_q_code" placeholder="开始时间" name="yxq_q"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
				        	至 <input type="text" id="yxq_z_code" placeholder="结束时间" name="yxq_z"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
					    </div>
					    <select id="yxbz" name="yxbz" class="form-control">
				    	    <option value="">请选择状态</option>
					    	<option value="Y">有效</option>
					    	<option value="N">无效</option>
					    </select>
					    <button class="btn btn-info btn-sm btn-clear" type="button">
						        <i class="fa fa-remove bigger-110"></i>     
						</button>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-code">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
				    </div>
				    
				    <div class="pull-right">	    	   
					    <button class="btn btn-warning btn-sm" type="button"  data-toggle="modal" data-target="#add_code">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
						<button class="btn btn-danger btn-sm" type="button" data-acid="${activity_id!}" onclick="confrimDel('#grid-table-code','${CONTEXT_PATH}/activityManage/delCouponCodeActivity',this)">
						    <i class="fa fa-trash bigger-110"></i> 删除
						</button>
					</div>
				</form>
			</div>
			
			<div class="col-xs-12">
			    <!-- PAGE CONTENT BEGINS -->
			    <table id="grid-table-code"></table>
			    <div id="grid-pager-code"></div>
			    <!-- PAGE CONTENT ENDS -->
			</div><!-- /.col -->
		
		</div><!--/End coupon_code-->

		<!--Begain coupon_get-->
		<div class="tab-pane clearfix" id="coupon_get" role="tabpanel">
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="main_title_getCoupon" name="main_title" type="text" placeholder="请输入活动名称"/>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-get">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
				    </div>
				    <div class="pull-right">	    	   
					    <button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/activityManage/initEditCouponActivity?activity_type=5'">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
						<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEditCounponActivity(null,'#grid-table-get');">
						    <i class="fa fa-edit bigger-110"></i> 编辑
						</button>
						<button class="btn btn-danger btn-sm" type="button"  onclick="confrimDel('#grid-table-get','${CONTEXT_PATH}/activityManage/delActivity',this)">
						    <i class="fa fa fa-trash bigger-110"></i> 删除
						</button>
					</div>
				</form>
			</div>
			
			<div class="col-xs-12">
			    <!-- PAGE CONTENT BEGINS -->
			    <table id="grid-table-get"></table>
			    <div id="grid-pager-get"></div>
			    <!-- PAGE CONTENT ENDS -->
			</div><!-- /.col -->
			
		</div><!--End coupon_get-->
		
		<!--Begain coupon_give-->
		<div class="tab-pane clearfix" id="coupon_give" role="tabpanel">
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="main_title" name="main_title" type="text" placeholder="请输入活动名称"/>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-give">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
				    </div>
				    
				    <div class="pull-right">	    	   
					    <button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/couponManage/editGiveCoupon'">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
						<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEditCounpon6Activity(null,'#grid-table-give');">
						    <i class="fa fa-edit bigger-110"></i> 编辑
						</button>
						<button class="btn btn-danger btn-sm" type="button"  onclick="confrimDel('#grid-table-give','${CONTEXT_PATH}/activityManage/delActivity',this)">
						    <i class="fa fa fa-trash bigger-110"></i> 删除
						</button>
					</div>
				</form>
			</div>
			
			<div class="col-xs-12">
			    <!-- PAGE CONTENT BEGINS -->
			    <table id="grid-table-give"></table>
			    <div id="grid-pager-give"></div>
			    <!-- PAGE CONTENT ENDS -->
			</div><!-- /.col -->
		
		</div><!--End  coupon_give-->
		
		<!--Begain coupon_send-->
		<div class="tab-pane clearfix" id="coupon_send" role="tabpanel">
			<div class="col-xs-12 wigtbox-head form-inline">
				<form id="submitForm">
				    <div class="pull-left">
					    <input class="form-control" id="giveCoupon_title" name="giveCoupon_title" type="text" placeholder="请输入活动名称"/>
					    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-send">
					        <i class="fa fa-search bigger-110"></i> 搜索    
					    </button> 
				    </div>
				    
				    <div class="pull-right">	    	   
					    <button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/couponManage/editOutCoupon'">
						    <i class="fa fa-plus bigger-110"></i> 添加
						</button>
						<button class="btn btn-info btn-sm" type="button"  onclick="editOutCounpon(null,'#grid-table-send');">
						    <i class="fa fa-edit bigger-110"></i> 编辑
						</button>
						<button class="btn btn-danger btn-sm" type="button"  onclick="confrimDel('#grid-table-send','${CONTEXT_PATH}/activityManage/delActivity',this)">
						    <i class="fa fa fa-trash bigger-110"></i> 删除
						</button>
					</div>
				</form>
			</div>
			
			<div class="col-xs-12">
			    <!-- PAGE CONTENT BEGINS -->
			    <table id="grid-table-send"></table>
			    <div id="grid-pager-send"></div>
			    <!-- PAGE CONTENT ENDS -->
			</div><!-- /.col -->
			
		</div><!--End coupon_send-->
    
    </div><!--End Tab-content-->

	<div class="modal fade" id="add_code" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
		                <h4 class="modal-title pull-left">新增/更改兑换码活动</h4>
		                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <div class="clearfix"></div>
		        </div>
	    		<div class="modal-body clearfix">
	    		     <form action="${CONTEXT_PATH}/acitivityManage/saveCodeActivity" class="form-horizontal" role="form" method="post" id="activity_code">
					    <input type="hidden" id="activity_id" name="activity_id" />
					    <input type="hidden" id="coupon_category_id" name="id" />
					    
					    <div class="form-group">
					       <label class="col-sm-3 control-label no-padding-right" for="main_title">名称</label>
					        <div class="col-sm-9">
					            <input type="text" id="main_title" name="main_title" class="col-xs-10 col-sm-5" required/>
					            <span class="tip">(*)</span>
					        </div>
					    </div>
					    
					    <div class="form-group">
		        			<label class="col-sm-3 control-label no-padding-right" for="yxq_q">开始时间节点</label>
					        <div class="col-sm-9">
					            <input type="text" id="yxq_q" name="yxq_q" 
					            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'yxq_z\')}'})" class="col-xs-10 col-sm-5" required/>
					            <span class="tip">(*)</span>
					        </div>
				    	</div>
				    	
					    <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">结束时间节点 </label>
					        <div class="col-sm-9">
					            <input type="text" id="yxq_z" name="yxq_z"   
					            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'yxq_q\')}'})" class="col-xs-10 col-sm-5" required/>
					            <span class="tip">(*)</span>
					        </div>
					    </div>
					    
					    <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right">关联优惠券</label>
					        <div class="col-sm-9">
					            <select id="coupon_scale_id" name="coupon_scale_id">
					               <#list scaleList as item>
	                                    <option value="${item.id}">${item.coupon_desc}</option>
	                               </#list>
	                             </select>
					        </div>
					    </div>
					    
					   <div class="form-group">
					    	<label class="col-sm-3 control-label no-padding-right" for="yxq">优惠券有效期</label>
					    	<div class="col-sm-9">
					    		<input type="number" id="yxq" name="yxq" class="col-sm-5 col-xs-10 digits" value="0"/>
					    	</div>
					    </div>
					    
					    <div class="form-group">
					    	<label class="col-sm-3 control-label no-padding-right" for="coupon_total">优惠券码数量</label>
					    	<div class="col-sm-9">
					    		<input type="number" id="coupon_total" name="coupon_total" class="col-sm-5 col-xs-10 digits" value="0"/>
					    	</div>
					    </div>			
					    
					    <div class="form-group">
					    	<label class="col-sm-3 control-label no-padding-right" for="coupon_total">用户限领次数</label>
					    	<div class="col-sm-9">
					    		<input type="number" id="user_gain_times" name="user_gain_times" class="col-sm-5 col-xs-10 digits" value="0"/>
					    	</div>
					    </div>				    
					</form>
			    </div>
			    <div class="modal-footer text-center">
	           		<button class="btn btn-info" type="button" id="btn-confirm" data-grid="#grid-table-code">确认</button>
	           </div>
	        </div>
	    </div>
	</div>

    <div class="modal fade" id="coupon_real" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog" style="width:800px;">
	        <div class="modal-content">
		        <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title">优惠券码列表</h4>
	            </div>
	        	<div class="modal-body">
					<div class="col-xs-12 wigtbox-head form-inline">
						<form id="submitForm">
						    <div class="pull-left">
						        <input type="hidden" id="activity_id" name="activity_id" value="${activity_id}"/>
						        <input type="hidden" name="category_id" id="category_id" />
						        
							    <input type="text" class="form-control" id="coupon_code" name="coupon_code" placeholder="请输入兑换码"/>
							    <select id="status" name="status" class="form-control">
						    	    <option value="">请选择状态</option>
							    	<option value="0">未领取</option>
							    	<option value="1">已领取</option>
							    	<option value="2">已使用</option>
							    </select>
							    <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-coupon">
							        <i class="fa fa-search bigger-110"></i> 搜索    
							    </button> 
						    </div>
						    
						    <div class="pull-right">	    	   
							    <button class="btn btn-success btn-sm btn-export" type="button" id="btn-export" data-grid="#grid-table-coupon" target="_blank">
								    <i class="fa fa-donwload bigger-110"></i> 导出
								</button>
							</div>
						</form>
					</div>
			
					<div class="col-xs-12">
					    <!-- PAGE CONTENT BEGINS -->
					    <table id="grid-table-coupon"></table>
					    <div id="grid-pager-coupon"></div>
					    <!-- PAGE CONTENT ENDS -->
					</div><!-- /.col -->
	        	</div>
	        	<div class="clearfix"></div>
	        	<div class="modal-footer text-center mt10">
	        	   <button class="btn btn-info btn-sm" type="button" data-dismiss="modal" aria-hidden="true"> 
	                  		确认
	               </button>
			    </div>
	        </div>
	    </div>
	</div>

	<div class="modal fade" id="coupon-stat" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog">
	        <div class="modal-content">
		        <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title">本期活动优惠券情况统计</h4>
	            </div>
	        	<div class="modal-body">
					<table class="table table-bordered" id="coupon-data">
					  <thead>
					    <tr>
					      <th>优惠券描述</th>
					      <th>领取数量</th>
					      <th>使用数量</th>
					      <th>使用订单总金额</th>
					    </tr>
					  </thead>
					  <tbody>
					  
					  </tbody>
					</table>
	        	</div>
	        	<div class="modal-footer">
	        	   <button class="btn btn-info btn-sm" type="button" data-dismiss="modal" aria-hidden="true"> 
	                  		确认
	               </button>
			    </div>
	        </div>
	    </div>
	</div>

<script>
	<#--优惠券规模管理-->
    function getSelRowToEdit(table_name){
        var selr = jQuery(table_name).getGridParam('selrow');
        if(!selr){
        	$.alert("提示","请先选择一行数据再编辑");
            return;
        }
        window.location.href="${CONTEXT_PATH}/activityManage/initEditCouponScale?id="+selr;
    }
    
    function getSelRowToDeleteCouponScale(table_name){
    	if(table_name!=null){
	    	var selr = jQuery(table_name).getGridParam('selrow');
	        if(!selr){
	        	$.alert("提示","请先选择一行数据再删除");
	            return;
	        }
	        if(confirm("您确认要删除该种优惠券规模吗？")){
	        	window.location.href="${CONTEXT_PATH}/activityManage/deleteCouponScale?id="+selr;
	        }
    	}else{
    		if(confirm("您确认要删除该种优惠券规模吗？")){
	        	window.location.href="${CONTEXT_PATH}/activityManage/deleteCouponScale?id="+id;
	        }
    	}
    }
    <#--优惠券活动编辑(领券/返券)-->
	function getSelRowToEditCounponActivity(id,table_name){
		if(table_name!=null){
	        var selr = jQuery(table_name).getGridParam('selrow');
	        if(!selr){
	        	$.alert("提示","请先选择一行数据再编辑");
	            return;
	        }
        	window.location.href="${CONTEXT_PATH}/activityManage/initEditCouponActivity?id="+selr;
		}else{
			window.location.href="${CONTEXT_PATH}/activityManage/initEditCouponActivity?id="+id;
		}
    }
    
    
    <#--发券活动编辑-->
	function editOutCounpon(id,table_name){
		var a="";
		if(table_name!=null){
	        var selr = jQuery(table_name).getGridParam('selrow');
	        if(!selr){
	        	$.alert("提示","请先选择一行数据再编辑");
	            return;
	        }
	        a=selr;
		}else{
			a=id;
		}
		//判断编辑是否产生业务数据
		 $.ajax({
				type: "Get",
	            url: "${CONTEXT_PATH}/couponManage/isData",
	            data:{id:a},
	            success: function(result){
	            	if(result.success==true){
	            		window.location.href="${CONTEXT_PATH}/couponManage/editOutCoupon?id="+a;
	            	}else{
	            		$.alert("提示",result.msg);
	            	}
	            }
			});
    }
	
	<#--返券活动编辑-->
	function getSelRowToEditCounpon6Activity(id,table_name){
		if(table_name!=null){
	        var selr = jQuery(table_name).getGridParam('selrow');
	        if(!selr){
	            $.alert("提示","请先选择一行数据再编辑");
	            return;
	        }
        	window.location.href="${CONTEXT_PATH}/couponManage/editGiveCoupon?id="+selr;
		}else{
			window.location.href="${CONTEXT_PATH}/couponManage/editGiveCoupon?id="+id;
		}
    }
    
</script>
</@layout>

<script type="text/javascript">
jQuery(function($) {
	
	var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";
    
    var grid_selector_code="#grid-table-code";
    var pager_selector_code="#grid-pager-code"; 
    
    var grid_selector_get = "#grid-table-get";
    var pager_selector_get = "#grid-pager-get";
    
    var grid_selector_give = "#grid-table-give";
    var pager_selector_give = "#grid-pager-give";
    
    var grid_selector_send = "#grid-table-send";
    var pager_selector_send = "#grid-pager-send";
    
    var grid_selector_coupon = "#grid-table-coupon";
    var pager_selector_coupon = "#grid-pager-coupon";
    
    jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getCouponScaleJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','优惠券编号','优惠券描述','满减金额', '优惠券面值','是否有效'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                }
            },
            {name:'id',index:'id', width:90, editable: true},
            {name:'coupon_desc',index:'coupon_desc',width:90, editable:true, sorttype:"date"},
            {name:'min_cost',index:'min_cost', width:150,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'coupon_val',index:'coupon_val', width:90,editable: true},
            {name:'is_valid',index:'is_valid', width:90,editable: false,editoptions:{value:"Y:有效;N:无效"}},
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
                enableTooltips(table);
            }, 0);
        },
        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "优惠券规模管理",
        autowidth: true
    });
    
    jQuery(grid_selector_code).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getCouponCodeActivity",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','活动名称','优惠券描述','有效时间起','有效时间止','优惠券码数量','状态','操作','',''],
        colModel:[
            {name:'id',index:'id', editable: true},
            {name:'main_title',index:'main_title',editable: true},
            {name:'coupon_desc',index:'coupon_desc',editable: true},
            {name:'yxq_q',index:'yxq_q', editable:true, sorttype:"date"},
            {name:'yxq_z',index:'yxq_z',editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'coupon_total',index:'coupon_total',editable: false},
            {name:'yxbz',index:'yxbz',editable: false,
            	formatter:function(cellvalue,options,rowObject){
            		switch(cellvalue){
            		    case "Y":
	            			return "开启";
	            			break;
            		    case "N":
	            		    return "关闭";
	            		    break;
            		}
                }
            },
            {name: 'myac', index: '',fixed: true, sortable: false, resize: false,    
                formatter: function(cellvalue,options,rows){
                	//var acid=$('#activity_id').val();
                	if(rows[6] == "Y"){
	               		return  '<a class="btn btn-danger btn-xs mr5" title="关闭活动" data-grid="grid-table-code" onclick =ChangeStatus('+rows[0]+',"'+rows[6]+'",this,"${CONTEXT_PATH}/activityManage/changeCodeStatus")><i class="fa fa-cloud-download"></i></a>'+
	               		    '<a class="btn btn-info btn-xs mr5" title="查看兑换码"  data-toggle="modal" data-target="#coupon_real" data-id="'+rows[0]+'" data-category-id="'+rows[8]+'"><i class="fa fa-ticket"></i></a>'+    
	               		    '<a class="btn btn-warning btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已开启的活动,需先关闭再编辑")><i class="fa fa-edit"></i></a>'+
			                '<a class="btn btn-danger btn-xs mr5" title="删除" data-categoryid="'+rows[8]+'" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>';
	               	}else{
			    	    return '<a class="btn btn-success btn-xs mr5" title="开启活动" data-grid="grid-table-code" onclick = ChangeStatus('+rows[0]+',"'+rows[6]+'",this,"${CONTEXT_PATH}/activityManage/changeCodeStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
			    	    '<a class="btn btn-info btn-xs mr5" title="查看兑换码"  data-toggle="modal" data-target="#coupon_real" data-id="'+rows[0]+'" data-category-id="'+rows[8]+'"><i class="fa fa-ticket"></i></a>'+
			    	    '<a class="btn btn-warning btn-xs mr5" title="修改" data-toggle="modal" data-target="#add_code" data-id="'+rows[0]+'" ><i class="fa fa-edit"></i></a>'+		                
		                '<a class="btn btn-danger btn-xs mr5" title="删除" data-categoryid="'+rows[8]+'"  onclick=confrimDel("#grid-table-code","${CONTEXT_PATH}/activityManage/delCouponCodeActivity",this)><i class="fa fa-trash"></i></a>';
			        }
                }
            },
            {name:'coupon_category_id',index:'coupon_category_id',editable : false,hidden:true},
            {name:'activity_type',index:'activity_type',editable : false,hidden:true}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_code,
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
        editurl: "${CONTEXT_PATH}/activityManage/edit",
        caption: "兑换码优惠券管理",
        autowidth: true,
        sortname:'id',
        sortorder:'desc'
    });
    
    jQuery(grid_selector_coupon).jqGrid({
        //postData:{'category_id':$("#category_id").val()},
        url:"${CONTEXT_PATH}/activityManage/getCouponRealCode",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['优惠券码','优惠券状态','用户手机号','使用时间'],
        colModel:[
            {name:'coupon_code',index:'coupon_code',editable: false},
            {name:'status',index:'status',editable: false,
            	formatter:function(cellvalue,options,rows){
            		switch(cellvalue){
            		    case "0":
	            			return "未领取";
	            			break;
            		    case "1":
	            		    return "已领取";
	            		    break;
            		    case "2":
	            			return "已使用";
	            			break;
            			default:
            		    return "N/A";
            		}
                }
            },
            {name:'phone_num',index:'phone_num',editable: false,
            	formatter:function(cellvalue,options,rows){
	                if(!cellvalue){return "N/A";}
	                return cellvalue;
                }
            },
            {name:'used_time',index:'used_time',editable: false,
            	formatter:function(cellvalue,options,rows){
	                if(!cellvalue){return "N/A";}
	                return cellvalue;
                }
            }
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_coupon,
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
        /*editurl: "${CONTEXT_PATH}/activityManage/edit",*/
        caption: "优惠券兑换码管理",
        autowidth: false,
        width:743
    });
    
    jQuery(grid_selector_get).jqGrid({
        postData:{'activity_type':'5'},
        url:"${CONTEXT_PATH}/activityManage/getCouponActivityJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','活动开始时间','活动结束始时间', '活动名称','链接地址','是否有效','操作',''],
        colModel:[
            {name:'id',index:'id', editable: true},
            {name:'yxq_q',index:'yxq_q', editable:true, sorttype:"date"},
            {name:'yxq_z',index:'yxq_z',editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'main_title',index:'main_title',editable: true},
            {name:'url',index:'url',editable: false},
            {name:'yxbz',index:'yxbz',editable: false,
            	formatter:function(cellvalue,options,rowObject){
            		switch(cellvalue){
            		    case "Y":
	            			return "开启";
	            			break;
            		    case "N":
	            		    return "关闭";
	            		    break;
            		}
                }
            },
            {name: 'myac', index: '',fixed: true, sortable: false, resize: false,    
                formatter: function(cellvalue,options,rowObject){ 
                	if(rowObject[5] == "Y"){
				    	return '<a class="btn btn-danger btn-xs mr5" title="关闭活动" data-grid="grid-table-get" onclick =ChangeStatus('+rowObject[0]+',"'+rowObject[5]+'",this,"${CONTEXT_PATH}/activityManage/openOrCloseActivity")><i class="fa fa-cloud-download"></i></a>'+
			    		'<a class="btn btn-info btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已开启的活动,需先关闭再编辑")><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-success btn-xs mr5" title="统计"  data-toggle="modal" data-target="#coupon-stat" data-id="'+rowObject[0]+'"><i class="fa fa-line-chart"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>';
                	}else{
                		return '<a class="btn btn-success btn-xs mr5" title="开启活动" data-grid="grid-table-get" onclick = ChangeStatus('+rowObject[0]+',"'+rowObject[5]+'",this,"${CONTEXT_PATH}/activityManage/openOrCloseActivity")><i class="fa fa-cloud-upload"></i></a>'+ 
			    		'<a class="btn btn-info btn-xs mr5" title="修改" onclick="getSelRowToEditCounponActivity('+rowObject[0]+',null);"><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-success btn-xs mr5" title="统计"  data-toggle="modal" data-target="#coupon-stat" data-id="'+rowObject[0]+'"><i class="fa fa-line-chart"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=confrimDel("#grid-table-get","${CONTEXT_PATH}/activityManage/delActivity",this) ><i class="fa fa-trash"></i></a>';
                	}
			    }  
            },
            {name:'yxbz',index:'yxbz',editable: false,hidden:true}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_get,
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
        editurl: "${CONTEXT_PATH}/activityManage/edit",
        caption: "领券活动管理",
        autowidth: true
    });
    
    jQuery(grid_selector_give).jqGrid({
        postData:{'activity_type':'6'},
        url:"${CONTEXT_PATH}/activityManage/getCouponActivityJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','活动开始时间','活动结束始时间', '活动名称','链接地址','是否有效','操作',''],
        colModel:[
            {name:'id',index:'id', editable: true},
            {name:'yxq_q',index:'yxq_q', editable:true, sorttype:"date"},
            {name:'yxq_z',index:'yxq_z',editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'main_title',index:'main_title',editable: true},
            {name:'url',index:'url',editable: false},
            {name:'yxbz',index:'yxbz',editable: false,
            	formatter:function(cellvalue,options,rowObject){
            		switch(cellvalue){
            		    case "Y":
	            			return "开启";
	            			break;
            		    case "N":
	            		    return "关闭";
	            		    break;
            		}
                }
            },
            {name: 'myac', index: '',fixed: true, sortable: false, resize: false,    
                formatter: function(cellvalue,options,rowObject){ 
                	if(rowObject[5]=="Y"){
                		return '<a class="btn btn-danger btn-xs mr5" title="关闭活动" data-grid="grid-table-give" onclick =ChangeStatus('+rowObject[0]+',"'+rowObject[5]+'",this,"${CONTEXT_PATH}/activityManage/openOrCloseActivity")><i class="fa fa-cloud-download"></i></a>'+
                		'<a class="btn btn-info btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已开启的活动,需先关闭再编辑")><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-success btn-xs mr5" title="统计"  data-toggle="modal" data-target="#coupon-stat" data-id="'+rowObject[0]+'"><i class="fa fa-line-chart"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>';
                	}else{
				    	return '<a class="btn btn-success btn-xs mr5" title="开启活动" data-grid="grid-table-give" onclick = ChangeStatus('+rowObject[0]+',"'+rowObject[5]+'",this,"${CONTEXT_PATH}/activityManage/openOrCloseActivity")><i class="fa fa-cloud-upload"></i></a>'+ 
				    	'<a class="btn btn-info btn-xs mr5" title="修改" onclick="getSelRowToEditCounpon6Activity('+rowObject[0]+',null);"><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-success btn-xs mr5" title="统计"  data-toggle="modal" data-target="#coupon-stat" data-id="'+rowObject[0]+'"><i class="fa fa-line-chart"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=confrimDel("#grid-table-give","${CONTEXT_PATH}/activityManage/delActivity",this)><i class="fa fa-trash"></i></a>';
                	}
			    }  
            },
            {name:'activity_type',index:'activity_type', editable: true,hidden:true}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_give,
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
        editurl: "${CONTEXT_PATH}/activityManage/e",
        caption: "返券活动管理",
        autowidth: true
    });
    
    jQuery(grid_selector_send).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getCouponActivityJson?activity_type=17",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','活动名称','活动开始时间','活动结束始时间', '链接地址','是否有效','福利码','操作',''],
        colModel:[
            {name:'id',index:'id', editable: true,hidden:true},
            {name:'main_title',index:'main_title',editable: true,width:90},
            {name:'yxq_q',index:'yxq_q', editable:true, sorttype:"date"},
            {name:'yxq_z',index:'yxq_z',editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'url',index:'url',editable: false,width:450},
            {name:'yxbz',index:'yxbz',editable: false,width:50,
            	formatter:function(cellvalue,options,rowObject){
            		switch(cellvalue){
            		    case "Y":
	            			return "开启";
	            			break;
            		    case "N":
	            		    return "关闭";
	            		    break;
            		}
                }
            },
            {name:'receive_code',index:'receive_code',editable: false,width:100},
            {name: 'myac', index: '',fixed: true, sortable: false, resize: false,    
                formatter: function(cellvalue,options,rowObject){ 
                	if(rowObject[5]=="Y"){
                		return'<a class="btn btn-danger btn-xs mr5" title="关闭活动" data-grid="grid-table-send" onclick =ChangeStatus('+rowObject[0]+',"'+rowObject[5]+'",this,"${CONTEXT_PATH}/activityManage/changeCodeStatus")><i class="fa fa-cloud-download"></i></a>'+ 
                		'<a class="btn btn-info btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已开启的活动,需先关闭再编辑")><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-success btn-xs mr5" title="统计"  data-toggle="modal" data-target="#coupon-stat" data-id="'+rowObject[0]+'"><i class="fa fa-line-chart"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>';
                	}else{
                		return '<a class="btn btn-success btn-xs mr5" title="开启活动" data-grid="grid-table-send" onclick = ChangeStatus('+rowObject[0]+',"'+rowObject[5]+'",this,"${CONTEXT_PATH}/activityManage/changeCodeStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
                		'<a class="btn btn-info btn-xs mr5" title="修改" onclick="editOutCounpon('+rowObject[0]+',null);"><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-success btn-xs mr5" title="统计"  data-toggle="modal" data-target="#coupon-stat" data-id="'+rowObject[0]+'"><i class="fa fa-line-chart"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=confrimDel("#grid-table-send","${CONTEXT_PATH}/activityManage/delActivity",this)><i class="fa fa-trash"></i></a>';
                	}
			    }  
            },
            {name:'activity_type',index:'activity_type', editable: true,hidden:true}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_send,
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
        editurl: "${CONTEXT_PATH}/activityManage/e",
        caption: "发券活动管理",
        autowidth: true
    });
    
    initNavGrid(grid_selector,pager_selector);
    initNavGrid(grid_selector_get,pager_selector_get);
    initNavGrid(grid_selector_give,pager_selector_give);
    initNavGrid(grid_selector_send,pager_selector_send);
    initNavGrid(grid_selector_coupon,pager_selector_coupon);
    
    //优惠券码导出
    $('#btn-export').on('click',function(e){
        var _this=$(this);
        var gridName=_this.data('grid');
        
        var jsonArray=[];
        var array=_this.parents("form#submitForm").serializeArray();
        
        for(let i=0;i<array.length;i++){
        	var jsonObj=new Object();
        	jsonObj[array[i].name]=array[i].value;
        	jsonArray.push(jsonObj);
        }
        
        var formData=JSON.stringify(jsonArray);
        console.log(formData);
        
        var colNames=JSON.stringify($(gridName).getGridParam().colNames);
        var colModel=JSON.stringify($(gridName).getGridParam().colModel);
	    window.location.href=
   	    encodeURI("${CONTEXT_PATH}/activityManage/exportCouponCode?formData="+formData
					+"&colNames="+colNames
					+"&colModel="+colModel
	    ); 
    });
    
    //优惠券兑换码管理弹窗
    $('#coupon_real').on('show.bs.modal',function(e){
  	    var $button=$(e.relatedTarget);
        var modal=$(this);
        var id=$button.data("id");
        var coupon_category_id=$button.data("category-id");
        modal.find('#category_id').val(coupon_category_id);
        modal.find('#activity_id').val(id);
        //需要手动触发一遍搜索，因为页面加载时category_id没赋值
        modal.find(".btn-search").trigger("click");
    });
    
    //兑换码活动新增或修改
    $('#add_code').on('show.bs.modal',function(e){
  	   var $button=$(e.relatedTarget);
        var modal=$(this);
        var id=$button.data("id");
        
        if(id==null||id==""){
        	  //新增放开限制
        	  modal.find("#yxq").attr('disabled',false);
              modal.find("#coupon_total").attr('disabled',false);
              modal.find("#coupon_scale_id").attr('disabled',false);
              //添加直接show
              $('#activity_code')[0].reset();
		      //隐藏字段也清除掉
		      $('#coupon_category_id').val("");
            return;
        }else{
	          //发送ajax回去查询单条数据
	          $.ajax({
	                url:'${CONTEXT_PATH}/activityManage/codeDetail',
	                type:'Get',
	                data:{id:id},
	                success:function(result){
	                    if(result.success==true){
	                        //回填数据
	                        modal.find("#main_title").val(result.data.main_title);
	                        modal.find('#yxq_q').val(result.data.yxq_q);
	                        modal.find("#yxq_z").val(result.data.yxq_z);
	                        modal.find("#yxq").val(result.data.yxq);
	                        modal.find("#coupon_total").val(result.data.coupon_total);
	                        modal.find("#coupon_scale_id").val(result.data.coupon_scale_id);
	                        modal.find("#coupon_category_id").val(result.data.id);
	                        modal.find("#activity_id").val(result.data.activity_id);
	                        modal.find("#user_gain_times").val(result.data.user_gain_times);
	                        //不允许修改此3项数据
	                        modal.find("#yxq").attr('disabled',true);
	                        modal.find("#coupon_total").attr('disabled',true);
	                        modal.find("#coupon_scale_id").attr('disabled',true);
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
       
    //兑换码活动提交
    $('#btn-confirm').on('click',function(){
    	var modal=$('#add_code');
    	var grid=$('#grid-table-code');
    	var total=$('#coupon_total').val();
    	var yxq=$('#yxq').val();
    	   	
        //表单校验
        var validetor=$('#activity_code').validate({
        	rules: {
        		main_title:{
        			required:true,
        			maxlength:20
        		},
        		yxq_q:{
        			required:true,
        		},
        		yxq_z:{
        			required:true,
        		},
        		yxq:{
        			required:true,
        			digits:true
        		},
        		coupon_total:{
        			required:true,
        			digits:true
        		}
        	},
        	messages:{
        		main_title:{
        			required:"请输入名称",
        			maxlength:"最多输入20个字符"
        		},
        		yxq_q:{
        			required:"请输入开始时间",
        		},
        		yxq_z:{
        			required:"请输入结束时间",
        		},
                yxq:{
                   required:"请输入有效期",
                   digits:"请输入正整数"
        		},
        		coupon_total:{
        		   required:"请输入优惠券数量",
        		   digits:"请输入正整数"
        		}
        	},
        });
        
        if(!validetor.form()){     
        	return false;
        }
        
        if(yxq<=0){
        	$.alert('提示',"有效期至少为1天");
    		return false;
        }
        
        if(total<=0){
        	$.alert('提示',"请至少生成一张优惠券");
    		return false;
    	}
          	
        var formData=$('#activity_code').serialize();
        console.log(formData);
        //Ajax提交表单数据
        $.ajax({
              url:'${CONTEXT_PATH}/activityManage/saveCodeActivity',
              type:'Post',
              data:formData,
              success:function(result){
                  if(result.success){
                	  //关闭modal
                      modal.modal('hide');
                      $.alert('提示', result.msg);
                      //刷新grid
                      grid.trigger("reloadGrid");
                  }
                  else
                  {
                  	  modal.modal('hide');
                      $.alert('提示',result.msg);
                  }
              }
        });
        
    }); 
        
	//领券活动查看统计
    $('#coupon-stat').on('show.bs.modal',function(e){
          var $button=$(e.relatedTarget);
          var id=$button.data("id");
          var modal = $(this);
          console.log(id);
          //查询统计数据
       	  $.ajax({
              url:'${CONTEXT_PATH}/couponManage/analysisCoupon',
              type:'Get',
              data:{id:id},
              success:function(result){
                  if(result){
                  	$('#coupon-data tbody').find('tr').remove();
                      for(let i=0;i<result.length;i++){
                          var markup='<tr>'+
 							           '<td>'+result[i].coupon_desc+'</td>'+
 							           '<td>'+result[i].give_num+'</td>'+
 							           '<td>'+result[i].use_num+'</td>'+
 							           '<td>'+result[i].total_money+'</td>'+
 									   '</tr>';
 			                $('#coupon-data tbody').append(markup);
                      }                    
                  }
                  else
                  {
                      $('#coupon-data tbody').append('<td colspan="5" class="text-center">暂无数据</td>');
                  }
               }
          });
     });
});
</script>