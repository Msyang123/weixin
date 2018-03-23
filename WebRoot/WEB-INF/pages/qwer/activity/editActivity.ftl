<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form action="${CONTEXT_PATH}/activityManage/save" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="activity.id" value="${activity.id!}"/>
    <input type="hidden" name="activity.content" id="content"/>
    <input type="hidden" id="annouceContent" name="annouceContent" />
 
   <input type="hidden"  id="hidden_activity_type" value="${activity.activity_type!}"/>
    <div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">活动主标题 </label>

        <div class="col-sm-9">
            <input type="text" id="main_title" name="activity.main_title" value="${activity.main_title!}"  placeholder="活动主标题" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_subheading">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">活动副标题 </label>

        <div class="col-sm-9">
            <input type="text" id="subheading" name="activity.subheading" placeholder="活动副标题" value="${activity.subheading!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_content">
        <label class="col-sm-3 control-label no-padding-right" for="editor"> 内容 </label>
        <textarea id="editor" name="activity.content"  class="col-sm-5 ml12" rows="7">
        ${activity.content!}</textarea>
    </div>
    <div class="form-group" id="show_yxqq">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">活动时间起 </label>

        <div class="col-sm-9">
            <input type="text" id="yxq_q" name="activity.yxq_q" placeholder="活动时间起" value="${activity.yxq_q!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'yxq_z\')}'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_yxqz">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">活动时间止 </label>

        <div class="col-sm-9">
            <input type="text" id="yxq_z" name="activity.yxq_z" placeholder="活动时间止" value="${activity.yxq_z!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'yxq_q\')}'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_dis_order">
        <label class="col-sm-3 control-label no-padding-right" for="dis_order">排序 </label>

        <div class="col-sm-9">
            <input type="text" id="dis_order" name="activity.dis_order" placeholder="排序" value="${activity.dis_order!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_type">
        <label class="col-sm-3 control-label no-padding-right">活动类型 </label>
        <div class="col-sm-9">
            <select onchange="change();" id="activity_type" name="activity.activity_type">
            	<#if activity.activity_type??>
	        		<option value="1" <#if activity.activity_type==1>selected</#if>>抢购活动</option>
	        		<option value="2" <#if activity.activity_type==2>selected</#if>>底部活动</option>
	        		<option value="3" <#if activity.activity_type==3>selected</#if>>特殊活动</option>
	        		<option value="4" <#if activity.activity_type==4>selected</#if>>其他活动</option>
	        		<option value="5" <#if activity.activity_type==5>selected</#if>>优惠券活动</option>
	        		<option value="6" <#if activity.activity_type==6>selected</#if>>返券活动</option>
	        		<option value="7" <#if activity.activity_type==7>selected</#if>>满立减活动</option>
	        		<option value="8" <#if activity.activity_type==8>selected</#if>>排名活动</option>
	        		<option value="9" <#if activity.activity_type==9>selected</#if>>banner活动</option>
	        		<option value="10" <#if activity.activity_type==10>selected</#if>>团购活动</option>
	        		<option value="11" <#if activity.activity_type==11>selected</#if>>首单立送鲜果币活动</option>
	        		<option value="12" <#if activity.activity_type==12>selected</#if>>手动发券活动</option>
	        		<option value="13" <#if activity.activity_type==13>selected</#if>>九宫格活动</option>
	        		<option value="14" <#if activity.activity_type==14>selected</#if>>首页滚动公告通知</option>
	        		<option value="17" <#if activity.activity_type==17>selected</#if>>H5页发券活动</option>
	        		<option value="18" <#if activity.activity_type==18>selected</#if>>种子购活动</option>
	        		<option value="19" <#if activity.activity_type==19>selected</#if>>优惠券兑换码活动</option>
        		<#else>
        			<option value="1" >抢购活动</option>
	        		<option value="2" >底部活动</option>
	        		<option value="3" >特殊活动</option>
	        		<option value="4" >其他活动</option>
	        		<option value="5" >优惠券活动</option>
	        		<option value="6" >返券活动</option>
	        		<option value="7" >满立减活动</option>
	        		<option value="8" >排名活动</option>
	        		<option value="9" >banner活动</option>
	        		<option value="10" >团购活动</option>
	        		<option value="11" >首单立送鲜果币活动</option>
	        		<option value="12" >手动发券活动</option>
	        		<option value="13" >九宫格活动</option>
	        		<option value="14" >首页滚动公告通知</option>
	        		<option value="17" >H5页发券活动</option>
	        		<option value="18" >种子购活动</option>
	        		<option value="19" >优惠券兑换码活动</option>
        		</#if>
        	</select>
        </div>
    </div>
    <div class="form-group" id="show_url">
        <label class="col-sm-3 control-label no-padding-right">url</label>
        <div class="col-sm-9">
            <input type="text" id="url" name="activity.url" placeholder="url" value="${activity.url!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div>
    <div class="form-group" id="show_restrict">
        <label class="col-sm-3 control-label no-padding-right">限制购买数量</label>

        <div class="col-sm-9">
            <input type="text" id="restrict" name="activity.restrict" placeholder="限制购买数量" value="${activity.restrict!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div>
    <div class="form-group" id="show_status">
        <label class="col-sm-3 control-label no-padding-right">状态</label>

        <div class="col-sm-9">
        	<select id="status" name="activity.status" class="col-xs-10 col-sm-5">
			  	  <option <#if activity.status?? && activity.status==1 >selected</#if> value="1" >有效</option>
				  <option <#if activity.status?? && activity.status==2 >selected</#if> value="2" >无效</option>
			</select>
        </div>
    </div>
    <div class="form-group" id="show_yxbz">
        <label class="col-sm-3 control-label no-padding-right">有效标志</label>

        <div class="col-sm-9">
        	<select id="yxbz" name="activity.yxbz" class="col-xs-10 col-sm-5">
			  	  <option <#if activity.yxbz?? && activity.yxbz=='Y' >selected</#if> value="Y" >有效</option>
				  <option <#if activity.yxbz?? && activity.yxbz=='N' >selected</#if> value="N" >无效</option>
			</select>
        </div>
    </div>
    <div class="form-group" id="show_coupon_count">
        <label class="col-sm-3 control-label no-padding-right">优惠券数量</label>

        <div class="col-sm-9">
            <input type="text" id="coupon_count" name="activity.coupon_count" 
            placeholder="优惠券数量" value="${activity.coupon_count!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_full_amount" style="display:none;">
        <label class="col-sm-3 control-label no-padding-right" id="full_amount_text">限制金额</label>

        <div class="col-sm-9">
            <input type="text" id="full_amount" name="activity.full_amount" 
            placeholder="5800" value="${activity.full_amount!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>	
    <div class="form-group" id="show_activity_money">
        <label class="col-sm-3 control-label no-padding-right" id="activity_money_text">活动计划经费</label>

        <div class="col-sm-9">
            <input type="text" id="activity_money" name="activity.activity_money" 
            placeholder="活动计划经费" value="${activity.activity_money!}" class="col-xs-10 col-sm-5" />
            <input type="checkbox" id="money_random" name="activity.money_random" 
            <#if activity.money_random?? && activity.money_random=='Y' >checked="true"</#if> 
			onclick="this.value=(this.checked==true)?'Y':'N'" style="display:none;"/>
            <label id="money_random_text" style="display:none;">随机取值</label>
        </div>
    </div>
  
    <div class="form-group" id="show_activity_content" style="display:none;">
        <label class="col-sm-3 control-label no-padding-right" id="activity_money_text">滚动内容</label>
		<div class="col-sm-9 add_annoucements">
			<#if annouce??>
			<#list annouce as item>
			<div class="add_annoucement row mt10">
				<div class="col-sm-1" >
		        	<select id="content_type"  class="content_type">
		        		<#if item.contentType??>
					  	  <option <#if item.contentType="活动"> selected </#if>>活动</option>
						  <option <#if item.contentType="公告"> selected </#if>>公告</option>
						  <option <#if item.contentType="热讯"> selected </#if>>热讯</option>
						<#else>
						  <option  value="活动" >活动</option>
						  <option  value="公告" >公告</option>
						  <option  value="热讯" >热讯</option>
						</#if>
					</select>
		        </div>
		        
	        	<div class="col-sm-11 nopd-lr">
		            <input type="text" id="activity_content" name="activity.content" 
		            placeholder="微商城购物满58减5元，赶快来参与吧。" value="${item.activityContent!}" class="col-xs-10 col-sm-5" />
		            <#if item_index gt 0 >
		            	<button type="button" class="btn btn-danger btn-sm btn-remove ml12"><i class="fa fa-remove"></i></button>
		            </#if>
		        </div>
			</div>
			</#list>
			<#else>
				<div class="add_annoucement row mt10">
					<div class="col-sm-1" >
			        	<select id="content_type"  class="content_type">
							  <option  value="活动" >活动</option>
							  <option  value="公告" >公告</option>
							  <option  value="热讯" >热讯</option>
						</select>
			        </div>
			        <div class="col-sm-11 nopd-lr">
			            <input type="text" id="activity_content" name="activity.content" 
			            placeholder="微商城购物满58减5元，赶快来参与吧。"  class="col-xs-10 col-sm-5" />
			        </div>
				</div>
			</#if>
		<div><button type="button" class="btn btn-info btn-sm" id="btn-activity"><i class="fa fa-plus"></i></button></div>
       	</div>
       	
    </div>
    
    
    <div class="form-group" id="show_image_src">
        <label class="col-sm-3 control-label no-padding-right" for="url">banner</label>

        <div class="col-sm-9">
	        <input type="hidden" id="image_src" name="image_src" value="${(image.save_string)!}" />
	        <img id="url2" src="${(image.save_string)!}"/>
			<input type="button" id="image" value="选择图片" />
        </div>
    </div>
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" onclick="whenSubmit();">
                                                 提交
            </button>
            <button class="btn" type="button" onclick="history.go(-1);">
              	  取消
            </button>
        </div>
    </div>
