<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-客户详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_customer_details" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>我的客户</span>
	    </header>
	    
	   	<div class="bg-gradient" style="height:12rem;"></div>
	   	
	   	<section class="m-customer-details bg-white s-shadow2">
	   		<img v-bind:src="userDetail.user_img_id">
	   		<div class="u-customer-info">
   				<p>{{userDetail.nickname}}</p>
   				<p>{{userDetail.phone_num}}</p>
	   		</div>
	   		<div class="m-sales-info">
		   		<p>消费总次数：<span>{{userDetail.all_orders_count}}</span></p>
		   		<p>消费总金额：<span>&yen; {{userDetail.all_orders_total | formatCurrency}}</span></p>
		   		<p>本月消费次数：<span>{{userDetail.month_orders_count}}</span></p>
		   		<p>本月消费总金额：<span>&yen; {{userDetail.month_orders_total | formatCurrency}}</span></p>
	   		</div>
	   	</section>
	   	
	   	<form class="m-remark bg-white s-shadow2" id="userinfo_form">
	   		<button type="button" @click="editDesc">修改</button>
	   		<textarea rows="5" id="userDesc" name="userDesc" 
	   		oninput="common.reExpression()" 
	   		v-model="userDetail.master_desc" 
	   		placeholder="为这个客户添加点备注吧..."></textarea>
	   	</form>
	</div>
	
	<script>
		$(function () {
			var validtor;
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatCurrency],
		        el:"#my_customer_details",
		        data:{
			        userDetail:${master_user_detail},
		        },
		        mounted:function(){
		        	validtor=$('#userinfo_form').validate({
	        			rules: {
	        				userDesc: {
	        			        required: false,
	        			        maxlength: 100
	        			    },
		        	    },
	        			messages: {
	        				userDesc: {
	        			        required: "请简单写点什么吧...",
	        			        maxlength: "最多不超过100个字符"
	        			    },
		        	    }
		            });
			    },
		        methods: {
		        	editDesc:function(){
		        		var that = this;		            
		        		var masterId = this.userDetail.master_id;
		        		var userId = this.userDetail.user_id;
		        		var description = this.userDetail.master_desc;
		        		
		        		if(!validtor.form()){
			        		return false;
			            }
		        		
	        			$.ajax({
				            type: "POST",
				            data:{
				            	master_id:masterId,
				            	user_id:userId,
				            	description:description
			 	            	},
			 	            url: "${CONTEXT_PATH}/fruitmaster/updateMasterUserDescription",
				            dataType: "json",
				            success: function(data){
				            	$.dialog.alert(data.msg);
				            }
				        });
		        	}
		        }
		     });
		});  
	</script>
</body>
</html>