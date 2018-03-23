<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-会员资料" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl" />
</head>
<body>
<div data-role="page" class="member-moblie">
		<div data-role="main">
				<div class="register-box">
					<input type="hidden" id="nearStore" name="nearStore" value="8888"/>
						<input type="hidden"  name="activity_id" id="activity_id" value="${(activity_id)!}">
						<input type="hidden"  name="receiveId" id="receiveId" value="${(receiveId)!}">
					<i class="icon-logo"><img src="resource/image/icon/register-logo.png"></i>
					<div class="phone-box row no-gutters align-items-center">
						<i class="col-2"><img src="resource/image/icon/icon-yonghu.png"></i>
						<input class="col-10" data-role='none' type="number" autofocus="autofocus" name="phone_num" id="phone_num" placeholder="请输入11位手机号码">
					</div>
					<div class="password-box row no-gutters align-items-center">
						<i class="col-2"><img src="resource/image/icon/icon-yanzhengma.png"></i>
						<input class="col-6" data-role='none' type="number" name="verify_code" id="verify_code" placeholder="请输入验证码">
						<button class="col-4" data-role='none' id="getVerify">获取验证码</button>
					</div>
					<div class="cmt-box">
					<button data-role='none' id="mobileCmt">
						<#if flag ??>
							立即领取
						<#else>	
							提 交
						</#if>
					</button>
					<#if flag ??>
						<p class="red-tips">检测到还未有账户，填写手机号才能领取到哦</p>
					</#if>
					</div>
				</div> 
		</div>
	</div>

	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		var nearStore="8888";
		var ajaxSettings = {
			async: false,
			type: "POST",
			url: "${CONTEXT_PATH}/storeList",
			data: {flag: 1},
			dataType: "json"
		};
		
	 	$(function(){
	 		var t = 0;
	 		var getVerifyClick = false;
	 		$("#getVerify").bind("click",function(){
	 			var phone_num = $("#phone_num").val();
	 			var reg = /^1[0-9]{10}$/;
	 			if(phone_num==null||phone_num==""){
	 				$.dialog.alert("手机号码不能为空！");
	 				return;
	 			}
	 			if(!reg.test(phone_num)){
	 				$.dialog.alert("请输入正确的手机号码！");
	 				return;
	 			}
	 			getVerifyClick = true;
	 			clearInterval(t);
	 			$("#getVerify").attr("disabled","true");
	 			$.ajax({
	 	            type: "POST",
	 	            data:{phone_num:$("#phone_num").val()},
	 	            url: "${CONTEXT_PATH}/getVerifyCode"
	 	        }).done(function(data){
	 	        	if(data.result=="success"){
	 	        		var seconds = 120;
	 	        		$("#phone_num").attr("readonly","readonly");
	 	        		$("#getVerify").html("再次获取("+seconds+")");
	 	 	        	t = setInterval(function() {
	 	 	        		if(seconds>1){
	 	 	        			seconds--;
	 	 	        			$("#getVerify").html("再次获取("+seconds+")");
	 	 	        		}else{
	 	 	        			$("#getVerify").html("再次获取");
	 	 	        			$("#getVerify").removeAttr("disabled");
	 	 	        		}
	 					}, 1000);
	 	        	}else{
	 	        		$.dialog.alert(data.msg);
	 	        	}
		        });
	 		});
	 		wx.ready(function() {
				wx.getLocation({
				    type: 'wgs84',
				    success: function (res) {
				    	ajaxSettings.data.lat = res.latitude; 
				    	ajaxSettings.data.lng = res.longitude;
				    	ajaxSettings.data.flag = 1;
				    	$.ajax(ajaxSettings).done(function(list){
				    		if(list){
				    			if(list[0]["distance"]){
			    					nearStore=list[0].store_id;
			    					$("#nearStore").val(nearStore);
						    	}
					    	} 
				    	});
					}	
				});
			});
			
	 		var flag=true;
	 			 		
	 		$("#mobileCmt").bind("click",function(){
	 			if(flag){
		 			//防止用户点击过于频繁
		 			flag=false;
		 			var phone_num = $("#phone_num").val();
		 			var verifyCode = $("#verify_code").val();
		 			var reg = /^1[0-9]{10}$/;
		 			if(phone_num==null||phone_num==""){
		 				$.dialog.alert("手机号码不能为空！");
		 				flag=true;
		 				return;
		 			}
		 			if(verifyCode==null||verifyCode==""){
		 				$.dialog.alert("验证码不能为空！");
		 				flag=true;
		 				return;
		 			}
		 			if(!reg.test(phone_num)){
		 				$.dialog.alert("请输入正确的手机号码！");
		 				flag=true;
		 				return;
		 			}
		 			if(!getVerifyClick){
		 				$.dialog.alert("请先点击获取验证码！");
		 				flag=true;
		 				return;
		 			}
		 			$.ajax({
			            type: "POST",
			            data:{
		 	            	phone_num:$("#phone_num").val(),
		 	            	verifyCode:$("#verify_code").val(),
		 	            	nearStore:$("#nearStore").val(),
		 	            	receiveId:$("#receiveId").val(),
		 	            	activity_id:$("#activity_id").val()
		 	            },
		 	            url: "${CONTEXT_PATH}/memberMobileCmt",
			            dataType: "json",
			            success: function(data){
			            	if(data.result=="success"){
			        				$.dialog.alert("注册成功！");
			        				if(data.status==1||data.status==2){
			        					setTimeout(function(){
						        			window.location.href = "${CONTEXT_PATH}"+data.url;//发券活动链接
						        		 },5000);
			        				}else{
					 	        		setTimeout(function(){
						        			window.location.href = "${CONTEXT_PATH}/main";
						        		 },5000);
			        				}
			 	        	}else{
			 	        		flag=true;
			 	        		$.dialog.alert(data.msg);
			 	        	}
			            }
			        });
			     }else{
			    	 $.dialog.alert("请勿重复提交！");
			     }  
	 		});
	 	});
	</script>	
</body>
</html>