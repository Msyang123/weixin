<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<div class="col-xs-12 abc">
	<form action="" class="form-horizontal" role="form" method="post">
	    <input type="hidden" id="activity_id" name="activity_id" value="${(activity.id)!}"/>
		<input type="hidden" id="activity_type" name="activity.activity_type" value="17"/>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="main_title">活动名称： </label>
	        <div class="col-sm-9">
	            <input type="text" id="main_title" name="activity.main_title" value="${(activity.main_title)!}"  placeholder="活动主标题" class="col-xs-10 col-sm-5" />
	        </div> 
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="id">编号：</label>
	        <div class="col-sm-9">
	            <input type="text" id="id" name="id" placeholder="活动编号,系统自动生成" value="${(activity.id)!}"  readonly="readonly" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">活动开始时间：</label>
	        <div class="col-sm-9">
	            <input type="text" id="yxq_q" name="activity.yxq_q" placeholder="活动开始时间" value="${(activity.yxq_q)!}" 
	            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">活动结束时间： </label>
	        <div class="col-sm-9">
	            <input type="text" id="yxq_z" name="activity.yxq_z" placeholder="活动结束时间" value="${(activity.yxq_z)!}" 
	            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="url">背景banner</label>
	        <div class="col-sm-9">
	        	<input type="hidden" id="image_id" name="image.id" value="${(image.id)!}"/>
		        <input type="text" id="url" name="image.save_string" placeholder="推荐尺寸 642X1057（单位：px）" value="${(image.save_string)!}" class="col-xs-10 col-sm-5"/>
				<input type="button" id="image" value="上传图片" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="url">图片预览 </label>
	        <div class="col-sm-9">
		            <img id="url2" style="width:50%;" src="${(image.save_string)!}"/>
	        </div>
	    </div>
	    
	    <!-- <div class="form-group" id="show_yxbz">
	        <label class="col-sm-3 control-label no-padding-right">有效标志：</label>
	        <div class="col-sm-9">
	        	<select id="yxbz" name="activity.yxbz" class="col-xs-10 col-sm-5">
				  	  <option <#if (activity.yxbz)?? && (activity.yxbz)=='Y' >selected</#if> value="Y" >有效</option>
					  <option <#if (activity.yxbz)?? && (activity.yxbz)=='N' >selected</#if> value="N" >无效</option>
				</select>
	        </div>
	    </div> -->
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">关联优惠券：</label>
	        <div class="col-sm-9 rele-coupon-scalss">
	        <#if tCouponCategorys??>
	            <#list tCouponCategorys as tCouponCategory>
		        <div class="rele-coupon-scals mb10 z-hidden">
			        <#if tCouponScale??>
			        	<select id="relateCoupon" name="relateCoupon" class="col-xs-10 col-sm-5 h34">
			         		<#list tCouponScale as item>
					        	<#if tCouponCategory??>
								  	  <option value='${item.id!}' <#if (tCouponCategory.coupon_desc!)==(item.coupon_desc!)>selected</#if>>${item.coupon_desc!}</option>
					        	<#else>
					        		  <option value='${item.id!}'>${item.coupon_desc!}</option>
					        	</#if>
							 </#list>
						</select>
					</#if>
				</div>
				</#list>
			<#else>
			<div class="rele-coupon-scals" style="display:block;overflow: hidden;">
		        <#if tCouponScale??>
		        	<select id="relateCoupon" name="relateCoupon" class="col-xs-10 col-sm-5 mb8">
		         		<#list tCouponScale as item>
		        		      <option value='${item.id!}'>${item.coupon_desc!}</option>
						 </#list>
					</select>
				</#if>
			  </div>
			</#if>	
	        	<div class="text-left mt10"><button type="button" class="btn btn-info btn-sm" id="btn-scals"><i class="fa fa-plus"></i></button></div>
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="activity_main_title">优惠券有效期： </label>
	        <div class="col-sm-9">
	            <input type="text" id="yxq" name="yxq" value="${(activity.yxq)!}"  placeholder="优惠券有效期" class="col-xs-10 col-sm-5" />
	        </div> 
	    </div>
	    
      <div class="form-group">
	       <label class="col-sm-3 control-label no-padding-right">是否输入口令：</label>
	       <input type="hidden" name="activity.share_send" id="share_send" value='${activity.share_send!}' />
	       <div class="col-sm-3">
				<label>
					<input type="checkbox" id="isCode" name="isCode" class="ace ace-switch ace-switch-2" checked="checked" value="true">
					<span class="lbl"></span>
				</label>
		   </div>
	    </div>
	    
	    <div class="form-group is-code" >
	        <label class="col-sm-3 control-label no-padding-right" for="activity_main_title">领取口令： </label>
	        <div class="col-sm-9">
	            <input type="text" id="receive_code" name="activity.receive_code" value="${(activity.receive_code)!}"  placeholder="领取口令" class="col-xs-10 col-sm-5" />
	        </div> 
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">使用次数限制：</label>
	        <div class="col-sm-9">
				<input type="text" id="coupon_count" name="activity.coupon_count" class="col-sm-2 mr12 coupon-count" value="${(activity.coupon_count)!}"/>		
				<div class="checkbox-inline col-sm-2">
				    <label>
				        <input type="checkbox" id="countCheckbox" value="${(activity.coupon_isLimt)!'1'}"> 不限制 
				    </label>
				</div>
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">用户可领取次数：</label>
	        <div class="col-sm-9">
				<input type="text" id="user_receive_num" name="user_receive_num" value="${(activity.user_receive_num)!}" class="col-sm-3" /><span class="input-text">次</span>
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">商品url：</label>
	        <div class="col-sm-9">
				<input type="text" id="use_url" name="use_url" value="${(activity.use_url)!}" class="col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="clearfix form-actions">
	        <div class="col-md-offset-3 col-md-9">
	            <button class="btn btn-info" type="button" id="btn-confirm">
	                                                  提交
	            </button>
	            <button class="btn" type="button" onclick="history.go(-1);">
	             	   取消
	            </button>
	        </div>
	    </div>
	</form>
