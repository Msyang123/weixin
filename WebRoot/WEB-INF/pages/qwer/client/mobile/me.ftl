<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-我的" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl" />
</head>
<body>
	<input type="hidden" id="lat" name="lat" />
	<input type="hidden" id="lng" name="lng" />

	<div id="main" data-role="page" class="me-page">
		<div id="me_person" data-role="main">	
			<div class="top-box">
				<div class="user-info">
					<a class="btn-code" data-position-to="window" href="#myTwoBarCode" data-rel="popup">
 						<img src="resource/image/icon/icon-code.png" width="25px;"/>
 					</a>
				</div>
				<div class="top-info row">
					<div class="col" onclick="myBalance();">
						<p class="top-tittle">鲜果币</p>
						<p class="top-value">${(tUser.balance!0)/100}</p>
					</div>
					<div class="col user-info-box nopd-lr">
						<div class="user-img">
							<img src="${tUser.user_img_id!}" onclick="myDetial();"/>
						</div>
						<p class="user-name">${tUser.nickname!}</p>
					</div>
					<div class="col" onclick="myCoupon();">
						<p class="top-tittle">优惠券</p>
						<p class="top-value">${couponCount!0}</p>
					</div>
				</div>
			</div>
			
			<div class="me-order">
				<div class="me-order-text">
					我的订单
				</div>
				<div class="all-order" onclick="window.location.href='myOrder?type=0'">全部订单 >></div>
			</div>
			
			<div class="user-opreation row">
				<div class="col-4">
					<div onclick="window.location.href='myOrder?type=1'">
						<div class="icon-box">
							<img src="resource/image/icon/icon-payment.png" />
							
						</div>
						<div class="user-opreat">待付款
							<#if (totalOrder.dfk>0)>
								<span class="num-icon">${totalOrder.dfk!0}</span>
							</#if>
						</div>
					</div>
				</div>
				<div class="col-4">
					<div onclick="window.location.href='myOrder?type=2'">
						<div class="icon-box">
							<img src="resource/image/icon/icon-delivery.png" />
						</div>
						<div class="user-opreat">待收货
							<#if (totalOrder.dsh>0)>
								<span class="num-icon">${totalOrder.dsh!0}</span>
							</#if>
						</div>
					</div>
				</div>
				<div class="col-4">
					<div onclick="window.location.href='myOrder?type=3'"> 
						<img height="40px" src="resource/image/icon/icon-recede.png" />
						<div class="user-opreat">退货</div>
					</div>
				</div>
			</div>
			
			<hr/>
			
			<div class="row no-gutters">
				<div class="imgbutton col-4" onclick="myStorage();">
					<img src="resource/image/icon/icon-storage.png" />
					<div class="img_menu">我的仓库</div>
				</div>
				
				<div class="imgbutton col-4 <#if activityId==0>bg-close</#if>" 
					<#if activityId!=0>
						onclick="window.location.href='${CONTEXT_PATH}/activity/seedBuy';"
					</#if>
				>
					<img src="resource/image/icon/icon-seed.png" />
					<div class="img_menu">我的种子</div>
				</div>
				
				<div class="imgbutton col-4" onclick="myPresent();">
					<img src="resource/image/icon/icon-guolaiguowang.png" />
					<div class="img_menu">果来果往</div>
					<#if (myPresent.present_count>0)>
						<div class="present-icon">${myPresent.present_count}</div>
					</#if>
				</div>				
			
				<div class="imgbutton col-4" onclick="nearStore();">
					<img src="resource/image/icon/icon-store.png" />
					<div class="img_menu">附近门店</div>
				</div>
				
				<div class="imgbutton col-4" onclick="faq();">
					<img src="resource/image/icon/icon-help.png" />
					<div class="img_menu">帮助中心</div>
				</div>
				
				<div class="imgbutton col-4" onclick="feedback();">
					<img src="resource/image/icon/icon-feedback.png" />
					<div class="img_menu">反馈中心</div>
				</div>
			</div>
			
		</div>
	
		<div data-role="popup" id="myTwoBarCode" class="ui-content">
			<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
			<img width="200px;"  src="${CONTEXT_PATH}/activityManage/printTwoBarCode?code=${tUser.phone_num!13900000000}"/>
		</div>
		
		<!-- <div data-role="footer" style="height: 20px;"></div> -->
		
	</div>

	<div class="navbar-footer">
		<div class="ui-grid-b">
			<div class="ui-block-a mainmenu" id="mainPage">
				<img id="mainImg" src="${CONTEXT_PATH}/resource/image/icon/icon-index.png" /><br /> <span>首页</span>
			</div>
			<div class="ui-block-b mainmenu" id="cartPage">
				<img id="cartImg" src="${CONTEXT_PATH}/resource/image/icon/shop-cart.png" /><br /> <span>购物车</span>
			</div>
			<div class="ui-block-c mainmenu" id="selfPage">
				<img id="selfImg" src="${CONTEXT_PATH}/resource/image/icon/icon-me-on.png" /><br /> <span class="icon-text">我的</span>
			</div>
		</div>
	</div>

