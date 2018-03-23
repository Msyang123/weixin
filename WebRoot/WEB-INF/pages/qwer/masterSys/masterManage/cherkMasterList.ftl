<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-right">	    	   
		    <button class="btn btn-primary btn-sm" type="button"  onclick="lookup()"/>
			  查看
			</button>
		</div>
	</form>
</div>

<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->


<div class="col-xs-12 wigtbox-head form-inline pt40">
	<form id="submitForm1">
	   <div class="pull-left">
					  <div class="form-group">
						    <input id="masterName" name="masterName" class="form-control" placeholder="申请人名字"/>
						    <div class="input-group">
							    <input type="text" id="createDateBegin" name="createDateBegin"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	        	至 <input type="text" id="createDateEnd" name="createDateEnd"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
							</div>
					        <button class="btn btn-primary btn-sm" type="button" 
					         onclick="jQuery('#grid-table1')
					                .setGridParam({postData:{'masterName':$('#masterName').val(),
					                'status':$('#status').val(),
					                'createDateBegin':$('#createDateBegin').val(),
					                'createDateEnd':$('#createDateEnd').val()}})
					                .trigger('reloadGrid');">
					            <i class="fa fa-search bigger-110"></i>查询
					        </button>
				       </div>
		        </div>
        <div class="pull-right">	    
        <input type="hidden" id="masterNc" name="master_nc">	   
		    <button class="btn btn-primary btn-sm" type="button"  onclick="passButton();"/>
			  通过
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="trainNotPass();"/>
			  取消资格
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


<div class="modal fade" id="add-star" tabindex="-1" role="dialog" aria-hidden="true">
    <input type="hidden" id="saleId" name="id" value=""/>
    <div class="modal-dialog">
        <div class="modal-content pd20">
	    	<h4>鲜果师头衔管理</h4>
	    	<div class="text-center mt10">
	        	<input type="text" id="master_nc" name="master_nc" class="col-xs-10 col-sm-5" />
	         </div>
	         
	         <div class="col-12 text-center">
           		<button class="btn btn-secondary btn-sm" type="button" data-dismiss="modal">
                	<i class="fa fa-close bigger-110"></i>取消
            	</button>
           		<button class="btn btn-info btn-sm" type="button" id="btn-confirm">
                	<i class="fa fa-check bigger-110"></i>确认
            	</button>
           </div>
		  </div>    
     </div>
</div>
</@layout>

<script type="text/javascript">
function lookup(){
	var selr = jQuery("#grid-table").getGridParam('selrow');
	if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
	window.location.href="${CONTEXT_PATH}/masterManage/masterDetail?id="+selr;
}

function passButton(){
	 var ids=$("#grid-table1").jqGrid("getGridParam","selarrrow");
	 if(ids.length==0){
		alert("请先选择一条数据在进行操作！");
		//$('#add-star').modal('hide');
		return;
	}
	 $('#add-star').modal('show');
}

$("#btn-confirm").click(function(){
	var master_nc=$("#master_nc").val();
	  $("#masterNc").val(master_nc);
	  $('#add-star').modal('hide');
	  trainPass();
}); 

function trainPass(){
	var masterNC=$("#masterNc").val();
	var selr = jQuery("#grid-table1").getGridParam('selrow');
	if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
	 $.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/trainIsPass?id="+selr+"&master_status=3&master_nc="+masterNC,
        success: function(data) {
        	window.location.href="${CONTEXT_PATH}/masterManage/initCherkMasterList";
        },
        error: function(request) {
            alert("Connection error");
        },
    });  
}


function trainNotPass(){
	var selr = jQuery("#grid-table1").getGridParam('selrow');
	if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/trainIsPass?id="+selr+"&master_status=-1",
        success: function(data) {
        	alert(data.status);
        	window.location.href="${CONTEXT_PATH}/masterManage/initCherkMasterList";
        },
        error: function(request) {
            alert("Connection error");
        },
    });
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

var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
    	postData:{"master_status":0},
    	url:"${CONTEXT_PATH}/masterManage/cherkMasterList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['申请时间','申请人','手机号码','身份证号码'],
        colModel:[
        	{name:'create_time',index:'create_time', width:150, editable: false},
            {name:'master_name',index:'master_name',width:150,editable: false},
            {name:'mobile',index:'mobile',width:90, editable:false},
            {name:'idcard',index:'idcard',width:90, editable:false}
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
        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "待审核申请列表",
        autowidth: true

    });
});

jQuery(function($) {
    var grid_selector = "#grid-table1";
    var pager_selector = "#grid-pager1";
   
    jQuery(grid_selector).jqGrid({
        //data: grid_data,?activity_type=5
        postData:{"master_status":1},
        url:"${CONTEXT_PATH}/masterManage/cherkMasterList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['申请时间','申请人','手机号码','身份证号码'],
        colModel:[
        	{name:'create_time',index:'create_time', width:150, editable: false},
            {name:'master_name',index:'master_name',width:150,editable: false},
            {name:'mobile',index:'mobile',width:90, editable:false},
            {name:'idcard',index:'idcard',width:90, editable:false}
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
        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "培训中人员名单",
        autowidth: true

    });
    
  //显示图片渲染函数
    function selectStatus(cellvalue, options, rowdata){
	  if(rowdata[3]==0){
		  return "未处理";
	  }else if(rowdata[3]==1){
		  return "已处理";
	  }else if(rowdata[3]==2){
		  return "已失效";
	  }
    }
  
  //显示二维码图片渲染函数
    function erweimaPhotoFormatter1(cellvalue, options, rowdata){
    	var _url=encodeURIComponent("${app_domain}/fruitDetial?pf_id="+rowdata[1]);
    	 return "<img src='${CONTEXT_PATH}/activityManage/printTwoBarCode?code="+_url+"' style='width:40px;height:40px;' />";
    }

});
</script>