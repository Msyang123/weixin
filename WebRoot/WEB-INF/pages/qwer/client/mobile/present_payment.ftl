<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-支付详情" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="present-payment bg-white">	
		<div data-role="main">
		<#if present??>
			<div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<div>支付详情</div>
			</div>

			<div id="present-detail">
			    <div id="tipsDiv">请在30分钟内完成支付，否则订单将被取消</div>
				<div class="pro-num">共${productNum}种商品</div>
				<div class="pro-list clearfix">				
					<!-- 商品列表开始 -->
					<#list presentProducts as product>
					 <div class="row no-gutters align-items-center present-list">
						<div class="col-4">
							<img class="pro-img" src="${product.save_string}" onclick="fruitDetial('${product.pf_id}')"/>
						</div>
						<div class="col-4 col-sm-auto">
							<div class="font_blod">
								${product.product_name!}			
								<span>${product.product_amount!}${product.base_unit!}/${product.unit_name!}</span>
							</div>
							<div class="font_price">￥${(product.price!0)/100}</div>
						</div>
						<div class="col-4"><!--X ${product.amount!0}--></div>
					 </div>
					</#list>
				</div>
				
				<div class="message">
					<div class="message-text">留言</div>
					<div class="message-box">${present.present_msg!'暂无任何留言'}</div>
				</div>	
				<div class="sent-friend text-left">赠送好友：${present.nickname!} (${present.phone_num!})</div>
				<div class="pay-money">
					总计金额：<span class="sum">￥${((present.discount!0)+(present.need_pay!0))/100}</span><br/>
					优惠金额：<span class="sum">￥${(present.discount!0)/100}</span><br/>
					应付金额：<span class="sum">￥${(present.need_pay!0)/100}</span>
				</div>
			</div>
			<div class="cartfoot">
				<div class="cancel-btn" onclick="cancelPresent('${present.id}')">取消订单</div>
				<div id="present-pay-btn">立即支付</div>
			</div>
		</div>
		<#else>
			<div class="past-page">页面已过期</div>
		</#if>
	</div>
	<div class="custom-dialog">
	    <img src="resource/image/icon/icon-success.png" />
	    <p>余额支付成功</p>
    </div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#present-pay-btn").on("click",function(e){
				e && e.preventDefault();
				$(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/present",
						data: {presentId: "${present.id}"}
					},
					wcpay: {
						ok: function(res){ 
				            //alert("微信支付成功!");
				            window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${present.id}&type=zs&deliverytype=1";
						},
						fail: function(res){
							$.post("${CONTEXT_PATH}/pay/presentFailure", {presentId: "${present.id}"});
						}
					},
					balancepay: function(res){
				       // alert("余额支付 - 页面跳转");
				       window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${present.id}&type=zs&deliverytype=1";
					}
				});
			});
		});
		
	    function cancelPresent(presentId){
			$.dialog.message("确认取消赠送吗（取消后将不能恢复）？",true,function(){
				$.ajax({
			       type: "POST",
			       url: "${CONTEXT_PATH}/cancelPresent",
			       data: {presentId:presentId},
			       dataType: "json",
			       success: function(data){
			    	   if(data.result=="success"){
			    		   window.location.href = "${CONTEXT_PATH}/main";
			    		}else{
			    			   alert(data.msg);
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
