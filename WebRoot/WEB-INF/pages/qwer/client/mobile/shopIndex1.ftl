<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-首页" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<div id="main" data-role="page" class="shop-index bg-white">
		<div data-role="main">
			<div class="d-none">
				<input id="lat" value="28.119658"  type="hidden" />
				<input id="lng" value="113.008950" type="hidden" />
			</div>
			<div class="search_box">
				<a class="search_icon" onclick="goAdr();" id="near_store"  data-ajax="false">
				</a>
				<div class="address_btn" onclick="proSearch();">
					<div class="pull-left pro-txt">${indexSetting.search!'好吃的水果'}</div>
					<div class="pull-right search-txt">搜索</div>
				</div>
			</div>
			
			<!-- Swiper -->
		    <div class="swiper-container index-banner index-shadow">
		        <div class="swiper-wrapper">
		        	<#list mCarousels as item>
		            	<div class="swiper-slide img_content">
							<a href="${item.url!}"  data-ajax="false">
								<img src="${item.save_string!}" alt="${item.id!}" onerror="common.imgLoadMaster(this)" width="100%"/>
							</a>
						</div>
		            </#list>
		        </div>
		        <div class="swiper-button-next"></div>
		        <div class="swiper-button-prev"></div>
		    </div>
			
			<!--商品分类-->
			<div class="play_content maindiv">
				<div class="ui-grid-c">
					<#list tCategorys as category>
						<div style="margin-top:5px;" onclick="goKind('${category.category_id}');" 
							<#if category_index==0>
								class="ui-block-a category"
							
							<#elseif category_index==1>
								class="ui-block-b category"
							<#elseif category_index==2>
								class="ui-block-c category"
							<#elseif category_index==3>
								class="ui-block-d category"		
							</#if>
							>
							<img style="width:55px;" src="${category.save_string!}" />
							<!--屏蔽分类文字-->
							<div class="pro-classes-text">${category.category_name!}</div>
						</div>
					</#list>	
				</div>
			</div>
			
			<!--首页公告展示区域-->
			<#if annoucementActivity.content??>
			<div class="marquee-top row no-gutters justify-content-center" id="notice_area">
			     <div class="marquee-title"></div>
			     <div class="marquee-content col-12 text-left">
				     <ul>
				     <#assign text>
							${annoucementActivity.content!}
					</#assign>			
					<#assign json=text?eval />
				     <#list json.annoucementContent as item>
				        <li><span class="brand-red">【${item.contentType!}】</span>${item.activityContent!}</li>
				     </#list>
				     </ul>
			     </div>
			</div>			
			</#if>
			<!--立马执行superslide 效果最优化-->
			<script>
			    $('.marquee-top').slide({ 
			         mainCell:".marquee-content ul",
			         autoPlay:true,
			         effect:"topLoop",//Marquee
			         vis:1,
			         delayTime:500,
			         //interTime:50,
			         opp:false,
			         pnLoop:true,
			         trigger:"click",
			         mouseOverStop:false
			     });
			</script>
			
			<!--排名或者banner活动-->
			<#if bannerActivitys?? >
				<div class="ui-grid-solo maindiv">
					<#list bannerActivitys as activity>
						<div class="special">
							<a href="${activity.url!}" data-ajax="false"> 
								<img src="${activity.save_string!}" />
							</a>
						</div>
					</#list>		
				</div>
			</#if>
			
			<!--团购banner活动-->
			<#if groupActivity?? >
				<div class="ui-grid-solo maindiv bg-white" style="margin-bottom:19px;">
					<#list groupActivity as activity>
						<div class="special">
							<a href="${activity.url!}" data-ajax="false"> 
								<img src="${activity.save_string!}" onerror="common.imgLoadMaster(this)"/>
								<!--/resource/image/icon/groupBannr.png -->
							</a>
						</div>
					</#list>		
				</div>
			</#if>
			
			<!--优惠券-->
	        <#if couponList?? && (couponList?size>0)>
		        <div id="coupon-entry" class="coupon-box row">
		        	<p class="coupon-tittle">领券时间：${tCouponActivity.yxq_q?string("yyyy年MM月dd日")}-${tCouponActivity.yxq_z?string("yyyy年MM月dd日")}</p>
					<div class="coupon-txt">
						先领券<br/>后购物
					</div>
					<div class="coupon-collapse"></div>
					<#list couponList as coupon>	
						<div class="col-4 coupon-itm 
							<#if coupon.c==0>
								coupon-none
							</#if>" >
							<p class="coupon-price"><span>￥</span>${coupon.coupon_val/100}</p>
							<p class="coupon-desc">${coupon.coupon_desc!}</p>
							<u class="btn-coupon" onclick="getYhq('${coupon.id}','${tCouponActivity.id}');">
								<#if coupon.c==0>
									已抢完
								<#else>
									领取
								</#if>
							</u>
						</div>
					</#list>
		        </div>
			</#if>
			
			<!--热门爆款-->
			<#if weekRecommends?size gt 0>
				<div class="hotPro-box">
					<h3>热门爆款<span onclick="proSearch();">更多</span></h3>
					<p class="tit">果园到舌尖 安全又新鲜</p>
					
					<div class="hotPro-list">
						<#list weekRecommends as weekRecommend>
							<div class="hotPro-itm" onclick="fruitDetial('${weekRecommend.pf_id}');">
								<img src="${weekRecommend.save_string!}" onerror="common.imgLoad(this)"/> 
								<p class="proname">${weekRecommend.product_name!}</p>
								<p class="sell-num">已售${weekRecommend.saleCount!0}件</p>
								<#if weekRecommend.real_price??>
									<p class="proprice">￥${(weekRecommend.real_price!0)/100}/${weekRecommend.unit_name!}<del>￥${(weekRecommend.price!0)/100}</del></p>
								<#else>
									<p class="proprice">￥${(weekRecommend.price!0)/100}/${weekRecommend.unit_name!}</p>
								</#if>
							</div>
					    </#list>
					</div>
				</div>
			</#if>
			
			
			<!--抢购活动-->
			<#if (activitys??)&&(activitys?size>0)>
				<div class="fast-buy bg-white">
					<#list activitys as activity>
						<a
							<#if activity.isInInterval==true >
							 href="${activity.url!}" data-ajax="false" 
							<#else>
							 data-target="#activity${activity.id}" data-toggle="modal"
						    </#if>
						>
							<img src="${activity.save_string!}">		
							<!-- <img src="resource/image/icon/BANNER1.png"> ${activity.save_string!}-->			
						</a>
						
						<div class="modal fade activity-modal" id="activity${activity.id}" tabindex="-1" role="dialog" aria-hidden="true">
						    <div class="modal-dialog">
						        <div class="modal-content">
						            <div class="pr10">
						                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
						            </div>
						            <p>${activity.subheading!}</p>
					            	<a href="${activity.url!}" data-ajax="false">不管，我就要原价购买</a>
						        </div>
						    </div>
						</div>
						
					</#list>
				</div>
			</#if> 
			
			<!--活动商品-->
			<#if (bottomActivitys??)&&(bottomActivitys?size>0)>
			<#list bottomActivitys.bottomActivity as bottomActivity>
				<div class="maindiv activitydiv">
					<div class="ui-grid-solo">
						<div class="ui-block-a">
							<a href='${bottomActivity.url!}'" data-ajax="false">
								<img src="${bottomActivity.imgSrc!}" onerror="common.imgLoadMaster(this)"/>
							</a>
						</div>
					</div>
					<div class="ui-grid-b both-padding mt5">
						<#list bottomActivity.products as product>
							<div 
								<#if product_index%3==0>
									class="ui-block-a"
								<#elseif product_index%3==1>
									class="ui-block-b"
								<#elseif product_index%3==2>
									class="ui-block-c"
								</#if>
							>
								<div onclick="fruitDetial('${product.pf_id!}');" class="index-pro">
									<img src="resource/image/icon/blank.gif" data-echo="${product.save_string!}" onerror="common.imgLoad(this)"/> 
										<p class="proname">${product.product_name!}</p>
										<p class="sell-num">已售${product.saleCount!0}件</p>
										<#if product.real_price??>
											<p class="proprice">￥${(product.real_price!0)/100}/${product.unit_name!}<del>￥${(product.price!0)/100}</del></p>
										<#else>
											<p class="proprice">￥${(product.price!0)/100}/${product.unit_name!}</p>
										</#if>
								</div>
							</div>
						</#list>
					</div>
				</div>
			</#list>	
			</#if>
		<div style="width:100%;margin-bottom:60px;">
			<img style="width:100%;" src="resource/image/icon/bottom-img.jpg" />
		</div>
