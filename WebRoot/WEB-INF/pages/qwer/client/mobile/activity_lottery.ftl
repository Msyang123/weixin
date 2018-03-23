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
    <div data-role="page" class="lottery-area bg-white mt41">
    
		   <div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>   
			    </div>
			    <div>抽奖</div>
			    <div class="rules"><a href="javascript:void(0);" class="brand-red" data-target="#activity_rules" data-toggle="modal">活动规则</a></div>
		   </div>
	     
	       <div class="my-lottery-entrance">
	          <h5>我的奖品&nbsp;></h5>
	       </div>
	     
	       <div data-role="main" class="lottery-content">
	       		<#if activity.leading_content??>
		            <div class="recharges-area row no-gutters justify-content-between">
		                    <div class="col-9 desc"><div class="desc-content">${(activity.leading_content)!}</div></div>
		                    <div class="col-3 opreation"><a href="javascript:void(0);" onclick="goRecharge()" class="btn-recharge" data-role="none">马上<br/>充值</a></div>
		            </div>
				<#else>
					<!-- 若抽奖机会获取方式未选择充值送 -->
	            	<div style="margin-top:9rem;"></div>
	            </#if>
	            <div class="awards-area">
	              <div class="awards-titles row justify-content-around">
	                    <div class="col-4"><button class="btn-custom btn-purple">中奖号码</button></div>
	                    <div class="col-4"><button class="btn-custom btn-purple">奖品</button></div>
	               </div>
	               
	               <div class="awards-list">
	                  <ul>
	                  	 <#list userAwardRecordList as item>
	                  	 	<li class="row justify-content-center">
	                  	 		<div class="col-6">${item.phone_num!}</div><div class="col-6">${item.award_name!}</div>
	                  	 	</li>
	                  	 </#list>
	                  	 <!--还没有抽奖的时候是否可以显示默认内容-->
	                  </ul>
	               </div>
	            </div>
	           	<!--立马执行superslide 效果最优化-->
				<script type="text/javascript">		
					function slideInit(){
			            var wWidth=$(window).width();
					   	var visNum=wWidth>=384?5:4;
					   	
					   	if(wWidth<=320){
					   	    visNum=2;
					   	}
					   	
			             $('.awards-area').slide({ 
					         mainCell:".awards-list ul",
					         autoPlay:true,
					         effect:"topMarquee",
					         vis:visNum,
					         interTime:60,
					         opp:false,
					         pnLoop:true,
					         trigger:"click",
					         mouseOverStop:false
					     });
			        }	   		    
				    slideInit();
				</script>
				
				 <!--Begian lottery--> 
		         <div class="lottery" id="lottery"> 
		          			    
		            <div class="row justify-content-center no-gutters lottery-row">
		                  <div class="col lottery-unit lottery-unit-0">
		                     <img src="${awardList[0].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-1">
		                     <img src="${awardList[1].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-2">
		                     <img src="${awardList[2].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		             </div>
		             
		             <div class="row justify-content-center no-gutters lottery-row">
		                  <div class="col lottery-unit lottery-unit-7">
		                     <img src="${awardList[7].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-btn">
			                    <a href="#" class="">
			                      <h2 class="brand-red">抽奖</h2>
			                      <p>剩余<span class="lottery-num brand-red">&nbsp;${myHaveAwardChance}&nbsp;</span>次</p>
			                    </a>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-3">
		                     <img src="${awardList[3].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		             </div>
		             
		             <div class="row justify-content-center no-gutters lottery-row">
		                  <div class="col lottery-unit lottery-unit-6">
		                     <img src="${awardList[6].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-5">
		                     <img src="${awardList[5].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-4 text-center">
		                  	 <img src="${awardList[4].save_string}" class="img-responsive" onerror="imgLoad(this)">
		                     <!--<div class="no-lottery">谢谢参与</div>-->
		                     <div class="mask"></div>
		                  </div>
		             </div>
		        </div><!--/End lottery--> 
	     </div><!--/End lottery-content -->     
              
    </div><!--/End Page-->
    
	<div class="modal fade" id="activity_rules" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <h3 class="modal-title brand-red text-center" style="padding-bottom: 5px;border-bottom:1px solid #de374e;">活动规则</h3>
	            <div class="modal-body text-left">
	                ${activity.content}
	            	<div class="known brand-red text-center" data-dismiss="modal">我知道了</div>
	            </div>
	        </div>
	    </div>
	</div><!--/End activity_rules-->
		
	<div class="modal fade" id="lottery-succeed" tabindex="-1" role="dialog" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="pr10">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
		            </div>
		            <div class="modal-body text-center">
		                <h4>恭喜您获得</h4>
		            	<img id="award_img" src="resource/image/activity/lottery/activity_lottery_xgb_10.png" height="120">
		            	<p id="lottery_succeed_msg" class="brand-red"></p>
		            	<button type="button" data-role="button" class="btn-custom" id="btn_see">查看奖品</button>
		            </div>
		        </div>
		    </div>
    </div><!--/End share-succeed-->	
				
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">	
		var lottery={
	        index:-1,    //当前转动到哪个位置，起点位置
	        count:0,    //总共有多少个位置
	        timer:0,    //setTimeout的ID，用clearTimeout清除
	        speed:40,    //初始转动速度
	        times:0,    //转动次数
	        cycle:50,    //转动基本次数：即至少需要转动多少次再进入抽奖环节
	        prize:-1,    //中奖位置
	        init:function(id){
	            if ($("#"+id).find(".lottery-unit").length>0) {
	                $lottery = $("#"+id);
	                $units = $lottery.find(".lottery-unit");
	                this.obj = $lottery;
	                this.count = $units.length;
	                $lottery.find(".lottery-unit-"+this.index).addClass("active");
	            };
	        },
	        roll:function(){
	            var index = this.index;
	            var count = this.count;
	            var lottery = this.obj;
	            $(lottery).find(".lottery-unit-"+index).removeClass("active");
	            index += 1;
	            if (index>count-1) {
	                index = 0;
	            };
	            $(lottery).find(".lottery-unit-"+index).addClass("active");
	            this.index=index;
	            return false;
	        },
	        stop:function(index){
	            this.prize=index;
	            return false;
	        },
	        finish:function(index){
	            this.prize=index;
	            return false;
	        }
	    };
 
	    function roll(){
	        lottery.times += 1;
	        lottery.roll();//转动过程调用的是lottery的roll方法，这里是第一次调用初始化
	        if (lottery.times > lottery.cycle+10 && lottery.prize==lottery.index) {
	            clearTimeout(lottery.timer);
	            lottery.prize=-1;
	            lottery.times=0;
	            lottery.finish();
	            click=false;
	        }else{
	            if (lottery.times<lottery.cycle) {
	                lottery.speed -= 10;
	            }else if(lottery.times==lottery.cycle) {
	                var index = Math.random()*(lottery.count)|0;
	                //lottery.prize = index;
	            }else{
	                if (lottery.times > lottery.cycle+10 && ((lottery.prize==0 && lottery.index==7) || lottery.prize==lottery.index+1)) {
	                    lottery.speed += 110;
	                }else{
	                    lottery.speed += 20;
	                }
	            }
	            if (lottery.speed<40) {
	                lottery.speed=40;
	            };
	            console.log(lottery.times+'^^^^^^'+lottery.speed+'^^^^^^^'+lottery.prize);
	            lottery.timer = setTimeout(roll,lottery.speed);//循环调用
	        }
	        return false;
	    }
 
       var click=false;
 
	    $(function(){
	        lottery.init('lottery');
	        $("#lottery a").click(function(){
	            if (click) {//click控制一次抽奖过程中不能重复点击抽奖按钮，后面的点击不响应
	                return false;
	            }else{
	                /*lottery.speed=80;
	                  roll();    //转圈过程不响应click事件，会将click置为false
	                  click=true; //一次抽奖完成后，设置click为true，可继续抽奖
	                  return false;*/
	                //向后端接口发请求返回中奖结果
                    var geturl="${CONTEXT_PATH}/activity/getAward?activityId=${activity.id}";
                    $.ajax({
                        url:geturl,
                        type:"GET",
                        dataType:"json",
                        async:false,
                        success:function(data){
                            
                            if(data.resultCode){
                                var prize=-1;
                                var content="";
                                lottery.prize=data.awardSequence;
                                prize=data.awardSequence;
                                content=data.msg;
                                //剩余领奖次数
                                $('.lottery-num').text(data.awardChance);
                                $('#lottery_succeed_msg').text(content);
                                
                                if(data.awardType==4){
                                   $('#lottery-succeed h4').text("很遗憾，您此次未中奖");
                                   $('#award_img').attr('src','resource/image/activity/lottery/activity_lottery_noaward.png');
                                   $('#award_img').css('border','none');
                                   $('#btn_see').hide();
                                   $('#lottery_succeed_msg').hide();
                                }else{
                                   $('#lottery-succeed h4').text("恭喜您获得");
	                               $('#award_img').attr('src',data.imageUrl);
	                               $('#award_img').css('border','1px solid #ccc');
	                               $('#btn_see').show();
                                }
                                
                                lottery.finish=function(){
                                   ajaxAwardList();
                                   $('#lottery-succeed').modal('show');
                                   return false;
                                }
                                                  
                                lottery.speed=100;
                                roll();
                                click=true;
                                return false;
                            }else{
                            	$.dialog.alert(data.msg);
                            }
                        }
                    });/*ajax结束*/
	            }
	        });
	        
	        $('.my-lottery-entrance h5,#btn_see').on('click',function(){
	             window.location.href="${CONTEXT_PATH}/activity/myLottery?activityId=${activity.id}";
	        });
	        
	        $('#lottery-succeed').on('hide.bs.modal',function(){
	             //当关闭时要清除掉上次中奖结果
	             $('#lottery .active').removeClass('active');
	        });
	        
	         //使用刚指定的配置项和数据显示图表
            var tt = setInterval(function () {
                ajaxAwardList();
            }, 600000);
	    });
    
        function ajaxAwardList(){
            //清空之前的数据
            $('.awards-list').html('');
            //请求最新的50条数据
            var getUrl="${CONTEXT_PATH}/activity/getAllUserAwardRecordListJson?activityId=${activity.id}";
            $.ajax({
                url:getUrl,
                type:"GET",
                dataType:"json",
                success:function(result){
                    if(result){
                        var len=result.length;
                        var markUp='<ul>';
                        
                        for(var i=0;i<len;i++){
                           markUp+='<li class="row justify-content-center">'+
                            '<div class="col-6">'+result[i].phone_num+'</div>'+
                            '<div class="col-6">'+result[i].award_name+'</div>'+
	                  	 	'</li>'
                        }
                        
                        markUp=markUp+'</ul>';
                        $('.awards-list').html(markUp);
                        //再去绑定slide事件
                        slideInit();
                    }else{
                    	$.dialog.alert(result.msg);
                    }
                }
            });
            
        }
    
		function back(){
	 		window.location.href="${CONTEXT_PATH}/main?index=0";
	 	}
	 	
	 	function goRecharge(){
	 		var oLink = window.location.href;
	 		$.cookie('linkInfo',oLink,{expires:1,path:'/'});
	 		window.location.href="${CONTEXT_PATH}/pay/sbmtRecharge";
	 	}
	 	
	 	function imgLoad(element) {
			var imgSrc = "resource/image/activity/lottery/noprize.png";
			$(element).attr("src", imgSrc);
	    }
    </script>
</body>
</html>