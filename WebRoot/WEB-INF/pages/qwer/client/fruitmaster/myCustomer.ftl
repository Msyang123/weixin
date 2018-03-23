<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-我的客户列表页面" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_customer" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>我的客户</span>
	        <a href="javacript:void(0);" class="u-btn-modal" data-toggle="modal" data-target="#codeModel">推荐二维码</a>
	    </header>
	    
	   <div id="letter"></div>
	   
	   <div class="sort_box">
			<div v-for="item in customerObject.customers" :key="item.id">
				<a class="sort_list row no-gutters" :href="'${CONTEXT_PATH}/fruitmaster/myCustomerDetail?master_id=' + customerObject.master_id + '&user_id='+ item.user_id">
					<div class="num_logo col-4">
						<img v-bind:src="item.user_img_id"/>
					</div>
					<div class="col">
						<p class="num_name">{{item.nickname}}</p>
						<p class="num_phone">{{item.phone_num}}</p>
						<p class="num_info mt5">备注：{{item.master_desc}}</p>
					</div>				
				</a>
			</div>
	   </div>
	   
	   <div class="initials"><ul></ul></div>
	
	  <div class="modal fade m-modal" id="codeModel" tabindex="-1" role="dialog" aria-hidden="true">
	      <div class="modal-dialog">
	   		<div class="modal-content">
	         	<div class="modal-body m-code-box">	
		           	<img :src="'${CONTEXT_PATH}/fruitmaster/printTwoBarCode?master_id='+customerObject.master_id+'&recommend=true&master_recommend='+customerObject.master_id">
		           	<p>推荐鲜果师二维码<p>
	          </div>
	        </div>
	      </div>
	 </div>
	</div>
	
	<script src="plugin/spell/jquery.charfirst.pinyin.js"></script>
	<script src="plugin/spell/sort.js"></script>
	<script>
		$(function () {
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory],
		        el:"#my_customer",
		        data:{
		        	customerObject:${customers},
		        },
		        created: function () {
		        	
		        },
		        computed:{
		        },
		        filters: {
		        },
		        methods: {
		        }
		     });
			initials();
			//$(".sort_letter").prev(".sort_list").css('background', 'black');
		});
	</script>
</body>
</html>