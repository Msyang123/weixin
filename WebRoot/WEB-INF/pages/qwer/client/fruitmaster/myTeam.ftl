<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-我的团队页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_team" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>我的团队</span>
	    </header>
	    
	    <section class="m-list">
			<div class="itm row bg-white s-shadow2 no-gutters" v-for="item in teamObject.teamList">
				<div class="itm-img col-3">
					<img v-bind:src="item.head_image | formatImg" onerror="common.imgLoadHead(this)">
				</div>
				<div class="itm-info col">
					<p class="s-info-title">{{item.master_name}}</p>
					<p class="s-info-text">{{item.phone_num}}</p>
					<p class="s-info-text">当月绩效&yen; {{item.month_total | formatCurrency}}</p>
				</div>
				<a class="itm-btn col-2" :href="'${CONTEXT_PATH}/fruitmaster/subMaster?master_id=' + item.id">
			        <img src="resource/image/icon-master/icon_more_single.png" width="16px">
			    </a>
			</div>
		</section>
		
	</div>  

	<script>
		$(function () {
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatHead,formatCurrency],	
		        el:"#my_team",
		        data:{
		        	teamObject:${master_team}
		        }
		     });
		});
	</script> 
</body>
</html>