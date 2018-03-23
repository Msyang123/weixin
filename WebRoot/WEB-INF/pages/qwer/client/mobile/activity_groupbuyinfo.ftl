<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-团购活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	
	<div data-role="page" id="group_info">
		<div data-role="main" class="bg-white">
		
			<a class="btn-back" onclick="back();">
				<img src="resource/image/activity/groupbuy/btn-back.png" />
			</a>
					
		    <div class="group-person">
				<div class="person-list swiper-container">
				    <div class="swiper-wrapper">
						<#list members as item>
							<div class="member swiper-slide">
								<img src="${item.user_img_id!'resource/image/activity/groupbuy/default_avatar.png'}" />
								<#if item.tour_user_id==item.team_user_id>
									<span class="captain-logo">团长</span>
								</#if>
							</div>
						</#list>
						<#if beginTeam.left_count??&&(beginTeam.left_count!=0)>
							<div class="member btn-share swiper-slide">
								<img src="resource/image/activity/groupbuy/add-people1.png"/>
							</div>
						</#if>					
					</div>		
					<div class="swiper-pagination"></div>		
				</div>
					
			<#if productDetial.down_time?datetime gt .now?datetime>
			    <#if beginTeam.status==1>
					<p class="time-info">仅剩${beginTeam.left_count!0}个名额 <span data-createtime="${beginTeam.create_time}"class="count-down"></span> 后结束</p>
					<div class="group-btn row justify-content-center">
						<div class="col-4">
							<#if isMyJoin??>
								<button type="button" class="btn-custom btn-disabled disabled">已参团</button>
							<#else>
								<button type="button" class="btn-custom groupFinish" data-teambuyscaleid="${beginTeam.m_team_buy_scale_id}" data-teambuyid="${beginTeam.id}">马上参团</button>
							</#if>
					    </div>
					    <#if isMyJoin?? && isMyJoin.is_pay=='D'>
					    <div class="col-4">
				       		<button type="button" class="btn-pay btn-custom" data-teambuyscaleid="${beginTeam.m_team_buy_scale_id}" data-teambuyid="${beginTeam.id}" data-teammemberid="${isMyJoin.id}">继续支付</button>
					    </div>
					    </#if>
					    <div class="col-4">
					        <button type="button" class="btn-share btn-custom btn-white">邀请好友</button>
					    </div>
					</div>
				 <#elseif beginTeam.status==2>
				 <#if isMyJoin??>
					 <p class="time-info">拼团已成功</p>
					 <div class="group-btn row justify-content-center">
					     <div class="col-4">
						     <button type="button" class="btn-custom btn-disabled disabled">已参团</button>
						 </div>
						 <div class="col-4">
						     <button type="button" class="btn-custom btn-order" data-order-id="${myOrder.id!}">查看订单</button>
						 </div>
					 </div>
				 <#else>
				    <p class="time-info">拼团已满</p>
				 </#if>
				 <#else>
					<#if isMyJoin??>
						<p class="time-info">拼团失败了，您支付的货款会按原路返回</p>
					<#else>
					    <p class="time-info">拼团已过期</p>
					</#if>
				 </#if>
				 <#else>
				    <p class="time-info">拼团已结束</p>
				 </#if>
			</div>
		
		<div class="proinfo-tittle bg-grey">详细介绍</div>
		<div class="pro-detail-img bg-white">
			<img src="${productDetial.save_string}" onerror="common.imgLoadMaster(this)" width="200" height="200" />
		</div>
		
		<div class="proinfo-detail row no-gutters justify-content-between border-t">
			<div class="col-6">
				<p class="pro-name">${productDetial.product_name}</p>
				<p style="margin-top:10px;">约${productDetial.product_amount!0}${productDetial.unit_name}</p>
				<p class="pro-price"><span>￥${teamBuyScale.activity_price_reduce/100}</span> 立省${(productDetial.real_price-teamBuyScale.activity_price_reduce)/100}元</p>
			</div>
			<div class="col-6 sales-num align-self-center">
				<span class="brand-red-new">${teamBuyScale.person_count!0}人团</span> 已拼团 <span class="brand-red-new">${productDetial.total!0}</span> 份
			</div>
		</div>
		
		<div class="finish-tips">
			<img src="resource/image/activity/groupbuy/slow.png" />
			<p>亲，你手慢了哦~</p>
		</div>
		
		<div class="all-shade">
	        <i class="icon">
	            <img src="resource/image/icon/all-share.png" />
	        </i>
	        <div class="share-info">
	        	<p>快邀请你的好友来参团吧</p>
	        	<button type="button" class="btn-custom close-all">知道了</button>
	        </div>
         </div>	
       </div>
	</div>
		
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/location.js"></script>
	<script type="text/javascript">
		//参团
		$(".groupFinish").click(function(){
			//获取其他参数：商品id,规格id
			 var teamBuyScaleId=$(this).data("teambuyscaleid");
			 var teamBuyId=$(this).data("teambuyid");
			 var currentTime=new Date().getTime();
			 var downTime=new Date("${productDetial.down_time}").getTime();
			 
			//商品下架后点击马上参团做判断
			if(currentTime>downTime){
			  $.dialog.alert("拼团已结束")
			   return false;
			} 
			
			$.ajax({ 
				url: "${CONTEXT_PATH}/activity/isFull", 
				data: {teamBuyId:teamBuyId}, 
				success: function(data){
					if(data.isFull){
						$(".finish-tips").show();
					    setTimeout(function(){
							$(".finish-tips").hide();
							location.reload();
						},3000);
					}else{
						//查询我是否超过了参团次数
						$.ajax({
				          type:'Get',
				          url:'${CONTEXT_PATH}/activity/isUserJoinOver',
				          data:{teamBuyScaleId:teamBuyScaleId},
				          success:function(result){
				          	//判断当前用户是否超过购买限制次数
				          	if(result.isFull){
				          		$.dialog.alert("您今天已经参与过多此类商品的团购，去瞧瞧其它商品的团购!");
				            }else{
				            	window.location.href="${CONTEXT_PATH}/activity/groupOrder?teamBuyScaleId="+teamBuyScaleId+"&teamBuyId="+teamBuyId+"&pId="+${productDetial.product_id}+"&pfId="+${productDetial.product_f_id};
				            }   
				          }
				       }); 
					}	
		      	}
			});
		}); 
		
		//分享引导层
		$(".btn-share").click(function(){
 	 		$(".all-shade").show();
 	 	});
 	 	
        $(document).on("touchmove",function(e) {
            if($(".all-shade").css("display")==='block') {
                e.preventDefault();
            }
        });
        
        $(".close-all").click(function(){
            $(".all-shade").css("display","none");
        });	
        
 		function back(){
			window.location.href = "${CONTEXT_PATH}/activity/groupBuys";
	 	}	    
	 	
	 	//拼团成功后订单页跳转--v2.1.1
	 	$('.btn-order').click(function(){
	 	     var orderId=$(this).data("order-id");
	 	     window.location.href="${CONTEXT_PATH}/pay/orderDetail?id="+orderId;
	 	});
	 	
	 	//继续支付
	 	$(".btn-pay").click(function(){
		 	var teambuyScaleId=$(this).data("teambuyscaleid");
		 	var teambuyId=$(this).data("teambuyid");
		 	var teamMemberId=$(this).data("teammemberid");
	        window.location.href = "${CONTEXT_PATH}/pay/groupPayment?tbs="+teambuyScaleId
	            	+"&teamBuyId="+teambuyId+"&teamMemberId="+teamMemberId;
        });
        
 	    $(function(){
 	         //参团人数		
			 var swiper = new Swiper('.swiper-container', {
				    pagination : '.swiper-pagination',
				    paginationClickable:true,
			        scrollbarHide: true,
			        slidesPerView: 4,
			        slidesPerGroup:4,
			        centeredSlides: false,
			        spaceBetween: 10,
			        grabCursor: true,
			        setWrapperSize :false,
			        breakpoints: { 
					    //当宽度小于等于320
					    320: {
					      slidesPerView: 4,
					      slidesPerGroup:4,
					      spaceBetweenSlides: 5
					    },
					    //当宽度小于等于376
					    375: { 
					      slidesPerView: 4,
					      slidesPerGroup:4,
					      spaceBetweenSlides: 10
					    },
					   //当宽度小于等于415
					    414: { 
					      slidesPerView: 5,
					      slidesPerGroup:5,
					      spaceBetweenSlides: 10
					    },
					     //当宽度小于等于415
					    480: { 
					      slidesPerView: 5,
					      slidesPerGroup:5,
					      spaceBetweenSlides: 10
					    },
					    //当宽度小于等于640
					    640: {
					      slidesPerView: 6,
					      slidesPerGroup:6,
					      spaceBetweenSlides: 20
				        }
				     }
			    });
			    
			    countDownInit();
		    });
		    
	    function countDownInit(){
		    var len=$('.count-down').length;
		    
		    if(len==0){
		       return false;
		    }
		    
		    for(var i=0;i<len;i++){
		         var creatTime=$('.count-down').eq(i).data("createtime");
		         creatTime=creatTime.replace(/\-/g, "/");
		         var now=new Date();
		         var cDate=new Date(creatTime);
		         var leftTime=cDate.getTime()+24*60*60*1000-now.getTime();
		         
		         if(leftTime<0){
		            return false;
		            console.log('此团已过期');
		         }
		         
		         var leftDate=new Date(cDate.getTime()+24*60*60*1000);
		         $('.count-down').eq(i).countdown({
		             until: leftDate, 
		             format: 'HMS',
		             compact: true, 
		             description:''
		         }); 
		    }
		}
		
		//发送Ajax去请求与路径相匹配的分享模板
		$.ajax({
		    type:'Get',
			url: "${CONTEXT_PATH}/share",
		    success: function(result){
		          if(result){
		               //组织要替换的模板值
		               var jsonObj=new Object();
		               jsonObj.Username=result.tUserSession.nickname;
		               jsonObj.product_name="${productDetial.product_name!}";
		               jsonObj.picture=result.share.picture.indexOf("{{")>=0?'${app_domain}/${productDetial.save_string?substring(8)}': 
		               '${app_domain}'+result.share.picture.replace("/weixin","");
		               jsonObj.person_count="${teamBuyScale.person_count!0}";
		               jsonObj.left_count="${beginTeam.left_count!0}";
		               jsonObj.activity_price_reduce="${teamBuyScale.activity_price_reduce/100}";
		               console.log(jsonObj);
		               
		               //使用Mustache替换
		               var title=Mustache.render(result.share.title,jsonObj);
		               var desc=Mustache.render(result.share.content,jsonObj);
		               var link='${app_domain}/activity/groupBuyInfo?teamBuyId='+${beginTeam.id};
		               var imgUrl=jsonObj.picture;
		               
		               console.log(title+'\r\n'+desc+'\r\n'+link+'\r\n'+imgUrl);
		               
		               var shareData={
			                  title:title,
							  desc:desc,
							  link:link,
							  imgUrl:imgUrl,
							  success:function(){
							     //分享成功回调函数
								  $(".all-shade").hide();
							  },
							  cancel:function(){
							    //分享取消回调函数
							  }
				       };
		               
		               //微信分享js
					   wx.ready(function() {
						   var share=new wxShare(shareData);
						   share.bind();
					   });
		          }   
		    }			
		});
		 	
    </script>
</body>
</html>