/** 用户点击分享到微信圈后加载接口 */
!function($) {
	"use strict";
	var share_info = {
		title: $("#share_title").val(),
		desc: $("#share_desc").val(),
		link: $("#share_link").val(),
		imgUrl: $("#share_imgurl").val(),
		success: function() {},
		cancel : function() {}
	};

	wx.config({
		debug : false,
		appId : $("#appId").val(),
		timestamp : $("#timestamp").val(),
		nonceStr : $("#nonceStr").val(),
		signature : $("#signature").val(),
		jsApiList : [ "onMenuShareTimeline", "onMenuShareAppMessage","onMenuShareQQ","onMenuShareWeibo","onMenuShareQZone", "getLocation","openAddress"]
	});
	
	wx.ready(function() {
		wx.onMenuShareTimeline(share_info);
		wx.onMenuShareAppMessage(share_info);
	});
	
	wx.error(function(res) {
	});
}(jQuery);