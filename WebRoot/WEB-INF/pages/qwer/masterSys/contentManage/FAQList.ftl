<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
<div class="col-xs-12 wigtbox-head">
	<form id="submitForm" class="form-inline">
	   <div class="pull-left">
			  <div class="form-group">
				    <input id="master_FAQ_name" name="master_FAQ_name" class="form-control" placeholder="FAQ标题"/>
				    <div class="input-group">
					</div>
			        <button class="btn btn-primary btn-sm" type="button" 
			         onclick="jQuery('#master-grid-table')
			                .setGridParam({postData:{'faq_name':$('#master_FAQ_name').val()
			        		}})
			                .trigger('reloadGrid');">
			            <i class="fa fa-search bigger-110"></i>查询
			        </button>
		       </div>
        </div>
        <div class="pull-right">
			<button class="btn btn-warning btn-sm" type="button"  
			onclick="$('#faq_id').val('');$('input[type=reset]').trigger('click');$('#faq_type').val(4);$('#faq_modal').modal();"/>
			     <i class="fa fa-plus bigger-110"></i> 添加
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToEdit('#master-grid-table',4);">
			    <i class="fa fa-edit bigger-110"></i> 编辑
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDelete('#master-grid-table');">
			    <i class="fa fa-remove bigger-110"></i> 删除
			</button>
	    </div>  
    </form>   
</div>
<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="master-grid-table"></table>
    <div id="master-grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->


<div class="col-xs-12 wigtbox-head ">
	<form id="submitForm" class="form-inline">
	   <div class="pull-left">
			  <div class="form-group">
				    <input id="user_FAQ_name" name="user_FAQ_name" class="form-control" placeholder="FAQ标题"/>
				    <div class="input-group">
					</div>
			        <button class="btn btn-primary btn-sm" type="button" 
			         onclick="jQuery('#user-grid-table')
			                .setGridParam({postData:{'faq_name':$('#user_FAQ_name').val()}})
			                .trigger('reloadGrid');">
			            <i class="fa fa-search bigger-110"></i>查询
			        </button>
		       </div>
        </div>
        <div class="pull-right">
			<button class="btn btn-warning btn-sm" type="button"  
			onclick="$('#faq_id').val('');$('input[type=reset]').trigger('click');$('#faq_type').val(5);$('#faq_modal').modal();"/>
					     <i class="fa fa-plus bigger-110"></i> 添加
					</button>
					<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToEdit('#user-grid-table',5);">
					    <i class="fa fa-edit bigger-110"></i> 编辑
					</button>
					<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDelete('#user-grid-table');">
					    <i class="fa fa-remove bigger-110"></i> 删除
					</button>
			    </div>  
		    </form>   
	    </div>
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="user-grid-table"></table>
            <div id="user-grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
 
        <!--select tree-->
        <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
			<ul id="category" class="ztree" style="margin-top: -12px;width: 180px; margin-left: -18px;"></ul>
		</div>
		
<#--FAQ编辑弹窗--> 
<div class="modal fade" id="faq_modal" tabindex="-1" role="dialog" aria-hidden="true">
    <form id="FAQForm">
    <input type="hidden" id="faq_type" name="faq_type"></input>
    <input type="hidden" id="faq_id" name="faq_id"></input>
    <div class="modal-dialog" >
        <div class="modal-content pd20">
            <div class="col-12 clearfix">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
    		<div class="form-group clearfix" id="order_num_show">
		       <label class="col-sm-3 control-label text-right" for="order_num">FAQ排序:</label>
		        <div class="col-sm-9">
		            <input type="number" id="order_num" name="order_num" placeholder="" value=""/>
		        </div>
		    </div>
		    <div class="form-group clearfix" id="faq_title_show">
		       <label class="col-sm-3 control-label text-right" for="faq_title">标题：</label>
		        <div class="col-sm-9">
		            <input type="text" id="faq_title" name="faq_title" placeholder="" value="" />
		        </div>
		    </div>
		    <div class="form-group clearfix" id="faq_content_show">
		       <label class="col-sm-3 control-label text-right" for="faq_content">FAQ内容详情：</label>
		        <div class="col-sm-9">
		            <textarea rows="5" id="faq_content" name="faq_content" class="col-sm-8"></textarea>
		        </div>
		    </div>
		    <div class="col-12 text-center">
           		<button class="btn btn-info btn-sm" type="button" onclick="ajaxSubSingle();">
                	确认
            	</button>
            	<button class="btn btn-sm" data-dismiss="modal" aria-hidden="true">
                	取消
                </button>
           </div>
        </div>
    </div>
    <input type="reset" name="reset" style="display:none"/>
    </form>
    
</div>
</@layout>


