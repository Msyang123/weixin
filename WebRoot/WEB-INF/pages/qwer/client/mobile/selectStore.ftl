<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-选择门店" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<div id="main" data-role="page">
	<div data-role="main">
		<div hidden>
			<input id="lat" value="28.119658" />
			<input id="lng" value="113.008950" />
			<input type="hidden" id="addressName"/>
		</div>
		<div class="carthead bg-pink">
			<div class="btn-back">
				<a onclick="back();"><img height="20px" src="resource/image/icon/back_white.png" /></a>
			</div>
			<div>门店定位</div>
		</div>
		<div class="bg-pink adress-details row mt41" id="selectAddress">
			<div class="col-2">
				<img src="resource/image/icon/dizhi_icon.png" class="left-img">
			</div>
			<div class="col-8 text-left nopd-lr">
				<div class="location-box">
				
				</div>
				<div class="delivery-box">
					<input type="hidden" name="order.receiver_name" id="receiver_name" />
					<input type="hidden" name="order.receiver_mobile" id="receiver_mobile"/>
					<input type="hidden" name="order.address_detail" id="address_detail"/>
					
					<h4><span id="user_name"></span><span id="user_phone"></span></h4>
					<p id="user_adr"></p>
				</div>
			</div>
			<div class="col-2 text-right">
				<img src="resource/image/icon/next_white.png" class="gonext-img"> 
			</div>
		</div>
		
		<div class="selectStore-box">
			<div class="now-adr text-left">
				当前选择的门店：
				<span id="near_store">

				</span>
				<img src="resource/image/icon/dingwei_icon.png" id="reposition_btn">
			</div>
			<div class="selectStore-more">
				<div class="selectStore-list row">
					<#list storeList as item>
						<div class="store-items col">
							<input type="hidden" class="nowStoreId" value="${item.store_id}"/>
							<a>${item.store_name}</a><span><#if item.distance??>${item.distance?substring(0,item.distance?index_of(".")+2)}</#if></span>km
						</div>
					</#list>
				</div>
				<div id="go_more">查看更多 >></div>
			</div>
		</div>
	</div>
</div>
<div id="loading-mask" style="display:none;">
	<img src="resource/image/icon/loading.gif">
	<p class="mt10">定位中，请等待</p> 
