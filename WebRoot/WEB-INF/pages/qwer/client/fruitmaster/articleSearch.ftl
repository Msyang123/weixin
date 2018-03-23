<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-文章内容搜索页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">
	<div id="article_search" class="wrapper bg-grey-light">
		 <header class="g-ipt-search bg-white g-hd">
			<div class="u-btn-back">
		         <a href="javascript:void(0);" @click="back">
		         <img height="20px" src="resource/image/icon/icon-back.png" /></a>
		       </div>
		       <div class="u-ipt-search">
		       	<img src="resource/image/icon-master/icon_search.png">
		       	<input type="search" name="master_search" placeholder="请输入文章名/商品名" v-model="keywords">
		       </div>
		       <a class="u-btn-search" @click="goSearch()">搜索</a>
		 </header>
		  
		 <section class="m-tab row justify-content-center align-items-center no-gutters mt48">
		       <div class="col-6 text-center type">
		          <a href="javascript:void(0)" 
		             :class="{active: type=='1'}" 
		             @click.prevent="switchRecord('1',$event)">商品</a>
		        </div>
		       <div class="col-6 text-center type">
		          <a href="javascript:void(0)" 
		            :class="{active: type=='2'}"
		            @click.prevent="switchRecord('2',$event)">文章</a>
		       </div>
		 </section>
		  
		 <section class="m-list-income" v-show="type=='1'">
		  	<div class="article-itm" v-for="item in productList" :key="item.id">
				<img class="bg-img" :src="item.save_string">
				<a class="f-mask u-mask" :href="'${CONTEXT_PATH}/mall/foodDetail?product_id=' + item.id + '&product_fid=' + item.pf_id">
					<p class="itm-tit">{{item.product_name}}</p>
					<p class="itm-text">{{item.description}}</p>
				</a>
			</div>
		 
			 <div class="z-none" v-show="isShow">
				<img src="resource/image/icon-master/expression_sorry.png">
				<p>没有找到您想要的商品哦，去文章看看吧~</p>
			 </div>
		 </section>
		 
		 <section class="m-list-pay" v-show="type=='2'">
			  <div class="article-itm" v-for="item in articleList" :key="item.id">
					<img class="bg-img" :src="item.head_image">
					<a class="f-mask u-mask" :href="'${CONTEXT_PATH}/mall/articleDetail?article_id=' + item.id">
						<p class="itm-tit">{{item.title}}</p>
						<p class="itm-text">{{item.article_intro}}</p>
					</a>
			  </div>
			  <div class="z-none" v-show="isShow1">
					<img src="resource/image/icon-master/expression_sorry.png">
					<p>没有找到您想要的文章哦，去商品看看吧~</p>
			  </div>
		 </section>
		 
		 <div class="z-none" v-show="isShow2">
			<img src="resource/image/icon-master/expression_happy.png">
			<p>快去搜索您想要的商品或文章吧~</p>
		 </div>
	</div>
	
	<script src="plugin/dropload/dropload.min.js"></script>
	<script>
		$(function() {
			var data={
				productList:[],
				articleList:[],
				isActive:true,
				isShow:false,
				isShow1:false,
				isShow2:true,
				keywords:'',
				pageNum:1,
				pageSize:4,
				type:"1",
			};			
			
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory],				
                el:"#article_search",
                data:data,
                computed:{
                	
                },
                filters: {

                },
                methods: {
                    switchRecord:function(type,event){
                        //修改isActive 切换显示列表
                        this.isActive=type=="2"?false:true;
                        this.type=type;
                        this.goSearch();
                    },
                    goSearch:function(){
                    	load.unlock();
                    	$(".dropload-down").show();
                    	$(".dropload-noData").hide();
    	        		var that = this;
    	        		if(that.keywords==""){
                            //$.dialog.alert("请先输入搜索关键字");
                            return false;
        	            }
    	        		that.isShow=false;
    	        		that.isShow1=false;
    	        		that.isShow2=false;
    	        		that.pageNum=1;
    	        		
   	        			$.ajax({
   	  		                type: 'GET',
   	  		                url:'${CONTEXT_PATH}/mall/search',
   	  		           		data:{
   	   	  		           		content:that.keywords,
   	   	  		           		pageNumber:that.pageNum,
   	   	  		           		pageSize:that.pageSize,
   	   	  		           		type:that.type
   	   	  		            },
   	  		                dataType: 'json',
   	  		                success: function(result){
   	  		                	if(that.type=="1"){
   	  		                		that.productList = result.productList;
		   	  		                if(that.productList.length==0){
		  		                	    that.isShow=true;
		  		                	  	$(".dropload-down").hide();
		  		                    }
   	  		                	}else{
   	  		                		that.articleList = result.articleList
		   	  		              	if(that.articleList.length==0){
		 		                	    that.isShow1=true;
		 		                	   	$(".dropload-down").hide();
		 		                   	}
   	  		                    }
   	  		                }
   	  		            });
    	            }
                }
		     });
	
			      //滚动加载
		    var load =  $('.wrapper').dropload({
				        scrollArea : window,
					    autoLoad:false, 
				        distance:50,
				        domDown:{
				        		domClass : 'dropload-down',
					        	domRefresh : '<div class="dropload-refresh"></div>',
					        	domLoad : '<div class="dropload-load">加载中...</div>',
					        	domNoData : '<div class="dropload-noData brand-grey-s">-------------我是有底线的-------------</div>'
			        	},
				        loadDownFn : function(me){
				        	if(vm.keywords==""){
				        		$(".dropload-down").hide();
				        	}
				        	vm.pageNum++;
				        	
	   	        			$.ajax({
	   	  		                type: 'GET',
	   	  		                url:'${CONTEXT_PATH}/mall/search',
	   	  		           		data:{content:vm.keywords,pageNumber:vm.pageNum,pageSize:vm.pageSize,type:vm.type},
	   	  		                dataType: 'json',
	   	  		                success: function(result){
	   	  		                    
	 	  		                	if(vm.type=="1"){
				                		var newList = result.productList;
			  	  		                if(newList.length > 0){
				  	  		                for(var i=0;i<newList.length;i++){
				  	  		                	vm.productList.push(newList[i]);
						                    }
			 		                    }else{
				                    		me.lock();
				                        	me.noData();
				                    	}
			                		}else if(vm.type=="2"){
			                			var newList1 = result.articleList;
			                			
			  	  		                if(newList1.length > 0){
			  	  		                	for(var i=0;i<newList1.length;i++){
			  	  		                		vm.articleList.push(newList1[i]);
						                    }
			 		                    }else{
				                    		me.lock();
				                        	me.noData();
				                    	}
			                    	}
	 	  		                	me.resetload();
	   	  		                },
	  	   	  		            error: function(xhr, type){
	  	                            // 即使加载出错，也得重置
	  	                            me.resetload();
	  	                        }
	   	  		            })
				        }
	  			 }); 
		});
	</script>
</body>
</html>