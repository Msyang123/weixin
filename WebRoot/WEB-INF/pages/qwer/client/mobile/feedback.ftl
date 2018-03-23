<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-反馈中心" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="feed_back" class="bg-white">	
		<div class="orderhead">
			<div class="btn-back"><a onclick="backToMain()"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div class="commit" onclick="fbCommit()"><img height="25px" src="resource/image/icon/tijiaofankui.png" /></div>
			<div>反馈中心</div>
		</div>
		
		<div data-role="main" class="feed-back">
			<form>
				<div class="fb-tittle-box">
					<label for="fb_title">意见反馈</label>
					<input type="text" placeholder="请输入主题（20字以内）" id="fb_title" name="fb_title" data-role='none'/>
				</div>
				<p>反馈内容</p>
      			<textarea name="fb_content" id="fb_content" class="recede-box" maxlength="200" placeholder="200字以内"></textarea>
			</form>
		</div>
		<div id="tips">提交成功，感谢您的反馈！</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		 function fbCommit(){
			var fb_title = $("#fb_title").val();
			var fb_content = $("#fb_content").val();
			if(fb_title==""){
				$.dialog.alert("标题不能为空！");
				return;
			}
			if(fb_title.length>50){
				$.dialog.alert("标题不能超过50个字符！");
				return;
			}
			if(fb_content==""){
				$.dialog.alert("内容不能为空！");
				return;
			}
			if(fb_content.length>200){
				$.dialog.alert("内容不能超过200个字符！");
				return;
			}
			$.ajax({ 
				url: "${CONTEXT_PATH}/feedback_cmt", 
				data: {fb_title:fb_title,fb_content:fb_content}, 
				success: function(){
		        	$("#tips").css("display","block");
		        	setTimeout(function(){
		        		window.location.href="${CONTEXT_PATH}/me";
		        	},2000);
		      	}
			});			
		}
		
		function backToMain(){
			window.history.back();
		}
	</script>
</body>
</html>