<div id="seed-entry" data-toggle="modal" onclick="getSeed();">
	<img src="resource/image/activity/seedbuy/seed-start.png"/>
</div>

<div id="seed-end">
	<img src="resource/image/activity/seedbuy/seed-end.png"/>
	<div class="countdown-box">
		<p>距离下次发放还有</p>
		<div class="countdown-num" id="countdown-num">
			<span>0</span>
			<span>0</span>
			<span>0</span>
			<span>0</span>
		</div>
		<div class="count-line"></div>
	</div>
</div>

<div class="modal fade" id="get-seed" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog">
        		<div class="modal-content">
		            <div class="col-12">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		            </div>
            	<div class="modal-body text-center">	
            	<p>恭喜您获得</p>

            	<img id="get-seed-img">
            	<p class="seed-kind"></p>

            	<p class="seed-text">您可以通过种子来兑换水果哦~</p>
            	
            	<div class="col-12 text-center">
		        	<button type="button" class="btn-exchange btn-custom" onclick="goSend();">去看看</button>
		        </div>
            	</div>
            
        </div>
    </div>
</div>

	<#include "/WEB-INF/pages/common/share.ftl"/>
	<!--<script src="plugin/weixin/address.js?v={.now?long}"></script>-->
	<script src="plugin/jQuery/json2.js"></script>
	<script src="resource/scripts/seedbuy.js"></script>
	<script type="text/javascript">	
		$(function(){
			$("#mainPage").click(function(){
			  window.location.href = "${CONTEXT_PATH}/main";
			});
		
			$("#cartPage").click(function(){
				window.location.href = "${CONTEXT_PATH}/cart";
			});
			
			wx.ready(function() {
			    wx.getLocation({
				    type: 'wgs84',
				    success: function (res) {
				    	$("#lat").val(res.latitude);
				    	$("#lng").val(res.longitude);
					}	
				});
			});
		});
		
		function myPresent(){
			window.location.href="${CONTEXT_PATH}/myPresent";
		}
		
		function faq(){
			window.location.href="${CONTEXT_PATH}/faq";
		}
		
		function feedback(){
			window.location.href="${CONTEXT_PATH}/feedback";
		}
		
		function myCost(){
			window.location.href="${CONTEXT_PATH}/myCost";
		}
		
		function myStorage(){
			window.location.href="${CONTEXT_PATH}/myStorage";
		}
		
		function myCoupon(){
			window.location.href="${CONTEXT_PATH}/myCoupon";
		}
		
		function present(){
			window.location.href="${CONTEXT_PATH}/present";
		}
		
		function myBalance(){
			window.location.href="${CONTEXT_PATH}/myBalance";
		}
		
		function fuwa(){
			window.location.href="${CONTEXT_PATH}/myFuwa";
		}
		
		function myDetial(){
			window.location.href="${CONTEXT_PATH}/myDetial?init=1";
		}
		
		function nearStore(){
			window.location.href="${CONTEXT_PATH}/store?lat=" + $("#lat").val() + "&lng=" + $("#lng").val();
		}
	</script>
</body>
</html>
