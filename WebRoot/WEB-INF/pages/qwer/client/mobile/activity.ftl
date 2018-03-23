<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-${(activity.main_title)!}" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page">
			<div class="back">
				<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div data-role="main">
				<div>
					${(activity.content)!}
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