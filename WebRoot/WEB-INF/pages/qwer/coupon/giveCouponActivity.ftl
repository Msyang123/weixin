<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js",
"${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js",
"${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css",
"${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >

<form class="form-horizontal" role="form" method="post" id="give_coupon">
	<input type="hidden" id="activity_id" name="activity_id" value="${(activity.id)!}"/>
	<input type="hidden" id="activity_type" name="activity_type" value="${(activity.activity_type)!'6'}"/>
	
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">活动名称： </label>
        <div class="col-sm-9">
            <input type="text" id="main_title" name="main_title" value="${(activity.main_title)!}"  placeholder="活动主标题" class="col-xs-10 col-sm-5" />
        </div> 
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">编号：</label>
        <div class="col-sm-9">
            <input type="text" id="id" name="id" placeholder="活动编号,系统自动生成" value="${(activity.id)!}"  readonly="readonly" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">活动开始时间：</label>
        <div class="col-sm-9">
            <input type="text" id="yxq_q" name="yxq_q" placeholder="活动开始时间" value="${(activity.yxq_q)!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'yxq_z\')}'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">活动结束时间： </label>
        <div class="col-sm-9">
            <input type="text" id="yxq_z" name="yxq_z" placeholder="活动结束时间" value="${(activity.yxq_z)!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'yxq_q\')}'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">有效标志</label>
        <div class="col-sm-9">
        	<select id="yxbz" name="yxbz" class="col-xs-10 col-sm-5">
			  	  <option <#if (activity.yxbz)?? && (activity.yxbz)=='Y' >selected</#if> value="Y" >有效</option>
				  <option <#if (activity.yxbz)?? && (activity.yxbz)=='N' >selected</#if> value="N" >无效</option>
			</select>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">是否指定商品</label>
        <div class="col-sm-9">
        	<select id="designate_product" name="designate_product" onchange="showGrid()" class="col-xs-10 col-sm-5">
				  <option <#if (activity.designate_product)?? && activity.designate_product=='N' >selected</#if> value="N" >否</option>
			  	  <option <#if (activity.designate_product)?? && activity.designate_product=='Y' >selected</#if> value="Y" >是</option>
			</select>
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" id="btn-save">
                	提交
            </button>
            <button class="btn" type="button" onclick="window.history.back();">
                	取消
            </button>
        </div>
    </div>
</form>

<div id="grid-table-product-show">
	<div class="col-xs-12 wigtbox-head form-inline">
		<form id="submitForm" class="form-inline">
			<div class="pull-left">
				<div class="form-group">
					<input id="productName" name="productName" class="form-control" placeholder="商品名称"/>
						
						<select  id="productStatus" name="productStatus" class="form-control">
						    <option value="">商品状态</option>
							<option value="01">正常</option>
							<option value="02">禁采</option>
							<option value="03">停止下单</option>
						</select>
						<button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-product">
							<i class="fa fa-search bigger-110"></i>搜索
						</button>
				</div>
			</div>
		</form>

		<div class="pull-right">
			<button class="btn btn-warning btn-sm" type="button" onclick="addProductToActivity('#grid-table-product')">
			   <i class="fa fa-plus bigger-110"></i> 添加
			</button>
		</div>  
	</div>
	
	<div class="col-xs-12">
		<!-- PAGE CONTENT BEGINS -->
		<table id="grid-table-product"></table>
		<div id="grid-pager-product"></div>
		<!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div>

<div id="grid-table-designate-product-show">
	<div class="col-xs-12 wigtbox-head form-inline pt40">
		<div class="pull-right">
			<button class="btn btn-danger btn-sm" type="button" onclick="delProductFromActivity('#grid-table-designate-product')">
			   <i class="fa fa-close bigger-110"></i> 删除
			</button>
		</div>  
	</div>
	<div class="col-xs-12">
		<!-- PAGE CONTENT BEGINS -->
		<table id="grid-table-designate-product"></table>
		<div id="grid-pager-designate-product"></div>
		<!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div>

