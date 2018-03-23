<#macro layout scripts >
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="zh-CN" xmlns="http://www.w3.org/1999/xhtml" lang="zh-CN">
<head>
<base href="${CONTEXT_PATH}/"/>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<!-- <link href="css/manage.css" media="screen" rel="stylesheet" type="text/css" />
<script src="js/jquery.min.js" type="text/javascript" ></script> -->
</head>
<body>
	<div class="manage_container">
		<div class="manage_head">
			<div class="manage_logo"><a href="http://code.google.com/p/jfinal" target="_blank">JFinal web framework</a></div>
			<div id="nav">
				<ul>
					<li><a href=""><b>首页</b></a></li>
					<li><a href="blog"><b>Blog管理</b></a></li>
				</ul>
			</div>
		</div>
		<div class="main">
			<#nested>
		</div>
	</div>
</body>
<#list scripts as item >
    <script src="${(item)! }"></script>
</#list>
</html>
</#macro>