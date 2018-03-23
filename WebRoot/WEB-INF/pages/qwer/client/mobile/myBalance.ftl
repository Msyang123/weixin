<!DOCTYPE html>
<html>
<head>
<title>水果熟了- 我的余额</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-我的余额" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order" class="my-balance">
		<div class="carthead">
			<div class="btn-back">
			    <a onclick="back();">
			      <img height="20px" src="resource/image/icon/icon-back.png" />
			    </a>
			</div>
			<div class="btn-balance" onclick="balanceDetail();">余额明细</div>
			<div>我的果币</div>
    	</div>
    	<div data-role="main">
    		<div class="balance-box">
    			<img src="resource/image/icon/icon-balance.png" />
			    <div class="rest">我的余额</div>
			    <div class="sum">￥${(user.balance!0)/100}</div>
    		</div>
    		<div class="btn-operation">
    		    <button type="button" class="btn-custom" onclick="recharge();">充值</button>
    	    </div>
	    	<div class="btn-operation">
	    		<button type="button" class="btn-white btn-custom" onclick="balanceTransfer();">转账</button>
	    	</div>
	    	<div class="text-center brand-red mt41">Tip: 鲜果币可用于购买微商城内商品，1鲜果币=1元</div>
    	</div>
    </div>
    
    
    <#include "/WEB-INF/pages/common/share.ftl"/>
    <script type="text/javascript">
		function recharge(){
			var oLink = '${CONTEXT_PATH}/main?index=0';
	 		$.cookie('linkInfo',oLink,{expires:1,path:'/'});
			window.location.href="${CONTEXT_PATH}/pay/sbmtRecharge";
		}
		function balanceTransfer(){
			window.location.href="${CONTEXT_PATH}/pay/initBalanceTransfer";	
		}
		
		function balanceDetail(){
			window.location.href="${CONTEXT_PATH}/balanceDetail";
		}
		function back(){
			window.history.back();
		}
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
	</script>
</body>
</html>