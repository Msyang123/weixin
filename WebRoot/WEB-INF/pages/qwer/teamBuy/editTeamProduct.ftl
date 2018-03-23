<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/teamBuyManage/saveTeamProduct" class="form-horizontal" role="form" method="post">
    <input type="hidden" id="activity_product_id" name="activity_product_id" value="${(activityProduct.id)!}"/>
    <input type="hidden" name="activityProduct.activity_id" 
    <#if activity_id ??>
    	value="${activity_id}";
    <#else>
    	value="${(activityProduct.activity_id)!}"
    </#if>
    	/>
    <div class="form-group">
       <label class="col-sm-3 control-label no-padding-right" for="product_name">商品排序</label>

        <div class="col-sm-9">
            <input type="text"  name="activityProduct.dis_order" 
            value="${(activityProduct.dis_order)!}"
             placeholder="商品排序" class="col-xs-10 col-sm-5" />
        </div>
    </div>
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">关联商品</label>

        <div class="col-sm-9">
            <input id="product_name1" type="text" readonly value="${(product_name)!}" />
            <input id="product_id" name="activityProduct.product_id" type="hidden" readonly value="${(activityProduct.product_id)!}" />
            <input id="product_fid" name="activityProduct.product_f_id" type="hidden" readonly value="${(activityProduct.product_f_id)!}" />
            <input id="activity_price" name="activity_price" type="hidden" readonly value="${(activityProduct.price)!}" />
            <button class="btn btn-info btn-sm cm3" type="button" title="关联商品" data-toggle="modal" data-target="#dataModal">
		        <i class="fa fa-search bigger-110"></i> 搜索    
		    </button>
        </div>
    </div>				
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="product_name">拼团开始时间</label>

        <div class="col-sm-9">
            <input type="text" id="up_time" placeholder="拼团开始时间" name="activityProduct.up_time" value="${(activityProduct.up_time)!}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="product_name">拼团结束时间</label>

        <div class="col-sm-9">
           <input type="text" id="down_time" placeholder="拼团结束时间" name="activityProduct.down_time" value="${(activityProduct.down_time)!}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
        </div>
    </div>
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
        <#if activityProduct?? && activityProduct.status!=1>
        <#else>
            <button class="btn btn-info btn-sm" type="button" onclick="whenSubmit();">
               		 提交
            </button>
        </#if>
            <button class="btn btn-sm" type="button" onclick="history.go(-1);">
                	取消
            </button>
        </div>
    </div>
    
</form>

<!--关联商品查询Modal -->
<div class="modal fade" id="dataModal" tabindex="-1" role="dialog" aria-labelledby="dataModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">关联商品查询</h4>
      </div>
      <div class="modal-body">
      	    <div class="clearfix mb20">
				<div class="pull-left">
					<input type="text" id="product_code" placeholder="商品编码" name="product_code" />
		        	<input type="text" id="product_name" placeholder="商品名称" name="product_name" />
				    <button class="btn btn-info btn-sm cm3" type="button" onclick="jQuery('#grid-table1')
		                .setGridParam({postData:{'product_name':$('#product_name').val(),
			                'product_code':$('#product_code').val()}})
			                .trigger('reloadGrid');">
				        <i class="fa fa-search bigger-110"></i> 搜索    
				    </button> 
			    </div>
			</div>
			
			<div class="row">
			<!-- 关联商品表格 -->
				<div class="col-xs-12">
				    <!-- PAGE CONTENT BEGINS -->
				    <table id="grid-table1"></table>
				    <div id="grid-pager1"></div>
				    <!-- PAGE CONTENT ENDS -->
				</div>
			</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info" data-dismiss="modal" onclick="receiveData()">确认</button>
      </div>
    </div>
  </div>
</div>

