<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
	   <div class="col-xs-12 wigtbox-head">
			<form id="submitForm" class="form-inline">
			   <div class="pull-left">
					  <div class="form-group">
						    <input id="masterName" name="masterName" class="form-control" placeholder="鲜果师名称"/>
							  创建时间	
							<input type="text" id="createDateBegin" name="createDateBegin" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			            	至
			            	<input type="text" id="createDateEnd" name="createDateEnd" value='' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
			            	  鲜果师状态
							<select  id="master_status" name="master_status" class="form-control">
								<option value="">全部</option>
								<option value="3">正常</option>
								<option value="4">停用</option>
							</select>
					        <button class="btn btn-primary btn-sm" type="button" 
					         onclick="jQuery('#grid-table')
					                .setGridParam({postData:{
					                'master_status':$('#master_status').val(),
					                'createDateBegin':$('#createDateBegin').val(),
					                'createDateEnd':$('#createDateEnd').val(),
					                'masterName':$('#masterName').val()}})
					                .trigger('reloadGrid');">
					            <i class="fa fa-search bigger-110"></i>查询
					        </button>
				       </div>
		        </div>
		        <div class="pull-right">
					<button class="btn btn-warning btn-sm" type="button" onclick="lookUpDetail();"/>
					     <i class="fa fa-eye bigger-110"></i> 查看
					</button>
					<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToEdit();">
					    <i class="fa fa-sign-out bigger-110"></i> 导出
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
 
        <!--select tree-->
        <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
			<ul id="category" class="ztree" style="margin-top: -12px;width: 180px; margin-left: -18px;"></ul>
		</div>
</@layout>

<script type="text/javascript">
var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        postData:{'isNutritionPage':false},
        url:"${CONTEXT_PATH}/masterManage/masterList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','手机号码','姓名','加盟时间','头像' ,'上级鲜果师','鲜果师状态'],
        colModel:[
        	{name:'id',index:'id', width:150, sorttype:"int", editable: false},
            {name:'mobile',index:'product_status',width:150,editable: false},
            {name:'master_name',index:'product_name',width:90, editable:false},
            {name:'create_time',index:'category_name', width:70,editable: false},
            {name:'head_image',index:'save_string', width:150,editable: false,formatter: photoFormatter},
            {name:'upName',index:'unit_name', width:150,editable: false},
            {name:'master_status',index:'unit_name', width:150,editable: false}
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
        caption: "鲜果师列表",
        autowidth: true
    });
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
	 return "<img src='"+rowdata[4]+"' style='width:40px;height:40px;' />";
}

function lookUpDetail(){
	var selr = $("#grid-table").getGridParam("selrow");
	
    if(!selr){
        alert("请先选择一行数据再删除");
        return;
    }
    window.location.href='${CONTEXT_PATH}/masterManage/initMasterDetail?id='+selr;
}

function getSelRowToEdit(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
    if(!selr){
        alert("请先选择一行数据再编辑");
        return;
    }
    window.location.href="${CONTEXT_PATH}/masterProductManage/initSave?id="+selr;
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
</script>