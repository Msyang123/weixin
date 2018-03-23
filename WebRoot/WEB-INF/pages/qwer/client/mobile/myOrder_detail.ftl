<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-订单详情" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order" class="my-order-detail">
		
		<div data-role="main" style="height:100%;">
				<div class="orderhead">
					<div class="btn-back"><a onclick="window.history.go(-1)"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
					<div>订单详情</div>
				</div>
			     <div style="height:50px;">
			</div>
			<#if order.order_status=='3' && order.deliverytype='1'>
				<div class="tips marquee">请您在72小时内完成提货，超出时间将自动取消该订单，按实际支付金额转成等价的鲜果币</div>
			</#if>
			<div class="order-info">
				<div class="order-number">订单编号<span>${order.order_id}</span></div>
				<div class="order-state">${order.status_cn}</div>
			</div>
			<#if order.deliverytype='2'>
			<div class="content">
				<div class="order-info-text">联系方式</div>
					<div class="content-left">
						${order.receiver_name!} &nbsp;&nbsp;${order.receiver_mobile!}
					</div>
			</div>
			<div class="content" style="height: auto;">
				<div class="order-info-text">收货地址</div>
					<div class="content-left">
						${order.address_detail!}
					</div>
			</div>
			</#if>

			<div class="content">
				<div class="order-info-text">下单时间</div>
				<div class="content-left">
					${order.createtime_display!}
				</div>
			</div>
			<div class="content">
				<div class="order-info-text">配送方式</div>
				<div class="content-left">
					<#if order.deliverytype='1'>
					 	门店自提
					<#elseif order.deliverytype='2'>
						送货上门
					<#else>
						全国配送
					</#if> 
				</div>
			</div>
			<div class="content">
				<div class="order-info-text">支付方式</div>
				<div class="content-left">
					<#if order.pay_type='1'>
					 	 在线支付
					<#else>
						货到付款
					</#if>
					
				</div>
			</div>
			<#if order.deliverytype='2'>
				<div class="content">
					<div class="order-info-text">配送时间</div>
					<div class="content-left">
						${order.deliverytime!}
					</div>
				</div>
			</#if>
			<div class="content">
				<div class="order-info-text">配送门店</div>
				<div class="content-left">
					${order.store_name!}
				</div>
			</div>
			<div class="content">
				<div class="order-info-text">我的留言</div>
				<div class="content-left">
					${order.customer_note!}
				</div>
			</div>
			<#if order.deliverytype='2'>
			<div class="content" style="color:#de374e;">
				超时未配送请联系${order.store_phone!}
			</div>
			</#if>
			<div class="procontent">
				<div class="procontent-number">
					共${product_num!}件商品
				</div>
				<table style="width:100%;border-collapse:collapse;" id="order-detail">
					<!-- 商品列表开始 -->
					<#list orderProducts as product>
					<tr>
						<td width="30%">
							<img height="80px"
							src="${product.save_string}" data-pid="${product.product_id}"/>
						</td>
		
						<td width="50%">
							<div class="pro-name">
								${product.product_name!}
								<br/>
								<span>${product.unit_name!}</span>
							</div>
							<div class="pro-price">￥${(product.price!0)/100}</div>
						</td>
						<td width="20%" clas="pro-num">
							×${product.amount!}
						</td>
					</tr>
					</#list>
				</table>
			</div>
			<div class="pro-price-content">
				<ul class="font-price">
					<li>
						商品总额：<span>￥${(order.total!0)/100}</span>
					</li>
					<li>
						优惠金额：<span>￥${(order.discount!0)/100}</span>
					</li>
					<#if order.deliverytype='2'||order.deliverytype='3'>
					 	<li>
							配送费：<span>￥${(order.delivery_fee!0)/100}</span>
						</li>
					</#if>
					<li>
						<#if order.order_type='2'>
							应付金额：<span>￥0</span>
						<#else>
							应付金额：<span>￥${((order.need_pay!0)+(order.delivery_fee!0))/100}</span>
						</#if>
					</li>
					<#if order.title??>
					<li>
						使用优惠券：<span>${coupon.title!}</span>
					</li>
					</#if>
				</ul>
			</div>
				<#if order.order_status=='1'>
				<div class="cartfoot">
					<div onclick="cancelOrder(${order.id})" class="btn-cancel">
						取消订单
					</div>
					<div id="pay-btn">
						立即支付
					</div>
				</div>
				<#elseif order.order_status=='3'>
				<div class="cartfoot">
					<#if isVisible=="true">
						<div class="detail-recede">
							<a href="#hdCancelOrderDialog" onclick="$('#hdCancelOrderId').val(${order.id});" 
												data-position-to="window" data-rel="popup" class="full-btn btn-recede"
														data-transition="slideup">退货</a>
						</div>
					</#if>
					
 					<!-- <div onclick="confirmReceipt(${order.order_status},${order.id})" class="btn-operation">
 						确认收货 
 					</div>  -->
				</div>
				<#elseif order.order_status=='4'>
						<div class="detail-recede">
							<a href="#dialog" onclick="cancleFruit('order-detail')" data-position-to="window" data-rel="popup" class="full-btn btn-recede"
													data-transition="slideup">退货</a>
						</div>
				<#elseif order.order_status=='12'>
					<div onclick="confirmReceipt(${order.order_status},${order.id})" class="detail-recede">
 						<a class="full-btn btn-recede" data-ajax="false" style="color:white;">确认收货</a> 
 					</div>
				</#if>	
				<div data-role="popup" id="dialog" class="ui-content" style="min-width:250px;">
			        <a href="javascript:void(0);" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>        
		            <form id="submitForm">
		                 <div class="cancel-fruit">
		                     <div class="cancel-desc">
		                         <p>请选择你要退货的商品</p>
		                         <input type="checkbox" name="select_all" id="select_all" data-role='none'/>
		                     </div>
		                     <ul class="user-fruits"></ul>
		                 </div>
			             <div class="cancel-reason">
			                <p>请填写退货原因</p>          	
				          	<input type="hidden" name="orderId" id="orderId" value="${order.id}" />
					      	<div>
						        <textarea name="reason" id="reason" col="3" placeholder="200字以内" class="recede-box"></textarea>
						        <a class="confirm-recede" onclick="returnOrder();">确认</a>
					      	</div>
					      </div>
			      	</form>
			    </div>
				
				 <div data-role="popup" id="hdCancelOrderDialog" class="ui-content" style="min-width:250px;">
				      <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
				        <div>
				          <h3>请填写退货原因</h3>
				          	<form id="hdCancelSubmitForm">
					          	<input type="hidden" name="hdCancelOrderId" id="hdCancelOrderId" value="${order.id}" />
					           	<div class="ui-field-contain">
							        <textarea name="reason" placeholder="200字以内" class="recede-box"></textarea>
							        <a onclick="hdCancelOrder();" class="hd-recede">确认</a>
						      	</div>
					      	</form>
				        </div>
			    </div>
			</div>
		</div>
	</div>
		
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="//cdn.jsdelivr.net/jquery.marquee/1.4.0/jquery.marquee.min.js"></script><!--跑马灯效果-->	
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script data-main="scripts/main" src="plugin/dateTime/js/mobiscroll.js" ></script>
	<script data-main="scripts/main" src="plugin/dateTime/js/PluginDatetime.js"></script>
	<script type="text/javascript">
	
	function hdCancelOrder(){
		$.ajax({
            type: "POST",
            url: "${CONTEXT_PATH}/hdCancelOrder",
            data: $("#hdCancelSubmitForm").serializeArray(),
            dataType: "json",
            success: function(data){
            	if(data.success){
            		$.dialog.alert(data.message);
            		window.location.href = "${CONTEXT_PATH}/myOrder?type=0";
            	}else{
            		$.dialog.alert(data.message);
            	}
            }
        });
	}
	
	function cancelOrder(orderId){
		$.dialog.message("确认取消订单吗？",true,function(){
			$.ajax({
	            type: "POST",
	            url: "${CONTEXT_PATH}/cancelOrder",
	            data: {orderId:orderId},
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
	
	function confirmReceipt(orderStatus,orderId){
		$.dialog.message("确认收货吗？",true,function(){
			$.ajax({
	            type: "POST",
	            url: "${CONTEXT_PATH}/confirmReceipt",
	            data: {order_status:orderStatus,orderId:orderId},
	            dataType: "json",
	            success: function(data){
	            	if(data.result=="success"){
	            		window.location.reload();
	            	}else{
	            		$.dialog.alert(data.msg);
	            	}
	            }
	        });
		});
	}
	
	function returnOrder(){
	//判断是否有被选中的
	if($("input[name='cancel_fruit']").is(':checked')){
			$.ajax({
	            type: "POST",
	            url: "${CONTEXT_PATH}/returnOrder",
	            data: $("#submitForm").serializeArray(),
	            dataType: "json",
	            success: function(data){
	            	if(data.result=="success"){
	            		window.location.href = "${CONTEXT_PATH}/myOrder?type=0";
	            	}else{
	            		$.dialog.alert(data.msg);
	            	}
	            }
	        });
	     }else{
	     	$.dialog.alert("请先选择要退货的商品！");
	     	return;
	     }   
	}		

    $('.user-fruits').on('click','li',function(e){
        var currentNode=$(e.currentTarget);
        if(currentNode.hasClass('active')){
            currentNode.removeClass('active')
            currentNode.find('span').css("display","none");
            currentNode.find('input').prop('checked',false)
        }else{
            currentNode.addClass('active')
            currentNode.find('span').css("display","block");
            currentNode.find('input').prop('checked',"checked")
        }
        var len=$('.user-fruits li').length;
        var seletedLen=$('.user-fruits li.active').length;

        if(seletedLen==len){
            $('#select_all').prop('checked','checked');
        }else{
            if($('#select_all').is(':checked')){
                $('#select_all').prop('checked',false);
            }
        }
    });

    $('#select_all').on('click',function(){
        if($(this).is(":checked")){
            $('.user-fruits li').addClass('active');
            $('.user-fruits li span').css("display","block");
            $('.user-fruits li').find('input').prop('checked','checked');
        }else{
            $('.user-fruits li').removeClass('active');
            $('.user-fruits li span').css("display","none");
            $('.user-fruits li').find('input').prop('checked',false);
        }
    });
    
    function cancleFruit(domId){
        $('.user-fruits').html("");
        var len=$("#"+domId).find('img').length;

        for(var i=0;i<len;i++){
            var imgNode=$("#"+domId).find('img').eq(i);
            var markup='<li><img src="'+imgNode.attr("src")+'" height="60px" />'+'<span></span>'+
                    '<input type="checkbox" name="cancel_fruit" value="'+imgNode.data("pid")+'" style="display:none" />'+
                    '</li>'
            $('.user-fruits').append(markup);
        }
    }
	</script>
	
	<script type="text/javascript">
		$(function(){
		    $('.marquee').marquee({
				duration: 8000,
				gap: 60,
				delayBeforeStart: 1,
				direction: 'left',
				duplicated: true
			});
		
			$("#pay-btn").on("click", function(e){
				$(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/order",
						data: {orderId: "${order.order_id}"}
					},
					wcpay: {
						ok: function(res){ 
				            $.dialog.alert("微信支付成功!");
				            window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${order.order_id}";
						},
						fail: function(res){
							$.post("${CONTEXT_PATH}/pay/orderFailure", {orderId: "${order.order_id}"});
						}
					},
					balancepay: function(res){
				        //alert("余额支付 - 页面跳转");
				        window.location.href = "${CONTEXT_PATH}/pay/successPay?orderId=${order.order_id}";
					}
				});
			});
		});
	</script>			    
</body>
</html>