<!--product_f table-->
<div class="row">
	<div class="col-xs-12 wigtbox-head form-inline pt40">
	    <div class="pull-right">	
			<button class="btn btn-warning btn-sm" type="button" title="添加/编辑拼团规模" data-toggle="modal" data-target="#editModal">
			 <i class="fa fa-plus bigger-110"></i>   
			    新增
			</button>
	    	<button class="btn btn-danger btn-sm" type="button"  onclick="delScale()">
			 <i class="fa fa-close bigger-110"></i>  
			    删除
			</button>    	   
		</div>
	</div>
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        <table id="grid-table"></table>
        <div id="grid-pager"></div>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->
<!--product_f table-->

<!--新增/编辑团购规模Model-->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
           <h4 class="modal-title">添加/编辑拼团规模</h4>
      </div>
      <div class="modal-body">
      	    <div class="form-horizontal detail-form">
			     <div class="form-group">
                       <label class="col-md-3 no-padding-right">排序 ：</label>
			           <div class="col-md-8">
			           		<input type="hidden" id="team_scale_id" name="team_scale_id" />
			            	<input type="text" id="dis_order" name="teamScals.dis_order" class="activity-name form-control" />
			            	<!-- <input type="text" id="activity_name1" > -->
			           </div>
			     </div>  				     
			     <div class="form-group">
                       <label class="col-md-3 no-padding-right">拼团人数：</label>
			           <div class="col-md-8">
							<input type="text" id="person_count" name="teamScals.person_count" class="activity-name form-control" />
			           </div>
			     </div> 
				 <div class="form-group">
				       <label class="col-md-3 no-padding-right control-label" for="url">商品单价：</label>
				
				       <div class="col-sm-8">
				       	<input type="text" id="activity_price_reduce" name="teamScals.activity_price_reduce" class="activity-name form-control" />
				       </div>
				 </div>
				 <div class="form-group">
			        <label class="col-sm-3 control-label no-padding-right" for="url">每日开团数：</label>
			        <div class="col-sm-8">
				         <input type="text" id="team_open_times" name="teamScals.team_open_times" class="col-sm-2 mr12 gain_money_times" />
						 <div class="checkbox-inline col-sm-3">
						   <label>
						       <input type="checkbox" id="openCheckbox"> 不限制 
						   </label>
						 </div>
			        </div>
			    </div>
			    <div class="form-group">
			        <label class="col-sm-3 control-label no-padding-right" for="url">用户限制次数：</label>
			        <div class="col-sm-8">
				         <input type="text" id="team_buy_times" name="teamScals.team_buy_times" class="col-sm-2 mr12 gain_money_times" />
						 <div class="checkbox-inline col-sm-3">
						   <label>
						       <input type="checkbox" id="buyCheckbox"> 不限制 
						   </label>
						 </div>
			        </div>
			    </div>
			    <div class="clearfix form-actions">
			        <div class="col-md-offset-3 col-md-9">
			        	<button class="btn btn-sm" type="button" data-dismiss="modal" aria-hidden="true">
			                		取消
			            </button>
			            <button class="btn btn-info btn-sm" type="button" onclick="whenSubmit1();">
			                      	提交
			            </button>
			        </div>
   				 </div>
			</div>
       </div>
    </div>
  </div>
</div>
</@layout>

