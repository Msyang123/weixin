<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了- 余额明细" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="my-balance-detail">
		<div class="carthead">
			<div class="btn-back">
				<a onclick="window.history.back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div>
				充值记录
			</div>
    	</div>
		<div data-role="main">
    		<div style="height:40px;"></div>
    		<table class="tab">
    			<thead>
    				<tr style="height:44px;">
    					<td>充值时间</td>
    					<td>充值金额</td>
    					<td>赠送金额</td>
    				</tr>
    			</thead>
				<#list payLogs as payLog>
    			<tr>
    				<td>${payLog.recharge_time}</td>
    				<td style="color:#de374e;font-weight:700;">￥${(payLog.total_fee!0)/100}</td>
    				<td style="color:#de374e;font-weight:700;">￥${(payLog.give_fee!0)/100}</td>
    			</tr>
    			</#list>
    		</table>
    	</div>
    </div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
</body>
</html>