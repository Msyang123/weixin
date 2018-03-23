<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-购物车" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<div id="main" data-role="page" class="bg-white">
	<div id="cart" data-role="main">
		<div style="margin-bottom:113px">
			<div class="carthead">
				<div class="cart-label">购物车 
				<span class="cart-clear" onclick="clearCart();">清空</span>
				</div>
			</div>
			<#if (proList??)&&(proList?size>0)>
			<div class="mt41 redTips">还差<span id="differ_money">10</span>元即可享受免费送货上门服务，<a href="${CONTEXT_PATH}/main" data-ajax="false">再看看吧</a></div>
		    <!-- <div class="prohead">商品清单</div> -->
			<table id="pro_list">
				<!-- 商品列表开始 -->
				<#list proList as item>
					<tr>
						<td width="30%">
							<img class="pro-img" src="${item.product.save_string!}" onclick="fruitDetial('${item.product.pf_id}')" onerror="common.imgLoad(this)"/>
						</td>
						<td width="37%">
							<p class="pro-name">
								${item.product.product_name!}
							</p>
							<p class="pro-norms">
								${item.product.product_amount!}${item.product.base_unitname!}
								<span>/${item.product.unit_name!}</span>
							</p>
							<p class="pro-price" id="productPrice${item.product.pf_id}" value="${item.product.real_price!0}">￥${(item.product.real_price!0)/100}</p>
						</td>
						<td width="33%">
							<div class="opreation">
								<div class="opreat" onclick="addToCart('${item.product.id}','${item.product.pf_id}');">
									<img height="25px" src="resource/image/icon/icon-plus.png" />
								</div>
								<div class="opreat">
									<span id="productNumDisplay${item.product.pf_id}">${item.productNum!}</span>
								</div>
								<div class="opreat" onclick="delFromCart('${item.product.id}','${item.product.pf_id}');">
									<img height="25px" src="resource/image/icon/icon-cut.png" />
								</div>
							</div>
						</td>
					</tr>
				</#list>
				<!-- 商品列表结束 -->
			</table>
		
		</div>
		
		<div class="cartfoot">
			<!-- <div class="cartbutton" style="margin-left:1px;" onclick="giftBalance('${(sum!0)}')">赠送</div> -->
			<div class="cartbutton" id="balance">购买</div>
			<div class="cart-sum">总价：<span>￥</span><span id="total_price">${(sum!0)/100}</span></div>
		</div>
		<#else>
		<!-- 当购物车为空时显示-->	
		<div class="empty-box">
			<img src="resource/image/icon/cry.png" />
			<p>购物车好寂寞，快用<a onclick="toMain()">水果</a>填满我<p>
		</div> 
		</#if>
	</div>
</div>

<div class="navbar-footer">
	<div class="ui-grid-b">
		<div class="ui-block-a mainmenu" id="mainPage">
			<img id="mainImg" src="${CONTEXT_PATH}/resource/image/icon/icon-index.png" /><br /><span>首页</span>
		</div>
		<div class="ui-block-b mainmenu" id="cartPage">
			<img id="cartImg" src="${CONTEXT_PATH}/resource/image/icon/shop-cart-on.png" /><br /><span class="icon-text">购物车</span>
		</div>
		<div class="ui-block-c mainmenu" id="selfPage">
			<img id="selfImg" src="${CONTEXT_PATH}/resource/image/icon/icon-me.png" /><br /><span>我的</span>
		</div>
	</div>
</div>
	
