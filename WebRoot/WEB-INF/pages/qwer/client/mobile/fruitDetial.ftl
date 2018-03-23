<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
    <meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-${product.product_name!}" />
    <#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<div data-role="page" id="fruit_detail">

  	<div data-role="main" class="bg-white">
	  	<div class="carthead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px"
						src="resource/image/icon/icon-back.png" /></a>
				</div>
				<div>产品详情</div>
	    </div>
			
	    <div class="mt41"></div>
	  	<!--商品主图-->
	  	<div class="pro-img js-product-img">
		    <img src="${product.save_string!}" onerror="common.imgLoadMaster(this)"/>
		</div>
		<!--轮播图-->	
		<!--商品详情属性-->
		<div id="product_detail" class="row no-gutters justify-content-between align-items-center mt5">
            <div class="col-6 text-left">  
					<span class="pro-name">${product.product_name!}</span><br/>
					<!--暂时先屏蔽这个字段-->
					<!--<span class="pro-num-norms"> ${product.product_f_des!}/${product.unit_name!}</span><br/> -->
		    		<span class="pro-norms">已售<i class="brand-red-new">${product.saleCount!0}</i>件</span><br/>
		    		<span class="pro-norms">单位：${product.unit_name!}&nbsp;&nbsp;规格：${product.standard!}</span>
		    </div>
		    <div class="col-6 align-self-end">  	
				<#if product.real_price??>
				    <p class="pro-price"><!--如果为正常情况  价格:-->
						<span class="text-del">￥${(product.price!0)/100}</span>
						<span class="proprice" value="${product.real_price!0}">￥${(product.real_price!0)/100}</span>
					</p>
				<#else>
					<p class="pro-price">
						<span class="proprice <#if product.inv_enough=='false'>unenough-price</#if>" 
							value="${product.price!0}">￥${(product.price!0)/100}</span>
					</p>
				</#if>
				<div id="boll${product.id}" class="boll"></div>		
				<#if product.inv_enough=="true">
					<button class="btn-purchase addToCart" val="${product.id}" pfId="${product.pf_id}" data-role="none">加入购物车</button>
					<button class="btn-purchase goToBuy ml5" val="${product.id}" pfId="${product.pf_id}" data-role="none" style="padding:5px;border:none;">立即购买</button>
				</#if>
           </div>
           <#if product.inv_enough=="false"><div class="no-enough"></div></#if>
		</div>
	  	<!--商品详情属性-->

		<!--推荐商品-->
		<div class="maintop"><i></i> 为您推荐 <i></i></div>
		
		<div class="ui-grid-b maindiv both-padding mt10 mb8">
			  <#list detialProductRecommends as item>
				<div 
					<#if item_index%3==0>
						class="ui-block-a"
					<#elseif item_index%3==1>
						class="ui-block-b"
					<#elseif item_index%3==2>
						class="ui-block-c"		
					</#if>
				>
					<div onclick="fruitDetial('${item.pf_id}');"
						 class="prodiv ml5">
						<img src="${item.save_string!}" /> 
							<p class="proname">${item.product_name!}</p> 
							<#if item.real_price??>
							    <!--如果为特价情况  价格:-->
									<p class="proprice">￥${(item.real_price!0)/100}/${item.unit_name!}</p>
							<#else>
									<p class="proprice">￥${(item.price!0)/100}/${item.unit_name!}</p>
							</#if>
					</div>
					
				</div>
			 </#list>	
		</div>
	<!--推荐商品-->
	<!--商品详情属性-->
		<div class="ui-grid-solo bg-white mt10" id="detail">
			<div class="detial-top">详细介绍</div>
			<div class="detail_introduce">
				<#if product.product_detail??>
					<#if product.product_detail.indexOf("<img")!=-1>
						${product.product_detail}
					<#else>
						<#list product.product_detail?split(",") as img >
							<img width="100%" style="vertical-align:top;" 
							src="resource/image/fruitDetial/${img}"/>
						</#list>
					</#if>
				<#else>
					暂无数据
				</#if>
			</div>
		</div>	
	<!--商品详情属性-->
  	</div>
  	
  	<div id="cart">
  		<div id="cart_img"><img src="resource/image/icon/shopping-basket.png"/></div>
  		<div id="cart_num"></div>
  	</div>
  	
  	<div class="btn-home">
  		<img src="resource/image/icon/icon-toHome.png">
  	</div>
