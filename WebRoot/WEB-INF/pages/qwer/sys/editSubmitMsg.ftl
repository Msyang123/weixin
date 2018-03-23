<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-min.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=[]>

<form action="submitMsg/saveSubmitMsg" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="sm.id" value="${sm.id!}"/>
    <input type="hidden" name="sm.content" id="content" value="${sm.content!}"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="message_type"> 消息类型 </label>

        <div class="col-sm-9">
            <div class="radio">
                <#if sm?? && sm.message_type??>
                    <label>
                        <input id="commonMessage" name="sm.message_type" type="radio" class="ace" value="1" <#if (sm.message_type==1)>checked="checked" </#if>/>
                        <span class="lbl">普通消息</span>
                    </label>

                    <label>
                        <input id="mixedMessage" name="sm.message_type" type="radio" class="ace" value="2" <#if (sm.message_type==2)>checked="checked" </#if>/>
                        <span class="lbl">文字图片消息</span>
                    </label>

                    <label>
                        <input id="pictureMessage" name="sm.message_type" type="radio" class="ace" value="3" <#if (sm.message_type==3)>checked="checked" </#if>/>
                        <span class="lbl">图片消息</span>
                    </label>

                    <label>
                        <input id="subscribeMesage" name="sm.message_type" type="radio" class="ace" value="4" <#if (sm.message_type==4)>checked="checked" </#if>/>
                        <span class="lbl">订阅消息</span>
                    </label>
                <#else>
                    <label>
                        <input id="commonMessage" name="sm.message_type" type="radio" class="ace" value="1" />
                        <span class="lbl">普通消息</span>
                    </label>

                    <label>
                        <input id="mixedMessage" name="sm.message_type" type="radio" class="ace" value="2" />
                        <span class="lbl">文字图片消息</span>
                    </label>

                    <label>
                        <input id="pictureMessage" name="sm.message_type" type="radio" class="ace" value="3" />
                        <span class="lbl">图片消息</span>
                    </label>

                    <label>
                        <input id="subscribeMesage" name="sm.message_type" type="radio" class="ace" value="4" />
                        <span class="lbl">订阅消息</span>
                    </label>
                </#if>
            </div>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="key_word"> 关键字 </label>

        <div class="col-sm-9">
            <input type="text" id="key_word"  name="sm.key_word" value="${sm.key_word!}" placeholder="关键字" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="editor"> 内容 </label>
        <textarea id="editor" style="width:700px;height:300px;" >${sm.content!}</textarea>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="pic_url"> 图片 </label>

        <div class="col-sm-9">
            <input type="text" id="pic_url" name="sm.pic_url" placeholder="图片" value="${sm.pic_url!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url"> 链接地址 </label>

        <div class="col-sm-9">
            <input type="text" id="url" name="sm.url" placeholder="链接地址" value="${sm.url!}" class="col-xs-10 col-sm-5" />
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
    <#if sm.key_word??>
    
		KindEditor.ready(function(K) {
             resuorceEditor=K.create('textarea[id="editor"]', {
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
			 resuorceEditor=K.create('textarea[id="editor"]', {
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