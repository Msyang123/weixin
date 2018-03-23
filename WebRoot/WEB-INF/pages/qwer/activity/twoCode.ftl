<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form action="${CONTEXT_PATH}/activityManage/saveTwoCode" class="form-horizontal" role="form" method="post" id="award_form">
    <input type="hidden" name="id" value="${(award.id)!}"/>
    <div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">奖品标题 </label>

        <div class="col-sm-9">
            <input type="text" id="award_name" name="award.award_name" value="${(award.award_name)!}"  placeholder="奖品标题" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">概率设置 </label>

        <div class="col-sm-9">
            <input type="text" id="award_percent" name="award.award_percent"  value="${(award.award_percent)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="">
        <label class="col-sm-3 control-label no-padding-right" for="dis_order">排序 </label>

        <div class="col-sm-9">
            <input type="text" id="award_sequence" name="award.award_sequence"  value="${(award.award_sequence)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    <div class="form-group" id="">
        <label class="col-sm-3 control-label no-padding-right">奖品类型</label>
        <div class="col-sm-9">
            <select id="award_type" name="award.award_type" onchange="wayChange()">
            	<#if (award.award_type)??>
	        		<option value="1" <#if award.award_type=='1'>selected</#if>>鲜果币</option>
	        		<option value="2" <#if award.award_type=='2'>selected</#if>>优惠券</option>
	        		<option value="3" <#if award.award_type=='3'>selected</#if>>实物奖品</option>
	        		<option value="4" <#if award.award_type=='4'>selected</#if>>谢谢惠顾</option>
        		<#else>
        			<option value="1" >鲜果币</option>
	        		<option value="2" >优惠券</option>
	        		<option value="3" >实物奖品</option>
	        		<option value="4" >谢谢惠顾</option>
        		</#if>
        	</select>
        </div>
    </div>
    <div class="form-group" id="pro_box">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">商品规格编号</label>

        <div class="col-sm-9">
            <input type="text" id="pf_id" name="award.pf_id"  value="${(award.pf_id)!}" />
        </div>
    </div>
    <div class="form-group" id="coin_box">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">鲜果币数量 </label>

        <div class="col-sm-9">
            <input type="text" id="coin_count" name="award.coin_count"  value="${(award.coin_count)!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
	<div id="coupon_box">
	    <div class="form-group" id="">
	        <label class="col-sm-3 control-label no-padding-right">优惠券规模</label>
	
	        <div class="col-sm-9">
	           <select id="coupon_scale_id" name="coupon_scale_id">
	            	<#if couponScaleList??>
		            	<#if (award.coupon_scale_id) ??>
		            		<#list couponScaleList as couponScale>
		        				<option value="${couponScale.id}" <#if award.coupon_scale_id==couponScale.id>selected</#if>>${couponScale.coupon_desc}</option>
		            	  	</#list>
		            	<#else>
			            	  <#list couponScaleList as couponScale>
			        			<option value="${couponScale.id}" >${couponScale.coupon_desc}</option>
			            	  </#list>
		            	</#if>
	        		</#if>
	        	</select>
	        </div>
	    </div>
	    <div class="form-group" id="show_coupon_count">
	        <label class="col-sm-3 control-label no-padding-right">优惠券有效期</label>
	
	        <div class="col-sm-9">
	            <input type="text" id="coupon_vali_date" name="award.coupon_vali_date" value="${(award.coupon_vali_date)!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
  	</div>
    <div class="form-group" id="show_image_src">
        <label class="col-sm-3 control-label no-padding-right" for="url">图片</label>

        <div class="col-sm-9">
	        <input type="hidden" id="image_src" name="image_src" value="${(award.save_string)!}" />
	        <input type="hidden" id="image_id" name="award.img_id" value="${(award.img_id)!}" />
	        <img id="url2" src="${(award.save_string)!}"/>
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
		wayChange();
	})
	var K=window.KindEditor;
	var resuorceEditor;
	KindEditor.ready(function(K) {
           resuorceEditor = K.editor({
        	   cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=twoCode',
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=twoCode',
				allowFileManager : true,
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

	});
	
	//改变奖励内容
    function wayChange(){
		var wayForm =$("#award_form");
        var strvalue=$("#award_type").val();
        
        if(strvalue==1){
        	wayForm.find("#coin_box").show();
        	wayForm.find("#pro_box").hide();
        	wayForm.find("#coupon_box").hide();
        }else if(strvalue == 2){
        	wayForm.find("#coin_box").hide();
        	wayForm.find("#pro_box").hide();
        	wayForm.find("#coupon_box").show();
        }else if(strvalue == 3){
        	wayForm.find("#coin_box").hide();
        	wayForm.find("#pro_box").show();
        	wayForm.find("#coupon_box").hide();
        }else{
        	wayForm.find("#coin_box").hide();
        	wayForm.find("#pro_box").hide();
        	wayForm.find("#coupon_box").hide();
        }
    }
	
    function whenSubmit(){
        $(".form-horizontal").submit();
    }
</script>