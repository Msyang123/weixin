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
			<div class="orderhead">
				支付详情
			</div>
			<div id="tipsDiv">
				请在10分钟内完成支付，否则订单将被取消。
			</div>
			<div class="bb5">
				<!--<div class="order-info">
					<div class="order-number">订单编号：{order.order_id}</div>
					<div class="order-state">{order.status_cn}</div>
				</div>
				-->
				<div class="order-info">
					<div class="order-state">待付款</div>
				</div>
			
				<#if teamMember.deliverytype='2'>
				<div id="addressDiv">
					<div id="detialAddress">
						<div id="address_detail">
							<div class="receiver-info">
								<div>&nbsp;</div>
								<div id="rcvname_text">${teamMember.receiver_name!}</div>
								<div>${teamMember.receiver_mobile!}</div>
							</div>
							<div class="address-info">	
								<div>
									<img height="20px" src="${CONTEXT_PATH}/resource/image/icon/address.png" />
								</div>
								<div>
									${teamMember.address_detail!}
								</div>
							</div>
						</div>
					</div>
				</div>
				<#else>
				<div class="order-info">
					<p class="info-tittle">提货门店：<span>${store.store_name}</span></p>
				</div>
				</#if>
				<div class="order-info">
					<p class="info-tittle">
						下单时间：<span>${teamMember.deliverytime}</span>
					</p>
				</div>
			</div>
			
			<ul class="price_box">
					<li>订单金额：￥${(teamBuyScale.real_price)/100}</li>
					<li>优惠金额：￥${(teamBuyScale.real_price-teamBuyScale.activity_price_reduce)/100}</li>
					<li>配送费用：￥${(teamMember.delivery_fee!0)/100}
					<li>应付金额：<span class="last_price">￥${((teamBuyScale.activity_price_reduce!0)+(teamMember.delivery_fee!0))/100}</span></li>
			</ul>
			<div class="cartfoot"  style="bottom:0;">
				<div class="cancel-btn" onclick="cancelOrder()">取消订单</div>
				<div id="pay-btn">立即支付</div>
			</div>
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
						url: "${CONTEXT_PATH}/pay/payTeamBuy",
						data: {
							   buyScaleId:${teamBuyScale.id},
							   teamBuyId:<#if teamBuyId?? && teamBuyId!=''>${teamBuyId}<#else>0</#if>,
							   order_store:"${teamMember.order_store}",
							   deliverytype:"${teamMember.deliverytype}",
							   deliverytime:"${teamMember.deliverytime}",
							   receiver_name: "${teamMember.receiver_name!}",
							   receiver_mobile:"${teamMember.receiver_mobile!}",
							   address_detail:"${teamMember.address_detail!}",
							   delivery_fee:"${teamMember.delivery_fee!0}",
							   lat:"${teamMember.lat!0}",
							   lng:"${teamMember.lng!0}"
							  }
					},
					wcpay: {
						ok: function(res,data){
				            window.location.href = "${CONTEXT_PATH}/pay/teamSuccessPay?delivery_fee=${teamMember.delivery_fee!0}&buyScaleId=${teamBuyScale.id}&lat=${teamMember.lat!0}&lng=${teamMember.lng!0}&orderId="+data.orderId;
						},
						fail: function(res,data){
							$.post("${CONTEXT_PATH}/pay/teamFailure", {buyScaleId: ${teamBuyScale.id},orderId:data.orderId});
						}
					},
					balancepay: function(res){
				        window.location.href = "${CONTEXT_PATH}/pay/teamSuccessPay?delivery_fee=${teamMember.delivery_fee!0}&buyScaleId=${teamBuyScale.id}&lat=${teamMember.lat!0}&lng=${teamMember.lng!0}&orderId="+res.orderId;
					}
			    });
			});
		});
		
		function cancelOrder(){
			window.location.href="${CONTEXT_PATH}/main";
		}
		
		function back(){
			window.history.back();
		}
	</script>
</body>
</html>
