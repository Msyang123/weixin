<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-赠送订单" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="presentOrderPage" class="present-order bg-white">
		<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>赠送订单</div>
		</div>
			
		<div data-role="main" id="send-order">
			<form id="presentForm" action="${CONTEXT_PATH}/presentCmt" method="post" data-ajax="false">
			<div class="content">
				<div class="pro-num">共${pro_num!0}件商品</div>
				<div class="pro-list clearfix">				
					<#list proList as item>
				    <div class="row no-gutters align-items-center mb8">
						<div class="col-4">
							<img class="pro-img" src="${item.product.save_string!}" onclick="fruitDetial('${item.product.pf_id}')"/>
						</div> 
						<div class="col-4 col-sm-auto">
							<div class="font_blod">
								${item.product.product_name}			
								<span>${item.product.amount!}${item.product.base_unitname!}</span>
							</div>
							<div class="font_price" style="text-align:left;">￥${(item.product_price!0)/100}</div>
						</div>
						<div class="col-4">X ${item.product_num!0}</div>
	                </div>
					</#list>
				</div>
			</div>
			<div class="select-people">
				<div class="select-people-text">赠送好友：</div>
				<div class="select-box">
					<input type="hidden" id="target_user" name="present.target_user"/>
					<img onclick="selectFriend()" height="25px" src="resource/image/icon/icon-plus.png" />&nbsp;<span id="target_text"></span>
				</div>
				<div id="present_tips">请先选择赠送的好友！</div>
			</div>
			<div class="model-box">
				<div class="model-tittle">留言</div>
				<select id="msgModel" onchange="changeModel()" data-mini="true">
					<option value="0">选择留言模版</option>
					<option value="1">身体健康，万事如意</option>
					<option value="2">在生日到来的今天，愿所有的欢乐和喜悦不断涌向您的窗前！</option>
					<option value="3">辛苦一年，我们创造佳绩，努力一年，我们成就奇迹，来年更需积极，努力团结一起，全员一起奋斗，公司创新天地，愿你身体健康，万事如意，合家快乐，幸福甜蜜</option>
					<option value="4">欢聚要有喜气，喝酒要有人气，16年的福气，化作17年的幸福，16年的运气，化作17年的幸运，16年的心愿，化作17年的希望，16年的目标，化作17年的成功，愿你17更辉煌，事业更成功</option>
					<option value="5">鸡年大吉，阖家幸福</option>
					<option value="6">鸡年好时机，发展大契机，聪明察天机，轻松理万机，聚财获商机，晋升占先机，爱情添生机，成功遇良机</option>
				</select>
    			<textarea name="present.present_msg" id="present_msg" maxlength="200" placeholder="请输入你想对Ta说的话(200字以内哦~)"></textarea>
			</div>
				<input type="hidden" name="proListJson" value='${proListJson}'/>
			</form>
			<div class="cartfoot row no-gutters align-items-center">
			    <div class="col-6 cartsum">总价：<span>￥</span><span id="needPay">${(sum!0)/100}</span></div>
				<div class="col-6" id="commit_btn" onclick="presentCmt()">提交订单</div>
			</div>
		</div>
	</div>
	
	<div data-role="page" id="selectFriendPage" class="bg-white">
		<div class="carthead search-head">
			<div class="btn-back">
				<a onclick="cacelSelect();">
					<img style="height:20px;width:10px;"src="${CONTEXT_PATH}/resource/image/icon/icon-back1.png" />
				</a>
			</div>
			<div class="search-box">
				<img src="resource/image/icon/icon-search.png">
				<input type="search" data-role='none' data-mini="true" name="search" id="search" placeholder="请输入昵称或手机号码">
			</div>
			<div class="btn-search">
				<a onclick="searchUser();">搜索</a>
			</div>
    	</div>
    	<div data-role="main" class="mt50">
    		<div id="userListDiv">
    			<div class="search-phone">
    				建议输入手机号码后四位进行查询
    			</div>
    		</div>
    	</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl" />
	<script src="plugin/common/productDetial.js"></script>
	<script type="text/javascript">
		function back(){
			window.location.href = "${CONTEXT_PATH}/present";
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
				alert("请输入关键字进行查询");
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
		
		function changeModel(){
			if($("#msgModel").val()!="0"){
				$("#present_msg").html($("#msgModel").find("option:selected").text());
			}else{
				$("#present_msg").html("");
			}	
		}
	</script>
</body>
</html>