</div>
<div class="navbar-footer">
   <div class="ui-grid-b">
		<div class="ui-block-a mainmenu" id="mainPage">
			<img id="mainImg" src="${CONTEXT_PATH}/resource/image/icon/icon-index-on.png" /><br /> <span class="icon-text">首页</span>
		</div>
		<div class="ui-block-b mainmenu" id="cartPage">
			<img id="cartImg" src="${CONTEXT_PATH}/resource/image/icon/shop-cart.png" /><br /> <span>购物车</span>
		</div>
		<div class="ui-block-c mainmenu" id="selfPage">
			<img id="selfImg" src="${CONTEXT_PATH}/resource/image/icon/icon-me.png" /><br /> <span>我的</span>
			</div>
		</div>
	</div>
</div>

<div id="seed-entry" data-toggle="modal" onclick="getSeed();">
	<img src="resource/image/activity/seedbuy/seed-start.png"/>
</div>

<div id="seed-end">
	<img src="resource/image/activity/seedbuy/seed-end.png"/>
	<div class="countdown-box">
		<p>距离下次发放倒计时</p>
		<div class="countdown-num" id="countdown-num">
			<span>0</span>
			<span>0</span>
			<b style="color:#FFB808;vertical-align:super;">:</b>
			<span>0</span>
			<span>0</span>
		</div>
		<div class="count-line"></div>
	</div>
