<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="page-header">
	<h1>
		操作台
		<small>
			<i class="ace-icon fa fa-angle-double-right"></i>
			每日汇总及预览
		</small>
	</h1>
</div>
<#if orderFailCount gt 0>
	<div class="alert alert-danger alert-message">
		<button type="button" class="close" data-dismiss="alert">
			<i class="ace-icon fa fa-times"></i>
		</button>
        <a href="/weixin/orderManage/initOrderList" class="send-fail"><i class="ace-icon fa fa-exclamation-triangle"></i> 海鼎订单发送失败${orderFailCount}单</a>
	</div>
 </#if>

<div class="table_box">
    <!--销售数据统计-->
	<div class="col-sm-12">
			<div class="widget-box transparent">
				<div class="widget-header widget-header-flat">
					<h4 class="lighter">
						<i class="fa fa-line-chart"></i>
						销售对比
					</h4>

					<div class="widget-toolbar">
					</div>
				</div>

				<div class="widget-body">
					<div class="widget-main padding-4">
						<div id="sales-charts"></div>
					</div><!-- /widget-main -->
				</div><!-- /widget-body -->
			</div><!-- /widget-box -->
		</div>
	</div>
	
	<div class="col-sm-6">
		<div class="widget-box">
			<div class="widget-header widget-header-flat widget-header-small">
				<h5>
					<i class="fa fa-money"></i>
					所有消费
				</h5>
				<div class="widget-toolbar no-border"></div>
			</div>
	
			<div class="widget-body">
				<div class="widget-main">
					<div id="piechart-placeholder"></div>
	
					<div class="hr hr8 hr-double"></div>
	
					<div class="clearfix">
						<#list payStat as x>
							<div class="grid3">
								<span class="grey">
									<i class="icon-pinterest-sign icon-2x red"></i>
									&nbsp;
									<#if x.source_type=='balance'>
										果币
									</#if>
									<#if x.source_type=='order'>
									   	购买
									</#if>
									<#if x.source_type=='present'>
										赠送
									</#if>
									<#if x.source_type=='recharge'>
									           充值
									</#if>
									<#if x.source_type=='give'>
									         赠予
									</#if>
								</span>
								<h4 class="bigger pull-right">${x.total_fee!0}</h4>
							</div>
						</#list>
					</div>
				</div><!-- /widget-main -->
			</div><!-- /widget-body -->
		</div><!-- /widget-box -->
	</div>
	
	<div class="col-sm-6">
		<div class="widget-box">
			<div class="widget-header widget-header-flat widget-header-small">
				<h5>
					<i class="fa fa-money"></i>
					今天消费
				</h5>
	
				<div class="widget-toolbar no-border">
					
				</div>
			</div>
	
			<div class="widget-body">
				<div class="widget-main">
					<div id="piechart-placeholder1"></div>
	
					<div class="hr hr8 hr-double"></div>
	
					<div class="clearfix">
						<#list payStatTody as y>
							<div class="grid3">
								<span class="grey">
									<i class="icon-pinterest-sign icon-2x red"></i>
									&nbsp;
									<#if y.source_type=='balance'>
										果币
									</#if>
									<#if y.source_type=='order'>
									   	购买
									</#if>
									<#if y.source_type=='present'>
										赠送
									</#if>
									<#if y.source_type=='recharge'>
									           充值
									</#if>
									<#if y.source_type=='give'>
									         赠予
									</#if>
								</span>
								<h4 class="bigger pull-right">${y.total_fee!0}</h4>
							</div>
						</#list>
					</div>
				</div><!-- /widget-main -->
			</div><!-- /widget-body -->
		</div><!-- /widget-box -->
	</div>
	
	
	<div class="col-sm-6">
		<div class="widget-box">
			<div class="widget-header widget-header-flat widget-header-small">
				<h5>
					<i class="fa fa-money"></i>
					未消费/已消费比例
				</h5>
	
				<div class="widget-toolbar no-border">
					
				</div>
			</div>
	
			<div class="widget-body">
				<div class="widget-main">
					<div id="piechart-placeholder7"></div>
	
					<div class="hr hr8 hr-double"></div>
	
					<div class="clearfix">
						<div class="grid2">
							<span class="grey">
								<i class="icon-pinterest-sign icon-2x red"></i>
								&nbsp;未消费
							</span>
							<h4 class="bigger pull-right">${xf.wxf/100!0}</h4>
						</div>
						<div class="grid2">
							<span class="grey">
								<i class="icon-pinterest-sign icon-2x red"></i>
								&nbsp;已消费
							</span>
							<h4 class="bigger pull-right">${xf.yxf/100!0}</h4>
						</div>
					</div>
				</div><!-- /widget-main -->
			</div><!-- /widget-body -->
		</div><!-- /widget-box -->
	</div>
	
	<div class="col-sm-6">
		<div class="widget-box">
			<div class="widget-header widget-header-flat widget-header-small">
				<h5>
					<i class="fa fa-paperclip"></i>
					订单类型比例
				</h5>
	
				<div class="widget-toolbar no-border">
					
				</div>
			</div>
	
			<div class="widget-body">
				<div class="widget-main">
					<div id="piechart-placeholder4"></div>
	
					<div class="hr hr8 hr-double"></div>
	
					<div class="clearfix">
						<#list statByType as sbt>
							<div class="grid2">
								<span class="grey">
									<i class="icon-pinterest-sign icon-2x red"></i>
									&nbsp;
									<#if sbt.order_type=='1'>
										正常购买
									<#else>
										仓库提货
									</#if>
								</span>
								<h4 class="bigger pull-right">${sbt.count!0}</h4>
							</div>
						</#list>
					</div>
				</div><!-- /widget-main -->
			</div><!-- /widget-body -->
		</div><!-- /widget-box -->
	</div>
	
	<div class="col-sm-6">
		<div class="widget-box">
			<div class="widget-header widget-header-flat widget-header-small">
				<h5>
					<i class="fa fa-paperclip"></i>
					订单水果排行
				</h5>
	
				<div class="widget-toolbar no-border">
					
				</div>
			</div>
	
			<div class="widget-body">
				<div class="widget-main">
					<div id="piechart-placeholder5"></div>
	
					<div class="hr hr8 hr-double"></div>
	
					<div class="clearfix">
						<#list orderStatByFruitType as osf>
							<div class="grid2">
								<span class="grey">
									<i class="icon-pinterest-sign icon-2x red"></i>
									&nbsp;${osf.product_name!}
								</span>
								<h4 class="bigger pull-right">${osf.amount!0}</h4>
							</div>
						</#list>
					</div>
				</div><!-- /widget-main -->
			</div><!-- /widget-body -->
		</div><!-- /widget-box -->
	</div>
	
	
	
	
