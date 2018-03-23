<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-鲜果师搜索页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="master_search" class="wrapper">
		<header class="g-ipt-search bg-white g-hd">
			<div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <div class="u-ipt-search">
	        	<img src="resource/image/icon-master/icon_search.png">
	        	<input type="search" id="search_keyword" placeholder="请输入鲜果师名称" v-model="keywords">
	        </div>
	        <a class="u-btn-search" v-on:click="searchMaster">搜索</a>
		</header>
		
		<section class="m-m-search-list">
				<div class="master-itm row bg-white s-shadow2 no-gutters" v-for="item in masterList">
					<div class="itm-img col-3">
						<img v-bind:src="item.head_image | formatImg">
					</div>
					<div class="itm-info col">
						<p class="s-info-name">{{item.master_name}}</p>
						<p class="s-info-level">{{item.master_nc}}</p>
					</div>
					<div class="itm-btn col">
				        <a class="btn u-btn-brown2" :href="'${CONTEXT_PATH}/masterIndex/masterDetail?master_id=' + item.id ">了解详情</a>
				    </div>
				</div>
		</section>
		
		<section class="z-none" v-if="masterList.length==0">
			<img src="resource/image/icon-master/expression_sorry.png">
			<p>抱歉，没有找到这位鲜果师哦</p>
		</section>
		
		<div class="z-none" v-show="isShow">
				<img src="resource/image/icon-master/expression_happy.png">
				<p>快去 搜索鲜果师吧~</p>
		  </div>
	</div>
	<script src="plugin/dropload/dropload.min.js"></script>
	<script>
		$(function(){
		    //实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatHead],	
		        el:"#master_search",
		        data:{
		        	isShow:true,	        	
		        	keywords:'',
		        	masterList:{},
					pageNum:1,
					pageSize:5,
		        },
		        methods: {
		        	searchMaster:function(){
		        		var that = this;
		        		var keywords= this.keywords;
		        		that.pageNum = 1;
		        		that.isShow=false;
		        		$(".dropload-down").remove();
	        			$.ajax({
   	  		                type: 'GET',
   	  		                url:'${CONTEXT_PATH}/masterIndex/searchMasterList',
   	  		           		data:{keywords:keywords,pageNumber:that.pageNum,pageSize:that.pageSize},
   	  		                dataType: 'json',
   	  		                success: function(data){
   	  		               		that.masterList = data;
   	  		               		if(that.masterList.length > 0){
   	        				 		//滚动加载
   		                    		$('.wrapper').dropload({
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
	   		        				        	that.pageNum++;
	   		        	   	        			$.ajax({
	   		        	   	  		                type: 'GET',
	   		        	   	  		                url:'${CONTEXT_PATH}/masterIndex/searchMasterList',
	   		        	   	  		           		data:{keywords:that.keywords,pageNumber:that.pageNum,pageSize:that.pageSize},
	   		        	   	  		                dataType: 'json',
	   		        	   	  		                success: function(data){
	   		        	   	  		             	  var masterList=data;
	   		        	   	  		              	  var arrLen = masterList.length;
	   		        	   	  		              	  if(arrLen > 0){
	   		        				                		for(var i=0;i<arrLen;i++){
	   		        				                			that.masterList.push(masterList[i]);
	   		        					                    }
	   		        				                  }else{
	   		        				                        me.lock();
	   		        				                        me.noData();
	   		        					              }
	   		        	   	  		              	  
	   		        			                	  setTimeout(function(){
	   		        		                                me.resetload();
	   		        			                	  },1000);
	   		        	   	  		                },
	   			        	   	  		           error: function(xhr, type){
	   			        	                            // 即使加载出错，也得重置
	   			        	                            me.resetload();
	   			        	                        }
	   		        	   	  		            })
	   		        				        }
	   		        				 	}); 
   	        			     		}
   	  		                	}
   	  		            	});
		            	}
		        	}
		     });
		});
	</script>
</body>
</html>
