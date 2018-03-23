<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-美味食鲜商城首页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>
	<div id="shop_index" class="wrapper pb70 bg-grey-light">
	    <header class="g-search">
			<a class="u-search" @click="goAsearch">
				<i><img src="resource/image/icon-master/icon_search.png"></i>
				搜索文章/商品
			</a>
		</header>
		
		<!--轮播图-->
	    <section class="swiper-container swiper-container-bn s-shadow1">
	        <div class="swiper-wrapper">
	            <div class="swiper-slide" v-for="item in product.bannerList" :key="item.id" v-cloak>
	                <a :href="item.url"><img :src="item.save_string" onerror="common.imgLoadMaster(this)"></a>
	            </div>
	        </div>
		    <!--如果需要分页器 -->
	        <div class="swiper-pagination swiper-pagination-bn"></div>
	    </section>
	    
	    <section class="m-coupon mt15">
	        <div class="u-line">
			     <hr class="line-left"/>营养精选<hr class="line-right"/>
			</div>
			
			<p class="u-title-info">精挑细选的美味商品</p>
			
			<div class="m-list-coupon">
			     <div class="m-item js-fly-source" v-for="item in product.comboList" :key="item.comboId"  v-cloak>
			         <img :src="item.save_string" class="coupon-pic w100" onerror="common.imgLoadMaster(this)" @click="goDetial(item.id,item.pf_id)"/>
				     <div class="u-caption-overlay w100">
				        <div @click.stop="goDetial(item.id,item.pf_id)">
					        <h4>{{item.product_name}}</h4>
					        <p>{{item.description}}</p>
				        </div>
				        <div class="row justify-content-between no-gutters align-items-center">
					        <div class="col-6 price">&yen; {{item.price | formatCurrency}}</div>
					        <div class="col-6 text-right"><img @click="addCart(item.id,item.pf_id,$event)" src="resource/image/icon-master/icon_mall_cart_add1.png"  height="30" /></div>
				        </div>
				     </div>
			     </div>
			</div>
	    </section>
	    
	    <section class="m-recommend mb15">
	        <div class="u-line">
			     <hr class="line-left"/>食鲜推荐<hr class="line-right"/>
			</div>
			
			<p class="u-title-info">营养健康一手抓</p>
			
			<div class="m-recommend-content" v-for="(ritem,index) in product.recomendSection" :key="ritem.id" v-cloak>
			
				<img :src="ritem.save_string | formatImg" class="w100 mt15" onerror="common.imgLoadMaster(this)"/>
				
				<div class="m-list-recommend bg-white swiper-container swiper-container-cp">
				
			        <div class="swiper-wrapper">
			        
			            <div class="swiper-slide js-fly-source" v-for="item in ritem.product_list" :key="item.id">
			               <img :src="item.save_string" class="img-fluid" @click="goDetial(item.id,item.pf_id)" onerror="common.imgLoadMaster(this)">
			               <h4>{{item.product_name}}</h4>
			               <p>约{{item.product_amount}}{{item.base_unitname}}/{{item.unit_name}}</p>
			               <div class="row justify-content-between no-gutters align-items-center">
			                   <div class="col-8 coupon-price">&yen; {{item.price | formatCurrency}}</div>  
			                   <div class="col-auto text-right"><img @click="addCart(item.id,item.pf_id,$event)" src="resource/image/icon-master/icon_mall_cart_add2.png"  height="20" /></div>
			               </div>
			            </div>
			            
			        </div>
				    <!--如果需要分页器 -->
			        <!-- <div class="swiper-pagination swiper-pagination-cp"></div> -->
			        
		        </div>
		        
			</div>
	    </section> 
	    
	   <footer class="m-nav row no-gutters">
			<div class="col u-nav-btn" @click="goHome">
				<img src="resource/image/icon-master/nav_home_default.png">
				<br/><span class="f-nav-index">首页</span>
			</div>
			<div class="col u-nav-btn active" @click="goMall">
				<img src="resource/image/icon-master/nav_mall_selected.png">
				<br/><span class="z-crt f-nav-mall">商城</span>
			</div>
			<div class="col u-nav-btn u-nav-center" @click="goFresh">
				<img src="resource/image/icon-master/nav_center_default.png">
			</div>
			<div class="col u-nav-btn" @click="goCart">
				<img src="resource/image/icon-master/nav_cart_default.png" class="js-fly-target">
				<br/><span class="f-nav-cart">购物车</span>
				<i class="boll" v-show="isShow"></i>
			</div>
			<div class="col u-nav-btn" @click="goMe">
				<img src="resource/image/icon-master/nav_me_default.png">
				<br/><span class="f-nav-me">我的</span>
			</div>
	    </footer>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/echo.min.js"></script>
	<script src="plugin/jQuery/jquery.cookie.js"></script>
	<script src="plugin/jQuery/json2.js"></script>
	<script>
		$(function() {
			 //实例化vue
			 var vm=new Vue({
				    mixins:[formatCurrency,backHistory,navBar],
					el:"#shop_index",
	                data:{
	                   product:${data},
	                   isShow:false
	                },
	                computed:{
	
	                },
	                filters: {
	                	formatImg:function(value){
	                		if (!value) return 'resource/image/icon-master/img-error-big.png';
	                	    return value.toString();
	                	}
	                },
	                mounted() {
	                    /* axios.get("${CONTEXT_PATH}/masterIndex/foodDetail?pid=")
	                    .then(response => {this.data = response.data.results}) */
	                },
	                methods: {               	
	                    goDetial:function(id,pid){
	                    	window.location.href="${CONTEXT_PATH}/mall/foodDetail?product_id="+id+'&product_fid='+pid;
	                    },
	                    goAsearch:function(){
	                    	window.location.href = "/weixin/mall/searchShow";
	                    },
	                    addCart:function(id,pfId,event){
	                    	//添加到购物车去 id--商品id pfId--商品规格id
	                    	var _this=this;
	        				var flag=false,index=0;
	        				var $eTarget=$(event.target);
	        				
	        				var _sourceImg=$eTarget.parents('.js-fly-source').children('img');
	        				var _target=$(".js-fly-target");
	        			    var _back=function(){
	        			       //添加到购物车cookie处理
	        			       _this.handleCart(id,pfId);
	        			    };
	        	          
	        				//查找购物车cookie中是否有指定商品
	        				if($.cookie('xgCartInfo')!=null){
	        					var old_historyp_json=JSON.parse($.cookie('xgCartInfo'));
	        			       
	        			        for(var i=0;i<old_historyp_json.length;i++){
	        			          	if(old_historyp_json[i].pf_id==pfId){
	        			          		flag=true;
	        			          		index=i;
	        			          		break;
	        			          	}
	        			        }
	        			    } 
	        		        //设置添加了的单个商品总数,默认为1
	        		        var count=1;
	                  		if(flag){
	                  			count=parseInt(old_historyp_json[index].product_num)+1;
	                  		}
	                  		_this.isShow=true;
	                  		//_this.product.proNum=count;
	                     	//购物车飞入动画
	        	            common.objectFlyIn(_sourceImg,_target,_back);
	                    },
	                    handleCart:function(id,pfId){
	                    	//添加到购物车cookie处理
	                    	var new_historyp='{"product_id":'+id+',"product_num":1,"pf_id":'+pfId+'}';
		
	    					if($.cookie('xgCartInfo')==null){
	    			          new_historyp='['+new_historyp+']';
	    			          $.cookie('xgCartInfo',new_historyp,{expires:15,path:'/'});
	    			     	}else{
	    			          var old_historyp_json=JSON.parse($.cookie('xgCartInfo'));
	    			          var flag=false;
	    			          for(var i=0;i<old_historyp_json.length;i++){
	    			          	if(old_historyp_json[i].pf_id==pfId){
	    			          		old_historyp_json[i].product_num=parseInt(old_historyp_json[i].product_num)+1;
	    			          		flag=true;
	    			          		break;
	    			          	}
	    			          }
	    			          //新的就加进来
	    					  if(flag==false){
	    					     var item  =
	   							 {
    					    		'product_id' : id,
   	   							    'product_num' :1,
   	   							    'pf_id':pfId
	   							 }
	    						 old_historyp_json.push(item);
	    					   }
	    			           //将json对象转换成字符串存cookie
	    			           $.cookie('xgCartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
	    			         }
	                    }
	                }
			 });
			 
			 
		      //延迟加载图片初始化
		      var swiper = new Swiper('.swiper-container-bn', {
			        pagination: '.swiper-pagination-bn',
			        paginationClickable: '.swiper-pagination-bn',
			        spaceBetween: 30,
			        loop: true,
			        centeredSlides: true,
			        autoplayDisableOnInteraction : false,
			        autoplay: 3000
			   });
		     
		      //实例化Swiper
  		      var swiper1=new Swiper('.swiper-container-cp', {
				    //pagination : '.swiper-pagination-cp',
				    paginationClickable:false,
			        scrollbarHide: true,
			        slidesPerView: 3,
			        slidesPerGroup:3,
			        slidesOffsetBefore:10,
			        slidesOffsetAfter : 10,
			        centeredSlides: false,
			        spaceBetween: 15,
			        grabCursor: true,
			        setWrapperSize :false,
			        breakpoints: { 
					    //当宽度小于等于320
					    320: {
					      slidesPerView: 3,
					      slidesPerGroup:3,
					      spaceBetweenSlides: 10
					    },
					    //当宽度小于等于376
					    375: { 
					      slidesPerView: 3,
					      slidesPerGroup:3,
					      spaceBetweenSlides: 15
					    },
					   //当宽度小于等于415
					    414: { 
					      slidesPerView: 4,
					      slidesPerGroup:4,
					      spaceBetweenSlides: 15
					    },
					     //当宽度小于等于415
					    480: { 
					      slidesPerView: 5,
					      slidesPerGroup:5,
					      spaceBetweenSlides: 15
					    },
					    //当宽度小于等于640
					    640: {
					      slidesPerView: 5,
					      slidesPerGroup:5,
					      spaceBetweenSlides: 20
				        }
				     }
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
				var master_id=vm.product.master_id==null?'':vm.product.master_id;
				var link='${app_domain}/mall/shareShopIndex?master_id='+master_id;
				var imgUrl='${app_domain}/resource/image/logo/shuiguoshullogo.png';
				//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
				wx.onMenuShareTimeline({
				    title: vm.product.share_name+'为您推荐--精品生鲜一手推荐，美食食鲜将提供最合适你的营养搭配。不要错过哦', // 分享标题
				    link: link, // 分享链接
				    imgUrl: imgUrl, // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				        console.log('share success');
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				        //alert('取消分享到朋友圈');
				    	console.log('cancel success');
				    }
				});
				
				//获取“分享到QQ”按钮点击状态及自定义分享内容接口
				wx.onMenuShareQQ({
				    title: vm.product.share_name+'为您推荐', // 分享标题
				    desc:'精品生鲜一手推荐，美食食鲜将提供最合适你的营养搭配。不要错过哦',
				    link: link, // 分享链接
				    imgUrl: imgUrl, // 分享图标
				    success: function () { 
				    	 console.log('share success');
				    },
				    cancel: function () { 
				       // 用户取消分享后执行的回调函数
				    	console.log('cancel success');
				    }
				});
			
				//分享给朋友
				wx.onMenuShareAppMessage({
				    title:vm.product.share_name+'为您推荐', // 分享标题
				    desc:'精品生鲜一手推荐，美食食鲜将提供最合适你的营养搭配。不要错过哦',
				    link: link, // 分享链接
				    imgUrl: imgUrl, // 分享图标
				    success: function () {
				        // 用户确认分享后执行的回调函数
				    	console.log('share success');
				    },
				    cancel: function () {
				        // 用户取消分享后执行的回调函数
				    	console.log('cancel success');
				    }
				});
			});
		});
	</script>
</body>
</html>