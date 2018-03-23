<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-兑换记录" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>

<body>
	<div data-role="page" class="bg-white">
	
		<div class="orderhead">
			<div class="btn-back">
				<a onclick="back();"><img height="20px"
					src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div>兑换记录</div>
		</div>
	    
		<div data-role="main" class="mt41 bg-white">
			<#if records?? && (records?size>0) >
				<div class="record-list">
					<#list records as records>
						<div class="row no-gutters record-box">
							<div class="col-3 record-img">
								<img src="${records.save_string!}" onerror="imgLoad(this)"/>
							</div>
							<div class="col-9 record-info">
								<p class="record-name">${records.record_name}</p>
								<p class="record-text">兑换时间</p>
								<p class="record-time">${records.create_time}</p>
							</div>
						</div>	
					</#list>		
				</div>
			<#else>
				<div id="no_pro">
					<img src="resource/image/icon/coupon_empty.png">
					<p>本期没有奖品呢</p>
				</div>
			</#if>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function back(){
			window.history.back();
		}
	</script>
</body>
</html>