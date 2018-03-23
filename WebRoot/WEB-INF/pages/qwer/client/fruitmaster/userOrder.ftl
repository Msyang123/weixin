<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-用户订单管理页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>

	<div id="user_order" class="wrapper my-order">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" onclick="back();">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>我的订单</span>
		  </header>
				
			<div class="title-list row no-gutters justify-content-center mt48">
				<div class="col-3 text-center type on">全部</div>
				<div class="col-3 text-center type">待付款</div>
				<div class="col-3 text-center type">待收货</div>
				<div class="col-3 text-center type">退货</div>
			</div>
			
			<div class="product-wrap">
				<!--全部-->
				<div class="product show" id="all_order">
					<#if (qbTOrders??)&&(qbTOrders?size>0)>
						<#list qbTOrders as tOrder>
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
												tOrder.order_status=='11'> 成功 <#elseif
												tOrder.order_status=='0'> 已失效 <#else> -- </#if>
								</div>
							</div>
										
							<div class="pro-detail-box" id="pro-${tOrder.id}" onclick="orderDetail('${tOrder.id}');" >
								<div class="m-pro-detail-list">
									 <#list tOrder.orderProducts as product>
									 	<div class="pro-detail-itm"><img src="${product.save_string!}" data-pid="${product.id}" onerror="imgLoad(this)"/></div> 
		                             </#list>	
		                        </div>
							</div>
							
							<div class="row no-gutters justify-content-between align-items-center total-box">
								<div class="col-3 total-num">
									共${tOrder.totalProduct}件商品
								</div>
								<div class="col-4 total-price-box">
									<p class="total-price">合计： <span>&yen; ${(tOrder.need_pay!0)/100}</span></p>		
								</div>
								<div class="col-5">
							 		<#if tOrder.order_status=='1'>
										<button onclick="pay(${tOrder.id})" class="btn bnt-sm u-btn-brown btn-pay">付款</button>
										<button onclick="cancelOrder(${tOrder.id})" class="btn btn-cancel-order">取消订单</button>
									<#elseif tOrder.order_status=='3'>
											<a onclick="$('#hdCancelOrderId').val(${tOrder.id});" 
											data-toggle="modal" data-target="#cancelModal" class="btn btn-recede">退货</a>
									<#elseif tOrder.order_status=='4'>
									 		<a data-toggle="modal" data-target="#returnModal"  onclick="cancleFruit('pro-${tOrder.id}','all_order')" class="btn btn-recede" 
											>退货</a> 
									</#if>
								</div>
		                   </div>
		              </div>
		              </#list>
		              <#else>
			              <div class="z-none">
					         <img src="resource/image/icon-master/order_empty.png"/>
					         <p>暂无任何订单</p>
					      </div>
		              </#if>
				</div><!--/End all-orders-->
				
				<!--待付款-->
				<div class="product" id="waitpay_order">
					<#if (dfkTOrders??)&&(dfkTOrders?size>0)>
						<#list dfkTOrders as tOrder>
						<div class="product-item">
							<div class="pro-status">
								<div class="float-left">编号：${tOrder.order_id}</div>
								<div class="float-right orderstatus">待付款 </div>
							</div>
										
							<div class="pro-detail-box swiper-container"  onclick="orderDetail('${tOrder.id}');">
								<div class="m-pro-detail-list">
									 <#list tOrder.orderProducts as product> 
		                             	<div class="pro-detail-itm">
		                             		<img src="${product.save_string!}" data-pid="${product.id}" onerror="imgLoad(this)"/>
		                             	</div>
		                             </#list>
		                        </div>
							</div>
							
							<div class="row no-gutters justify-content-between align-items-center total-box">
								<div class="col-3 total-num">
									共${tOrder.totalProduct}件商品
								</div>
								<div class="col-4 total-price-box">
									<p class="total-price">合计： <span>&yen; ${(tOrder.need_pay!0)/100}</span></p>		
								</div>
								<div class="col-5">
									<button onclick="pay(${tOrder.id});" type="button" class="btn bnt-sm u-btn-brown btn-pay">付款</button>
									<button onclick="cancelOrder(${tOrder.id})" type="button" class="btn bnt-sm u-btn-brown btn-cancel-order">取消订单</button>
								</div>
		                   </div>
					  </div>
		              </#list>
		              <#else>
			              <div class="z-none">
					         <img src="resource/image/icon-master/order_empty.png"/>
					         <p>暂无任何订单</p>
					      </div>
		              </#if>
				</div><!--/End waitpay_order-->
				
				<!--待收货-->
				<div class="product" id="waitrecieve_order">
					<#if (dshTOrders??)&&(dshTOrders?size>0)>
					<#list dshTOrders as tOrder>
					<div class="product-item">
							<div class="pro-status">
								<div class="float-left">编号：${tOrder.order_id}</div>
								<div class="float-right orderstatus">待收货 </div>
							</div>
										
							<div class="pro-detail-box swiper-container" onclick="orderDetail('${tOrder.id}');">
								<div class="m-pro-detail-list">
									 <#list tOrder.orderProducts as product> 
		                            	 <div class="pro-detail-itm"><img src="${product.save_string!}" onerror="imgLoad(this)"/></div>
		                             </#list>
		                        </div>
							</div>
							
							<div class="row no-gutters justify-content-between align-items-center total-box">
								<div class="col-3 total-num">
									共${tOrder.totalProduct}件商品
								</div>
								<div class="col-4 total-price-box">
									<p class="total-price">合计： <span>&yen; ${(tOrder.need_pay!0)/100}</span></p>		
								</div>
								<div class="col-5">
									<a onclick="$('#hdCancelOrderId').val(${tOrder.id});" class="btn bnt-sm u-btn-brown btn-recede" 
										 data-toggle="modal" data-target="#cancelModal">退货</a>
								</div>
		                   </div>
		              </div>
		              </#list>
		              <#else>
			              <div class="z-none">
					         <img src="resource/image/icon-master/order_empty.png"/>
					         <p>暂无任何订单</p>
					      </div>
		              </#if>
				</div><!--/End waitrecieve_order-->
				
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
												tOrder.order_status=='0'> 已失效 <#else> -- </#if>
									</div>
								</div>
											
								<div class="pro-detail-box swiper-container"  id="pro-${tOrder.id}" onclick="orderDetail('${tOrder.id}');" >
									<div class="m-pro-detail-list">
										<#list tOrder.orderProducts as product>
										 	<div class="pro-detail-itm"><img src="${product.save_string!}" data-pid="${product.id}" onerror="imgLoad(this)"/></div> 
			                            </#list>	
			                        </div>
								</div>
								
								<div class="row no-gutters justify-content-between align-items-center total-box">
									<div class="col-3 total-num">
										共${tOrder.totalProduct}件商品
									</div>
									<div class="col-4 total-price-box">
										<p class="total-price">合计： <span>&yen; ${(tOrder.need_pay!0)/100}</span></p>		
									</div>
									<div class="col-5">
								 		<#if tOrder.order_status=='4'>
											<a onclick="cancleFruit('pro-${tOrder.id}','cancel_order')"  data-toggle="modal" data-target="#returnModal" 
												class="btn bnt-sm u-btn-brown btn-recede">退货</a>
										</#if>
									</div>
			                   </div>
			               </div>
			          </#list>
		              <#else>
			              <div class="z-none">
					         <img src="resource/image/icon-master/order_empty.png"/>
					         <p>暂无任何订单</p>
					      </div>
		              </#if>
				</div><!--/End waitrecieve_order-->
		    </div><!--/End m-list-orders-->
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
			          	<input type="hidden" name="orderId" id="orderId" />
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
		          	<input type="hidden" name="hdCancelOrderId" id="hdCancelOrderId" />
		           	<div class="ui-field-contain">
				        <textarea name="reason" placeholder="200字以内" rows="5" oninput="common.reExpression()"></textarea>
				        <a onclick="hdCancelOrder();" class="hd-recede s-btn-brown">确认</a>
			      	</div>
		      	</form>
	      </div>
	    </div>
	  </div>
	</div>		
	
	<script>
			$(function() {
				 /*tab切换*/
			    var typeBtn = $('.title-list').find(".type");
			    var productBox = $('.product-wrap').find('.product');
			    typeBtn.click(function(){
			        var $this = $(this);
			        var $t = $this.index();
			        typeBtn.removeClass('on');
			        $this.addClass('on');
			        productBox.hide();
			        productBox.eq($t).show();
			    });
			    var type = parseInt("${type}");
			    typeBtn[type].click();
			    
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
			
			//默认checked是为了暂时屏蔽部分退货
			function cancleFruit(domId,typeId){
			    $('.user-fruits').html("");
			    var len=$("#"+typeId+" "+"#"+domId).find('img').length;
			    
			    for(var i=0;i<len;i++){
			         var imgNode=$("#"+domId).find('img').eq(i);         
			         var markup='<li><img src="'+imgNode.attr("src")+'" height="60px" />'+'<span></span>'+
		                        '<input type="checkbox" checked="checked" name="cancel_fruit" value="'+imgNode.data("pid")+'" style="display:none" />'+
		                        '</li>'
		             $('.user-fruits').append(markup);           
			    }
			    
		        $('#orderId').val(domId.replace("pro-",""))
			}
			
			 function back(){
				    window.location.href = "${CONTEXT_PATH}/myself/me";
             }
			 
			 function orderDetail(id) {
					window.location.href = "${CONTEXT_PATH}/myself/userOrderDetail?id="+id;
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
			
			function pay(orderId){
				window.location.href = "${CONTEXT_PATH}/pay/payFruitmasterPayment?id="+orderId;
			}
			
			function imgLoad(element){
				var imgSrc=$(element).height()<80?"resource/image/icon/failed-small.png":"resource/image/icon/failed-big.png"
				$(element).attr("src",imgSrc);
		    }
    </script>
</body>
</html>