<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-消费排行榜" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl" />
</head>
<body>
<div id="main" data-role="page" class="mt41 bg-white">
		<div class="orderhead">
			<div class="btn-back">
				<a onclick="back();"><img height="20" src="resource/image/icon/icon-back.png" /></a>	   
		    </div>
		    <div>消费排行榜</div>
		    <div class="rules"><a href="javascript:void(0);" class="brand-red" data-target="#rule-model" data-toggle="modal">活动规则</a></div>
	    </div>
	
		<div id="ranking_list" data-role="main">	
			<div class="top-box">
				<img src="resource/image/activity/rankingList/bg-ranking.jpg"/>
			</div>
			<div class="my-tittle">我的排名</div>
			<div class="row list-me">
				  <div class="col-3">
						${myFeeRank.rank}.
				  </div>
				  <div class="col-5 phone-num">${myFeeRank.phone_num!}</div>
				  <div class="col-3 total-price">￥${(myFeeRank.need_pay!0)/100}</div>			  
		    </div>
			<div class="ranking-tittle">
				排行榜
			</div>
			<div class="ranking-list">
				<#list feeRank as item>
					<#if item_index==0>
					  <div class="row first list">
						  <div class="col-3">
						  		<div class="img-box">
						  			<i class="crown-box">
						  				<img src="resource/image/activity/rankingList/crown1.png"/>
						  			</i>
						  			<img onerror="this.src='resource/image/activity/rankingList/avatar1.png'"
						  				 src="${item.user_img_id!}"/>
						  		</div>
						  </div>
						  <div class="col-5 phone-num">${item.phone_num!}</div>
						  <div class="col-3 total-price">￥${(item.need_pay!0)/100}</div>			  
					  </div>
					<#elseif item_index==1>
					  <div class="row second list">
						  <div class="col-3">
						  		<div class="img-box">
						  			<i class="crown-box">
						  				<img src="resource/image/activity/rankingList/crown2.png"/>
						  			</i>
						  			<img onerror="this.src='resource/image/activity/rankingList/avatar2.png'"
						  				 src="${item.user_img_id!}"/>
						  		</div>
						  </div>
						  <div class="col-5 phone-num">${item.phone_num!}</div>
						  <div class="col-3 total-price">￥${(item.need_pay!0)/100}</div>			  
					  </div>
					<#elseif item_index==2>
					  <div class="row third list">
						  <div class="col-3">
						  		<div class="img-box">
						  			<i class="crown-box">
						  				<img src="resource/image/activity/rankingList/crown3.png"/>
						  			</i>
						  			<img onerror="this.src='resource/image/activity/rankingList/avatar3.png'"
						  				 src="${item.user_img_id!}"/>
						  		</div>
						  </div>
						  <div class="col-5 phone-num">${item.phone_num!}</div>
						  <div class="col-3 total-price">￥${(item.need_pay!0)/100}</div>			  
					  </div>
					<#else>  
					   <div class="row list-same">
						  <div class="col-3">
								${item_index+1}.
						  </div>
						  <div class="col-5 phone-num">${item.phone_num!}</div>
						  <div class="col-3 total-price">￥${(item.need_pay!0)/100}</div>			  
					   </div>
					</#if>
				</#list>									
			</div>
			<div class="col-12 ranking-share">
				<button type="button" class="btn-custom go-share">分享给好友</button>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="rule-model" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	    		<div class="modal-content">
		            <div class="col-12 close-btn">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		            </div>
			        <p class="rule-tittle">活动规则</p>
		        	<div class="rule-detail">
		    			<ol>
			    			<li>活动时间：2017年5月20日 00:00~2017年5月31日  23:59</li>	
							<li>排名前五名将获得水果熟了为Ta准备的礼物，礼物如下:
							    <ul>
							       <li>第一名，华为荣耀8手机（全网通3GB+32GB）一台，价值1799元。</li>
							       <li>第二名，步步高(BBK)点读机T500S 绿色 4G，价值498元。</li>
							       <li>第三名，200个鲜果币，价值200元。</li>
							       <li>第四名，100个鲜果币，价值100元。</li>
							       <li>第五名，50个鲜果币，价值50元。</li>
							    </ul>
							</li>
							<li>6月1日公布结果，并兑现第3-5名的鲜果币奖励。在6月1日-6月5日获得第1、2名的客户可到公司领取实物奖励，领取奖励需要验证客户手机号码、身份证。</li>
						</ol>
		        	</div>	
		        </div>
		    </div>
	</div>
	
	<div class="all-shade">
	        <i class="icon">
	            <img src="resource/image/icon/all-share.png" />
	        </i>
	        <p>点击这里可进行分享哦~</p>
			<a class="close-all">知道啦</a>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/jQuery/json2.js"></script>
	<script type="text/javascript">	
		$(function() {
			var phone = $('.phone-num');
			$(phone).each(function(){
			    var oPhone = $(this).html();
			    var mPhone = oPhone.substr(0, 3) + '****' + oPhone.substr(7);
			    $(this).html(mPhone)
			})
			
			//分享引导层
			$(".go-share").click(function(){
	 	 		$(".all-shade").css("display","block");
	 	 	})
	        $(document).on("touchmove",function(e) {
	            if($(".all-shade").css("display")==='block') {
	                e.preventDefault();
	            }
	        });
	        $(".close-all").click(function(){
	            $(".all-shade").css("display","none");
	        })
	        
		});
		
		//微信分享js
		wx.ready(function() {
			var link='${app_domain}/activity/rankingList';
			var imgUrl='${app_domain}/resource/image/logo/shuiguoshullogo.png';
			//获取“分享到朋友圈”按钮点击状态及自定义分享内容接口
			wx.onMenuShareTimeline({
			    title: '最铁果粉，冲榜得大奖', // 分享标题
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () {
			        // 用户确认分享后执行的回调函数
			        $(".all-shade").css("display","none");
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			        //alert('取消分享到朋友圈');
			    }
			});
			
			wx.onMenuShareAppMessage({
			    title: '最铁果粉，冲榜得大奖', // 分享标题
			    desc: '第1名，华为荣耀手机一台。第2名步步高点读机一台。第3-5名奖励大量鲜果币。', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () {
			        // 用户确认分享后执行的回调函数
			        $(".all-shade").css("display","none");
			    },
			    cancel: function () {
			        // 用户取消分享后执行的回调函数
			    }
			});
			
			
			//获取“分享到QQ”按钮点击状态及自定义分享内容接口
			wx.onMenuShareQQ({
			    title: '最铁果粉，冲榜得大奖', // 分享标题
			    desc: '第1名，华为荣耀手机一台。第2名步步高点读机一台。第3-5名奖励大量鲜果币。', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () { 
			   		$(".all-shade").css("display","none");
			    },
			    cancel: function () { 
			       // 用户取消分享后执行的回调函数
			    }
			});
			
			//获取“分享到QQ空间”按钮点击状态及自定义分享内容接口
			wx.onMenuShareQZone({
			    title: '最铁果粉，冲榜得大奖', // 分享标题
			    desc: '第1名，华为荣耀手机一台。第2名步步高点读机一台。第3-5名奖励大量鲜果币。', // 分享描述
			    link: link, // 分享链接
			    imgUrl: imgUrl, // 分享图标
			    success: function () { 
			    	$(".all-shade").css("display","none");
			    },
			    cancel: function () { 
			        // 用户取消分享后执行的回调函数
			    }
			});
		});
				
		function back(){
 			window.location.href="${CONTEXT_PATH}/main?index=0";
	 	}	
	</script>
</body>
</html>
