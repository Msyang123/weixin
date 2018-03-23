<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-订单" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order" class="my-present-detail">
	
	   <div class="orderhead">
			<div class="btn-back"><a onclick="window.history.go(-1)"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>赠送详情</div>
		</div>
		
		<div data-role="main" id="present_detail">	
			<div class="present-info-box">
				<div class="present-info-people"><#if type="source">接收好友<#else>赠送人</#if>：${present.present_username}</div>
				<div class="present-info-status">${present.status_cn}</div>
			</div>
			<div class="procontent">
			    <div class="row no-gutters align-items-center">
					<div class="col-6 present-pro-num">共${product_num!}件商品</div>
					<div class="col-6 present-time">${present.present_time}</div>
				</div>
				<div class="pro-list clearfix">				
					<!-- 商品列表开始 -->
					<#list presentProducts as product>
					 <div class="row no-gutters align-items-center mb8">
						<div class="col-4">
							<img height="60px" src="${product.save_string!}" />
						</div>
						<div class="col-4 col-sm-auto">
							<div class="font_blod">
								${product.product_name!}			
								<span>${product.product_amount!}${product.unit_name!}</span>
							</div>
							<div class="font_price">￥${(product.real_price!0)/100}</div>
						</div>
						<div class="col-4">X ${product.amount!0}</div>
					 </div>
					</#list>
				</div>
			</div>
			
			<div class="row no-gutters align-items-center total-money">
				<div class="col-12 text-left">
					总计金额：<span class="font-price brand-red">￥${((present.discount!0)+(present.need_pay!0))/100}</span><br/>
					优惠金额：<span class="font-price brand-red">￥${(present.discount!0)/100}</span><br/>
					应付金额：<span class="font-price brand-red">￥${(present.need_pay!0)/100}</span>
				</div>		
			</div>
			
			<div class="message">
				<div class="message-text">赠送附言</div>
				<div class="message-box">${present.present_msg!"暂无任何留言"}</div>
			</div>
			<#if type="target">
			<div class="col">
				<button type="button" class="btn-custom" onclick="gotoMyStorage()">快去我的仓库提货吧</button>
			</div>
			</#if>
			<#if present.present_status=='1'>
			<div class="cartfoot">
				<div onclick="cancelOrder(${present.id})" class="btn-cancel">
					取消订单
				</div>
				<div id="present-pay-btn">
					立即支付
				</div>
			</div>
			</#if>	
			</div>
		</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>	
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#present-pay-btn").on("click", function(e){
				e && e.preventDefault();
			    $(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/present",
						data: {presentId: "${present.id}"}
					},
					wcpay: {
						ok: function(res){ 
				            $.dialog.alert("微信支付成功!");
				            window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${present.id}&type=zs";
						},
						fail: function(res){
							$.post("${CONTEXT_PATH}/pay/presentFailure", {presentId: "${present.id}"});
						}
					},
					balancepay: function(res){
				        //alert("余额支付 - 页面跳转");
				        window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${present.id}&type=zs";
					}
			    });
			});
		});
	</script>
	<script>
		function cancelOrder(presentId){
			$.dialog.message("确认取消订单吗？",true,function(){
				$.ajax({
		            type: "POST",
		            url: "${CONTEXT_PATH}/cancelPresent",
		            data: {presentId:presentId},
		            dataType: "json",
		            success: function(data){
		            	if(data.result=="success"){
		            		window.location.reload();
		            	}else{
		            		alert(data.msg);
		            	}
		            }
		        });
			});
		}
		
		function gotoMyStorage(){
			window.location.href="${CONTEXT_PATH}/myStorage";
		}
</script>			    
</body>
</html>