<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="page-header">
	<h1>
		操作台
		<small>
			<i class="ace-icon fa fa-angle-double-right"></i>
			每日汇总及预览
		</small>
	</h1>
</div>
<#if orderFailCount gt 0>
	<div class="alert alert-danger alert-message">
		<button type="button" class="close" data-dismiss="alert">
			<i class="ace-icon fa fa-times"></i>
		</button>
        <a href="/weixin/orderManage/initOrderList" class="send-fail"><i class="ace-icon fa fa-exclamation-triangle"></i> 海鼎订单发送失败${orderFailCount}单</a>
	</div>
 </#if>

<!--[if !IE]> -->
<script type="text/javascript">
	window.jQuery || document.write("<script src='plugin/ace/assets/js/jquery-2.0.3.min.js'>"+"<"+"script>");
</script>
<!-- <![endif]-->

<!--[if IE]>
<script type="text/javascript">
 window.jQuery || document.write("<script src='plugin/ace/assets/js/jquery-1.10.2.min.js'>"+"<"+"script>");
</script>
<![endif]-->

		<script src="plugin/ace/assets/js/bootstrap.min.js"></script>
		<script src="plugin/ace/assets/js/typeahead-bs2.min.js"></script>

		<!-- page specific plugin scripts -->

		<!--[if lte IE 8]>
		  <script src="plugin/ace/assets/js/excanvas.min.js"></script>
		<![endif]-->

		
 
</@layout>