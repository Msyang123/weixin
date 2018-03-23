<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-我的果币余额页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_rest" class="wrapper">
	      <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>我的果币</span>
				<a class="u-btn-modal" href="${CONTEXT_PATH}/myself/myRestDetail">余额明细</a>
		  </header>
		  
		  <section class="m-rest-money text-center mt68">
		        <img src="resource/image/icon-master/icon_balance.png" height="100"/>
		        <h4>我的余额</h4>
		        <span class="brand-blue">&yen; {{balance | formatCurrency}}</span>
	          	<div class="u-btn-recharge col-12 text-center">
		        	<button class="btn bnt-sm u-btn-brown" @click="goRecharge">充值</button>
		        	<p>Tip：鲜果币用于购买微商城内商品，1鲜果币=1元</p>
		        </div>
		  </section>
	</div>
	
    <#include "/WEB-INF/pages/common/share.ftl"/>
	<script>
		$(function() {
			var vm=new Vue({
				mixins:[backHistory,formatCurrency],
                el:"#my_rest",
                data:${user},
                computed:{

                },
                filters: {

                },
                methods: {
                    goRecharge:function(){
                    	window.location.href="${CONTEXT_PATH}/pay/payFruitmasterSbmtRecharge";
                    }
                }
		     });
		});
	</script>
</body>
</html>