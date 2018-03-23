<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-充值页面" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="recharge_area" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					   <img height="20px" src="resource/image/icon/icon-back.png" />
					</a>
				</div>
				<span>充值</span>
		  </header>
		  
		  <section class="m-salary row justify-content-between no-gutters mt48"></section>
		  
		  <section class="m-recharge s-shadow1 bg-white">
		  
	            <h4>选择金额</h4>
				<div class="m-monery-sel row no-gutters just-content-start">			           
				    <div class="col-3" >
				        <label for="num1" @click="selectMoney(300)">
				        <input type="radio" name="recharge_money" value="300" id="num1"/>
				        300元</label>
				    </div>
				    <div class="col-3">
				        <label for="num2" @click="selectMoney(500)">
				        <input type="radio" name="recharge_money" value="500" id="num2"/> 
				        500元</label>
				    </div>
				    <div class="col-3">
				        <label for="num3" @click="selectMoney(800)">
				        <input type="radio" name="recharge_money" value="800" id="num3"/> 
				        800元</label>
				    </div>
				    <div class="col-3">
				        <label for="num4" @click="selectMoney(1000)">
				        <input type="radio" name="recharge_money" value="1000" id="num4"/> 
				        1000元</label>
				    </div>
				    <div class="w-100 mt10"></div>
				    <div class="col-3">
				        <label for="num5" @click="selectMoney(2000)">
				        <input type="radio" name="recharge_money" value="2000" id="num5"/> 
				        2000元</label>
				    </div>
				    <div class="col-3">
				        <label for="num6" @click="selectMoney(5000)">
				        <input type="radio" name="recharge_money" value="5000" id="num6"/> 
				        5000元</label>
				    </div>
				    <div class="col-3">
				        <label for="num7" @click="selectMoney(10000)">
				        <input type="radio" name="recharge_money" value="10000" id="num7"/> 
				        10000元</label>
				    </div>
				</div>
				
				<div class="m-money-input">  
				             其他金额
				    <input type="number" id="money" v-model.number.trim="money" :value="money"/> 元
				    <p>说明：1个鲜果币/1元，鲜果币仅限微商城使用，不可兑换成现金。</p>
				</div>
				
				<div class="m-settle text-center">
				   <button class="btn bnt-sm u-btn-brown js-btn-confirm" id="recharge-btn">确认充值</button>
		        </div>
		        
		  </section>
		  
		  <section class="m-recharge-rules">
		        <h4>充值优惠：</h4>
		        <ul>
					<li>单笔充值满300元，送20鲜果币</li>
					<li>单笔充值满500元，送50鲜果币</li>
					<li>单笔充值满800元，送90鲜果币</li>
					<li>单笔充值满1000元，送120鲜果币</li>
				    <li>单笔充值满2000元，送260鲜果币</li>
					<li>单笔充值满5000元，送700鲜果币</li>
					<li>单笔充值满10000元，送1500鲜果币</li>
				</ul>		
		  </section>
	</div>
	
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script type="text/javascript">
		$(function(){
			//实例化Vue 
		    var vm=new Vue({
			     mixins:[backHistory],
	             el:"#recharge_area",
	             data:{
	                 isActive:true,
	                 money:0
	     	     },
	             methods: {
	                 selectMoney:function(money){
	                     this.money=parseFloat(money);
		             }
	             }
			});

			$("#recharge-btn").on("click", function(e){
				e && e.preventDefault();
				$(this).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/payFruitmasterRecharge?totalFee=" + parseFloat($('#money').val())
					},
					wcpay: {
						ok: function(res){ 
				            $.dialog.alert("微信支付成功!");
				    		window.location.href = "${CONTEXT_PATH}/myself/me";
						},
						fail: function(res){
				            //alert("微信支付失败!"); 这里不能alert
						}
					}
			 	});
			});
		});
	</script>
</body>
</html>