<#include "/WEB-INF/pages/common/share.ftl"/>
<script src="plugin/jQuery/json2.js"></script>
<script src="plugin/common/productDetial.js"></script>
<script src="plugin/common/location.js"></script>
<script data-main="scripts/main" src="resource/scripts/vconsole.min.js"></script>
<script>
	$(function(){
		//alert($.cookie('cartInfo'));
		//var vConsole = new VConsole();
		
		$("#mainPage").click(function(){
			  window.location.href = "${CONTEXT_PATH}/main";
		});
		
		$("#selfPage").click(function(){
			window.location.href = "${CONTEXT_PATH}/me";
		});
		
		$('#balance').click(function(){
		    var balance = parseFloat($("#total_price").html())*100;
			window.location.href="${CONTEXT_PATH}/order";
		});
		differMoney();
	});

	//清空购物车
	function clearCart(){
		if($.cookie('cartInfo')==null){
			$(this).css("color","gray");
			return false;
		}
		$.dialog.message("确认清空购物车吗？", true, function(){
			$.cookie('cartInfo',null,{path:"/",expires: -1});
			window.location.reload();
		});
		return false;
	}
	
	//添加商品到购物车
	function addToCart(productId,pfId){
		var new_historyp='{"product_id":"'+productId+'","product_num":"1","pf_id":"'+pfId+'"}';
		//防止用户点击过快导致js来不及执行
		var nowTime = new Date().getTime();
	    var clickTime = $(this).attr("ctime");
	    if( clickTime != 'undefined' && (nowTime - clickTime < 500)){
	    	$.dialog.alert('慢点儿~');
	        return false;
	    }else{
	    	$(this).attr("ctime",nowTime);
	        
			if($.cookie('cartInfo')==null){    
				  $.ajax({ 
						url: "${CONTEXT_PATH}/activity/restrict", 
						data: {count:1,productFId:pfId}, 
						success: function(data){
							if(data.isLimit){
								$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
							}else{
								new_historyp='['+new_historyp+']';
		          				$.cookie('cartInfo',new_historyp,{expires:15,path:'/'});
							}
						}
				  }); 
	     	}else{
		          var old_historyp_json=JSON.parse($.cookie('cartInfo'));
		          var flag=false,index=0;
		          for(var i=0;i<old_historyp_json.length;i++){
		          	if(old_historyp_json[i].pf_id==pfId){
		          		flag=true;
		          		index=i;
		          		break;
		          	}
		          }
		          if(flag){
		          	 $.ajax({ 
							url: "${CONTEXT_PATH}/activity/restrict", 
							data: {count:parseInt(old_historyp_json[index].product_num)+1,productFId:pfId}, 
							success: function(data){
								if(data.isLimit){
									$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
								}else{
									old_historyp_json[i].product_num=parseInt(old_historyp_json[index].product_num)+1;
					          		//给显示商品购物车数量加上1
						          	$('#productNumDisplay'+pfId).html(old_historyp_json[index].product_num);
						          	//计算总价格
						          	$("#total_price").html(
						          		new Number(parseFloat($("#total_price").html())+(parseInt($("#productPrice"+pfId).attr("value"))/100)).toFixed(2)
						          	);
						          	differMoney();
						          	//将json对象转换成字符串存cookie
		          					$.cookie('cartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
								}
							}
				     });
				  }	
	         }
	     }
	}
	
	//从购物车删除商品
	function delFromCart(productId,pfId){
		//防止用户点击过快导致js来不及执行
		var nowTime = new Date().getTime();
	    var clickTime = $(this).attr("ctime");
	    if( clickTime != 'undefined' && (nowTime - clickTime < 500)){
	    	$.dialog.alert('慢点儿~');
	        return false;
	    }else{
	    	$(this).attr("ctime",nowTime);
	    	
			if($.cookie('cartInfo')!=null){
		          //将字符串转换成json对象
		          var old_historyp_json=JSON.parse($.cookie('cartInfo'));
		          for(var i=0;i<old_historyp_json.length;i++){
			          	if(old_historyp_json[i].pf_id==pfId){
			          		var productNum=parseInt(old_historyp_json[i].product_num);
			          		if(productNum>1){
				          		old_historyp_json[i].product_num=productNum-1;
				          		//给显示商品购物车数量减去1
				          		$('#productNumDisplay'+pfId).html(old_historyp_json[i].product_num);
				          		//计算总价格
					          	$("#total_price").html(
					          		new Number(parseFloat($("#total_price").html())-(parseInt($("#productPrice"+pfId).attr("value"))/100)).toFixed(2)
					          	);
					          	differMoney();
					          	//将json对象转换成字符串存cookie
					            $.cookie('cartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
			          		}else{
			          			$.dialog.message("确认删除该商品吗？", true,function(){
			          				old_historyp_json.splice(i, 1);
			          				//将json对象转换成字符串存cookie
			          	          	$.cookie('cartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
			          	          	window.location.reload();
			          			});
			          		}
			          		break;
			          	}
		          }
	         }
	    }
	}
	
	function differMoney(){
		var differMoney = (38-parseFloat($("#total_price").html())).toFixed(2);
		$("#differ_money").html(differMoney);
		if(differMoney<=0){
			$(".redTips").hide();
			$("#pro_list").addClass("mt41");
		}else{
			$(".redTips").show();
			$("#pro_list").removeClass("mt41");
		}
	}
	
	function giftBalance(amount){
		window.location.href="${CONTEXT_PATH}/gift?balance="+amount;
	}
	
	function toMain(){
		window.location.href="${CONTEXT_PATH}/main";
	}
</script>
</body>
</html>