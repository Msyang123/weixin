<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-订单详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_order_detail" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>订单详情</span>
		  </header>
		  
		  <div :class="isShowTip?'mt48':'mt58'"></div>
		 
		  <div class="tips marquee" v-if="isShowTip">请您在72小时内完成提货，超出时间将自动取消该订单，按实际支付金额转成等价的鲜果币</div>
		  
		  <section class="m-card">
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4"><h4>订单信息</h4></div>
		          <div class="col-8 order-status brand-red text-right">{{orderObj.status_name}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">订单编号</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.order_id}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">下单时间</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.createtime}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">配送方式</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.delivery_name}}</div>
		      </div> 
		      
		      <template v-if="orderObj.deliverytype==2">
		      <div class="u-cell row no-gutters justify-content-between align-items-center" v-if="isHomeDelivery">
		          <div class="col-4">配送时间</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.deliverytime}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center" v-if="isHomeDelivery">
		          <div class="col-4">送货地址</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.address_detail}}</div>
		      </div> 
		      </template>
		      
		       <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">服务门店</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.store_name}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">支付方式</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.pay_type | formatPaytype}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">订单备注</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.customer_note}}</div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">客户名称</div>
		          <div class="col-8 text-right brand-grey-h">{{orderObj.customer_name}}</div>
		      </div> 
		  </section>
		  
		  <section class="m-card m-card-bt">
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4"><h4>订单信息</h4></div>
		      </div>
		      
		      <!-- 商品列表开始 -->
		      <div class="m-pro-list bg-grey-light"> 
					 <div class="m-item row no-gutters align-items-center" v-for="item in orderObj.productList" :key="item.id">
						<div class="col-4 text-center">
							<img height="80px" :src="item.save_string" onerror="common.imgLoadMaster(this)"/>
						</div>
						<div class="col-6 col-sm-auto pl10">
							<h4>{{item.product_name}}</h4>			
							<h5>{{item.unit_name}}</h5>
							<p class="brand-blue">&yen; {{item.price | formatCurrency}}</p>
						</div>
						<div class="col-2 text-right pr15"><sub>X {{item.product_amount}}</sub></div>
					 </div>	
			  </div>
				
			  <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">共{{orderObj.productList.length}}件商品</div>
		          <div class="col-8 text-right brand-grey-h">总计金额：<span class="brand-blue">&yen; {{orderObj.total | formatCurrency}}</span></div>
		      </div> 
		      
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">优惠金额</div>
		          <div class="col-8 text-right brand-blue">&yen; {{orderObj.discount | formatCurrency}}</div>
		      </div>
		       
		      <div class="u-cell row no-gutters justify-content-between align-items-center">
		          <div class="col-4">应付金额</div>
		          <div class="col-8 text-right brand-blue">&yen; {{orderObj.need_pay | formatCurrency}}</div>
		      </div> 
				
		  </section>
		  
	</div>
	
	<script src="//cdn.jsdelivr.net/jquery.marquee/1.4.0/jquery.marquee.min.js"></script><!--跑马灯效果-->
	<script>
        $(function(){
        	//实例化Vue
        	var data={
               isHomeDelivery:true,
               orderObj:${order_detail}
			};
			
        	var vm=new Vue({
            	    mixins:[backHistory],
				    el:"#my_order_detail",
	                data:data,
	                computed:{
                       isShowTip:function(){
                    	  return this.orderObj.order_status=="3" && this.orderObj.deliverytype=="1";
                    	  //return true;
                       }
	                },
	                filters: {
	                	formatPaytype:function(value){
                              switch(value){
	                              case "1":
	                                  return "线上支付";
	                                  break;
	                              case "2":
	                                  return "货到付款";
                              }
		                },
		                formatCurrency:function(value){
                            return common.formatCurrency(value);
			            }
	                },
	                methods: {
	                }
			 });
			 
            //实例化跑马灯
        	$('.marquee').marquee({
				duration: 8000,
				gap: 60,
				delayBeforeStart: 1,
				direction: 'left',
				duplicated: true
			});
			
        });
	
	</script>
</body>
</html>