<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-扫码抽奖活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
    <div data-role="page" class="lottery-area bg-white" id="code_lottery">
    	<input type="hidden" value="${(result.code)!}" id="codeResult">
	       <div class="lottery-entrance">
	          <h5 onclick="goLottery();"><img src="resource/image/activity/lottery/gift_icon.png" />我的奖品&nbsp;></h5>
	       </div>
	     
	       <div data-role="main" class="lottery-content">
				 <!--Begian lottery--> 
		         <div class="lottery" id="lottery"> 
		            <div class="row justify-content-center no-gutters lottery-row">
		                  <div class="col lottery-unit lottery-unit-0">
		                     <img src="${awardList[0].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-1">
		                     <img src="${awardList[1].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-2">
		                     <img src="${awardList[2].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		             </div>
		             
		             <div class="row justify-content-center no-gutters lottery-row">
		                  <div class="col lottery-unit lottery-unit-7">
		                     <img src="${awardList[3].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-btn">
			                                                     开始抽奖
		                  </div>
		                  <div class="col lottery-unit lottery-unit-3">
		                     <img src="${awardList[4].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		             </div>
		             
		             <div class="row justify-content-center no-gutters lottery-row">
		                  <div class="col lottery-unit lottery-unit-6">
		                     	<img src="${awardList[5].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-5">
		                     <img src="${awardList[6].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		                  <div class="col lottery-unit lottery-unit-4 text-center">
		                  	 <img src="${awardList[7].save_string}" class="img-responsive" onerror="imgError(this)">
		                     <div class="mask"></div>
		                  </div>
		             </div>
		        </div><!--/End lottery--> 
	     </div><!--/End lottery-content -->     
         
         <div class="rule-box">
         	<h4>活动规则</h4>
         	<p>1.凡在水果熟了任一平台下单均可享受抽奖机会</p>
         	<p>2.每个二维码限抽奖一次</p>
         	<p>3.注册成为微商城会员方可领取奖品</p>
         	<P>4.抽奖获得的奖品需要在7天内领取，否则奖品将失效</P>
         </div>    
         
         <div class="btn-box">
         	<a>进入商城</a>
         </div> 
    </div><!--/End Page-->
		
	<div class="modal fade" id="lottery-dialog" tabindex="-1" role="dialog" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="pr10">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
		            </div>
		            <div class="modal-body text-center" id="lottery-succeed">
		                <h4>恭喜您获得</h4>
		            	<img id="award_img" src="resource/image/activity/lottery/activity_lottery_xgb_10.png">
		            	<p id="lottery_succeed_msg"><span class="award-name">精品富士 </span><span class="award-desc">0.5kg</span></p>
		            	<button type="button" data-role="button" class="btn-custom" id="btn_see" onclick="goLottery();">查看奖品</button>
		            </div>
		        </div>
		    </div>
    </div><!--/End share-succeed-->	
				
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
			if($("#codeResult").val()=='1'||$("#codeResult").val()=='0'){
				$.dialog.messageOperation('${(result.msg)!}', true,function(){
					goLottery();
				},'我的奖品','关闭',true);
			}
			
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
		            lottery.timer = setTimeout(roll,lottery.speed);//循环调用
		        }
		        return false;
		    } 
			
		    var click=false;
			 
			$(function(){
				lottery.init('lottery');
				//抽奖码无效
				if($("#codeResult").val()=='1'){
					$(".lottery-btn").addClass('u-invalid');
					$(".lottery-btn").click(function(){
					    $.dialog.messageOperation('${(result.msg)!}', true,function(){
							goLottery();
					    },'我的奖品','关闭',true);
					});
				}else{
					$(".lottery-btn").click(function(){
						if(click){//click控制一次抽奖过程中不能重复点击抽奖按钮，后面的点击不响应
							return false;
						}else{
							//向后端接口发请求返回中奖结果
                            var geturl="${CONTEXT_PATH}/activity/getRandomAward";
                            
                            $.ajax({
                            	url:geturl,
                                type:"GET",
                                dataType:"json",
                                async:false,
                                success:function(data){
                                	$(".lottery-btn").addClass('u-invalid');
                                	//抽奖码无效
                                	if(data.msg){
                                		 $.dialog.alert(data.msg);
                                	}else{
                                		var prize=-1;
                                        lottery.prize=data.awardSequence;
                                        prize=data.awardSequence;
                                        $('#award_img').attr('src',data.image_url);
                                        if(data.award_type==4){
                                              $('#lottery-succeed h4').text("很遗憾，您此次未中奖");
                                              //$('#award_img').attr('src','resource/image/activity/lottery/activity_lottery_noaward.png');
                                              $('#btn_see').hide();
                                              $('#lottery_succeed_msg').hide();
                                        }else if(data.award_type==3){
         	                            	  $('#lottery-succeed h4').text("恭喜您获得");
         	                            	  $('.award-name').html(data.product_name);
	           	                              $('.award-desc').html(data.product_amount+data.unit_name);
	           	                           	  $('#btn_see').show();
	           	                        }else if(data.award_type==2){
         	                            	  $('#lottery-succeed h4').text("恭喜您获得");
         	                            	  $('.award-name').html('优惠券');
         	                          		  $('.award-desc').html(data.coupon_val/100+'元');
         	                          		  $('#btn_see').show();
	           	                        }else if(data.award_type==1){
         	                            	  $('#lottery-succeed h4').text("恭喜您获得");
         	                            	  $('.award-name').html('鲜果币');
         	                            	  $('.award-desc').html(data.coin/100+'个');
         	                            	  $('#btn_see').show();
           	                            }
                                        lottery.finish=function(){
                                            $('#lottery-dialog').modal('show');
                                            return false;
                                        }
                                        lottery.speed=100;
                                        roll();
                                        click=true;
                                        return false;
                                	}
                                }
                            });/*ajax结束*/
						}
					});
				}
				
				$(".btn-box").on('click',function(){
					window.location.href="${CONTEXT_PATH}/main?index=0";
				});
			});
			
			function goLottery(){
				window.location.href="${CONTEXT_PATH}/activity/myTwoCodeLottery ";
			}

			function imgError(element) {
				var imgSrc = "resource/image/activity/lottery/error.png";
				$(element).attr("src", imgSrc);
			}
    </script>
</body>
</html>