</form>

</@layout>

<script>
	$(function(){
		$('.add_annoucements').on('click','.btn-remove',function(e){
		    var $remove=$(e.currentTarget);
		    $remove.parents('.add_annoucement').remove();
		});
		
		$('#btn-activity').on('click',function(){
		   		var existNum=$('.add_annoucement').length;
		   		if(existNum>5){
		    		$.dialog.alert('请不要超过6条！');
			        return false;
		       }
				var removeBtn='<button type="button" class="btn btn-danger btn-sm btn-remove ml12"><i class="fa fa-remove"></i></button>';
		        var markup='<div class="add_annoucement row mt10">'+
				'<div class="col-sm-1" >'+
		    	'<select id="content_type"  class="content_type" >'+
			    	  '<option  value="活动" >活动</option>'+
					  '<option  value="公告" >公告</option>'+
					  '<option  value="热讯" >热讯</option>'+
				'</select>'+
		    '</div>'+
		    '<div class="col-sm-11 nopd-lr">'+
		        '<input type="text" id="activity_content" name="activity.content" placeholder="微商城购物满58减5元，赶快来参与吧。"  class="col-xs-10 col-sm-5" />'
			    	+(existNum>=1?removeBtn:"")+
		    '</div>'+'</div>'; 
		       
		    $(this).parent().before(markup);	       
		});
	});

	var K=window.KindEditor;
	var resuorceEditor;
	<#if activity.id??>
		KindEditor.ready(function(K) {
            resuorceEditor = K.create('textarea[id="editor"]', {
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+K('#main_title').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+K('#main_title').val(),
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
						imageUrl: K('#image_src').val(),
						clickFn: function (url, title, width, height, border, align) {
							K('#image_src').val(url);
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
		 if($('#main_title').val()==''){
				alert("请先填写活动主标题");
				return;
		}
		
		 resuorceEditor=K.create('textarea[id="editor"]', {
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+K('#main_title').val(),
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+K('#main_title').val(),
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
						imageUrl: K('#image_src').val(),
						clickFn: function (url, title, width, height, border, align) {
							K('#image_src').val(url);
							K('#url2').attr("src",url);
							resuorceEditor.hideDialog();
						 }
					});
				});
		});
	</#if>
		
    function whenSubmit(){
        $("#content").val($(".ke-edit-iframe").contents().find("body").html());
        //公告栏数组
        var annoucementArray=new Array();
        var len=$('.add_annoucement').length;
        var content=new Object();
        for(var i=0;i<len;i++){
            var obj=new Object();
            var currentNode=$('.add_annoucement').eq(i);
            var contentType=currentNode.find('.content_type').val();
            var activityContent=currentNode.find('#activity_content').val();
            if(activityContent==''){
            	continue;
            }
            obj.contentType=contentType;
            obj.activityContent=activityContent;
            annoucementArray.push(obj);
        }
        content.annoucementContent=annoucementArray;
        $("#annouceContent").val(JSON.stringify(content));
        $(".form-horizontal").submit();
    }
    
    <#--根据不同的活动，显示出不同的需要修改的属性框-->
   	window.onload = function(){
   			<#--设置首单即送鲜果币显示的界面-->
	    	var activity_type = $("#hidden_activity_type").val();
		    if(activity_type == 11){
		    	$("#show_dis_order").hide();
				$("#show_content").hide();
				$("#show_type").hide();
				$("#show_url").hide();
				$("#show_restrict").hide();
				$("#show_coupon_count").hide();
				$("#show_image_src").hide();
				$("#show_editor").hide();
				$("#activity_money_text").text("立送金额");
				$("#activity_money").attr('placeholder','立送金额');
		    }else if(activity_type == 7){
		    	$("#show_coupon_count").hide();
		    	$("#show_image_src").hide();
				$("#show_full_amount").show();
				$("#money_random").show();
				$("#money_random_text").show();
				$("#activity_money_text").text("立减金额");
				$("#activity_money").attr('placeholder','500');	
		    }else if(activity_type == 14){
		    	//$("#show_dis_order").hide();//排序
				$("#show_content").hide();//内容
				//$("#show_type").hide();
				//$("#show_url").hide();//url
				$("#show_restrict").hide();//限制购买数量
				$("#show_coupon_count").hide();//优惠券数量
				$("#show_image_src").hide();//选择图片
				$("#show_activity_money").hide();//活动计划经费
				$("#show_editor").hide();
				$("#show_activity_content").show();
		    }		
	}

	
	<#-- 选择不同活动，触发该事件（隐藏一些不必要的属性标签）-->
	function change(){
    	//var activity_type = $("#hidden_activity_type").val();
		var activity_type = $("#activity_type").val();
		<#--根据对应活动,设置一些默认属性-->
		if(activity_type == 11){
			$("#show_restrict").hide();
			$("#show_coupon_count").hide();
			$("#show_editor").hide();
			$("#activity_money_text").text("立送金额");
			$("#activity_money").attr('placeholder','立送金额');
			<#--将活动类型属性设置为所选的活动类型-->
	   	   	$("#hidden_activity_type").val($('#activity_type option:selected').val());
		}else if(activity_type == 14){
			//$("#show_dis_order").hide();//排序
			$("#show_content").hide();//内容
			//$("#show_type").hide();
			//$("#show_url").hide();//url
			$("#show_restrict").hide();//限制购买数量
			$("#show_coupon_count").hide();//优惠券数量
			$("#show_image_src").hide();//选择图片
			$("#show_activity_money").hide();//活动计划经费
			$("#show_editor").hide();
			$("#hidden_activity_type").val($('#activity_type option:selected').val());
			$("#show_activity_content").show();
		}else if(activity_type == 7){
			$("#show_coupon_count").hide();
		    $("#show_image_src").hide();
			$("#show_full_amount").show();
			$("#money_random").show();
			$("#money_random_text").show();
			$("#show_activity_money").show();
			$("#activity_money_text").text("立减金额");
			$("#activity_money").attr('placeholder','500');	
			$("#hidden_activity_type").val($('#activity_type option:selected').val());	
		}else{
			$("#show_full_amount").hide();
			$("#money_random").hide();
			$("#money_random_text").hide();
			$("#show_restrict").show();
			$("#show_coupon_count").show();
			$("#show_image_src").show();
			$("#show_editor").show();
			$("#activity_money_text").text("优惠券金额");
			$("#activity_money").attr('placeholder','优惠券金额');
			$("#hidden_activity_type").val($('#activity_type option:selected').val());
			$("#show_activity_content").hide();
		}

	}
</script>