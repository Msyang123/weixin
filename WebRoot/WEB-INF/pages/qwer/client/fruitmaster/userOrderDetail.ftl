<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-用户订单详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="user_order_detail" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" onclick="back();">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>订单详情</span>
		  </header>
		  <div style="height:4rem;"></div>
		  
		  <#if orderDetail.order_status=='3' && orderDetail.deliverytype='1'>
		 	 <div class="u-tips2 marquee">请您在72小时内完成提货，超出时间将自动取消该订单，按实际支付金额转成等价的鲜果币</div>
		  </#if>
		  
		  <section class="m-card">
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">订单信息</div>
		          <div class="col-8 order-status brand-blue text-right">${orderDetail.status_cn}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">订单编号</div>
		          <div class="col-8 text-right brand-grey-h">${orderDetail.order_id}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">下单时间</div>
		          <div class="col-8 text-right brand-grey-h">${orderDetail.createtime_display!}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">配送方式</div>
		          <div class="col-8 text-right brand-grey-h">
						<#if orderDetail.deliverytype='1'>
						 	门店自提
						<#else>
							送货上门
						</#if>	
				  </div>
		      </div> 
		      <#if orderDetail.deliverytype='2'>
			      <div class="u-cell row no-gutters justify-content-between align-items-center">
			          <div class="col-4">配送时间</div>
			          <div class="col-8 text-right brand-grey-h">${orderDetail.deliverytime!}</div>
			      </div> 
			      
			      <div class="u-cell row no-gutters justify-content-between align-items-center">
			          <div class="col-4">送货地址</div>
			          <div class="col-8 text-right brand-grey-h">${orderDetail.address_detail!}</div>
			      </div> 
		      </#if>
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">服务门店</div>
		          <div class="col-8 text-right brand-grey-h">${orderDetail.store_name!}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">支付方式</div>
		          <div class="col-8 text-right brand-grey-h">
		          		<#if orderDetail.pay_type='1'>
						 	 在线支付
						<#else>
							货到付款
						</#if>
		          </div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">订单备注</div>
		          <div class="col-8 text-right brand-grey-h">${orderDetail.customer_note!}</div>
		      </div> 
		  </section>
		  
		  <section class="mb50 m-card m-card-bt" style="margin-bottom:5rem;">
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4"><h4>订单信息</h4></div>
		      </div>
		      
		      <!-- 商品列表开始 -->
		      <div class="m-pro-list bg-grey-light" id="order-detail"> 
					<#list orderDetail.orderProducts as product>
						 <div class="m-item row no-gutters align-items-center">
							<div class="col-4 text-center">
								<img src="${product.save_string}" data-pid="${product.product_id}"/>
							</div>
							<div class="col-6 col-sm-auto pl10">
								<h4>${product.product_name!}</h4>			
								<h5>${product.unit_name!}</h5>
								<p class="brand-blue">&yen; ${(product.price!0)/100}</p>
							</div>
							<div class="col-2"><sub>X${product.amount!}</sub></div>
						 </div>
				    </#list>
			  </div>
				
			  <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">共${orderDetail.product_num!}件商品</div>
		      </div>
		       
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">商品金额:</div>
		          <div class="col-8 text-right brand-blue">&yen; ${(orderDetail.total!0)/100}</div>
		      </div>
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">优惠金额:</div>
		          <div class="col-8 text-right brand-blue">&yen; ${(orderDetail.discount!0)/100}</div>
		      </div>
		      
		      <#if orderDetail.deliverytype='2'> 
			      <div class="u-cell row no-gutters justify-content-between align-items-center">
			          <div class="col-4">配送费:</div>
			          <div class="col-8 text-right brand-blue">&yen; ${(orderDetail.delivery_fee!0)/100}</div>
			      </div> 
		      </#if> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">应付金额</div>
		          <div class="col-8 text-right brand-blue">
				  		<#if orderDetail.order_type='2'>
							&yen; 0
						<#else>
							&yen; ${((orderDetail.need_pay!0)+(orderDetail.delivery_fee!0))/100}
						</#if>
				  </div>
		      </div> 
		  </section>
		  
		  <#if orderDetail.order_status=='1'>		  
			  <footer class="row m-bottom-btn no-gutters">
				  <a class="col-6" onclick="cancelOrder(${orderDetail.id})">取消订单</a>
				  <a class="col-6 s-btn-brown" id="pay-btn">立即支付</a>
			  </footer>
		  <#elseif orderDetail.order_status=='3'>
			  <a class="u-btn-single s-btn-brown" onclick="$('#hdCancelOrderId').val(${orderDetail.id});" 
										data-toggle="modal" data-target="#cancelModal">退货</a>			  
		  <#elseif orderDetail.order_status=='4'>
			  <a class="u-btn-single s-btn-brown" data-toggle="modal" data-target="#returnModal"  onclick="cancleFruit('order-detail')">退货</a>	  
		  </#if>
	</div>
	
	<div class="modal fade s-model-m" id="returnModal" tabindex="-1" role="dialog" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
		        <form id="submitForm">	
	                 <div class="cancel-fruit" hidden>
	                     <div class="cancel-desc">
	                         <p>请选择你要退货的商品</p>
	                         <input type="checkbox" name="select_all" id="select_all" data-role='none'/>
	                     </div>
	                     <ul class="user-fruits"></ul>
	                 </div>
		             <div class="cancel-reason">
		                <p>请填写退货原因</p>
		                <input type="hidden" name="orderId" id="orderId" value="${orderDetail.id}" />          	
			           	<div>
					        <textarea name="reason" id="reason" rows="5" placeholder="200字以内" oninput="common.reExpression()"></textarea>
					        <a class="confirm-recede s-btn-brown" onclick="returnOrder();">确认</a>
				      	</div>
				      </div>
		      	</form>
	      </div>
	    </div>
	  </div>
	</div>	
	
	<div class="modal fade s-model-m" id="cancelModal" tabindex="-1" role="dialog" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body m-cancel-box">
	          <p>请填写退货原因</p>
	          	<form id="hdCancelSubmitForm">
		          	<input type="hidden" name="hdCancelOrderId" id="hdCancelOrderId" value="${orderDetail.id}" />
		           	<div class="ui-field-contain">
				        <textarea name="reason" placeholder="200字以内" rows="5" oninput="common.reExpression()"></textarea>
				        <a onclick="hdCancelOrder();" class="hd-recede s-btn-brown">确认</a>
			      	</div>
		      	</form>
	      </div>
	    </div>
	  </div>
	</div>
		
	<script src="//cdn.jsdelivr.net/jquery.marquee/1.4.0/jquery.marquee.min.js"></script><!--跑马灯效果-->
	<script src="plugin/weixin/wechat.payment.js"></script>
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
       	    
	       	 $("#pay-btn").on("click",function(e){
				  e && e.preventDefault();
				  $(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/payFruitmasterBuy",
						data: {orderId: "${orderDetail.order_id}"}
					},
					wcpay: {
						ok: function(res){
							$.dialog.alert("微信支付成功!");
							window.location.href = "${CONTEXT_PATH}/pay/fruitmasterSuccessPay?orderId=${orderDetail.order_id}";
						},
						fail: function(res){
							$.post("${CONTEXT_PATH}/pay/payFruitmasterFailure", {orderId: "${orderDetail.order_id}"});
						}
					},
					balancepay: function(res){
				       // alert("余额支付 - 页面跳转");
				        window.location.href = "${CONTEXT_PATH}/pay/fruitmasterSuccessPay?orderId=${orderDetail.order_id}";
					}
				 });
	       	});
       	 });
        
        function cancleFruit(domId){

            $('.user-fruits').html("");
            var len=$("#"+domId).find('img').length;

            for(var i=0;i<len;i++){
                var imgNode=$("#"+domId).find('img').eq(i);
                var markup='<li><img src="'+imgNode.attr("src")+'" height="60px" />'+'<span></span>'+
                        '<input type="checkbox" checked="checked" name="cancel_fruit" value="'+imgNode.data("pid")+'" style="display:none" />'+
                        '</li>'
                $('.user-fruits').append(markup);
            }
        }
        
        function back(){
        	window.location.href="${CONTEXT_PATH}/myself/userOrder?type=0";
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
		            		window.location.href = "${CONTEXT_PATH}/myself/userOrder?type=0";
		            	}else{
		            		$.dialog.alert(data.msg);
		            	}
		            }
		        });
			});
		}
		function hdCancelOrder(){
			$.ajax({
	            type: "POST",
	            url: "${CONTEXT_PATH}/hdCancelOrder",
	            data: $("#hdCancelSubmitForm").serializeArray(),
	            dataType: "json",
	            success: function(data){
	            	if(data.success){
	            		$.dialog.alert(data.message);
	            		window.location.href = "${CONTEXT_PATH}/myself/userOrder?type=3";
	            	}else{
	            		$.dialog.alert(data.message);
	            	}
	            }
	        });
		}
		
		function returnOrder(){
			if($("input[name='cancel_fruit']").is(':checked')){
				
				$.ajax({
		            type: "POST",
		            url: "${CONTEXT_PATH}/returnOrder",
		            data: $("#submitForm").serializeArray(),
		            dataType: "json",
		            success: function(data){
		            	
		            	if(data.result=="success"){
		            		window.location.href = "${CONTEXT_PATH}/myself/userOrder?type=3";
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
	</script>
</body>
</html>