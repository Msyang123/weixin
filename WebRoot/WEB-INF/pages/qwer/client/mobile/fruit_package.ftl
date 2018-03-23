<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-水果也来抢" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>

	<div data-role="page">
		<div class="back">
			<a onclick="back();"><img height="20px"
				src="resource/image/icon/icon-back.png" /></a>
	    </div>
		<div data-role="main">
			<div id="content">
				<div style="width:100%;">
					<!-- 内部水果礼包-->
					<h3>我来抢水果规则</h3>
					<pre>
						1：用户在自己的仓库中选择商品
						2：添加您的好友进入此次疯狂大赛中
						3：设置你准备的套路
						4：GO	
					</pre>
					<div class="recievePresent" id="recievePresent" >
						<div class="close-gift">
							<img id="closeGift" style="width:100%;"  src="resource/image/huodong/personGift/关闭.png">
						</div>
						<div id="fdImg">
							<img style="width:100%;" src="resource/image/huodong/personGift/福袋.jpg">
						</div>
						<div id="giftDiv">
							<img id="giftImg" src="" />
							<br/>
							 恭喜您获得  
							<span id="giftProName"></span>  
							<span id="giftProAmount"></span>
							<br/>
							<button data-inline="true" data-mini="true" id="goStorage" style="height:30px;">去仓库查看</button>
						</div>
					</div>
				    <div class="mask"></div>
				</div>
			</div>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		$(function(){
			$(".recievePresent").css("left",(window.screen.width-300)/2+"px");
			$("#fdImg").bind("click",function(){
				$.ajax({
		            type: "POST",
		            url: "${CONTEXT_PATH}/activity/personGift",
		            data: {},
		            dataType: "json",
		            success: function(data){
		           		if(data.status=="success"){
		           			$("#giftImg").attr("src",data.giftProduct.save_string);
		    				$("#giftProName").html(data.giftProduct.product_name);
		    				$("#giftProAmount").html(data.giftProduct.total_amount+""+data.giftProduct.unit_name);
		    				$("#fdImg").hide();
		    				$("#giftDiv").show();
		           		}else{
		           			$.dialog.alert(data.msg);
		           		}
		           }
		       });
			});
			
			$("#closeGift").bind("click",function(){
				$("#recievePresent").hide();
				$(".mask").hide();
			});
			
			$("#goStorage").bind("click",function(){
				window.location.href="${CONTEXT_PATH}/myStorage";
			});
		});
	
		function back(){
	 		window.history.back();
	 	}
    </script>
</body>
</html>