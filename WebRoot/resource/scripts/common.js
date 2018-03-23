var common = {};
(function(window, $, undefined) {
	/**
	 * 图片加载异常处理
	 */
	imgLoad = function imgLoad(element) {
		var imgSrc = $(element).height() < 80 ? "resource/image/icon/failed-small.png"
				: "resource/image/icon/failed-big.png"
		$(element).attr("src", imgSrc);
	}

	imgLoadMaster = function imgLoadMaster(element) {
		var imgSrc = "resource/image/icon-master/img-error-big.png";
		$(element).attr("src", imgSrc);
	}
	
	imgLoadHead = function imgLoadHead(element){
		var imgSrc="resource/image/icon-master/default_icon.png";
   		$(element).attr("src",imgSrc);
	}
	
	/**
	 * 购物车对象飞入
	 */
	objectFlyIn = function objectFlyIn(_sourceImg, _target, _back) {
		var addOffset = _target.offset();

		var img = _sourceImg;
		var flyer = $('<img style="display: block;width: 50px;height: 50px;border-radius: 50px;position: fixed;z-index: 999;" src="'
				+ img.attr('src') + '">');
		var X, Y;

		if (img.offset()) {
			X = img.offset().left - $(window).scrollLeft();
			Y = img.offset().top - $(window).scrollTop();
		}
		flyer.fly({
			start : {
				left : X + img.width() / 2 - 25, // 开始位置（必填）
				top : Y + img.height() / 2 - 25 // 开始位置（必填）
			},
			end : {
				left : addOffset.left + 10, // 结束位置（必填）
				top : addOffset.top + 10, // 结束位置（必填）
				width : 10, // 结束时宽度
				height : 10
			// 结束时高度
			},
			onEnd : function() { // 结束回调
				this.destroy(); // 移除dom
				_back();
			}
		});

	}

	/**
	 * 购物车对象飞出
	 */
	objectFlyOut = function objectFlyOut(_sourceImg, _target, _back) {
		var addOffset = _target.offset();

		var img = _sourceImg;
		var flyer = $('<img style="display: block;width: 50px;height: 50px;border-radius: 50px;position: fixed;z-index: 999;" src="'
				+ img.attr('src') + '">');

		flyer.fly({
			start : {
				left : addOffset.left, // 开始位置（必填）
				top : addOffset.top
			// 开始位置（必填）
			},
			end : {
				left : addOffset.left - 20, // 结束位置（必填）
				top : addOffset.top - 20, // 结束位置（必填）
				width : 5, // 结束时宽度
				height : 5
			// 结束时高度
			},
			onEnd : function() { // 结束回调
				this.destroy(); // 移除dom
				_back();
			}
		});
	}

	/**
	 * 倒计时
	 */
	countDownTimer = function countDownTimer(node, hour, minute, second) {
		var timer = setInterval(function() {
			minutes_1 = parseInt(minute / 10);
			minutes_2 = minute % 10;
			second_1 = parseInt(second / 10);
			second_2 = second % 10;
			node.html(hour + ":" + minutes_1 + minutes_2 + ":" + second_1
					+ second_2);
			if (second == 0) {
				if (hour == 0 && minute == 0 && second == 0) {
					clearInterval(timer);
				} else {
					second = 60;
					if (minute == 0) {
						hour--;
						minute = 60
					}
					minute--;
				}
			}
			second--;
		}, 1000);
	}

	/**
	 * 商城所有价钱数据/100 保留2位小数
	 */
	formatCurrency = function formatCurrency(value) {
		if (!value)
			return '0.00';
		return Number(parseFloat(value / 100.0)).toFixed(2);
	}

	isPC = function isPC() {
		var userAgentInfo = navigator.userAgent;
		var Agents = [ "Android", "iPhone", "SymbianOS", "Windows Phone",
				"iPad", "iPod" ];
		var flag = true;
		for (var v = 0; v < Agents.length; v++) {
			if (userAgentInfo.indexOf(Agents[v]) > 0) {
				flag = false;
				break;
			}
		}
		return flag;
	}

    /**
     * 银行卡校验
     */
	//Luhm校验规则：16位银行卡号（19位通用）
	// 1.将未带校验位的 15（或18）位卡号从右依次编号 1 到 15（18），位于奇数位号上的数字乘以 2
	// 2.将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
	// 3.将加法和加上校验位能被 10 整除
	luhmCheck=function luhmCheck(bankno){
	    var lastNum=bankno.substr(bankno.length-1,1);//取出最后一位（与luhm进行比较）
	    var first15Num=bankno.substr(0,bankno.length-1);//前15或18位
	    var newArr=new Array();
	    for(var i=first15Num.length-1;i>-1;i--){    //前15或18位倒序存进数组
	        newArr.push(first15Num.substr(i,1));
	    }
	    var arrJiShu=new Array();  //奇数位*2的积 <9
	    var arrJiShu2=new Array(); //奇数位*2的积 >9
	    var arrOuShu=new Array();  //偶数位数组
	    for(var j=0;j<newArr.length;j++){
	        if((j+1)%2==1){//奇数位
	            if(parseInt(newArr[j])*2<9)
	            arrJiShu.push(parseInt(newArr[j])*2);
	            else
	            arrJiShu2.push(parseInt(newArr[j])*2);
	        }
	        else //偶数位
	        arrOuShu.push(newArr[j]);
	    }
	     
	    var jishu_child1=new Array();//奇数位*2 >9 的分割之后的数组个位数
	    var jishu_child2=new Array();//奇数位*2 >9 的分割之后的数组十位数
	    for(var h=0;h<arrJiShu2.length;h++){
	        jishu_child1.push(parseInt(arrJiShu2[h])%10);
	        jishu_child2.push(parseInt(arrJiShu2[h])/10);
	    }        
	     
	    var sumJiShu=0; //奇数位*2 < 9 的数组之和
	    var sumOuShu=0; //偶数位数组之和
	    var sumJiShuChild1=0; //奇数位*2 >9 的分割之后的数组个位数之和
	    var sumJiShuChild2=0; //奇数位*2 >9 的分割之后的数组十位数之和
	    var sumTotal=0;
	    for(var m=0;m<arrJiShu.length;m++){
	        sumJiShu=sumJiShu+parseInt(arrJiShu[m]);
	    }
	    for(var n=0;n<arrOuShu.length;n++){
	        sumOuShu=sumOuShu+parseInt(arrOuShu[n]);
	    }
	    for(var p=0;p<jishu_child1.length;p++){
	        sumJiShuChild1=sumJiShuChild1+parseInt(jishu_child1[p]);
	        sumJiShuChild2=sumJiShuChild2+parseInt(jishu_child2[p]);
	    }      
	    //计算总和
	    sumTotal=parseInt(sumJiShu)+parseInt(sumOuShu)+parseInt(sumJiShuChild1)+parseInt(sumJiShuChild2);
	    //计算Luhm值
	    var k= parseInt(sumTotal)%10==0?10:parseInt(sumTotal)%10;        
	    var luhm= 10-k;
	    
	    if(lastNum==luhm){
	       return true;
	    }
	    else{
	       return false;
	    }        
	}
	
	 /**
     * 过滤文本域的表情
     */	
	reExpression = function reExpression(event){
		event = event ? event : window.event; 
		var oText=$(event.target).val();
		var regStr = /[\uD83C|\uD83D|\uD83E][\uDC00-\uDFFF][\u200D|\uFE0F]|[\uD83C|\uD83D|\uD83E][\uDC00-\uDFFF]|[0-9|*|#]\uFE0F\u20E3|[0-9|#]\u20E3|[\u203C-\u3299]\uFE0F\u200D|[\u203C-\u3299]\uFE0F|[\u2122-\u2B55]|\u303D|[\A9|\AE]\u3030|\uA9|\uAE|\u3030/g;
		if(regStr.test(oText)){
		  $(event.target).val(oText.replace(regStr,""));
		}
	}
	
	common = {
		imgLoad : imgLoad,
		imgLoadMaster : imgLoadMaster,
		imgLoadHead : imgLoadHead,
		objectFlyIn : objectFlyIn,
		objectFlyOut : objectFlyOut,
		countDownTimer : countDownTimer,
		formatCurrency : formatCurrency,
		isPC : isPC,
		luhmCheck:luhmCheck,
		reExpression:reExpression
	}
	
})(window, jQuery);

//setInterval(function(){
//	$('iframe').parent("div").not("#m-article-content").remove();
//}, 500);

String.prototype.format = function() {
	if (arguments.length == 0)
		return this;
	for (var s = this, i = 0; i < arguments.length; i++)
		s = s.replace(new RegExp("\\{" + i + "\\}", "g"), arguments[i]);
	return s;
};

function getDateFormat(date){
	var month = date.getMonth()+1;
	var day = date.getDate();
	return month+"-"+day+" ";
}

function dateAdd(dtTmp, Number) {  
    return new Date(Date.parse(dtTmp) + (86400000 * Number));
}

//创建补0函数
function fillZreo(s) {
    return s < 10 ? '0' + s: s;
}

function getFullDate(date){
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	var day = date.getDate();
	return year+"-"+fillZreo(month)+"-"+fillZreo(day)+" "
}