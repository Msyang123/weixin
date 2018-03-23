<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-min.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=[]>

<form action="${CONTEXT_PATH}/resourceShow/saveResourceShow" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="rs.id" value="${resourceShow.id!}"/>
    <input type="hidden" name="rs.content" id="content"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="key_word"> 关键字 </label>

        <div class="col-sm-9">
            <input type="text" id="key_word" name="rs.key_word" value="${resourceShow.key_word!}" placeholder="关键字" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="editor"> 内容 </label>
        <textarea id="editor" style="width:700px;height:300px;" name="rs.content">${resourceShow.content!}</textarea>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url"> 链接地址 </label>

        <div class="col-sm-9">
            <input type="text" id="url" name="rs.url" placeholder="链接地址" value="${resourceShow.url!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" onclick="whenSubmit();">
                <i class="icon-ok bigger-110"></i>
                提交
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
    var resuorceEditor;
    var K=window.KindEditor;
    <#if resourceShow.key_word??>
		KindEditor.ready(function(K) {
            resuorceEditor = K.create('textarea[id="editor"]', {
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName='+$('#key_word').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName='+$('#key_word').val(),
				allowFileManager : true,
				afterCreate : function() {
					var self = this;
					K.ctrl(document, 13, function() {
						self.sync();
						document.forms['editForm'].submit();
					});
					K.ctrl(self.edit.doc, 13, function() {
						self.sync();
						document.forms['editForm'].submit();
					});
				}
			});
			prettyPrint();
		});
	<#else>
		K('#key_word').blur(function (){
			if($('#key_word').val()==""){
				alert("请填写关键字");
				return;
			}
			 resuorceEditor = K.create('textarea[id="editor"]', {
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName='+$('#key_word').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName='+$('#key_word').val(),
				allowFileManager : true,
				afterCreate : function() {
					var self = this;
					K.ctrl(document, 13, function() {
						self.sync();
						document.forms['editForm'].submit();
					});
					K.ctrl(self.edit.doc, 13, function() {
						self.sync();
						document.forms['editForm'].submit();
					});
				}
			});
		});	
	</#if>	
    function whenSubmit(){
        $("#content").val(resuorceEditor.html());
        $(".form-horizontal").submit();
    }
	</script>