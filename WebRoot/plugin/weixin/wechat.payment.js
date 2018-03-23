!function($) {
	"use strict";
	
	var available = true;
	
	$.fn.wechatpay = function(option){
		return this.each(function(){
			if(!available){
				return;
			}
			this.options = $.extend({
				ajax: {
					async: false,
					type: "POST"
				},
				wcpay: {
					ok: function(res,data){ },
					fail: function(res,data){ }
				},
				balancepay: function(data){},
				validator: function(){return true;}
			}, option);

			if(!this.options.validator()){
				return;
			}
			available = false;
			var that = this;
			$.ajax(that.options.ajax).done(function(data){
				if(data.msg){
					if( data.state== "success"){
						//added by andrew
					    $('.custom-dialog').show();
		            	that.options.balancepay(data);
					}else{
						$('.custom-dialog').find('img').attr('src','resource/image/icon/pay-failed.png')
						$('.custom-dialog').find('p').text(data.msg);
						$('.custom-dialog').show();
						if(data.resouce_from==0){
							setTimeout("window.location.href='/weixin/main?index=0';",3000);
						}else if(data.resouce_from==1){
							setTimeout("window.location.href='/weixin/mall/shopIndex';",3000);
						}
					}
					return;
				}
				if(parseInt(data.agent) < 5){
					$('.custom-dialog').find('img').attr('src','resource/image/icon/pay-failed.png')
					$('.custom-dialog').find('p').text('"您的微信版本太低，无法完成微信支付！"');
					$('.custom-dialog').show();
					return;
				}
				WeixinJSBridge.invoke("getBrandWCPayRequest", {
		  		 	"appId" : data.appid,
		  		 	"timeStamp" : data.timeStamp, 
		  		 	"nonceStr" : data.nonceStr, 
		  		 	"package" : data.packageValue,
		  		 	"signType" : "MD5", 
		  		 	"paySign" : data.sign
				},function(res){
		            if(res.err_msg == "get_brand_wcpay_request:ok"){
		            	that.options.wcpay.ok(res,data);
		            }else{
	                //get_brand_wcpay_request：cancel或者get_brand_wcpay_request：fail可以统一处理为用户遇到错误或者主动放弃，不必细化区分。
		            	that.options.wcpay.fail(res,data);
		            }
				});
			});
			available = true;
		});
	}
}(jQuery);	