</div>
</@layout>

<script>
KindEditor.ready(function(K) {	
	 var editor = K.editor({
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=sendCoupon',
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=sendCoupon',
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
						K('#url').val(url);//图片地址存储
						K('#url2').attr("src",url);//显示图片
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
});

$(function(){
	
    //编辑时回填数据和选择checkbox 
	if($("#countCheckbox").val()=="2"){
	    $("#countCheckbox").attr('checked',true);  
		$(".coupon-count").attr("disabled",true);
		$(".coupon-count").val("");
	}
			
	$("#countCheckbox").on('click',function() { 
		var _this=$(this);
		if(_this.is(':checked')) {
		    $(".coupon-count").attr("disabled",true);
		    $(".coupon-count").val("");
		    _this.val("2");
		}else{
			$(".coupon-count").attr("disabled",false);
			_this.val("1");
		}
	});
	
    $('#isCode').on('click',function(){
        var _this=$(this);
        if(_this.is(":checked")){
        	_this.val("true");
        	$('.is-code').show();
        }else{
        	_this.val("false");
            $('.is-code').hide();
        }
  });
	
	$('.rele-coupon-scalss').on('click','.btn-remove',function(e){
        var $remove=$(e.currentTarget);
        $remove.parents('.rele-coupon-scals').remove();
    });

    $('#btn-scals').on('click',function(){
        var existNum=$('.rele-coupon-scals').length;
        var removeBtn='<span class="input-group-btn">'+
	        	        '<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>'+
	        	     '</span>';
	        	     
   	     var markup='<div class="rele-coupon-scals mb10">'+
		        <#if tCouponScale??>
		        	'<select id="relateCoupon" name="relateCoupon" class="col-xs-10 col-sm-5 h34">'+
		         		<#list tCouponScale as item>
				        	<#if tCouponCategory??>
						  	  '<option value="${item.id!}" <#if (tCouponCategory.coupon_desc!)==(item.coupon_desc!)>selected</#if>>${item.coupon_desc!}</option>'+
				        	<#else>
			        		  '<option value="${item.id!}">${item.coupon_desc!}</option>'+
				        	</#if>
						 </#list>
					'</select>'+
					'<div class="input-group">'+
		        	     (existNum>=1?removeBtn:"")+
		        	'</div>'+
				</#if>
			'</div>';
	        	     
	      if(existNum>=10){
	        $.dialog.alert('请不要超过10个');
	         return false;
	      }   
	      $(this).parent().before(markup);	      	          
   });

   $('#btn-confirm').on('click',function(){
   
       var activity_id=$("#activity_id").val();
	   var user_gain_times=$("#user_gain_times").val();//用户限制次数
	   var activity_type=$("#activity_type").val();//活动类型
	   var main_title=$("#main_title").val();
	   var yxq_q=$("#yxq_q").val();
	   var yxq_z=$("#yxq_z").val();
	   var yxbz=$("#yxbz").val();
	   //var relateCoupon=$("#relateCoupon").val();
	   var coupon_count=$("#coupon_count").val();
	   var receive_code=$("#receive_code").val();
	   var user_receive_num=$("#user_receive_num").val();
	   var image_id=$("#image_id").val();
	   var url=$("#url").val();
	   var yxq=$("#yxq").val();
	   var use_url=$("#use_url").val();
	   var scals=new Array();
	   var nodes=$('.abc').find('.rele-coupon-scals');
       var len=nodes.length;
   
	   var scals_id=0;
	   for(var i=0;i<len;i++){
	   	scals_id=nodes.eq(i).find('#relateCoupon').val();
	   	scals.push(scals_id);
	   }
	   
       console.log(JSON.stringify(scals));
	   if($("#coupon_desc").val()==""||$("#min_cost").val()==""||$("#coupon_val").val()==""){
	   	$.dialog.alert("请填写完毕后在提交");  
			return;  		
		}
	
	   if($("#coupon_range").val()=="0"&&$("#GOODS_NAME").val()==""){
	   	$.dialog.alert("请关联商品");  
			return;  
	   }
	   
       var data={activity_id:activity_id,user_gain_times:user_gain_times,receive_code:receive_code,yxq:yxq
   		,activity_type:activity_type,main_title:main_title,yxq_q:yxq_q,user_receive_num:user_receive_num
   		,yxq_z:yxq_z,yxbz:yxbz,coupon_count:coupon_count,relateCoupons:JSON.stringify(scals),url:url,image_id:image_id,use_url:use_url};

	   $.ajax({
	         url:'${CONTEXT_PATH}/couponManage/addOutCoupon',
	         type:'Get',
	         data:data,
	         success:function(result){
	       	  $.dialog.alert(result.mes);
	       	  window.location.href="${CONTEXT_PATH}/activityManage/yhq";
	         }
	   });
   });
});	
	
	
</script>