</div>
<#include "/WEB-INF/pages/common/share.ftl"/>
<script charset="utf-8" src="https://map.qq.com/api/js?v=2.exp"></script>
<script>
$(document).ready(function(){
		/*初始化console*/
		//根据是否有默认收货地址 来决定是显示当前定位还是收货地址
		if($.cookie('deliverInfo')==null){
			$("#loading-mask").show();
			wx.ready(function() {
				wx.getLocation({
				    type: 'wgs84',
				    success: function (res) {
				    	$("#lat").val(res.latitude);
						$("#lng").val(res.longitude);
						$("#loading-mask").hide();
						showAddress(res.latitude,res.longitude);
					},
					fail: function (err) {
						$("#loading-mask").hide();
						$.dialog.alert("请允许访问您的位置 ; )");
				    },
				    cancel:function(res){
				    	$("#loading-mask").hide();
						$.dialog.alert("请允许访问您的位置 ; )");
				    },
				    complete:function(info){
				    	$("#loading-mask").hide();
				    }
				});
			})
		}else{
			//显示收货地址
			$('.delivery-box').show();
			$('.location-box').hide();
			
			var deliverInfoJson=JSON.parse($.cookie('deliverInfo'));
			$("#user_name").html(deliverInfoJson.adrName);
			$("#user_phone").html(deliverInfoJson.adrMobile);
			$("#user_adr").html(deliverInfoJson.adr);
		}
		
		var storeInfoJson=JSON.parse($.cookie('storeInfo'));
		$("#near_store").html(storeInfoJson.storeName);
		//点击查看更多
		goMore();
		
		//腾讯地图反查经纬度
		var geocoder, map, marker = null;
        geocoder = new qq.maps.Geocoder();
        
		$("#selectAddress").on("click", function(){
			wx.ready(function() {
				wx.openAddress({
					success: function(res){
						var addressStr = res.provinceName + res.cityName + res.detailInfo;
						var address = '中国,'+res.provinceName+','+res.cityName+','+res.detailInfo;
    					//对指定地址进行解析
			            geocoder.getLocation(address);
			            //设置服务请求成功的回调函数
			            geocoder.setComplete(function(result) {
				            //回填信息给页面展示用和给隐藏域赋值
			            	$("#user_name").html(res.userName);
							$("#user_phone").html(res.telNumber);
							$("#user_adr").html(addressStr.replace(/\s/g, ""));
						
							$("#receiver_name").val(res.userName);
							$("#receiver_mobile").val(res.telNumber);
							$("#address_detail").val(addressStr.replace(/\s/g, ""));
							
							$(".delivery-box").show();
							$(".location-box").hide();
							
							var oName = $("#receiver_name").val();
							var oMobile = $("#receiver_mobile").val();
							var oAddress = $("#address_detail").val();
							
							if( 	oName!=null &&oName!=""
									&&oMobile!=null &&oMobile!=""
									&&oAddress!=null &&oAddress!=""){
							
								var deliverInfo = '{"adrName":"'+oName+'","adrMobile":"'+oMobile+'","adr":"'+oAddress+'"}';
			            		$.cookie('deliverInfo',deliverInfo,{expires:15,path:'/'});
			            		
								refreshList(result.detail.location.lat,result.detail.location.lng);
								
								//一旦有了收货地址 无论什么时候进入列表都是以收货地址排序
								var adrStoreName = $("#addressName").val();
// 								console.log($("#addressName").val());
			            		var adrStoreInfo = '{"storeLat":"'+result.detail.location.lat+'","storeLng":"'+result.detail.location.lng+'","storeName":"'+adrStoreName+'"}';
			            		$.cookie('adrStoreInfo',adrStoreInfo,{expires:15,path:'/'});
							}
			    	
			            });
			            //若服务请求失败，则运行以下函数
			            geocoder.setError(function() {
			                $.dialog.alert("出错了，请输入正确的地址！！！");
			            });
						
					},
		            cancel: function (res) { }
				});
			});
		});
		
		//选择某一个门店
		$(".selectStore-list").on("click",".store-items",function(){
			goMore();
			var nowName = $(this).find('a').html();
			var nowStoreId=$(this).find(".nowStoreId").val();
			$("#near_store").html(nowName);
			
			//因为选择门店时不需要刷新列表 所以经纬度就储存当前定位的经纬度
			var storeInfo = '{"storeLat":"'+$("#lat").val()+'","storeLng":"'+$("#lng").val()+'","storeName":"'+nowName+'"}';
    		$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
    		$.cookie('store_id',nowStoreId,{expires:15,path:'/'});
    		
    		window.location.href="${CONTEXT_PATH}/main";
		})
		
		//重新定位
		$("#reposition_btn").click(function(){
			getPosition();
			refreshList($("#lat").val(),$("#lng").val());
			showAddress($("#lat").val(),$("#lng").val());
			
			$.cookie('deliverInfo',null,{path:"/",expires: -1});
			$.cookie('adrStoreInfo',null,{path:"/",expires: -1});
		})
	});
	
	function getPosition(){
		$("#loading-mask").show();
		wx.ready(function() {
			wx.getLocation({
			    type: 'wgs84',
			    success: function (res) {
			    	$("#lat").val(res.latitude);
					$("#lng").val(res.longitude);
					$("#loading-mask").hide();
				},
				fail: function (err) {
					$("#loading-mask").hide();
					$.dialog.alert("请允许访问您的位置 ; )");
			    },
			    cancel:function(res){
			    	$("#loading-mask").hide();
					$.dialog.alert("请允许访问您的位置 ; )");
			    },
			    complete:function(info){
			    	$("#loading-mask").hide();
			    }
			});
		})
	}
	
	function back() {
		window.location.href="${CONTEXT_PATH}/main";
	}
	
	function refreshList(oLat,oLng){
		$.ajax({
            type: "POST",
            url: "${CONTEXT_PATH}/storeList",
            data:{lat:oLat,lng:oLng,flag:1},
            dataType: "json",
            success: function(data){
            	if(data){
            		$(".selectStore-list").html("");
            		var storeId = data[0].store_id;
            		var len=data.length;
            		
                    for(var i=0;i<len;i++){
                    	var markup = '<div class="store-items col">'+
                    			'<input type="hidden" class="nowStoreId" value="'+
                    			data[i].store_id+'"/><a>'+
                       			data[i].store_name+'</a><span>'+
                       			data[i].distance+'</span>'+'km</div>';
                       	$(".selectStore-list").append(markup);
                    }
                    goMore();
            		$("#near_store").html(data[0].store_name);
            		$.cookie('store_id',storeId,{expires:15,path:'/'});
            		
            		$("#addressName").val(data[0].store_name);
//             		console.log($("#addressName").val());
            		//根据收货地址或者是定位来储存门店信息
            		var storeInfo = '{"storeLat":"'+oLat+'","storeLng":"'+oLng+'","storeName":"'+data[0].store_name+'"}';
            		$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
            	}
            }
    	});
	}
	
	//查看更多
	function goMore(){
		var el = $(".selectStore-list");
		curHeight = el.css('height', '190').height();
		$('#go_more').show();
	    $('#go_more').click(function(){
	    	autoHeight = el.css('height', 'auto').height();
			el.height(curHeight).animate({height: autoHeight}, 300);
			$(this).hide();
	    });
	}
	
	//根据经纬度查当前位置
	function showAddress(latitude,longitude){
		geocoder = new qq.maps.Geocoder({
			complete:function(result){
				$('.delivery-box').hide();
				$('.location-box').show();
				$(".location-box").html(result.detail.address);
			}
		});
		var coord = new qq.maps.LatLng(latitude,longitude);
		geocoder.getAddress(coord);
	}
</script>
</body>
</html>