<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css"] >
	   
	   <div class="col-xs-12 wigtbox-head">
			<form id="submitForm" class="form-inline">
			   <div class="pull-left">
					  <div class="form-group">
						    <input id="articleName" name="articleName" class="form-control" placeholder="文章名称"/>
						    <div class="input-group">
							    <input id="categoryId" type="text" readonly value="" placeholder="文章分类"/>
						        <span class="input-group-btn"><button class="btn btn-info btn-sm" id="menuBtn" onclick="showMenu(); return false;">选择</button></span>
								<input id="categoryIdValue" type="hidden" value="" />
							</div>
							  文章状态
							<select  id="articleStatus" name="articleStatus" class="form-control">
								<option value="0">审核</option>
								<option value="1">审核通过</option>
							</select>
					        <button class="btn btn-primary btn-sm" type="button" 
					         onclick="jQuery('#grid-table')
					                .setGridParam({postData:{'categoryIdValue':$('#categoryIdValue').val(),
					                'articleStatus':$('#articleStatus').val(),
					                'articleName':$('#articleName').val()}})
					                .trigger('reloadGrid');">
					            <i class="fa fa-search bigger-110"></i>查询
					        </button>
				       </div>
		        </div>
		        <div class="pull-right">
					<button class="btn btn-warning btn-sm btn-add" type="button"/>
					     <i class="fa fa-plus bigger-110"></i> 添加
					</button>
					<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToEdit();">
					    <i class="fa fa-edit bigger-110"></i> 编辑
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
		<script>
		    function getSelRowToEdit(){
		    	debugger;
		        var selr = jQuery("#grid-table").getGridParam('selrow');
		        if(!selr){
		            alert("请先选择一行数据再编辑");
		            return;
		        }
		        window.location.href="${CONTEXT_PATH}/masterArticleManage/initArticle?article_id="+selr;
		    }
		</script>
</@layout>

<div class="modal fade" id="detail-dialog" tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                 <h4 class="modal-title pull-left">文章详情</h4>
	                 <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				     </button>
				     <div class="clearfix"></div>
	            </div>
	            <div class="modal-body">
	            	<div id="html-page-form" class="form-horizontal">
	            		<div class="form-group">
		        			<div class="col-md-6">
		        			    <label class="col-md-5">文章标题：</label>
						        <div class="TITLE col-md-7 nopd-lr"></div>
		        			</div>
							<div class="col-md-6">
								<label class="col-md-5">状态：</label>
						        <div class="STATUS col-md-7 nopd-lr"></div>
							</div>
					    </div>
					    <div class="form-group">
		        			<div class="col-md-6">
		        			    <label class="col-md-5">投稿人：</label>
						        <div class="CONTRIBUTION_PENSON col-md-7 nopd-lr"></div>
		        			</div>
							<div class="col-md-6">
								<label class="col-md-5">编辑人：</label>
						        <div class="EDIT_PENSON col-md-7 nopd-lr"></div>
							</div>
					    </div>
					    <div class="form-group">
							<div class="col-md-6">
								<label class="col-md-5">创建时间：</label>
						        <div class="CREATE_TIME col-md-7 nopd-lr"></div>
							</div>
					    </div>
					    <div class="form-group">
					        <div class="col-md-12">
								<label class="col-md-2 nopd-l ml20">简介图：</label>
						        <div class="CONTENT_IMAGE col-md-7 nopd-lr"><img src="" class="img-responsive" /></div>
					        </div>
					    </div>
					    <div class="form-group">
					        <div class="col-md-12">
								<label class="col-md-2 nopd-l ml20">首部图：</label>
						        <div class="HEAD_IMAGE col-md-7 nopd-lr"><img src="" class="img-responsive" /></div>
					        </div>
					    </div>
					    <div class="form-group">
					        <div class="col-md-12">
								<label class="col-md-3 nopd-l">文章简介：</label>
						        <div class="ARTICLE_INTRO col-md-8 nopd-lr"><img src="" class="img-responsive" /></div>
					        </div>
					    </div>
					    <div class="form-group">
					        <div class="col-md-12">
								<label for="URL" class="col-md-3 nopd-l">文章链接 ：</label>
						        <div class="URL col-md-8 nopd-lr"></div>
					        </div>
					     </div> 
					     <div class="form-group">
					        <div class="col-md-12">
								<label for="HTML_PAGE_CONTENT" class="col-md-3">页面预览 ：</label>
						        <a id="content_preview" href="javascript:void(0);" target="_blank" class="btn btn-info btn-sm">预览</a>
					        </div>
					     </div>  
					</div>
	            </div>
	        </div>
	    </div>
</div><!--/End detail-dialog-->
<script type="text/javascript">
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

function editHtml(id){
	debugger;
	if(null == id || "" == id){
		alert("请选择一行数据");
		return;
	}
    window.location.href="${CONTEXT_PATH}/masterArticleManage/initArticle?article_id="+id;
}

