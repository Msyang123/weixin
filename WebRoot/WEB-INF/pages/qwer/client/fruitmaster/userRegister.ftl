<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-用户注册" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">
	<div class="member-moblie">
		<div class="register-box">
			<input type="hidden" id="nearStore" name="nearStore" value="8888"/>
			<i class="icon-logo"><img src="resource/image/icon/register-logo.png"></i>
			<div class="phone-box row no-gutters align-items-center">
				<i class="col-2"><img src="resource/image/icon/icon-yonghu.png"></i>
				<input class="col-10" type="number" autofocus="autofocus" name="phone_num" id="phone_num" placeholder="请输入11位手机号码">
			</div>
			<div class="password-box row no-gutters align-items-center">
				<i class="col-2"><img src="resource/image/icon/icon-yanzhengma.png"></i>
				<input class="col-6" type="number" name="verify_code" id="verify_code" placeholder="请输入验证码">
				<button class="col-4" id="getVerify">获取验证码</button>
			</div>
			<div class="cmt-box text-center">
				<button id="mobileCmt" class="s-btn-brown">提 交</button>
			</div>
		</div> 
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script>
		//最近门店，默认中心
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
	 				alert("手机号码不能为空！");
	 				return;
	 			}
	 			if(!reg.test(phone_num)){
	 				alert("请输入正确的手机号码！");
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
	 	        		alert(data.msg);
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
		 			flag=false;
		 			var phone_num = $("#phone_num").val();
		 			var verifyCode = $("#verify_code").val();
		 			var reg = /^1[0-9]{10}$/;
		 			if(phone_num==null||phone_num==""){
		 				alert("手机号码不能为空！");
		 				return;
		 			}
		 			if(verifyCode==null||verifyCode==""){
		 				alert("验证码不能为空！");
		 				return;
		 			}
		 			if(!reg.test(phone_num)){
		 				alert("请输入正确的手机号码！");
		 				return;
		 			}
		 			if(!getVerifyClick){
		 				alert("请先点击获取验证码！");
		 				return;
		 			}
		 			$.ajax({
			            type: "POST",
			            data:{
		 	            	phone_num:$("#phone_num").val(),
		 	            	verifyCode:$("#verify_code").val(),
		 	            	nearStore:$("#nearStore").val()
		 	            	},
		 	            url: "${CONTEXT_PATH}/memberMobileCmt",   
			            dataType: "json",
			            success: function(data){
			            	if(data.result=="success"){
			        				$.dialog.alert("注册成功！");
				 	        		setTimeout(function(){
					        			window.location.href = "${CONTEXT_PATH}/mall/shopIndex";
					        		 },3000);
			 	        	}else{
			 	        		alert(data.msg);
			 	        	}
			            }
			        });
			     }else{
			     	alert("请勿重复提交！");
			     }  
	 		});
	 	});
	</script>
</body>
</html>
