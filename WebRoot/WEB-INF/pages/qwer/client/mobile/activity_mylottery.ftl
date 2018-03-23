<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-九宫格抽奖活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
    <div data-role="page" class="my-lottery mt41">
    
			<div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>   
			    </div>
			    <div>我的奖品</div>
             </div>
             
		     <div data-role="main" class="my-lottery-content">
		     	 <#if currentUserAwardRecord?? && (currentUserAwardRecord?size>0)>
		             <div class="lottery-list">
						<#list currentUserAwardRecord as item>
							<div class="row no-gutters justify-content-center lottery-detail" data-gid="${item.id}">
							    <div class="col-9 bg-l">
							        <div class="row no-gutters justify-content-center">
									    <div class="col-4 lottery-pic">
									      	 <img src="${item.save_string}" height="59" />
									    </div>
									    <div class="col-8 lottery-name">
									         <p>${item.award_name}</p>
									         <p>${item.award_time?substring(0,10)}</p>
									    </div>
								    </div>
							    </div>
							    <#if item.is_get=='0' >
								    <div class="col-3 text-center bg-r js-btn-draw">
	  							        <div class="btn-draw">点击<br/>领取</div>
	  							        <div class="arrow-down"><img src="resource/image/icon/icon-down.png" height="15"></div>
								    </div>
							    <#else>
								    <div class="col-3 text-center bg-r disabled">
	  							        <div class="btn-draw disabled">已领取</div>
								    </div>
								</#if>    
							</div>
						</#list>
					  </div>
					<#else>
						<div class="empty-group text-center">
						     <img src="resource/image/activity/lottery/activity_lottery_noprize.png" class="img-responsive" height="240"/>
						     <p class="mt10">您现在还没有奖品哦~赶快<span class="brand-red go-lottery">去抽奖吧~</span></p>
						</div>		
					</#if>
		     </div>
    </div>
    			
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
	    $(function(){
	  	        
	         $('.go-lottery').on('click',function(){
	              window.location.href = "${CONTEXT_PATH}/activity/lottery?activityId=${activityId!}";
	         });
	         
	         $('.js-btn-draw').on('click',function(){
	             var $this=$(this);
	             var gid=$this.parent('.lottery-detail').data('gid');
	             $.dialog.message("确认领取该奖品？<br/>（请交由水果熟了工作人员操作）",true,function(){
	                //线下商品领取，直接变为已领取
	                //线上将此条记录状态修改为已领取   
	                $.ajax({ 
						url: "${CONTEXT_PATH}/activity/setInvalid", 
						data: {id:gid}, 
						success: function(data){
							if(data.resultCode){
								$this.children('.arrow-down').remove();
	                			$this.unbind('click').removeClass("js-btn-draw").addClass('disabled').children('.btn-draw').addClass('disabled').html("已领取");
								$.dialog.alert(data.msg);
							}else{
								$.dialog.alert(data.msg);
							}
				      	}
					});
				 });
	         });
		});
		
		function back(){
	 		window.location.href="${CONTEXT_PATH}/activity/lottery?activityId=${activityId!}";
	 	}
    </script>
</body>
</html>