</div>

<div class="modal fade" id="get-seed" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="pr10">
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

<div id="loading-mask">
	<img src="resource/image/icon/loading.gif">
	<p class="mt10">定位中，请等待</p> 
</div>

<div id="back_top">
	<img src="resource/image/icon/back-to-top.png"/>
</div>

<#include "/WEB-INF/pages/common/share.ftl"/>
<script src="plugin/jQuery/json2.js"></script>
<script src="resource/scripts/seedbuy.js"></script>
<script src="plugin/common/productDetial.js"></script>
<script src="plugin/common/echo.min.js"></script>
<script data-main="scripts/main" src="resource/scripts/vconsole.min.js"></script>
<script>
	$(function() {
	    $("#coupon-entry").on("click", function (event) {
	        $(this).animate({marginLeft:0},800);
			$(".coupon-txt").hide();
			$(".coupon-collapse").show();
			$(".coupon-itm").show();
	    });
		
	    //点击除优惠券本身外关闭优惠券
	    /* $(document).bind('click', function(e) {  
            var e = e || window.event; //浏览器兼容性   
            var elem = e.target || e.srcElement;  
            while (elem) { //循环判断至跟节点，防止点击的是div子元素   
                if (elem.id && elem.id == 'coupon-entry') {  
                    return;  
                }  
                elem = elem.parentNode;  
            }  
            closeCoupon();
        });  */
        
	    $(".coupon-collapse").on('click','',function(e){
	    	 $("#coupon-entry").animate({marginLeft:'80%'},800);
	    	 $(".coupon-txt").show();
	    	 $(".coupon-itm").hide();
	    	 $(".coupon-collapse").hide();
	    	 e.stopPropagation();
		});
	   
	    //优惠券拖拽
	    var cont=$("#coupon-entry");    
	    var contH=$("#coupon-entry").height();          
	    var startY,sY,moveY,disY;        
	    var winH=$(window).height();
	    cont.on({//绑定事件
	        touchstart:function(e){             
	            startY = e.originalEvent.targetTouches[0].pageY;    //获取点击点的Y坐标
	            sY=$(this).offset().top;//相对于当前窗口Y轴的偏移量
	            topY=startY-sY;//鼠标所能移动最上端是当前鼠标距div上边距的位置
	            bottomY=winH-contH+topY;//鼠标所能移动最下端是当前窗口距离减去鼠标距div最下端位置             
	            },
	        touchmove:function(e){              
	            e.preventDefault();
	            moveY=e.originalEvent.targetTouches[0].pageY;//移动过程中Y轴的坐标
	            if(moveY<topY){moveY=topY;}
	            if(moveY>bottomY){moveY=bottomY;}
	            $(this).css({
	                "top":moveY+sY-startY,                  
	            });
	        },
	        mousedown: function(ev){
	            var patch = parseInt($(this).css("height"))/2;
	            $(this).mousemove(function(ev){
	                var oEvent = ev || event;
	                var oY = oEvent.clientY;
	                var t = oY - patch;
	                var h = $(window).height() - $(this).height();
	                if(t<0){t = 0}
	                if(t>h){t=h}
	                $(this).css({top:t})
	            });
	            $(this).mouseup(function(){
	                $(this).unbind('mousemove');
	            });
	        }
	    });
	    
	    //轮播图
		var swiper = new Swiper('.swiper-container', {
	        pagination: '.swiper-pagination',
	        paginationClickable: '.swiper-pagination',
	        nextButton: '.swiper-button-next',
	        prevButton: '.swiper-button-prev',
	        spaceBetween: 30,
	        autoplay: 5000,//可选选项，自动滑动
	        autoplayDisableOnInteraction : false,
	        loop : true,
		});
		
		$("#cartPage").click(function(){
			  window.location.href = "${CONTEXT_PATH}/cart";
		});
		
		$("#selfPage").click(function(){
			  window.location.href = "${CONTEXT_PATH}/me";
		});
		//延迟加载图片初始化
		echo.init();
		
		//如果用户是重新进入微商城，则会把门店信息的cookie清除，重新定位
		if($.cookie('storeInfo')==null){
			wx.ready(function() {
				wx.getLocation({
				    type: 'wgs84',
				    success: function (res) {
				    	$("#lat").val(res.latitude);
						$("#lng").val(res.longitude);
						var oLat = res.latitude; 
				    	var oLng = res.longitude;
						$.ajax({
				            type: "POST",
				            url: "${CONTEXT_PATH}/storeList",
				            data:{lat:oLat,lng:oLng,flag:1},
				            dataType: "json",
				            success: function(data){
				            	if(data){
				            		var storeId = data[0].store_id;
				            		var storeName = data[0].store_name;
				            		$("#near_store").html(storeName);
				            		//当前位置的store_id,用于查询库存
				            		$.cookie('store_id',storeId,{expires:15,path:'/'});
				            		
				            		//将当前位置的门店信息存储
				            		var storeInfo = '{"storeLat":"'+oLat+'","storeLng":"'+oLng+'","storeName":"'+data[0].store_name+'"}';
				            		$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
				            	}
				            }
			        	});
						$("#loading-mask").hide();
					},
					//若定位失败或者是用户取消了定位 则默认为红星旗舰店
					fail: function (err) {
						var storeId = '07310109';
						$("#loading-mask").hide();
						$("#near_store").html("红星旗舰店");
						var storeInfo = '{"storeLat":"'+$("#lat").val()+'","storeLng":"'+$("#lng").val()+'","storeName":"'+$("#near_store").html()+'"}';
						
						$.cookie('store_id',storeId,{expires:15,path:'/'});
	            		$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
						$.dialog.alert("请允许访问您的位置 ");
				    },
				    cancel: function (res) {
				    	var storeId = '07310109';
						$("#loading-mask").hide();
						$("#near_store").html("红星旗舰店");
						var storeInfo = '{"storeLat":"'+$("#lat").val()+'","storeLng":"'+$("#lng").val()+'","storeName":"'+$("#near_store").html()+'"}';
						
						$.cookie('store_id',storeId,{expires:15,path:'/'});
						$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
						$.dialog.alert("请允许访问您的位置");
				    },
				    complete:function(info){
				    	$("#loading-mask").hide();
				    }
				});
			});
		//用户选择了收货地址后 直接去cookie中读取收货信息（经纬度 ）
		}else{
			var storeInfoJson=JSON.parse($.cookie('storeInfo'));
			var storeName = storeInfoJson.storeName;
			$("#near_store").html(storeName);
			if($.cookie('adrStoreInfo')==null){
				$("#loading-mask").hide();
				$("#lat").val(storeInfoJson.storeLat);
				$("#lng").val(storeInfoJson.storeLng);
			}else{
				$("#loading-mask").hide();
				var adrStoreInfoJson=JSON.parse($.cookie('adrStoreInfo'));
				$("#lat").val(adrStoreInfoJson.storeLat);
				$("#lng").val(adrStoreInfoJson.storeLng);
			}
		}
		
		//回到顶部
		$(window).scroll(function(){
            if ($(window).scrollTop()>400){
                $("#back_top").fadeIn(1000);
            } else {
                $("#back_top").fadeOut(1000);
            }
        });
        
        $("#back_top").click(function(){
            $('body,html').animate({scrollTop:0},1000);
        });
	});
			
	function goKind(kind){ 
		window.location.href = "${CONTEXT_PATH}/fruitKind?id="+kind;
	}
	
	function proSearch(){
		window.location.href = "${CONTEXT_PATH}/search";
	}
	function goAdr(){
		window.location.href="${CONTEXT_PATH}/initStoreList?lat=" + $("#lat").val() + "&lng=" + $("#lng").val();
	}
		
	//领优惠券
	function getYhq(coupon_category_id,activityId){
	    $.ajax({ 
			url: "${CONTEXT_PATH}/activity/getYhq", 
			data: {coupon_category_id:coupon_category_id,activityId:activityId}, 
			success: function(data){
				if(data.errcode==0){
					$.dialog.alert("领取成功");
				}else{
					$.dialog.alert(data.errmsg);
				}	
	      	}
		});
	}
</script>
</body>
</html>