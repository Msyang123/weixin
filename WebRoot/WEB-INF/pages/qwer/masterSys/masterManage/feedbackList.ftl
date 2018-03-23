<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>
<div class="col-xs-12 wigtbox-head">
	<form id="submitForm">
		<div class="pull-left">
			手机号
			<input type="text" id="phoneNum" name="phoneNum" />
			时间	
			<input type="text" id="registTimeBegin" name="registTimeBegin" value='${feedbackTimeBegin!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
    		至
    		<input type="text" id="registTimeEnd" name="registTimeEnd" value='${feedbackTimeEnd!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	    	类型
	    	<select  id="feedbackType" name="feedbackType" >
				<option value=0>全    部</option>
				<option value=1>鲜果师</option>
				<option value=2>用    户</option>
			</select>
            <button class="btn btn-info btn-sm" type="button" onclick="jQuery('#grid-table')
                    .setGridParam({postData:{'phoneNum':$('#phoneNum').val(),'feedbackTimeBegin':$('#feedbackTimeBegin').val(),'feedbackTimeEnd':$('#feedbackTimeEnd').val(),'feedbackType':$('#feedbackType').val()}})
                    .trigger('reloadGrid');">
                <i class="fa fa-search bigger-110"></i>查询
            </button>
		</div>
    </form>  
    <div class="pull-right">
	    <button class="btn btn-info btn-success btn-sm" type="button"  onclick="getSelRowToView();">			
			<i class="fa fa-eye bigger-110"></i> 查看
		</button>
	</div>
</div>  	
	
<!--feedback table-->
	<div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table"></table>
            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
<!--product_f table-->
<!--查看内容的模态框-->
<div class="modal fade" id="fb_content_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" >
	    <div class="modal-content" style="padding:40px">
		    <div class="form-group clearfix col">
		       <label class="col-sm-3 control-label no-padding-right" for="fb_content_detail">反馈内容详情：</label>
		       <div class="col-sm-9">
		            <textarea type="text" id="fb_content_detail" class="form-control" rows="5"/>
		            </textarea>
		       </div>
		    </div>
		    <div class="col-12 text-center">
	       		<button class="btn btn-info btn-sm" type="button"  data-dismiss="modal">
	            	<i class="fa fa-check bigger-110"></i>确认
	        	</button>	        	
	       </div>
	       
	    </div>
	</div>
</div>
</@layout>

<script>

function getSelRowToView(){
	 var selr = jQuery("#grid-table").getGridParam('selrow');
	 if(!selr){
	 	alert("请选择一行数据再查看");
	 	return;
	 }
	 var rowData = $("#grid-table").jqGrid("getRowData",selr);
	 var content = rowData.fb_content;
	 $("#fb_content_detail").val(content);
     $("#fb_content_modal").modal();
}

jQuery(function($) {
	
	var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterManage/feedbackList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','主题','反馈内容','创建时间','用户昵称', '头像','手机号','反馈类型'],
        colModel:[
            {name:'id',index:'id',width:90, editable:true},
            {name:'fb_title',index:'fb_title',width:90, editable:false},
            {name:'fb_content',index:'fb_content', width:150,editable: false},
            {name:'fb_time',index:'fb_time',width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'user_img_id',index:'user_img_id', width:150,editable: false,formatter: photoFormatter},
            {name:'phone_num',index:'phone_num', width:150,editable: false},
            {name:'fb_type',index:'fb_type', width:150,editable: true,
            edittype:"select",formatter:function(cellvalue,options,rowObject){
            							var statusStr;
					            		switch(cellvalue){
					            		case 1:
					            			statusStr = "鲜果师反馈";
					            			break;
					            		case 2:
					            			statusStr = "鲜果师商城用户反馈";
					            			break;
					            		default:
					                		statusStr = "N/A";
					            			break;
					            		}
            							return statusStr;}}
        ],

        viewrecords : true,
        rowNum:5,
        rowList:[5,10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        //toppager: true,

        multiselect: true,
        //multikey: "ctrlKey",
        multiboxonly: true,
		editurl: "${CONTEXT_PATH}/masterManage/feedbackSave",
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        caption: "反馈管理",
        autowidth: true
    });
    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }
	//显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[6]+"' style='width:40px;height:40px;' />";
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
});
</script>