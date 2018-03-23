<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-提货成功" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order">
    	<div data-role="main">
    		<div style="margin-top:40%;">
    		<img style="width:150px" src="resource/image/icon/tixianchenggong.png"><br/>
    		提货订单已提交，请于相应时间进行提取！[<span id="time">3</span>]
    		</div>
    	</div>
    </div>
    <#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		var t = setInterval(function(){
			var seconds = parseInt($("#time").html());
			if(seconds==0){
				clearInterval(t);
				window.location.href = "${CONTEXT_PATH}/myOrder?type=2";
			}else{
				$("#time").html(seconds-1)
			}
		},1000);
	</script>
</body>
</html>