<script type="text/javascript">
function addMasterFAQ(){
	$('#faq_modal').modal();
}
function getSelRowToEdit(grid_table,type){
	 var selr = jQuery(grid_table).getGridParam('selrow');
	 if(!selr){
         alert("请选择一条FAQ再编辑");
        return;
    }
    var rowData = $(grid_table).jqGrid("getRowData",selr);
    $("#faq_type").val(type);
    $("#faq_id").val(selr);
    $("#order_num").val(rowData.order_num);
    $("#faq_title").val(rowData.faq_title);
    $("#faq_content").val(rowData.faq_content);
    $('#faq_modal').modal();
};
function getSelRowToDelete(grid_table){
	 var selr = jQuery(grid_table).getGridParam('selrow');
	 if(!selr){
         alert("请选择一条FAQ再删除");
        return;
    }
    var r=confirm("确定要删除吗");
    if(!r){
    	return;
    }
    $.ajax({
    	url:"${CONTEXT_PATH}/masterArticleManage/removeMasterFAQ?faq_id="+selr,
	    type: "POST",
        success: function(data) {
        	$.dialog.alert("删除成功");
        	$(grid_table).trigger("reloadGrid");
        },
        error: function(request) {
            $.dialog.alert("删除失败");
        },
    });
};
function ajaxSubSingle(){
	var jsonData={
		faq_id:$("#faq_id").val(),
		type:$("#faq_type").val(),
		faq_title:$("#faq_title").val(),
		faq_content:$("#faq_content").val(),
		order_num:$("#order_num").val()
	};
	$.ajax({ 
			url: "${CONTEXT_PATH}/masterArticleManage/editFAQ", 
			data: jsonData, 
			success: function(data){
					$.dialog.alert("操作成功");
					$("#faq_modal").modal("hide");
					$("#master-grid-table").trigger("reloadGrid");
					$("#user-grid-table").trigger("reloadGrid");
	      	},
	      	error: function(request) {
            		$.dialog.alert("操作失败");
       		}
		});
}


var $path_base = "/";
var setting = {
	view: {
		selectedMulti: false
	},
	async: {
		enable: true,
		url:"${CONTEXT_PATH}/productManage/category",
		autoParam:["id", "name=n", "level=lv"],
		otherParam:{"otherParam":""},
		dataFilter: filter
	},
	callback: {
		onClick: onClick
	}
};
function onClick(e, treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj("category"),
	nodes = zTree.getSelectedNodes(),
	v = "";
	nodes.sort(function compare(a,b){return a.id-b.id;});
	for (var i=0, l=nodes.length; i<l; i++) {
		v += nodes[i].name + ",";
	}
	if (v.length > 0 ) v = v.substring(0, v.length-1);
	var cityObj = $("#categoryId");
	cityObj.attr("value", v);
	$("#categoryIdValue").val(treeNode.id);
}

function showMenu() {
	var categoryId = $("#categoryId");
	var categoryIdOffset = categoryId.offset();
	$("#menuContent").css({left:categoryIdOffset.left-180 + "px", 
	top:categoryIdOffset.top-60 + "px",
	zIndex:999}).slideDown("fast");

	$("body").bind("mousedown", onBodyDown);
}
function hideMenu() {
	$("#menuContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
		hideMenu();
	}
}
function filter(treeId, parentNode, childNodes) {
		if (!childNodes) return null;
		for (var i=0, l=childNodes.length; i<l; i++) {
			childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
		}
		return childNodes;
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

jQuery(function($) {
	$.fn.zTree.init($("#category"), setting);
    var master_grid_selector = "#master-grid-table";
    var master_pager_selector = "#master-grid-pager";

    jQuery(master_grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterArticleManage/masterFAQListAjax",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['顺序','标题','内容详情'],
        colModel:[
        	{name:'order_num',index:'order_num', width:10, sorttype:"int", editable: false},
            {name:'faq_title',index:'faq_title',width:50,editable: false},
            {name:'faq_content',index:'faq_content',width:150, editable:false},
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : master_pager_selector,
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
        caption: "鲜果师帮助中心",
        autowidth: true
    });
});


jQuery(function($) {
	$.fn.zTree.init($("#category"), setting);
	
    var user_grid_selector = "#user-grid-table";
    var user_pager_selector = "#user-grid-pager";

    jQuery(user_grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        url:"${CONTEXT_PATH}/masterArticleManage/userFAQListAjax",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['顺序','FAQ标题','内容详情'],
        colModel:[
        	{name:'order_num',index:'order_num', width:10, sorttype:"int", editable: false},
            {name:'faq_title',index:'faq_title',width:50,editable: false},
            {name:'faq_content',index:'faq_content',width:150, editable:false},
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : user_pager_selector,
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
        caption: "用户帮助中心",
        autowidth: true
    });
});
</script>