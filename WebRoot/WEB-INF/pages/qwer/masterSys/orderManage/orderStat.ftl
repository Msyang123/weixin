<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
    <div class="col-xs-12 wigtbox-head">
		<form id="submitForm" action="${CONTEXT_PATH}/masterOrderManage/orderStatResult" method="post">
				支付时间 <input type="text" id="createDateBegin" name="payDateBegin" value='${payDateBegin!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	        	至 <input type="text" id="createDateEnd" name="payDateEnd" value='${payDateEnd!}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
		        <button class="btn btn-info btn-sm" id="searchBtn" type="button">
		            <i class="fa fa-search bigger-110"></i>查询
		        </button>
	    </form>  
    </div>
    
    <div class="col-xs-8">   
	    <table class="table table-striped">
	    	<tr><th>类型</th><th>累计金额</th></tr>
	    	<#if result?? && (result?size>0)>
	        	<#list result as item >
	        		<tr>
	        			<td>${item.source_type}</td>
	        			<td>${item.total_fee/100}元</td>
	        		</tr>
	        	</#list>
			</#if>
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