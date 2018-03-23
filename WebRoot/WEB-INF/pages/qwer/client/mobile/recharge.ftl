<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-充值" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="order" class="recharge-page">
	
		<div class="carthead">
			<div class="btn-back">
				<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div>充值</div>
    	</div>
    	
    	<div data-role="main" class="recharge-area bg-white">
    		<div class="recharge-box clearfix bg-white">	
    		    <div class="select-money">
    		        <h3>选择金额</h3>  		     
					<div class="row no-gutters just-content-start mb5">			           
					    <div class="col-3" >
					        <label for="recharge_money"><input type="radio" name="recharge_money" value="200" data-role="none"/> 200元</label>
					    </div>
					    <div class="col-3">
					        <label for="recharge_money"><input type="radio" name="recharge_money" value="300" data-role="none"/> 300元</label>
					    </div>
					    <div class="col-3">
					        <label for="recharge_money"><input type="radio" name="recharge_money" value="500" data-role="none"/> 500元</label>
					    </div>
					    <div class="col-3">
					        <label for="recharge_money"><input type="radio" name="recharge_money" value="1000" data-role="none"/> 1000元</label>
					    </div>
					</div>
				</div>
				  
				<div class="other-methoed">
				    <div class="other-money">其他金额: <input type="number" id="money" data-inline="true" data-role="none" onchange="dochange(this.value)" /> 元</div>
				    <p>说明：1个鲜果币/1元，鲜果币仅限微商城使用,不可兑换成现金。</p>
				 </div>
				
    		</div>
    		
    		<div class="btn-recharge">
    		    <button onclick="recharge(this)" class="btn-custom">确认充值</button>
    	    </div>
    	    
    	</div>
    	
    	<div class="m-banner">
			  <a href="${(rechargeBanner.url)!}"><img src="${(rechargeBanner.save_string)!}" height="70px"/></a>
	    </div>
	    
    </div>
    <#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/weixin/wechat.payment.js"></script>
	<script type="text/javascript">
		function back(){
			window.history.back();
		}
		
		$('input[type="radio"]').click(function (){
        	$("#money").val($(this).val());
   	 	});
		
		function recharge(btn){
			var money = $.trim($("#money").val());
			if(/^[0-9]*[1-9][0-9]*$/.test(money)){
				$(btn).wechatpay({
					ajax: {
						url: "${CONTEXT_PATH}/pay/recharge?totalFee="+parseFloat(money),
					},
					wcpay: {
						ok: function(res){ 
				            $.dialog.alert("微信支付成功!");
				    		window.location.href = "${CONTEXT_PATH}/pay/successRecharge";
						},
						fail: function(res){
				            //alert("微信支付失败!"); 这里不能alert
						}
					}
				});
			}else{
				$.dialog.alert("请输入正确的金额！");
			}
		}
		
		//屏蔽微信分享js
		wx.ready(function() {
		     wx.hideOptionMenu();
		});
	</script>
</body>
</html>