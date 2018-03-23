<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-min.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=[]>



<div >
	<textarea id="editor" style="width:700px;height:300px;" > </textarea>
</div>
<br />
<br />
<p>
				<input type="button" name="getHtml" value="取得HTML" />
				<input type="button" name="isEmpty" value="判断是否为空" />
				<input type="button" name="getText" value="取得文本(包含img,embed)" />
				<input type="button" name="selectedHtml" value="取得选中HTML" />
				<br />
				<br />
				<input type="button" name="setHtml" value="设置HTML" />
				<input type="button" name="setText" value="设置文本" />
				<input type="button" name="insertHtml" value="插入HTML" />
				<input type="button" name="appendHtml" value="添加HTML" />
				<input type="button" name="clear" value="清空内容" />
				<input type="reset" name="reset" value="Reset" />
			</p>

</@layout>

<script>
		KindEditor.ready(function(K) {
			var editor1 = K.create('textarea[id="editor"]', {
				cssPath : '/plugin/kindeditor-4.1.10/code/prettify.css',
				uploadJson : '/resourceShow/upload?dir=image',
				fileManagerJson : '/resourceShow/fileManage?dir=image',
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
			K('input[name=getHtml]').click(function(e) {
				alert(editor1.html());
			});
			K('input[name=isEmpty]').click(function(e) {
				alert(editor1.isEmpty());
			});
			K('input[name=getText]').click(function(e) {
				alert(editor1.text());
			});
			K('input[name=selectedHtml]').click(function(e) {
				alert(editor1.selectedHtml());
			});
			K('input[name=setHtml]').click(function(e) {
				editor1.html('<h3>Hello KindKindEditor</h3>');
			});
			K('input[name=setText]').click(function(e) {
				editor1.text('<h3>Hello KindEditor</h3>');
			});
			K('input[name=insertHtml]').click(function(e) {
				editor1.insertHtml('<strong>插入HTML</strong>');
			});
			K('input[name=appendHtml]').click(function(e) {
				editor1.appendHtml('<strong>添加HTML</strong>');
			});
			K('input[name=clear]').click(function(e) {
				editor1.html('');
			});
		});
	</script>