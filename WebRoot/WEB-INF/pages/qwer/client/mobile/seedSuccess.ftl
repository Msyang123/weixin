<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-充值成功" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="success-pay bg-white">
		<div data-role="main">
  			<div class="tips marquee">请您在72小时内完成提货，超出时间将自动取消该订单，按实际支付金额转成等价的鲜果币</div>
  			
			<div class="success-icon">
		        <img height="100px" src="resource/image/icon/pay-success.png"/>
			    <h3>兑换成功</h3>
			</div>			
		
			<div class="complete-box">		    
				<button type="button" data-role="button" class="btn-custom" id="exchange_success">完成</button>
			</div>
			<#if seedTypes??>
			  <h4>扣除
			  <#list seedTypes as item>
			  	${item.seed_name!}${item.amount!}个
			  </#list>
			  </h4>
				<p>种子使用完成无法退还哦</p>
			</#if>
			<!-- <h4>扣除${seed_name!}${amount!}个</h4>
			<p>种子使用完成无法退还哦</p> -->
		</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="//cdn.jsdelivr.net/jquery.marquee/1.4.0/jquery.marquee.min.js"></script><!--跑马灯效果-->
	<script type="text/javascript">
			
		$(function(){
			//实例化跑马灯
			$('.marquee').marquee({
				duration: 8000,
				gap: 60,
				delayBeforeStart: 1,
				direction: 'left',
				duplicated: true
			});
			
		    $('#exchange_success').on('click',function(){
		    	window.location.href='${CONTEXT_PATH}/activity/seedBuy';
		    });
		});
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
</script>
</body>
</html>