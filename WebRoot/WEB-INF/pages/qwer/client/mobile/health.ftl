<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-鲜果养生" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="health">
		<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>鲜果养生</div>
		</div>
		
		<div data-role="main">
			<div style="height:40px;"></div>
			<table id="health_table">
				<tr>
					<td>
						<img height="80px" src="resource/image/me/售前问题.png" onclick="healthList(1)"/><br/>
						美味果汁
					</td>
					<td>
						<img height="80px" src="resource/image/me/售后问题.png"  onclick="healthList(2)"/><br/>
						水果美容
					</td>
				</tr>
				<tr>
					<td>
						<img height="80px" src="resource/image/me/退换货.png"  onclick="healthList(3)"/><br/>
						水果食疗
					</td>
				</tr>
			</table>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
	 	function healthList(type){
	 		window.location.href="${CONTEXT_PATH}/healthList?type="+type;
	 	}
	 	
	 	function back(){
	 		window.history.back();
	 	}
	</script>
</body>
</html>