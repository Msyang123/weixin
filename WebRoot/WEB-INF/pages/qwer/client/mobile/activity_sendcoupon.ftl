<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-发券活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>  
    <div data-role="page" class="wrapper coupon-bg">
         <img src="${activity_image!}" onerror="this.src='resource/image/activity/sendcoupon/yhq_bg.png'" class="w-100">
         <article data-role="main">
         	<#if isCode ?? && isCode == 0>
			 <div class="ipt-code">
			 	<lable>福利码：</lable>
			 	<input type="text" data-role='none' id="code" name="code"/>
			 </div>         
         	</#if>
         
	         <section class="coupon-get">
	              <button class="btn-custom btn-coupon col-7" id="get_coupon" data-role="none">点击领取</button>
	         </section>
         </article>
    </div>
    
    <#include "/WEB-INF/pages/common/share.ftl"/>
    <script>
    	$(function(){
			$('#get_coupon').on('click',function(){
 				 <#if isCode?? && isCode == 0>
 					 var code=$('#code').val();
					  if(code==""){
						  $.dialog.alert("请输入福利码");
						  return false;
					  }
					  //发送ajax去兑换优惠券
					  $.ajax({
							type: "Get",
				            url: "${CONTEXT_PATH}/coupon/confirmation?activity_id="+${activity_id},
				            data:{code:code.trim()},
				            success: function(result){
				            	if(result.success){
				            		window.location.href="${CONTEXT_PATH}/coupon/receiveCoupon?activity_id="+${activity_id}+"&userId="+${user_id};
				            	}else{
				            		$.dialog.alert(result.msg);
				            	}
				            }
					  });
 				 <#else>
					  window.location.href="${CONTEXT_PATH}/coupon/receiveCoupon?activity_id="+${activity_id}+"&userId="+${user_id};
 				 </#if>
				
		    });
			//屏蔽微信分享js
			wx.ready(function() {
			     wx.hideOptionMenu();
			});
			
			var isPageHide = false; 
			window.addEventListener('pageshow', function () { 
			    if (isPageHide) { 
			      window.location.reload(); 
			    } 
			}); 
			window.addEventListener('pagehide', function () { 
			    isPageHide = true; 
			});
    	});
    	
	</script>  
</body>
</html>