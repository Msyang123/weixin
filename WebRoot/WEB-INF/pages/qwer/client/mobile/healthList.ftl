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
	<div data-role="page" id="main">
		<div class="orderhead">
			<div class="btn-back"><a onclick="window.history.go(-1)"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>鲜果养生</div>
		</div>
		<div data-role="main" class="health-list">
			<!-- <div class="fq_cat">积分及优惠券问题</div> -->
			<ul data-role="listview" id="rep_list">
				<#list repList as item>
  				<li>			
    				<a style="" onclick="viewRepDetail('${item.id}')">${item.rep_title}</a>
  				</li>
  				</#list>
			</ul>		
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function viewRepDetail(id){
			window.location.href="${CONTEXT_PATH}/healthDetail?id="+id;
		}
    </script>
</body>
</html>