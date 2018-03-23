<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-鲜果师业绩统计页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="master_statistic" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>业绩统计</span>
	    </header>
	    
	    <div class="btn-group m-btn-group s-shadow2" role="group" aria-label="Basic example">
  			<button type="button" class="u-group-btn" :class="{'s-orange': statisticObj.days=='2'}" @click="selectDays(2)">昨天</button>
  			<button type="button" class="u-group-btn" :class="{'s-orange': statisticObj.days=='7'}" @click="selectDays(7)">7天</button>
  			<button type="button" class="u-group-btn" :class="{'s-orange': statisticObj.days=='30'}" @click="selectDays(30)">30天</button>
  			<button type="button" class="u-group-btn" :class="{'s-orange': statisticObj.days=='90'}" @click="selectDays(90)">90天</button>
  		</div>
  		
  		<div class="m-tab-content">
  			<div id="sales_chart" class="bg-white t-tab-itm"></div>
  		</div>
  		
  		<div class="m-total s-shadow2 bg-white">
  			<p>{{statisticObj.days | formatDay}}订单成交总数<span>{{statisticObj.order_count}} 单</span></p>
  			<p class="s-bdc-tb">{{statisticObj.days | formatDay}}产生总销售额<span>&yen; {{statisticObj.order_total | formatCurrency}}</span></p>
  			<p>{{statisticObj.days | formatDay}}产生实际收入<span>&yen; {{statisticObj.bonus | formatCurrency}}</span></p>
  		</div>
  		
	</div>   

	<script>
	$(function(){
		
		var data={
	       	statisticObj:${orders},
	       	salesChartObj:{},
	       	orderTime:[],
	       	orderCount:[],
	       	orderTotal:[]
	    };
		
		//实例化vue
		var vm=new Vue({
			mixins:[backHistory,formatCurrency],
	        el:"#master_statistic",
	        data:data,
	        mounted:function() {
	       	    this.setEchart();
	       	},
	        updated:function() {
		        if (!this.salesChartObj) {
	       	      this.setEchart();
	       	    }
	       	    this.chartChange();
	       	},
	        computed:{
	        	origin:function(){       		  
	        		return this.data;
	            },
	            salesOpt:function(){
	                   var that=this;
		       		   var obj={
		       	        tooltip: {
		       		        trigger: 'item',
		       		        formatter: '{a} <br/>{b} : {c}'
		       		    },
		       		    legend: {
		       				show:'true',		    	
		       				type:'scroll',		    		
		       		        left: 'left',
		       		        data: ['订单成交数','销售额']
		       		    },
		       		    xAxis: {
		       		        type: 'category',
		       		        name: 'x',
		       		        splitLine: {show: false},
		       		        data:that.orderTime,
		       		        itemStyle: {
		    	                normal: {
		    	                    color: '#21c4c6'
		    	                }
		    	            }
		       		    },
		       		    grid: {
		       		        left: '3%',
		       		        right: '4%',
		       		        bottom: '3%',
		       		        containLabel: true
		       		    },
		       		    yAxis: {
		       		        type: 'value',
		       		        name: 'y',
		       		        itemStyle: {
		       		                normal: {
		       		                    color: '#0083cb'
		       		                }
		       		            }
		       		    },
		       		    series: [
		       		        {
		       		            name: '订单成交数',
		       		            type: 'line',
		       		            data:that.orderCount,
		       		            symbolSize:10,
		       		            itemStyle: {
		       		                normal: {
		       		                    color: '#21c4c6'
		       		                }
		       		            }
		       		        },
		       		        {
		       		            name: '销售额',
		       		            type: 'line',
		       		            data:that.orderTotal,
		       		            symbolSize:10,
		       		            itemStyle: {
		       		                normal: {
		       		                    color: '#ab96d9'
		       		                }
		       		            }
		       		        }
		       		    ]
		       		}//End obj
		       		return obj;
			     }
	        },
	        filters: {
	        	formatDay:function(value){
	            	 if(!value) return "N/A";
	                 switch(value){
		                 case 2:
		                     return "昨天";
		                 case 7:
		                     return "7天";
		                 case 30:
			                 return "30天";
		                 case 90:
		                     return "90天";
	                 }
	            }
	        },
	        methods: {
	        	setEchart:function() {
	       		   var dom = document.getElementById("sales_chart");
	       		   this.salesChartObj = echarts.init(dom);
	       		   this.prepareData();
	       		   this.salesChartObj.setOption(this.salesOpt);
	            },
	        	selectDays:function(days){
	        		var that = this;
	        		that.statisticObj.days=days;
	        		$.ajax({
	                      type: 'GET',
	                      url:'${CONTEXT_PATH}/fruitMaster/achievementAjax?master_id='+this.statisticObj.master_id+'&days='+days,
	                      success: function(data){
	                           that.statisticObj = data;
	                           that.prepareData();
	                      }
	                });
	        	},
	        	chartChange:function(){
	        		 this.salesChartObj.setOption(this.salesOpt);
	            },
	            prepareData:function(){
	                   var that=this;
		               var orderTime = [];
		 	   		   var orderCount = [];
		 	   		   var orderTotal = [];
		 	   		   var orderList =that.statisticObj.order_list;  
		          	
		 	            for(var i=0;i<orderList.length;i++){
		 	           		orderTime.push(orderList[i].time);
		 	           		orderCount.push(orderList[i].count);
		 	           		orderTotal.push((orderList[i].total/100).toFixed(2));
		 	            }
		 	           that.orderTime=orderTime;
		 	           that.orderCount=orderCount;
		 	           that.orderTotal=orderTotal;  
	            }
	        }
	     });
	
	});
	
	</script>
</body>
</html>