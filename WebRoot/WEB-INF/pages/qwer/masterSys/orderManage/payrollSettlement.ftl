<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-right">	    	   
		    <button class="btn btn-primary btn-sm" type="button"  onclick="real()"/>
			   处理
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="exportOut()"/>
			    导出
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
					   申请状态
					<select id="status" name="status" class="form-control">
						<option value="-1">全部</option>
						<option value="1">已处理</option>
						<option value="2">已失效</option>
					</select>
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
	</form>
</div>
<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table1"></table>
    <div id="grid-pager1"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

</@layout>
<script type="text/javascript">
/**
 * 处理未结算薪资
 */
function real(){
	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterOrderManage/realSettlement?ids="+ids.join(),
        success: function(data) {
        	alert(data.message);
        	jQuery("#grid-table").trigger("reloadGrid");
        	jQuery("#grid-table1").trigger("reloadGrid");
        },
        error: function(request) {
            //alert("Connection error");
        },
    });
}

function exportOut(){
	window.location.href=
		encodeURI("${CONTEXT_PATH}/masterOrderManage/exportSettlement?colNames="+JSON.stringify(jQuery("#grid-table").getGridParam().colNames)
				+"&colModel="+JSON.stringify(jQuery("#grid-table").getGridParam().colModel)
		);
}

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
    	postData:{"status":0},
    	url:"${CONTEXT_PATH}/masterOrderManage/findNotRealSettlement",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['申请时间','申请人','申请金额'],
        colModel:[
        	{name:'apply_time',index:'apply_time', width:150, editable: false},
            {name:'master_name',index:'master_name',width:150,editable: false},
            {name:'apply_money',index:'product_name',width:90, editable:false}
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
        caption: "未处理结算申请",
        autowidth: true

    });
    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }
    //navButtons
    jQuery(grid_selector).jqGrid('navGrid',pager_selector,
            { 	//navbar options
                edit: false,
                editicon : 'icon-pencil blue',
                add: false,
                addicon : 'icon-plus-sign purple',
                del: false,
                delicon : 'icon-trash red',
                search: false,
                searchicon : 'icon-search orange',
                refresh: true,
                refreshicon : 'icon-refresh green',
                view: true,
                viewicon : 'icon-zoom-in grey'
            }
    )
});

jQuery(function($) {
    var grid_selector = "#grid-table1";
    var pager_selector = "#grid-pager1";
    
   
    jQuery(grid_selector).jqGrid({
        //data: grid_data,?activity_type=5
        postData:{"status":-1},
        url:"${CONTEXT_PATH}/masterOrderManage/findNotRealSettlement",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['申请时间','申请人','申请金额','申请状态'],
        colModel:[
        	{name:'apply_time',index:'apply_time', width:150, editable: false},
            {name:'master_name',index:'master_name',width:150,editable: false},
            {name:'apply_money',index:'apply_money',width:90, editable:false},
            {name:'status',index:'status',width:90,editable: true,
            	formatter:selectStatus}
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
        multiboxonly: true,

        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },

        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "结算申请查询",
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

    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }


    //navButtons
    jQuery(grid_selector).jqGrid('navGrid',pager_selector,
            { 	//navbar options
                edit: false,
                editicon : 'icon-pencil blue',
                add: false,
                addicon : 'icon-plus-sign purple',
                del: false,
                delicon : 'icon-trash red',
                search: false,
                searchicon : 'icon-search orange',
                refresh: true,
                refreshicon : 'icon-refresh green',
                view: true,
                viewicon : 'icon-zoom-in grey'
            }
	)
});


//});
</script>