<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-订单" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order" class="tx-order">
	
		<div class="orderhead">
			<div class="btn-back">
				<a onclick="back();"><img height="20px"
					src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div>抽奖订单</div>
		</div>
		
		<div data-role="main" class="mt61">
			<form id="txOrderForm" action="${CONTEXT_PATH}/activity/cjOrderCmt" method="post" data-ajax="false">
				<input type="hidden" name="order.deliverytype" value="1"/>
				<input type="hidden" id="proList" name="proList" value="${proList!}"/>
				<input type="hidden" id="user_award_id" name="user_award_id" value="${user_award_id!}"/>
				<input type="hidden" id="storeId" name="storeId" value="${storeId!}"/>
				<table style="width: 100%;border-collapse:collapse;">
					<tr>
						<td class="order-left">配送方式：</td>
						<td class="order-right">
							<select data-mini="true" name="order.deliverytype" id="psfs">
								<option value="1">门店自提</option>
							</select>
						</td>
				    	</tr>
					<tr class="select-store-box">
						<td class="order-left">选择门店：</td>
						<td class="order-right">
							<select name="order.order_store" data-mini="true" id="md">
								<#list storeList as item> 
									<option value="${item.store_id}"  
									<#if item.store_id == storeId>
										selected=true
									</#if>
									>${item.store_name}</option> 
								</#list> 
							</select>
						</td>
					</tr>
				</table>
			</form>
			
			<div class="cartfoot">
				<div id="txCmt" class="cartbutton">确认提货</div>
			</div>
		</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
    <script data-main="scripts/main" src="plugin/dateTime/js/mobiscroll.js"></script>
	<script data-main="scripts/main" src="plugin/dateTime/js/PluginDatetime.js"></script>
	<script src="plugin/jQuery/json2.js"></script>	
	<script>
		var CONTEXT_PATH='${CONTEXT_PATH}';
		var ajaxSettings = {
			async: false,
			type: "POST",
			url: "${CONTEXT_PATH}/storeList",
			data: {flag: 1},
			dataType: "json"
		};
		
		//当前位置
		if($.cookie('storeInfo')==null){
			var currentPoint ={
					data:{lat:28.119658,lng:113.008950}
			};
		}else{
			var storeInfoJson=JSON.parse($.cookie('storeInfo'));
			var currentPoint ={
					data:{lat:storeInfoJson.storeLat,lng:storeInfoJson.storeLng}
			};
		}
		
		$(function(){
			//门店列表
			ajaxSettings.data.flag = 1;
	    	ajaxSettings.data.lat = currentPoint.data.lat; 
			ajaxSettings.data.lng = currentPoint.data.lng; 
			setStoreSelectOptions(ajaxSettings,true);
			
			$("#txCmt").on("click",function(){
               	$('#txOrderForm').submit();	  
			});
		});
	
		function setStoreSelectOptions(settings){
	    	$.ajax(settings).done(function(list){
	    		var storeId = $.cookie('store_id');
	    		
	    		if(list){
	    			var select = $("#md");
	    			select.empty();
		    		$.each(list, function(i, o){
		    			if(o){
			    			var option = $("<option></option>");
			    			if(o["distance"]){
				    			option.val(o.store_id).text(o.store_name + "(约" + o.distance + "km)");
			    			}else{
				    			option.val(o.store_id).text(o.store_name);
			    			}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
							select.append(option); 
		    			}
		    		});
		    		select.find("option[value='"+storeId+"']").attr("selected",true);
		    		$("#md-button span").html($("#md").find("option:selected").text());
	    		} 
	    	});
		}
		
		function back(){
			window.location.href='${CONTEXT_PATH}/activity/myTwoCodeLottery';
		}
	</script>
</body>
</html>