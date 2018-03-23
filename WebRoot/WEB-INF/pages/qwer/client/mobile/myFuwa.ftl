<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-我的果娃" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="myFuwas" class="my-fuwa">
			<div class="orderhead">
				<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back1.png" /></a></div>
				<div class="btn-record" onclick="detial();">获取记录</div>
				<div>我的果娃</div>
			</div>
		<div data-role="main">
			<div class="fuwa-number">
					您已集齐${getMyGift.total_gift!0}套果娃
			</div>
			<div style="margin-top:10px;">
				<div class="ui-grid-a">
  					<div class="ui-block-a">
  						<div style="padding:5px;"
						<#if (myFws[0].fw_count>0) >
							onclick="detial('${myFws[0].id}');"
						</#if>
						>
						<img style="width:120px;" src="${myFws[0].save_string}"></div>
						<div class="zs_btn" onclick="selectFriend('${myFws[0].fw_id}',${myFws[0].fw_count});">
							送一张给好友
						</div>
						<div class="fw_num1">
							x${myFws[0].fw_count}
						</div>
  					</div>
  					<div class="ui-block-b">
  						<div style="padding:5px;"
								<#if (myFws[1].fw_count>0) >
									onclick="detial('${myFws[1].id}');"
								</#if>
								><img style="width:120px;" src="${myFws[1].save_string}"></div>
								<div class="zs_btn" onclick="selectFriend('${myFws[1].fw_id}',${myFws[1].fw_count});">
									送一张给好友
								</div>
								<div  class="fw_num2">x${myFws[1].fw_count}</div>
  					</div>
  					<div class="ui-block-a" style="margin-top:10px;">
  						<div style="padding:5px;"
								<#if (myFws[2].fw_count>0) >
									onclick="detial('${myFws[2].id}');"
								</#if>
								><img style="width:120px;" src="${myFws[2].save_string}"></div>
								<div class="zs_btn" onclick="selectFriend('${myFws[2].fw_id}',${myFws[2].fw_count});">
									送一张给好友
								</div>
								<div  class="fw_num3">x${myFws[2].fw_count}</div>
  					</div>
  					<div class="ui-block-b" style="margin-top:10px;">
  						<div style="padding:5px;"
								<#if (myFws[3].fw_count>0) >
									onclick="detial('${myFws[3].id}');"
								</#if>
								><img style="width:120px;" src="${myFws[3].save_string}"></div>
								<div class="zs_btn" onclick="selectFriend('${myFws[3].fw_id}',${myFws[3].fw_count});">
									送一张给好友
								</div>
								<div  class="fw_num4">x${myFws[3].fw_count}</div>
  					</div>
			</div>
			<div style="height:10px;"></div>	
			</div>
		</div>
	</div>
	<div data-role="page" id="selectFriendPage" class="fuwa-search">
		<div class="carthead search-head">
			<div class="btn-back">
				<a onclick="cacelSelect();">
					<img style="height:20px;width:10px;"src="${CONTEXT_PATH}/resource/image/icon/icon-back.png" />
				</a>
			</div>
			<div class="search-box">
				<i><img src="resource/image/icon/icon-search.png"></i>
				<input type="search" data-role='none' data-mini="true" name="search" id="search" placeholder="请输入昵称或手机号">
			</div>
			<div class="btn-search-two">
				<a onclick="searchUser();">搜索</a>
			</div>
			<div class="btn-search">
				<a id="scanQRCode">扫码</a>
			</div>
    	</div>
    	
    	<div data-role="main">
    		<div style="height:50px;"></div>
    		<div id="userListDiv">
    		
    		</div>
    	</div>
    	<form id="fuwaSendForm" action="${CONTEXT_PATH}/fuwaSend" method="post" data-ajax="false">
			<input type="hidden" id="fw_id" name="fw_get.fw_id"/>
			<input type="hidden" id="user_id" name="fw_get.user_id"/>
		</form>	
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function back(){
			window.location.href="${CONTEXT_PATH}/me";
		}
		function detial(){
			window.location.href="${CONTEXT_PATH}/myFuwaDetial";
		}
		
		function selectFriend(fw_id,fw_count){
			if(fw_count<=0){
				$.dialog.alert("您的此类果娃数量为0,不能赠送！");
				return;
			}
			$("#fw_id").val(fw_id);
			$.mobile.changePage("#selectFriendPage", "slideup");
		}
		
		function cacelSelect(){
			$.mobile.changePage("#myFuwas", "slideup");
		}
		//查找微信用户
		function searchUser(){
			var keyword = $("#search").val();
			if(keyword==''){
				return;
			}
			$("#userListDiv").load("${CONTEXT_PATH}/searchUserList?keyword="+keyword);
		}
		
		function selectUser(id,nickname,mobile){
			$.dialog.message("确定赠送？",true,function(){
				$("#user_id").val(id);
				$("#fuwaSendForm").submit();
			});
		}
		
		wx.config({
	      debug: false,
	      appId: '${appid}',
	      timestamp: ${timestamp},
	      nonceStr: '${nonce_str}',
	      signature: '${signature}',
	      jsApiList: [
	        'scanQRCode'
	      ]
	  });
	  
		wx.ready(function () {
		  // 9.1.2 扫描二维码并返回结果
		  $("#scanQRCode").click(function() {
				wx.scanQRCode({
				  needResult: 1,
				  desc: 'scanQRCode desc',
				  success: function (res) {
					$("#search").val(res.resultStr);
					searchUser();
				  }
				});
			});
		});
	
		wx.error(function (res) {
		});
	</script>
	<script src="plugin/jQuery/json2.js"></script>
	<script src="plugin/common/productDetial.js"></script>
</body>
</html>