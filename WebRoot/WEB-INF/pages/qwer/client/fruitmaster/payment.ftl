<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-支付详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>

	<div id="payment" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" onclick="back();">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>支付详情</span>
	    </header>
	    
	    <div class="u-tips">请在30分钟内完成支付，否则订单将被取消。</div>

		<section class="m-order-details s-bdc5">
			<p><span>订单编号：</span>${order.order_id}<span class="u-status">${order.status_cn}</span></p>
			<#if order.deliverytype='2'>
				<div class="delivery-info">
					<p><span>收货人&emsp;：</span>${order.receiver_name}&emsp;${order.receiver_mobile}</p>
					<p><span>收货地址：</span>${order.address_detail}</p>
				</div>
			<#else>
				<p><span>提货门店：</span>${order.store_name}</p>
			</#if>
			<p><span>下单时间：</span>${order.createtime!}</p>
			<p><span>我要留言：</span>${order.customer_note!}</p>
		</section>
		
		<section class="m-pay-details mb50">
			<p><span>订单金额：</span>&yen; ${(order.total!0)/100}</p>
			<#if order.coupon_val??>
				<p><span>优惠金额：</span>&yen; ${(order.coupon_val!0)/100}</p>
			</#if>
			<p><span>应付金额：</span>&yen; ${(order.need_pay!0)/100}</p>
		</section>	
			
		<footer class="row m-bottom-btn no-gutters">
			<a class="col-6" onclick="cancelOrder()">取消订单</a>
			<a class="col-6 s-btn-brown" id="pay-btn">立即支付</a>
		</footer>
	</div>
	
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#pay-btn").on("click",function(e){
				e && e.preventDefault();
				$(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/payFruitmasterBuy",
						data: {orderId: "${order.order_id}"}
					},
					wcpay: {
						ok: function(res){
				          //  alert("微信支付成功!");
				          //清除用户登录信息，重新鉴权，因为此情况可能已经从未关注到已关注状态
				          	$.ajax({ 
								url: "${CONTEXT_PATH}/clear", 
								data: {}, 
								success: function(data){
									window.location.href = "${CONTEXT_PATH}/pay/fruitmasterSuccessPay?orderId=${order.order_id}";
						      	}
							});
						},
						fail: function(res){
							$.post("${CONTEXT_PATH}/pay/payFruitmasterFailure", {orderId: "${order.order_id}"});
						}
					},
					balancepay: function(res){
				       // alert("余额支付 - 页面跳转");
				        window.location.href = "${CONTEXT_PATH}/pay/fruitmasterSuccessPay?orderId=${order.order_id}";
					}
			    });
			});
		});
		
		function cancelOrder(){
			$.dialog.message("确认取消订单吗<br/>（取消后将不能恢复）？",true,
			function(){
				$.ajax({
	            type: "POST",
	            url: "${CONTEXT_PATH}/cancelOrder",
	            data: {orderId:"${order.id}"},
	            dataType: "json",
	            success: function(data){
	            	if(data.result=="success"){
	            		window.location.href="${CONTEXT_PATH}/myself/userOrder?type=0";
	            	}else{
	            		$.dialog.alert(data.msg);
	            	}
	            }
	        	});
			});
		}
		
		function back(){
			window.history.back();
		}
	</script>
</body>
</html>