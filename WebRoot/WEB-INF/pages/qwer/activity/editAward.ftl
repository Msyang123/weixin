<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form action="${CONTEXT_PATH}/activityManage/saveJggAward" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="award.id" value="${award.id!}"/>
 
   <input type="hidden" name="award.activity_id" id="activity_id" 
   			value="${activityId!}"/>
   	<div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="id">编号 </label>
        <div class="col-sm-9">
            <input type="text" readonly="readonly" 
            id="id" name="award.id" value="${award.id!}"  placeholder="编号" 
            class="col-xs-10 col-sm-5" />
        </div>
    </div>		 
    <div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="award_sequence">排序 </label>

        <div class="col-sm-9">
            <input type="text" id="award_sequence" name="award.award_sequence" 
            value="${award.award_sequence!}"  placeholder="排序" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="award_sequence">奖品名称 </label>

        <div class="col-sm-9">
            <input type="text" id="award_name" name="award.award_name"
            value="${award.award_name!}"  placeholder="奖品名称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_image_src">
        <label class="col-sm-3 control-label no-padding-right" for="image_src">奖品图片</label>
        <div class="col-sm-9">
	        <input type="hidden" id="image_src" name="image_src" value="${(image.save_string)!}" />
	        <img id="url" src="${(image.save_string)!}"/>
			<input type="button" id="image" value="选择图片" />
        </div>
    </div>
    <div class="form-group" id="show_dis_order">
        <label class="col-sm-3 control-label no-padding-right" for="award_percent">中奖概率 </label>

        <div class="col-sm-9">
            <input type="text" id="award_percent" name="award.award_percent" placeholder="中奖概率" 
            value="${award.award_percent!}" class="col-xs-10 col-sm-5" />%
        </div>
    </div>
    <div class="form-group" id="show_url">
        <label class="col-sm-3 control-label no-padding-right">奖品份数</label>
        <div class="col-sm-9">
            <input type="text" id="award_num" name="award.award_num" placeholder="奖品份数" 
            value="${award.award_num!}" class="col-xs-10 col-sm-5" />
            <input type="checkbox" id="amount_restriction" name="award.amount_restriction" value="0"
            <#if award.amount_restriction ?? && award.amount_restriction=='0' >checked=true</#if>
            >不限制
        </div>
    </div>
    <div class="form-group" id="show_status">
        <label class="col-sm-3 control-label no-padding-right">奖品类型</label>
        <div class="col-sm-9">
        	<select id="award_type" name="award.award_type" onchange="change();" class="col-xs-10 col-sm-5">
			  	  <option <#if award.award_type?? && award.award_type=='1' >selected</#if> value="1" >鲜果币</option>
				  <option <#if award.award_type?? && award.award_type=='2' >selected</#if> value="2" >优惠券</option>
				  <option <#if award.award_type?? && award.award_type=='3' >selected</#if> value="3" >实物奖品</option>
				  <option <#if award.award_type?? && award.award_type=='4' >selected</#if> value="4" >谢谢惠顾</option>
			</select>
        </div>
    </div>
    <div class="form-group" id="show_coin_count">
        <label class="col-sm-3 control-label no-padding-right">鲜果币金额</label>

        <div class="col-sm-9">
            <input type="text" id="coin_count" name="award.coin_count" 
            placeholder="鲜果币金额" value="${award.coin_count!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_coupon_scale_id">
        <label class="col-sm-3 control-label no-padding-right">优惠券规模</label>

        <div class="col-sm-9">
            <select id="coupon_scale_id" name="award.coupon_scale_id" >
            	<#list couponScale as item>
        			<option value="${item.id}" 
        			<#if (award.coupon_scale_id)?? && award.coupon_scale_id==item.id>selected=true</#if> 
        			>${item.coupon_desc}</option>
        		</#list>
            </select>
        </div>
    </div>
    <div class="form-group" id="show_coupon_vali_date">
        <label class="col-sm-3 control-label no-padding-right">优惠券有效期</label>

        <div class="col-sm-9">
            <input type="text" id="coupon_vali_date" name="award.coupon_vali_date" 
            placeholder="优惠券有效期" value="${award.coupon_vali_date!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="show_coupon_count">
        <label class="col-sm-3 control-label no-padding-right">返券张数</label>

        <div class="col-sm-9">
            <input type="text" id="coupon_count" name="award.coupon_count" 
            placeholder="返券张数" value="${award.coupon_count!}" class="col-xs-10 col-sm-5" />
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
	<#--根据不同的活动，显示出不同的需要修改的属性框-->
   	$(function(){
   		change();	
	});

	function change(){
		var award_type = $("#award_type").val();
		if(award_type == '1'){
		    	$("#show_coin_count").show();
				$("#show_coupon_scale_id").hide();
				$("#show_coupon_vali_date").hide();
				$("#show_coupon_count").hide();
		    }else if(award_type == '2'){
		    	$("#show_coin_count").hide();
				$("#show_coupon_scale_id").show();
				$("#show_coupon_vali_date").show();
				$("#show_coupon_count").show();
		    }else{
		    	$("#show_coin_count").hide();
				$("#show_coupon_scale_id").hide();
				$("#show_coupon_vali_date").hide();
				$("#show_coupon_count").hide();
		    }		
	}	
	
	KindEditor.ready(function(K) {	
		 var editor = K.editor({
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=九宫格活动',
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=九宫格活动',
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
							K('#image_src').val(url);//图片地址存储
							K('#url').attr("src",url);//显示图片
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
	});
	
    function whenSubmit(){
        $(".form-horizontal").submit();
    }
</script>