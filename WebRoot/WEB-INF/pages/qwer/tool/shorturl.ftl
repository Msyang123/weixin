<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form action="${CONTEXT_PATH}/weixin/shorturl" 
	class="form-horizontal" role="form" method="post">
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">url内容 </label>

        <div class="col-sm-9">
            <input type="text" id="langUrl" name="langUrl" value="${langUrl!}" 
            placeholder="url" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="title">生成后的短地址</label>

        <div class="col-sm-9">
            ${result!}
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" onclick="$('.form-horizontal').submit();">
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