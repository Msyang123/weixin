<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js"] styles=[]>

<form action="${CONTEXT_PATH}/article/saveArticle" class="form-horizontal" role="form" method="post" id="article_form">
    <input type="hidden" name="article.id" value="${article.id!}"/>
    <input type="hidden" name="article.content" id="content"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">文章主标题 </label>

        <div class="col-sm-9">
            <input type="text" id="main_title" name="article.main_title" value="${article.main_title!}" placeholder="文章主标题" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">文章副标题 </label>

        <div class="col-sm-9">
            <input type="text" id="subheading" name="article.subheading" placeholder="文章副标题" value="${article.subheading!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right mr12" for="editor">内容  </label>
        <textarea id="editor" style="width:700px;height:300px;" >${article.content!}</textarea>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="dis_order">排序 </label>

        <div class="col-sm-9">
            <input type="text" id="dis_order" name="article.subheading" placeholder="排序" value="${article.subheading!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">文章类型 </label>

        <div class="col-sm-9">
            <input type="text" id="article_type" name="article.article_type" placeholder="文章类型" value="${article.article_type!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">资源地址 </label>

        <div class="col-sm-9">
            <input type="text" id="url" name="article.url" placeholder="资源地址" value="${article.url!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">图片 </label>

        <div class="col-sm-9">
        	<input type="hidden" id="h" value="" />
	        <input type="text" id="url" value="" />
	        <img id="url2"/>
			<input type="button" id="image" value="选择图片" />（网络图片 + 本地上传)
        </div>
    </div>
  
    <div class="col-sm-12 col-md-12 col-lg-12 text-center">
        <button class="btn btn-info" type="button" onclick="whenSubmit();">
            <i class="icon-ok bigger-110"></i> 提交
        </button>
        <button class="btn" type="button" onclick="history.go(-1);">
            <i class="icon-undo bigger-110"></i>  取消
        </button>
    </div>
    
</form>

</@layout>

<script>
    var resuorceEditor;
	var K=window.KindEditor;
	<#if article.main_title?? >
		KindEditor.ready(function(K) {
            resuorceEditor = K.create('textarea[id="editor"]', {
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName='+$('#main_title').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName='+$('#main_title').val(),
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
			
			K('#image').click(function () {
				resuorceEditor.loadPlugin('image', function () {
					resuorceEditor.plugin.imageDialog({
						imageUrl: K('#url').val(),
						clickFn: function (url, title, width, height, border, align) {
							K('#url').val(url);
							K('#url2').attr("src",url);
							resuorceEditor.hideDialog();
						 }
					});
				});
			});

			prettyPrint();
		});
		
	<#else>
		K('#main_title').blur(function (){
			if($('#main_title').val()==""){
				alert("请填写关键字");
				return;
			}
			 resuorceEditor = K.create('textarea[id="editor"]', {
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName='+$('#main_title').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName='+$('#main_title').val(),
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
		
		K('#image').click(function () {
			resuorceEditor.loadPlugin('image', function () {
				resuorceEditor.plugin.imageDialog({
					imageUrl: K('#url').val(),
					clickFn: function (url, title, width, height, border, align) {
						K('#url').val(url);
						K('#url2').attr("src",url);
						resuorceEditor.hideDialog();
					 }
				});
			});
		});
		</#if>
		
    function whenSubmit(){
        $("#content").val(resuorceEditor.html());
        $(".form-horizontal").submit();
    }
    
	</script>