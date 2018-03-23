(function(window, $, undefined) {
	//如果用户是重新进入微商城，则会把门店信息的cookie清除，重新定位
	if($.cookie('storeInfo')==null){
		wx.ready(function() {
			wx.getLocation({
			    type: 'wgs84',
			    success: function (res) {
					var oLat = res.latitude; 
			    	var oLng = res.longitude;
					$.ajax({
			            type: "POST",
			            url: "/weixin/storeList",
			            data:{lat:oLat,lng:oLng,flag:1},
			            dataType: "json",
			            success: function(data){
			            	if(data){
			            		var storeId = data[0].store_id;
			            		//当前位置的store_id,用于查询库存
			            		$.cookie('store_id',storeId,{expires:15,path:'/'});
			            		//将当前位置的门店信息存储
			            		var storeInfo = '{"storeLat":"'+oLat+'","storeLng":"'+oLng+'","storeName":"'+data[0].store_name+'"}';
			            		$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
			            	}
			            }
		        	});
					$("#loading-mask").hide();
				},
				//若定位失败或者是用户取消了定位 则默认为红星旗舰店
				fail: function (err) {
					var storeId = '07310109';
					var storeInfo = '{"storeLat":"'+$("#lat").val()+'","storeLng":"'+$("#lng").val()+'","storeName":"'+$("#near_store").html()+'"}';
					
					$.cookie('store_id',storeId,{expires:15,path:'/'});
            		$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
					$.dialog.alert("请允许访问您的位置 ; )");
			    },
			    cancel: function (res) {
			    	var storeId = '07310109';
					var storeInfo = '{"storeLat":"'+$("#lat").val()+'","storeLng":"'+$("#lng").val()+'","storeName":"'+$("#near_store").html()+'"}';
					
					$.cookie('store_id',storeId,{expires:15,path:'/'});
					$.cookie('storeInfo',storeInfo,{expires:15,path:'/'});
					$.dialog.alert("请允许访问您的位置 ; )");
			    },
			    complete:function(info){
			    	
			    }
			});
		});
	}
})(window, jQuery);