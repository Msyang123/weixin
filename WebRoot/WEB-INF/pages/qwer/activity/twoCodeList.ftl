<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >

<div class="col-xs-12 wigtbox-head form-inline">
    <div class="pull-right">	    
	    <button class="btn btn-warning btn-sm" type="button"  onclick="window.location.href='${CONTEXT_PATH}/activityManage/initTwoCodeEdit'">
		    <i class="fa fa-plus bigger-110"></i> 添加
		</button>
		<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
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

<script>
    function getSelRowToEdit(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再编辑");
            return;
        }
        window.location.href="${CONTEXT_PATH}/activityManage/initTwoCodeEdit?id="+selr;
    }
    
    function getSelRowToSetting(){
    	var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再设置");
            return;
        }
        window.location.href="${CONTEXT_PATH}/activityManage/initSetting?id="+selr;
    }
</script>
</@layout>

<script type="text/javascript">
$(function() {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    $(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/twoCodeList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','奖品名称','图片', '概率','排序','奖品类型'],
        colModel:[
            {name:'id',index:'id', editable: true},
            {name:'award_name',index:'award_name', editable:true, sorttype:"date"},
            {name:'save_string',index:'save_string',editable: true,
                  formatter:function(value,grid,rows,state){
                	return "<img src='"+value+"' style='width:40px;height:40px;' onerror='imgLoad(this)' />";
                  }
            },
            {name:'award_percent',index:'award_percent',editable: true},
            {name:'award_sequence',index:'award_sequence',editable: true},
            {name:'award_type',index:'award_type',editable: false,
                formatter:function(cellvalue,options,rows){
                    //console.log(cellvalue);
                    if(cellvalue=="1"){
                    	return "鲜果币";
                    }else if(cellvalue=="2"){
                    	return "优惠券";
                    }else if(cellvalue=="3"){
                    	return "实物奖品";
                    }else{
                    	return "谢谢惠顾";
                    }
                }
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
        editurl: "${CONTEXT_PATH}/activityManage/e",
        caption: "二维码抽奖奖品设置",
        autowidth: true,
        sortname:'id',
        sortorder:'desc'
    });

    initNavGrid(grid_selector,pager_selector);
 
});
</script>