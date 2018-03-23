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
	<div data-role="page" id="group_detail">
		<div data-role="main" class="bg-white">
			<#if beginTeams?? && (beginTeams?size>0) >
				<div class="tips">
					<a onclick="back();">
						<img src="resource/image/activity/groupbuy/btn-back.png" />
					</a>
					以下是已有的拼团，快来参与吧~
				</div>
				
				<div class="progroup-list">
					<#list beginTeams as item>
						<div class="row progroup-detail" data-teambuyid="${item.bid}"  data-teambuyscaleid="${item.id}" >
						    <div class="col-3 detail-name">
						      	<p>${item.person_count}人团</p>
						      	<p>团长 ${item.nickname!''}</p>
						    </div>
						    <div class="col-6 detail-time">
						      	<p>还差 <span>${item.left_count}</span> 人成团</p>
						      	<p>剩余 <span data-createtime="${item.create_time}" class="count-down"></span> 结束</p>
						    </div>
						    <div class="col-auto align-self-center detail-btn">
						       <button type="button" class="btn-custom btn-order">马上参团</button>
						    </div>
						</div>
					</#list>
					<#if (beginTeams?size>1) >
						<a class="down">查看更多 <i class="fa fa-angle-down" aria-hidden="true"></i></a>
					</#if>
				</div>
			<#else>
				<div class="no-tips">
					<a onclick="back();">
						<img src="resource/image/activity/groupbuy/btn-back.png" />
					</a>
					没有小伙伴开团哦，自己去开团吧~
				</div>
			</#if>
		
			<div class="proinfo-tittle border-b">产品详情</div>
			
			<div class="pro-img">
				<img src="${productDetial.save_string!}" onerror="common.imgLoadMaster(this)"/>
			</div>
			
			<div class="proinfo-detail row no-gutters align-items-center">
				<div class="col-5">
					<p class="pro-name">${productDetial.product_name}</p>
					<p>约${productDetial.product_amount!0}${productDetial.base_unit_name}</p>
					<p>已拼团 <span class="group-total">${productDetial.total!0}</span> 份</p>
				</div>
				<div class="col-7 sales-num align-self-end">
					<p>单位：${productDetial.unit_name!} 规格：${productDetial.standard!}</p>
					<p><span class="js-pro-timer"></span> &nbsp;后结束</p>
				</div>
			</div>
			<div class="proinfo-tittle border-b">详细介绍</div>
		
			<div class="detail-introduce">
				<#if productDetial.product_detail??>
						<#if productDetial.product_detail.indexOf("<img")!=-1>
						
							${productDetial.product_detail}
						<#else>
							<#list productDetial.product_detail?split(",") as img >
								<img width="100%" style="vertical-align:top;" src="resource/image/fruitDetial/${img}"/>
							</#list>
						</#if>
				<#else>
					暂无数据
				</#if>
			</div>
		
			<div class="group-footer row no-gutters">
				<div class="col-4 go-pay"  data-pid="${productDetial.product_id}" data-pfid="${productDetial.product_f_id}">
					<p>￥${(productDetial.real_price!0)/100}</p>
					<p>直接购买</p>
				</div>
				<#list teamBuyScales as item>
					<div class="col-4 
					<#if item_index==0>
					   two-pay
					<#else>
					   five-pay
					</#if>
					js-group-pay js-timer-over" data-teambuyscaleid="${item.id}" 
					<#if item.currenttimes gte item.team_open_times> style="background:#999;"</#if> 
					data-pcount="${item.person_count}"
					data-opentimes="${item.team_open_times}"
					data-currenttimes="${item.currenttimes}">
						<p>￥${(item.activity_price_reduce)/100}</p>
						<p>开${item.person_count!0}人团</p>
					</div>
				</#list>
			</div>
		
			<div class="finish-tips">
				<img src="resource/image/activity/groupbuy/slow.png"">
				<p>亲，你手慢了哦~</p>
			</div>	
		</div>
		
		<div class="btn-home">
  			<img src="resource/image/icon/icon-toHome.png">
  		</div>
	</div>	
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/location.js"></script>
	<script type="text/javascript">
	    $(function(){
	         //根据商品上下架时间来控制开团
	         var sDate1= ("${productDetial.up_time}").replace(/\-/g, "/")
	         var lDate1= ("${productDetial.down_time}").replace(/\-/g, "/")
	         
			 var sDate=new Date(sDate1);
			 var lDate=new Date(lDate1);
			 var currentDate=new Date().getTime();
			 var overDate=lDate.getTime();
			 
	         //如果过期了重新刷新一遍页面后
		     if(currentDate>overDate){
		         $('.js-group-pay').unbind('click').removeClass('js-group-pay');
		         $('.js-timer-over').on('click',function(){
					  $.dialog.alert("该拼团已结束~");
				 });
		     }
		     
			 $('.js-pro-timer').countdown({
			         startTime: sDate,
		             until: lDate, 
		             format: 'HMS',
		             compact: true, 
		             description:'',
		             onExpiry:function(){
		                 $('.js-group-pay').unbind('click').removeClass('js-group-pay');
		                 $('.js-timer-over').on('click',function(){
						    $.dialog.alert("该拼团已结束~");
						 });                 
		             }
		     }); 
		     
	          //查看团详
	          $('.progroup-list').on('click','.progroup-detail',function(e){
	               //点击进入团购信息详情页
	               var teamBuyId=$(e.currentTarget).data("teambuyid");
	               window.location.href="${CONTEXT_PATH}/activity/groupBuyInfo?teamBuyId="+teamBuyId;
	          }).on('click','.btn-order',function(e){
	               //点击马上参团--进入团购订单支付
	               var teamBuyId=$(e.currentTarget).parents('.progroup-detail').data("teambuyid");
				   var teamBuyScaleId=$(e.currentTarget).parents('.progroup-detail').data("teambuyscaleid");
				   var downTime=new Date("${productDetial.down_time}").getTime();
			       var currentTime=new Date().getTime();
			       
				   if(currentTime>downTime){
					    $.dialog.alert("拼团已结束")
				        return false;
				   }
				   
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
	               e.stopPropagation();//阻止冒泡
	          });
	    		
	          //查看更多
	          $('.down').on('click',function(){  
	                 var excId=$('.progroup-detail').eq(0).data("teambuyid");
	                 var excId2=$('.progroup-detail').eq(1).data("teambuyid");
	                 
				     $.ajax({
				          type:'Get',
				          url:'${CONTEXT_PATH}/activity/teamBuyMore',
				          data:{id:${activityProductId},exc1:excId,exc2:excId2},
				          success:function(result){
				              if(result&&result.length>0){
				                 for(var i=0;i<result.length;i++){
					                 var markup ='<div class="row progroup-detail" data-teambuyid="'+result[i].bid+'" data-teambuyscaleid="'+result[i].id+'">'+
				                      '<div class="col-3 detail-name"><p>'+result[i].personCount+"人团"+'</p><p>'+"团长"+result[i].nickname+'</p></div>'+
				                      '<div class="col-6 detail-time"><p>还差 <span>'+result[i].leftCount+'</span> 人成团</p><p>剩余 <span data-createtime="'+result[i].createTime+'" class="count-down"></span> 结束</p></div>'+
						              '<div class="col-auto align-self-center detail-btn"><button type="button" class="btn-custom btn-order">马上参团</button></div></div>';
						              $(".down").before(markup); 
					              }
					              $('.down').addClass('d-none');
					              //初始化倒计时
			                      countDownInit();
				              }else{
				                  $.dialog.alert("暂时无更多的团购可查看");
				              }
				          }
				     });
			 });
			 		
			 $('.js-group-pay').on('click',function(){
			        //开团按钮点击下单 如果是今天没有开的团有限制就按照限制数量来限制
			        var opentimes=$(this).data("opentimes");
			        var currenttimes=$(this).data("currenttimes");
			        if(currenttimes>=opentimes){
			            //弹出提示
			            $.dialog.alert("此商品今日开团数已满，明天再来哦~");
			            return false;
			        }else{
			        	var teamBuyScaleId=$(this).data("teambuyscaleid");
			        	$.ajax({
				          type:'Get',
				          url:'${CONTEXT_PATH}/activity/isUserJoinOver',
				          data:{teamBuyScaleId:teamBuyScaleId},
				          success:function(result){
				          	//判断当前用户是否超过购买限制次数
				          	if(result.isFull){
				          		$.dialog.alert("您今天已经参与过多此类商品的团购，去瞧瞧其它商品的团购!");
				            }else{
				                window.location.href="${CONTEXT_PATH}/activity/groupOrder?teamBuyScaleId="+teamBuyScaleId+"&pId="+${productDetial.product_id}+"&pfId="+${productDetial.product_f_id};
				            }   
				          }
				       }); 
			        }
			 });
			 
			 $(".go-pay").click(function(){
				var val=$(this).data('pid');
				var pfId=$(this).data('pfid');
				$.ajax({ 
					url: "${CONTEXT_PATH}/activity/restrict", 
					data: {count:1,productFId:pfId}, 
					success: function(data){
						if(data.isLimit){
							$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
						}else{
							window.location.href="${CONTEXT_PATH}/order?pId="+val+"&pfId="+pfId;
						}
					}
				});		
			 });
			 		     
			 //初始化剩余时间
			 countDownInit();
			
			 $(".btn-home").click(function(){
				window.location.href="${CONTEXT_PATH}/main?index=0";
			 });
	    });
	
		
		function back(){
			window.history.back();
	 	}
	 		
	 	function groupFinish(){
		    $(".finish-tips").show();
		    setTimeout(function(){
				$(".finish-tips").hide();
				location.reload();
			},3000)
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
		            console.log("此团已经过期了，定时任务失败");
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
		               jsonObj.price="${(productDetial.real_price!0)/100}";
		               jsonObj.activity_price_reduce=$('.js-timer-over:last-child').find('p:first-child').text();
		               jsonObj.picture=result.share.picture.indexOf("{{")>=0?'${app_domain}/${productDetial.save_string?substring(8)}': 
		               '${app_domain}'+result.share.picture.replace("/weixin","");
		               jsonObj.product_unit="${productDetial.unit_name!}";
		               console.log(jsonObj);
		               
		               //var jsonStr=Json.Stringfiy(jsonObj);
		               //使用Mustache替换
		               var title=Mustache.render(result.share.title,jsonObj);
		               var desc=Mustache.render(result.share.content,jsonObj);
		               var link='${app_domain}/activity/groupGoodsInfo?id=${activityProductId}';
		               var imgUrl=jsonObj.picture;
		               
		               console.log(title+'\r\n'+desc+'\r\n'+link+'\r\n'+imgUrl);
		               
		               var shareData={
		                  title:title,
						  desc:desc,
						  link:link,
						  imgUrl:imgUrl,
						  success:function(){
						     //分享成功回调函数
						  },
						  cancel:function(){
						    //分享取消回调函数
						  }
		               };
		               
		               //微信分享模块
						wx.ready(function() {
							var share=new wxShare(shareData);
						    share.bindWX();
						});
		          }   
		    }			
		});
		
    </script>
</body>
</html>