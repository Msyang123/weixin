<div id="zs_list">
	<!-- 商品列表开始 -->
	<#if products?? && (products?size>0)>
		<#list products as item>
		<div class="row no-gutters align-items-center zs-product">
			<div class="col-3">
				<div id="boll${item.pf_id}" class="boll"></div>
				<img height="60" src="${item.save_string!}" onclick="fruitDetial('${item.pf_id}')" onerror="imgLoad(this)"/>
			</div> 
			<div class="col-5">
				<div class="font_blod">
					${item.product_name}			
					<span>${item.product_amount!}${item.base_unitname!}/${item.unit_name!}</span>
				</div>
				<div class="font_price">￥${(item.real_price!0)/100}</div>
			</div>
			<div class="col-4 justify-content-center">
			    <#if item.queryStatus=="true" && item.inv_enough=="true">	
				<div class="joinToCart" val='${item.id}' pfId='${item.pf_id}'>
					<img height="25px" src="resource/image/icon/icon-plus.png" />
				</div>
				<#else>
				    <span class="brand-blue" style="font-size: 1.4rem;">补货中</span>    
				</#if>				
			</div>	
			<div class="col-12 divider"></div>	
			<div class="col-4 offset-8 opreation text-center">
			    <#if item.queryStatus=="true" && item.inv_enough=="true">
				   <button type="button" val='${item.id}' pfId='${item.pf_id}' class="btn-custom">立即赠送</button>
				<#else>
				</#if>	
		    </div>	  
		</div>
		</#list>
		<#else>
		<!--搜索不到商品时-->
		<div id="no_pro">
			<img src="resource/image/icon/cry.png">
			<p>抱歉~</p>
			<p>果果们正在赶来的路上哦</p>
		</div>
	</#if>
</div>

<div id="cart" onclick="toPresentCart();">
	<div id="cart_img"><img src="resource/image/icon/shopping-basket.png"/></div>
	<div id="cart_num">0</div>
</div>

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
	
   //点击添加到购物车 
   $(".joinToCart").click(function(){
   		  var that=$(this);
   		  //实现购物车飞入效果  
		  var _sourceImg=$(this).parents('.zs-product').find('.boll').next('img');
	      var _back=function(){
		       //添加到购物车cookie处理
		       joinCartCallback(that.attr("val"),that.attr("pfId"));
	      };
	      var _target=$("#cart_img");
	      objectFlyIn(_sourceImg,_target,_back);
   });
   
   //从购物车删除商品
   $(".removeFromCart").click(function(){
   		if($.cookie('zscartInfo')==null){
			return;	
		}
		var num = parseInt($("#cart_num").html());
		
		var old_historyp_json=JSON.parse($.cookie('zscartInfo'));
		
	    for(var i=0;i<old_historyp_json.length;i++){
	    	//找到了购物车中指定的商品
	      	if(old_historyp_json[i].pf_id==$(this).attr("pfId")){
	      		old_historyp_json[i].product_num=old_historyp_json[i].product_num-1;
	      		$("#cart_num").html(num-1);
	      		//如果购物车当前数量是1，就不显示购物车图标,并且清空cookie
	      		if(num==1){
					$("#cart_num").css("display","none");
					$.cookie('zscartInfo', null, {
						path : "/",
						expires : -1
					});
					$("#productNumDisplay"+$(this).attr("pfId")).html(0);
					return;
				}
				//如果此项商品数量为0，则购物车中清除掉此商品
				if(old_historyp_json[i].product_num==0){
					old_historyp_json.splice(i,1);
					$("#productNumDisplay"+$(this).attr("pfId")).html(0);
				}else{
					var productNum = parseInt($("#productNumDisplay"+$(this).attr("pfId")).html());
   					$("#productNumDisplay"+$(this).attr("pfId")).html(productNum-1);
				}		    
	      		$.cookie('zscartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
	      		return;
	      	}
	     }
   });
   //立即赠送
   $(".btn-custom").click(function(){
   		/*
   		var productNum= parseInt($("#productNumDisplay"+$(this).attr("pfId")).html());
   		if(productNum==0){
   			$.dialog.alert("请先选择商品数量！");
   			return;
   		}else{
   			window.location.href="${CONTEXT_PATH}/presentOrder?isImmediate=Y&productNum="+productNum+"&pfId="+$(this).attr("pfId");
   		}*/
   		window.location.href="${CONTEXT_PATH}/presentOrder?isImmediate=Y&pfId="+$(this).attr("pfId");
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
		if($.cookie('zscartInfo')==null){//cookie 不存在     
	      $.ajax({ 
				url: "${CONTEXT_PATH}/activity/restrict", 
				data: {count:1,productFId:pfId}, 
				success: function(data){
					if(data.isLimit){
						$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
					}else{
				   		new_historyp='['+new_historyp+']';
	      				$.cookie('zscartInfo',new_historyp,{expires:15,path:'/'});
	      				$("#cart_num").html(1);
			     	}
		     	}
		   });
	 	}else{//cookies已经存在,就将存储的cookie取出然后判定是已经加入的还是新的，原来的直接覆盖
	      //将字符串转换成json对象
	      var old_historyp_json=JSON.parse($.cookie('zscartInfo'));
	      var flag=false,index=0,count=1;
	      for(var i=0;i<old_historyp_json.length;i++){
	      	if(old_historyp_json[i].pf_id==pfId){
	      		index=i;
	      		flag=true;
	      		break;
	      	}
	      }
		
		if(flag){
			count=parseInt(old_historyp_json[index].product_num)+1;
		}
		$.ajax({ 
				url: "${CONTEXT_PATH}/activity/restrict", 
				data: {count:count,productFId:pfId}, 
				success: function(data){
					if(data.isLimit){
						$.dialog.alert("此商品今天超过购买数量限制，请购买其它商品!");
					}else{
					      //新的就加进来
					     if(flag==false){
					      	var item  =
							     {
							         "product_id" : productId,
							         "product_num" : 1,
							         "pf_id": pfId
							     }
							old_historyp_json.push(item);
					      }else{
					      	old_historyp_json[index].product_num=parseInt(old_historyp_json[index].product_num)+1;
					      }
					      //将json对象转换成字符串存cookie
					      $.cookie('zscartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
						 $("#cart_num").html(num+1);
			     	}
		     	}
		   });
		}  
	}
});	
function toPresentCart(){
	window.location.href="${CONTEXT_PATH}/zscart";
}
function srdzDetail(tcName){
	window.location.href = "${CONTEXT_PATH}/srdzDetail?tcName="+tcName;
}
function imgLoad(element){
		var imgSrc=$(element).height()<80?"resource/image/icon/failed-small.png":"resource/image/icon/failed-big.png"
		$(element).attr("src",imgSrc);
}
</script>