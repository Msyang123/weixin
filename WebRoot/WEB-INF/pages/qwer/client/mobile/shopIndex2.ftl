<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
<meta name="description" content="水果熟了-首页" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
<style>
html{
    font-size: 62.5%;
}

@media screen and (max-width:340px){
    html{
        font-size: 50%;
    }
}

@media screen and (min-width:600px){
    html{
        font-size: 150%;
    }
}
body, h1, h2, h3, h4, h5, h6, p, ul, li, dl, dt, dd {
	padding: 0;
	margin: 0;
	font-size: 12px;
	font-family: 方正兰亭黑;
	word-break: break-all;
	word-wrap: break-word;
}
.ui-content{
	background-color:#ffffff!important;
}
li {
	list-style: none;
}

img {
	border: none;
}

em {
	font-style: normal;
}

a {
	color: #555;
	text-decoration: none;
	outline: none;
	blr: this.onFocus=this.blur();
}

a:hover {
	color: #000;
	text-decoration: underline;
}

.clear {
	height: 0;
	overflow: hidden;
	clear: both;
}

.play_content {
	padding: 0px;
	overflow: hidden;
	margin: auto;
}

.play {
	
	text-align: center;
	margin: auto;
	overflow: hidden;
}

.textbg {
	margin-top: 200px;
	z-index: 1;
	filter: alpha(opacity = 40);
	opacity: 0.4;
	width: 100%;
	height: 30px;
	position: absolute;
	background: #000;
}

.text {
	margin-top: 200px;
	z-index: 2;
	padding-left: 10px;
	font-size: 14px;
	font-weight: bold;
	width: 40%;
	color: #fff;
	line-height: 30px;
	overflow: hidden;
	position: absolute;
	cursor: pointer;
}


.ui-grid-solo img {
	width: 100%;
}

.bottom_menu {
	width: 33.33%;
	background-color: #EEEDED;
	height: 100%;
	float: left;
	text-align: center;
	padding-top: 32px;
	color: white;
	font-size: 18px;
	font-family: 微软雅黑;
}

.special {
	margin-top: 5px;
}

.proImage {
	width: 100%;
	height: 100%;
}

img {
	width: 100%;
	height: 100%;
}

.proname {
	font-family: 微软雅黑;
	color: black;
	font-size: 14px;
}

.proprice {
	color: orange;
	font-size: 13px;
}

.maindiv {
	background-color: white;
}

.prodiv {
	padding: 11px;
}

.maintop {
	width: 100%;
	height:40px;
	line-height:40px;
	font-size: 18px;
	color:#333333;
	background-color:#ffffff;
}

.category {
	padding: 10px;
}

.mainmenu{
	padding-top:8px;
	letter-spacing: 2px;
}
.mainmenu span{
	maigin-top:5px;
	font-size:12px;
}

.mainmenu img{
	width:30px;
	height:30px;
}
.hot_line{
    width: 100%;
    margin-top: 10px;
    text-align: center;
}
.hot_line>p:first-child{
    color: #666666;
    font-weight: bold;
    font-size: 2.4rem;
    margin-bottom: 0.5rem;
}
.hot_line>p{
    color: #666666;
    font-size: 1.4rem;
    margin: 0;
}
.hot_pro{
    margin-top: 20px;
    text-align: center;
}
.pro_name{
    font-size: 1.6rem;
    color: #666666;
    margin: 5px 0;
}
.pro_price{
    font-weight: bold;
    font-size: 2.2rem;
    color: #FE0000;
    margin: 0 0 5px 0;
}
.pro_price>span{
    font-size: 1.6rem;
}
.guess_name{
    font-size: 1.4rem;
    color: #666666;
    margin: 5px 0;
}
.guess_price{
    font-weight: bold;
    font-size: 2rem;
    color: #FE0000;
    margin: 0;
}
.guess_price>span{
    font-size: 1.4rem;
}
 /*优惠券*/
        .coupon_tittle{
            width: 100%;
            text-align: center;
            margin-bottom: 10px;
        }
        .coupon_tittle>p{
            color: #666666;
            font-size: 1.4rem;
        }
        .coupon_tittle>p:first-child{
            font-size: 2.2rem;
            font-weight: bold;
        }
        .coupon_box{
            position: relative;
            overflow: hidden;
        }
        .coupon{
            background-color: #FE0000;
            padding: 5px;
            margin-left: 5px;
        }
        .coupon_price{
            color: white;
            font-size: 1.2rem;
            position: relative;
        }
        .coupon_icon{
            position: absolute;
            top: 0;
            left:0;
        }
        .coupon_num{
            font-size: 4rem;
            margin-right: 0.6rem;
        }
        .coupon_price>i{
            display: inline-block;
            width: 2rem;
            height: 2rem;
            border-radius: 1rem;
            background-color: white;
            color: #FE0000;
            line-height: 2rem;
            position: absolute;
            right: 0;
            top:0;
        }
        .coupon_info{
            font-size: 1.4rem;
            color: white;
        }

        /*遮罩层*/
        .coupon_none{
            width: 100%;
            height: 100%;
            background:rgba(0, 0,0, 0.7) none repeat scroll 0 0 !important;
            filter: alpha(opacity=70);
            opacity: 0.6;
            z-index:1;
            left: 0;
            top: 0;
            position: absolute;
            box-sizing: border-box;
            color: white;
            font-size:1.6rem;
            text-align: center;
            padding-top: 26px;
            margin-left: 5px;
        }