//删除文章
function confrimDel(){
	debugger;
	var selr = jQuery("#grid-table").getGridParam('selrow');
	var rowData = $('#grid-table').jqGrid('getRowData',selr);
    if(!selr){
        alert("请先选择一行数据再操作");
        return;
    }
    var article_id = rowData["id"];
    var content= "可能导致数据丢失!确认删除？";
    if(confirm(content)){
         $.ajax({
            url: "${CONTEXT_PATH}/masterArticleManage/deleteArticleAjax?id="+article_id,
            type:'Get',
            success:function(data){
 				if(data.result){
 					alert(data.msg);
 					$('#grid-table').trigger("reloadGrid");
 				}else{
 					alert(data.msg);
 				}
            }
        });
    }
}

$('.btn-add').on('click',function(){
	window.location.href='${CONTEXT_PATH}/masterArticleManage/editArticle';
});

//查看详情    
$('#detail-dialog').on('show.bs.modal',function(e){
		debugger;
      var $button=$(e.relatedTarget);
      var id=$button.data("id");
      var modal = $(this);
      //发送ajax回去查询单条数据
      $.ajax({
    	  url: "${CONTEXT_PATH}/masterArticleManage/articleDetail?id="+id,
            type:'Get',
            data:{id:id},
            success:function(data){
            	modal.find('.TITLE').html(data.title);
            	modal.find('.STATUS').html(data.status=="0"?"正常":"下架");
            	modal.find('.CONTRIBUTION_PENSON').html(data.contribution_penson);
            	modal.find('.EDIT_PENSON').html(data.edit_penson);
            	modal.find('.CREATE_TIME').html(data.create_time);
            	modal.find('.CONTENT_IMAGE img').attr('src',data.content_image);
            	modal.find('.HEAD_IMAGE img').attr('src',data.head_image);
            	modal.find('.ARTICLE_INTRO').html(data.article_intro);
            	modal.find('.URL').html(data.url);
            	modal.find('#content_preview').attr("href",data.url);
            }
      });
});

function confrimOpenOrClose(id,status){
	//debugger;
	var content;
	var articleStatus;
    if("" == id || null == id){
        alert("请先选择一行数据再操作");
        return;
    }
	if("0" == status){
		articleStatus = "1";
		content = "确定下架文章";
	}else {
		articleStatus = "0";
		content = "确定上架文章";
	}
	
	if(confirm(content)){
        $.ajax({
        	url:'${CONTEXT_PATH}/masterArticleManage/switchStatus?articleId='+id+'&status='+articleStatus,
        	type:'Get',
		    success:function(data){
		    	if(data.success){
		    	    alert(data.msg);
		    		$('#grid-table').trigger("reloadGrid");
		    	}else{
		    		alert(data.msg);
		    	}
		    }
        });
	}
}

jQuery(function($) {
	$.fn.zTree.init($("#category"), setting);
	
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/masterArticleManage/articleListAjax",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['编号','文章名称','文章分类','投稿人','文章状态' ,'url','推荐文章','操作'],
        colModel:[
        	{name:'id',index:'id', width:'70', sorttype:"int", editable: false},
            {name:'title',index:'title',width:150,editable: false},
            {name:'category_name',index:'category_name',width:90, editable:false},
            {name:'contribution_penson',index:'contribution_penson', width:70,editable: false},
            {name:'status',index:'status', width:'70',editable: false,
            	formatter: function(cellvalue,options,rowObject){
            		var statusStr;
            		switch(cellvalue){
            		case 0:
            			statusStr = "正常";
            			break;
            		case 1:
            			statusStr = "下架";
            			break;
            		default:
                		statusStr = "N/A";
            			break;
            		}
            		return statusStr;
            	},
                cellattr : function(rowId, val, rawObject, cm, rdata){
 	             	var value = rawObject[4];
                	if(value != 0){
	             		   return " style='color:red'";
	             	   }
	                } 
            },
            {name:'url',index:'url', width:150,editable: false},
            {name:'recommend_product_name',index:'recommend_product_name', width:150,editable: false},
            {name:'myac',index:'', fixed:true, sortable:false, resize:false,
                formatter: function(cellvalue,options,rowObject){
                	var myacStr;
                	var value = rowObject[4];
                	var id = rowObject[0];
                	if("0" == value){
                		myacStr = '<a class="btn btn-danger btn-xs mr5" title="下架" onclick=confrimOpenOrClose('+id+','+value+')><i class="fa fa-cloud-download"></i></a>'+
                		 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#detail-dialog" data-id="'+id+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
				         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" onclick="editHtml('+id+');"><i class="fa fa-edit"></i></a>'+
				         '<a class="btn btn-danger btn-xs mr5" title="删除" onclick="confrimDel();"><i class="fa fa-trash"></i></a>';
                	}else{
                		myacStr = '<a class="btn btn-success btn-xs mr5" title="上架" onclick=confrimOpenOrClose('+id+','+value+')><i class="fa fa-cloud-upload"></i></a>'+
                		 '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#detail-dialog" data-id="'+id+'" title="查看详情"><i class="fa fa-eye"></i></a>'+
				         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" onclick="editHtml('+id+');"><i class="fa fa-edit"></i></a>'+
				         '<a class="btn btn-danger btn-xs mr5" title="删除" onclick="confrimDel();"><i class="fa fa-trash"></i></a>';
                	}
				    return myacStr;
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
            }, 0);
        },
        caption: "文件列表",
        autowidth: true
    });
    
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