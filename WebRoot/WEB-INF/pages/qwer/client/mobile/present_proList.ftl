<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-赠送选购" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order" class="present-prolist bg-white">
    	<div class="carthead search-head">
			<div class="btn-back">
				<a onclick="back();">
					<img style="height:20px;width:10px;"src="${CONTEXT_PATH}/resource/image/icon/icon-back1.png" />
				</a>
			</div>
			<div class="search-box">
				<img src="resource/image/icon/icon-search.png">
				<input type="search" data-role='none' data-mini="true" name="search" id="search" placeholder="搜索赠送选购水果...">
			</div>
			<div class="btn-search">
				<a onclick="searchPro();">搜索</a>
			</div>
    	</div>
    	<div data-role="main">
    		<div id="proListDiv"></div>
    	</div>
    </div>
    <#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/jQuery/json2.js"></script>
	<script src="plugin/gw/parabola.js"></script>
	<script type="text/javascript">
		function back(){
			window.location.href="${CONTEXT_PATH}/me";
		}
		function searchPro(){
			var keyword = $("#search").val();
			$("#cart").css("display","block");
			$("#proListDiv").load("${CONTEXT_PATH}/searchZsProList?keyword="+keyword);
		}
		jQuery(function($) {
			searchPro();
		});
	</script>
</body>
</html>