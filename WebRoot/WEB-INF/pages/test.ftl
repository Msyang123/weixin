
<link rel="stylesheet" href="http://localhost:8080/weixin/plugin/kindeditor-4.1.7/themes/default/default.css" />
<script src="http://localhost:8080/weixin/plugin/kindeditor-4.1.7/kindeditor-all-min.js"></script>
<script src="http://localhost:8080/weixin/plugin/kindeditor-4.1.7/lang/zh_CN.js"></script>
<script src="http://localhost:8080/weixin/plugin/kindeditor-4.1.7/plugins/code/prettify.js"></script>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">测试图片 </label>

        <div class="col-sm-9">
        	<input type="hidden" id="h" value="" />
	        <input type="text" id="url" value="" />
	        <img id="url2"/>
			<input type="button" id="image" value="选择图片" />（网络图片 + 本地上传)
        </div>
    </div>
<script>

    /*var resuorceEditor;
		KindEditor.ready(function(K) {
            resuorceEditor = K.create('textarea[id="editor"]', {
				cssPath : 'http://localhost:8080/weixin/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : 'http://localhost:8080/weixin/resourceShow/upload?dir=image',
				fileManagerJson : 'http://localhost:8080/weixin/resourceShow/fileManage?dir=image',
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
		});*/
		KindEditor.ready(function(K) {

		 var editor = K.editor({
				cssPath : 'http://localhost:8080/weixin/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : 'http://localhost:8080/weixin/resourceShow/upload?dir=image',
				fileManagerJson : 'http://localhost:8080/weixin/resourceShow/fileManage?dir=image',
				allowFileManager : true,
			});
			//给按钮添加click事件
			K('#image').click(function() {
				editor.loadPlugin('image', function() {
					//图片弹窗的基本参数配置
					editor.plugin.imageDialog({
						imageUrl : K('#url').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
						//点击弹窗内”确定“按钮所执行的逻辑
						clickFn : function(url, title, width, height, border, align) {
							K('#url').val(url);//获取图片地址
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
		});
    
	</script>
