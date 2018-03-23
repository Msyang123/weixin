<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-收支明细页" />
<link rel="stylesheet" href="plugin/dropload/dropload.css">
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="salary_record" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>收支明细</span>
		  </header>
		  
		  <section class="m-tab row justify-content-center align-items-center no-gutters mt48">
		       <div class="col-6 text-center type">
		          <a href="javascript:void(0)" 
		             :class="{active: isActive}" 
		             @click.prevent="switchRecord('1',$event)">收入</a>
		        </div>
		       <div class="col-6 text-center type">
		          <a href="javascript:void(0)" 
		            :class="{active: !isActive}"
		            @click.prevent="switchRecord('2',$event)">支出</a>
		       </div>
		  </section>
		  
		  <section class="m-list-area mt15">
		       <div class="m-list-income m-list-pay" v-show="!isShow" v-cloak>
			       <div class="m-item" v-for="(item,index) in recordList" :key="item.id">
				       <div class="timespan">{{item.time}}</div>
				       <div class="u-white-box row no-gutters justify-content-around align-items-center">
				           <div class="col-9 u-box-l">
					           <p>
					               <span v-if="item.type=='1' || item.type=='2'">收入类型：</span>
						           <span v-else>支出类型：</span>
						           {{item.type | formatType}}
					           </p>
					           <p v-if="item.type=='1' || item.type=='4'">
					           <span>订单编号：</span>{{item.order_id}}</p>
				           </div>
				           <div class="col-3 js-profit text-right" :class="{'brand-blue': item.type=='3' || item.type=='4'}">
				           <span v-if="item.type=='1' || item.type=='2'">+</span>
				           <span v-if="item.type=='3' || item.type=='4'">-</span>
				           {{item.money | formatCurrency}}</div>
				       </div>
			       </div>  
		       </div>
		       
		       <div class="z-none" v-show="isShow">
					<img src="resource/image/icon-master/expression_sorry.png">
					<p>没有找到相关历史记录哦~</p>
		       </div>
		  </section>
		  
		 
	</div>
	
	<script src="plugin/dropload/dropload.min.js"></script>	
	<script>
		$(function() {
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatCurrency],
                el:"#salary_record",
                data:{
    			    recordList:${recordArr},
    			    master_id:${master_id},
    				isActive:true,
    				isShow:false,
    				pageNum:1,
                    pageSize:5,
                    inoutType:'1'
    			},
                created:function(){
                	this.$nextTick(function () {
                	   this.getRecordList(this.inoutType,this.master_id,1,5);
                	});
                },
                filters: {
                	formatType:function(value){
                    	if(!value) return "N/A";
                        switch(value){
	                        case "1":
	                            return "订单分成";
	                            break;
	                        case "2":
	                            return "分销商红利";
	                            break;
		                	case "3":
		                         return "红利结算";
		                         break;
			                case "4":
			                    return "客户退款";
			                    break;
                       }
                	}
                },
                methods: {
                    switchRecord:function(type,event){
                        //修改isActive 切换显示列表
                        this.isActive=type=="1"?true:false;
                        this.inoutType=type=="1"?"1":"2";
                        this.pageNum=1;
	                    dropInstance.unlock();
	                    dropInstance.resetload();
                        this.getRecordList(this.inoutType,this.master_id,1,5);
                    },
                    getRecordList:function(type,masterId,pageNum,pageSize){
                    	    var _this=this;
                    	    //根据当前菜单类型和当前页码获取List
		                    axios.get("${CONTEXT_PATH}/fruitMaster/inOutDetailAjax",
				            {
		                		params: {
		                			inout_type: type,
		                			master_id: masterId,
		                			pageNumber:pageNum,
		                			pageSize: pageSize
		                		}
		                	}).then(function(response){
		                		var arrLen = response.data.length;
		                		
		                		if(arrLen==0){
	 		                		_this.isShow=true;
	 		                    }else{
	 		                    	_this.isShow=false;
		 		                }
	 		                    
		                		if(arrLen >= 0){
                                   _this.recordList=response.data;
			                    }
   		                        
		                	}).catch(function(error){
			                    console.log(error);
		                	});
                    }
                }
		     });
		     
			//滚动加载
            var dropInstance=$('.wrapper').dropload({
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
			        	
			        	//根据当前菜单类型和当前页码获取List
	                    axios.get("${CONTEXT_PATH}/fruitMaster/inOutDetailAjax",
			            {
	                		params: {
	                			inout_type: vm.inoutType,
	                			master_id: vm.master_id,
	                			pageNumber:vm.pageNum,
	                			pageSize: vm.pageSize
	                		}
	                	}).then(function(response){
	                		console.log(response.data);
	                		var recordList=response.data;
	                		var arrLen = recordList.length;
	                		
	                		if(arrLen > 0){
		                		for(var i=0;i<arrLen;i++){
		                			vm.recordList.push(recordList[i]);
			                    }
		                    }else{
		                    	dropInstance.lock();
		                    	dropInstance.noData();
		                    	vm.isShow=false;
			                }
	                		dropInstance.resetload();
	                	}).catch(function(error){
	                	    // 即使加载出错，也得重置
		                    dropInstance.resetload();
	                	}); 
			        }
			 }); 
		});
	</script>
</body>
</html>