<script>
$(function(){
openCheckbox();
buyCheckbox();
//编辑回填数据
$('#editModal').on('show.bs.modal',function(e){
      var $button=$(e.relatedTarget);
      var id=$button.data("id");
      var modal = $(this);
      //发送ajax回去查询单条数据
      $.ajax({
            url:'${CONTEXT_PATH}/teamBuyManage/eidtProductScals',
            type:'Get',
            data:{id:id},
            success:function(result){
                if(result){
                    //回填数据
                    modal.find('#dis_order').val(result.teamScals.dis_order);
                    modal.find('#person_count').val(result.teamScals.person_count);
                    modal.find('#activity_price_reduce').val(result.teamScals.activity_price_reduce);
                    if(result.teamScals.team_open_times==9999){
	                    $("#openCheckbox").attr('checked',true);  
	        			$("#team_open_times").attr("disabled",true);
	        			$("#team_open_times").val("");
                    }else{
                    	modal.find('#team_open_times').val(result.teamScals.team_open_times);
                    	openCheckbox();
                    }
                    
                    if(result.teamScals.team_buy_times==9999){
	                    $("#buyCheckbox").attr('checked',true);  
	        			$("#team_buy_times").attr("disabled",true);
	        			$("#team_buy_times").val("");
                    }else{
                    	modal.find('#team_buy_times').val(result.teamScals.team_buy_times);
                    	buyCheckbox();
                    }
                    modal.find('#team_scale_id').val(result.teamScals.id); 
                }
                else
                {
                    alert('提示','查看详情失败 ！');
                }
            }
      });
});
})

function openCheckbox(){
	$("#openCheckbox").change(function() { 
		if($(this).is(':checked')) {
		    $("#team_open_times").attr("disabled",true);
		    $("#team_open_times").val("");
		}else{
			$("#team_open_times").attr("disabled",false);
		}
	}); 
}

function buyCheckbox(){
	$("#buyCheckbox").change(function() { 
		if($(this).is(':checked')) {
		    $("#team_buy_times").attr("disabled",true);
		    $("#team_buy_times").val("");
		}else{
			$("#team_buy_times").attr("disabled",false);
		}
	}); 
}
	
function whenSubmit1(){
	var dis_order=$("input[name='teamScals.dis_order']").val();
	var person_count=$("input[name='teamScals.person_count']").val();
	var activity_price_reduce=$("input[name='teamScals.activity_price_reduce']").val();
	var team_open_times=$("input[name='teamScals.team_open_times']").val();
	var team_buy_times=$("input[name='teamScals.team_buy_times']").val();
	var activity_product_id=$("input[name='activity_product_id']").val();
	var product_id=$("#product_id").val();
	var team_scale_id=$("#team_scale_id").val();
	var data={dis_order:dis_order,person_count:person_count,activity_price_reduce:activity_price_reduce,activity_product_id:activity_product_id, 
			team_open_times:team_open_times,team_buy_times:team_buy_times,product_id:product_id,team_scale_id:team_scale_id};
	  $.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/teamBuyManage/saveProduct",
        data:data,
        success: function(data) {
        	alert(data.mes);
        	window.location.href="${CONTEXT_PATH}/teamBuyManage/initTeamProduct?id="+data.id;
        },
        error: function(request) {
            //alert("Connection error");
        },
    });  
}

function receiveData(){
	var ser = jQuery("#grid-table1").getGridParam('selrow');
	var rowData = $("#grid-table1").jqGrid('getRowData',ser);
	var product_name=rowData.product_name;
	var product_fid=rowData.product_fid;
	var activity_price=rowData.price;
	var id=rowData.id
	$("#product_id").val(id);
	$("#product_name1").val(product_name);
	$("#product_fid").val(product_fid);
	$("#activity_price").val(activity_price);
	
}

//提交表单
function whenSubmit(){
	var up_time=$("#up_time").val();
	var down_time=$("#down_time").val();
	if(up_time==null||up_time==""){
		alert("拼团商品开始时间不能为空！");
		return;
	}
	if(down_time==null||down_time==""){
		alert("拼团商品结束时间不能为空！");
		return;
	}
	 var html=$(".ke-edit-iframe").contents().find("body").html(); 
    $(".form-horizontal").submit(); 
}

function scaleOpenOrClose(id,status){
	$.ajax({
        url:'${CONTEXT_PATH}/teamBuyManage/scaleOpenOrClose',
        type:'Get',
        data:{id:id,status:status},
        success:function(result){
            if(result){
            	alert(result.mes);
            	jQuery("#grid-table").trigger("reloadGrid");
            }
            else
            {
                alert('提示','查看详情失败 ！');
            }
        }
  }); 
}

