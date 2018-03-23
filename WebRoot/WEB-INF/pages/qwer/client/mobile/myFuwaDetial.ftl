<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-我的果娃详情" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="myFuwas" class="my-fuwa-detial">
			<div class="orderhead">
				<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
				<div>我的果娃</div>
			</div>
		<div data-role="main" style="margin-top:41px;">
			<table id="proTable">
				<thead>
					<tr style="height:40px;">
						<td>果娃</td>
						<td>获得时间</td>
						<td>赠送人</td>
					</tr>
				</thead>
				<#if myFws?? && (myFws?size>0)>
					<#list myFws as myFw>
						<tr class="fuwa-info-tittle">
							<td width="25%">
								${myFw.fw_name}
							</td>
							<td width="50%">${myFw.get_time}</td>
							<td width="25%">${myFw.nickname!}</td>
						</tr>
					</#list>
				<#else>
					<tr class="no-fuwa"><td colspan="5">无果娃记录</td></tr>
				</#if>
			</table>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/jQuery/json2.js"></script>
	<script src="plugin/common/productDetial.js"></script>
	<script type="text/javascript">
		function back(){
			window.location.href="${CONTEXT_PATH}/myFuwa";
		}
	</script>
</body>
</html>