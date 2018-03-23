<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-支付成功页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>

	<div id="success_pay" class="wrapper">
		<div class="u-tips2 marquee">请您在72小时内完成提货，超出时间将自动取消该订单，按实际支付金额转成等价的鲜果币</div>
		<div class="m-success-img">
	        <img src="resource/image/icon-master/icon_ok.png"/>
		    <h3>支付成功</h3>
		</div>
		<div class="m-success-btn">
			<button type="button" class="btn btn-lg btn-block u-btn-finished s-btn-brown" onclick="goMall();">完成</button>
		</div>
	</div>
	
	<script src="//cdn.jsdelivr.net/jquery.marquee/1.4.0/jquery.marquee.min.js"></script><!--跑马灯效果-->
	<script>
		$(function(){
			//实例化跑马灯
			$('.marquee').marquee({
				duration: 8000,
				gap: 60,
				delayBeforeStart: 1,
				direction: 'left',
				duplicated: true
			});
		})
		function goMall(){
		     window.location.href = "${CONTEXT_PATH}/mall/shopIndex";
		}
	</script>
</body>
</html>