</div> 

    <#include "/WEB-INF/pages/common/share.ftl"/>    
	<script src="plugin/jQuery/json2.js"></script>
    <script src="plugin/gw/parabola.js"></script>
    <script src="plugin/common/productDetial.js"></script>
	<script src="plugin/common/location.js"></script>
    <script> 
		$(function() {
		    var num = 0;
			if('${proNum}'){
				num = '${proNum}';
			}
			$("#cart_num").html(num);
			if(num==0){
				$("#cart_num").css("display","none");
			}
			
			$(".goToBuy").click(function(){
				var pId=$(this).attr('val');
				var pfId=$(this).attr('pfId');
				
				//先去查库存
				$.ajax({
					url: "${CONTEXT_PATH}/queryStoreInv", 
					data: {product_id:pId}, 
				    success: function(result){
						if(!(result&&result.inv_enough)){
							$.dialog.alert("该门店库存不足\n换个门店试试吧");
						}else{
						    //库存充足后判断购买限制
						    $.ajax({ 
								url: "${CONTEXT_PATH}/activity/restrict", 
								data: {count:1,productFId:pfId}, 
								success: function(data){
									if(data.isLimit){
										$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
									}else{
										window.location.href="${CONTEXT_PATH}/order?pId="+pId+"&pfId="+pfId;
									}
								}
							});	
						}
				    }			
				});
				
			});
			
			$("#cart").click(function(){
				window.location.href="${CONTEXT_PATH}/cart";
			});
			
			$(".btn-home").click(function(){
				window.location.href="${CONTEXT_PATH}/main?index=0";
			});
			
			var date = new Array();
			
			$(".addToCart").click(function(e){
				date.push(new Date());
				
				if (date.length > 1 && (date[date.length - 1].getTime() - date[date.length - 2].getTime() < 1000)){
					e.cancelBubble = true;
					return false;
				}
				var val=$(this).attr("val");
				var pfId=$(this).attr('pfId');
				var flag=false,index=0;
				var _sourceImg=$('.js-product-img').find('img');
					
			    var _back=function(){
			       //添加到购物车cookie处理
			       addToCart(val,pfId);
			    };
			    
	            var _target=$("#cart_img");
	            //common.objectFlyIn(_sourceImg,_target,_back);
				//查找购物车cookie中是否有指定商品
				if($.cookie('cartInfo')!=null){
					var old_historyp_json=JSON.parse($.cookie('cartInfo'));
			       
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
          		
          		$.ajax({
					url: "${CONTEXT_PATH}/queryStoreInv", 
					data: {product_id:val}, 
				    success: function(result){
							if(!(result&&result.inv_enough)){
								$.dialog.alert("该门店库存不足\n换个门店试试吧");
							}else{
							    //库存充足后判断购买限制
							    $.ajax({ 
									url: "${CONTEXT_PATH}/activity/restrict", 
									data: {count:count,productFId:pfId}, 
									success: function(data){
										if(data.isLimit){
											$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
										}else{						
											common.objectFlyIn(_sourceImg,_target,_back);
								        }
							        }
							    });
							}
				    }			
				});
				
			});
			  		
			function addToCart(pId,pfId){
				//添加到购物车cookie处理
			    	var num = parseInt($("#cart_num").html());
					if(num==0){
						$("#cart_num").css("display","block");
					}
					$("#cart_num").html(num+1);
					var new_historyp='{"product_id":"'+pId+'","product_num":"1","pf_id":"'+pfId+'"}';
					if($.cookie('cartInfo')==null){//cookie 不存在     
			          new_historyp='['+new_historyp+']';
			          $.cookie('cartInfo',new_historyp,{expires:15,path:'/'});
			     	}else{//cookies已经存在,就将存储的cookie取出然后判定是已经加入的还是新的，原来的直接覆盖
			     	//新的就加进来,一般情况下不会发生，因为此页面没有加入新商品的入口
			          //将字符串转换成json对象
			          var old_historyp_json=JSON.parse($.cookie('cartInfo'));
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
							    "product_id" : pId,
							    "product_num" : 1,
							    "pf_id":pfId
							}
						old_historyp_json.push(item);
					   }
			          //将json对象转换成字符串存cookie
			          $.cookie('cartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
			         }
			}
		 });
		 
		function back(){
		    window.history.back();
		}
		
		//发送Ajax去请求与路径相匹配的分享模板
		$.ajax({
		    type:'Get',
			url: "${CONTEXT_PATH}/share",
		    success: function(result){
		          if(result){
		               //组织要替换的模板值
		               var jsonObj=new Object();
		               jsonObj.Username=result.tUserSession.nickname;
		               jsonObj.product_name="${product.product_name!}";
		               jsonObj.price="${(product.real_price!0)/100}";
		               jsonObj.picture=result.share.picture.indexOf("{{")>=0?
		               '${app_domain}/${product.save_string?substring(8)}': 
		               '${app_domain}'+result.share.picture.replace("/weixin","");
		               jsonObj.product_unit="${product.unit_name!}";
		               console.log(jsonObj);
		              
		               //使用Mustache替换
		               var title=Mustache.render(result.share.title,jsonObj);
		               var desc=Mustache.render(result.share.content,jsonObj);
		               var link='${app_domain}/fruitDetial?pf_id=${product.pf_id}';
		               var imgUrl=jsonObj.picture;
		               
		               console.log(title+'\r\n'+desc+'\r\n'+link+'\r\n'+imgUrl);
		               
		               var shareData={
		                  title:title,
						  desc:desc,
						  link:link,
						  imgUrl:imgUrl,
						  success:function(){
						     //分享成功回调函数
						  },
						  cancel:function(){
						    //分享取消回调函数
						  }
		               };
		               
		               //调用封装好的微信分享函数
		               wx.ready(function(){
						  var share=new wxShare(shareData);
						  share.bindWX();
					   });
		          }   
		    }			
		});
		
     </script>
</body>
</html>