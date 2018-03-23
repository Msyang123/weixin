<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>
	
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

        //data: grid_data,
        url:"${CONTEXT_PATH}/feedbackManage/feedbackList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:["操作",'编号','主题','反馈内容','创建时间','用户昵称', '头像','手机号','状态'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                    editformbutton:true, 
                    editOptions:{recreateForm: true, beforeShowForm:beforeEditCallback}
                }
            },
            {name:'id',index:'id',width:90, editable:true},
            {name:'fb_title',index:'fb_title',width:90, editable:false},
            {name:'fb_content',index:'fb_content', width:150,editable: false},
            {name:'fb_time',index:'fb_time',width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'user_img_id',index:'user_img_id', width:150,editable: false,formatter: photoFormatter},
            {name:'phone_num',index:'phone_num', width:150,editable: false},
            {name:'is_deal',index:'is_deal', width:150,editable: true,
            edittype:"select",editoptions:{value:"Y:已处理;:未处理"}}
        ],

        viewrecords : true,
        rowNum:5,
        rowList:[5,10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        multiselect: true,
        //multikey: "ctrlKey",
        multiboxonly: true,
		editurl: "${CONTEXT_PATH}/feedbackManage/feedbackSave",
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },
        caption: "反馈管理",
        autowidth: true
    });
    
    initNavGrid(grid_selector,pager_selector);
});
</script>