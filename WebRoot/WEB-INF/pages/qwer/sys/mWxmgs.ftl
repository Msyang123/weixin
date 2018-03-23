<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head">
	<form id="submitForm">
	    <div class="pull-left">
	        <input class="form-control" id="keyWord" name="keyWord" type="text" placeholder="内容" />
	    </div>
	    <div class="pull-right">
		    <button class="btn btn-info btn-sm" type="button"
		            onclick="jQuery('#grid-table').setGridParam({postData:{'keyWord':$('#keyWord').val()}}).trigger('reloadGrid');">
		        <i class="fa fa-search bigger-110"></i> 搜索
		    </button>
		    <button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
			    <i class="fa fa-paper-plane bigger-110"></i> 回复
		    </button>
		</div>
	</form>
</div>
<div class="col-xs-12">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->
<script>
    function getSelRowToEdit(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再回复");
            return;
        }

        window.location.href="${CONTEXT_PATH}/submitMsg/initRepWxmsg?id="+selr;
    }
</script>
</@layout>


<script type="text/javascript">
var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/submitMsg/searchWxmsgs",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:[ '编号','消息发送人','昵称','头像', '发送内容'],
        colModel:[
            {name:'id',index:'id', width:60, sorttype:"int", editable: false},
            {name:'msg_from',index:'msg_from',width:200, editable:false},
            {name:'nickname',index:'create_time', width:150,editable: false},
            {name:'user_img_id',index:'create_time', width:150,editable: false,formatter: photoFormatter},
            {name:'content',index:'content', width:300, editable: false}
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
                enableTooltips(table);
            }, 0);
        },

        editurl: "${CONTEXT_PATH}/submitMsg",//nothing is saved
        caption: "回复管理",
        autowidth: true
    });
    
  //显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[3]+"' style='width:40px;height:40px;' />";
    }
    
	initNavGrid(grid_selector,pager_selector);
	
});
</script>