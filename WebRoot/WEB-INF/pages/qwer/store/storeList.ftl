<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>
<div class="col-xs-12 wigtbox-head">
	<form id="submitForm">
			<div class="pull-left">	
			   <input type="text" id="storeName" name="storeName" placeholder="店铺名称"/>
			</div>
			<div class="pull-right">
			    <button class="btn btn-info btn-sm" type="button" onclick="jQuery('#grid-table')
			            .setGridParam({postData:{'storeName':$('#storeName').val()}})
			            .trigger('reloadGrid');">
			        <i class="fa fa-search bigger-110"></i> 查询
			    </button>
			    <button class="btn btn-success btn-sm" type="button" onclick="store2Dada()">
			    	<i class="fa fa-cloud-upload bigger-110"></i> 上传达达
				</button>
			</div>
			
	</form>
</div>
	
<!--product_f table-->
	<div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
	            <table id="grid-table"></table>
	            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
<!--product_f table-->
</@layout>

<script>
	jQuery(function($) {
		
		var grid_selector = "#grid-table";
	    var pager_selector = "#grid-pager";
	    
	    jQuery(grid_selector).jqGrid({
	        //direction: "rtl",
	        //data: grid_data,
	        url:"${CONTEXT_PATH}/storeManage/storeList",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:["操作",'编号','门店编码','门店名称','门店联系方式', 
	         '门店详细地址','纬度','经度','门店宣言','门店二维码','微信群二维码','门店图片','所属区域'],
	        colModel:[
	            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
	                formatter:'actions',
	                formatoptions:{
	                    keys:true,
	                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
	                    editformbutton:true, 
	                    editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback},
	                    formatter:"actionFormatter"
	                }
	            },
	            {name:'sl.id',index:'id',width:90, editable:true},
	            {name:'sl.store_id',index:'store_id',width:90, editable:true},
	            {name:'sl.store_name',index:'store_name', width:150,editable: true},
	            {name:'sl.store_phone',index:'store_phone',width:150,editable: true},
	            {name:'sl.store_addr',index:'store_addr', width:150,editable:true},
	            {name:'sl.lat',index:'lat', width:100,editable: true},
	            {name:'sl.lng',index:'lng', width:100,editable: true},
	            {name:'sl.store_declar',index:'store_declar', width:150,editable: true},
	            {name:'sl.qrcode_img',index:'qrcode_img', width:150,editable: true},
	            {name:'sl.wxgroup_img',index:'wxgroup_img', width:150,editable: true},
	            {name:'sl.store_img',index:'store_img', width:150,editable: true},
	            {name:'sl.belong_area',index:'belong_area', width:150,editable: true}
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
			editurl: "${CONTEXT_PATH}/storeManage/storeSave",
	        
			loadComplete : function() {
	            var table = this;
	            setTimeout(function(){
	                updatePagerIcons(table);
	                enableTooltips(table);
	            }, 0);
	        },
	        caption: "店铺管理",
	        autowidth: true
	    });
	    
	    $.extend($.fn.fmatter, {
	        actionFormatter: function(cellvalue, options, rowObject) {
	            var retVal = '<a class="btn btn-success btn-xs mr5" title="更新到达达" ><i class="fa fa-cloud-upload"></i></a>';
	            return retVal;
	        }
	    });
	    
	    initNavGrid(grid_selector,pager_selector);
	});

	function store2Dada(){
		var selr = jQuery("#grid-table").getGridParam('selrow');
		var rowData = $('#grid-table').jqGrid('getRowData',selr);
	    if(!selr){
	        alert("请先选择一行数据再操作");
	        return;
	    }
	    var storeId = rowData["sl.store_id"];
         $.ajax({
            url: "${CONTEXT_PATH}/storeManage/store2Dada?store_Id="+storeId,
            type:'Get',
            success:function(data){
 				if(data.success){
 					alert(data.msg);
 				}else{
 					alert(data.msg);
 				}
            }
        });
	}
</script>