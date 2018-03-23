<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-果来果往" />	
	<meta content="telephone=no" name="format-detection" />
	<link rel="stylesheet" href="plugin/tab/tab-2.css" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="my-present bg-white">
	    <div class="mask"></div>
		<div data-role="main">
			<div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<div>果来果往</div>
			</div>
			
			<div class="tab">
				<div class="title cf">
					<ul class="title-list fl cf">
						<li class="on">我收到的</li>
						<li>我赠送的</li>
						<p></p>
					</ul>
				</div>
				
				<div class="product-wrap">
					<!--我收到的-->
					<div class="product show">			
						<#if (targetPresents??)&&(targetPresents?size>0)>
					
							<#list targetPresents as tPresent>
							<div class="product-item">
								<#if tPresent.present_status='4'>
								<div class="row no-gutters justify-content-around present-name">
									<div class="col-9 text-left pl10">赠送人：${tPresent.present_username}</div>
									<div class="col-3 text-right time pr10">${tPresent.present_time?substring(0,10)}</div>
								</div>
								<div class="go-pro swiper-container0" onclick="presentDetail('${tPresent.id}','target');" >
									<div class="swiper-wrapper">
										<#list tPresent.presentProducts as product>					  
									         <div class="swiper-slide"><img  width="60" height="60" src="${product.save_string!}" 
									         onclick="fruitDetial('${product.id}');" onerror="imgLoad(this)"/></div>
		                                </#list>
	                                    <div class="swiper-scrollbar0"></div>
	                                </div>
								</div>
								<div class="row no-gutters justify-content-around present-name total-money">
								    <div class="col-4 text-left pl10">共${tPresent.totalProduct}件商品</div>
									<div class="col-8 text-right time pr10">
									        价值：<span class="sum">￥${(tPresent.need_pay!0)/100}</span>
									</div>
								</div>
								<#else>
								<div onclick="openRecieve('${tPresent.id}','${tPresent.totalProduct}');" class="open-recieve"></div>
							    <!-- 点击查收的贺卡 -->
								<div class="recievePresent" id="recievePresent${tPresent.id}" >
									<div class="close-recieve" onclick="closeRecieve('${tPresent.id}');"></div>
									<div class="presentUser" id="presentUser${tPresent.id}">${tPresent.present_username!}</div>
									<div class="presentProDiv" id="presentProDiv${tPresent.id}">
										<#list tPresent.presentProducts as product>
										<div class="off">${product.product_name!}   *${product.amount!}   ${product.base_unitname!}</div>
										</#list>
									</div>
								<div class="presentMsg" id="presentMsg${tPresent.id}">
								      ${tPresent.present_msg!}
								</div>
					            <div class="recieveCmt" id="recieveCmt${tPresent.id}" onclick="recieveConfirm('${tPresent.id}');"></div>
				                </div>
							    </#if>
					        </div>
							</#list>			           
						<#else>
						<div class="empty-present">
							<img height="150px" src="resource/image/icon/wsdd_empty.png" /><br/>
							再可爱一点，是不是礼物就到了？
						</div>
						</#if>
					</div>
					
					<!--我赠送的-->
					<div class="product">
						<#if (sourcePresents??)&&(sourcePresents?size>0)>
						
							<#list sourcePresents as tPresent>
                            <div class="product-item">
									<div class="present-name">
										<div class="float-left">接收好友：${tPresent.present_username!}</div>
										<div class="float-right orderstatus">
											<#if tPresent.present_status=='1'> 待付款 <#elseif
												tPresent.present_status=='2'> 支付中
											 <#elseif
												tPresent.present_status=='3'> 赠送完成
												<#elseif
												tPresent.present_status=='4'> 赠送完成
												<#elseif
												tPresent.present_status=='0'> 已失效
											<#else> -- </#if>
										</div>
									</div>
									<div class="go-pro swiper-container1" onclick="presentDetail('${tPresent.id}','source');" >
									    <div class="swiper-wrapper">
											<#list tPresent.presentProducts as product>
											   <div class="swiper-slide"><img  width="60" height="60" src="${product.save_string!}" 
											   onerror="imgLoad(this)"/></div>
	                                        </#list>
	                                        <div class="swiper-scrollbar1"></div>
	                                    </div>
									</div>
									<div class="total-money">
										<div class="float-left">${tPresent.present_time!}</div>
										<div class="float-right">
											共${tPresent.totalProduct!}件商品&nbsp;
											合计： <span class="sum">￥${(tPresent.need_pay!0)/100}</span>
										</div>
									</div>
									<#if tPresent.present_status=='1'>
									<div class="row no-gutters justify-content-end order-opreation">
									    <div class="col-3 mr10">
											<button type="button" onclick="cancelPresent(${tPresent.id})" class="btn-white">取消订单</button>
										</div>
									    <div class="col-3 mr10">
											<button type="button" onclick="pay(${tPresent.id});" class="btn-custom">付款</button>
									    </div>				    
							        </div>
									</#if>								
							</div>
							</#list>
						
						<#else>
							<div class="miss-box">
							<img height="150px" src="resource/image/icon/wzsd_empty.png" /><br/>
								想TA了吗，给TA<a onclick="window.location.href='${CONTEXT_PATH}/present'">赠送</a>一份礼物吧
							</div>
						</#if>
						
					</div>
				</div><!--/End product-wrap -->
			</div><!--/End tab -->

		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/productDetial.js"></script>
	<script src="plugin/tab/tab.js"></script>
	<script charset="utf-8">
		var t = n = 0;    
		$(function(){		
		 var swiper = new Swiper('.swiper-container0', {
			    scrollbar: '.swiper-scrollbar0',
		        scrollbarHide: true,
		        slidesPerView: 4,
		        slidesPerGroup:4,
		        centeredSlides: false,
		        spaceBetween: 10,
		        grabCursor: true,
		        setWrapperSize :false,
		        breakpoints: { 
				    //当宽度小于等于320
				    320: {
				      slidesPerView: 4,
				      slidesPerGroup:4,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于376
				    375: { 
				      slidesPerView: 5,
				      slidesPerGroup:5,
				      spaceBetweenSlides: 15
				    },
				   //当宽度小于等于415
				    414: { 
				      slidesPerView: 6,
				      slidesPerGroup:6,
				      spaceBetweenSlides: 10
				    },
				     //当宽度小于等于415
				    480: { 
				      slidesPerView: 7,
				      slidesPerGroup:7,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于640
				    640: {
				      slidesPerView: 8,
				      slidesPerGroup:8,
				      spaceBetweenSlides: 20
			        }
			     }
		    });			       
			$(".recievePresent").css("left",(window.screen.width-300)/2+"px");
			
		});
		
		function imgLoad(element){
				var imgSrc=$(element).height()<80?"resource/image/icon/failed-small.png":"resource/image/icon/failed-big.png"
				$(element).attr("src",imgSrc);
	    }
		
		function back() {
			window.location.href = "${CONTEXT_PATH}/me";
		}
	
		function presentDetail(id,type) {
			window.location.href = "${CONTEXT_PATH}/pay/presentDetail?id="+id+"&type="+type;
		}
		
		function cancelPresent(presentId){
			$.dialog.message("确认取消订单吗？",true,function(){
				$.ajax({
		            type: "POST",
		            url: "${CONTEXT_PATH}/cancelPresent",
		            data: {presentId:presentId},
		            dataType: "json",
		            success: function(data){
		            	if(data.result=="success"){
		            		window.location.href = "${CONTEXT_PATH}/myPresent";
		            	}else{
		            		alert(data.msg);
		            	}
		            }
		        });
			});
		}
		
		function pay(presentId){
			window.location.href = "${CONTEXT_PATH}/pay/sbmtPresent?present_id="+presentId;
		}
		
		function closeRecieve(presentId){
			clearInterval(t);
			$('.mask').hide();
			$('#recievePresent'+presentId).hide();
		}
		
		function openRecieve(presentId,proNum){
			n=0;
			$('.mask').show();
			$('#recievePresent'+presentId).show();
			$("#presentProDiv"+presentId+" div:first").removeClass("off").addClass("on");
			t = setInterval(function() {
				presentRoll(presentId,proNum);
			}, 3000);
		}
		
		function presentRoll(presentId,proNum){
			var num = parseInt(proNum);
			if(n>num-1){
				n=0;
			}
			$("#presentProDiv"+presentId+" div").filter(":visible").hide().parent()
			.children().eq(n).slideDown(2000);
			n++;
		}
		
		function recieveConfirm(presentId){
			$.ajax({
	            type: "POST",
	            url: "${CONTEXT_PATH}/recievePresent",
	            data: {presentId:presentId},
	            dataType: "json",
	            success: function(data){
	           		if(data.result=="success"){
	           			window.location.href="${CONTEXT_PATH}/myPresent";
	           		}else{
	           			alert(data.msg);
	           		}
	           }
	       });
		}
	</script>
</body>