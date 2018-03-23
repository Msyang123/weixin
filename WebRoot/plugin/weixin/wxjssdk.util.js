/* 
 * wxjssdk 1.0
 * Copyright (c) 2017 By Andrew 
 * Date: 2017-11-05
 * 使用wxjsdk，需引用jquery.js,artdailog.js,include share.ftl
 */
;(function ($,window,document,undefined) {
   'use strict';
    var appDomain=$("#app_domain").val();
    //定义wxShare的构造函数
	var wxShare=function(opts){
		  var defaultOpt={
		    title:'我很喜欢在“水果熟了”买水果，推荐你也来用！',//分享标题,不能为空
		    desc:'每一颗水果你都可以放心享用，不必担心农药超标，虫子叮咬等质量问题',//分享描述，可以为空，（分享到朋友圈，不支持描述）
		    link:appDomain+'/main',//分享页面地址,不能为空
		    imgUrl:appDomain+'/resource/image/logo/shuiguoshullogo.png',//分享是封面图片，不能为空
		    success:function(){},//分享成功触发
		    cancel:function(){} //分享取消触发，需要时可以调用
		  }
		  
		  if (opts == undefined || opts == null) {
			  opts = {};
	    }
		this.opts=$.extend({},defaultOpt,opts);
	}
	
	//定义wxShare的方法
	wxShare.prototype={
		  //绑定微信朋友圈，发送朋友
		  bindWX:function(){
		    var _opts=this.opts;
		    //监听，分享到朋友圈
		    wx.onMenuShareTimeline({
			      title:_opts.title,
			      link:_opts.link,
			      imgUrl:_opts.imgUrl,
			      success:function(){
			        if(_opts.success)
			          _opts.success();
			      },
			      calcel:function(){
			        if(_opts.cancel)
			          _opts.cancel();
			      }
		    });
		    //监听，分享给朋友 （type，dataurl基本可以放弃不使用）
		    wx.onMenuShareAppMessage({
			      title: _opts.title, // 分享标题
			      desc: _opts.desc, // 分享描述
			      link: _opts.link, // 分享链接
			      imgUrl: _opts.imgUrl, // 分享图标
			      success: function () {
			        if(_opts.success)
			          _opts.success();
			      },
			      cancel: function () {
			        if(_opts.cancel)
			          _opts.cancel();
			      }
		    });
		  },
		  //绑定QQ空间，QQ好友
		  bindQQ:function(){
		    var _opts=this.opts;
		    //监听，分享到QQ空间
		    wx.onMenuShareQZone({
		      title: _opts.title, // 分享标题
		      desc: _opts.desc, // 分享描述
		      link: _opts.link, // 分享链接
		      imgUrl: _opts.imgUrl, // 分享图标
		      success: function () {
		        if(_opts.success)
		          _opts.success();
		      },
		      cancel: function () {
		        if(_opts.cancel)
		          _opts.cancel();
		      }
		    });
		    //监听，分享到QQ
		    wx.onMenuShareQQ({
		      title: _opts.title, // 分享标题
		      desc: _opts.desc, // 分享描述
		      link: _opts.link, // 分享链接
		      imgUrl: _opts.imgUrl, // 分享图标
		      success: function () {
		        if(_opts.success)
		          _opts.success();
		      },
		      cancel: function () {
		        if(_opts.cancel)
		          _opts.cancel();
		      }
		    });
		  },
		  //绑定默认，不使用腾讯微博
		  bind:function(){
		    this.bindWX();
		    this.bindQQ();
		  },
		  //绑定所有,包括腾讯微博
		  bindAll:function(){
		    this.bind();
		    var _opts=this.opts;
		    //监听，分享到腾讯微博 (基本可以放弃不使用)
		    wx.onMenuShareWeibo({
		      title: _opts.title, // 分享标题
		      desc:_opts.desc, // 分享描述
		      link: _opts.link, // 分享链接
		      imgUrl:_opts.imgUrl, // 分享图标
		      success: function () {
		        if(_opts.success)
		          _opts.success();
		      },
		      cancel: function () {
		        if(_opts.cancel)
		          _opts.cancel();
		      }
		    });
		 }
	}
	
	$.fn.wxJsUtil = function (_options) {
 
		var defaults = {
			 debug: false,
			 appId: '', // 必填，企业号的唯一标识，此处填写企业号corpid
			 timestamp:'',// 必填，生成签名的时间戳
			 nonceStr: '',// 必填，生成签名的随机串
			 signature: '',// 必填，签名，见附录1
			 jsApiList: ['checkJsApi','onMenuShareTimeline','onMenuShareAppMessage','onMenuShareQQ','onMenuShareWeibo','hideMenuItems',
			 'showMenuItems','hideAllNonBaseMenuItem','showAllNonBaseMenuItem','translateVoice','startRecord','stopRecord',
			 'onRecordEnd','playVoice','pauseVoice','stopVoice','uploadVoice','downloadVoice','chooseImage','previewImage','uploadImage',
			 'downloadImage','getNetworkType','openLocation','getLocation','hideOptionMenu','showOptionMenu','closeWindow','scanQRCode',
			 'chooseWXPay','openProductSpecificView','addCard','chooseCard','openCard'
			 ]// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
		};
		
	    if (_options == undefined || _options == null) {
            _options = {};
        }

        this.options = $.extend({}, defaults, _options);

        var options = this.options;
        
	    function getWxParam(url){
		     var url = location.href.split('#')[0];
		     url = encodeURIComponent(url);
			 var promise = new Promise(function(resolve, reject){
				 //发送ajax去请求配置参数
				 $.ajax({
					  type:'GET',
					  url: 'weixinApi/getAppProps?url='+url,
					  dataType: 'json'
				 }).then(function(result){
					  //console.log(result);
					  var wxOptions={
						 debug: false,
						 appId: result.appid,
						 timestamp: result.timestamp,
						 nonceStr: result.nonce_str,
						 signature: result.signature,
						 jsApiList: ['checkJsApi','onMenuShareTimeline','onMenuShareAppMessage','onMenuShareQQ','onMenuShareWeibo','scanQRCode',
						             'chooseImage','previewImage','uploadImage','openLocation','getLocation','hideOptionMenu','showOptionMenu']
					  }
					  
					  options=$.extend({},options,wxOptions);
					  console.log(options);
					  
					  wx.config(options);
					  
					  //默认公共页面模板类型的分享调用
					  wx.ready(function(){
						  var share=new wxShare();
						  share.bind();
					  });
					  
					  wx.error(function(res){
					      console.log(res.errMsg);
					  });
					  
					  resolve();
				 },function(error){
				      console.log(error);
				 });
			 });
		     return promise;
		}
	    
		this.callWx =function(){
			  getWxParam();
		}	
		this.callWx();
	    return this;
	}
	window.wxShare=wxShare;
})(jQuery,window,document);