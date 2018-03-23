<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form id="roleForm" action="${CONTEXT_PATH}/m/addRole" class="form-horizontal pbb40" role="form" method="post">
    <input type="hidden" name="mActivity.id" id="mActivity_id" value=""/>
     <input type="hidden" name="mid" id="mid" value=""/>
    <div class="clearfix top-btn">
         <button class="btn btn-sm ml12" type="button" onclick="history.go(-1);">
           	  取消
         </button>
         <button class="btn btn-info btn-sm" type="button" onclick="whenSubmit();">
            	 提交
         </button>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="product_name">角色名称</label>
        <div class="col-sm-5">
        <input type="hidden" id="role_id" name="sysRole.id" value="${(sysRole.id)!}"/>
            <input type="text" id="role_name" name="sysRole.role_name" 
            value="${(sysRole.role_name)!}"
             placeholder="角色名称" class="form-control" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">描述</label>
        <div class="col-sm-5">
	        <textarea id="role_desc" name="role_desc" class="form-control" rows="3">${(sysRole.role_desc)!}</textarea>
        </div>
    </div>
</form>

<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm1">
      <div class="pull-left">
	   <div class="zTreeDemoBackground left">
		<ul id="muneTree" class="ztree"></ul>
	   </div>
      </div>
	</form>
</div>
</@layout>

<script>
 $(function(){
	 var role_id=$("#role_id").val();
		var setting = {
				view: {
					selectedMulti: true
				},
				async: {
					enable: true,
					url:"${CONTEXT_PATH}/m/initTree?role_id="+role_id,
					autoParam:["id", "name=n", "level=lv"],
					otherParam:{"otherParam":""}
					//dataFilter: filter
				},
				edit: {
					enable: true,
					showRemoveBtn: false,
					showRenameBtn: false
				},
				data: {
					keep: {
						parent:true,
						leaf:true
					},
					simpleData: {
						enable: true
					}
				},
				check: {
					enable: true
				},
				callback: {
					onAsyncSuccess: onAsyncSuccess,
// 					onCheck: onCheck
				}
		};
		$.fn.zTree.init($("#muneTree"), setting);  
	});
function filter(treeId, parentNode, childNodes) {
	if (!childNodes) return null;
	for (var i=0, l=childNodes.length; i<l; i++) {
		childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
	}
	return childNodes;
}


var isFirst = true;
function onAsyncSuccess(event, treeId,treeNode,msg) {
	var zTree = $.fn.zTree.getZTreeObj("muneTree");	 
	if (isFirst){
		  //获取根节点个数,getNodes获取的是根节点的集合
	      var nodeList = zTree.getNodes();
	　　　　//展开所有根节点
	      for (var i = 0; i < nodeList.length; i++){ //设置节点展开
	    	  zTree.expandNode(nodeList[i], true, true,true);
	      }
	     //当再次点击节点时条件不符合,直接跳出方法
	      isFirst= false;
	 }
	console.log(msg);
}
function whenSubmit(){
	 var treeObj=$.fn.zTree.getZTreeObj("muneTree");
   	 nodes=treeObj.getCheckedNodes(true);	 
   	 var mid=[];
     for(var i=0;i<nodes.length;i++){
   		//console.log(nodes[i].id); //获取选中节点的值
   		mid.push(nodes[i].id);
     }
     $("#mid").val(mid);
     $("#roleForm").submit();
     /* var role_name=$("#role_name").val();
     var role_desc=$("#role_desc").val();
     var data={role_name:role_name,role_desc:role_desc,mid:mid};
     $.ajax({
     	url:"${CONTEXT_PATH}/adminManage/addRole",
     	data:data,
     	success:function(data){
     		alert(data.msg);
     		$("#grid-table").trigger("reloadGrid");
     	}
     }); */
}
</script>