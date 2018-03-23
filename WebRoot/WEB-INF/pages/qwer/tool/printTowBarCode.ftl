<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form action="${CONTEXT_PATH}/activityManage/initPrintTwoBarCode" 
	class="form-horizontal" role="form" method="post">
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">二维码内容 </label>

        <div class="col-sm-9">
            <input type="text" id="code" 
            name="code" value="${code!}" 
            placeholder="二维码内容" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="title">生成后的二维码</label>

        <div class="col-sm-9">
            <img src="${CONTEXT_PATH}/activityManage/printTwoBarCode?code=${code!}">
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" onclick="whenSubmit();">
                <i class="icon-ok bigger-110"></i>
                生成
            </button>

            &nbsp; &nbsp; &nbsp;
            <button class="btn" type="button" onclick="history.go(-1);">
                <i class="icon-undo bigger-110"></i>
                取消
            </button>
        </div>
    </div>
</form>
</@layout>

<script>
    function whenSubmit(){
    	$("#code").val(encodeURIComponent($("#code").val()));
        $(".form-horizontal").submit();
    }
</script>