<div id="grid_coupon_scale">
	<div class="col-xs-12 wigtbox-head form-inline">
		<form id="submitForm">
		    <div class="pull-right">	    	   
			    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" 
			            data-target="#give_coupon_setting" data-type="add"
			            data-grid="#grid-table-couponScale">
				        <i class="fa fa-plus bigger-110"></i> 添加
				</button>
			</div>
		</form>
	</div>
	
	<div class="col-xs-12">            
	    <!-- PAGE CONTENT BEGINS -->
	    <table id="grid-table-couponScale"></table>
	    <div id="grid-pager-couponScale"></div>
	    <!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div>

<div id="show_couponGrid6">
	<div class="col-xs-12 wigtbox-head form-inline pt40">
		<form id="submitForm_coupon6Category">
		 <div class="pull-right">
			<button class="btn btn-info btn-sm" type="button" data-toggle="modal" 
			     data-target="#give_coupon_setting" data-type="edit"
			     data-grid="#grid-table-coupon6Category">
			    <i class="fa fa-edit bigger-110"></i> 编辑
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDeleteCouponCategory('#grid-table-coupon6Category')">
			    <i class="fa fa-close bigger-110"></i> 删除
			</button>
		</div>
		</form>
	</div>
	<div class="col-xs-12" id="coupon6">
	    <!-- PAGE CONTENT BEGINS -->
	    <table id="grid-table-coupon6Category"></table>
	    <div id="grid-pager-coupon6Category"></div>
	    <!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div>

<div class="modal fade" id="give_coupon_setting" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog" >
	        <div class="modal-content">
	           <div class="modal-header">
	                <h4 class="modal-title pull-left">设置优惠券模板</h4>
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	           </div>
	           
	           <div class="modal-body clearfix">
	                <form id="coupon_category" class="form-horizontal" role="form" method="post">
	                    <input type="hidden" id="coupon_type" name="coupon_type" value="2" />
	                    
			    		<div class="form-group" id="min_pay_give_show">
					       <label class="col-sm-3 control-label no-padding-right" for="min_pay_give">获取限制金额：</label>
					        <div class="col-sm-9">
					            <input type="number" id="min_pay_give" name="min_pay_give" class="col-xs-10 col-sm-5" required/>
					        </div>
					    </div>
					     
					    <div class="form-group" id="user_gain_times_show">
					       <label class="col-sm-3 control-label no-padding-right" for="user_gain_times">用户获取次数限制：</label>
					        <div class="col-sm-9">
					            <input type="text" id="user_gain_times" name="user_gain_times" class="col-xs-10 col-sm-5" />
					        	<input type="checkbox" id="user_gain_times_checkbox" onclick="checkboxShow('#user_gain_times_checkbox','#user_gain_times')"></input>不限制
					        </div>
					    </div>
					    		   
					    <div class="form-group" id="yxq_show">
					       <label class="col-sm-3 control-label no-padding-right" for="yxq">优惠券有效期：</label>
					        <div class="col-sm-9">
					            <input type="number" id="yxq" name="yxq" class="col-xs-10 col-sm-5" />
					        </div>
					    </div>
					   
					    <div class="form-group" id="give_coupon_amount_show">
					       <label class="col-sm-3 control-label no-padding-right" for="give_coupon_amount">返券张数：</label>
					        <div class="col-sm-9">
					            <input type="number" id="give_coupon_amount" name="give_coupon_amount" class="col-xs-10 col-sm-5" />
					        </div>
					    </div>
					    		    
					    <div class="form-group" id="show_yxbz">
					        <label class="col-sm-3 control-label no-padding-right" for="yxbz_coupon6">有效标志：</label>
					        <div class="col-sm-9">
					        	<select id="yxbz_coupon6" name="yxbz_coupon6" class="col-xs-10 col-sm-5">
								  	  <option value="Y" >有效</option>
									  <option value="N" >无效</option>
								</select>
					        </div>
					    </div>
	               </form>
	           </div>
	           
	           <div class="modal-footer text-center">
	           		<button class="btn btn-info btn-md" type="button" id="btn-confirm">
	                	确认
	            	</button>
	            	<button class="btn btn-danger btn-md" data-dismiss="modal" aria-hidden="true">
	                                                            取消
	                </button>
			   </div>
	        </div>
	    </div>
