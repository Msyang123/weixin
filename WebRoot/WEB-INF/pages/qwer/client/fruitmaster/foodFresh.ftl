<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-美味食鲜首页" />
<link rel="stylesheet" href="plugin/dropload/dropload.css">
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

    <div id="food_fresh" class="wrapper pb70">

	    <header class="g-search-static">
			<a class="u-search-static" @click="goSearch">
				<i><img src="resource/image/icon-master/icon_search.png"></i>
				搜索文章/商品
			</a>
		</header>
		
	    <section class="m-tab row justify-content-center align-items-center no-gutters">
		       <div class="col-4 text-center type">
		          <a href="javascript:void(0)" 
		             :class="{active: articleObj.type=='1'}" 
		             @click.prevent="switchType('1',$event)">营养菜单</a>
		        </div>
		       <div class="col-4 text-center type">
		          <a href="javascript:void(0)" 
		            :class="{active: articleObj.type=='2'}"
		            @click.prevent="switchType('2',$event)">食鲜常识</a>
		       </div>
		       <div class="col-4 text-center type">
		          <a href="javascript:void(0)" 
		            :class="{active: articleObj.type=='3'}"
		            @click.prevent="switchType('3',$event)">经验分享</a>
		       </div>
	    </section>
	    		  
	    <section class="m-coupon mt15">
			
			<div class="m-list-coupon" v-cloak>
			     <div class="m-item" v-for="item in articleObj.articleList" :key="item.id" @click="goDetail(item.id)" v-cloak>
			         <img :src="item.head_image | formatImg" class="coupon-pic w100" onerror="common.imgLoadMaster(this)"/>
				     <div class="u-caption-overlay w100">
				        <h4>{{item.title}}</h4>
				        <p class="f-no-border">{{item.article_intro}}</p>
				     </div>
			     </div>
			</div>
			
	        <div class="z-none" v-show="isShow">
				<img src="resource/image/icon-master/expression_sorry.png">
				<p>没有您想要的文章哦~</p>
			</div>
			  
	    </section>
	    
	    <footer class="m-nav row no-gutters">
			<div class="col u-nav-btn" @click="goHome">
				<img src="resource/image/icon-master/nav_home_default.png">
				<br/><span class="f-nav-index">首页</span>
			</div>
			<div class="col u-nav-btn active" @click="goMall">
				<img src="resource/image/icon-master/nav_mall_default.png">
				<br/><span class="f-nav-mall">商城</span>
			</div>
			<div class="col u-nav-btn u-nav-center" @click="goFresh">
				<img src="resource/image/icon-master/nav_center_selected.png">
			</div>
			<div class="col u-nav-btn" @click="goCart">
				<img src="resource/image/icon-master/nav_cart_default.png" class="js-fly-target">
				<br/><span class="f-nav-cart">购物车</span>
			</div>
			<div class="col u-nav-btn" @click="goMe">
				<img src="resource/image/icon-master/nav_me_default.png">
				<br/><span class="f-nav-me">我的</span>
			</div>
	    </footer>
   </div>
   
   <#include "/WEB-INF/pages/common/share.ftl"/>
   <script src="plugin/dropload/dropload.min.js"></script>
   <script>
        $(function(){
        	 //实例化vue
			 var data={
			    articleObj:${xactiles},
				isActive:true,
				pageNum:1,
				pageSize:4,
				isShow:false
			 };
			 
			 var vm=new Vue({
				    mixins:[backHistory,navBar],
				    el:"#food_fresh",
	                data:data,
	                computed:{

	                },
	                created:function(){
	                	this.$nextTick(function(){
	                	    this.getArticleList(this.articleObj.type,1,4);
	            		});
		            },
	                filters:{
	                	formatImg:function(value){
	                		if (!value) return 'resource/image/icon-master/img-error-big.png';
	                	    return value.toString();
	                	}
	                },
	                methods: {
	                    goSearch:function(){
                            window.location.href="${CONTEXT_PATH}/mall/searchShow";
		                },
		                goDetail:function(id){
		                	window.location.href='${CONTEXT_PATH}/mall/articleDetail?article_id='+id;
		                },
		                switchType:function(type,event){
	                       //修改type 切换显示列表
	                       this.articleObj.type=type;
	                       //发送请求回后台 刷新数据更新Data
	                       this.pageNum=1;
	                       this.isShow=false;
	                       dropInstance.unlock();
	                       dropInstance.resetload();
	                       this.getArticleList(type,1,4);
				        }, 
		                getArticleList:function(type,pageNum,pageSize){
			                var _this=this;
			                //根据当前菜单类型和当前页码获取文章list
		                	axios.get("${CONTEXT_PATH}/foodFresh/foodFreshAjax",{
		                		params: {
		                			type: type,
		                			pageNumber: pageNum,
		                			pageSize: pageSize
		                		}
		                	}).then(function(response){
 		                		var arrLen = response.data.articleList.length;
 		                		
 		                		if(arrLen==0){
 	 		                		_this.isShow=true;
 	 		                	}
 	 		                	
 		                		if(arrLen >= 0){
                                    //切换status=切换显示 列表
                                    _this.articleObj.articleList=response.data.articleList;
 			                    }
 			                    
		                	}).catch(function(error){
		                		console.log(error);
		                	}); 
			            }
	                }
			 });
			 
			 //滚动加载
             var dropInstance=$('.wrapper').dropload({
				        scrollArea : window,
				        autoLoad:false, 
				        distance:50,
				        domDown:{
				        	domClass : 'dropload-down',
				        	domRefresh : '<div class="dropload-refresh"></div>',
				        	domLoad : '<div class="dropload-load">加载中...</div>',
				        	domNoData : '<div class="dropload-noData brand-grey-s">-------------我是有底线的-------------</div>'
			        	},
				        loadDownFn : function(me){
				        	vm.pageNum++;
				        	//根据当前菜单类型和当前页码获取orderList
		                    axios.get("${CONTEXT_PATH}/foodFresh/foodFreshAjax",
				            {
		                		params: {
		                			type: vm.articleObj.type,
		                			pageNumber:vm.pageNum,
		                			pageSize: vm.pageSize
		                		}
		                	}).then(function(response){
		                		//console.log(response.data);
		                		var articleList=response.data.articleList;
		                		var arrLen = articleList.length;
		                		if(arrLen > 0){
			                		for(var i=0;i<arrLen;i++){
			                			vm.articleObj.articleList.push(articleList[i]);
				                    }
			                    }else{
			                    	dropInstance.lock();
			                    	dropInstance.noData();
			                    	vm.isShow=false;
				                }
				                
		                	    dropInstance.resetload();
		                		
		                	}).catch(function(error){
		                	    // 即使加载出错，也得重置
			                    dropInstance.resetload();
		                	}); 
				        }
				 }); 

            //微信分享js
 			wx.ready(function() {
 				var master_id=vm.articleObj.master_id==null?'':vm.articleObj.master_id;
 				var link='${app_domain}/foodFresh/shareFoodFresh?type='+vm.articleObj.type+'&pageNumber=1&pageSize=4&master_id='+master_id;
 				var imgUrl='${app_domain}/resource/image/logo/shuiguoshullogo.png';
 				//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
 				wx.onMenuShareTimeline({
 				    title: vm.articleObj.share_name+'为您推荐--在这里，你能找到生活的美好。营养生活，从美味食鲜开始', // 分享标题
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
 				    title: vm.articleObj.share_name+'为您推荐', // 分享标题
 				    desc:'在这里，你能找到生活的美好。营养生活，从美味食鲜开始',
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
 				    title:vm.articleObj.share_name+'为您推荐', // 分享标题
 				    desc:'在这里，你能找到生活的美好。营养生活，从美味食鲜开始',
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