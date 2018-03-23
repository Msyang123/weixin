<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
    <div class="col-xs-12 wigtbox-head">
		<form id="submitForm" action="${CONTEXT_PATH}/orderManage/orderStatResult" method="post">
				支付时间 <input type="text" id="createDateBegin" name="payDateBegin" value='${payDateBegin!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	        	至 <input type="text" id="createDateEnd" name="payDateEnd" value='${payDateEnd!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
		        <button class="btn btn-info btn-sm" id="searchBtn" type="button">
		            <i class="fa fa-search bigger-110"></i>查询
		        </button>
	    </form>  
    </div>
    
    <div class="col-xs-6">   
	    <table class="table table-bordered">
	    	<tr><th>类型</th><th>累计金额</th></tr>
	    	<#if result?? && (result?size>0)>
	        	<#list result as item >
	        		<tr>
	        			<td>${item.source_type}：</td>
	        			<td>${item.total_fee/100}元</td>
	        		</tr>
	        	</#list>
			</#if>
<!-- 			<tr> -->
<!--     			<td>有效订单金额：</td> -->
<!--     			<td>${((orderStat.total)!0)/100}元</td> -->
<!--     		</tr> -->

			<#if orderStat?? && (orderStat?size>0)>
				<#list orderStat as order>
					<tr>
		    			<td>${order.orderStatus!}</td>
		    			<td>${((order.total)!0)/100}元</td>
		    		</tr>
				</#list>
			</#if>
    		<!-- <tr>
    			<td>已付款订单金额：</td>
    			<td>${((orderStat.total)!0)/100}元</td>
    		</tr>
    		<tr>
    			<td>已收货订单金额：</td>
    			<td>${((orderStat.total)!0)/100}元</td>
    		</tr>
    		<tr>
    			<td>已完成订单金额显示：</td>
    			<td>${((orderStat.total)!0)/100}元</td>
    		</tr>
    		<tr>
    			<td>退货订单金额：</td>
    			<td>${((orderStat.total)!0)/100}元</td>
    		</tr> -->
	    <table>
    </div><!-- /.col -->
</@layout>
<script>	
	$(function() {
	     $("#searchBtn").click(function(){
	     	$("#submitForm").submit();
	     });
     });
</script>