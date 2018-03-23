<!DOCTYPE html>
<html>
<head>
	<title>水果熟了-首页</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="description" content="水果熟了-首页" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
	<style>
		body,h1,h2,h3,h4,h5,h6,p,ul,li,dl,dt,dd{padding:0;margin:0;font-size:12px;font-family:Arial,Verdana, Helvetica, sans-serif;word-break:break-all;word-wrap:break-word;}
		li{list-style:none;}img{border:none;}em{font-style:normal;}
		a{color:#555;text-decoration:none;outline:none;blr:this.onFocus=this.blur();}
		a:hover{color:#000;text-decoration:underline;}
		.clear{height:0;overflow:hidden;clear:both;}
		.play_content{
			padding:0px;
			overflow:hidden;
			width:98%;
			margin:auto;
		}
		.play{width:98%;height:230px;border:#ccc 1px solid; text-align:center; margin:auto;overflow:hidden;position:absolute;}
		.textbg{margin-top:200px;z-index:1;filter:alpha(opacity=40);opacity:0.4;width:100%;height:30px;position:absolute;background:#000;}
		.text{margin-top:200px;z-index:2;padding-left:10px;font-size:14px;font-weight:bold;width:40%;color:#fff;line-height:30px; overflow:hidden;position:absolute;cursor:pointer;}
		.num{margin:205px 1% 0 55%;z-index:3;width:45%; text-align:right;position:absolute;height:25px;float:right;}
		.num a{margin:0 2px;width:20px;height:20px;font-size:14px; font-weight:bold;line-height:20px;cursor:pointer;color:#000;padding:0 5px;background:#D7D6D7;text-align:center}
		.num a.on{background:#FFD116;color:#A8471C;}
		.num a.on2{background:#D7D6D7;color:#000;}
		.img_content img{width:100%;height:230px;}
	</style>
	
</head>
<body>

<div data-role="page">
  <div data-role="header">
	<div data-role="navbar">
		<ul>
		<li><a href="javascript:;">首页</a></li>
		<li><a href="javascript:;">用户信息</a></li>
		<li><input type="search" name="search" id="search" value="" placeholder="搜索"/></li>
		</ul>
	</div>
  </div>
  	
  

  <div data-role="main" class="ui-content">
  	<!--
  	<div data-role="content" class="play_content">	
		<div class="play">
			<ul>
				<li class="textbg"></li>
				<li class="text"></li>
				<li class="num" ><a href='http://www.baidu.com'>1</a><a>2</a><a>3</a><a>4</a><a>5</a><a>6</a></li>
				<li class="img_content">
					<a href="javascript:void(0);" ><img src="resource/image/play/wall1.jpg" alt="澳大利亚：体验蓝山风光，感受澳洲风情" /></a> 
					<a href="javascript:void(0);" ><img src="resource/image/play/wall2.jpg" alt="九月抄底旅游，马上行动" /></a> 
					<a href="javascript:void(0);" ><img src="resource/image/play/wall3.jpg" alt="港澳旅游：超值特价，奢华享受" /></a> 
					<a href="javascript:void(0);" ><img src="resource/image/play/wall4.jpg" alt="炎炎夏日哪里去，途牛带你海滨游" /></a> 
					<a href="javascript:void(0);" ><img src="resource/image/play/wall5.jpg" alt="定途牛旅游线路，优惠购买乐相册" /></a> 
					<a href="javascript:void(0);" ><img src="resource/image/play/wall6.jpg" alt="三亚自助游" /></a>
				</li>
			</ul>
		</div>
	  </div>	
	  -->
	 
	 <div class="ui-grid-c">
      <div class="ui-block-a">
        <a href="javascript:;" class="ui-btn ui-corner-all ui-shadow">进口鲜果</a>
      </div>
      <div class="ui-block-b">
        <a href="javascript:;" class="ui-btn ui-corner-all ui-shadow">国产鲜果</a>
      </div>
      <div class="ui-block-c">
        <a href="javascript:;" class="ui-btn ui-corner-all ui-shadow">干果零食</a>
      </div>
      <div class="ui-block-d">
        <a href="javascript:;" class="ui-btn ui-corner-all ui-shadow">水果套餐</a>
      </div>  
    </div>
    
    <ul data-role="listview" data-inset="true">
      <li><a href="javascript:;">香橙</a></li>
      <li><a href="javascript:;">苹果</a></li>
      <li><a href="javascript:;">鸭梨</a></li>
      <li><a href="javascript:;">橘子</a></li>
      <li><a href="javascript:;">榴莲</a></li>
    </ul>
    
    <ul data-role="listview" data-inset="true">
      <li><a href="http://localhost:8080/weixin/activityDetails">活动1</a><br/>
      	<span>这个是活动一的相关内容</span>
      </li>
      <li><a href="javascript:;">活动2</a><br/>
      	<span>这个是活动二的相关内容</span>
      </li>
      <li><a href="javascript:;">活动3</a><br/>
      	<span>这个是活动三的相关内容</span>
      </li>
      <li><a href="javascript:;">活动4</a><br/>
      	<span>这个是活动四的相关内容</span>
      </li>
    </ul>
    
  </div>
  

  
  	<div class="ui-grid-a">
      <div class="ui-block-a">
        <a href="javascript:;" class="ui-btn ui-corner-all ui-shadow">联系我</a>
      </div>
      <div class="ui-block-b">
        <a href="javascript:;" class="ui-btn ui-corner-all ui-shadow">关于</a>
      </div>
    </div>
  <div data-role="footer">
  </div>
</div> 
<script>
	$(function(){
		var t = n = 0; count = $(".img_content a").size();
		var st=0;
		var play = ".play";
		var playText = ".play .text";
		var playNum = ".play .num a";
		var playConcent = ".play .img_content a";
		$(playConcent + ":not(:first)").hide();
		$(playText).html($(playConcent + ":first").find("img").attr("alt"));
		$(playNum + ":first").addClass("on");
		$(playNum).click(function() {
		   var i = $(this).text() - 1;
		   n = i;
		   if (i >= count) return;
		   $(playText).html($(playConcent).eq(i).find("img").attr('alt'));
		  // $(playText).unbind().click(function(){window.open($(playConcent).eq(i).attr('href'), "_blank")})
		   $(playConcent).filter(":visible").hide().parent().children().eq(i).fadeIn("fast");
		   $(this).removeClass("on").siblings().removeClass("on");
		   $(this).removeClass("on2").siblings().removeClass("on2");
		   $(this).addClass("on").siblings().addClass("on2");
		   
		});
		/*
		$(playConcent).click(function(){
			var i;
			if(n==0){
				i=1;
				n=1;
			}else{
				i=n+1;
				n++;
			}
			//alert(i);
			//alert(n);
			if(i>=count){
				i=0;
				n=0;
			}
			$(playText).html($(playConcent).eq(i).find("img").attr('alt'));
			//$(playText).unbind().click(function(){window.open($(playConcent).eq(i).attr('href'), "_blank")})
			$(playConcent).filter(":visible").hide().parent().children().eq(i).fadeIn(1200);
			$(".num a").eq(n).removeClass("on").siblings().removeClass("on");
			$(".num a").eq(n).removeClass("on2").siblings().removeClass("on2");
			$(".num a").eq(n).addClass("on").siblings().addClass("on2");
		})
		*/
		t = setInterval(function(){
			if(st==1){
				n = n <= (count - 1) ? --n :5;
			}else{
				n = n >= (count - 1) ? 0 : ++n;
			}
			$(".num a").eq(n).trigger('click');
		},1000);
		$(playConcent).bind("swiperight",function(){clearInterval(t)},function(){
			var i;
			st=0;
			if(n==0){
				i=1;
				n=1;
			}else{
				i=n+1;
				n++;
			}
			//alert(i);
			//alert(n);
			if(i>=count){
				i=0;
				n=0;
			}
			$(playText).html($(playConcent).eq(i).find("img").attr('alt'));
			//$(playText).unbind().click(function(){window.open($(playConcent).eq(i).attr('href'), "_blank")})
			$(playConcent).filter(":visible").hide().parent().children().eq(i).fadeIn(1200);
			$(".num a").eq(n).removeClass("on").siblings().removeClass("on");
			$(".num a").eq(n).removeClass("on2").siblings().removeClass("on2");
			$(".num a").eq(n).addClass("on").siblings().addClass("on2");
		})
		$(playConcent).bind("swipeleft",function(){clearInterval(t)},function(){
			
			var i;
			st=1;
			if(n==0){
				i=5;
				n=5;
			}else{
				i=n-1;
				n--;
			}
			$(playText).html($(playConcent).eq(i).find("img").attr('alt'));
			//$(playText).unbind().click(function(){window.open($(playConcent).eq(i).attr('href'), "_blank")})
			$(playConcent).filter(":visible").hide().parent().children().eq(i).fadeIn(1200);
			$(".num a").eq(n).removeClass("on").siblings().removeClass("on");
			$(".num a").eq(n).removeClass("on2").siblings().removeClass("on2");
			$(".num a").eq(n).addClass("on").siblings().addClass("on2");
		})
		
		
		$(play).hover(function(){clearInterval(t)}, function(){t = setInterval(function(){
																	if(st==1){
																		n = n <= (count - 1) ? --n :5;
																	}else{
																		n = n >= (count - 1) ? 0 : ++n;
																	}
																	$(".num a").eq(n).trigger('click');
															  }, 1000);});
															
	})
	</script>
</body>
</html>