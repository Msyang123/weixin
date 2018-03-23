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
		      	 <#if result.code==0 >
		      	 	 <div class="lottery-list">
		      	 	 	 <#list result.lotterys as item>
							<div class="row no-gutters justify-content-center lottery-detail" data-gid="${item.id}">
							    <div class="col-9 bg-l">
							        <div class="row no-gutters justify-content-center">
									    <div class="col-4 lottery-pic">
									      	 <img src="${item.save_string!}" height="59" />
									    </div>
									    <div class="col-8 lottery-name">
									         <p>${item.award_name!}</p>
									         <p>${item.expire_time!}过期</p>
									    </div>
								    </div>
							    </div>
							    <#if item.is_get=='0'>
								    <div class="col-3 text-center bg-r js-btn-draw">
	  							        <div class="btn-draw">点击<br/>领取</div>
	  							        <div class="arrow-down"><img src="resource/image/icon/icon-down.png" height="15"></div>
								    </div>
								<#elseif item.is_get=='1'>   
								    <div class="col-3 text-center bg-r disabled">
	  							        <div class="btn-draw disabled">已领取</div>
								    </div>
								 <#else>
								 	<div class="col-3 text-center bg-r disabled">
	  							        <div class="btn-draw disabled">已过期</div>
								    </div>
								</#if>  
							</div>
						 </#list>
					  </div> 
				<#else>
				    <div class="empty-group text-center">
					     <img src="resource/image/activity/lottery/activity_lottery_noprize.png" class="img-responsive" height="240"/>
					     <p class="mt30">您还没有奖品哦<br/>扫描水果熟了小票二维码即可参与抽奖</p>
					</div>	 	
			    </#if>
		     </div>
    </div>
    			
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
	    $(function(){
	         $('.js-btn-draw').on('click',function(){
	             var $this=$(this);
	             var gid=$this.parent('.lottery-detail').data('gid');
	                $.ajax({ 
						url: "${CONTEXT_PATH}/activity/receiveGift", 
						data: {id:gid}, 
						success: function(data){
							if(data.isUser==false){
								$.dialog.messageOperation('只有会员才能领取奖品哦', true,function(){
									window.location.href="${CONTEXT_PATH}/activity/newUserRegister?receiveId="+data.receiveId;
								},'马上注册','取消',true);
							}else{
								if(data.param=='0'){
									$this.children('.arrow-down').remove();
		                			$this.unbind('click').removeClass("js-btn-draw").addClass('disabled').children('.btn-draw').addClass('disabled').html("已领取");
									$.dialog.alert(data.msg);	
								}else{
									window.location.href="${CONTEXT_PATH}/activity/lotteryOrder?pf_id="+data.pf_id+"&user_award_id="+data.user_award_id;
								}
							}
				      	}
					});
	         });
		});
		
		function back(){
			window.history.back();
	 	}
    </script>
</body>
</html>