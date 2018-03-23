<!DOCTYPE html>
<!-- 弃用 -->
<head>
<base href="${CONTEXT_PATH}/"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>菜单</title>
<!-- <script src="js/jquery.min.js" type="text/javascript"></script> -->
<script src="js/menu.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="css/menu_admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<!--[if lt IE 8]>
   <style type="text/css">
   li a {display:inline-block;}
   li a {display:block;}
   </style>
   <![endif]-->
</head>
<body>
	<ul id="menu">
		<#list sessionMenu.keySet() as items>
			<li>
				<a href="javascript:;">${items}</a>
				<ul>
					<#list sessionMenu[items] as item>
						<li><a href="${item.href!'#'}">${item.menu_name}</a></li>
					</#list>
				</ul>
			</li>
		</#list>
		
	</ul>
	<br />
<br />
</body>
</html>