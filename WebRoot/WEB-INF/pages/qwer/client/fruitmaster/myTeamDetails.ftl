<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-我的团队详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_team_details" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>我的团队</span>
	    </header>
	    
	   	<div class="bg-gradient"></div>
	   	
	   	<section class="m-member-details bg-white s-shadow2">
	   		<div class="row no-gutters u-member">
	   			<div class="col-3 u-member-img">
	   				<img v-bind:src="memberDetail.head_image | formatImg">
	   			</div>
	   			<div class="col u-member-info">
	   				<p>{{memberDetail.master_name}}</p>
	   				<p>{{memberDetail.phone_num}}</p>
	   				<p>加盟时间：   <span>{{memberDetail.create_time}}</span></p>
	   			</div>
	   		</div>
	   		<div class="m-sales-info">
		   		<p>总销售额：<span>&yen; {{memberDetail.total |formatCurrency}}</span></p>
		   		<p>当月销售：<span>&yen; {{memberDetail.month_total |formatCurrency}}</span></p>
		   		<p>本月产生红利：<span>&yen; {{memberDetail.bonus |formatCurrency}}</span></p>
	   		</div>
	   	</section>
	   	
	</div>
	<script>
		$(function () {
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatCurrency,formatHead],
		        el:"#my_team_details",
		        data:{memberDetail:${subMasterDetail}}
		     });
		});  
	</script>   
</body>
</html>