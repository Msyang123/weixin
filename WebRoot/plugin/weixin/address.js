/** 用户获取收货地址接口 */
!function($) {
	wx.config({
		debug : false,
		appId : $("#appId").val(),
		timestamp : $("#timestamp").val(),
		nonceStr : $("#nonceStr").val(),
		signature : $("#signature").val(),
		jsApiList : [ 'openAddress', ]
	});
	
	wx.ready(function() {
		wx.openAddress({
            success: function (res) {
            	//回调设置收货地址
            	//setAddress(10000,res.userName,res.telNumber,receiver_address);
            	//此处需要通过ajax将用户地址存入用户地址表（t_receiver_address）中，如果存在就修改信息，否则新增
				//保存到cookie    
		         //$.cookie('userAddress',JSON.stringify(res),{expires:15,path:'/'});
            	//保存地址信息  先不存code 直接存文字信息
            	$.ajax({
                    type: "get",
                    url: CONTEXT_PATH+"/saveAddress",
                    data: { 
                   	 receiver_name:res.userName,
                   	 receiver_mobile:res.telNumber, 
                   	 province:res.provinceName,
                   	 city:res.cityName, 
                   	 area:res.countryName,
                   	 receiver_address:res.detailInfo,
                   	 is_default:'0'//默认
                    },
                    dataType: "json",
                    success: function(data){
                   	 if(data.status=="success"){
                   		 $("#addressList").load("${CONTEXT_PATH}/addressList");
                       	 clearForm();
                       	 $("#addressFormDiv").hide();
                       	
                       	setAddress(data.record.id,res.userName,res.telNumber,
                    			res.provinceName + " " + res.cityName + " " + res.countryName + " " + res.detailInfo);
                   	 }else{
                   		 alert(data.errorMsg);
                   	 }
                   	 
                    }
                });
            },
            cancel: function (res) {
            },
            fail: function (res) {
              alert("错误:"+JSON.stringify(res));
            }
        });
	});
	wx.error(function() { });
}(jQuery);