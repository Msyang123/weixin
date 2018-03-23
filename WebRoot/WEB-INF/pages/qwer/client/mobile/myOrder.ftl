<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-我的订单" />	
<link rel="stylesheet" href="plugin/tab/tab-4.css">
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<#if isUserFirstBuy?? && isUserFirstBuy>
	<div class="shadeOrder">
		<i class="close">
            <img src="resource/image/icon/shade-close.png" />
        </i>
		<div class="order-code">编号：8547595421358</div>
	    <i class="icon">
            <img src="resource/image/icon/first-buy.png" />
        </i>
        <p>这个是<span>订单编号</span></p>
        <p>把这个给导购看就行了哦~</p>		
    </div>
</#if>
	<div data-role="page" class="my-order">
		<div data-role="main">
			<div class="carthead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px"
						src="resource/image/icon/icon-back.png" /></a>
				</div>
				<div>我的订单</div>
			</div>
			<div style="height:90px;"></div>
			<div class="tab">
				<div class="title cf">
					<ul class="title-list fl cf">
						<li class="on">全部</li>
						<li>待付款</li>
						<li>待收货</li>
						<li>退货</li>
						<p></p>
					</ul>
				</div>
				<div class="product-wrap">
					<!--全部-->
					<div class="product show" id="all_order">
					<#if (tOrders??)&&(tOrders?size>0)>
									
							<#list tOrders as tOrder>
							<div class="product-item">							
									<div class="order-status-box">
										<div class="float-left">编号：${tOrder.order_id}</div>
										<div class="float-right orderstatus">
											<#if tOrder.order_status=='1'> 待付款 <#elseif
												tOrder.order_status=='2'> 支付中 <#elseif
												tOrder.order_status=='3'> 待收货 <#elseif
												tOrder.order_status=='4'> 已收货 <#elseif
												tOrder.order_status=='5'> 退货中 <#elseif
												tOrder.order_status=='6'> 退货完成 <#elseif
												tOrder.order_status=='7'> 退货中 <#elseif
												tOrder.order_status=='8'> 店铺处理中 <#elseif
												tOrder.order_status=='11'> 成功 <#elseif
												tOrder.order_status=='0'> 已失效 <#elseif
												tOrder.order_status=='12'>配送中<#else> -- </#if>
										</div>
									</div>
									<div class="pro-detail-box swiper-container0" id="pro-${tOrder.id}" onclick="orderDetail('${tOrder.id}');" >
										<div class="swiper-wrapper">
	                                        <#list tOrder.orderProducts as product> 
											   <div class="swiper-slide">
											       <img src="resource/image/icon/blank.gif" data-echo="${product.save_string!}" data-pid="${product.id}" onerror="common.imgLoad(this)"/>
											   </div> 
	                                        </#list>
                                            <div class="swiper-scrollbar0"></div>
                                        </div>
									</div>
									<div class="row no-gutters justify-content-between total-box">
										<div class="col-3 total-num">
											共${tOrder.totalProduct}件商品
										</div>
										<div class="col-4 total-price-box">
											<p class="total-price">合计： <span>￥${((tOrder.need_pay!0)+(tOrder.delivery_fee!0))/100}</span></p>		
										</div>
										<div class="col-5">
										<#if tOrder.order_status=='1'>
											<button onclick="pay(${tOrder.id})" class="btn-pay">付款</button>
											<button onclick="cancelOrder(${tOrder.id})" class="btn-cancel-order">取消订单</button>
										<#elseif tOrder.order_status=='3'>
											<#list temp as item>
												 <#if item.orderId==tOrder.order_id && item.isVisible=="true">
													<!-- <button onclick="confirmReceipt(${tOrder.order_status},${tOrder.id})" class="btn-confirm">确认收货</button> -->
													<a href="#hdCancelOrderDialog" onclick="$('#hdCancelOrderId').val(${tOrder.id});" 
													data-position-to="window" data-rel="popup" class="btn-recede ui-btn ui-corner-all btn-non-arrival" 
														data-transition="slideup">退货</a>
												 </#if>
											</#list>
										<#elseif tOrder.order_status=='4'>
											 		<a href="#dialog" onclick="cancleFruit('pro-${tOrder.id}','all_order')" data-position-to="window" data-rel="popup" class="btn-recede ui-btn ui-corner-all" 
													data-transition="slideup">退货</a>
										<#elseif tOrder.order_status=='12'>
										 		<button onclick="confirmReceipt(${tOrder.order_status},${tOrder.id})" class="btn-confirm">确认收货</button>
										</#if>
										</div>
									</div>
							  </div>						
							</#list>
						
						<#else>
							<!-- 当全部订单为空时显示-->	
							<div class="empty-order">
								<img src="resource/image/icon/all_empty.png" /><br/>
								肚子饿了，好想吃点水果
							</div> 
						</#if>
					</div>
					
					<!--待付款-->
					<div class="product" id="waitpay_order">
					<#if (dfkTOrders??)&&(dfkTOrders?size>0)>
				
							<#list dfkTOrders as tOrder>
							<div class="product-item">
									<div class="pro-status">
										<div class="float-left">编号：${tOrder.order_id}</div>
										<div class="float-right orderstatus">待付款</div>
									</div>
									<div class="pro-detail-box swiper-container1" onclick="orderDetail('${tOrder.id}');" >
										<div class="swiper-wrapper">
                                            <#list tOrder.orderProducts as product> 
                                             <div class="swiper-slide"><img height="60" src="${product.save_string!}"
											  onclick="fruitDetial('${product.id}');" /></div> 
                                            </#list>
                                            <div class="swiper-scrollbar1"></div>
                                        </div>
									</div>
									<div class="row no-gutters justify-content-between total-box">
										<div class="col-3 total-num">
											共${tOrder.totalProduct}件商品
										</div>
										<div class="col-4">
											<p class="total-price">合计： <span>￥${((tOrder.need_pay!0)+(tOrder.delivery_fee!0))/100}</span></p>
										</div>
										<div class="col-5">
											<button onclick="pay(${tOrder.id});" class="btn-pay">付款</button>
											<button onclick="cancelOrder(${tOrder.id})" class="btn-cancel-order">取消订单</button>
										</div>
									</div>
						    </div>
							</#list>
						
						<#else>
							<!-- 当购物车为空时显示-->	
							<div class="empty-cart">
								<img src="resource/image/icon/dfk_empty.png" /><br/>
								抖抖你的手，美味水果就带走
							</div> 
						</#if>
					</div>
					
					<!--待收货-->
					<div class="product" id="waitrecieve_order">
					<#if (dshTOrders??)&&(dshTOrders?size>0)>
						
							<#list dshTOrders as tOrder>
							<div class="product-item">
									<div class="pro-status">
										<div class="float-left">编号：${tOrder.order_id}</div>
										<div class="float-right orderstatus">
										<#if tOrder.order_status=='3'> 待收货 
											<#elseif tOrder.order_status=='12'>配送中<#else> -- 
										</#if>
										</div>
									</div>
									<div class="pro-detail-box swiper-container2" onclick="orderDetail('${tOrder.id}');">
										<div class="swiper-wrapper">
	                                        <#list tOrder.orderProducts as product> 
											<div class="swiper-slide">
												<img height="60" src="${product.save_string!}" onerror="common.imgLoad(this)" />
											</div> 
	                                        </#list>
                                            <div class="swiper-scrollbar2"></div>
                                        </div>
									</div>
									<div class="row no-gutters justify-content-between total-box">
										<div class="col-3 total-num">
											共${tOrder.totalProduct}件商品
										</div>
										<div class="col-4">
											<p class="total-price">合计： <span>￥${((tOrder.need_pay!0)+(tOrder.delivery_fee!0))/100}</span></p>
										</div>
										<div class="col-5">
										
 											<!-- <button onclick="confirmReceipt(${tOrder.order_status},${tOrder.id})" class="btn-confirm">确认收货</button> -->
											<#if tOrder.order_status=='3'>
												<#list temp as item>
												    <#if item.orderId==tOrder.order_id && item.isVisible=="true">
													    <a href="#hdCancelOrderDialog" onclick="$('#hdCancelOrderId').val(${tOrder.id});" 
													data-position-to="window" data-rel="popup" class="btn-recede ui-btn ui-corner-all btn-non-arrival" 
															data-transition="slideup">退货</a>
												    </#if>
											    </#list>
											<#elseif tOrder.order_status=='12'>
													<button onclick="confirmReceipt(${tOrder.order_status},${tOrder.id})" class="btn-confirm">确认收货</button>
											</#if>
											
										</div>
									</div>
								</div>
							</#list>
						
						<#else>
							<!-- 当购物车为空时显示-->	
							<div class="empty-cart">
								<img src="resource/image/icon/dsh_empty.png" /><br/>
								瓜儿们已蓄势待发，只等您一声令下
							</div> 
						</#if>
					</div>
					
					<!--退货-->
					<div class="product" id="cancel_order">
					
						<#if (thTOrders??)&&(thTOrders?size>0)>
				
							<#list thTOrders as tOrder>
							<div class="product-item">
									<div class="pro-status">
										<div class="float-left">编号：${tOrder.order_id}</div>
										<div class="float-right orderstatus">
											<#if tOrder.order_status=='1'> 待付款 <#elseif
												tOrder.order_status=='2'> 支付中 <#elseif
												tOrder.order_status=='3'> 待收货 <#elseif
												tOrder.order_status=='4'> 已收货 <#elseif
												tOrder.order_status=='5'> 退货中 <#elseif
												tOrder.order_status=='6'> 退货完成 <#elseif
												tOrder.order_status=='7'> 退货中 <#elseif
												tOrder.order_status=='8'> 店铺处理中 <#elseif
												tOrder.order_status=='0'> 已失效 <#elseif
												tOrder.order_status=='12'> 配送中<#else> -- </#if>
										</div>
									</div>
									<div class="pro-detail-box swiper-container3" id="pro-${tOrder.id}" onclick="orderDetail('${tOrder.id}');" >
									    <div class="swiper-wrapper">
											<#list tOrder.orderProducts as product> 
											    <div class="swiper-slide">
											       <img height="60" src="${product.save_string!}" data-pid="${product.id}" onerror="common.imgLoad(this)" />
											    </div> 
	                                        </#list>
	                                        <div class="swiper-scrollbar3"></div>
                                        </div>
									</div>
									<div class="row no-gutters justify-content-between total-box">
										<div class="col-3 total-num">
											共${tOrder.totalProduct}件商品
										</div>
										<div class="col-4">
											<p class="total-price">合计： <span>￥${((tOrder.need_pay!0)+(tOrder.delivery_fee!0))/100}</span></p>
										</div>
										<div class="col-5">
											<#if tOrder.order_status=='4'>
													<a href="#dialog" onclick="cancleFruit('pro-${tOrder.id}','cancel_order')" data-position-to="window" data-rel="popup" class="btn-recede ui-btn ui-corner-all" 
														data-transition="slideup">退货</a>
											</#if>
										</div>
									</div>
						    </div>
							</#list>
						
						<#else>
							<!-- 当购物车为空时显示-->	
							<div class="empty-cart">
							<img src="resource/image/icon/th_empty.png" /><br/>
								没有可以退货的订单哦
							</div> 
						</#if>
					</div>
				</div>
			</div>

		</div>
		
		<div data-role="popup" id="dialog" class="ui-content" style="min-width:250px;" data-overlay-theme="b">
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
		          	<input type="hidden" name="orderId" id="orderId" />
		           	<div>
				        <textarea name="reason" id="reason" col="3" class="recede-box" placeholder="200字以内"></textarea>
				        <a class="confirm-recede" onclick="returnOrder();">确认</a>
			      	</div>
			      </div>
	      	</form>
	    </div>
	    
	    <div data-role="popup" id="hdCancelOrderDialog" class="ui-content" style="min-width:250px;" data-overlay-theme="b">
	      <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
	        <div>
	          <h3>请填写退货原因</h3>
	          	<form id="hdCancelSubmitForm">
		          	<input type="hidden" name="hdCancelOrderId" id="hdCancelOrderId" />
		           	<div class="ui-field-contain">
				        <textarea name="reason" class="recede-box" placeholder="200字以内"></textarea>
				        <a onclick="hdCancelOrder();" class="hd-recede">确认</a>
			      	</div>
		      	</form>
	        </div>
	    </div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/productDetial.js"></script>
	<script src="plugin/tab/tab.js"></script>
	<script src="plugin/common/echo.min.js"></script>
	<script>
	$(function(){
		var type = parseInt("${type}");
		$(".title-list li").eq(type).click();
		
		//延迟加载图片初始化
		echo.init();
		
		$('.user-fruits').on('click','li',function(e){  
		    var currentNode=$(e.currentTarget);
		    if(currentNode.hasClass('active')){
		      currentNode.removeClass('active')
		      currentNode.find('input').prop('checked',false)
		      currentNode.find('span').css("display","none");
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
	
	});
	
	function cancleFruit(domId,typeId){
	
	    $('.user-fruits').html("");
	    var len=$("#"+typeId+" "+"#"+domId).find('img').length;
	    
	    for(var i=0;i<len;i++){
	         var imgNode=$("#"+domId).find('img').eq(i);         
	         var markup='<li><img src="'+imgNode.attr("src")+'" height="60px" />'+'<span></span>'+
                        '<input type="checkbox" name="cancel_fruit" value="'+imgNode.data("pid")+'" style="display:none" />'+
                        '</li>'
             $('.user-fruits').append(markup);           
	    }
	    
        $('#orderId').val(domId.replace("pro-",""))
	}
	
	function back() {
		window.location.href = "${CONTEXT_PATH}/me";
	}

	function orderDetail(id) {
		window.location.href = "${CONTEXT_PATH}/pay/orderDetail?id="+id;
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
	            		window.location.href = "${CONTEXT_PATH}/myOrder?type=1";
	            	}else{
	            		$.dialog.alert(data.msg);
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
	            		window.location.href = "${CONTEXT_PATH}/myOrder?type=2";
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
            		window.location.href = "${CONTEXT_PATH}/myOrder?type=2";
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
	            		window.location.href = "${CONTEXT_PATH}/myOrder?type=3";
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
	
	function pay(orderId){
		window.location.href = "${CONTEXT_PATH}/pay/sbmtOrder?id="+orderId;
	}
	
	function toMain(){
		window.location.href="${CONTEXT_PATH}/main";
	}
			
	//分享层
	$(".close").click(function(){
	 		$(".shadeOrder").css("display","block");
	 	})
	 	
    $(document).on("touchmove",function(e) {
        if($(".shadeOrder").css("display")==='block') {
            e.preventDefault();
        }
    });
	
    $(".close").click(function(){
        $(".shadeOrder").css("display","none");
    })
        
</script>
</body>