</style>
</head>
<body>
<div id="main" data-role="page" style="background-color: #f5f5f5;font-family:微软雅黑;color:#333333;">

		<!-- 
  <div data-role="header">
  	<div style="height:20px;"></div>
  </div> -->
		<div data-role="main">
			<div style="position: fixed;left:10%;align:center; z-index: 9999;width: 80%">
				<a class="ui-btn ui-icon-search ui-btn-icon-right" onclick="proSearch();"
					style="background-color: rgba(255,255,255,0.6);height:12px;border-radius:5px;border:0px solid white;">
				</a>
			</div>
			<div class="play maindiv">
				<div  id="pre" style="position:absolute;top:100px;left:5px;">
					<img style="width:30px;" src="resource/image/icon/左箭头.png" />
				</div>
				<div id="next" style="position:absolute;top:100px;right:5px;">
					<img style="width:30px;" src="resource/image/icon/右箭头.png" />
				</div>
				<ul>
					<li class="img_content">
						<#list mCarousels as item>
						<a href="${item.url!}"  data-ajax="false"><img
							src="${item.save_string!}" alt="${item.id!}" /></a>
						</#list>	
					</li>
				</ul>
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
							<div style="margin-top:5px;">${category.category_name!}</div>
							
						</div>
					</#list>	
				</div>
			</div>
			<!--优惠券-->
	        
	        <#if couponList?? && (couponList?size>0)>
		        <div class="ui-content" style="background-color: white">
		            <div class="coupon_tittle">
		                <p>先领券后购物</p>
		                <p>有效期2017年2月20日至2月26日</p>
		            </div>
		            <div class="coupon_content ui-grid-b">
		            <#list couponList as coupon>
		                <div <#if coupon_index%3==0>
										class="ui-block-a"
									<#elseif coupon_index%3==1>
										class="ui-block-b"
									<#elseif coupon_index%3==2>
										class="ui-block-c"
									</#if>
						>
		                    <div class="coupon_box" onclick="getYhq('${coupon.id}','${tCouponActivity.id}');">
		                        <div class="coupon" 
										<#if coupon_index%3==0>
		                        			style="margin-left: 0"
		                        		</#if>
		                        		>
		                            <p class="coupon_price">
		                                <span class="coupon_icon">RMB</span>
		                                <span class="coupon_num">${coupon.coupon_val/100}</span>
		                                <i>领</i>
		                            </p>
		                            <p class="coupon_info">${coupon.coupon_desc!}</p>
		                        </div>
		                        <#if coupon.c==0>
			                        <div class="coupon_none" 
			                        	<#if coupon_index%3==0>	
			                        		style="margin-left: 0"
			                        	</#if>
			                        	>
			                            -领完啦!-
			                        </div>
		                        </#if>
		                    </div>
		                </div>
		              </#list>
		            </div>
		        </div>
			</#if>
			<!--活动专题-->
			<div class="ui-grid-solo maindiv">
				<#list activitys as activity>
					<div class="special">
						<a href="${activity.url!}" data-ajax="false"> <img
							src="${activity.save_string!}" />
						</a>
					</div>
				</#list>		
			</div>
			
			<div data-role="main" class="ui-content ">
	          <div class="hot_line">
	              <p>热门爆款</p>
	              <p>优选鲜果 预购从速</p>
	          </div>
			<#if weekRecommends?? && (weekRecommends?size>0)>
	          <div class="hot_pro ui-grid-a">
	          	<#list weekRecommends as recommend>
	              <div <#if recommend_index%2==0>
							class="ui-block-a"
						<#elseif recommend_index%2==1>
							class="ui-block-b"
						</#if>
					onclick="window.location.href='${CONTEXT_PATH}/fruitDetial?pf_id=${recommend.pf_id}';">
		                  <img src="${recommend.save_string!}">
		                  <p class="pro_name">${recommend.product_name!}</p>
		                  <p class="pro_price">￥${(recommend.real_price!0)/100}/<span>${recommend.unit_name!}</span></p>
		                   <span style="font-size: 12px;color: #999999">${recommend.saleCount!0}人付款</span>
	              </div>
	            </#list>  
	          </div>
	        </#if>  
	      </div>
      		
      	  <div style="background-color: #EEECED; height: 10px;"></div>
      
      
	      <div data-role="main" class="ui-content">
	          <div class="hot_line">
	              <p>主推商品</p>
	              <p>优选鲜果 预购从速</p>
	          </div>
	          <#if mRecommends?? && (mRecommends?size>0)>
		          <div class="ui-grid-b">
		             <#list mRecommends as recommend>
		              <div <#if recommend_index%3==0>
								class="ui-block-a"
							<#elseif recommend_index%3==1>
								class="ui-block-b"
							<#elseif recommend_index%3==2>
								class="ui-block-c"
							</#if>
							onclick="window.location.href='${CONTEXT_PATH}/fruitDetial?pf_id=${recommend.pf_id}';">
		                  <img src="${recommend.save_string!}">
		                  <p class="guess_name">${recommend.product_name!}</p>
		                  <p class="guess_price">￥${(recommend.real_price!0)/100}/<span>${recommend.unit_name!}</span></p>
		                   <span style="font-size: 12px;color: #999999">${recommend.saleCount!0}人付款</span>
		              </div>
		             </#list> 
		          </div>
	          </#if>
	      </div>	
			
			<!--活动商品-->
			<#if (bottomActivitys??)&&(bottomActivitys?size>0)>
			<#list bottomActivitys.bottomActivity as bottomActivity>
				<div class="maindiv">
					<div class="ui-grid-solo">
						<div class="ui-block-a">
							<a href="javascript:void(0);"
							 onClick="window.location.href='${CONTEXT_PATH}/customProList?activityId=${bottomActivity.id!}'">
								<img src="${bottomActivity.imgSrc!}" />
							</a>
						</div>
					</div>
					<div class="ui-grid-b">
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
								<div onclick="fruitDetial('${product.pf_id!}');" class="prodiv">
									<img src="${product.save_string!}" /> <span
										class="proname">${product.product_name!}</span><br> 
										<span class="proprice">￥${(product.real_price!0)/100}/${product.unit_name!}</span>
										<br/>
										<span style="font-size: 12px;color: #999999">${product.saleCount!0}人付款</span>
								</div>
							</div>
						</#list>
					</div>
				</div>
			</#list>	
			</#if>
		<div style="width:100%;">
			<img style="width:100%;" src="resource/image/icon/微商城底图.jpg" />
		</div>
		
			<div data-role="footer" style="height: 60px;"></div>
