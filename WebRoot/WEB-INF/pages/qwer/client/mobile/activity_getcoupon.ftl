<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-优惠券领取页" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>  
    <div data-role="page" class="wrapper bg-grey">
         <article data-role="main" class="coupon-wrppaer">
            <section class="coupon-result">
                <div class="coupon-infos row no-gutters justify-content-between align-items-center">
                      <div class="col-3">
                          <img src="${result.user_img_id!}" class="rounded-circle img-responsive"/>
                      </div>
                       
	                <div class="col-7 text-left">
		               <#if result.status == 0>   
		                  <h3 class="brand-red">领取成功</h3>
		                  <h5 class="mr5">恭喜您获得总价值<span class="brand-red sum-val"></span>元优惠礼包一份</h5>
		               <#elseif result.status == 1>
		                  <h3 class="brand-red">领取失败</h3>
		                  <h5>慢了一步，优惠礼包被领完了哦</h5>
					   <#elseif result.status == 2>
						  <h3 class="brand-red">领取失败</h3>
	                      <h5>您已领取过该优惠礼包</h5>
	                    </#if>
	                </div>
	                		
	                <div class="col-2 btn-goCoupon">
	                	<a href="${CONTEXT_PATH}/myCoupon" data-ajax="false" data-role="none">
	                		查看
	                	</a>
	                </div>
		         </div>
		     </section>
		     
	         <section class="coupon-bg-red">
		         <div class="coupon-white">      
					<#if result.status == 0> 
						<!--  领取成功	 -->
				         <div class="coupon-lists">
				         	  <#list result.couponCategorys.data as coupon>	
					             <div class="coupon-infos row no-gutters justify-content-between align-items-center">
			                        <div class="col-2 title text-center">
			                        	优惠券
			                        </div>
					                <div class="col-10 text-left pl10">
					                    <h3 class="brand-red"><span class="coupon-val">${coupon.coupon_val/100}</span>元</h3>
					                    <h5>${coupon.coupon_desc}</h5>
					                    <p>有效期: ${(result.couponCategorys.start_time)?substring(0,10)}至${(result.couponCategorys.end_time)?substring(0,10)}</p>
					                </div>
						         </div>
					           </#list>
				         </div>
				         <div class="col-12">
					         <button class="btn-custom btn-use-coupon" data-role="none" onclick="goHome();">立即使用</button>
					     </div>
				    <#else>
						 <!-- 失败 -->
				         <div class="coupon-empty text-center">
					          <#if result.status == 1>
						 <!-- 领完 -->
					              <img src="resource/image/activity/sendcoupon/yhq_empty.png" class=""/><br/>
					          <#else>
						 <!-- 领过 -->
					              <img src="resource/image/activity/sendcoupon/yhq_received.png"/><br/>
						      </#if>
						      <button class="btn-custom" data-role="none" onclick="goHome();">进店逛逛</button>
				         </div>
				    </#if>
			     </div>
	         </section>
         </article>
    </div>  
    <#include "/WEB-INF/pages/common/share.ftl"/>
    <script>
		$(function(){
			//屏蔽微信分享js
			wx.ready(function() {
			     wx.hideOptionMenu();
			});
			
			//计算总价值
			var sum = 0;
			var couponItm = $(".coupon-lists").find(".coupon-val");
			
			couponItm.each(function(){
                sum += parseInt($(this).html());
            });
            
            $(".sum-val").html(sum);
		});
		function goHome(){
			<#if result.useUrl ?? >
				window.location.href="${result.useUrl}"; 
			<#else>
				window.location.href="${CONTEXT_PATH}/main?index=0"; 
			</#if>
		}
    </script>
</body>
</html>