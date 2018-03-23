<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-帮助中心" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="faq_list" class="bg-white">
	
		<div class="orderhead">
			<div class="btn-back"><a onclick="window.history.go(-1)"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div class="type-name">${typeName}</div>
		</div>	
		
		<div data-role="main" class="faq-list">
			<!-- div class="fq_cat">积分及优惠券问题</div> -->
			<#list faqList as item>
			<div data-role="collapsible" style="text-align:left;" data-collapsed-icon="carat-d" data-expanded-icon="carat-u" class="help-list-same">
      			<h3>${item.faq_title}</h3>
      			<p>${item.faq_content}</p>
    		</div>
    		</#list>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
</body>
</html>