 <!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-转账" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="presentOrderPage" class="bg-white">

		<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div class="transfer-text">转账</div>
		</div>
		
		<div data-role="main" id="balance_transfer">
			<form id="transferForm" action="${CONTEXT_PATH}/pay/balanceTransfer" method="post" data-ajax="false">
				<div class="row no-gutters select-friends">
					<div class="col-3 select-friend text-right">选择好友：</div>
					<div class="col-auto select-input">
						<input type="hidden" id="target_user" name="target_user"/>
						<img onclick="selectFriend()" height="25px" src="resource/image/icon/icon-plus.png" />
						<span id="target_text"></span>
					</div>
					<div class="col-5" id="present_tips">请先选择转账的好友！</div>
				</div>
				<div class="row no-gutters transfer-area">
					<div class="col-4 transfer-label">转账鲜果币：</div>
					<div class="col-6 transfer-input">
						<input type="number" data-inline="true" id="money" name="money"/>
					</div>			
				</div>
			</form>	
			
			<div class="confrim-transfer">
	    		<button class="btn-custom btn-transfer" type="button" onclick="return whenSubmit();">确认转账</button>
	    	</div>
	    	
		</div>
	</div>
	
	<div data-role="page" id="selectFriendPage">
		<div class="carthead search-head">
			<div class="btn-back">
				<a onclick="cacelSelect();"><img width="10px" height="20px" src="resource/image/icon/icon-back1.png" /></a>
			</div>
			<div class="search-box">
				<img src="resource/image/icon/icon-search.png">
				<input type="search" data-mini="true" name="search" id="search" data-role='none'/>
			</div>
			<div class="btn-search">
				<a onclick="searchUser();">搜索</a>
			</div>
    	</div>
    	<div data-role="main" id="userListDiv" class="mt50">
    	    <div class="search-phone">建议输入手机号码后四位进行查询</div>
    	</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function back(){
			window.history.back();
		}
		
		function presentCmt(){
			var target_user = $("#target_user").val();
			if(target_user==null||target_user==""){
				$("#present_tips").show();
				return;
			}
			$("#presentForm").submit();
		}
		
		function selectFriend(){
			$.mobile.changePage("#selectFriendPage", "slideup");
		}
		
		function cacelSelect(){
			$.mobile.changePage("#presentOrderPage", "slideup");
		}
		
		function searchUser(){
			var keyword = $("#search").val();
			if(keyword==null||keyword==""){
				$.dialog.alert("请输入关键字进行查询");
				return;
			}
			$("#userListDiv").load("${CONTEXT_PATH}/searchUserList?keyword="+keyword);
		}
		
		function selectUser(id,nickname,mobile){
			$("#target_text").html(nickname+"("+mobile+")");
			$("#target_user").val(id);
			$("#present_tips").hide();
			$.mobile.changePage("#presentOrderPage", "slideup");
		}
		
		function whenSubmit(){
			var target_user=$("#target_user").val();
			if(target_user==null||target_user==""){
				$("#present_tips").show();
				return false;
			}
			var money = $.trim($("#money").val());
			if(/^[0-9]*[1-9][0-9]*$/.test(money)){
				if(${user.balance/100}>=money){
					$.dialog.message("确定转账？",true,function(){
						$('#transferForm').submit();	
					});
				}else{
					$.dialog.alert("请输入小于您账户的金额！");
				}
			}else{
				$.dialog.alert("请输入正确的金额！");
				return false;
			}	
		}
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
	</script>
</body>
</html>