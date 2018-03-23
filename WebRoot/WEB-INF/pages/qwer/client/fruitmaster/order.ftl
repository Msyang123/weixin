<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-订单结算或生成页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>
	<div id="order">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" onclick="back();">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>确认订单</span>
	    </header>
	    
	    <div class="u-tips">单笔订单38元起送，配送范围仅限门店2公里</div>
	    
	    <div class="mask"></div>
		<div class="loading"><img src="resource/image/icon/loading.gif"></div>
		
		<section class="container m-order-from">
		
			<form id="orderForm" action="${CONTEXT_PATH}/fruitShop/orderCmt" method="post">
			    <input type="hidden" name="isSingle" value="${isSingle!0}" />
			    <input type="hidden" name="order.lat" id="lat" value="0" />
				<input type="hidden" name="order.lng" id="lng" value="0" />
				
				<div class="u-address-box" id="selectAddress">
					<p class="select-text"  >选择收货地址</p>
					<div id="address_info" >
						<input type="hidden" name="order.receiver_name" id="receiver_name" />
						<input type="hidden" name="order.receiver_mobile" id="receiver_mobile"/>
						<input type="hidden" name="order.address_detail" id="address_detail"/>
						<p id="rcvname_text"></p>
						<p id="rcvmobile_text"></p>
						<p id="rcvaddress_text"></p>
					</div>
					<div class="u-btn-more">
						<img src="resource/image/icon-master/icon_more_single.png" />
					</div>
				</div>
				
				<div class="form-group row mt15">
					<label for="order.deliverytype" class="col-3 col-form-label">配送方式:</label>
					<div class="col-9">
					    <select name="order.deliverytype" class="form-control" id="psfs">
								<option value="1">门店自提</option>
								<#if (balance>=3800)>
								<option value="2">送货上门</option>
								</#if>
						</select>
					</div>
				</div>
					
				<div class="form-group row delivery_time">
					<label for="order.deliverytime" class="col-3 col-form-label">配送时间:</label>
					<div class="col-9">
					    <select id="deliverytime" name="order.deliverytime" class="form-control">
						</select>
					</div>
				</div>
				
				<div class="form-group row">
					<label for="order.order_store" class="col-3 col-form-label">选择门店:</label>
					<div class="col-9">
					    <select id="md" name="order.order_store" class="form-control">
						    <#list storeList as item> 
								<option value="${item.store_id}">${item.store_name}</option> 
							</#list> 
						</select>
					</div>
				</div>
				
				<#if !(session['wxUser'].phone_num??)>
					<div class="form-group row phone_num">
						<label for="" class="col-3 col-form-label">联系方式:</label>
						<div class="col-9">
						    <input id="phone_num" name="phone_num"  class="form-control"/>
						</div>
					</div>
				</#if>
				
				<div class="form-group row">
					<label for="" class="col-3 col-form-label">优惠券:</label>
					<div class="col-9">
					    <input placeholder="无可用优惠券" name="" readonly="readonly" class="form-control"/>
					</div>
				</div>
				<div class="form-group row">
					<label for="" class="col-3 col-form-label">我要留言:</label>
					<div class="col-9">
					    <textarea name="order.customer_note" id="customer_note" class="form-control" rows="5" oninput ="common.reExpression()"></textarea>
					</div>
				</div>
			</form>	
			
		</section>
		
		<footer class="m-account">
			<p>总价：<span>&yen; ${(balance!0)/100}</span></p>
			<a class="u-btn-account s-btn-brown" id="commit_btn">结算</a>
		</footer>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/dateTime/js/mobiscroll.js"></script>
	<script src="plugin/dateTime/js/PluginDatetime.js"></script>
	<script src="plugin/jQuery/jquery.cookie.js"></script>
	<script src="plugin/jQuery/json2.js"></script>		
	<script charset="utf-8" src="https://map.qq.com/api/js?v=2.exp"></script>
	<script>
		var CONTEXT_PATH='${CONTEXT_PATH}';
		
		var ajaxSettings = {
			async: false,
			type: "POST",
			url: "${CONTEXT_PATH}/storeList",
			data: {flag: 1},
			dataType: "json"
		};
		
		//初始化当前位置
		var currentPoint ={
			data:{lat:0,lng:0}
		};
		
		$(function(){
			var currTime = '${currDate}';
			var date = new Date(currTime);
			var fmtDate = getDateFormat(date);
			var group1 = "";
			if(date.getHours()<12){
				group1 += "<option value='"+getFullDate(date)+"09:00-12:00'>"+fmtDate+"09:00-12:00</option>";
			}
			if(date.getHours()<18){
				group1 += "<option value='"+getFullDate(date)+"12:00-18:00'>"+fmtDate+"12:00-18:00</option>";
			}
			if(date.getHours()<22){
				group1 += "<option value='"+getFullDate(date)+"18:00-20:00'>"+fmtDate+"18:00-20:00</option>";
			}
			$("#deliverytime").append(group1);
			
			for(var i=1;i<3;i++){
				var newDate = dateAdd(date,i);
				fmtDate = getDateFormat(newDate);
				var group = "";
					group += "<option value='"+getFullDate(newDate)+"09:00-12:00'>"+fmtDate+"09:00-12:00</option>";
					group += "<option value='"+getFullDate(newDate)+"12:00-18:00'>"+fmtDate+"12:00-18:00</option>";
					group += "<option value='"+getFullDate(newDate)+"18:00-20:00'>"+fmtDate+"18:00-20:00</option>";
					group += "</optgroup>";
				$("#deliverytime").append(group);
			}
			
			//腾讯地图反查经纬度
			var geocoder, map, marker = null;
	        geocoder = new qq.maps.Geocoder();
	        //若服务请求失败，则运行以下函数
	        geocoder.setError(function() {
	            $.dialog.alert("出错了，请输入正确的地址！");
	        });
	        
			$("#selectAddress").on("click", function(){
				
					wx.openAddress({
						success: function(res){						
							var addressStr = res.provinceName + res.cityName + res.detailInfo;
							var address = '中国,'+res.provinceName+','+res.cityName+','+res.detailInfo;
        					//对指定地址进行解析
				            geocoder.getLocation(address);
				            //设置服务请求成功的回调函数
				            geocoder.setComplete(function(result) {
								$("#rcvname_text").html(res.userName);
								$("#rcvmobile_text").html(res.telNumber);
								$("#rcvaddress_text").html(addressStr.replace(/\s/g, ""));
								
								$("#receiver_name").val(res.userName);
								$("#receiver_mobile").val(res.telNumber);
								$("#address_detail").val(addressStr.replace(/\s/g, ""));
								$(".select-text").hide(); 
								$("#address_info").show();
								
								if($("#psfs").val()=='2' && $("#receiver_name").val()!=null &&$("#receiver_name").val()!=""
									&&$("#receiver_mobile").val()!=null &&$("#receiver_mobile").val()!=""
										&&$("#address_detail").val()!=null &&$("#address_detail").val()!=""){
									
							    	ajaxSettings.data.flag = 2;
							    	ajaxSettings.data.lat = result.detail.location.lat; 
					    			ajaxSettings.data.lng = result.detail.location.lng;
					    			$("#lat").val(result.detail.location.lat);
					    			$("#lng").val(result.detail.location.lng);
					    			
					    			//ajaxSettings.data.address = addressStr;
									setStoreSelectOptions(ajaxSettings);
								}
				            })
				            //若服务请求失败，则运行以下函数
				            geocoder.setError(function() {
				                $.dialog.alert("出错了，请输入正确的地址！");
				            });
				            
						 },
			            cancel: function (res) { }
					});
			
			});
			
			wx.ready(function() {
				wx.getLocation({
				    type: 'wgs84',
				    success: function (res) {
				    	currentPoint.data.lat = res.latitude; 
				    	currentPoint.data.lng = res.longitude; 
				    	ajaxSettings.data.lat = res.latitude; 
				    	ajaxSettings.data.lng = res.longitude;
				    	$("#lat").val(res.latitude);
						$("#lng").val(res.longitude);
						
				    	deliveryChange(1);
				    	$(".loading").hide();
				    	$(".mask").hide();
					}	
				});
			});
			
			$("#psfs").on("change", function(){
				deliveryChange($(this).val());
			});
			
		   /* $("#md").on("change", function(){
				if($("#psfs").val()=='2'&&$("#receiver_name").val()!=null &&$("#receiver_name").val()!=""
					&&$("#receiver_mobile").val()!=null &&$("#receiver_mobile").val()!=""
						&&$("#address_detail").val()!=null &&$("#address_detail").val()!=""){
					mdChange();
				}
			}); */
			
			setTimeout(function(){
				$(".loading").hide();
				$(".mask").hide();
			},5000);
			
		});
		
		$("#commit_btn").on("click",function(){
				if($("#psfs").val()=='2'){
					if($("#receiver_name").val()==null ||$("#receiver_name").val()==""
						||$("#receiver_mobile").val()==null ||$("#receiver_mobile").val()==""
							||$("#address_detail").val()==null ||$("#address_detail").val()==""){
						$.dialog.alert("请先填写收货地址！");
						return;
					}
				}
				if(parseInt('${balance}')<0){
					$.dialog.alert("无效金额！");
						return;
				}
				<#if !(session['wxUser'].phone_num??)>
					if($("#psfs").val()=='1'){
						var true_num=/^1(3|4|5|7|8)\d{9}$/;
						var value=$("#phone_num").val();
						var istrue=true_num.test(value)&&value!="";
						if(!istrue){
							$.dialog.alert("您输入的手机号码有误");
							return;
						}
					}
				</#if>
				$('#orderForm').submit();
	    });
		
		function getDateFormat(date){
			var month = date.getMonth()+1;
			var day = date.getDate();
			var weekday = date.getDay();
			var weekday_cn = "";
			if(weekday==1){
				weekday_cn="周一";
			}else if(weekday==2){
				weekday_cn="周二";
			}else if(weekday==3){
				weekday_cn="周三";
			}else if(weekday==4){
				weekday_cn="周四";
			}else if(weekday==5){
				weekday_cn="周五";
			}else if(weekday==6){
				weekday_cn="周六";
			}else if(weekday==0){
				weekday_cn="周日";
			}
			return month+"-"+day+"  "+weekday_cn+" ";
		}
			
		function dateAdd(dtTmp, Number) {  
		    return new Date(Date.parse(dtTmp) + (86400000 * Number));
		}
		
		function getFullDate(date){
			var year = date.getFullYear();
			var month = date.getMonth()+1;
			var day = date.getDate();
			return year+"-"+month+"-"+day+" "
		}
		
		function back() {
			window.location.href="${CONTEXT_PATH}/fruitShop/cart"
		}
		
		function deliveryChange(type){
			//到店自提
			if(type == 1){
				$("#selectAddress").hide();
				$(".delivery_time").hide();
				//获取用户手机号
				<#if !(session['wxUser'].phone_num??)>
					$(".phone_num").show();
				</#if>
		    	ajaxSettings.data.flag = 1;
		    	ajaxSettings.data.lat = currentPoint.data.lat; 
				ajaxSettings.data.lng = currentPoint.data.lng; 
				setStoreSelectOptions(ajaxSettings);
				$("#commit_btn").removeAttr("disabled");
			}else{
				$("#selectAddress").show();
				$(".delivery_time").show();
				$(".phone_num").hide();
				var addressStr = $("#address_detail").val().replace(/\s/g, "");
				if(addressStr && $.trim(addressStr).length > 0){
					var address = '中国,湖南省,长沙市,'+addressStr;
					//对指定地址进行解析
		            geocoder.getLocation(address);
		          //设置服务请求成功的回调函数
		            geocoder.setComplete(function(result) {
				    	ajaxSettings.data.flag = 2;
				    	ajaxSettings.data.lat = result.detail.location.lat; 
				    	ajaxSettings.data.lng = result.detail.location.lng;
				    	$("#lat").val(result.detail.location.lat);
						$("#lng").val(result.detail.location.lng);
						setStoreSelectOptions(ajaxSettings);
		            });
		            //若服务请求失败，则运行以下函数
		            geocoder.setError(function() {
		                $.dialog.alert("出错了，请输入正确的地址！");
		            });
				}
			}
		}
		
		function setStoreSelectOptions(settings){
	    	$.ajax(settings).done(function(list){
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
	    			$("#md-button span").html($("#md").find("option:selected").text());
	    		} 
	    	});
		}
	</script>	
</body>
</html>