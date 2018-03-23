<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-门店信息" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
 </head>
<body>	
<div data-role="page" class="store">
	<div data-role="main">
		<div class="orderhead">
			<div class="btn-back">
				<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div>门店信息</div>
		</div>
	
		<div data-role="collapsibleset" id="stroe_list">
		<#list storeList as item>
	      <div class="store-list" data-role="collapsible" data-collapsed="true" data-mini="true" data-collapsed-icon="carat-d" data-expanded-icon="carat-u" data-iconpos="right">
	        <h3>${item.store_name} <#if item.distance??>(约${item.distance}km)</#if></h3>
	        <table class="store-table">
	        	<tr>
	        		<td colspan="4">
	        			<img  width="100%" src="${item.storeimg!}"/>
	        		</td>
	        	</tr>
	        	<tr>
	        		<td class="store-info">
	        			<i><img src="${CONTEXT_PATH}/resource/image/icon/store-flag.png"></i>
	        			<span>门店宣言</span>
	        		</td>
	        		<td>
	        			${item.store_declar!}
	        		</td>
	        	</tr>
				<tr>
	        		<td class="store-info">
	        			<i><img src="${CONTEXT_PATH}/resource/image/icon/store-adr.png"></i>
	        			<span>门店地址</span>
	        		</td>
	        		<td>
	        			${item.store_addr!}
	        		</td>
	        	</tr>
	        	<tr>
	        		<td class="store-info">
	        			<i><img src="${CONTEXT_PATH}/resource/image/icon/store-phone.png"></i>
	        			<span>联系电话</span>
	        		</td>
	        		<td>
	        			${item.store_phone!}
	        		</td>
	        	</tr>
	        	<!--<tr>
	        		<td class="store-info">
	        			<span>二维码</span>
	        		</td>
	        		<td >
	        			<div class="code-box">
	        				<a href="#img1" data-rel="popup" data-transition="slideup">
	        				<img src="${item.qrcodeimg!}"/>
	        				</a>
	        				<br/>
	        				<span>店铺二维码</span>
	        			</div>
	        			<div class="code-box">
	        				<a href="#img1" data-rel="popup" data-transition="slideup">
	        				<img src="${item.wxgroupimg!}"/>
	        				</a>
	        				<br/>
	        				<span>微信群二维码</span>
	        			</div>
	        			
	        		</td>
	        		
	        	</tr>-->
	        </table>
	        <div data-role="popup" id="img1" class="ui-content">
		      <a href="javascript:;" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
		       <img src="${item.qrcodeimg!}">
		    </div>
		    <div data-role="popup" id="img2" class="ui-content">
		      <a href="javascript:;" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
		       <img src="${item.wxgroupimg!}">
		    </div>
	      </div>
 		</#list>
 		</div>
 		
	</div>
</div>
<#include "/WEB-INF/pages/common/share.ftl"/>
<script type="text/javascript">
	function back(){
		window.history.back();
	}
</script>
</body>
<!-- 
<div data-role="footer" style="height: 20px;"></div> -->