</div>
<div style="position: fixed; width: 100%;z-index:10; bottom: 0; height: 56px; background-color: #f5f5f5; border-top: #DEDEDE 1px solid;">
		<div class="ui-grid-b">
			<div class="ui-block-a mainmenu" id="mainPage">
				<img id="mainImg" src="${CONTEXT_PATH}/resource/image/menu/首页1.png" /><br /> <span>首页</span>
			</div>
			<div class="ui-block-b mainmenu" id="cartPage">
				<img id="cartImg" src="${CONTEXT_PATH}/resource/image/menu/购物车.png" /><br /> <span>购物车</span>
			</div>
			<div class="ui-block-c mainmenu" id="selfPage">
				<img id="selfImg" src="${CONTEXT_PATH}/resource/image/menu/我的.png" /><br /> <span>我的</span>
			</div>
		</div>
	</div>
</div>
<#include "/WEB-INF/pages/common/share.ftl"/>
<script src="plugin/jQuery/json2.js"></script>
<script src="plugin/common/productDetial.js"></script>
<script>
	$(
			function() {
				var t = n = 0;
				count = $(".img_content a").size();
				var st = 0;
				var play = ".play";
				var playText = ".play .text";
				var playNum = ".play .num a";
				var playConcent = ".play .img_content a";
				$(playConcent + ":not(:first)").hide();
				$(playText).html(
						$(playConcent + ":first").find("img").attr("alt"));
				$(playNum + ":first").addClass("on");
				$("#next").click(
						function() {
							if (n >= count-1){
								n=0;
							}else{
								n++;
							}
							$(playText).html(
									$(playConcent).eq(n).find("img")
											.attr('alt'));
							// $(playText).unbind().click(function(){window.open($(playConcent).eq(i).attr('href'), "_blank")})
							$(playConcent).filter(":visible").hide().parent()
									.children().eq(n).show();

						});
				$("#pre").click(
						function() {
							if (n <= 0){
								n=count-1;
							}else{
								n--;
							}
							$(playText).html(
									$(playConcent).eq(n).find("img")
											.attr('alt'));
							// $(playText).unbind().click(function(){window.open($(playConcent).eq(i).attr('href'), "_blank")})
							$(playConcent).filter(":visible").hide().parent()
									.children().eq(n).show();

						});
				t = setInterval(function() {
					$("#next").click();
				}, 5000);
				
				$(playConcent).bind(
						"swipeleft",
						function() {
							clearInterval(t);
							$("#next").click();
						});
				
				$(playConcent).bind(
						"swiperight",
						function() {
							clearInterval(t);
							$("#pre").click();
						});
	
				$("#cartPage").click(function(){
					  window.location.href = "${CONTEXT_PATH}/cart";
				});
				
				$("#selfPage").click(function(){
					window.location.href = "${CONTEXT_PATH}/me";
				});

	});
			
	function goKind(kind){
		window.location.href = "${CONTEXT_PATH}/fruitKind?id="+kind;
	}
	
	function proSearch(){
		window.location.href = "${CONTEXT_PATH}/search";
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
<!--<script src="plugin/weixin/address.js?v={.now?long}"></script>-->
</body>
</html>