</div>
</@layout>

<script>
//根据时间判定有效状态
function checkTime(){  
	var date = new Date();
	var now = date.getFullYear()+ "-" + ((date.getMonth() + 1) > 10 ? (date.getMonth() + 1) : "0"
            + (date.getMonth() + 1)) + "-" + (date.getDate() < 10 ? "0" + date.getDate() : date.getDate()) 
            + " " + (date.getHours() < 10 ? "0" + date.getHours() : date.getHours()) + ":"
        	+ (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()) + ":"
        	+ (date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds());
	var now=new Date(now.replace("-", "/").replace("-", "/"));  
	
    var startTime=$("#yxq_q").val();  
    var start=new Date(startTime.replace("-", "/").replace("-", "/"));  

    var endTime=$("#yxq_z").val();  
    var end=new Date(endTime.replace("-", "/").replace("-", "/")); 

    var boo = now>start&&now<end;
    var message;
    if(!boo){  
    	message = "当前时间不在有效时间内，活动为无效";
        $("#yxbz").val("N");
    } else{
    	message = 0;
    } 
    return message;
}  

//选择商品规格到活动中    
function addProductToActivity(table_name){
	var selr = jQuery(table_name).getGridParam('selrow');
	if(selr==null){$.alert("提示","请先选择一个商品去添加");return;}
	var activity_id = $("#id").val();
	
	$.ajax({
		data:{
			productf_id:selr,
			activity_id:activity_id
		},
		url:"${CONTEXT_PATH}/couponManage/addProductToActivity",
		success:function(data){
			if(data.success=="success"){
				$.alert("提示","添加成功");
				$("#grid-table-designate-product").trigger("reloadGrid");
			}
		}
	});
}

//选择活动商品,将其删除
function delProductFromActivity(table_name){
	if(confirm("您确认要从活动中删除该种商品吗？")){
		var selr = jQuery(table_name).getGridParam('selrow');
		if(selr==null){$.alert("请先选择一个商品再删除");return;}
		
		$.ajax({
			data:{id:selr},
			url:"${CONTEXT_PATH}/couponManage/delProductFromActivity",
			success:function(data){
				if(data.success=="success"){
			       $.alert("提示","删除成功");
				   $(table_name).trigger("reloadGrid");
				}
			}
		});
	}
}  

<#--检查checkbox是否选中-->
function checkboxShow(checkboxID,inputID){
	var flag = $(checkboxID).prop("checked");
	if(flag){
		$(inputID).attr("disabled",true);
		$(inputID).val("/");
	}else{
		$(inputID).attr("disabled",false);
		$(inputID).val("");
	}
}

<#--根据活动类型显示不同的couponGrid-->
window.onload=function(){
	showGrid();				
}

<#--TODO-->
function showGrid(){
	var designate_product = $("#designate_product").val();
	if(designate_product=='Y'){
		$("#grid-table-product-show").show();
		$("#grid-table-designate-product-show").show();
	}
	if(designate_product=='N'){
		$("#grid-table-product-show").hide();
		$("#grid-table-designate-product-show").hide();
	}
}
          
function getSelRowToDeleteCouponScale(table_name){
	var selr = jQuery(table_name).getGridParam("selrow");

    if(!selr){
        $.alert("提示","请先选择一行数据再删除");
        return;
    }
    
    if(confirm("您确认要删除该种优惠券规模吗？")){
    window.location.href="${CONTEXT_PATH}/activityManage/delCouponScale?id="+selr;
    }
}

