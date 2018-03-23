<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>
<form  class="form-horizontal" role="form" method="post" action="${CONTEXT_PATH}/weixin/sendCustomMessage" >
    <input type="hidden" id="id" name="id" value="${id!}"/>
    <input type="hidden" id="msgFrom" name="msgFrom" value="${msgFrom!}"/>
    <input type="hidden" id="ids" name="ids" value="${ids!}"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="content">回复内容 </label>

        <div class="col-sm-9">
            <input type="text" id="content" name="content" placeholder="回复内容" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="submit">
                <i class="icon-ok bigger-110"></i>
               回复
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
	<#if msg??>
		alert('${msg}');
	</#if>
	
</script>