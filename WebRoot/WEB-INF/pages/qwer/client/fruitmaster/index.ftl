<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-美味食鲜首页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>
	<div id="master_index" class="wrapper">
		<header class="g-search">
			<a class="u-search" @click="goAsearch">
				<i><img src="resource/image/icon-master/icon_search.png"></i>
				搜索文章/商品	
			</a>
		</header>
		
		<!--轮播图-->
	    <div class="swiper-container s-shadow1">
	        <div class="swiper-wrapper">
	            <div class="swiper-slide" v-for="item in bannerList">
		            <a v-bind:href="item.url">
		            <img v-bind:src="item.img" onerror="common.imgLoadMaster(this)"></a>
	            </div>
	        </div>
		<!--如果需要分页器 -->
	        <div class="swiper-pagination"></div>
	    </div>
	
		<!--明星鲜果师 -->
		<div class="m-master-star" v-cloak>
		 	<div class="u-line">
			     <hr class="line-left"/>明星鲜果师<hr class="line-right"/>
			</div>
			<p class="u-title-info">专业团队为您量身定制。因为专业，所以健康！<p>	
			
			<div class="m-index-star-list">
				<a class="star-itm" v-for="item in starMasterList" :href="'${CONTEXT_PATH}/masterIndex/masterDetail?master_id=' + item.id ">
				  <img class="star-itm-img" v-bind:src="item.img | formatImg" onerror="common.imgLoadHead(this)">
			      <p class="star-itm-title">{{item.name}}</p>
			      <p class="star-itm-text">{{item.level}}</p>
				</a>
			</div>
			
			<div class="u-index-more" @click="goMaterList">
				查看更多内容<img src="resource/image/icon-master/icon_more_double.png">
			</div>
		</div>
		
		<div class="m-index-article" v-cloak>
			<div class="u-line">
			     <hr class="line-left"/>食鲜之味<hr class="line-right"/>
			</div>
			<p class="u-title-info">最新美食攻略，持续更新中<p>
			
			<div class="article-itm" v-for="item in artList" :key="item.article_id" @click="goArticleDetail(item.article_id)">
				<img class="bg-img" :src="item.bgImg | formatImg1" onerror="common.imgLoadMaster(this)">
				<a class="f-mask u-mask">
					<img class="itm-portrait" :src="item.xg_headPictrue | formatImg" onerror="common.imgLoadHead(this)">
					<p class="itm-author">{{item.name}}/{{item.level}}</p>
					<p class="itm-tit">{{item.title}}</p>
					<div class="itm-text">{{item.info}}</div>
				</a>
			</div>
			
			<div class="u-index-more" @click="goFresh">
				查看更多内容<img src="resource/image/icon-master/icon_more_double.png">
			</div>
		</div>
	    
		<footer class="m-nav row no-gutters">
			<div class="col u-nav-btn active" @click="goHome">
				<img src="resource/image/icon-master/nav_home_selected.png">
				<br/><span class="z-crt f-nav-index">首页</span>
			</div>
			<div class="col u-nav-btn" @click="goMall">
				<img src="resource/image/icon-master/nav_mall_default.png">
				<br/><span class="f-nav-mall">商城</span>
			</div>
			<div class="col u-nav-btn u-nav-center" @click="goFresh">
				<img src="resource/image/icon-master/nav_center_default.png">
			</div>
			<div class="col u-nav-btn" @click="goCart">
				<img src="resource/image/icon-master/nav_cart_default.png">
				<br/><span class="f-nav-cart">购物车</span>
			</div>
			<div class="col u-nav-btn" @click="goMe">
				<img src="resource/image/icon-master/nav_me_default.png">
				<br/><span class="f-nav-me">我的</span>
			</div>
		</footer>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script>
		$(function(){
		    //实例化vue
			var vm=new Vue({
				mixins:[formatHead,navBar],
                el:"#master_index",
                data:${indexData},
                filters: {
                	formatImg1:function(value){
                		if (!value) return 'resource/image/icon-master/img-error-big.png';
                	    return value.toString();
                	}
                },
                methods: {
                    goAsearch:function(){
                    	window.location.href = "/weixin/mall/searchShow";
                    },
                    goMaterList:function(){
						window.location.href = "/weixin/masterIndex/masterList?page=1&size=8";                    	
                    },
                    goArticleDetail:function(id){
                    	window.location.href = "/weixin/mall/articleDetail?article_id="+id;
                    }
                }
		     });
		    
			//轮播图
	        var swiper = new Swiper('.swiper-container', {
      		        pagination: '.swiper-pagination',
      		        paginationClickable: '.swiper-pagination',
      		        spaceBetween: 30,
      		        loop: true,
      		        centeredSlides: true,
      		        autoplayDisableOnInteraction : false,
      		        autoplay: 3000
      		 });
			
			//搜索栏
		    $(window).scroll(function () {
		        var nTop = $(".g-search").offset().top;
		        if (nTop>=200) {
		            $(".u-search").css("animation","goShow 3s forwards")
		        }else{
		        	$(".u-search").css("animation","goHide 3s forwards")
		        }
		    });
			
			//微信分享js
			wx.ready(function() {
				var master_id=vm.master_id==null?'':vm.master_id;
				var link='${app_domain}/masterIndex/shareIndex?master_id='+master_id;
				var imgUrl='${app_domain}/resource/image/logo/shuiguoshullogo.png';
				//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
				wx.onMenuShareTimeline({
				    title: vm.share_name+'为您推荐-优质生活需自己打造，快来美味食鲜获得最新的营养咨询吧', // 分享标题,
				   // desc: '', // 分享描述
				    link: link, // 分享链接
				    imgUrl: imgUrl, // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				        //alert('取消分享到朋友圈');
				    }
				});
				//获取“分享到QQ”按钮点击状态及自定义分享内容接口
				wx.onMenuShareQQ({
				    title: vm.share_name+'为您推荐', // 分享标题
				    desc: '优质生活需自己打造，快来美味食鲜获得最新的营养咨询吧', // 分享描述
				    link: link, // 分享链接
				    imgUrl: imgUrl, // 分享图标
				    success: function () { 
				    },
				    cancel: function () { 
				       // 用户取消分享后执行的回调函数
				    }
				});
			
				//分享给朋友
				wx.onMenuShareAppMessage({
					title: vm.share_name+'为您推荐', // 分享标题
				    desc: '优质生活需自己打造，快来美味食鲜获得最新的营养咨询吧', // 分享描述
				    link: link, // 分享链接
				    imgUrl: imgUrl, // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				    },
				    cancel: function () {
				        // 用户取消分享后执行的回调函数
				    }
				});
			});
		});
	</script>
</body>
</html>