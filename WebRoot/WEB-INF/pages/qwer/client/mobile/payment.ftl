<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-订单支付" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="payment-page bg-white">	
		<div data-role="main">
		<#if order??>
			<div class="orderhead">
				支付详情
			</div>
			<div id="tipsDiv">
				请在30分钟内完成支付，否则订单将被取消。
			</div>
			<div style="border-bottom:5px solid #eeeded">
				<div class="order-info">
					<div class="order-number">订单编号：${order.order_id}</div>
					<div class="order-state">${order.status_cn}</div>
				</div>
			
				<#if order.deliverytype='2'>
				<div id="addressDiv">
					<div id="detialAddress">
						<div id="address_detail">
							<div class="receiver-info">
								<div>&nbsp;</div>
								<div id="rcvname_text">${order.receiver_name}</div>
								<div>${order.receiver_mobile}</div>
							</div>
							<div class="address-info">	
								<div>
									<img height="20px" src="${CONTEXT_PATH}/resource/image/icon/address.png" />
								</div>
								<div>
									${order.address_detail}
								</div>
							</div>
						</div>
					</div>
				</div>
				<#else>
				<div class="order-info">
					<p class="info-tittle">提货门店：<span>${order.store_name}</span></p>
				</div>
				</#if>
				<div class="order-info">
					<p class="info-tittle">
						下单时间：<span>${order.deliverytime!}</span>
					</p>
				</div>
				<div class="order-info">
					<p class="info-tittle">
						我的留言：<span>${order.customer_note!}</span>
					</p>
				</div>
			</div>
			
			<ul class="price_box">
					<li>订单金额：￥${(order.total!0)/100}</li>
						<#if order.coupon_val??>
							<li>优惠金额：￥${(order.coupon_val!0)/100}</li>
						</#if>
						<#if ((order.total!0)-(order.need_pay!0)-(order.coupon_val!0))!=0>
							<li>
								随机立减：
								<#if order.need_pay==0>
									<span style="color:#de374e;">免单啦，人品大爆发！</span>
									
								<#else>
									￥${((order.total!0)-(order.need_pay!0)-(order.coupon_val!0))/100}<span class="price_text">立减￥${((order.total!0)-(order.need_pay!0)-(order.coupon_val!0))/100}元，运气真好!</span>
								</#if>
							</li>
						</#if>
					<li>配送费：<span class="last_price">￥${(order.delivery_fee!0)/100}</span></li>
					<li>应付金额：<span class="last_price">￥${((order.need_pay!0)+(order.delivery_fee!0))/100}</span></li>
			</ul>
			<div class="cartfoot"  style="bottom:0;">
				<div class="cancel-btn" onclick="cancelOrder()">取消订单</div>
				<div id="pay-btn">立即支付</div>
			</div>
		<#else>
			<div class="past-page">页面已过期</div>
		</#if>
		</div>
		<div class="custom-dialog">
		    <img src="resource/image/icon/icon-success.png" />
		    <p>余额支付成功</p>
		</div>
	</div>

	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#pay-btn").on("click", function(e){
				e && e.preventDefault();
			    $(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/order",
						data: {orderId: "${(order.order_id)!}"}
					},
					wcpay: {
						ok: function(res){
				          //  alert("微信支付成功!");
				          //清除用户登录信息，重新鉴权，因为此情况可能已经从未关注到已关注状态
				          	$.ajax({ 
								url: "${CONTEXT_PATH}/clear", 
								data: {}, 
								success: function(data){
									window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${order.order_id}";
						      	}
							});
						},
						fail: function(res){
							$.post("${CONTEXT_PATH}/pay/orderFailure", {orderId: "${order.order_id}"});
						}
					},
					balancepay: function(res){
				       // alert("余额支付 - 页面跳转");
				        window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${order.order_id}";
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
	            		window.location.href="${CONTEXT_PATH}/myOrder?type=0";
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
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
	</script>
</body>
</html>
