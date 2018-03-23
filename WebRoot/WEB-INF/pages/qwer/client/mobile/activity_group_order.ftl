<!DOCTYPE html>
<html>
<head>
	<title>水果熟了-拼团订单</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-拼团订单" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl" />
</head>
<body>
	<div data-role="page" id="order" class="order-page bg-white">
		<div class="mask1"></div>
		<div class="loading"><img src="resource/image/icon/loading.gif"></div>
		
		<div class="orderhead">
			<div class="btn-back">
				<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div>确认订单</div>
		</div>
		
		<div id="tipsDiv">
				购物满38元(2km以内，5kg以下)免费送货上门
		</div>
		
		<div data-role="main">
			<form id="orderForm" action="${CONTEXT_PATH}/pay/groupPayment" method="post" data-ajax="false">
				<input type="hidden" name="tbs" value="${teamBuyScale.id}" id="tbs" />
				<input type="hidden" name="teamBuyId" value="${teamBuyId!}" />
				<input type="hidden" name="nearStore" value="8888" id="nearStore" />
				<input type="hidden" name="teamMember.delivery_fee" id="delivery_fee" value="0" />
				<input type="hidden" name="teamMember.lat" id="lat"/>
				<input type="hidden" name="teamMember.lng" id="lng"/>
				<table style="width: 100%;border-collapse:collapse;">
					<tr>
						<td colspan="3">
							<div class="addrdiv" id="selectAddress">
								<div id="detialAddress">
									<div id="xzshdz">选择收货地址</div>
									<div id="address_info">
										<input type="hidden" name="teamMember.receiver_name" id="receiver_name" />
										<input type="hidden" name="teamMember.receiver_mobile" id="receiver_mobile"/>
										<input type="hidden" name="teamMember.address_detail" id="address_detail"/>
										<div style="height:25px;width:100%;">
											<div id="rcvname_text"></div>
											<div id="rcvmobile_text"></div>
										</div>
										<div id="rcvaddress_text"> 
										</div>
									</div>
								</div>
								<div class="right-img">
									<img src="resource/image/icon/right.png" />
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="order-left">配送方式：</td>
						<td class="order-right">
						<select data-mini="true" name="teamMember.deliverytype" id="psfs">
								<option value="1">门店自提</option>
								<option value="2">送货上门</option>
						</select>
						</td>
					</tr>
						<tr id="deliverytimeDisplay">
							<td class="order-left">配送时间：</td>
							<td class="order-right">
	        					<select name="teamMember.deliverytime" id="deliverytime" data-mini="true"></select>
							</td>
						</tr>
					<tr>
						<td class="order-left">选择门店：</td>
						<td class="order-right">
							<select name="teamMember.order_store" data-mini="true" id="md">
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
					<#if session?? && !(session['wxUser'].phone_num??)>
						<tr id="phone_num_tr">
							<td class="order-left">联系方式：</td>
							<td class="order-right">
								<input id="phone_num" name="phone_num" type="number" placeholder="请输入手机号码">
							</td>
						</tr>
					</#if>
				</table>
			</form>	
			<div class="cartfoot">
				<button data-role='none' id="commit_btn" class="cartbutton">结算</button>
				<div class="cart-sum1">￥<span id="needPay">${(teamBuyScale.activity_price_reduce)/100}</span>
					<span class="delivery-icon">
					</span>
				</div>
			</div>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script data-main="scripts/main" src="plugin/dateTime/js/mobiscroll.js"></script>
	<script data-main="scripts/main" src="plugin/dateTime/js/PluginDatetime.js"></script>
	<script src="plugin/jQuery/json2.js"></script>	
	<script charset="utf-8" src="https://map.qq.com/api/js?v=2.exp"></script>
	<script data-main="scripts/main" src="resource/scripts/vconsole.min.js"></script>
	<script>
	var vConsole = new VConsole();
		var CONTEXT_PATH='${CONTEXT_PATH}';
		//最近门店，默认中心
		var nearStore="8888";
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
			//配送时间			
			var currTime = '${currDate}';
			var date = new Date(currTime);
			var timeArr = ['08:30-09:30','09:30-10:30','10:30-11:30','11:30-12:30','12:30-13:30','13:30-14:30','14:30-15:30','15:30-16:30','16:30-17:30','17:30-18:30','18:30-19:30','19:30-20:30','20:30-21:30'];
			var hoursArr = ['08','09','10','11','12','13','14','15','16','17','18','19','20','21'];
			var nowHours = date.getHours();
			var nowMinutes = date.getMinutes();
			
			var todayDate = getDateFormat(date);
			var todayGroup = "";
			
			//今天的时间段 判断当前时间在30分之前还是之后
			for(var i=0;i<hoursArr.length;i++){
				if(hoursArr[i]==nowHours){
					if(nowMinutes<30){
						for(var j=i;j<timeArr.length;j++){
							todayGroup += "<option value='"+getFullDate(date)+timeArr[j]+"'>今天"+todayDate+timeArr[j]+"</option>";
						}
					}else{
						for(var j=i+1;j<timeArr.length;j++){
							todayGroup += "<option value='"+getFullDate(date)+timeArr[j]+"'>今天"+todayDate+timeArr[j]+"</option>";
						}
					}
				}
			}
			
			$("#deliverytime").append(todayGroup);
			
			//明天的全部时间段
			var tomorrowGroup = "";
			var newDate = dateAdd(date,1);
			var tomorrowDate = getDateFormat(newDate);
			
			for(var i=0;i<timeArr.length;i++){
				tomorrowGroup += "<option value='"+getFullDate(newDate)+timeArr[i]+"'>明天"+tomorrowDate+timeArr[i]+"</option>";
			}
			$("#deliverytime").append(tomorrowGroup);
			
			var nowDate = new Date ();
			nowDate.setHours (nowDate.getHours () + 1);
			
			//立即送达的时间显示为当前时间的后一个小时
			$("#deliverytime option:first").text('立即送达,约'+nowDate.getHours()+':'+nowDate.getMinutes ()+'送达');
			$("#deliverytime-button span").html($("#deliverytime").find("option:selected").text());
			
			//腾讯地图反查经纬度
			var geocoder, map, marker = null;
	        geocoder = new qq.maps.Geocoder();
	        //若服务请求失败，则运行以下函数
	        geocoder.setError(function() {
	            $.dialog.alert("出错了，请输入正确的地址！！！");
	        });
	        
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
				            
								$("#rcvname_text").html(res.userName);
								$("#rcvmobile_text").html(res.telNumber);
								$("#rcvaddress_text").html(addressStr);
								$("#receiver_name").val(res.userName);
								$("#receiver_mobile").val(res.telNumber);
								$("#address_detail").val(addressStr.replace(/\s/g, ""));
								$("#address_info").show();
								$("#xzshdz").hide();
								if($("#psfs").val()=='2'&&$("#receiver_name").val()!=null &&$("#receiver_name").val()!=""
										&&$("#receiver_mobile").val()!=null &&$("#receiver_mobile").val()!=""
											&&$("#address_detail").val()!=null &&$("#address_detail").val()!=""){
									    ajaxSettings.data.flag = 2;
						    	
								    	ajaxSettings.data.lat = result.detail.location.lat; 
						    			ajaxSettings.data.lng = result.detail.location.lng;
								    	$("#lat").val(result.detail.location.lat);
						    			$("#lng").val(result.detail.location.lng);
								    	//ajaxSettings.data.address = addressStr;
										setStoreSelectOptions(ajaxSettings,false);
								}
						    	
				            });
				            //若服务请求失败，则运行以下函数
				            geocoder.setError(function() {
				                $.dialog.alert("出错了，请输入正确的地址！！！");
				            });
						},
			            cancel: function (res) {  }
					});
				});
			});
			
			//页面初始化 下拉框第一次加载为之前选择的门店地址   默认选择为门店自提
	        deliveryChange(1);
			
			//结算逻辑支付完成跳转到团详情页
			$("#commit_btn").on("click",function(){
				var tbsId=$('#tbs').val();
				console.log(tbsId);
			    $.ajax({
			          type:'Get',
			          url:'${CONTEXT_PATH}/team/isTeamSuccess',
			          data:{teamBuyScaleId:tbsId},
			          success:function(result){
			          	//判断当前商品的状态
			          	if(result.flag){
			          		$.dialog.alert("该拼团商品已下架,3秒后返回拼团列表");
			          		setTimeout(function(){
			          			window.location.href="${CONTEXT_PATH}/activity/groupBuys";
			          	    },3000);
			            }else{
			            	//继续支付
			                if($("#psfs").val()=='2'){
								if($("#receiver_name").val()==null ||$("#receiver_name").val()==""
									||$("#receiver_mobile").val()==null ||$("#receiver_mobile").val()==""
										||$("#address_detail").val()==null ||$("#address_detail").val()==""){
									$.dialog.alert("请先填写收货地址！");
									return;
								}
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
						    
							$('#nearStore').val(nearStore);
							$('#orderForm').submit();
			            }   
			          }
			     }); 
            });
			
			$("#psfs").on("change", function(){
				deliveryChange($(this).val());
			});
			
			//修改门店
			$("#md").on("change", function(){
				if($("#psfs").val()=='2'&&$("#receiver_name").val()!=null &&$("#receiver_name").val()!=""
						&&$("#receiver_mobile").val()!=null &&$("#receiver_mobile").val()!=""
							&&$("#address_detail").val()!=null &&$("#address_detail").val()!=""){
						mdChange();
				}
			});
			
			setTimeout(function(){
			$(".loading").hide();
			$(".mask1").hide();
			},3000)
			
			$("#deliverytime").on("change",function(){
				mdChange();
			});
			
			
			/*验证手机号码*/
			$("#phone_num").blur(function(){
				var true_num=/^1(3|4|5|7|8)\d{9}$/;
				var value=this.value;
				var istrue=true_num.test(value)&&this.value!="";
				if(!istrue){
					$.dialog.alert("您输入的手机号码有误");
				}
			});
		});
		
		function back() {
			window.history.back();
		}
		
		function deliveryChange(type){
			//到店自提
			if(type == 1){
				$(".delivery-icon").hide();
				$("#selectAddress").hide();
				$("#deliverytimeDisplay").hide();
				//获取用户手机号
				<#if !(session['wxUser'].phone_num??)>
					$("#phone_num_tr").show();
				</#if>
		    	ajaxSettings.data.flag = 1;
		    	ajaxSettings.data.lat = currentPoint.data.lat; 
				ajaxSettings.data.lng = currentPoint.data.lng; 
				setStoreSelectOptions(ajaxSettings,true);
				$("#commit_btn").removeAttr("disabled");
			}else{
				//$(".delivery-icon").show();
				$("#selectAddress").show();
				$("#deliverytimeDisplay").show();
				$("#phone_num_tr").hide();
				
				//如果存在默认的收货地址 直接将收货地址回填入信息栏
				if($.cookie('deliverInfo')!=null){
					var deliverInfoJson=JSON.parse($.cookie('deliverInfo'));
					var adrStoreInfoJson=JSON.parse($.cookie('adrStoreInfo'));
					
					$("#address_info").show();
					$("#xzshdz").hide();
					
					$("#rcvname_text").html(deliverInfoJson.adrName);
					$("#rcvmobile_text").html(deliverInfoJson.adrMobile);
					$("#rcvaddress_text").html(deliverInfoJson.adr);
				
					$("#receiver_name").val(deliverInfoJson.adrName);
					$("#receiver_mobile").val(deliverInfoJson.adrMobile);
					$("#address_detail").val(deliverInfoJson.adr);
					
					$("#lat").val(adrStoreInfoJson.storeLat); 
				    $("#lng").val(adrStoreInfoJson.storeLng);
				}
				
				var addressStr = $("#address_detail").val().replace(/\s/g, "");;
				if(addressStr && $.trim(addressStr).length > 0){
					var address = '中国,湖南省,长沙市,'+addressStr;
					//先选择送货上门 再选到店自提 再选送货上门时会重新定位到当前的位置
					ajaxSettings.data.flag = 2;
					ajaxSettings.data.lat = $("#lat").val(); 
				    ajaxSettings.data.lng = $("#lng").val();
		            setStoreSelectOptions(ajaxSettings,false);
				}
			}
		}
		
		function mdChange(){
			//送货上门需要计算运费
			$(".loading").show();
			$(".mask1").show();
			$.ajax({ 
				url: "${CONTEXT_PATH}/dada/queryFnDeliverFee", 
				data: {orderStore:$("#md").find("option:selected").val(),
					receiverName:$("#receiver_name").val(),
					receiverMobile:$("#receiver_mobile").val(),
					deliveryAddress:$("#address_detail").val().replace(/\s/g, ""),
					lat:ajaxSettings.data.lat,
					lng:ajaxSettings.data.lng,
					isSingle:1,
					deliverTime:$("#deliverytime").find("option:selected").val()
					}, 
				success: function(data){
					if(data.code==0){
						console.log(data);
					    //单位分
						$("#delivery_fee").val(data.fee*100);
						if(data.fee>0){
							$(".delivery-icon").show();
							$(".delivery-icon").html("需配送费"+data.fee+"元");
						}else{
							$(".delivery-icon").show();
							$(".delivery-icon").html("免配送费");
						}
						$("#commit_btn").removeAttr("disabled");
					}else{
						$.dialog.alert(data.msg);
						$("#delivery_fee").val(0);
						$(".delivery-icon").html("");
						$(".delivery-icon").hide();
						$("#commit_btn").attr("disabled","disabled");
					}	
					$(".loading").hide();
					$(".mask1").hide();
		      	}
			});
		}
		
		function setStoreSelectOptions(settings,showDist){
	    	$.ajax(settings).done(function(list){
	    		var storeId = $.cookie('store_id');
	    		
	    		if(list){
	    			var select = $("#md");
	    			select.empty();
		    		$.each(list, function(i, o){
		    			if(o){
			    			var option = $("<option></option>");
			    			if(o["distance"]&&showDist){
				    			option.val(o.store_id).text(o.store_name + "(约" + o.distance + "km)");
			    			}else{
				    			option.val(o.store_id).text(o.store_name);
			    			}
							select.append(option); 
		    			}
		    		});
		    		
		    		select.find("option[value='"+storeId+"']").attr("selected",true); 
	    			$("#md-button span").html($("#md").find("option:selected").text());
	    			if(ajaxSettings.data.flag==2){
	    				mdChange();
	    			}else{
	    				$("#delivery_fee").val(0);
	    			}
	    		} 
	    	});
		}
	</script>
</body>
</html>