<!DOCTYPE html>
<html>
<head>
	<title>美味食鲜-商品详情</title>
    <meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="美味食鲜-商品详情页" />
    <#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/> 
</head>
<body>

	<div id="food_detail" class="wrapper pb50 bg-grey-light">
	  	
	  	<header class="g-banner">
	  	   <img :src="product.save_string" title="商品主图" id="main_pic" onerror="common.imgLoadMaster(this)"/>
	  	   <div class="u-back-rounded">
	  	      <a href="javascript:void(0);" @click="back">
	  	      <img src="resource/image/icon-master/icon_circle_back.png" title="返回图标" height="25"/></a>
	  	   </div>
	  	</header>        
 	       
	  	<section class="m-introduce" v-cloak>
	  	    <h4>{{product.product_name}}</h4>
	  	    <p>{{product.description}}</p>
	    </section>
	  	
	  	<section class="m-standards row no-gutters justify-content-between align-items-center">
  	       <div class="col-2 word">规格：</div>
  	       <div class="col-10 text-left">
  	           <button class="btn bnt-sm u-btn-default" 
  	           v-for="(item,index) in product.standardList" 
  	           @click.prevent="switchStandard(item.price,$event)" 
  	           :key="item.id" :class="{'u-btn-brown':index==0}" 
  	           :pid="item.id" v-cloak>{{item.show_standard}}/{{item.unit_name}}</button>
  	       </div>
	  	</section>    
	  	 
	  	<section class="m-detail">
	        <div class="u-line">
				<hr class="line-left"/>商品详情<hr class="line-right"/>
		    </div>
	        <div class="m-list-pic">
	            <div v-html="product.product_detail"></div>
	        </div>
        </section>
	
		<section class="m-cart" @click="goCart">
	  		<div class="cart-content">
		  		<img src="resource/image/icon-master/icon_cart_go_big.png" height="45" class="cart-img"/>
		  		<div class="cart-num js-cart-num" v-show="isShow">{{product.proNum}}</div>
	  		</div>
		</section> 

	    <footer class="m-opreation row no-gutters justify-content-between align-items-center">
	         <div class="col-4 price">
	              &yen; {{product.money | formatCurrency}}
	              <p v-show="product.master_id > 0">每份立赚<span>{{product.bonus | formatCurrency}}</span>元</p>
             </div>
	         <div class="col-8">
	              <div class="row no-gutters justify-content-between align-items-center">
		         	  <div class="col-6 text-center">
		         	    <button class="btn bnt-sm u-btn-blue" @click="addCart">加入购物车</button>
		         	   </div>
		              <div class="col-6 text-center">
		                <button class="btn bnt-sm u-btn-brown" @click="buyNow">立即购买</button>
		              </div>
	              </div>
	         </div>
	    </footer>
	</div> 
	
    <#include "/WEB-INF/pages/common/share.ftl"/>
    <script src="plugin/jQuery/jquery.cookie.js"></script>
	<script src="plugin/jQuery/json2.js"></script>
    <script> 
		$(function() {
			//实例化Vue
			var vm=new Vue({
				el:"#food_detail",
                data:{
                	product:${product},
			        isShow:false,
                },
                computed:{
                	
                },
                mounted:function() {
                	this.$nextTick(function(){

                		if(this.product.proNum!=0){
                            this.isShow=true
                		}
             		
            		});
                },
                filters: {
                	formatCurrency:function(value){
                		return common.formatCurrency(value);
                	}
                },
                methods: {
                	back:function(){
                		window.history.back();
                    },
                    switchStandard:function(price,event){
	                   	 var $target=$(event.target);
	                   	//切换样式
	                   	$target.addClass("u-btn-brown").siblings('button').removeClass("u-btn-brown");
	                   	//切换价格
	                   	this.product.money=price;
	                },
                    goCart:function(){
                    	window.location.href="${CONTEXT_PATH}/fruitShop/cart";
                    },
                    addCart:function(){
                    	//添加到购物车去 id--商品id pfId--商品规格id
                    	var _this=this;
                    	var id=_this.product.id;
        				var pfId=$('.u-btn-brown').attr('pid');
        				var flag=false,index=0;
        				
        				var _sourceImg=$('#main_pic');
        				var _target=$(".cart-img");
        			    var _back=function(){
        			       //添加到购物车cookie处理
        			       _this.handleCart(id,pfId);
        			    };
                  		_this.isShow=true;
                     	//购物车飞入动画
        	            common.objectFlyIn(_sourceImg,_target,_back);
                    },
                    buyNow:function(){
                    	//立即购买
        				var pfId=$('.u-btn-brown').attr('pid');
        				window.location.href="${CONTEXT_PATH}/fruitShop/order?pId="+this.product.id+"&pfId="+pfId;
                    },
                    handleCart:function(id,pfId){
                    	//添加到购物车cookie处理
    			    	var num = this.product.proNum;
    					this.product.proNum=++num;
    					var new_historyp='{"product_id":'+id+',"product_num":1,"pf_id":'+pfId+'}';
    					if($.cookie('xgCartInfo')==null){
    					  //cookie 不存在     
    			          new_historyp='['+new_historyp+']';
    			          $.cookie('xgCartInfo',new_historyp,{expires:15,path:'/'});
    			     	}else{
    			     	  //cookies已经存在,就将存储的cookie取出然后判定是已经加入的还是新的，原来的直接覆盖
    			     	  //新的就加进来,一般情况下不会发生，因为此页面没有加入新商品的入口
    			          //将字符串转换成json对象
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
			
			var imgNode=$('.m-list-pic').find('img')
			var len=imgNode.length;
			
			if(len>0){
    			for(var i=0;i<len;i++){
    				imgNode.eq(i).attr('onerror','common.imgLoadMaster(this)');
    				imgNode.eq(i).addClass('m-item');
    			}
        	}
			
			//微信分享js
			wx.ready(function() {
				var master_id=vm.product.master_id==null?'':vm.product.master_id;
				var link = '${app_domain}/fruitMaster/enterMasterIndex?master_id='+master_id+'&product_id='+vm.product.id+"&product_fid="+${pf_id};
				var oldUrl = vm.product.save_string;
				var newUrl = oldUrl.slice(7);
				var imgUrl = '${app_domain}'+newUrl;
				var price = Number(parseFloat(vm.product.money/100.0)).toFixed(2);
				//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
				wx.onMenuShareTimeline({
				    title: vm.product.share_name+'为您推荐-'+vm.product.product_name+'正在热销中，只要'+price+'/'+vm.product.unit_name+'快来购买吧', // 分享标题,
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
				    title: vm.product.share_name+'为您推荐', // 分享标题
				    desc: vm.product.product_name+'正在热销中，只要'+price+'/'+vm.product.unit_name+'快来购买吧', // 分享描述
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
					title: vm.product.share_name+'为您推荐', // 分享标题
				    desc: vm.product.product_name+'正在热销中，只要'+price+'/'+vm.product.unit_name+'快来购买吧', // 分享描述
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