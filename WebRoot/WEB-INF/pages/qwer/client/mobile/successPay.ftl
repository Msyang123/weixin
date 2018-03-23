<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-支付成功" />
<link type="text/css" rel="stylesheet" href="plugin/goldCoin/css/animator.css" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="success-pay bg-white">
		<div data-role="main">
            <div class="tips marquee">请您在72小时内完成提货，超出时间将自动取消该订单，按实际支付金额转成等价的鲜果币</div>
            
			<div class="success-icon">
		        <img height="100px" src="resource/image/icon/pay-success.png"/>
			    <h3>支付成功</h3>
			</div>			
			
			<#if bonus??>
				<div id="scratch">
					<div id="card">${bonus}鲜果币！</div>
				</div>
				
				<!--<div class="item1">
					<div class="kodai">
						<div id="html">获得${bonus}元果币红包</div>
						<img src="resource/image/icon/goldCoin/kd2.png" class="full" />
						<img src="resource/image/icon/goldCoin/kd1.png" class="empty" />
					</div>
					<div class="clipped-box"></div>
				</div>
				-->
			<#elseif aFuwa??>
				<script type="text/javascript">
					$(function(){
						$("#fw").show();
					});			
				</script>		
			</#if>

            <!--到时判断下隐藏掉-->
            <#if seed??&&seed.seedCount gt 0 >
	            <div class="complete-box">
	                 <h5 class="brand-red">恭喜获得${seed.seedType.seed_name}共${seed.seedCount}个</h5>
	                 <p>您可以通过种子来兑换水果</p>
	                 <button type="button" data-role="button" class="btn-custom" id="btn_seed">去看看</button>
	            </div>
            </#if>
            
            <!--<div class="text-center mt5">分享购物心得到朋友圈<br/>将获得鲜果币哦~</div>
            <div class="share-area">
			    <div class="col-12"><button type="button" class="btn-exchange btn-custom go-share">马上分享</button></div>
			</div> btn-white-->
			
			<div class="complete-box">		    
				<button type="button" data-role="button" class="btn-custom"
					<#if (session['wxUser'].subscribe)?? &&(session['wxUser'].subscribe==0)>
						data-toggle="modal" data-target="#myPopup" 
					<#else>
					onclick="back();" 	
				    </#if>
				>完成</button>
			</div>
			
			<#if userCoupon??>
				<div class="complete-box">	
					<h3 class="brand-red mb8">恭喜您获得${getCouponNum.count}张优惠券!</h3>
					<p class="brand-red f15 s-line" onclick="window.location.href='${CONTEXT_PATH}/myCoupon';">查看我的优惠券</p>
				</div>
			</#if>

			<div class="modal fade" id="myPopup" tabindex="-1" role="dialog" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="pr10">
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none" style="font-size:2.4rem;">&times;</button>
			            </div>
			            <div class="modal-body text-center">
			              <img class="codeImg" src="resource/image/qrcode/qrcode_for_gh_344.jpg">
			              <p>长按二维码，关注水果熟了公众号<br/>实时关注您的拼团信息。</p>
			            </div>
			        </div>
			    </div>
		    </div>
			
		</div>
		
		<#if aFuwa??>
			<div id="fw">
				<img id="fwBackground" src="resource/image/activity/guowa/kapianfengmian.png">
			      <div id="fwCard" style="display:none;">
			      	<img style="width:100%;" src="${aFuwa.save_string!}">
			      	<div class="award-text">
			      	恭喜您获得<span>${aFuwa.fw_name!}</span>
			      	</div>
			      </div>
			</div>
			<script type="text/javascript">
		     $(function(){
               		$("#fwBackground").bind("click",function(){
						$("#fwBackground").hide();
						$("#fwCard").fadeIn(2000);
						setTimeout(function(){
							$("#fwCard").hide();
						},5000);
					});
					
					$("#fwCard").bind("click",function(){
						$("#fwCard").hide();
					});
			 });			
			</script>
		</#if>	 

	</div>
	<!--分享屏蔽层-->
	<div class="shade">
            <i class="icon">
                <img src="resource/image/icon/arrows-share.png" />
            </i>
            <p>快去你的伙伴圈炫耀下吧~</p>
            <p>
           	    点击右上角   <span class="share">•••</span>
            </p>
            <div class="close_box">
                <a class="close_btn">知道啦</a>
            </div>
    </div>
    <!--分享成功-->
    <div class="modal fade" id="share-succeed" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <div class="modal-body text-center">
	                <img src="resource/image/icon/guobi.png" width="30%"/>
	            	<p id="share-succeed-msg"></p>
	            </div>
	        </div>
	    </div>
    </div>
	
	<#if first_order_present??>
    <!--首次下单成功  送货上门-->
    <div class="modal fade" id="first-succeed" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <div class="modal-body text-center">
	                <img src="resource/image/icon/guobi.png" width="30%"/>
	                <p id="first-succeed-msg">首单有礼，恭喜您获得了${first_order_present?default("0")}个鲜果币</p>
	            	<div class="text-center brand-red mt5">Tip: 鲜果币可用于购买微商城内商品，1鲜果币=1元</div>
	            </div>
	        </div>
	    </div>
    </div>

    <!--首次下单成功  门店自提-->
	<div class="modal fade" id="frist_buy" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
			<div class="modal-content">
	            <div class="col-12 close-btn">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	            </div>
	            <div class="modal-body text-center">
	                <img src="resource/image/icon/guobi.png" width="30%"/>
	                <p id="first-succeed-msg">首单有礼，恭喜您获得了${first_order_present?default("0")}个鲜果币</p>
					<p>请凭订单编号到门店领取</p>
					<a href="myOrder?type=0&deliverytype=2" data-ajax="false">查看订单</a>
					<div class="text-center brand-red mt5">Tip: 鲜果币可用于购买微商城内商品，1鲜果币=1元</div>
				</div>
	    </div>
	</div>
    </#if>	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="//cdn.jsdelivr.net/jquery.marquee/1.4.0/jquery.marquee.min.js"></script><!--跑马灯效果-->
	<script src="plugin/jQuery/json2.js"></script>
	<script src="plugin/common/productDetial.js"></script>
	<script src="plugin/goldCoin/js/script.js"></script>
	<script src="resource/scripts/lucky-card.js"></script>
	<script type="text/javascript">
		function back(){
			window.location.href="${CONTEXT_PATH}/main";
		}
		
		//分享后获取鲜果币
	 	function getCoin(orderId){
	 		$.ajax({ 
				url: "${CONTEXT_PATH}/getCoinByShare", 
				data: {'orderId':orderId}, 
				success: function(data){
					if(data.result=='success'){
						$("#share-succeed").modal('show');
						$("#share-succeed-msg").html("恭喜获得"+data.coinCount+"个鲜果币");
					}else{
						$.dialog.alert(data.msg);
					}	
		      	}
			});
	 	}
	 	
		$(function(){
		    //实例化跑马灯
			$('.marquee').marquee({
				duration: 8000,
				gap: 60,
				delayBeforeStart: 1,
				direction: 'left',
				duplicated: true
			});
			
			<#if isUserFirstBuy?? && deliverytype=='1'>
			      //继续判断订单类型,显示不同的弹出框
				  $("#frist_buy").modal('show');
			<#else>
				  $("#first-succeed").modal('show');	
			</#if>
			
		    $('#btn_seed').on("click",function(){
			    window.location.href="${CONTEXT_PATH}/activity/seedBuy";
			});
			<#if bonus??>
			//先隐藏2秒钟
					LuckyCard.case({
						//coverColor:'#CCCCCC',
						coverImg:'${CONTEXT_PATH}/resource/image/activity/luckycard/guajiang.png',
						ratio: .5
					}, function() {
						$.dialog.alert("恭喜您！获得${bonus}鲜果币");
						this.clearCover();
					});
					$("#card").hide();
				    setTimeout(function () {
				      $("#card").show();
				    }, 1000);
					/*ratio:触发回调函数时刮开面积占总面积的比例*/
					/* 刮开后可以是一张图片：LuckyCard.case({coverImg:'./demo.jpg'});*/
			</#if>
			$(".code").on('touchstart', '.codeImg', function(e){  
			    e.stopPropagation();  
			    time = setTimeout(function(){  
			        $.ajax({ 
						url: "${CONTEXT_PATH}/clear", 
						data: {}, 
						success: function(data){
				      	}
					});
			    }, 500);//这里设置长按响应时间  
			});
			
			//分享得鲜果币
			//分享引导层
			$(".go-share").click(function(){
	 	 		$(".shade").css("display","block");
	 	 	})
	        $(document).on("touchmove",function(e) {
	            if($(".shade").css("display")==='block') {
	                e.preventDefault();
	            }
	        });
	        $(".close_btn").click(function(){
	            $(".shade").css("display","none");
	        });                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
		});
		
		//微信分享js
		wx.ready(function() {
			var link='${app_domain}/main';
			var imgUrl='${app_domain}/resource/image/logo/shuiguoshullogo.png';
			//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
			wx.onMenuShareTimeline({
			    title: '水果狂欢季，购物有惊喜--喜欢吃水果的你还在等什么呢~', // 分享标题
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () {
			        // 用户确认分享后执行的回调函数
			        //getCoin('${orderId!}');
			        $(".shade").css("display","none");
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			        //alert('取消分享到朋友圈');
			    }
			});
			
			//获取“分享到QQ”按钮点击状态及自定义分享内容接口
			wx.onMenuShareQQ({
			    title: '水果狂欢季，购物有惊喜', // 分享标题
			    desc: '喜欢吃水果的你还在等什么呢~', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () { 
			        //getCoin('${orderId!}');
			    },
			    cancel: function () { 
			       // 用户取消分享后执行的回调函数
			    }
			});
			//分享给朋友
			wx.onMenuShareAppMessage({
			    title: '水果狂欢季，购物有惊喜', // 分享标题
			    desc: '喜欢吃水果的你还在等什么呢~', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () {
			        // 用户确认分享后执行的回调函数
			    },
			    cancel: function () {
			        // 用户取消分享后执行的回调函数
			    }
			});
			//获取“分享到腾讯微博”按钮点击状态及自定义分享内容接口
			
			wx.onMenuShareWeibo({
			    title: '水果狂欢季，购物有惊喜', // 分享标题
			    desc: '喜欢吃水果的你还在等什么呢~', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () { 
			         //getCoin('${orderId!}');
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			    }
			});
			
			//获取“分享到QQ空间”按钮点击状态及自定义分享内容接口
			wx.onMenuShareQZone({
			    title: '水果狂欢季，购物有惊喜', // 分享标题
			    desc: '喜欢吃水果的你还在等什么呢~', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () { 
			         //getCoin('${orderId!}');
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			    }
			});
		});
</script>
</body>
</html>