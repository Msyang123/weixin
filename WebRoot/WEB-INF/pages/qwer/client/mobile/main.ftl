<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-首页" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div id="main" data-role="page"></div>
	<div class="navbar-footer">
		<div class="ui-grid-b">
			<div class="ui-block-a mainmenu" id="mainPage">
				<img id="mainImg" src="${CONTEXT_PATH}/resource/image/menu/首页.png" /><br /> <span>首页</span>
			</div>
			<div class="ui-block-b mainmenu" id="cartPage">
				<img id="cartImg" src="${CONTEXT_PATH}/resource/image/menu/购物车.png" /><br /> <span>购物车</span>
			</div>
			<div class="ui-block-c mainmenu" id="selfPage">
				<img id="selfImg" src="${CONTEXT_PATH}/resource/image/menu/我的.png" /><br /> <span>我的</span>
			</div>
		</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<!--<script src="plugin/weixin/address.js?v={.now?long}"></script>-->
	<script src="plugin/jQuery/json2.js"></script>
	<script type="text/javascript">
	$(function(){
		//$.cookie('cartInfo',null,{path:"/",expires: -1});
		//$.cookie('zscartInfo',null,{path:"/",expires: -1});
		//$.cookie('basketInfo',null,{path:"/",expires: -1});
		$("#mainPage").click(function(){
			  $("#mainImg").attr("src","${CONTEXT_PATH}/resource/image/menu/首页1.png");
			  $("#cartImg").attr("src","${CONTEXT_PATH}/resource/image/menu/购物车.png");
			  $("#selfImg").attr("src","${CONTEXT_PATH}/resource/image/menu/我的.png");
			  $("#cartPage").css("color","black");
			  $("#selfPage").css("color","black");
			  $("#mainPage").css("color","#de374e");
			  $("#main").load("${CONTEXT_PATH}/shopIndex");
			});
		
		$("#cartPage").click(function(){
			  $("#mainImg").attr("src","${CONTEXT_PATH}/resource/image/menu/首页.png");
			  $("#cartImg").attr("src","${CONTEXT_PATH}/resource/image/menu/购物车1.png");
			  $("#selfImg").attr("src","${CONTEXT_PATH}/resource/image/menu/我的.png");
			  $("#selfPage").css("color","black");
			  $("#mainPage").css("color","black");
			  $("#cartPage").css("color","#de374e");
			  $("#main").load("${CONTEXT_PATH}/cart");
			});
		
		$("#selfPage").click(function(){
			  $("#mainImg").attr("src","${CONTEXT_PATH}/resource/image/menu/首页.png");
			  $("#cartImg").attr("src","${CONTEXT_PATH}/resource/image/menu/购物车.png");
			  $("#selfImg").attr("src","${CONTEXT_PATH}/resource/image/menu/我的1.png");
			  $("#mainPage").css("color","black");
			  $("#cartPage").css("color","black");
			  $("#selfPage").css("color","#de374e");
			  $("#main").load("${CONTEXT_PATH}/me");
			});
		var _index = '${index}';
		if(_index=="0"){
			$("#mainPage").click();
		}else if(_index=="1"){
			$("#cartPage").click();
		}else{
			$("#selfPage").click();
		}
		
	});
	</script>
</body>
</html>
	

