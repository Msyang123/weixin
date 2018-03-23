<!DOCTYPE html>
<html>
<head>
	<title>美味食鲜-我的</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="美味食鲜-我的个人页" />
	<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">
	<input type="hidden" id="lat" name="lat" />
	<input type="hidden" id="lng" name="lng" />
    
    <div id="mine_area" class="wrapper">
         <header class="m-personinfo">
              <div class="m-personbox s-shadow1 row no-gutters justify-content-start align-items-center">
                 <div class="col-4 plSame u-img">
                    <img :src="master.tUser.user_img_id | formatImg" height="70"/>
                 </div>
                 <div class="col-5"  v-cloak>
                      <h3>{{master.tUser.nickname}}</h3>
                      <p>鲜果币<span class="money ml15" @click="goMyRest">{{master.tUser.balance/100.0}}</span></p>
                 </div>
                 <div class="col-3 text-center" v-if="master.isFruitMaster">
                      <a href="javacript:void(0);" data-toggle="modal" data-target="#qrcode"><img src="resource/image/icon-master/btn_me_code.png" width="50%"/></a>
                 </div>
              </div>
         </header>
         
         <section class="m-orderinfo s-shadow1 bg-white">
               <div class="m-more row no-gutters justify-content-center align-items-center">
                      <div class="col-6">我的订单</div>
                      <div class="col-6 text-right" @click="goMyOrder(0)">更多
                      <img src="resource/image/icon-master/btn_genduo.png" class="ml10 mb5" height="20" />
                      </div>
               </div>
               
               <div class="m-card row no-gutters justify-content-center align-items-center"  v-cloak>
                   <div class="col-4 text-center" @click="goMyOrder(1)">
                        <img src="resource/image/icon-master/btn_me_daifukuan.png" />
                        <h4>待付款</h4>
                        <span class="bage-boll" v-if="master.totalOrder.dfk>0">{{master.totalOrder.dfk}}</span>
                   </div>
                   <div class="col-4 text-center" @click="goMyOrder(2)">
                        <img src="resource/image/icon-master/btn_me_daisouhuo.png" />
                        <h4>待收货</h4>
                        <span class="bage-boll" v-if="master.totalOrder.dsh>0">{{master.totalOrder.dsh}}</span>
                   </div>
                   <div class="col-4 text-center" @click="goMyOrder(3)">
                        <img src="resource/image/icon-master/btn_me_tuihuo.png" />
                        <h4>退货</h4>
                        <span class="bage-boll" v-if="master.totalOrder.th>0">{{master.totalOrder.th}}</span>
                   </div>
               </div>
         </section>  
         
         <section class="m-toolkit s-shadow1 bg-white">
               <div class="m-card row no-gutters justify-content-center align-items-center">
                   <div class="col-4 text-center" v-if="master.isFruitMaster" @click="goMasterIndex">
                        <img src="resource/image/icon-master/btn_me_master.png" />
                        <h4>鲜果师后台</h4>                      
                   </div>
                   <div class="col-4 text-center" v-if="!master.isFruitMaster" @click="goMasterApply">
                        <img src="resource/image/icon-master/btn_master_apply.png" />
                        <h4>申请鲜果师</h4>                     
                   </div>
                   <div class="col-4 text-center" @click="goHelperCenter">
                        <img src="resource/image/icon-master/icon_backstage_help.png" />
                        <h4>帮助中心</h4>
                   </div>
                   <div class="col-4 text-center" data-toggle="modal" data-target="#contact_servicer" style="cursor:pointer;">
                        <img src="resource/image/icon-master/btn_me_feedback.png" />
                        <h4>问题反馈</h4>
                   </div>
               </div>
        </section>
         
        <div class="modal fade m-modal" id="contact_servicer" tabindex="-1" role="dialog" aria-hidden="true">
		      <div class="modal-dialog">
		   		<div class="modal-content">
		         	<div class="modal-body">	
			           	<h4>客服微信：<span class="js-account">1384568888</span></h4>
			           	<h4>留言框</h4>
			           	<input type="text" name="title"class="u-input-title form-control" placeholder="标题"
			           	v-model.trim="fbTitle" @focus="focusHandler" autocomplete="off" />
			           	<textarea id="feed_back" name="content" v-model.trim="fbContent" @focus="focusHandler"
			           	class="u-textarea-content form-control" placeholder="尽情的吐槽吧" oninput="common.reExpression()"></textarea>
			           	<span class="text-danger brand-red" v-show="isInvalid">{{errorMsg}}</span>
			           	<div class="text-center">
				        	<button class="btn bnt-sm u-btn-brown" @click="submitFeedBack">提交</button>
				        </div>
		         	</div>
		          </div>
		      </div>
		 </div>
         
		 <div class="modal fade m-modal" id="qrcode" tabindex="-1" role="dialog" aria-hidden="true">
		      <div class="modal-dialog">
		   		<div class="modal-content">
		         	<div class="modal-body m-code-box">	
			           	<img :src="'${CONTEXT_PATH}/fruitmaster/printTwoBarCode?recommend=false&master_id='+master.id">
			           	<p>美味食鲜<p>
		          </div>
		        </div>
		     </div>
	   	 </div>
	
	
         <footer class="m-nav row no-gutters">
			<div class="col u-nav-btn" @click="goHome">
				<img src="resource/image/icon-master/nav_home_default.png">
				<br/><span class="f-nav-index">首页</span>
			</div>
			<div class="col u-nav-btn active" @click="goMall">
				<img src="resource/image/icon-master/nav_mall_default.png">
				<br/><span class="f-nav-mall">商城</span>
			</div>
			<div class="col u-nav-btn u-nav-center" @click="goFresh">
				<img src="resource/image/icon-master/nav_center_default.png">
			</div>
			<div class="col u-nav-btn" @click="goCart">
				<img src="resource/image/icon-master/nav_cart_default.png">
				<br/><span class="f-nav-cart">购物车</span>
			</div>
			<div class="col u-nav-btn" @click="goMe">
				<img src="resource/image/icon-master/nav_me_selected.png">
				<br/><span class="z-crt f-nav-me">我的</span>
			</div>
	    </footer>
    </div>
    
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">	
		$(function(){
			//实例化Vue
			 var vm=new Vue({
				    mixins:[backHistory,navBar,formatHead],
					el:"#mine_area",
	                data:{
	                   master:${masterObj},
	                   isShow:false,
	                   fbTitle:"",
	                   fbContent:"",
	                   isInvalid:false,
	                   errorMsg:""
	                },
	                computed:{
	
	                },
	                filters: {
	                	formatImg:function(value){
	                		if (!value) return 'resource/image/img-master/mall_banner.png';//暂时用这张图
	                	    return value.toString();
	                	},
	                	foramtPhone:function(value){
	                		if (!value) return 'N/A'
	                		return value.toString();
	                	}
	                },
	                mounted() {
	                    /* axios.get("${CONTEXT_PATH}/masterIndex/foodDetail?pid=")
	                    .then(response => {this.data = response.data.results}) */
	                },
	                methods: {
	                    goMyRest:function(){
	                    	window.location.href="${CONTEXT_PATH}/myself/myRest";
	                    },  
	                    goMasterIndex:function(){
	                        window.location.href="${CONTEXT_PATH}/fruitMaster/masterIndex?master_id="+this.master.master_id;
	                    },
	                    goMasterApply:function(){
	                        window.location.href="${CONTEXT_PATH}/fruitMaster/masterIndex";
	                    },
	                    goHelperCenter:function(){
	                    	window.location.href="${CONTEXT_PATH}/myself/faqList?type=5";
	                    },
	                    goMyOrder:function(status){
	                    	window.location.href="${CONTEXT_PATH}/myself/userOrder?type="+status;
	                    },
	                    focusHandler:function(){
	                         this.isInvalid=false;
	                         this.errorMsg="";
	                    },
	                    submitFeedBack:function(){
	                       var _this=this;
	                       //先进行校验 标题内容不能为空
	                       if(!_this.checkParam()){return false;}
	                       //处理JFinal后台接收不到contentType为Json数据结构参数问题
	                       var params = new URLSearchParams();
	                       params.append('title', _this.fbTitle);
	                       params.append('content',_this.fbContent);
	                       //提交数据到后台
	                       axios.post('${CONTEXT_PATH}/myself/saveFeedBack',params)
	                       .then(function(response){
	                           $('.m-modal').modal('hide');
	                    	   if(response.data.status){
	                               $.dialog.alert("提交成功，谢谢您的及时反馈！");
	                           }else{
	                        	   $.dialog.alert("提交失败，请尝试重新提交！");
	                           }
	                       })
	                       .catch(function(error){
	                            console.log(error);
	                       });
	                    },
	                    checkParam:function(){
	                         var _this=this;
	                         var msg="标题不能为空";
	                         var msg2="内容不能为空";
	                         
	                         if(_this.fbTitle==""&&_this.fbContent==""){
	                              msg=msg+","+msg2;
	                              _this.isInvalid=true;
	                              _this.errorMsg=msg;
	                              return false;
	                         }
	                         
	                         if(_this.fbTitle==""){
	                        	 _this.isInvalid=true;
	                             _this.errorMsg=msg;
	                             return false;
	                         }  
	                         
	                         if(_this.fbContent==""){
	                        	 _this.isInvalid=true;
	                             _this.errorMsg=msg2;
	                             return false;
	                         }
	                         return true;
	                    }
	                }
			 });
			
			 $('#contact_servicer').on('show.bs.modal',function(){
                 //清除掉上次填的数据
                 vm.fbTitle="";
                 vm.fbContent="";
                 vm.isInvalid=false;
                 vm.errorMsg="";
			 });
			 
			wx.ready(function() {
			    wx.getLocation({
				    type: 'wgs84',
				    success: function (res) {
				    	$("#lat").val(res.latitude);
				    	$("#lng").val(res.longitude);
					}	
				});
			    
				//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
				wx.onMenuShareTimeline({
				    title: '我的测试标题', // 分享标题
				    link: '${app_domain}/main', // 分享链接
				    imgUrl: '${app_domain}/resource/image/logo/shuiguoshullogo.png', // 分享图标
				    success: function () { 
				        // 用户确认分享后执行的回调函数
				        alert('分享到朋友圈');
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				        alert('取消分享到朋友圈');
				    }
				});
				
				//获取“分享给朋友”按钮点击状态及自定义分享内容接口
				wx.onMenuShareAppMessage({
				    title: '', // 分享标题
				    desc: '', // 分享描述
				    link: '', // 分享链接
				    imgUrl: '', // 分享图标
				    type: '', // 分享类型,music、video或link，不填默认为link
				    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
				    success: function () { 
				        alert('分享给朋友');// 用户确认分享后执行的回调函数
				    },
				    cancel: function () { 
				        alert('取消分享给朋友');// 用户取消分享后执行的回调函数
				    }
				});
				
				//获取“分享到QQ”按钮点击状态及自定义分享内容接口
				wx.onMenuShareQQ({
				    title: '', // 分享标题
				    desc: '', // 分享描述
				    link: '', // 分享链接
				    imgUrl: '', // 分享图标
				    success: function () { 
				       // 用户确认分享后执行的回调函数
				    },
				    cancel: function () { 
				       // 用户取消分享后执行的回调函数
				    }
				});
				//获取“分享到腾讯微博”按钮点击状态及自定义分享内容接口
				
				wx.onMenuShareWeibo({
				    title: '', // 分享标题
				    desc: '', // 分享描述
				    link: '', // 分享链接
				    imgUrl: '', // 分享图标
				    success: function () { 
				       // 用户确认分享后执行的回调函数
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				    }
				});
				//获取“分享到QQ空间”按钮点击状态及自定义分享内容接口
				
				wx.onMenuShareQZone({
				    title: '', // 分享标题
				    desc: '', // 分享描述
				    link: '', // 分享链接
				    imgUrl: '', // 分享图标
				    success: function () { 
				       // 用户确认分享后执行的回调函数
				    },
				    cancel: function () { 
				        // 用户取消分享后执行的回调函数
				    }
				});
			});
		});
		
		function nearStore(){
			window.location.href="${CONTEXT_PATH}/store?lat=" + $("#lat").val() + "&lng=" + $("#lng").val();
		}
	</script>
</body>
</html>
