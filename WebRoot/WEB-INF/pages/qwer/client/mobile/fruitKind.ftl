<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-水果分类" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page">
		<div data-role="main" id="fruit_kind">
			<div class="orderhead">
				<div class="btn-back"><a onclick="backToMain()"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
				<div class="category-name">${parentTCategory.category_name}</div>
			</div>
			<div id="menuShadow"></div>
			<div id="menu">
				<ul>
				<#list tCategorys as category>
					<li><div id="cat${category.category_id}" onclick="loadProList('${category.category_id}');">${category.category_name}</div></li>
				</#list>	
				</ul>
			</div>
			<!-- 导航菜单 -->
			<!-- 产品内容 -->
			<div id="content"></div>
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
			$("#menu ul li div").eq(0).click();
		});
		
		function loadProList(category_id){
			$("#menu ul li div").removeClass("catdiv");
			$("#cat"+category_id).addClass("catdiv");
			$("#content").load("${CONTEXT_PATH}/catProList?category_id="+category_id);
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