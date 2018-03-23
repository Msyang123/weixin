<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-搜索" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>

</head>
<body>
	<div data-role="page" id="order" class="search-page bg-white">
		<div class="carthead search-head">
			<div class="btn-back">
				<a onclick="window.history.back()">
					<img style="height:20px;width:10px;"src="${CONTEXT_PATH}/resource/image/icon/icon-back1.png" />
				</a>
			</div>
			<div class="search-box">
				<img src="resource/image/icon/icon-search.png">
				<input type="search" name="search" id="search" data-role='none' />
			</div>
			<div class="btn-search">
				<a onclick="searchPro();">搜索</a>
			</div>
    	</div>
    	<div data-role="main">
    		<div style="height:50px;"></div>
    		<div id="proListDiv"></div>
    	</div>
    </div>

<div id="seed-entry" data-toggle="modal" onclick="getSeed();">
	<img src="resource/image/activity/seedbuy/seed-start.png"/>
</div>

<div id="seed-end">
	<img src="resource/image/activity/seedbuy/seed-end.png"/>
	<div class="countdown-box">
		<p>距离下次发放还有</p>
		<div class="countdown-num" id="countdown-num">
			<span>0</span>
			<span>0</span>
			<span>0</span>
			<span>0</span>
		</div>
		<div class="count-line"></div>
	</div>
</div> 
    
<div class="modal fade" id="get-seed" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog">
        		<div class="modal-content">
		            <div class="col-12">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		            </div>
            	<div class="modal-body text-center">	
            	<p>恭喜您获得</p>

            	<img id="get-seed-img">
            	<p class="seed-kind"></p>

            	<p class="seed-text">您可以通过种子来兑换水果哦~</p>
            	
            	<div class="col-12 text-center">
		        	<button type="button" class="btn-exchange btn-custom" onclick="goSend();">去看看</button>
		        </div>
            	</div>
            
        </div>
    </div>
</div>  
  
    <#include "/WEB-INF/pages/common/share.ftl"/>
    
	<script src="resource/scripts/seedbuy.js"></script>
    <script type="text/javascript">
			$(function() {
				var num = 0;
				if('${proNum}'){
					num = '${proNum}';
				}
				$("#cart_num").html(num)
				if(num==0){
					$("#cart_num").css("display","none");
				}
				$("#menu ul li div").eq(0).click();
				searchPro();
			});
		
			function searchPro(){
				var keyword = $("#search").val();
				$("#cart").css("display","block");
				$("#proListDiv").load("${CONTEXT_PATH}/searchProList?keyword="+keyword);
			}

			//发送Ajax去请求与路径相匹配的分享模板
			$.ajax({
			    type:'Get',
				url: "${CONTEXT_PATH}/share",
			    success: function(result){
			          if(result){		          
			               var link=window.location.href;
			               var imgUrl=result.share.picture?'${app_domain}'+result.share.picture.replace("/weixin",""):
				               '${app_domain}/resource/image/logo/shuiguoshullogo.png';
			               var title=result.share.title;
			               var desc=result.share.content;
			               
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