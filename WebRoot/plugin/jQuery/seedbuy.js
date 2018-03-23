
	//获取种子
	function getSeed(){
		$.ajax({ 
			url: "activity/getSeed", 
			data: {'type':6},//点击领取6 
			async:false,
			success: function(data){
				if(data.state==0){
					$("#get-seed").modal();
					$("#get-seed-img").attr("src",data.seedType.save_string);
					$(".seed-kind").html(data.seedType.seed_name+"<span>x"+data.seedCount+"</span>");
				}else if(data.state==1){
					$.dialog.alert("本次种子已经领完，下次早点来哦！");
				}else if(data.state==2){
					$.dialog.alert("分享朋友圈，只能领取一次！");
				}else if(data.state==3){
					$.dialog.alert("不在活动时间内不能领取！");
				}else if(data.state==4){
					$.dialog.alert("本次时间段只能领取一次！");
				}
	      	}
		});
    }
			
	
	function goSend(){
		window.location.href = "activity/seedBuy";
	}
	
	$(function(){
			//种子入口拖拽
		    var cont=$("#seed-entry");
		    var contW=$("#seed-entry").width();
		    var contH=$("#seed-entry").height();          
		    var startX,startY,sX,sY,moveX,moveY;        
		    var winH=$(window).height();
		    var winW=$(window).width(); 
		    cont.on({//绑定事件
		        touchstart:function(e){ 
		        	startX = e.originalEvent.targetTouches[0].pageX;        //获取点击点的X坐标    
		            startY = e.originalEvent.targetTouches[0].pageY;    //获取点击点的Y坐标
		            sX=$(this).offset().left;//相对于当前窗口X轴的偏移量
		            sY=$(this).offset().top;//相对于当前窗口Y轴的偏移量
		            leftX=startX-sX;//鼠标所能移动的最左端是当前鼠标距div左边距的位置
		            rightX=winW-contW+leftX;//鼠标所能移动的最右端是当前窗口距离减去鼠标距div最右端位置
                    topY=startY-sY;//鼠标所能移动最上端是当前鼠标距div上边距的位置
		            bottomY=$(document).height()-contH+topY-70;//鼠标所能移动最下端是当前窗口距离减去鼠标距div最下端位置             
		            },
		        touchmove:function(e){              
		            e.preventDefault();
		            moveX=e.originalEvent.targetTouches[0].pageX;//移动过程中X轴的坐标
		            moveY=e.originalEvent.targetTouches[0].pageY;//移动过程中Y轴的坐标
		            if(moveX<leftX){moveX=leftX;}                                                                
                    if(moveX>rightX){moveX=rightX;}
		            if(moveY<topY){moveY=topY;}
		            if(moveY>bottomY){moveY=bottomY;}
		            $(this).css({
		            	"left":moveX+sX-startX,
                        "top":moveY+sY-startY,                  
		            });
		        },
		        mousedown: function(ev){
		            var patch = parseInt($(this).css("height"))/2;
		            $(this).mousemove(function(ev){
		            	 var oEvent = ev || event;
		                 var oX = oEvent.clientX;
		                 var oY = oEvent.clientY;
		                 var t = oY - patch;
		                 var l = oX - patch;
		                 var w = $(window).width() - $(this).width();
		                 var h = $(window).height() - $(this).height();
		                 if(t<0){t = 0}
		                 if(l<0){l=0}
		                 if(t>h){t=h}
		                 if(l>w){l=w}
		                 $(this).css({top:t,left:l})
		            });
		            $(this).mouseup(function(){
		                $(this).unbind('mousemove');
		            });
		        }
		    });
		   
	   		function countDown(minute,second){
				var $span_node = $("#countdown-num span");
				var timer = setInterval(function(){
					if(second == 0){
						if(minute==0 && second==0){
							clearInterval(timer);
							$('#seed-end').hide();
							$('#seed-entry').show();
						}else{
							minute--;
							second = 59;
						}	
					}else{
					second--;
					}
						minutes_1 = parseInt(minute/10);
						minutes_2 = minute%10;
						second_1 = parseInt(second/10);
						second_2 = second%10;
						$span_node.eq(0).html(minutes_1);
						$span_node.eq(1).html(minutes_2);
						$span_node.eq(2).html(second_1);
						$span_node.eq(3).html(second_2);
				    },1000);
            }
	   		
	   		$.ajax({ 
				url: "activity/getMInterval", 
				data: {}, 
				success: function(data){
					if(data.mark==-1){
						$('#seed-end').hide();	
					}else if(data.mark==0){
						$('#seed-end').show();
						countDown(data.minute,data.second);	
					}else if(data.mark==1){
						countDown(0,0);	
					}	
		      	}
			});
	   	});