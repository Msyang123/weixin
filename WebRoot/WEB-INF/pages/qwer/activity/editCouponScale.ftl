<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>
<div class="col-xs-12">
	<form action="${CONTEXT_PATH}/activityManage/saveCouponScale" class="form-horizontal" role="form" method="post">
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="coupon_desc">优惠券描述： </label>
	        <div class="col-sm-9">
	            <input type="text" id="coupon_desc" name="coupon_desc" value="${couponScale.coupon_desc!}"  placeholder="优惠券描述" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="id">优惠卷编号： </label>
	        <div class="col-sm-9">
	            <input type="text" id="id" name="id" placeholder="优惠卷编号,系统自动生成,不需要填写" value="${couponScale.id!}" class="col-xs-10 col-sm-5" readOnly="true" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="min_cost">满减金额：</label>
	
	        <div class="col-sm-9">
	            <input type="number" id="min_cost" name="min_cost" placeholder="满减金额" value="${couponScale.min_cost!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="coupon_val">优惠卷面值： </label>
	
	        <div class="col-sm-9">
	            <input type="text" id="coupon_val" name="coupon_val" placeholder="优惠卷面值" value="${couponScale.coupon_val!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="is_single">优惠卷针对范围： </label>
            <select name="is_single" id="is_single" class="col-sm-1 nopd-lr ml12">
	             <option value="" selected="selected" style="display:none">选择范围</option>
	             <#if couponScale.is_single??>
	               	 <option value="N" <#if couponScale.is_single=='N'>selected</#if>>全部商品</option>
	               	 <option value="Y" <#if couponScale.is_single=='Y'>selected</#if>>单件商品</option>
               	 <#else>	 
       				<option value="N"  >全部商品</option>
	        		<option value="Y"  >单件商品</option>
		         </#if>
			</select>
			<#if productF??>
			<div class="col-sm-6 " id="coupon_pro">
			<#else>
			<div class="col-sm-6 hidden" id="coupon_pro">
			</#if>
				<label class="col-sm-2 control-label" for="selcet_pro" >选择商品：</label>
		        <div class="col-md-3 input-group nopd-l">
		        	<input type="hidden" name="product_f_id" id="product_f_id" value="${(productF.id)!}"/>
		    		<input type="text" name="GOODS_NAME" id="GOODS_NAME" value="${(productF.product_name)!}" class="goods_name form-control" readonly="readonly"/>
		    		<span class="input-group-btn">
	                     <button type="button" class="btn btn-primary btn-sm" id="search-pro" data-toggle="modal" data-target="#select-pro"><i class="fa fa-search"></i></button>
	                </span>
		        </div>
			</div>
	    </div>
	    
	    <div class="form-group pbb40">
	        <label class="col-sm-3 control-label no-padding-right" for="is_valid">有效状态： </label>
	        <div class="col-sm-9">
				<select id="is_valid" name="is_valid">
	        		<#if couponScale.is_valid??>
	        			<option value="Y" <#if couponScale.is_valid=='Y'>selected</#if>>有效</option>
	       				<option value="N" <#if couponScale.is_valid=='N'>selected</#if>>无效</option>	       			
	       			<#else>	
	       				<option value="Y"  >有效</option>
		        		<option value="N"  >无效</option>
		        	</#if>
		        </select>
	        </div>
	    </div>	    	    	    
	      
	    <div class="clearfix">
	        <div class="col-md-offset-3 col-md-9">
	            <button class="btn btn-info btn-sm" type="button" onclick="whenSubmit();">
	                <i class="fa fa-check bigger-110"></i> 提交
	            </button>
	            <button class="btn btn-danger btn-sm" type="button" onclick="history.go(-1);">
	                <i class="fa fa-undo bigger-110"></i> 取消
	            </button>
	        </div>
	    </div>
	</form>
	
<div class="modal fade" id="select-pro" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog" style="width:800px">
	    <div class="modal-content">
	        <div class="modal-header">
	            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	            <h4 class="modal-title">选择商品</h4>
	   		 </div>
	   		 <div class="modal-body">
	   		 	<div class="col-xs-12 nopd-lr wigtbox-head form-inline">
		   		 	<form id="SearchProForm" action="" method="Post">
		   		 		<input type="text" class="barcode_code" name="BARCODE_CODE" id="BARCODE_CODE_PRO" placeholder="商品条码" class="form-control"/>
						<input type="text" class="goods_name" name="GOODS_NAME" id="GOODS_NAME_PRO" placeholder="商品名称" class="form-control"/>
		   		 		<button class="btn btn-primary btn-sm" type="button" id="btn-model-search">
						    <i class="fa fa-search bigger-110"></i> 搜索     
						</button>
		   		 	</form>
	   		 	</div>
	   		 	
	   		 	<div class="col-xs-12 nopd-lr mb10">
				    <table id="grid-pro-table"></table>
				    <div id="grid-pro-pager"></div>
				</div>
	   		 </div>
	   		 <div class="col-12 text-center mb10">
		       	<button class="btn btn-info btn-sm mt10" type="button" data-dismiss="modal" aria-hidden="true" onclick="getSelRowToConfirm()"> 
                  	确定
               	</button>
		     </div>
	    </div>
    </div>
