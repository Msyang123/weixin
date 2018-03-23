<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-订单管理页" />
<link rel="stylesheet" href="plugin/dropload/dropload.css">
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_order" class="wrapper my-order">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>订单管理</span>
		  </header>

		  <section class="m-tab bordered row justify-content-center align-items-center no-gutters mt48">
		       <div class="col-6 text-center type">
		          <a href="javascript:void(0)" :class="{active: isActive}" @click.prevent="switchType('1',$event)">进行中</a>
		        </div>
		       <div class="col-6 text-center type">
		          <a href="javascript:void(0)" :class="{active: !isActive}" @click.prevent="switchType('5',$event)">已完成</a>
		       </div>
		  </section>
		  
		  <section class="tab m-tab-blue">
				
				<div class="title-list row no-gutters justify-content-center" v-show="isActive">
					<div class="col-3 text-center type" :class="{active: orderObj.status=='1'}" @click="switchType('1',$event)">全部</div>
					<div class="col-3 text-center type" :class="{active: orderObj.status=='2'}" @click="switchType('2',$event)">待付款</div>
					<div class="col-3 text-center type" :class="{active: orderObj.status=='3'}" @click="switchType('3',$event)">待收货</div>
					<div class="col-3 text-center type" :class="{active: orderObj.status=='4'}" @click="switchType('4',$event)">退货</div>
				</div>
				
				<div class="product-wrap" v-show="isShow" v-cloak>
					
					<div class="product" v-for="item in orderObj.orderList" 
					:key="item.order_id" @click="goOrderDetail(item.id)">
					
						<div class="pro-status bg-white">
							<div class="float-left">编号：{{item.order_id}}</div>
							<div class="float-right orderstatus">{{item.status_name}}</div>
						</div>
						
						<div class="pro-detail-box swiper-container">
							<div class="swiper-wrapper">
								 <div class="swiper-slide" v-for="pro in item.orderProducts" :key="pro.id">
								    <img :src="pro.save_string" onerror="common.imgLoad(this)"/>
								</div> 
	                             <div class="swiper-scrollbar"></div>
	                        </div>
						</div>
						
						<div class="row no-gutters justify-content-between align-items-center total-box bg-white">
							<div class="col-6 total-num">
								共{{item.totalProduct}}件商品
							</div>
							<div class="col-6 text-right">
								<p class="total-price">合计： <span>&yen; {{item.total | formatCurrency}}</span></p>		
							</div>
	                    </div>
					</div><!--/End all-orders-->
			    
			    </div><!--/End m-list-orders-->
			    
		     	<div class="m-empty-box text-center" v-show="!isShow">
			       <img src="resource/image/icon-master/order_empty.png" height="175"/>
			       <p>暂无任何订单</p>
			    </div>
		  </section>
    </div>
    
    <script src="plugin/dropload/dropload.min.js"></script>	
	<script>
			$(function() {
				var vm=new Vue({
					mixins:[backHistory,formatCurrency],
	                el:"#my_order",
	                data:{
	 				   orderObj:${orders},
	                   isActive:true,
	                   pageNum:1,
	                   pageSize:4
				    },
		            created:function(){
                        this.$nextTick(function () {
                      	   this.getOrderList(this.orderObj.status,this.orderObj.master_id,1,4);
                        });
		            },
		            updated:function(){
		            	initSwiper();
			        },
	                computed:{
		                isShow:{
                            get:function(){
                                return this.orderObj.orderList.length>0;
                            },
                            set:function(newValue){
                                if(!newValue) return false;
                                return newValue;
                            }
			            }
	                },
	                filters: {
	                },
	                methods: {
	                    switchType:function(status,event){
	                    	//修改isActive 是否显示过滤栏
	                        this.isActive=status=="5"?false:true;
	                        this.orderObj.status=status;
	                        this.pageNum=1;
	                        this.isShow=true;
	                        dropIns.unlock();
	                        dropIns.resetload();
	                    	//发送请求回后台 刷新数据更新DataList
	                        this.getOrderList(status,this.orderObj.master_id,1,4);
		                },         
		                getOrderList:function(status,masterId,pageNum,pageSize){
                             var _this=this;
 				        	//根据当前菜单类型和当前页码获取orderList
 		                    axios.get("${CONTEXT_PATH}/fruitMaster/masterOrdersAjax",
 				            {
 		                		params: {
 		                			status: status,
 		                			master_id: masterId,
 		                			pageNumber:pageNum,
 		                			pageSize: pageSize
 		                		}
 		                	}).then(function(response){
 		                		
 		                		var arrLen = response.data.orderList.length;

 		                		if(arrLen==0){
                                    _this.isShow=false;
 	 			                }
 	 			                
 		                		if(arrLen >= 0){
                                    //切换status=切换显示 列表
                                    _this.orderObj.orderList=response.data.orderList;
 			                    }
 			                    
 		                	}).catch(function(error){
 			                    console.log(error);
 		                	});
			            },
			            goOrderDetail:function(order_id){
                            window.location.href="${CONTEXT_PATH}/fruitMaster/masterOrderDetail?order_id="+order_id;
				        }
	                }
			     });

				 //滚动加载
               var dropIns=$('.wrapper').dropload({
				        scrollArea : window,
				        autoLoad:false,
				        distance:50,
				        domDown:{
				        	domClass : 'dropload-down',
				        	domRefresh : '<div class="dropload-refresh"></div>',
				        	domLoad : '<div class="dropload-load">加载中...</div>',
				        	domNoData : '<div class="dropload-noData">-------------我是有底线的-------------</div>'
			        	},
				        loadDownFn : function(me){
				        	vm.pageNum++;
				        	//根据当前菜单类型和当前页码获取orderList
		                    axios.get("${CONTEXT_PATH}/fruitMaster/masterOrdersAjax",
				            {
		                		params: {
		                			status: vm.orderObj.status,
		                			master_id: vm.orderObj.master_id,
		                			pageNumber:vm.pageNum,
		                			pageSize: vm.pageSize
		                		}
		                	}).then(function(response){
		                		
		                		var orderList=response.data.orderList;
		                		var arrLen = orderList.length;
		                		if(arrLen > 0){
			                		for(var i=0;i<arrLen;i++){
			                			vm.orderObj.orderList.push(orderList[i]);
				                    }
			                    }else{
			                    	dropIns.lock();
			                    	dropIns.noData();
				                }
		                		dropIns.resetload();
		                	}).catch(function(error){
		                	    // 即使加载出错，也得重置
			                    dropIns.resetload();
		                	}); 
				        }
				 }); 
				 
                 initSwiper();
			});

			function initSwiper(){
				var swiper = new Swiper('.swiper-container', {
				    pagination : '.swiper-pagination',
				    paginationClickable:false,
			        scrollbarHide: true,
			        slidesPerView: 4,
			        slidesPerGroup:4,
			        centeredSlides: false,
			        spaceBetween: 10,
			        grabCursor: true,
			        setWrapperSize :false,
			        slidesOffsetBefore:0,
			        breakpoints: { 
					    //当宽度小于等于320
					    320: {
					      slidesPerView: 4,
					      slidesPerGroup:4,
					      spaceBetweenSlides: 5
					    },
					    //当宽度小于等于376
					    375: { 
					      slidesPerView: 4,
					      slidesPerGroup:4,
					      spaceBetweenSlides: 10
					    },
					   //当宽度小于等于415
					    414: { 
					      slidesPerView: 5,
					      slidesPerGroup:5,
					      spaceBetweenSlides: 10
					    },
					     //当宽度小于等于415
					    480: { 
					      slidesPerView: 6,
					      slidesPerGroup:6,
					      spaceBetweenSlides: 10
					    },
					    //当宽度小于等于640
					    640: {
					      slidesPerView: 6,
					      slidesPerGroup:6,
					      spaceBetweenSlides: 20
				        }
				     }
			    });
			}
    </script>
</body>
</html>