function delScale(){
	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
	//var rowData = $("#grid-table").jqGrid("getRowData",id)
	if(ids==0){
        alert("请先选择一行数据再进行操作！");
        return;
    }
	 $.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/teamBuyManage/delScale?ids="+ids.join(),
        success: function(data) {
        	alert(data.mes);
        	jQuery("#grid-table").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    }); 
}


jQuery(function($) {
	var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";
    var activity_product_id=$("#activity_product_id").val();

    jQuery(grid_selector).jqGrid({
        postData:{activity_product_id:$("#activity_product_id").val()},
        url:"${CONTEXT_PATH}/teamBuyManage/teamProductScal",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['id','商品名称','顺序','拼团人数','商品单价','每日开团数',  '用户限制次数','规模状态','操作'],
        colModel:[
            {name:'id',index:'id', width:150,sorttype:"int", editable: false},
            {name:'product_name',index:'product_name', width:70,editable: true},
            {name:'dis_order',index:'dis_order',width:90, editable:true},
            {name:'person_count',index:'person_count',width:150,editable: true},
            {name:'activity_price_reduce',index:'activity_price_reduce', width:150,editable:true},
            {name:'team_open_times',index:'team_open_times', width:150,editable: true},
            {name:'team_buy_times',index:'team_buy_times', width:150,editable: true},
            {name:'yxbz',index:'yxbz', width:150,editable: true,
            	formatter: function(cellvalue,options,rowObject){
		            		if(rowObject[7]=='Y'){
		        	    		return "开启";
		        	    	}else{
		        	    		return "关闭";
		        	    	}
            		       }
            	},
            {name:'myac',index:'', fixed:true, sortable:false, resize:false,
                formatter: function(cellvalue,options,rowObject){
                	var myacStr;
                	var value = rowObject[7];
                	var id = rowObject[0];
                	if(value == 'Y'){
                		myacStr = '<a class="btn btn-success btn-xs mr5" title="下架" onclick=scaleOpenOrClose('+id+',"'+value+'")><i class="fa fa-cloud-download"></i></a>'+
				         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" data-toggle="modal" data-target="#editModal" data-id="'+id+'"><i class="fa fa-edit"></i></a>';
                	}else{
                		myacStr = '<a class="btn btn-danger btn-xs mr5" title="上架" onclick=scaleOpenOrClose('+id+',"'+value+'")><i class="fa fa-cloud-upload"></i></a>'+
				         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" data-toggle="modal" data-target="#editModal" data-id="'+id+'"><i class="fa fa-edit"></i></a>';
                	}
				    return myacStr;
			    }
            }
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
            }, 0);
        },
        caption: "规模列表",
        autowidth: true
    });

    initNavGrid(grid_selector,pager_selector);
});

//商品关联列表
jQuery(function($) {
	var grid_selector = "#grid-table1";
    var pager_selector = "#grid-pager1";
	
	$('#dataModal').on('show.bs.modal',function(e){
		
    
    });
	
	jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/teamBuyManage/initSelectTeamProduct",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:["","","商品编号",'商品名称','商品单位','商品价格','是否上架'],
        colModel:[
            {name:'id',index:'id', width:150,editable: true,hidden:true},
            {name:'product_fid',index:'product_fid', width:30,editable: true,hidden:true},
           	{name:'product_code',index:'product_code',width:100, editable:true},
            {name:'product_name',index:'product_name',width:90, editable:true},
            {name:'unit_name',index:'unit_name', width:70,editable: true},
            {name:'price',index:'price',width:150,editable: true},
            {name:'is_vlid',index:'is_vlid', width:150,editable:true}
        ],

        viewrecords : true,
        rowNum:10,
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
            }, 0);
        },
        caption: "商品管理",
        autowidth: false,
        width:564
    });
	
	initNavGrid(grid_selector,pager_selector);
});

</script>