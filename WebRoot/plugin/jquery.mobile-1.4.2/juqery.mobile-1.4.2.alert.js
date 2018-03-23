/*
*jQuery简单消息框插件
*2014-03-14
*调用：
*$.dialog.alert("提示消息");
*对话框的调用：$.dialog.message("消息");仅有确定的对话框
*$.dialog.message("消息", true, callback);带取消和回调函数的对话框,空函数请传$.noop
*/
jQuery.dialog = {
	/*
	*消息框
	*/
	alert: function (text) {
		var $popOverlay=$('<div class="alert-overlay show"></div>')
		var $window = $('<div id="windowcenter" class="pop-alert"></div>');
		var $title = $('<div class="pop-title">操作提示</div>');
		var $close = $('<span class="pop-close"></span>');
		$close.click(function () {
			if ($("#windowcenter").length > 0) {
				$("#windowcenter").fadeOut(500);
				$('.alert-overlay').addClass("fade");
				$('.alert-overlay').remove();
			}
		});
		$title.append($close);
		$window.append($title);
		var $content = $('<div class="pop-centent"></div>');
		var $text = $('<div class="pop-text"></div>');
		$text.text(text);
		$content.append($text);
		$window.append($content);
		if ($("#windowcenter").length > 0) {
			$("#windowcenter").remove();
		}
		$("body").append($popOverlay);
		$("body").append($window);
		var scrollVal=$(window).scrollTop();
		
		if($('.ui-popup-screen').hasClass('in')){
			$('.alert-overlay').addClass("fade");
			$('.alert-overlay').remove();	
		}
		
		$("#windowcenter").fadeToggle("slow");
		setTimeout(function(){
			$("#windowcenter").fadeOut(500);
			$('.alert-overlay').addClass("fade");
			$('.alert-overlay').remove();
		}, 4000);
	},
	/*
	 *对话框  取消按钮在右边
	 */
	message: function (text, hasCancel, callback,okText) {
		var $popOverlay=$('<div class="pop-overlay show"></div>')
		var $popTips = $('<div id="popTips" class="pop-tips"></div>');
		var $popShow = $('<div></div>');
		/*var $title = $('<h4 class="pop-title">温馨提示</h4>');
		$popShow.append($title);
		*/
		var $text = $('<div class="pop-text"><img src="resource/image/icon/icon-comfirm.png" />' + text + '</div>');
		$popShow.append($text);
		var $popBtns = $('<div class="pop-buttons"></div>');
		//取消事件或OK事件
		var cancelEvent = function () {
			if ($("#popTips").length > 0) {
				$("#popTips").remove();
				$popOverlay.addClass("fade");
				$popOverlay.remove();
			}
		}
		var text='确定';
		if(okText){
			text=okText;
		}
		var $ok = $('<a href="javascript:void(0);" class="pop-btn pop-btn-confrim">'+text+'</a>');
		$popBtns.append($ok);
		//有取消按钮并且有确定的回调函数，设置确定后调用回调函数并追加取消按钮同时设定取消事件
		if (hasCancel && $.isFunction(callback)) {
			$ok.click(callback);
			$ok.click(cancelEvent);
			//设置取消按钮和取消事件
			$ok.css({ "width": "50%", "float": "left" });
			var $cancel = $('<a href="javascript:void(0);" class="pop-btn pop-btn-cancel brand-red" >取消</a>');
			$cancel.click(cancelEvent);
			$popBtns.append($cancel);
		} else {
			$ok.click(cancelEvent);
		}
		$popShow.append($popBtns);
		$popTips.append($popShow);
		if ($("#popTips").length > 0) {
			$("#popTips").remove();
		}
		$('body').append($popOverlay);
		$('body').append($popTips);
	},
	
	/*
	 *对话框 
	 *cancelLeft: 取消按钮在左边
	 */
	messageOperation: function (text, hasCancel, callback,okText,cancelText,cancelLeft) {
		var $popOverlay=$('<div class="pop-overlay show"></div>')
		var $popTips = $('<div id="popTips" class="pop-tips"></div>');
		var $popShow = $('<div></div>');
		/*var $title = $('<h4 class="pop-title">温馨提示</h4>');
		$popShow.append($title);
		*/
		var $text = $('<div class="pop-text"><img src="resource/image/icon/icon-comfirm.png" />' + text + '</div>');
		$popShow.append($text);
		var $popBtns = $('<div class="pop-buttons"></div>');
		//取消事件或OK事件
		var cancelEvent = function () {
			if ($("#popTips").length > 0) {
				$("#popTips").remove();
				$popOverlay.addClass("fade");
				$popOverlay.remove();
			}
		}
		var text='确定';
		if(okText){
			text=okText;
		}
		var $ok = $('<a href="javascript:void(0);" class="pop-btn pop-btn-confrim">'+text+'</a>');
		$popBtns.append($ok);
		//有取消按钮并且有确定的回调函数，设置确定后调用回调函数并追加取消按钮同时设定取消事件
		if (hasCancel && $.isFunction(callback)) {
			$ok.click(callback);
			$ok.click(cancelEvent);
			
			var cText = '取消';
			if(cancelText){
				cText = cancelText;
			}
			var $cancel = $('<a href="javascript:void(0);" class="pop-btn pop-btn-cancel" >'+cText+'</a>');
			$cancel.click(cancelEvent);
			$popBtns.append($cancel);
			
			//设置取消按钮和取消事件
			if(cancelLeft){
				$ok.css({ "width": "50%", "float": "right" });
				$ok.addClass('brand-red');
			}else{
				$ok.css({ "width": "50%", "float": "left" });
				$cancel.addClass('brand-red');
			}
		} else {
			$ok.click(cancelEvent);
		}
		$popShow.append($popBtns);
		$popTips.append($popShow);
		if ($("#popTips").length > 0) {
			$("#popTips").remove();
		}
		$('body').append($popOverlay);
		$('body').append($popTips);
	}
};  