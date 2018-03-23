<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<script>
    function getSelRowToCheck(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再操作");
            return;
        }
        $.ajax({
            cache: false,
            type: "POST",
            url:"${CONTEXT_PATH}/system/check",
            data:{'id':selr},
            async: false,
            error: function(request) {
                alert("操作错误");
            },
            success: function(data) {
                jQuery('#grid-table').trigger('reloadGrid');
            }
        });
    }
</script>
	<div class="col-xs-12 wigtbox-head">
		<form id="submitForm">
		    <div class="pull-left">
		       <input class="form-control" id="username" name="username" type="text" placeholder="公众账号" />		       
		    </div>
		    
		    <div class="pull-right">	  
		        <button class="btn btn-info btn-sm" type="button"
			            onclick="jQuery('#grid-table').setGridParam({postData:{'username':$('#username').val()}}).trigger('reloadGrid');">
			        <i class="fa fa-search bigger-110"></i> 搜索
			    </button>  
			    <button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToCheck();">
				    <i class="fa fa-check bigger-110"></i> 审核通过
				</button>
			</div>
			<div class="clearfix"></div>
		</form>
	</div>
    
    <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        <table id="grid-table"></table>
        <div id="grid-pager"></div>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</@layout>


<script type="text/javascript">
var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/system/getSysusersJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','公众账号','AppId', 'AppSecret', '用户标示','UUID','账户状态'],
        colModel:[
            {name:'id',index:'id', width:60, sorttype:"int", editable: true},
            {name:'username',index:'username',width:90, editable:true},
            {name:'app_id',index:'app_id', width:150,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'app_key',index:'app_key', width:70, editable: true,edittype:"checkbox",editoptions: {value:"Yes:No"},unformat: aceSwitch},
            {name:'user_kind',index:'user_kind', width:90, editable: true,edittype:"select",editoptions:{value:"1:管理员;0:非管理员;3:其它"},
                formatter:function(cellvalue, options, rowObject){if(cellvalue==1){return "管理员"} else if(cellvalue==0){return "非管理员"}else{return "其它"}}
            },
            {name:'uuid',index:'uuid', width:150, sortable:false,editable: true,edittype:"textarea", editoptions:{rows:"2",cols:"10"}},
            {name:'valid_flag',index:'valid_flag', width:90, editable: true,edittype:"select",editoptions:{value:"'1':正常;'2':未审核"},
                formatter:function(cellvalue, options, rowObject){if(cellvalue=='1'){return "正常"}else{return "未审核"}}
            }
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
        editurl: "${CONTEXT_PATH}/system/check",//nothing is saved
        caption: "公众账号管理",
        autowidth: true

    });
    initNavGrid(grid_selector,pager_selector);
});
</script>