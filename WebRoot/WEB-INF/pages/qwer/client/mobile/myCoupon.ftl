<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-优惠券" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>

<body>
	<div data-role="page" class="my-coupon">
	
		<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>优惠券</div>
		</div>
	    
		<div data-role="main" class="mt60">
			<div class="change-box">
	       		<input type="text" placeholder="请输入优惠券码" data-role="none" class="order-input" name="coupon_code" id="coupon_code" />
				<div class="btn-change bg-greyM" disabled="disabled">兑换</div>
	        </div>
	        <div class="coupon-list">
				<#if couponList?? && (couponList?size>0) >
					<#list couponList as coupon>
	    				<div class="coupon-box">
					        <div class="coupon-price pull-left">
					            <p>￥<span>${(coupon.coupon_val!0)/100}</span></p>
					        </div>
					        <div class="coupon-info pull-left">
					            <p>${coupon.coupon_desc}</p>
					            <p>${coupon.start_time?substring(5,10)}至${coupon.end_time?substring(5,10)}日使用</p>
					        </div>
					    </div>
	    			</#list>
				<#else>
					<div id="no_pro">
						<img src="resource/image/icon/coupon_empty.png">
						<p>您暂时没有优惠券哦</p>
					</div>
			   </#if>
			</div>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		$(function(){
			$("#coupon_code").on('input',function(e){  
				var btnNode=$(".btn-change");
				btnNode.removeClass("bg-greyM").addClass("bg-pink");
				btnNode.attr("disabled",false);
				if($(this).val()==""){
					btnNode.removeClass("bg-pink").addClass("bg-greyM");
					btnNode.attr("disabled",true);
				}
			}); 

			//兑换优惠券
			$(".btn-change").on('click',function(e){
				  var code=$('#coupon_code').val();
				  if(code==""){
					  $.dialog.alert("请输入兑换码");
					  return false;
				  }
				  $.ajax({
						type: "Get",
			            url: "${CONTEXT_PATH}/activity/exchangeCoupon",
			            data:{coupon_code:code.trim()},
			            success: function(result){
			            	if(result.success){
			            		var couponVal=result.coupon_val?(result.coupon_val/100):0;
			            		var startTime=result.start_time?result.start_time.substring(5,10):"N/A";
			            		var endTime=result.end_time?result.end_time.substring(5,10):"N/A";
			            		
                                var markup='<div class="coupon-box">'+
	    					        '<div class="coupon-price pull-left">'+
						            '<p>￥<span>'+couponVal+'</span></p></div>'+
						            '<div class="coupon-info pull-left">'+
							        '<p>'+result.coupon_desc+'</p>'+
							        '<p>'+startTime+'至'+endTime+'日使用</p>'+
							        '</div></div>';
				            	$("#no_pro").hide();
			            		$('.coupon-list').prepend(markup);
			            		//兑换成功后清空兑换码
			            		$("#coupon_code").val("");
			            		$.dialog.alert(result.msg);
			            	}else{
			            		$.dialog.alert(result.msg);
			            	}
			            }
					});
			}); 
			
		});	
		
		function back(){
			window.history.back();
		}
	</script>
</body>
</html>