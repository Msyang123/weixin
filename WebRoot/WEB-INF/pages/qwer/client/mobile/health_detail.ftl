<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-养生知识" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page">
		<div data-role="main" class="bg-white">
			<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>鲜果养生</div>
			</div>
			<div class="rep-area">
			    <h3>${rep.rep_title}</h3>
    			<span>${rep.publish_time}</span>
    			<div class="rep-content">${rep.rep_content}</div>
    	    </div>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script>
		function back(){
	 		window.history.back();
	 	}
	</script>
</body>
</html>
