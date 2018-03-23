<!DOCTYPE html>
<html>
<head>
<title>水果熟了-微后台-订单</title>
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
				<div style="font-size: 16px;">微后台-订单</div>
    	</div>
    	<div data-role="main" style="background-color:white;" class="ui-content">
    		<div style="height:50px;"></div>
				
			<table data-role="table" class="ui-responsive">
		      <thead>
		        <tr>
		          <th>订单编号</th>
		          <th>店铺</th>
		          <th>支付</th>
		          <th>昵称</th>
		          <th>手机号</th>
		          <th>创建时间</th>
		          <th>退货理由</th>
		          <th>操作</th>
		        </tr>
		      </thead>
		      <tbody>
		      <#list orderList as item>
		        <tr>
		          <td>${item.order_id}</td>
		          <td>${item.store_name!}</td>
		          <td>${(item.need_pay!0)/100}</td>
		          <td>${item.nickname!}</td>
		          <td>${item.phone_num!}</td>
		          <td>${item.createtime!}</td>
		          <td>${item.reason!}</td>
		          <td><button class="ui-btn"  onclick="orderReject(${item.id});">退货</button></td>
		        </tr>
		      </#list>  
		      </tbody>
		    </table>
    		
    		<div data-role="navbar">
		      <ul>
		        <!--<li><a href="${CONTEXT_PATH}/minSys/initMinsysOrderList" data-icon="navigation" data-ajax="false">订单</a></li>-->
		        <li><a href="${CONTEXT_PATH}/minSys/initRepList" data-icon="navigation" data-ajax="false">回复</a></li>
		      </ul>
		    </div>
    	</div>
    	
    </div>
    
<script type="text/javascript">
	function back(){
		window.history.back();
	}
	function orderReject(_id){
       $.dialog.message("确认退货吗？",true,function(){
			$.ajax({ 
				url: "${CONTEXT_PATH}/orderManage/orderReject", 
				data: {id:_id}, 
				success: function(data){
					$.dialog.alert(data.msg);
		      	}
			});
		});
    }
</script>
</body>
</html>