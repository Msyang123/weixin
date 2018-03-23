<!DOCTYPE html>
<html>
<head>
<title>美味食鲜-文章详情</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-美味食鲜文章详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>

	<div id="content_detail" class="wrapper">
		<div class="btn-circle-back" @click="back">
		     <img src="resource/image/icon-master/icon_circle_back.png" width="30" />
		</div>
		
		<header class="g-banner">
	  	   <img  v-bind:src="article.head_image" title="banner" onerror="common.imgLoadMaster(this)"/>
	  	</header> 
	  	<div class="m-author-info"  v-cloak>投稿人：{{article.contribution_penson}}   编辑：{{article.edit_penson}}</div>
	  	<div class="m-article-inro" v-cloak>
	  		{{article.article_intro}}
	  	</div>
	  	<div class="m-article-title"  v-cloak>{{article.title}}</div>
	  	<div id="m-article-content" v-cloak> 
	  	  	<iframe frameborder="0" v-bind:src="article.url" name="articleArea" id="articleArea"></iframe>
	  	</div>
		
		<div class="u-normal-title">{{article.recommend_product_name}}</div>
		
		<section class="m-related-pro row no-gutters">
			<div class="col-6 u-itm-pro js-fly-source" v-for="item in proList" :key="item.id">
				<img v-bind:src="item.save_string" @click="goDetial(item.product_id,item.pf_id)">
				<p>{{item.product_name}}</p>
				<p class="brand-blue">&yen; {{item.price | formatCurrency}}/{{item.unit_name}}</p>
				<a class="u-btn-add" @click="addCart(item.product_id,item.pf_id,$event)">
				<img src="resource/image/icon-master/icon_cart_add.png"></a>
			</div>
		</section>
		
		<section class="m-cart">
	  		<div class="cart-content" @click="goCart">
		  		<img src="resource/image/icon-master/icon_cart_go_big.png" height="45" class="js-fly-target"/>
		  		<div class="cart-num js-cart-num" v-show="proNum!=0">{{proNum}}</div>
	  		</div>
		</section> 
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/echo.min.js"></script>
	<script src="plugin/jQuery/jquery.cookie.js"></script>
	<script src="plugin/jQuery/json2.js"></script> 
	<script>
		$(function () {
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatCurrency],
		        el:"#content_detail",
		        data:{
					article:${result.article},
					proList:${result.products},
					proNum:${result.productNum},
					id:${result.article.master_id},
					name:'${result.share_name}',
		        },
		        created: function () {
		        	document.getElementById('articleArea').style.height = (document.documentElement.clientHeight - 140) + "px";
		        },
		        methods: {
		        	goDetial:function(id,pid){
                    	window.location.href="${CONTEXT_PATH}/mall/foodDetail?product_id="+id+'&product_fid='+pid;
                    },
		            goCart:function(){
	                	window.location.href="${CONTEXT_PATH}/fruitShop/cart";
	                },
		            addCart:function(id,pfId,event){
	                	//添加到购物车去 id--商品id pfId--商品规格id
	                	var _this=this;
	    				var flag=false;
	    				var $eTarget=$(event.target);
	    				
	    				var _sourceImg=$eTarget.parents('.js-fly-source').children('img');
	    				var _target=$(".js-fly-target");
	    			    var _back=function(){
	    			       //添加到购物车cookie处理
	    			       _this.handleCart(id,pfId);
	    			    };
	                 	//购物车飞入动画
	    	            common.objectFlyIn(_sourceImg,_target,_back);
	                },
	                handleCart:function(id,pfId){
	                	//添加到购物车cookie处理
				    	var num = this.proNum;
						this.proNum=++num;
						var new_historyp='{"product_id":'+id+',"product_num":1,"pf_id":'+pfId+'}';
						//debugger;
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
			
			//微信分享js
			wx.ready(function() {
				var master_id=vm.master_id==null?'':vm.master_id;
				var link='${app_domain}/fruitMaster/enterMasterIndex?master_id='+master_id+'&article_id='+vm.article.id;
				var oldUrl = vm.article.head_image;
				var newUrl = oldUrl.slice(7);
				var imgUrl = '${app_domain}'+newUrl;
				//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
				wx.onMenuShareTimeline({
				    title: vm.article.title, // 分享标题,
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
				    title: vm.article.title, // 分享标题
				    desc: vm.article.article_intro, // 分享描述
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
					title: vm.article.title, // 分享标题
				    desc: vm.article.article_intro, // 分享描述
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