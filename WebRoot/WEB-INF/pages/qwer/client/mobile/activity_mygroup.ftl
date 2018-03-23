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
    <div data-role="page" class="my-group bg-white mt41">
			<div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>   
			    </div>
			    <div>我的拼团</div>
             </div>
             
		     <div data-role="main" class="my-group-content">
		     	<#if myJoinTeams?? && (myJoinTeams?size>0)>
		             <div class="progroup-list">
						<#list myJoinTeams as item>
							<div class="row progroup-detail" data-gid="${item.bid}">
							    <div class="col-3 detail-name">
							      	<p>${item.person_count}人</p>
							      	<p>${item.product_name}团</p>
							    </div>
							    <div class="col-6 detail-time">
							    	<#if item.status==1>
							      		<p>还差<span>${item.left_count}</span>人成团</p>
							      		<p>剩余<span data-createtime="${item.create_time}" class="count-down"></span>结束</p>
							      	<#elseif item.status==2>
							      		<p>拼团成功<br/><span class="detail-status">已结束</span></p>
							      	<#else>
							      		<p>拼团失败<br/><span class="detail-status">已结束</span></p>
							      	</#if>
							    </div>
							    <div class="col-3 align-self-center detail-btn">
							         <p>团长 ${item.nickname!''}</p>
  							         <button type="button" class="btn-custom btn-detail">去看看</button>
							    </div>
							</div>
						</#list>
					</div>
				<#else>	
					<div class="empty-group text-center">
					     <img src="resource/image/activity/groupbuy/order-empty.png" class=""/>
					     <p>您现在还没有参加拼团哦<br/>赶快<span class="brand-orange"> 去参团吧</span></p>
					</div>
				</#if>	
		     </div>
    </div>
    
	<div class="modal fade" id="activity_rules" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <h3 class="modal-title brand-red text-center">活动规则</h3>
	            <div class="modal-body text-left">
	            	<p>1、团购每期持续一段时间，具体时间由运营决定</p>
	            	<p>2、商品的价格根据成团人数的不同进行调整</p>
	            	<p>3、用户开团后，有24小时进行团购人员邀请如仍未凑够拼团人数，则视为失败</p>
	            	<p>4、开团失败，用户支付费用全额退款</p>
	            	<p>5、本期团购活动结束时未达到规定人数的团购单，等规定时间到时会退款</p>
	            	<p>6、拼团成功后，团内所有订单统一发货</p>
	            </div>
	        </div>
	    </div>
	</div><!--/End activity_rules-->
			
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
	    $(function(){
	         $('.brand-orange').on('click',function(){
	              window.location.href = "${CONTEXT_PATH}/activity/groupBuys";
	         });
	         
	         $('.btn-detail').on('click',function(){
	              var gid=$(this).parents('.progroup-detail').data("gid");
	              window.location.href = "${CONTEXT_PATH}/activity/groupBuyInfo?teamBuyId="+gid;
	         });
	         
	         $('.progroup-detail').on('click',function(){
	              var gid=$(this).data("gid");
	              window.location.href = "${CONTEXT_PATH}/activity/groupBuyInfo?teamBuyId="+gid;
	         });
	         
	         countDownInit();
		});
		
		function back(){
	 		window.history.back();
	 	}
	 	
	 	function goStorage(){
		    window.location.href = "${CONTEXT_PATH}/myStorage";
		}
		
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
    </script>
</body>
</html>