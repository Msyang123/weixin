<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order">
		<div class="carthead">
			<div class="btn-back">
				<a onclick="backToMain();">
					<img style="height:20px;width:10px;"src="${CONTEXT_PATH}/resource/image/icon/icon-back.png" />
				</a>
			</div>
			<div style="float:left;width:90%;padding-top:5px;">
				${activity.main_title}
			</div>
    	</div>
    	<div data-role="main">
    		<div style="height:40px;"></div>
    		<div id="proListDiv">
    			
    		</div>
    	</div>
    </div>
    <#include "/WEB-INF/pages/common/share.ftl"/>
    <script type="text/javascript">
		$(function() {
			$("#cart").css("display","block");
			$("#proListDiv").load("${CONTEXT_PATH}/productByActivityId?activityId=${activityId}");
		});
    </script>
</body>
</html>