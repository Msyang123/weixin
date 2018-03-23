<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-订单" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" class="my-cost">
		<div>
			<div class="orderhead">
				<div class="btn-back"><a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a></div>
				<div>我的钱途</div>
			</div>
		</div>
		<div data-role="main">
			<div style="height:40px;">
			</div>
			<div id="testbar"></div>
		</div>
	</div>
	
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/echarts/echarts.simple.min.js"></script>
	<script type="text/javascript">
		// 基于准备好的dom，初始化echarts实例
		var myChart = echarts.init(document.getElementById('testbar'));
		$("#testbar").css("width",document.body.clientWidth);
		// 指定图表的配置项和数据
		option = {
		    title : {
		        text: '今年消费记录',
		        subtext: '单位/元',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        triggerOn:'click',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: '20',
		        top:'20',
		        data: ['1月','2月','3月','4月','5月']
		    },
		    series : [
		        {
		            name: '访问来源',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
		                {value:335, name:'1月'},
		                {value:310, name:'2月'},
		                {value:234, name:'3月'},
		                {value:135, name:'4月'},
		                {value:1548, name:'5月'}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		myChart.setOption(option);
		
		function back(){
			window.location.href="${CONTEXT_PATH}/main?index=2";
		}
	</script>
</body>
</html>