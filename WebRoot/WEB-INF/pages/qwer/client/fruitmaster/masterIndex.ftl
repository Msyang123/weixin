<!DOCTYPE html>
<html>
<head>
<title>美味食鲜-鲜果师管理</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-鲜果师后台首页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>

<body class="bg-grey-light">

	<div id="master_index" class="wrapper">
		<div class="bg-me">
			<img src="resource/image/icon-master/bg_me.png" width="100%">
		</div>
		
		<section class="m-master-info bg-white s-shadow2" v-cloak>
			<div class="row no-gutters mb8">
				<a class="master-img col-3" :href="'${CONTEXT_PATH}/fruitMaster/masterInfo?master_id=' + master.id ">
					<img :src="master.head_image | formatImg"  onerror="common.imgLoadHead(this)">
				</a>
				<a class="master-info col" :href="'${CONTEXT_PATH}/fruitMaster/masterInfo?master_id=' + master.id ">
					<p class="name">{{master.master_name}}</p>
					<p class="intro">{{master.description}}</p>
				</a>
				<a href="javacript:void(0);" class="master-code col-3" data-toggle="modal" data-target="#codeModel">
			        <img src="resource/image/icon-master/btn_me_code.png">
			    </a>
			</div>
			
			<div class="row no-gutters m-sale" @click="goAachievement" v-cloak>
				<div class="col-4 text-center">
					<p class="sale-title">今日成交单数</p>
					<p class="sale-num">{{master.today_amount}}</p>
				</div>
				<div class="col-4 text-center">
					<p class="sale-title">总销售额</p>
					<p class="sale-num">&yen; {{master.all_total | formatCurrency}}</p>
				</div>
				<div class="col-4 text-center">
					<p class="sale-title">今日销售额</p>
					<p class="sale-num">&yen; {{master.today_total | formatCurrency}}</p>
				</div>
			</div>
		</section>
		
		<section class="m-master-nav bg-white s-shadow2">
			<div class="row no-gutters">
				<div class="col-4 u-nav-itm" @click="goTeam">
					<img src="resource/image/icon-master/icon_backstage_team.png">
					<p>我的团队</p>
				</div>
				<div class="col-4 u-nav-itm" @click="goCustomer">
					<img src="resource/image/icon-master/icon_backstage_customer.png">
					<p>我的客户</p>
				</div>
				<div class="col-4 u-nav-itm" @click="goSalary">
					<img src="resource/image/icon-master/icon_backstage_income.png">
					<p>我的收入</p>
				</div>
				<div class="col-4 u-nav-itm" @click="goOrder">
					<img src="resource/image/icon-master/icon_backstage_order.png">
					<p>订单管理</p>
				</div>
				<div class="col-4 u-nav-itm" @click="goMall">
					<img src="resource/image/icon-master/icon_backstage_mall.png">
					<p>美味食鲜</p>
				</div>
				<div class="col-4 u-nav-itm" @click="goHelp">
					<img src="resource/image/icon-master/icon_backstage_help.png">
					<p>帮助中心</p>
				</div>
			</div>
		</section>
		
		<div class="modal fade m-modal" id="codeModel" tabindex="-1" role="dialog" aria-hidden="true">
		      <div class="modal-dialog">
		   		<div class="modal-content">
		         	<div class="modal-body m-code-box">	
			           	<img :src="'${CONTEXT_PATH}/fruitmaster/printTwoBarCode?recommend=false&master_id='+master.id">
			           	<p>我的二维码<p>
		          </div>
		        </div>
		     </div>
	   	</div>
		
	</div>

	<script>
	$(function(){
		//实例化Vue
		var vm=new Vue({
			   mixins:[formatHead,formatCurrency],
			   el:"#master_index",
		       data:{
		          master:${master_info},
		       },
		       filters: {
		       	formatImg:function(value){
		       		if (!value) return 'resource/image/icon-master/default_icon.png';
		       	    return value.toString();
		       	}
		       },
		       mounted() {
		    	   
		       },
		       methods: {
	               goTeam:function(){
	                  	window.location.href = "/weixin/fruitmaster/masterTeam?master_id="+this.master.id;
	               },
	               goCustomer:function(){
	                  	window.location.href = "/weixin/fruitmaster/masterCustomer?master_id="+this.master.id;
	               },
	               goSalary:function(){
	                  	window.location.href = "/weixin/fruitMaster/mySalary?master_id="+this.master.id;
	               },
	               goOrder:function(){
	               		window.location.href = "/weixin/fruitMaster/masterOrders?status=1&pageNumber=1&pageSize=4&master_id="+this.master.id;
	               },
	               goHelp:function(){
	            	   window.location.href="${CONTEXT_PATH}/myself/faqList?type=4";
	               },
	               goAachievement:function(){
	            	   window.location.href = "/weixin/fruitMaster/achievement?days=7&master_id=" + this.master.id; 
	               },
	               goMall:function(){
         				window.location.href = "/weixin/mall/shopIndex";
         		   }
		       }
		});
	})
	</script>
</body>
</html>