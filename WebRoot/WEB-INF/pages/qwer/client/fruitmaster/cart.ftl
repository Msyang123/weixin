<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-购物车页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

    <div id="shop_cart" class="wrapper">
	
	    <header class="g-hd bg-white">
			<span>购物车</span>
			<span class="u-btn-modal" onclick="clearCart()">清空</span>
	    </header>
		    
		<#if (proList??)&&(proList?size>0)>
	    <section class="m-list-food bg-white mt48">
	    	<#list proList as item>
		        <div class="m-item row justify-content-center align-items-center no-gutters" 
		        data-pid="${item.product.id}" data-pfid="${item.product.pf_id}" data-num="${item.productNum!}">  
		        
		            <div class="col-1 text-center pr5"><input type="checkbox" name="product" /></div>
		            
		            <div class="col-4">
		                <img src="${item.product.save_string}" class="img-fluid" title="商品缩略图" onerror="common.imgLoadMaster(this)" />
		            </div>
		            
		            <div class="col-4 pro-info pl15">
		               <h4>${item.product.product_name}</h4>
		               <h5>${item.product.product_amount!}${item.product.base_unitname!}</h5>
		               <span class="pro-price" id="productPrice${item.product.pf_id}" 
		               data-price="${(item.product.real_price!0)/100}">&yen; ${(item.product.real_price!0)/100}</span>
		            </div>
		            
		            <div class="col-3 align-self-end m-opreations">
						<span class="u-btn-opreation js-btn-cut" 
						onclick="delFromCart('${item.product.id}','${item.product.pf_id}');">
						   <img src="resource/image/icon-master/btn_cut.png" />
						</span>
					    <span class="pro-num" id="proNum${item.product.pf_id}">${item.productNum!}</span>
						<span class="u-btn-opreation js-btn-add" 
						onclick="addToCart('${item.product.id}','${item.product.pf_id}');">
						   <img src="resource/image/icon-master/btn_add.png" />
						</span>
		            </div>
		        </div>
	        </#list>
	    </section>
	    
	    <footer class="m-settlement m-opreation row no-gutters justify-content-between align-items-center">
         <div class="col-9">
              <div class="row no-gutters justify-content-around align-items-center">
	         	  <div class="col-6 u-input-selall">
	         	       <input type="checkbox" id="select_all" />
	         	       <label for="select_all">全选</label>
	         	   </div>
	              <div class="col-6">
	                  <p>合计:<span class="total-num">&yen; <span  id="total_price"> 0.00</span></span></p>
	              </div>
              </div>
         </div>
	         <div class="col-3 u-btn-settle text-center" id="balance">购买</div>
	    </footer>
			 
	    <#else>
		<div class="empty-box mt88 text-center">
			<img class="u-empty-pic mb15" src="resource/image/icon-master/cart_empty.png" />
			<p>动动小手，水果我有 <a href="${CONTEXT_PATH}/mall/shopIndex" class="brand-blue">Go!</a></p>
		</div> 
        </#if>
        
        <footer class="m-nav row no-gutters">
			<div class="col u-nav-btn active" onclick="goHome();">
				<img src="resource/image/icon-master/nav_home_default.png">
				<br/><span class="f-nav-index">首页</span>
			</div>
			<div class="col u-nav-btn" onclick="goMall();">
				<img src="resource/image/icon-master/nav_mall_default.png">
				<br/><span class="f-nav-mall">商城</span>
			</div>
			<div class="col u-nav-btn u-nav-center" onclick="goFresh();">
				<img src="resource/image/icon-master/nav_center_default.png">
			</div>
			<div class="col u-nav-btn">
				<img src="resource/image/icon-master/nav_cart_selected.png">
				<br/><span class="f-nav-cart z-crt">购物车</span>
			</div>
			<div class="col u-nav-btn" onclick="goMe();">
				<img src="resource/image/icon-master/nav_me_default.png">
				<br/><span class="f-nav-me">我的</span>
			</div>
		</footer>
        
	</div>
	
    <#include "/WEB-INF/pages/common/share.ftl"/> 
	<script src="plugin/jQuery/jquery.cookie.js"></script>
	<script src="plugin/jQuery/json2.js"></script>
	<script>
		$(function(){
					
			$("input[name=product]").on('click',function(){
				  var currentTotal=$('#total_price').val();
				  var len=$('.m-item').length;
				  var selectedLen=$('input[name=product]:checked').length;
				  if(len==selectedLen){
					  $('#select_all').prop("checked",true);
				  }else{
					  $('#select_all').prop("checked",false);
				  }
				  calTotalPrice();
			});
			 
			$("#select_all").on('click',function(){
				 //全选 重新计算金额总数
				 var inputNode=$('input[name=product]');
				 var len=inputNode.length;
				 for(var i=0;i<len;i++){
					 if($(this).is(":checked")){
						inputNode.eq(i).prop("checked",true);//选中所有input	
					 }else{
					    inputNode.eq(i).prop("checked",false);//取消全选
					 }
				 }
				 calTotalPrice();
			});
			
			$('#balance').click(function(){
			    var balance = parseFloat($("#total_price").text());
			    if(balance<=0){
			    	$.dialog.alert("请先选中要结算的商品");
			    	return false;
			    }
			    //组装选中的商品对象List--序列化为JSON传给后台处理
			     var selectedNode=$('input[name=product]:checked');
			     var arryList=[];
			     for(var i=0;i<selectedNode.length;i++){
                       var mNode=selectedNode.eq(i).parents('.m-item');
                       var productObj=new Object();
                       productObj.product_id=mNode.data('pid');
                       productObj.pf_id=mNode.data('pfid');
                       productObj.product_num=parseInt(mNode.find('.pro-num').text());
                       arryList.push(productObj);
			     }
			     var strList=JSON.stringify(arryList);
			     //console.log(strList);
				 window.location.href="${CONTEXT_PATH}/fruitShop/order?total="+balance+"&selectList="+encodeURIComponent(strList);
			});
			
			$("#select_all").trigger('click');
		});
		
	    //计算总金额
		function calTotalPrice(){
			 var currentTotal=0.00;
			 var selectedNode=$('input[name=product]:checked');
			 var selectedLen=selectedNode.length;
			 
	    	 for(var i=0;i<selectedLen;i++){
	    		 var mNode=selectedNode.eq(i).parents('.m-item');
	    		 var singlePrice=mNode.find('.pro-price').data('price');
	    		 var num=mNode.find('.pro-num').text();
	    		 currentTotal=Number(parseFloat(currentTotal)+parseFloat(singlePrice*num));
	    	 }
	    	 
	    	 $('#total_price').text(currentTotal.toFixed(2));
	    }
		
		//清空购物车
		function clearCart(){
			if($.cookie('xgCartInfo')==null){
				return false;
			}
			$.dialog.message("确认清空购物车吗？", true, function(){
				$.cookie('xgCartInfo',null,{path:"/",expires: -1});
				window.location.reload();
			});
		}
		
		//添加商品到购物车
		function addToCart(productId,pfId){
			var new_historyp="{'product_id':"+productId+",'product_num':1,'pf_id':"+pfId+"}";
			if($.cookie('xgCartInfo')==null){  
				//cookie 不存在  
				new_historyp='['+new_historyp+']';
				$.cookie('xgCartInfo',new_historyp,{expires:15,path:'/'});
				//console.log(new_historyp);
	     	}else{
		          var old_historyp_json=JSON.parse($.cookie('xgCartInfo'));
		          var flag=false,index=0;
		          for(var i=0;i<old_historyp_json.length;i++){
		          	if(old_historyp_json[i].pf_id==pfId){
		          		flag=true;
		          		index=i;
		          		break;
		          	}
		          }
		          if(flag){
		            var num1=$("#total_price").text();
					old_historyp_json[i].product_num=parseInt(old_historyp_json[index].product_num)+1;
					//给显示商品购物车数量加上1
		          	$('#proNum'+pfId).html(old_historyp_json[index].product_num);
		          	//计算总价格
	                calTotalPrice();
		          	//将json对象转换成字符串存cookie
		      		$.cookie('xgCartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
				   }	
	         }
		}
		
		//从购物车删除商品
		function delFromCart(productId,pfId){
			if($.cookie('xgCartInfo')!=null){
		          //将字符串转换成json对象
		          var old_historyp_json=JSON.parse($.cookie('xgCartInfo'));
		          for(var i=0;i<old_historyp_json.length;i++){
			          	if(old_historyp_json[i].pf_id==pfId){
			          		var productNum=parseInt(old_historyp_json[i].product_num);
			          		if(productNum>1){
				          		old_historyp_json[i].product_num=productNum-1;
				          		//给显示商品购物车数量减去1
				          		$('#proNum'+pfId).html(old_historyp_json[i].product_num);
				          		//计算总价格
				          		var currentTotal=$("#total_price").text();
				          		if(parseFloat(currentTotal)>0){
				          			 calTotalPrice();
					          	}
					          	//将json对象转换成字符串存cookie
					            $.cookie('xgCartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
			          		}else{
			          			$.dialog.message("确认删除该商品吗？", true,function(){
			          				old_historyp_json.splice(i, 1);
			          				//将json对象转换成字符串存cookie
			          	          	$.cookie('xgCartInfo',JSON.stringify(old_historyp_json),{expires:15,path:'/'});
			          	          	window.location.reload();
			          			});
			          		}
			          		break;
			          	}
		          }
	         }  
		}
		
		function goHome(){
         	window.location.href = "/weixin/masterIndex/index";
         }
        function  goMall(){
         	window.location.href = "/weixin/mall/shopIndex";
         }
        function goMe(){
         	window.location.href = "/weixin/myself/me";
         }
         function goFresh(){
         	window.location.href = "/weixin/foodFresh/foodFresh?type=1&pageNumber=1&pageSize=4";
         }
        function  goCart(){
         	window.location.href="/weixin/fruitShop/cart";
         }
	</script>
</body>
</html>