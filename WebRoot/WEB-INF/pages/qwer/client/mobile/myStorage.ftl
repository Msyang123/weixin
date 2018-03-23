<!DOCTYPE html>
<html>
<head>
<title>水果熟了-我的仓库</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-我的仓库" />	
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="my-storage bg-white">
		<div class="orderhead">
			<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
			<div>我的仓库</div>
		</div>
		<div data-role="main" class="pb50">
			<div id="tipsDiv">
				仓库商品需在七天内提货，若未提货自动兑换成鲜果币。
			</div>
			<#if (sockProducts??)&&(sockProducts?size>0)>
			<table id="proTable">
				<#list sockProducts as sockProduct>
					<tr>
						<td width="25%"><img height="60px" src="${sockProduct.save_string}" onerror="imgLoad(this)"/></td>
						<td width="25%">${sockProduct.product_name}</td>
						<td width="15%">${sockProduct.amount}${sockProduct.base_unitname!}</td>
						<td width="30%"><button onclick="joinBasket(this,'${sockProduct.product_id}','${sockProduct.save_string}','${sockProduct.product_name}','${sockProduct.amount}');" class="join-basket">加入提货篮</button></td>
					</tr>
				</#list>
			</table>
			<#else>
			<!-- 当仓库为空时显示-->	
			<div class="empty-storage">
			<img height="150px" src="resource/image/icon/storage_empty.png" /><br/>
				只要人人都献出一点爱，仓库就会更实在
			</div>
			</#if>
			<div class="cartfoot">
					<div class="cartbutton" id="tx_btn">提货</div>
			</div>
			<!-- 提货篮 -->
			<div id="basket" onclick="expand()">
				<div id="basket_img">
					<img height="50px" width="50px" src="resource/image/icon/shopping-basket.png"/>
				</div>
				<div id="basket_num">${proNum}</div>
			</div>
			<!-- 展开提货列表 -->
			<div id="txhead">
				<div onclick="expand()">提货篮 <img style="width:20px;" src="resource/image/icon/arrows-down.png"/></div>
				<div class="clear-cart" onclick="clearBasket();">清空</div>
			</div>
			<div id="txList">
				<div style="height:50px;"></div>
			</div>
		</div>
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/jQuery/json2.js"></script>
    <script src="plugin/common/productDetial.js"></script>
	<script src="plugin/common/location.js"></script>
	<script type="text/javascript">
		function expand(){
			if($("#txList").css("display")=="block"){
				$("#txList").css("display","none");
				$("#txhead").css("display","none");
			}else{
				$("#txList").css("display","block");
				$("#txhead").css("display","block");
			}
		}
		
		function back(){
			window.location.href="${CONTEXT_PATH}/me";
		}
		
		function loadBasket(){
			$("#txList").load("${CONTEXT_PATH}/txBasket");
		}
		
		function imgLoad(element){
			var imgSrc=$(element).height()<80?"resource/image/icon/failed-small.png":"resource/image/icon/failed-big.png"
			$(element).attr("src",imgSrc);
	    }
	    
		//清空提货篮
		function clearBasket(){
			//情况
			$.cookie('basketInfo',null,{path:"/",expires: -1});
			$("#basket_num").html('0');
			$("#basket_num").css("display","none");
			//重新请求我的仓库刷新页面
			loadBasket();
		}
	
	    //加入商品到提货篮中
		function joinBasket(self,productId,imageUrl,productName,amount,isInt){
		    var productName=productName.replace("("," ").replace(")"," ");
			var num = parseInt($("#basket_num").html());
			if(num==0){
				$("#basket_num").css("display","block");
			}
			var max_num = parseFloat(amount).toFixed(2);
			var new_historyp='{"product_id":"'+productId+'","product_num":"'+max_num+'","image_url":"'+imageUrl+'","amount":"'+amount+'","product_name":"'+productName+'"}';
			//实现购物车飞入效果  
		    var _sourceImg=$(self).parents('tr').find('img');
	        var _back=function(){};
	        var _target=$("#basket_img");
	        
			if($.cookie('basketInfo')==null||$.cookie('basketInfo')=='null'){
			  $("#basket_num").html(num+1);
		      new_historyp='['+new_historyp+']';
		      $.cookie('basketInfo',new_historyp,{expires:15,path:'/'});
		      loadBasket();
		 	}else{
		      var old_historyp_json=JSON.parse($.cookie('basketInfo'));
		      var flag=false;
		      console.log(old_historyp_json);
		      for(var i=0;i<old_historyp_json.length;i++){
			      	if(old_historyp_json[i].product_id==productId){
			      		var productNum = old_historyp_json[i].product_num;
			      		var pro_id = "#basketProduct"+productId;
			      		var pro_val = $(pro_id).val();
			      		if(pro_val==null||pro_val==""){
			      			pro_val = '0.0';
			      		}
			      		var pro_num = parseFloat(pro_val);
			      		//检测是否加入的数量超过总数量
			      		if(pro_num> parseFloat(amount)){
			      			alert("不能超出拥有数量！");
			      			$(pro_id).val(productNum);
			      			return;
			      		}
						if(isInt=="1"){
							pro_num = parseInt(pro_val);
							$(pro_id).val();
			      		}else{
			      			pro_num = pro_num.toFixed(2);
			      			$(pro_id).val(parseFloat(pro_val).toFixed(2));
			      		}
			      		
			      		old_historyp_json[i].product_num=pro_num;
			      		flag=true;
			      		break;
			      	}
		      }
		      //新的就加进来
		      if(flag==false){
		      	var item  =
			     {
			         "product_id" : productId,
			         "product_num" : max_num,
			         "image_url":imageUrl,
			         "amount":amount,	
			         "product_name": productName,		         
			     }
				old_historyp_json.push(item);
		      	$("#basket_num").html(num+1);
		      }
		      //将json对象转换成字符串存cookie
		      $.cookie('basketInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
		      loadBasket();
		     }
		     common.objectFlyIn(_sourceImg,_target,_back);
		}
	
	    //从购物车删除商品
		function delFromBasket(productId){
			var num = parseInt($("#basket_num").html());
			if($.cookie('basketInfo')!=null){
	          //将字符串转换成json对象
	          var old_historyp_json=JSON.parse($.cookie('basketInfo'));
	          for(var i=0;i<old_historyp_json.length;i++){
		          	if(old_historyp_json[i].product_id==productId){
		          		$.dialog.message("确认删除该商品吗？",true,function(){
		          			old_historyp_json.splice(i, 1);
		              		//将json对象转换成字符串存cookie
		              	    $.cookie('basketInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
		              	    loadBasket();
		              	    if(num>1){
		              	    	$("#basket_num").html(num-1);
		              	    }else{
		              	    	$("#basket_num").hide();
		              	    	$("#basket_num").html(num-1);
		              	    }
		          		});
		          		break;
		          	}
	          }
	        }
		}
		
		var latitude,longitude,accuracy;
		$(function() {
			var num = 0;
			<#if proNum??>
				num = '${proNum}';
			</#if>
			$("#basket_num").html(num);
			if(num==0){
				$("#basket_num").css("display","none");
			}
			loadBasket();
			
			$("#tx_btn").click(function(){
				var num = parseInt($("#basket_num").html());
				if(num<=0){
					$.dialog.alert("请添加商品到提货蓝中！");
					return;
				}
				window.location.href="${CONTEXT_PATH}/txOrder?lat="+latitude+"&lng="+longitude;
			});	
		});
		
	    //安卓手机调用输入法时底部按钮上移
		/*var oHeight = $(document).height(); //浏览器当前的高度
	  	$(window).resize(function(){
	        if($(document).height() < oHeight){
		        $(".cartfoot").css("position","static");
		    }else{
		        $(".cartfoot").css("position","absolute");
		    }   
	   	});*/
	   	
	</script>
</body>
</html>