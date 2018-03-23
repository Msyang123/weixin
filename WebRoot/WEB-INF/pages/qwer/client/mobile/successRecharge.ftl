<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-充值成功" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="success-recharge bg-white">
		<div data-role="main">
  
			<div class="success-icon">
		        <img height="100px" src="resource/image/icon/pay-success.png"/>
			    <h3>充值成功，当前鲜果币数量：<span class="brand-red">${(balance!0)/100}</span></h3>
			</div>			
		
			<div class="complete-box">		    
				<button type="button" data-role="button" class="btn-custom" id="recharge_success">完成</button>
			</div>
			
			<div class="complete-box">
			   <button type="button" data-role="button" class="btn-custom btn-white" id="recharge_again">继续充值</button>
			</div>
		</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
			
		$(function(){
		    $('#recharge_again').on('click',function(){
		         window.location.href="${CONTEXT_PATH}/pay/sbmtRecharge";
		    });
		    $('#recharge_success').on('click',function(){
		    	var oLink = $.cookie('linkInfo');
		    	if(oLink=='null'||oLink==null){
		    		window.location.href="${CONTEXT_PATH}/main";
		    	}else{
		    		$.cookie('linkInfo',null,{path:"/",expires: -1});
		    		window.location.href=oLink;
		    	}	
		    });
		});
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
</script>
</body>
</html>