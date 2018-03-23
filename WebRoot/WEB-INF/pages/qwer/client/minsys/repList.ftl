<!DOCTYPE html>
<html>
<head>
<title>水果熟了-微后台-回复</title>
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
<link rel="stylesheet"
	href="plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.css">
<link rel="stylesheet" href="plugin/scroll/css/index.css">
<script src="plugin/jQuery/jquery-1.11.0.min.js"></script>
<script src="plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.js"></script>
<script src="plugin/jquery.mobile-1.4.2/juqery.mobile-1.4.2.alert.js"></script>
<script src="plugin/jQuery/jquery.cookie.js"></script>
<script src="plugin/jQuery/json2.js"></script>

<style type="text/css">
body{
	font-family: 方正兰亭黑;
}

.carthead{
	height:50px;
	width:100%;
	line-height:50px;  
	background-color:#f5f5f5;
	text-align:center;
	font-size:20px;
	letter-spacing: 2px;
	position: fixed;
	top:0px;
	z-index:99;
}
.font_blod{
	font-size:12px;
	font-weight:bold;
	height:30px;
	width:100%;
}
.font_price{
	font-size:14px;
	font-weight:bold;
	color:orange;
	width:100%;
	margin-top: 20px;
}
.font_s{
	font-size:12px;
	color:#636363;
	height:30px;
	width:100%;
	line-height: 30px;
	font-weight:normal;
}
td{
	padding-top:5px;
	padding-bottom:5px;
}
</style>
</head>
<body>
	<div data-role="page">
		<div class="carthead" style="border-bottom:1px solid #ddd;">
			<div style="float: left; margin-left: 10px; cursor: pointer;">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<div style="font-size: 16px;">微后台-回复</div>
    	</div>
    	<div data-role="main" style="background-color:white;">
    		<div style="height:50px;"></div>
    		<div id="proListDiv">
    			<table style="width: 100%;border-collapse:collapse;">
					<#list msgList as item>
					<tr style="border-bottom:1px solid #ddd;">
						<td width="20%">
							<img height="40px" src="${item.user_img_id}"/>
						</td>
						<td width="20%">
							${item.nickname}
						</td> 
		
						<td width="40%" style="text-align:left;line-height:20px;">
							<div class="font_blod">
								${item.content}
							</div>
						</td>
						<td width="20%">
							<a href="#dialog" onclick="$('#id').val(${item.id});$('#msgFrom').val('${item.msg_from}');" data-position-to="window" data-rel="popup" class="ui-btn ui-corner-all"
												style="font-size: 12px; color: orange;
												 font-weight: normal; border-color: orange;float: right;" data-transition="slideup">回复</a>
						</td>
					</tr>
					</#list>
				</table>
    		</div>
    		
    		<div data-role="navbar">
		      <ul>
		        <!--<li><a href="${CONTEXT_PATH}/minSys/initMinsysOrderList" data-icon="navigation" data-ajax="false">订单</a></li>-->
		        <li><a href="${CONTEXT_PATH}/minSys/initRepList" data-icon="navigation" data-ajax="false">刷新</a></li>
		      </ul>
		    </div>
    	</div>
    	
    	<div data-role="popup" id="dialog" class="ui-content" style="min-width:250px;">
	      <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
	        <div>
	          <h3>请填写回复内容</h3>
	          	<form id="submitForm">
		          	<input type="hidden" name="id" id="id" />
		          	<input type="hidden" name="msgFrom" id="msgFrom" />
		           	<div class="ui-field-contain">
				        <input type="text" id="content" />
				        <input type="button" onclick="replay();" style="color:#de374e;" class="ui-btn ui-mini" value="确定">
			      	</div>
		      	</form>
	        </div>
	    </div>
    </div>
    
<script type="text/javascript">
	function back(){
		window.history.back();
	}
	function replay(){
	    $.ajax({ 
			url: "${CONTEXT_PATH}/weixin/sendCustomMessage", 
			data: {id:$('#id').val(),msgFrom:$('#msgFrom').val(),content:$('#content').val(),type:'ajax'}, 
			success: function(data){
				if(data.errcode==0){
					$.dialog.alert("回复成功");
					window.location.reload();
				}else{
					$.dialog.alert(data.errmsg);
				}	
	      	}
		});
	}
</script>
</body>
</html>