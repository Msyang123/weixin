<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-赠送购物车" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="zs-cart bg-white">
		<div data-role="main">
			<div class="carthead">
				<div class="btn-back">
					<a onclick="toPresent();"><img height="20px"
						src="resource/image/icon/icon-back.png" /></a>
				</div>
				<div>礼物清单</div>
				<div class="clear-cart" onclick="clearCart();">清空</div>
			</div>
			
			<div id="historyp">
				<#if (proList??)&&(proList?size>0)>
				<form id="presentForm" action="${CONTEXT_PATH}/presentOrder" method="post" data-ajax="false">
					<table id="pro_list">
						<!-- 商品列表开始 -->
						<#list proList as item>
						<tr>
						    <td width="10%"> 
						        <input type="checkbox" id="zs_fruit${item.product.pf_id}" name="zs_fruit" checked="checked" value="${item.product.pf_id}" 
						        	onclick="addToOrder(${item.product.real_price},${item.product.pf_id});" data-role="none"/>
						    </td>
							<td width="25%">
							    <img class="pro-img" src="${item.product.save_string!}" onclick="fruitDetial('${item.product.pf_id}')" />					
							</td>
							<td width="30%">
								<div class="font_blod">
									${item.product.product_name} 
									<span>${item.product.product_amount}${item.product.base_unitname!}/${item.product.unit_name!}</span>
								</div>
								<div class="font_price" id="productPrice${item.product.pf_id}"
									value="${item.product.real_price!0}">￥${(item.product.real_price!0)/100}</div>
							</td>
							<td width="35%">
								<div class="number-change">
									<div class="number-change-icon" onclick="addToCart('${item.product.id}','${item.product.pf_id}');">
										<img height="25px" src="resource/image/icon/icon-plus.png" />
									</div>
									<div class="number-change-icon">
										<span id="productNumDisplay${item.product.pf_id}">${item.productNum}</span>
									</div>
									<div class="number-change-icon" onclick="delFromCart('${item.product.id}','${item.product.pf_id}');">
										<img height="25px" src="resource/image/icon/icon-cut.png" />
									</div>
								</div>
							</td>
						</tr>
						</#list>
						<!-- 商品列表结束 -->
					</table>
					
					<div class="cartfoot row no-gutters align-items-center">
						<div class="col-6 cartsum">
							总价：<span>￥</span><span id="total_price">${(sum!0)/100}</span>
						</div>
						<div class="col-6 cartbutton" onclick="presentOrder();">赠送</div>
					</div>
				</form>
				<#else> <!-- 当购物车为空时显示-->
				<div class="empty-cart">
					<img src="resource/image/icon/gift_empty.png" /><br/>
					<span>赠人水果，手有余香</span>
				</div></#if>
			</div>
		</div>
	</div>
	
<#include "/WEB-INF/pages/common/share.ftl"/>	
<script src="plugin/jQuery/json2.js"></script>
<script src="plugin/common/productDetial.js"></script>
<script>
	//清空购物车
	function clearCart() {
		if($.cookie('zscartInfo')==null){
			$(this).css("color","gray");
			return false;
		}
		$.dialog.message("确认清空赠送吗？",true,function(){
			$.cookie('zscartInfo', null, {
				path : "/",
				expires : -1
			});
			window.location.href = "${CONTEXT_PATH}/zscart" ;
		});
		return false;
	}
	//勾选或者取消勾选
	function addToOrder(real_price,pf_id){
		var productNum=parseFloat($("#productNumDisplay"+pf_id).html());
		var totalPrice=parseFloat($("#total_price").html());
		if($("#zs_fruit"+pf_id).is(':checked')){
			$("#total_price").html((totalPrice+productNum*real_price/100).toFixed(2));
		}else{
			$("#total_price").html((totalPrice-productNum*real_price/100).toFixed(2));
		}
	}
	//添加商品到购物车
	function addToCart(productId, pfId) {
		var new_historyp = '{"product_id":"' + productId
				+ '","product_num":"1","pf_id":"' + pfId + '"}';
		if ($.cookie('zscartInfo') == null) {//cookie 不存在     
			$.ajax({ 
				url: "${CONTEXT_PATH}/activity/restrict", 
				data: {count:1,productFId:pfId}, 
				success: function(data){
					if(data.isLimit){
						$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
					}else{
				   		new_historyp = '[' + new_historyp + ']';
						$.cookie('zscartInfo', new_historyp, {
							expires : 15,
							path : '/'
						});
			     	}
		     	}
		   });
		} else {//cookies已经存在,就将存储的cookie取出然后判定是已经加入的还是新的，原来的直接覆盖
			//新的就加进来,一般情况下不会发生，因为此页面没有加入新商品的入口
			//将字符串转换成json对象
			var old_historyp_json = JSON.parse($.cookie('zscartInfo')),flag=false,index=0,count=1;
			for (var i = 0; i < old_historyp_json.length; i++) {
				if (old_historyp_json[i].pf_id == pfId) {
					count = parseInt(old_historyp_json[i].product_num) + 1;
					index=i;
					flag=true;
					break;
				}
			}
			$.ajax({ 
				url: "${CONTEXT_PATH}/activity/restrict", 
				data: {count:count,productFId:pfId}, 
				success: function(data){
					if(data.isLimit){
						$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
					}else{
				   		old_historyp_json[i].product_num = parseInt(old_historyp_json[i].product_num) + 1;
						//给显示商品购物车数量加上1
						$('#productNumDisplay' + pfId).html(old_historyp_json[index].product_num);
						//计算总价格
						$("#total_price").html(
								new Number(parseFloat($("#total_price").html())
										+ (parseInt($("#productPrice" + pfId).attr("value")) / 100)).toFixed(2));
						//将json对象转换成字符串存cookie
						$.cookie('zscartInfo', JSON.stringify(old_historyp_json), {
							expires : 15,
							path : '/'
						});				
				     }
		     	}
		   });
		}
	}
	//从购物车删除商品
	function delFromCart(productId, pfId) {
		if ($.cookie('zscartInfo') != null) {
			//将字符串转换成json对象
			var old_historyp_json = JSON.parse($.cookie('zscartInfo'));
			for (var i = 0; i < old_historyp_json.length; i++) {
				if (old_historyp_json[i].pf_id == pfId) {
					var productNum = parseInt(old_historyp_json[i].product_num);
					if (productNum > 1) {
						old_historyp_json[i].product_num = productNum - 1;
						//给显示商品购物车数量减去1
						$('#productNumDisplay' + pfId).html(
								old_historyp_json[i].product_num);
						//计算总价格
						$("#total_price").html(
								new Number(parseFloat($("#total_price").html())
										- (parseInt($("#productPrice" + pfId)
												.attr("value")) / 100))
										.toFixed(2));
						$.cookie('zscartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
					}else{
						$.dialog.message("确认删除该商品吗？",true,function(){
							old_historyp_json.splice(i, 1);
	          				//将json对象转换成字符串存cookie
	          	          	$.cookie('zscartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
	          	          	window.location.href = "${CONTEXT_PATH}/zscart" ;
						});
					}
					break;
				}
			}
		}
	}
	function presentOrder(){
		if($("input[name='zs_fruit']").is(':checked')){
			$('#presentForm').submit();
	     }else{
	     	$.dialog.alert("请先选择要赠送的商品！");
	     	return;
	     } 
	}       
	function toPresent() {
		window.location.href = "${CONTEXT_PATH}/present";
	}
	
</script>
</body>
</html>