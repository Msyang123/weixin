<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
 <div class="col-xs-12 wigtbox-head">
      <div class="pull-right">
		<button class="btn btn-info btn-sm" type="button" data-toggle="modal" data-target="#add-pro" >
		    <i class="fa fa-edit bigger-110"></i> 编辑
		</button>
      </div>  
 </div> 
  
 <div class="col-xs-12">
     <!-- PAGE CONTENT BEGINS -->
     <table id="grid-table"></table>
     <div id="grid-pager"></div>
     <!-- PAGE CONTENT ENDS -->
 </div><!-- /.col -->
 
 
<div class="modal fade" id="add-pro" tabindex="-1" role="dialog" aria-hidden="true">
	<form action="${CONTEXT_PATH}/activityManage/saveSeedInstAndInterval" id="seedInstAndInterval" method="post">
	    <input type="hidden" id="saleId" name="id" value=""/>
	    <div class="modal-dialog">
	        <div class="modal-content clearfix pd20">
	            <div class="col-12 clearfix pd20">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	            </div>
			    
			    <div class="form-group col clearfix">
			       <label class="col-sm-3 control-label no-padding-right" for="sale_percentage">销售分成</label>
			        <div class="col-sm-9">
			            <input type="text" id="sale_percentage" name="sale_percentage"  value="" class="form-control" />
			        </div>
			    </div>
			    
			    <div class="form-group col clearfix">
        			<label class="col-sm-3 control-label no-padding-right" for="bonus_percentage">红利比例</label>

			        <div class="col-sm-9">
			            <input type="text" id="bonus_percentage" name="bonus_percentage"  value="" class="form-control" />
			        </div>
		    	</div>
		         
		        <div class="col-12 text-center">
	           		<button class="btn btn-info" type="button" id="btn-confirm">
	                	<i class="fa fa-check bigger-110"></i>确认
	            	</button>
	           	</div>
			 </div>    
	      </div>
	 </form> 
</div>
</@layout>


<script type="text/javascript">
var $path_base = "/";
$("#btn-confirm").click(function(){
	var saleId=$("#saleId").val();
	var sale_percentage=$("#sale_percentage").val();
	var bonus_percentage=$("#bonus_percentage").val();
	var data={saleId:saleId,sale_percentage:sale_percentage,bonus_percentage:bonus_percentage};
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/eidtDivide",
        data:data,
        success: function(data) {
        	$('#add-pro').modal('hide');
        	jQuery("#grid-table").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
});

$('#add-pro').on('shown.bs.modal', function () {
	var selr = $("#grid-table").getGridParam("selrow");
	if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/eidtDivideSet?id="+selr,
        success: function(data) {
        	$("#saleId").val(data.bonusPercentage.id);
        	$("#sale_percentage").val(data.bonusPercentage.sale_percentage);
        	$("#bonus_percentage").val(data.bonusPercentage.bonus_percentage);
        	jQuery("#grid-table").trigger("reloadGrid");
        },
        error: function(request) {
            alert("Connection error");
        },
    });
})

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
jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/masterManage/divideSetList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','销售分成比例','下级鲜果师红利比例'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'sale_percentage',index:'sale_percentage',width:150,editable: false},
            {name:'bonus_percentage',index:'bonus_percentage',width:90, editable:false}
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
        caption: "权益设置列表",
        autowidth: true
    });
});
</script>