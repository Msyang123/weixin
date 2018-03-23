<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>

<form action="${CONTEXT_PATH}/masterCarouselManage/saveMCarousel" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="mCarousel.id" value="${(mCarousel.id)!}"/>
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">url </label>
        <div class="col-sm-9">
            <input type="text" id="url" name="mCarousel.url" value="${(mCarousel.url)!}" class="col-sm-4"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="order_id">排序 </label>
        <div class="col-sm-9">
            <input type="text" id="order_id" name="mCarousel.order_id" value="${(mCarousel.order_id)!}"  class="col-sm-4"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">轮播图名称 </label>
        <div class="col-sm-9">
            <input type="text" id="carousel_name" name="mCarousel.carousel_name" value="${(mCarousel.carousel_name)!}" class="col-sm-4"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="img_id">图片编号 </label>
        <div class="col-sm-9">
            <input type="text" id="img_id" name="mCarousel.img_id" value="${(mCarousel.img_id)!}" class="col-sm-4"/>
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="url">banner</label>
        <div class="col-sm-9">
	        <input type="hidden" id="image_src" name="image_src" value="${(image.save_string)!}" />
	        <input type="hidden" id="image_id" name="image_id" value="${(image.id)!0}"/>
	        <img id="url2" src="${(image.save_string)!}"/>
			<input type="button" id="image" value="选择图片"/>
        </div>
    </div>
    
    <div class="form-group" id="show_type">
        <label class="col-sm-3 control-label no-padding-right">活动类型 </label>
        <div class="col-sm-9">
            <select onchange="change();" id="type_id" name="mCarousel.type_id">
            	<#if (mCarousel.type_id)??>
	        		<option value="1" <#if  mCarousel.type_id==1>selected</#if>>鲜果师首页轮播图</option>
	        		<option value="2" <#if  mCarousel.type_id==2>selected</#if>>鲜果师商城轮播图</option>
        		<#else>
        			<option value="1"  >鲜果师首页轮播图</option>
	        		<option value="2"  >鲜果师商城轮播图</option>
        		</#if>
        	</select>
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info btn-sm" type="button" onclick="whenSubmit();">
               		 提交
            </button>
            <button class="btn btn-sm" type="button" onclick="history.go(-1);">
              		  取消
            </button>
        </div>
    </div>
</form>

</@layout>

<script>
    function whenSubmit(){
        $("#content").val($(".ke-edit-iframe").contents().find("body").html());
        $(".form-horizontal").submit();
    }
	var editor;
	var K=window.KindEditor;
	<#if (mCarousel.carousel_name)??>
		KindEditor.ready(function(K) {

		 editor = K.editor({
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+$('#carousel_name').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+$('#carousel_name').val(),
				allowFileManager : true,
			});
			//给按钮添加click事件
			K('#image').click(function() {
				editor.loadPlugin('image', function() {
					//图片弹窗的基本参数配置
					editor.plugin.imageDialog({
						imageUrl : K('#image_src').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
						//点击弹窗内”确定“按钮所执行的逻辑
						clickFn : function(url, title, width, height, border, align) {
							K('#image_src').val(url);//获取图片地址
							K('#url2').attr("src",url);
							$('#image_id').val(0);
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
		});	
	<#else>
		K('#carousel_name').blur(function (){
			if($('#carousel_name').val()==''){
				alert('请先填写轮播图名称');
				return;
			}
		 	editor = K.editor({
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+$('#carousel_name').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+$('#carousel_name').val(),
				allowFileManager : true,
			});
		});
		K('#image').click(function () {
			if($('#carousel_name').val()==''){
				alert('请先填写轮播图名称');
				return;
			}
			editor.loadPlugin('image', function() {
				//图片弹窗的基本参数配置
				editor.plugin.imageDialog({
					imageUrl : K('#image_src').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
					//点击弹窗内”确定“按钮所执行的逻辑
					clickFn : function(url, title, width, height, border, align) {
						K('#image_src').val(url);//获取图片地址
						K('#url2').attr("src",url);
						$('#image_id').val(0);
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
	</#if>
</script>