</div>
</@layout>

<script>
	$(function(){
		//切换显示优惠券范围
	    $('#is_single').on('change',function(e){
	    	 var type=$(this).val();
	    	 if(type=="Y"){
	    		 $('#coupon_pro').removeClass('hidden');
	    	 }else{
	    		 $('#coupon_pro').addClass('hidden');
	    		 $('#coupon_pro').val("");
	    	 }
	    });
		
		//商品列表
		var grid_sales = "#grid-pro-table";
		var pager_sales = "#grid-pro-pager";
    
    	jQuery(grid_sales).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/productFList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','商品状态','商品名称','分类名称','首图' ,'基础单位','规格数量',
        		'单位','规格','价格','特价','赠送商品','有效'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'product_status',index:'product_status',width:150,editable: false,hidden:true},
            {name:'product_name',index:'product_name',width:90, editable:false},
            {name:'category_name',index:'category_name', width:70,editable: false,hidden:true},
            {name:'save_string',index:'save_string', width:150,editable: false,
            	formatter:function(value,grid,rows,state){
                	return "<img src='"+value+"' style='width:40px;height:40px;' onerror='imgLoad(this)' />";
                }
            },
            {name:'base_unitname',index:'base_unitname', width:150,editable: false},
            {name:'product_amount',index:'product_amount',width:150,editable: true},
            {name:'product_unit',index:'product_unit', width:150,editable:true,
            	edittype:"select",hidden:true},
            {name:'standard',index:'standard', width:150,editable: true},
            {name:'price',index:'price', width:150,editable: true},
            {name:'special_price',index:'special_price', width:150,editable: true,hidden:true},
            {name:'is_gift',index:'is_gift', width:150,editable: true,
            	edittype:"select",editoptions:{value:"1:是;0:否"},hidden:true},
            {name:'is_vlid',index:'is_vlid', width:150,editable: true,
            	edittype:"select",editoptions:{value:"Y:有效;N:无效"},hidden:true}
            ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30,100,500],
	        pager : pager_sales,
	        emptyrecords : "未找到任何数据",
	        pgtext: "第{0}页 共{1}页",
	        altRows: true,
	        multiselect: true,
	        multiboxonly: true,
	        beforeSelectRow : beforeSelectRow,
			editurl: "",
	        loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	            }, 0);
	        },
	        caption: "选择数据",
	        autowidth: false,
	        shrinkToFit:true,
	        width:764
	    });	  
		
    	//搜索商品
		$('#btn-model-search').on('click',function(){
			$('#grid-pro-table').jqGrid('resetSelection');
			var data = $('#select-pro').find('#SearchProForm').serializeArray();
		   	 var jsonData={};
		     for(var i=0;i<data.length;i++){
		           jsonData[data[i].name]=data[i].value;
		     }
		     //提交后刷新grid
			 $('#grid-pro-table').setGridParam({postData:jsonData}).trigger('reloadGrid');
		});
	});

	//设定grid为单选
	function beforeSelectRow(){
		$('#grid-pro-table').jqGrid('resetSelection');
		return(true);
	}
	
    //选择商品后回填数据
    function getSelRowToConfirm(){
    	var selr = jQuery("#grid-pro-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择商品");
            return;
        }
        var rowData=jQuery("#grid-pro-table").getRowData(selr);
        $("#GOODS_NAME").val(rowData.product_name);
        $("#product_f_id").val(selr);
    }
    
	//XXX：当可编辑的值没有空值的时候，按钮才有效，否则无法点击按钮
    function whenSubmit(){
        $("#content").val($(".ke-edit-iframe").contents().find("body").html());
        if($("#coupon_desc").val()==""||$("#min_cost").val()==""||$("#coupon_val").val()==""){
			alert("请填写完毕后在提交");  
			return;  		
    	}
        if($("#is_single").val()=="Y"&&$("#GOODS_NAME").val()==""){
        	alert("请关联商品");  
			return;  
        }
        $(".form-horizontal").submit();
    }
</script>