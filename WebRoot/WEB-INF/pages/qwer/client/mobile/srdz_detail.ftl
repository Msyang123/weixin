<!DOCTYPE html>
<html>
<head>
<title>水果熟了-私人定制</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-私人定制" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
<style>
	#tcImg{
		width:100%;
	}
	.srdz-detail{
	 	left: 10px; 
	 	top:10px; 
	 	position:fixed;
	}
</style>
</head>
<body>
	<div data-role="page">
		<div class="srdz-detail">
				<a onclick="back();"><img height="20px"
					src="resource/image/icon/icon-back.png" /></a>
		</div>
		<img id="tcImg" src="resource/image/activity/srdz/${tc}.png">
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function back(){
	 		window.history.back();
	 	}
	</script>
</body>
</html>