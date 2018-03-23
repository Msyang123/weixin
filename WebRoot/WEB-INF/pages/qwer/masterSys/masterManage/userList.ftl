<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
		<div style="margin-bottom:5px;">
			
		</div>
		<div class="col-xs-12 wigtbox-head">
			<form id="submitForm">
				<div class="pull-left">
					手机号
					<input type="text" id="phoneNum" name="phoneNum" />
					注册时间	
					<input type="text" id="registTimeBegin" name="registTimeBegin" value='${registTimeBegin!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
            		至
            		<input type="text" id="registTimeEnd" name="registTimeEnd" value='${registTimeEnd!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
            		<button class="btn btn-info btn-sm" type="button" onclick="jQuery('#grid-table')
		                    .setGridParam({postData:{'phoneNum':$('#phoneNum').val(),'registTimeBegin':$('#registTimeBegin').val(),'registTimeEnd':$('#registTimeEnd').val()}})
		                    .trigger('reloadGrid');">
		                <i class="fa fa-search bigger-110"></i>查询
		            </button>		
            	</div>
            	<div class="pull-right">
		             <button class="btn btn-info btn-success btn-sm" type="button"  onclick="getSelRowToEdit();">			
			         <i class="fa fa-reply bigger-110"></i> 回复
				    </button>
					<button class="btn btn-primary btn-sm" type="button"  onclick="repAll();">	
					    <i class="fa fa-send bigger-110"></i> 群发
					</button>
		            <button class="btn btn-warning btn-sm" type="button" onclick="exportExcel();" target="_blank"><i class="fa fa-sign-out"></i>导出</a>
		        </div>
	        </form>  
	    </div>  
	      
     <div class="row">
         <div class="col-xs-12">
             <!-- PAGE CONTENT BEGINS -->
             <table id="grid-table"></table>
             <div id="grid-pager"></div>
             <!-- PAGE CONTENT ENDS -->
         </div><!-- /.col -->
     </div><!-- /.row -->
</@layout>


<script type="text/javascript">
var $path_base = "/";
var grid_selector = "#grid-table";
var pager_selector = "#grid-pager";
function exportExcel(){
	window.location.href=
	encodeURI("${CONTEXT_PATH}/userManage/export?formData="+JSON.stringify($("form").serializeArray())
		+"&colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
		+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
	);
}
function getSelRowToEdit(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再回复");
        return;
    }
	var rowData = $("#grid-table").jqGrid("getRowData",selr);
    window.location.href="${CONTEXT_PATH}/submitMsg/initRepWxmsg?msgFrom="+rowData.open_id;
}
function repAll(){
	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
    window.location.href="${CONTEXT_PATH}/submitMsg/initRepWxmsg?ids="+ids.join();
}
jQuery(function($) {  
    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterManage/userList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['序号','微信用户标示', '性别', '手机号','昵称','生日','真实姓名',
        			'用户地址','注册时间','用户头像','会员余额','会员积分','状态','关联鲜果师'],
        colModel:[
            {name:'id',index:'id', width:200, sorttype:"int", editable: false},
            {name:'open_id',index:'open_id',width:200, editable:false},
            {name:'sexDisplay',index:'sexDisplay', width:150,editable: false},
            {name:'phone_num',index:'phone_num',width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'birthday',index:'birthday', width:150,editable: false},
            {name:'realname',index:'realname', width:150,editable: false},
            {name:'user_address',index:'user_address', width:150,editable: false},
            {name:'regist_time',index:'regist_time', width:150,editable: false},
            {name:'user_img_id',index:'user_img_id', width:150,editable: false,formatter: photoFormatter},
            {name:'balance',index:'balance', width:150,editable: false},
            {name:'member_points',index:'member_points', width:150,editable: false},
            {name:'statusDisplay',index:'statusDisplay', width:150,editable: false},
            {name:'master_name',index:'store_name', width:150,editable: false}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30,200],
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
        //双击表格行回调函数
        ondblClickRow:function(rowid, iRow, iCol, e){
        	window.open("${CONTEXT_PATH}/userManage/userInfosList?id="+rowid);
        },
        caption: "用户管理",
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
    	 return "<img src='"+rowdata[9]+"' style='width:40px;height:40px;' />";
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