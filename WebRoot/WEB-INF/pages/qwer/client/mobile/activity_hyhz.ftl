<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-好友互赠" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page">
		<div class="back">
		    <a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
	    </div>
		<div data-role="main">
			<div id="content">
				<div style="xnxg">
					<img src="resource/image/activity/zs/好友在线互赠详情_01.jpg" />
					<img src="resource/image/activity/zs/好友在线互赠详情_02.jpg" />
					<img src="resource/image/activity/zs/好友在线互赠详情_03.jpg" />
					<img src="resource/image/activity/zs/好友在线互赠详情_04.jpg" />
					<img onclick="window.location.href='${CONTEXT_PATH}/present'" src="resource/image/activity/zs/好友在线互赠详情_05.jpg" />
				</div>
			</div>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function back(){
			window.location.href="${CONTEXT_PATH}/main?index=0";
		}
	</script>
</body>
</html>