</div>

<!--[if !IE]> -->
<script type="text/javascript">
	window.jQuery || document.write("<script src='plugin/ace/assets/js/jquery-2.0.3.min.js'>"+"<"+"script>");
</script>
<!-- <![endif]-->

<!--[if IE]>
<script type="text/javascript">
 window.jQuery || document.write("<script src='plugin/ace/assets/js/jquery-1.10.2.min.js'>"+"<"+"script>");
</script>
<![endif]-->

		<script src="plugin/ace/assets/js/bootstrap.min.js"></script>
		<script src="plugin/ace/assets/js/typeahead-bs2.min.js"></script>

		<!-- page specific plugin scripts -->

		<!--[if lte IE 8]>
		  <script src="plugin/ace/assets/js/excanvas.min.js"></script>
		<![endif]-->

		<script src="plugin/ace/assets/js/jquery-ui-1.10.3.custom.min.js"></script>
		<script src="plugin/ace/assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="plugin/ace/assets/js/jquery.slimscroll.min.js"></script>
		<script src="plugin/ace/assets/js/jquery.easy-pie-chart.min.js"></script>
		<script src="plugin/ace/assets/js/jquery.sparkline.min.js"></script>
		<script src="plugin/ace/assets/js/flot/jquery.flot.min.js"></script>
		<script src="plugin/ace/assets/js/flot/jquery.flot.pie.min.js"></script>
		<script src="plugin/ace/assets/js/flot/jquery.flot.resize.min.js"></script>

		<!-- ace scripts -->


	

		<!-- inline scripts related to this page -->

		<script type="text/javascript">
			jQuery(function($) {
				
			
			  var placeholder = $('#piechart-placeholder').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder1 = $('#piechart-placeholder1').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder2 = $('#piechart-placeholder2').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder3 = $('#piechart-placeholder3').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder4 = $('#piechart-placeholder4').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder5 = $('#piechart-placeholder5').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder6 = $('#piechart-placeholder6').css({'width':'90%' , 'min-height':'150px'});
			  var placeholder7 = $('#piechart-placeholder7').css({'width':'90%' , 'min-height':'150px'});
			  var data = [
			  	<#list payStat as x>
			  		{ label: 
			  		<#if x.source_type=='balance'>
						'果币'
					</#if>
					<#if x.source_type=='order'>
					   	'购买'
					</#if>
					<#if x.source_type=='present'>
						'赠送'
					</#if>
					<#if x.source_type=='recharge'>
					    '充值'
					</#if>
					<#if x.source_type=='give'>
					    '赠予'
					</#if>
					,  data: ${x.total_fee!0},
					color: 
					<#if x.source_type=='balance'>
						'#68BC31'
					</#if>
					<#if x.source_type=='order'>
					   	'#2091CF'
					</#if>
					<#if x.source_type=='present'>
						'#AF4E96'
					</#if>
					<#if x.source_type=='recharge'>
					    '#DA5430'
					</#if>
					<#if x.source_type=='give'>
					    '#FEE074'
					</#if>
					},
				</#list>
			  ];
			  var data1 = [
			  	<#list payStatTody as y>
			  		{ label: 
			  		<#if y.source_type=='balance'>
						'果币'
					</#if>
					<#if y.source_type=='order'>
					   	'购买'
					</#if>
					<#if y.source_type=='present'>
						'赠送'
					</#if>
					<#if y.source_type=='recharge'>
					    '充值'
					</#if>
					<#if y.source_type=='give'>
					    '赠予'
					</#if>
					,  data: ${y.total_fee!0},
					color: 
					<#if y.source_type=='balance'>
						'#68BC31'
					</#if>
					<#if y.source_type=='order'>
					   	'#2091CF'
					</#if>
					<#if y.source_type=='present'>
						'#AF4E96'
					</#if>
					<#if y.source_type=='recharge'>
					    '#DA5430'
					</#if>
					<#if y.source_type=='give'>
					    '#FEE074'
					</#if>
					},
				</#list>
			  ];
			  
			  //颜色数组
			  var colors=new Array('#68BC31','#2091CF','#AF4E96','#DA5430','#FEE074','#90EE90',
			  '#8B0A50','#68228B','#787878','#8B0A50','	#CD0000','#CDAD00','#EED2EE','#FF3030',
			  '#333333','#050505','#0000FF','#2F4F4F','#8470FF','#87CEEB','#8B4726','#8B7B8B',
			  '#8E8E38','#A52A2A','#ADFF2F','#BA55D3','	#C1FFC1','#DB7093','#C1FECF','#31FECF','#C1FEC1');
			  
			  var data4 =[
			  	<#list statByType as sbt>
			  		{ label: 
			  			<#if sbt.order_type=='1'>
							'正常购买'
						<#else>
							'仓库提货'
						</#if>
			  		,  
			  		data: ${sbt.count!0},
					color: colors[${sbt_index}]
					},
				</#list>	
			  ];
			  
			  var data5 =[
			  	<#list orderStatByFruitType as osf>
			  		{ label:'${osf.product_name!}',  
			  		data: ${osf.amount!0},
					color: colors[${osf_index}]
					},
				</#list>	
			  ];
			  
			  var data7 =[
			  	{ label:'未消费',  
			  		data: ${xf.wxf!0},
					color: colors[0]
					},
				{ label:'已消费',  
			  		data: ${xf.yxf!0},
					color: colors[1]
					}		
			  ];
			  

			  
			
			  function drawPieChart(placeholder, data, position) {
			 	  $.plot(placeholder, data, {
					series: {
						pie: {
							show: true,
							tilt:0.8,
							highlight: {
								opacity: 0.25
							},
							stroke: {
								color: '#fff',
								width: 2
							},
							startAngle: 2
						}
					},
					legend: {
						show: true,
						position: position || "ne", 
						labelBoxBorderColor: null,
						margin:[-30,15]
					}
					,
					grid: {
						hoverable: true,
						clickable: true
					}
				 })
			 }
			
			 /**
			 we saved the drawing function and the data to redraw with different position later when switching to RTL mode dynamically
			 so that's not needed actually.
			 */
			 placeholder.data('chart', data);
			 placeholder.data('draw', drawPieChart(placeholder, data));
			 
			 placeholder1.data('chart', data1);
			 placeholder1.data('draw', drawPieChart(placeholder1, data1));
			 
			 placeholder4.data('chart', data4);
			 placeholder4.data('draw', drawPieChart(placeholder4, data4));
			 
			 placeholder5.data('chart', data5);
			 placeholder5.data('draw', drawPieChart(placeholder5, data5));
			 
			 placeholder7.data('chart', data7);
			 placeholder7.data('draw', drawPieChart(placeholder7, data7));
			
			  var $tooltip = $("<div class='tooltip top in'><div class='tooltip-inner'></div></div>").hide().appendTo('body');
			  var previousPoint = null;
			
			  placeholder.on('plothover', function (event, pos, item) {
				if(item) {
					if (previousPoint != item.seriesIndex) {
						previousPoint = item.seriesIndex;
						var tip = item.series['label'] + " : " + item.series['percent']+'%';
						$tooltip.show().children(0).text(tip);
					}
					$tooltip.css({top:pos.pageY + 10, left:pos.pageX + 10});
				} else {
					$tooltip.hide();
					previousPoint = null;
				}
				
			 });
			
			
				
				var d1 = [];
				<#list payStayByTimeMap as p>
					d1.push(['${p.h}', ${p.total_fee}]);
				</#list>
			
				var d2 = [];
				<#list payStayByTimeYesterday as y>
					d2.push(['${y.h}', ${y.total_fee}]);
				</#list>
				
				var d3 = [];
				<#list payStayByAvgTime as a>
					d3.push(['${a.h}', ${a.total_fee}]);
				</#list>
				
			
				var sales_charts = $('#sales-charts').css({'width':'100%' , 'height':'220px'});
				$.plot("#sales-charts", [
					{ label: "今天", data: d1 },
					{ label: "昨天", data: d2 },
					{ label: "平均", data: d3 }
				], {
					hoverable: true,
					shadowSize: 0,
					series: {
						lines: { show: true },
						points: { show: true }
					},
					xaxis: {
						tickLength: 0
					},
					yaxis: {
						ticks: 10,
						min: 0,
						max: 5000,
						tickDecimals: 0
					},
					grid: {
						backgroundColor: { colors: [ "#fff", "#fff" ] },
						borderWidth: 1,
						borderColor:'#555'
					}
				});
			
			
				$('#recent-box [data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('.tab-content')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
			
			
			
			})
		</script>			
			 
</@layout>