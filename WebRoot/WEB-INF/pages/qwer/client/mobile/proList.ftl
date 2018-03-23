<table id="pro_list">
	<!-- 商品列表开始 -->
	<#if products?? && (products?size>0)>
		<#list products as item>
		<tr>
			<td width="40%">
				<div id="boll${item.pf_id}" class="boll"></div>
				<img height="80px" src="${item.save_string!}" onerror="common.imgLoad(this)" onclick="fruitDetial('${item.pf_id}')"/>
			</td> 
			<td width="30%">
				<div class="font_blod">
					${item.product_name}
					<span>${item.product_amount!}${item.base_unitname!}/${item.unit_name!}</span>
				</div>
				
				<#if item.real_price??>
					<div class="font_price">￥${(item.real_price!0)/100}<del>￥${(item.price!0)/100}</del></div>
				<#else>
					<div class="font_price">￥${(item.price!0)/100}</div>
				</#if>
			</td>
			<td width="30%">
			    <#if item.queryStatus=="true" && item.inv_enough=="true">
			        <div style="width:100%" class="joinCart" val="${item.id}" pfId="${item.pf_id}">
					    <img height="25px" src="resource/image/icon/icon-plus.png" />
					</div> 
			    <#else>
			        <span class="brand-blue" style="font-size: 1.4rem;">补货中</span>    
				</#if>
			</td>
		</tr>
		</#list>
	<#else>
		<!--搜索不到商品时-->
			<div id="no_pro">
				<img src="resource/image/icon/empty-pro.png">
				<p>抱歉~</p>
				<p>果果们正在赶来的路上哦</p>
			</div>
	</#if>
</table>

<div id="cart" onclick="toCart();">
  	<div id="cart_img"><img src="resource/image/icon/shopping-basket.png"/></div>
  	<div id="cart_num">0</div>
</div>

<script src="plugin/jQuery/json2.js"></script>
<script src="plugin/gw/parabola.js"></script>
<script src="plugin/common/productDetial.js"></script>
<script src="plugin/common/location.js"></script>
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
	
    var date = new Array();
   
   //点击添加到购物车 
   $(".joinCart").click(function(){
	   date.push(new Date());
		
		if (date.length > 1 && (date[date.length - 1].getTime() - date[date.length - 2].getTime() < 500)){
			e.cancelBubble = true;
			return false;
		}
		
    	var val=$(this).attr("val"),pfId=$(this).attr("pfId"),count=1,flag=false,index=0;
    	var _sourceImg=$(this).parents('tr').find('.boll').next('img');
	    var _back=function(){
		       //添加到购物车cookie处理
		       joinCartCallback(val,pfId);
	    };
	    var _target=$("#cart_img");
    	
   		if($.cookie('cartInfo')!=null){
   			var old_historyp_json=JSON.parse($.cookie('cartInfo'));
   			for(var i=0;i<old_historyp_json.length;i++){
	          	if(old_historyp_json[i].pf_id==pfId){
	          		flag=true;
	          		index=i;
	          		break;
	          	}
	        }
   		}
        
        if(flag){
           count=parseInt(old_historyp_json[index].product_num)+1;
        }
        
        $.ajax({
			url: "${CONTEXT_PATH}/queryStoreInv", 
			data: {product_id:val}, 
		    success: function(result){
					if(!(result&&result.inv_enough)){
						$.dialog.alert("该门店库存不足\n换个门店试试吧");
					}else{
					    //库存充足后判断购买限制
					    $.ajax({ 
							url: "${CONTEXT_PATH}/activity/restrict", 
							data: {count:count,productFId:pfId}, 
							success: function(data){
								if(data.isLimit){
									$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
								}else{						
									common.objectFlyIn(_sourceImg,_target,_back);
						        }
					        }
					    });
					}
		    }			
		});
  
   });
   
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
	 	}else{
		   //cookies已经存在,就将存储的cookie取出然后判定是已经加入的还是新的，原来的直接覆盖
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

function backToMain(){
	window.location.href="${CONTEXT_PATH}/main";
}

function toCart(){
	window.location.href="${CONTEXT_PATH}/cart";
}

function srdzDetail(tcName){
	window.location.href = "${CONTEXT_PATH}/srdzDetail?tcName="+tcName;
}
</script>