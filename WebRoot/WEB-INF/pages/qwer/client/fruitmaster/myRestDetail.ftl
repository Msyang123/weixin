<!DOCTYPE html>
<html>
<head>
	<title>美味食鲜</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="美味食鲜- 余额明细" />
    <#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>
	<div id="my_rest_detail" class="wrapper my-balance-detail">
	    
       <header class="g-hd bg-white">
			<div class="u-btn-back">
				<a href="javascript:void(0);" onclick="back()">
				<img height="20px" src="resource/image/icon/icon-back.png" /></a>
			</div>
			<span>充值记录</span>
	    </header>
		  
		<div class="main mt48">
    		<#if (payLogs??)&&(payLogs?size>0)>
	    		<table class="tab text-center">
	    			<thead>
	    				<tr style="height:44px;">
	    					<td>充值时间</td>
	    					<td>充值金额</td>
	    					<td>赠送金额</td>
	    				</tr>
	    			</thead>
	    			<tbody>
						<#list payLogs as payLog>
		    			<tr>
		    				<td>${payLog.recharge_time}</td>
		    				<td style="color:#de374e;font-weight:700;">&yen; ${(payLog.total_fee!0)/100}</td>
		    				<td style="color:#de374e;font-weight:700;">&yen; ${(payLog.give_fee!0)/100}</td>
		    			</tr>
		    			</#list>
	    			</tbody>
	    		</table>
	    	<#else>
				<div class="z-none">
					<img src="resource/image/icon-master/expression_helpless.png">
					<p>您没有过充值记录哦~</p>
				 </div>
			</#if>
    	</div>
    </div>
    
    <script>
          function back(){
        	  window.history.back();      	  
          }
    </script>
</body>
</html>