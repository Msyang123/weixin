<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] 
styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css","${CONTEXT_PATH}/plugin/zTree_v3/css/demo.css","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/masterProductManage/productSave" class="form-horizontal" role="form" method="post">
    <input type="hidden" id="masterId" name="masterDetail.id" value="${masterDetail.id}"/>
	<div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title"> 申请人名称</label>
        <div class="col-sm-9">
			<input name="masterDetail.master_name" value="${masterDetail.master_name!}" />
        </div>
    </div>
    				
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="product_name">身份证号码</label>
        <div class="col-sm-9">
            <input type="text" id="product_name" readonly name="masterDetail.idcard" 
            value="${masterDetail.idcard!}"
              class="col-xs-10 col-sm-5"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">手机号码</label>
        <div class="col-sm-9">
            <input type="text" id="product_code" readonly name="masterDetail.mobile" placeholder="产品编码" 
            value="${masterDetail.mobile!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">身份证正面 </label>
        <div class="col-sm-9">
	         <img id="url" style="width:50%;" src="${masterDetail.idcard_face!}"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url1">身份证反面 </label>
        <div class="col-sm-9">
	          <img id="url1" style="width:50%;" src="${masterDetail.idcard_opposite!}"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url2">资质证明 </label>
        <div class="col-sm-9">
	            <img id="url2" style="width:50%;" src="${masterDetail.qualification!}"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">推荐人</label>
        <div class="col-sm-9">
            <input type="text"  readonly name="masterDetail.master_recommend" 
             value="${(masterDetail.recommend_person.recommend_person)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-success" type="button" onclick="cherkPass();">
               		通过
            </button>
             <button class="btn btn-danger" id="noPass" type="button" onclick="notPassButton();">
                	不通过
            </button>
            <button class="btn" type="button" onclick="history.go(-1);">
               		 取消
            </button>
        </div>
    </div>
</form>

<div class="modal fade" id="cherk_master" tabindex="-1" role="dialog" aria-hidden="true">
    <form>
	    <div class="modal-dialog" >
	        <div class="modal-content pd20">
				<div class="form-group">
			        <h4>请输入不通过的原因 </h4>
			        <input type="hidden" id="masterId" name="masterDetail.id" value="${masterDetail.id}"/>
			        <textarea id="editor" rows="5" cols="60"></textarea>
			    </div>
			    <div class="col-12 text-center">
	           		<button class="btn btn-sm btn-info" type="button" onclick="cherkNotPass();">
	                	确认
	            	</button>
	            	<button class="btn btn-sm" data-dismiss="modal" aria-hidden="true">
	                	取消
	                </button>
	           </div>
	           
	        </div>
	    </div>
    </form>
</div>
</@layout>

<script>

function cherkPass(){
	var masterId=$("#masterId").val();
	var mobileNum=$("#product_code").val();
	if(!masterId){
		alert("没有对应的数据！");
		return;
	}
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/cherkPass?id="+masterId+"&mobileNum="+mobileNum,
        success: function(data) {
        	window.location.href="${CONTEXT_PATH}/masterManage/initCherkMasterList";
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

function notPassButton(){
	$("#noPass").css("data-target","#cherk_master");
	$("#cherk_master").modal();	
}

function cherkNotPass(){
	var masterId=$("#masterId").val();
	var mobileNum=$("#product_code").val();
	if(!masterId){
		alert("没有对应的数据！");
		return;
	}
	var reason=$("#editor").val();
	if(!reason){
		alert("原因不能为空！");
		return;
	}
	var data={masterId:masterId,reason:reason,mobileNum:mobileNum};
	$.ajax({
        type: "POST",
        url:"${CONTEXT_PATH}/masterManage/cherkNotPass",
        data:data,
        success: function(data) {
        	window.location.href="${CONTEXT_PATH}/masterManage/initCherkMasterList";
        },
        error: function(request) {
            alert("Connection error");
        },
    });
}

//提交表单
 function whenSubmit(){
 	var html=$(".ke-edit-iframe").contents().find("body").html(); 
	$("#product_detail").val(html);
 	if($('#categoryIdValue').val()==''){
 		alert('商品分类不能为空'); return false;
 	}
    $(".form-horizontal").submit();
 }


</script>