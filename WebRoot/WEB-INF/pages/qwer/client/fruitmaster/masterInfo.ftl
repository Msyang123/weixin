<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-个人信息页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="master_info" class="wrapper">
	
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" @click="back"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>个人信息</span>
	    </header>
	    
	    <section class="g-master-info bg-white s-shadow2">
			<h3>个人简介</h3>
			<div class="row no-gutters m-info">
				<div class="col-4 info-img">
					<!-- <img src="resource/image/img-master/index_portrait.png"> -->
					<div id="view" :style="{backgroundImage:'url('+ masterInfo.head_image +')'}"></div>
					<a>变更</a>
					<input type="file" id="file" style="opacity: 0;">
					<input type="hidden" id="newImg"/>
				</div>
				<div class="col info-text" v-cloak>
					<p>{{masterInfo.master_name}}</p>
					<p>{{masterInfo.master_nc}}</p>
				</div>
			</div>
			
			<form class="edit-introduce">
				<textarea rows="5" id="masterDesc" oninput="common.reExpression()">{{masterInfo.description}}</textarea>
				<a @click="editDesc" class="s-btn-brown">修改</a>
			</form>	    
	    </section>
	    
	    <a class="bg-white go-statistics" :href="'${CONTEXT_PATH}/fruitMaster/achievement?days=7&master_id=' + masterInfo.id ">
	    	业绩统计
	    	<i><img src="resource/image/icon-master/icon_more_single.png" height="20px;"></i>
	    </a>
	</div> 

	<div class="modal" id="exampleModal">
		  <div class="modal-dialog" role="document" style="margin-top:20%;">
			    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title">截取头像</h5>
				        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				        </button>
				      </div>
				      <div class="modal-body">
							<div id="clipArea" style="width: 100%; height: 300px;"></div>	        
				      </div>
				      <div class="modal-footer">
				        <button type="button" class="btn s-btn-brown" id="clipBtn">截取</button>
				      </div>
			    </div>
		  </div>
	</div>

	<script src="plugin/photoClip/iscroll-zoom.js"></script>
	<script src="plugin/photoClip/hammer.min.js"></script>
	<script src="plugin/photoClip/lrz.all.bundle.js"></script>
	<script src="plugin/photoClip/PhotoClip.js"></script> 
	<script type="text/javascript">
		$(function () {
			//实例化vue
			var vm=new Vue({
				mixins:[backHistory,formatHead],
		        el:"#master_info",
		        data:
		        	{
			        	masterInfo:${masterInfo},
		        	},
		        created: function () {
		        		var headImg = this.masterInfo.head_image==''?'resource/image/icon-master/default_icon.png':this.masterInfo.head_image;
		        		this.masterInfo.head_image = headImg;
		        },
		        computed:{
		        	
		        },
		        filters: {
		        	formatImg:function(value){
	            		if (!value) return 'resource/image/icon/default_icon.png';//暂时用这张图
	            	    return value.toString();
	            	}
		        },
		        methods: {
		        	editDesc:function(){
		        		var that = this;
		        		var masterId = this.masterInfo.id;
		        		var description = $("#masterDesc").val();
		        			$.ajax({
					            type: "POST",
					            data:{
					            	master_id:masterId,
					            	description:description	
				 	            	},
				 	            url: "${CONTEXT_PATH}/fruitmaster/updateMasterDescription",
					            dataType: "json",
					            success: function(data){
					            	$.dialog.alert(data.msg);
					            	setTimeout(function(){
					            			window.location=document.referrer;
									},3000);
					            }
					        });
		        	},
		        }
			 });
			 
			var pc = new PhotoClip('#clipArea', {
				size: 260,
				outputSize: 640,
				//adaptive: ['60%', '80%'],
				file: '#file',
				view: '#view',
				ok: '#clipBtn',
				//img: 'img/mm.jpg',
				loadStart: function() {
					//console.log('开始读取照片');
				},
				loadComplete: function() {
					$('#exampleModal').modal('show');
				},
				done: function(dataURL) {
					$('#exampleModal').modal('hide');
					$('#newImg').val(dataURL);
					var masterId =vm.masterInfo.id;
					$.ajax({
			            type: "POST",
			            data:{
			            	master_id:masterId,
			            	head_image:dataURL	
		 	            	},
		 	            url: "${CONTEXT_PATH}/fruitmaster/updateMasterPhoto",
			            dataType: "json",
			            success: function(data){
			            	$.dialog.alert(data.msg);
			            }
			        });
				},
				fail: function(msg) {
					$.dialog.alert(msg);
				}
			});
		});  
	</script>
</body>
</html>