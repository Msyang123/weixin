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
	<div data-role="page" id="faq_list">

		<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>帮助中心</div>
		</div>
		
		<div data-role="main" class="help-list">
			<table id="faq_table">
				<tr>
					<td>
						<a  onclick="faqList(1)">
							<img height="80px" src="resource/image/icon/shouqianwenti.png"/><br/>
							售前问题
						</a>
					</td>
					<td>
						<a onclick="faqList(2)">
							<img height="80px" src="resource/image/icon/shouhouwenti.png" /><br/>
							售后问题
						</a>
					</td>
				</tr>
				<tr>
					<td>
						<a onclick="faqList(3)">
							<img height="80px" src="resource/image/icon/tuihuanhuo.png"/><br/>
							退换货
						</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
	 	function faqList(type){
	 		window.location.href="${CONTEXT_PATH}/faqList?type="+type;
	 	}
	 	
	 	function back(){
	 		window.history.back();
	 	}
    </script>
</body>
</html>