<#--根据活动类型显示不同的模态框属性-->
function showDivByActivityType(activity_type){
	if(activity_type==5){
		$("#min_pay_give_show").hide();
		$("#coupon_total_checkbox").hide();
		$("#yxq_show").hide();
		$("#give_coupon_amount_show").hide();    		
	}else{
		$("#yxq_q_category_show").hide();
		$("#yxq_z_category_show").hide();
		$("#coupon_total_show").hide();
	}
}
    
<#--删除优惠券-->
function getSelRowToDeleteCouponCategory(table_name){
	var selr = $(table_name).getGridParam("selrow");
	if(!selr){
		$.alert("提示","请先选择一行数据再删除");
	    return;
	}
	if(confirm("您确认要删除该种优惠券规模吗？")){
	  	$.ajax({
	  		url:"${CONTEXT_PATH}/activityManage/delCouponCategory?id="+selr,
	  		success:function(data){
				$("#grid-table-coupon6Category").trigger("reloadGrid");
	   		}
	   	})
	}
}

jQuery(function($) {
    var grid_selector_couponScale = "#grid-table-couponScale";
    var pager_selector_couponScale = "#grid-pager-couponScale";
    
    var grid_selector_couponCategory = "#grid-table-couponCategory";
    var pager_selector_couponCategory = "#grid-pager-couponCategory";
    
    var grid_selector_product = "#grid-table-product";
    var pager_selector_product = "#grid-pager-product";

	var grid_selector_designate_product = "#grid-table-designate-product";
    var pager_selector_designate_product = "#grid-pager-designate-product";

    jQuery(grid_selector_product).jqGrid({
        url:"${CONTEXT_PATH}/couponManage/productFList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位','规格数量',
        		'单位','规格','价格','特价','赠送商品','有效'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false},
            {name:'save_string',index:'save_string', width:150,editable: false,formatter: productAddPhotoFormatter},
            {name:'base_unitname',index:'base_unitname', width:150,editable: false},
            {name:'product_amount',index:'product_amount',width:150,editable: true},
            {name:'product_unit',index:'product_unit', width:150,editable:true,
            	edittype:"select",editoptions:{value:"${unitList!}"}},
            {name:'standard',index:'standard', width:150,editable: true},
            {name:'price',index:'price', width:150,editable: true},
            {name:'special_price',index:'special_price', width:150,editable: true},
            {name:'is_gift',index:'is_gift', width:150,editable: true,
            	edittype:"select",editoptions:{value:"1:是;0:否"}},
            {name:'is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_product,
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
        caption: "微商城现货商品列表",
        autowidth: true
    });
    
    jQuery(grid_selector_designate_product).jqGrid({
        url:"${CONTEXT_PATH}/couponManage/activityProductList?activity_id= '"+$('#activity_id').val()+"'",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位','规格数量',
        		'单位','规格','价格','特价','赠送商品','有效'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false},
            {name:'save_string',index:'save_string', width:150,editable: false,formatter: productAddPhotoFormatter},
            {name:'base_unitname',index:'base_unitname', width:150,editable: false},
            {name:'product_amount',index:'product_amount',width:150,editable: true},
            {name:'product_unit',index:'product_unit', width:150,editable:true,
            	edittype:"select",editoptions:{value:"${unitList!}"}},
            {name:'standard',index:'standard', width:150,editable: true},
            {name:'price',index:'price', width:150,editable: true},
            {name:'special_price',index:'special_price', width:150,editable: true},
            {name:'is_gift',index:'is_gift', width:150,editable: true,
            	edittype:"select",editoptions:{value:"1:是;0:否"}},
            {name:'is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"}}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_designate_product,
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
        caption: "活动商品信息",
        autowidth: true
    });
    //显示图片渲染函数
    function productAddPhotoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
    }
    
    jQuery(grid_selector_couponScale).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getCouponScaleJson?is_valid='Y'",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','优惠券编号','优惠券描述','满减金额', '优惠券面值','是否有效'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                  formatter:'actions',
                  formatoptions:{
                      keys:false,
                      delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                  }
            },
            {name:'id',index:'id', width:90, editable: true},
            {name:'coupon_desc',index:'coupon_desc',width:90, editable:true, sorttype:"date"},
            {name:'min_cost',index:'min_cost', width:150,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'coupon_val',index:'coupon_val', width:90,editable: true},
            {name:'is_valid',index:'is_valid', width:90,editable: false},
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_couponScale,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        multiselect: true,
        //multikey: "ctrlKey",
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
    
	var grid_selector_coupon6Category = "#grid-table-coupon6Category";
    var pager_selector_coupon6Category = "#grid-pager-coupon6Category";
    
    jQuery(grid_selector_coupon6Category).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getCouponCategoryJson?activity_id=${(activity.id)!}",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','优惠券编号','优惠券描述','优惠券数量','有效期','有效期起','有效期止','优惠券获得金额','优惠券获得数量','获取次数限制','是否有效',],
        colModel:[
            {name:'myac',index:'', width:70, fixed:true, sortable:false, resize:false,
                  formatter:'actions',
                  formatoptions:{
                      keys:false,
                      delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                  }
            },
            {name:'id',index:'id', width:30, editable: true},
            {name:'coupon_desc',index:'coupon_desc',width:40, editable:true},
            {name:'coupon_total',index:'coupon_total', width:40,hidden:true},
            {name:'yxq',index:'yxq', width:20, editable:true},
            {name:'yxq_q',index:'yxq_q', width:50,hidden:true},
            {name:'yxq_z',index:'yxq_z', width:50,hidden:true},
            {name:'min_pay_give',index:'min_pay_give', width:20,hidden:true},
            {name:'give_coupon_amount',index:'give_coupon_amount', width:20,hidden:true},
            {name:'user_gain_times',index:'user_gain_times', width:50,editable: true},
            {name:'yxbz',index:'yxbz', width:20,editable: true}
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector_coupon6Category,
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
        caption: "已关联优惠券规模",
        autowidth: true
    });
    
    initNavGrid(grid_selector_couponScale,pager_selector_couponScale);
    initNavGrid(grid_selector_couponCategory,pager_selector_couponCategory);
    initNavGrid(grid_selector_product,pager_selector_product);
    initNavGrid(grid_selector_designate_product,pager_selector_designate_product);
    initNavGrid(grid_selector_coupon6Category,pager_selector_coupon6Category);

    $('#btn-save').on('click',function(){

    	var message = checkTime();
    	if(message!=0){
    		var mymessage=confirm("你确定要创建一个无效的活动吗？");  
    		if(mymessage==false){return;}
    	}
    	
    	//表单校验
        var validetor=$('#give_coupon').validate({
        	rules: {
        		main_title:{
        			required:true,
        		},
        		yxq_q:{
        			required:true,
        		},
        		yxq_z:{
        			required:true,
        		}
        	},
        	messages:{
        		main_title:{
        			required:"请输入活动主标题",
        		},
        		yxq_q:{
        			required:"请输入开始时间",
        		},
        		yxq_z:{
        			required:"请输入结束时间",
        		}
        	},
        });
        
        if(!validetor.form()){     
        	return false;
        }
        
        var formData=$('#give_coupon').serialize();
        console.log(formData);
    	$.ajax({  
            type:"POST",
            url:"${CONTEXT_PATH}/activityManage/saveCouponActivity",  
            data:formData,
            success:function(result) {
              		if(result.success){                        		  	 
              		  	 $("#id").val(result.id);                        		  	 
              		  	 $.alert("提示","操作成功");  
              		}else{  
              			 $.alert("提示","操作失败，请重试");  
             		}  
            }  
        });

    });

    $('#give_coupon_setting').on("show.bs.modal",function(e){
    	    var modal=$(this);
            var $btn=$(e.relatedTarget);
            var gridName=$btn.data("grid");
            var type=$btn.data("type");
            
            var actvity_id = $("#id").val();
            var coupon_scale_id = $(gridName).getGridParam('selrow');
         	var activity_type = $("#activity_type").val();
         	
         	if(actvity_id==null||actvity_id==""){
         		$.alert("提示","请先添加一个返券活动再进行后续操作");
                return false;
         	}
         	if(!coupon_scale_id){
         		$.alert("提示","请先选择一行数据再添加具体规模优惠券");
         		return false;
         	}
         	
            //判断是编辑还是修改
         	if(type=="add"){
         		//清空掉form
         		$("form#coupon_category")[0].reset();
            }else{
            	var selr = $(gridName).getGridParam("selrow");
                if(!selr){
                    $.alert("提示","请先选择一行数据再编辑");
                    return false;
                }
            	var min_pay_give=$(gridName).jqGrid("getCell",selr,"min_pay_give");
            	var user_gain_times=$(gridName).jqGrid("getCell",selr,"user_gain_times");
            	var yxq=$(gridName).jqGrid("getCell",selr,"yxq");
            	var give_coupon_amount=$(gridName).jqGrid("getCell",selr,"give_coupon_amount");
            	var yxbz=$(gridName).jqGrid("getCell",selr,"yxbz");
            	$("#min_pay_give").val(min_pay_give);
            	$("#user_gain_times").val(user_gain_times);
            	$("#yxq").val(yxq);
            	$("#give_coupon_amount").val(give_coupon_amount);
            	$("#yxbz_coupon6").val(yxbz);	
            				
            	if($("#user_gain_times").val()=="/"){
            		$("#user_gain_times_checkbox").attr("checked", true);
            		$("#user_gain_times").attr("disabled",true);
            	}else{
            		$("#user_gain_times_checkbox").attr("checked", false);
            		$("#user_gain_times").attr("disabled",false);
            	}
            }
    });
    
    $('#btn-confirm').on("click",function(){
    	var activity_type = $("#activity_type").val();
    	//表单校验
        var validetor=$('#coupon_category').validate({
        	rules: {
        		min_pay_give:{
        			required:true,
        			digits:true
                },
        		give_coupon_amount:{
        			required:true,
        			digits:true
        		},
        		user_gain_times:{
        			required:true
	            },
        		yxq:{
        			required:true,
        			digits:true
        		}
        	},
        	messages:{
        		min_pay_give:{
        			required:"请输入获取限制金额",
        			digits:"请输入合法的正整数"
                },
        		give_coupon_amount:{
        			required:"请输入返券张数",
        			digits:"请输入合法的正整数"
	            },
	        	user_gain_times:{
        			required:"请输入用户领取限制次数"
	            },
	            yxq:{
        			required:"请输入优惠券有效期",
        			digits:"请输入合法的正整数"
        		}
        	},
        });
        
        if(!validetor.form()){     
        	return false;
        }
        
        var jsonData = {
         	   	id:$("#grid-table-coupon6Category").getGridParam("selrow"),
         		main_title:$("#main_title").val(),
         		activity_id:$("#activity_id").val(),
         		couponScale_id:$("#grid-table-couponScale").getGridParam("selrow"),
         		coupon_type:$("#coupon_type").val(),
         		min_pay_give:$("#min_pay_give").val(),
         		user_gain_times:$("#user_gain_times").val(),
         		yxq:$("#yxq").val(),
         		give_coupon_amount:$("#give_coupon_amount").val(),
         		yxbz:$("#yxbz_coupon6").val(),
         		coupon_total:"/"
        }
        
        //发送Ajax去保存category
    	$.ajax({ 
			url: "${CONTEXT_PATH}/activityManage/saveCouponCategory", 
			data: jsonData, 
			success: function(data){
				if(data.errcode==0){
					$.alert("提示","操作成功");				
					$("#grid-table-coupon6Category").trigger("reloadGrid");
	 				$("#give_coupon_setting").modal("hide");
				}else{
					$.alert("提示",data.errmsg);
				}	
	      	}
		});
	});

});     
</script>