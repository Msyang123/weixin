<!DOCTYPE html>
<html>
<head>
	<title>水果熟了-订单</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-订单" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl" />
	<style>
		.ui-mobile .ui-page{
			height:100%;
		}
	</style>
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
		
		<div id="tipsDiv" class="mb5">
				
		</div>
		
		<div data-role="main">
			<form id="orderForm" action="${CONTEXT_PATH}/orderCmt" method="post" data-ajax="false">
				<input type="hidden" name="isSingle"  id="isSingle" value="${isSingle!0}" />
				<input type="hidden" name="order.delivery_fee" id="delivery_fee" value="0" />
				<input type="hidden" name="order.lat" id="lat"/>
				<input type="hidden" name="order.lng" id="lng"/>
				<div class="container">
					<div class="row mb5">
						<div class="addrdiv" id="selectAddress">
							<div id="detialAddress">
								<div id="xzshdz">选择收货地址</div>
								<div id="address_info">
									<input type="hidden" name="order.receiver_name" id="receiver_name" />
									<input type="hidden" name="order.receiver_mobile" id="receiver_mobile"/>
									<input type="hidden" name="order.address_detail" id="address_detail"/>
									<div style="height:25px;width:100%;">
										<div id="rcvname_text"></div>
										<div id="rcvmobile_text"></div>
									</div>
									<div id="rcvaddress_text"></div>
								</div>
							</div>
							<div class="right-img">
								<img src="resource/image/icon/right.png" />
							</div>
						</div>
					</div>
					<div class="row o-info">
						<div class="col-4 o-info-txt">配送方式：</div>
						<div class="col-8 nopd-l">
							<select data-mini="true" name="order.deliverytype" id="psfs">
								<#if isAllSpecialGoods==0>
									<option value="3" selected>全国配送</option>
								</#if>
								<option value="1">门店自提</option>
								<option value="2">送货上门</option>
							</select>
						</div>
					</div>
					<div class="row o-info" id="deliverytimeDisplay">
						<div class="col-4 o-info-txt">配送时间：</div>
						<div class="col-8 nopd-l">
        					<select name="order.deliverytime" id="deliverytime" data-mini="true"></select>
						</div>
					</div>
					<div class="row o-info">
						<div class="col-4 o-info-txt">选择门店：</div>
						<div class="col-8 nopd-l">
							<select name="order.order_store" data-mini="true" id="md">
								<#if isAllSpecialGoods==0>
									<option value="8888">水果熟了总仓</option> 
								<#else>
									<#list storeList as item> 
										<option value="${item.store_id}"  
										<#if item.store_id == storeId>
											selected=true
										</#if>
										>${item.store_name}</option> 
									</#list> 
								</#if>
							</select>
						</div>
					</div>
					<#if !(session['wxUser'].phone_num??)>
						<div class="row o-info" id="phone_num_tr">
							<div class="col-4 o-info-txt">联系方式：</div>
							<div class="col-8 nopd-l">
								<input id="phone_num" name="phone_num" type="number" placeholder="请输入手机号码">
							</div>
						</div>
					</#if>
					<div class="row o-info">
						<div class="col-4 o-info-txt" style="line-height:35px;">优惠券：</div>
						<div class="col-8 nopd-l input-group" id="btn_cModal">
							<input type="hidden" name="order.order_coupon" id="order_coupon"/>
							<input type="hidden" name="order.discount" id="order_discount"/>
							    <input type="text" class="form-control" placeholder="点击选择优惠券" data-role="none" id="coupon" readonly="readonly">
								
								<div class="input-group-addon">
									<i class="fa fa-search"></i></button>
								</div>
						</div>
					</div>
					<div class="row o-info">
						<div class="col-4 o-info-txt">我要留言：</div>
						<div class="col-8 nopd-l">
							<textarea name="order.customer_note" id="customer_note" maxlength="200"></textarea>
						</div>
					</div>
				</div>
			</form>
				
			<div class="cartfoot">
				<button data-role='none' id="commit_btn" class="cartbutton">结算</button>
				<div class="cart-sum1">
				            ￥<span id="needPay">${(balance!0)/100}</span>
					<span class="delivery-icon"></span>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="inv_enough" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">            
	            <div class="modal-body text-center">
	                <input type="hidden" name="is_all" id="is_all" />
	                <input type="hidden" name="is_single" id="is_single" />
	                <input type="hidden" name="pro_ids" id="pro_ids" />
	            	<h3>精品富士库存不足</h3>
	            	<label><input type="checkbox" name="is_del" id="is_del"  checked="checked" style="margin-bottom:1px;"/>&nbsp;&nbsp;删除订单内库存不足的商品</label>
	            	<div class="btn-opreations row no-gutters justify-content-between">
	            	     <!--<div class="col-6 btn-go-pay brand-red-new">继续支付</div>-->
	            	     <div class="col-12 btn-go-home">再去看看</div>
	            	</div>
	            </div>
	        </div>
	    </div>
	</div><!--/End invModel-->
	
	<div class="modal fade" id="couponModal" tabindex="-1" role="dialog" aria-hidden="true">
		  <div class="modal-dialog middle-modal" role="document">
			    <div class="modal-content">
				      <div class="modal-header">
					        <h5 class="modal-title" id="couponModalLabel">优惠券选择</h5>
					        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
					          <span aria-hidden="true" class="f15">&times;</span>
					        </button>
				      </div>
				      <div class="modal-body">
				        	<div class="change-box">
				        		<input type="text" placeholder="请输入优惠券码" data-role="none" class="order-input" name="coupon_code" id="coupon_code">
								<div class="btn-change bg-greyM" disabled="disabled">兑换</div>
				        	</div>				        	
				        	<div class="coupon-list">
							    <#list couponList as item>
								    <div class="order-coupon-box red-coupon" data-end-time="${item.end_time!0}">
								    	<input value="${item.id}_${item.coupon_val}" type="hidden" />
								        <div class="coupon-price pull-left">
								            <p>￥<span>${(item.coupon_val!0)/100}</span></p>
								        </div>
								        <div class="coupon-info pull-left">
								            <p class="coupon-title">${item.title}</p>
								            <p>${item.start_time?substring(5,10)}至${item.end_time?substring(5,10)}日使用</p>
								        </div>
								        <div class="coupon-check pull-right">
								        	<span class="bg-greyM icon-check"></span>
								        </div>
								    </div>
							    </#list>
							</div>
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
		/*初始化console*/
 		var vConsole = new VConsole();

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
			
			<#--<#if (couponList??)&&(couponList?size>0)>
				changeCoupon();
			</#if>-->
	
			//腾讯地图反查经纬度
			var geocoder, map, marker = null;
	        geocoder = new qq.maps.Geocoder();
	        //若服务请求失败，则运行以下函数
	        geocoder.setError(function() {
	            $.dialog.alert("出错了，请输入正确的地址！！！");
	        });

	        //页面初始化 下拉框第一次加载为之前选择的门店地址   默认选择为门店自提
	        deliveryChange('${isAllSpecialGoods}'=='0'?3:1);
			
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
					            console.log(result);
				            	$("#rcvname_text").html(res.userName);
								$("#rcvmobile_text").html(res.telNumber);
								$("#rcvaddress_text").html(addressStr.replace(/\s/g, ""));
							
								$("#receiver_name").val(res.userName);
								$("#receiver_mobile").val(res.telNumber);
								$("#address_detail").val(addressStr.replace(/\s/g, ""));
								
								$("#address_info").show();
								$("#xzshdz").hide();
								
								if($("#psfs").val()!='1'  
									    &&$("#receiver_name").val()!=null &&$("#receiver_name").val()!=""
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
				                $.dialog.alert("出错了，请输入正确的地址！");
				            });
							
						},
			            cancel: function (res) {
			            	$.dialog.alert("请允许访问您的收货地址");
						}
					});
				});
			});
			
			$("#psfs").on("change", function(){
				deliveryChange($(this).val());
			});

			$("#md").on("change", function(){
				if($("#psfs").val()=='2'&&$("#receiver_name").val()!=null &&$("#receiver_name").val()!=""
					&&$("#receiver_mobile").val()!=null &&$("#receiver_mobile").val()!=""
						&&$("#address_detail").val()!=null &&$("#address_detail").val()!=""){
					mdChange();
				}
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
					
			$("#commit_btn").on("click",function(){
				//结算前判断商品库存
				$.ajax({
					type: "Get",
		            url: "${CONTEXT_PATH}/hdApi/queryCartProductsInv",
		            data:{isSingle:$("#isSingle").val()},
		            dataType: "json",
		            success: function(data){
		            	if(data.status){
		            		//库存不足
		            		if(data.unEnoughInvProducts.length>0){
		            			var modalNode=$('#inv_enough');
				            	var str='当前门店',proIds='';
		            			for(var i=0;i<data.unEnoughInvProducts.length;i++){
		            				str+=data.unEnoughInvProducts[i].product_name+',';
		            				proIds+=data.unEnoughInvProducts[i].id+',';
		            			}
			            		modalNode.find('h3').text(str.substring(0,str.length-1)+"库存不足");
			            		//如果全部商品库存不足
			            		if(data.clearAllPro){
			            			str='当前门店库存不足，请切换门店试试!';
			            			modalNode.find('h3').text(str);
			            		}
			            		//console.log(proIds.substring(0,str.length-1));
			            		modalNode.find('#is_all').val(data.clearAllPro?"ok":"");
			            		modalNode.find('#is_single').val(data.isSingle);
			            		modalNode.find('#pro_ids').val(proIds.substring(0,proIds.length-1));
			            		modalNode.modal('show');
		            		}else if(data.unEnoughInvProducts.length==0){
		            			//库存充足
		            			if($("#psfs").val()!='1'){
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
		        				//是否使用过优惠券(防止返回重复使用优惠券)
		        				$.ajax({
		        					type: "Get",
		        		            url: "${CONTEXT_PATH}/isOrderCoupon",
		        		            data:{order_coupon:$("#order_coupon").val()},
		        		            dataType: "json",
		        		            success: function(data){
		        		            	if(data.msg==1){
		        		            		$('#orderForm').submit();
		        		            	}else{
		        		            		$.dialog.alert(data.msg);
		        		            		$("#coupon").val("");
		        		            		$("#order_coupon").val("");
		        		            	}
		        		            }
		        				});
		        				
		            		}
		            		
		            	}else{
		            		$.dialog.alert("您购物车的商品已不存在，请重新刷新!");
		            	}
		            }
				});
			});
			
			/*$('#is_del').on('click',function(){
				  var _this=$(this);
				  if(_this.is(':checked')){
					  $('.btn-go-pay').attr("disabled",false).removeClass('disable');
				  }else{
					  $('.btn-go-pay').attr("disabled",true).addClass('disable');
				  }
			});*/
			
			$('.btn-go-pay').on('click',function(){
				//继续支付前先从cookie中删除掉库存不足的商品
				$.ajax({
					type: "Get",
		            url: "${CONTEXT_PATH}/hdApi/queryCartProductsInv",
		            dataType: "json",
		            success: function(data){
		            	if(data.status){
		            		//库存不足
		            		if(data.unEnoughInvProducts.length>0){
		            			var modalNode=$('#inv_enough');
				            	var str='当前门店';
		            			for(var i=0;i<data.unEnoughInvProducts.length;i++){
		            				str+=data.unEnoughInvProducts.eq(i).product_name+',';
		            			}
			            		modalNode.find('h3').text(str.substring(0,str.length-1)+"库存不足");
			            		//如果全部商品库存不足
			            		if(data.clearAllPro){
			            			str='当前门店库存不足，请切换门店试试!';
			            			modalNode.find('h3').text(str);
			            		}
			            		modalNode.modal('show');
		            		}else if(data.unEnoughInvProducts.length==0){
		            			//库存充足
		            			if($("#psfs").val()!='1'){
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
		        				
		        				//是否使用过优惠券(防止返回重复使用优惠券)
		        				$.ajax({
		        					type: "Get",
		        		            url: "${CONTEXT_PATH}/isOrderCoupon",
		        		            data:{order_coupon:$("#order_coupon").val()},
		        		            dataType: "json",
		        		            success: function(data){
		        		            	if(data.msg==1){
		        		            		$('#orderForm').submit();
		        		            	}else{
		        		            		$.dialog.alert(data.msg);
		        		            		$("#coupon").val("");
		        		            		$("#order_coupon").val("");
		        		            	}
		        		            }
		        				});
		            		}
		            		
		            	}else{
		            		$.dialog.alert("当前门店库存不足，请切换门店试试!");
		            	}
		            	
		            }
				});
						
			});
			
			$('.btn-go-home').on('click',function(){
				  //先判断checkbox
				  if($('#is_del').is(":checked")){
					  //从cookie中移除掉库存不足的商品
					  if($('#is_all').val()=="ok"){
						  //清除购物车存在的cookie 区分来源购物车0 立即购买1
						  if($('#is_single').val()==0){
						      $.cookie('cartInfo',null,{path:"/",expires: -1});
						  }else{
							  $.cookie('productInfo',null,{path:"/",expires: -1});
						  }
					  }else{
						  //清除购物车部分商品
						  var ids=$('#pro_ids').val().split(',');
						  var cartJson=JSON.parse($.cookie('cartInfo'));
						  //console.log(cartJson);
						  var newCartJson=$.grep(cartJson, function(n,i){
							  var flag=false;
							  for(x=0;x<ids.length;x++){
								  if(n.product_id==ids[x]){
									  flag=true;
									  return flag;
								  }else{
									 continue;
								  }
							  }
							  return flag;
						 },true);
						 //console.log(newCartJson);
						 $.cookie('cartInfo',JSON.stringify(newCartJson),{expires:15,path:'/'});
					  }
				  }
				  window.location.href="${CONTEXT_PATH}/main?index=0";
			});
			
			setTimeout(function(){
				$(".loading").hide();
				$(".mask1").hide();
			},2000);
			
			
			//选择优惠券
			$("#btn_cModal").on('click',function(){
				$(".icon-check").removeClass("bg-pink");
				$(".icon-check").addClass("bg-greyM");
				$('#couponModal').modal('show');
			});
			
			//输入时切换兑换按钮状态
			$("#coupon_code").on('input',function(e){  
				var btnNode=$(".btn-change");
				btnNode.removeClass("bg-greyM").addClass("bg-pink");
				btnNode.attr("disabled",false);
				if($(this).val()==""){
					btnNode.removeClass("bg-pink").addClass("bg-greyM");
					btnNode.attr("disabled",true);
				}
			}); 
			
			//兑换优惠券
			$(".btn-change").on('click',function(e){
				  var code=$('#coupon_code').val();
				  var money=parseInt('${balance!0}');
				  if(code==""){
					  $.dialog.alert("请输入兑换码");
					  return false;
				  }
				  //发送ajax去兑换优惠券
				  $.ajax({
						type: "Get",
			            url: "${CONTEXT_PATH}/activity/exchangeCoupon",
			            data:{coupon_code:code.trim(),order_money:money},
			            success: function(result){
			            	if(result.success){
			            		var couponVal=result.coupon_val?(result.coupon_val/100):0;
			            		var startTime=result.start_time?result.start_time.substring(5,10):"N/A";
			            		var endTime=result.end_time?result.end_time.substring(5,10):"N/A";
			            		var className=result.isEnable?"red-coupon":"default-coupon";
			            		
                                var markup='<div class="order-coupon-box '+className+'" data-end-time="'+(result.end_time?result.end_time:"0")+'">'+
                                    '<input value="'+result.coupon_id+'_'+result.coupon_val+'" type="hidden" />'+
	    					        '<div class="coupon-price pull-left">'+
						            '<p>￥<span>'+couponVal+'</span></p></div>'+
						            '<div class="coupon-info pull-left">'+
							        '<p class="coupon-title">'+result.coupon_desc+'</p>'+
							        '<p>'+startTime+'至'+endTime+'日使用</p>'+
							        '</div>'+
							        '<div class="coupon-check pull-right">'+
						        	'<span class="bg-greyM icon-check"></span>'+
						            '</div></div>';
							        
			            		$('.coupon-list').prepend(markup);
			            		if(!result.isEnable){
			            			//禁用掉点击事件 因为不满足门槛金额，无法选择只能添加到优惠券列表里
			            			//$('.coupon-list').off('click','.order-coupon-box');
			            			$('.default-coupon').on('click',function(e){
			            				//阻止事件冒泡 此时等于解绑掉父元素的点击事件委托
			            				e&&e.stopPropagation();
			            				return false;
			            			});
			            		}
			            		//兑换成功后清空兑换码
			            		$("#coupon_code").val("");
			            		$.dialog.alert(result.msg);
			            	}else{
			            		$.dialog.alert(result.msg);
			            	}
			            }
					});
			});
			
			$("#deliverytime").on("change",function(){
				mdChange();
			});
			
			$(".coupon-list").on("click",'.order-coupon-box',function(e){
				var $btn=$(e.currentTarget);
				var coupon_obj = $btn.find('input').val();
				var coupon_name = $btn.find('.coupon-title').html();
				var balance = parseInt('${balance}');
				var endTime=$btn.data("end-time");
				
				if(coupon_obj==''){
					$("#order_coupon").val(0);
					$("#order_discount").val(0);
					$("#needPay").html(balance/100);
					return;
				}	
				
				//点击选择优惠券时，如果是通过兑换码兑换的优惠券需判断有效期
				if(new Date().getTime()>new Date(endTime).getTime()){
					 $.dialog.alert("该优惠券已过期");
					 return false;
				}
				
				var coupon_info=coupon_obj.split("_");
				var coupon_id = parseInt(coupon_info[0]);
				var discount = parseInt(coupon_info[1]);
				
				$("#order_coupon").val(coupon_id);
				$("#order_discount").val(discount);
				$("#coupon").val(coupon_name);
				
				$btn.find(".coupon-check span").removeClass("bg-greyM").addClass("bg-pink");
				
				$('#couponModal').modal('hide');
			});
			
			$('#couponModal').on("show.bs.modal",function(){
				  $('#coupon_code').val("");
			});
			
			$(".order-coupon-box").each(function(index, element){
				if($(this).hasClass("default-coupon")){
					$(this).unbind();
				}
			});
		});	
		
		function back() {
			window.history.back();
		}
			
		function deliveryChange(type){
			//到店自提
			if(type == 1){
				$("#tipsDiv").html("购物满38元(2km以内，5kg以下)免费送货上门");				
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
				if(type == 3){
					$("#tipsDiv").html("全国邮费按2元1kg执行，不足1kg按2元/kg计算");
					$("#deliverytimeDisplay").hide();
				}else{
					$("#tipsDiv").html("购物满38元(2km以内，5kg以下)免费送货上门");
					$("#deliverytimeDisplay").show();
				}
				$("#selectAddress").show();
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
				
				//送货上门计算的是达达配送距离，原计算的直线距离不准确，故屏蔽距离
				var addressStr = $("#address_detail").val().replace(/\s/g, "");
				if(addressStr && $.trim(addressStr).length > 0){
					var address = '中国,湖南省,长沙市,'+addressStr;
					//先选择送货上门 再选到店自提 再选送货上门时会重新定位到当前的位置
					ajaxSettings.data.flag = 2;
					ajaxSettings.data.lat = $("#lat").val(); 
				    ajaxSettings.data.lng = $("#lng").val();
		            setStoreSelectOptions(ajaxSettings,false);
				}else{
					ajaxSettings.data.lat = $("#lat").val(); 
				    ajaxSettings.data.lng = $("#lng").val();
		            setStoreSelectOptions(ajaxSettings,false);
				}
				
				
			}
		}
		
		function mdChange(){
			$(".loading").show();
			$(".mask1").show();
			//送货上门需要计算运费
			$.ajax({ 
				url: "${CONTEXT_PATH}/dada/queryFnDeliverFee", 
				data: {orderStore:$("#md").find("option:selected").val(),
					receiverName:$("#receiver_name").val(),
					receiverMobile:$("#receiver_mobile").val(),
					deliveryAddress:$("#address_detail").val().replace(/\s/g, ""),
					lat:ajaxSettings.data.lat,
					lng:ajaxSettings.data.lng,
					isSingle:$("#isSingle").val(),
					isAllSpecialGoods:'${isAllSpecialGoods}',
					isOrderStore:$("#md").find("option:selected").val(),
					deliverTime:$("#deliverytime").find("option:selected").val()
					}, 
					success: function(data){
						console.log(data);
						if(data.code==0){
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
		
		//填充下拉框选项
		function setStoreSelectOptions(settings,showDist){
			if($("#psfs").val()=='3'){
				var select = $("#md");
    			select.empty();
				var option = $("<option value='8888'>水果熟了总仓</option>");
		    	select.append(option);
		    	$("#md-button span").html($("#md").find("option:selected").text());
		    	mdChange();
		    	return;
			}
	    	$.ajax(settings).done(function(list){
	    		var storeId = $.cookie('store_id');
	    		console.log(storeId);
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
	    				$(".delivery-icon").html("");
						$(".delivery-icon").hide();
	    			}
	    		} 
	    	});
		}
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
	</script>
</body>
</html>