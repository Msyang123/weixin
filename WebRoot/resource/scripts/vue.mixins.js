var formatCurrency={
	 filters: {
	    formatCurrency: function (value) {
	        return common.formatCurrency(value);
	    }
	  }
}

var formatHead = {
	filters: {
    	formatImg:function(value){
    		if (!value) return 'resource/image/icon-master/default_icon.png';
    	    return value.toString();
    	}
    }
}

var backHistory={
	methods:{
		back:function(){
    		//window.location.href=document.referrer;
			window.history.back();
        }
	}
}

var navBar={  
    methods:{
    	 goHome:function(){
         	window.location.href = "/weixin/masterIndex/index";
         },
         goMall:function(){
         	window.location.href = "/weixin/mall/shopIndex";
         },
         goMe:function(){
         	window.location.href = "/weixin/myself/me";
         },
         goFresh:function(){
         	window.location.href = "/weixin/foodFresh/foodFresh?type=1&pageNumber=1&pageSize=4";
         },
         goCart:function(){
        	setTimeout(function(){
        		window.location.href="/weixin/fruitShop/cart";
        	},800);
         }
    }		
}

