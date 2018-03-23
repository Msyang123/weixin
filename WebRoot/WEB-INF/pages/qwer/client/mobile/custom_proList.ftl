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
	 <div data-role="page" id="cart">
		<div class="carthead">
			<div class="btn-back">
				<a onclick="window.history.back()">
					<img height="20px" width="10px" src="${CONTEXT_PATH}/resource/image/icon/icon-back.png" />
				</a>
			</div>
			${activity.main_title!}
    	</div>
    	<div data-role="main" class="mt41">
			<table id="pro_list">
				<!-- 商品列表开始 -->
				<#list products as item>
				<tr>
					<td width="40%">
						<div id="boll${item.pf_id}" class="boll"></div>
						<img height="80px" src="${item.save_string!}" onclick="fruitDetial('${item.pf_id}')"/>
					</td> 
					<td width="30%">
						<div class="font_blod">
                            ${item.product_name}
							<br/>
							<span>${item.product_amount!}${item.base_unitname!}/${item.unit_name!}</span>
						</div>
						<div class="font_price">￥${(item.real_price!0)/100}</div>
					</td>
					<td width="30%">
						<div class="joinCart" val="${item.id}" pfId="${item.pf_id}">
						<img height="25px" src="resource/image/icon/icon-plus.png" />
						</div>
					</td>
				</tr>
				</#list>
			</table>
			<div id="cart" onclick="toCart();">
			  	<div id="cart_img"><img src="resource/image/icon/shopping-basket.png"/></div>
			  	<div id="cart_num">0</div>
			</div>
       </div>
    </div>
    <#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/jQuery/json2.js"></script>
	<script src="plugin/gw/parabola.js"></script>
	<script src="plugin/common/productDetial.js"></script>
    <script type="text/javascript">
		function backToMain(){
			window.location.href="${CONTEXT_PATH}/main";
		}
		
		function toCart(){
			window.location.href="${CONTEXT_PATH}/cart";
		}
		
		$(function() {
			var num = 0;
			if('${proNum}'){
				num = '${proNum}';
			}
			$("#cart_num").html(num)
			if(num==0){
				$("#cart_num").css("display","none");
			}
			//购物车商品添加动作动画
			var bool = new Parabola({
		       el: "",
		       targetEl: $("#cart_img"),
			   <#if from=='category' >  
			    offset: [-60, -10],
			   <#else>
			    offset: [0, 0],
			   </#if>
			    curvature: 0.001,
			    duration: 500,
		        callback:function(){
			    	//添加到购物车cookie处理
					//joinCartCallback(this.goodsInfo,this.pfId);
			    	//动画重新回位
					bool.reset(-72,-40);
		        },
		       stepCallback:function(x,y){
			       
		       }
		   });
		   //点击添加到购物车 
		   $(".joinCart").click(function(){
				var val=$(this).attr("val")
				var pfId=$(this).attr("pfId")       
			    var _sourceImg=$(this).parents('tr').find('.boll').next('img');
			    var _back=function(){
			       //添加到购物车cookie处理
			       joinCartCallback(val,pfId);
			    };
	            var _target=$("#cart_img");
			    objectFlyIn(_sourceImg,_target,_back);	
		   });
		   
		   function objectFlyIn(_sourceImg,_target, _back) {
		        var addOffset =_target.offset();
		
		        var img = _sourceImg;
		        var flyer = $('<img style="display: block;width: 50px;height: 50px;border-radius: 50px;position: fixed;z-index: 999;" src="' + img.attr('src') + '">');
		        var X,Y;
		
		        if(img.offset()){
		            X = img.offset().left - $(window).scrollLeft();
		            Y = img.offset().top - $(window).scrollTop();
		        }
		        flyer.fly({
		            start: {
		                left: X + img.width() / 2 - 25, //开始位置（必填）
		                top: Y + img.height() / 2 - 25 //开始位置（必填）
		            },
		            end: {
		                left: addOffset.left + 10, //结束位置（必填）
		                top: addOffset.top + 10, //结束位置（必填）
		                width: 10, //结束时宽度
		                height: 10 //结束时高度
		    },
		            onEnd: function () { //结束回调
		                this.destroy(); //移除dom
		                _back();
		            }
		        });
		
		    }
    
			//加入商品到购物车中动画回调
			function joinCartCallback(productId,pfId){
				var num = parseInt($("#cart_num").html());
				if(num==0){
					$("#cart_num").css("display","block");
				}
				var new_historyp='{"product_id":"'+productId+'","product_num":"'+(num+1)+'","pf_id":"'+pfId+'"}';
				if($.cookie('cartInfo')==null){//cookie 不存在     
			      new_historyp='['+new_historyp+']';
			      $.cookie('cartInfo',new_historyp,{expires:15,path:'/'});
			 	}else{//cookies已经存在,就将存储的cookie取出然后判定是已经加入的还是新的，原来的直接覆盖
			      //将字符串转换成json对象
			      var old_historyp_json=JSON.parse($.cookie('cartInfo'));
			      var flag=false;
			      for(var i=0;i<old_historyp_json.length;i++){
			      	if(old_historyp_json[i].pf_id==pfId){
			      		old_historyp_json[i].product_num=parseInt(old_historyp_json[i].product_num)+1;
			      		flag=true;
			      		break;
			      	}
			      }
			      //新的就加进来
			      if(flag==false){
			      	var item  =
					     {
					         "product_id" : productId,
					         "product_num" : 1,
					         "pf_id": pfId
					     }
					old_historyp_json.push(item);
			      }
			      //将json对象转换成字符串存cookie
			      $.cookie('cartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
			     }
				$("#cart_num").html(num+1);
			}
		});	

		function srdzDetail(tcName){
			window.location.href = "${CONTEXT_PATH}/srdzDetail?tcName="+tcName;
		}
     </script>
</body>
</html>