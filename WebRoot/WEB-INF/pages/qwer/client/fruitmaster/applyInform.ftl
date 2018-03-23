<!DOCTYPE html>
<html>
<head>
<title>美味食鲜-申请反馈</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-鲜果师申请反馈页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>
	<div class="wrapper pd10" id="apply_info">
		<header class="m-apply-banner">
			<img src="resource/image/img-master/upload_banner.png">
		</header>
		
		<section class="m-inform">
			<div class="z-passed"  v-show="status.master_status=='1'">
				<img src="resource/image/icon-master/expression_passed.png">
				<p class="text">
					申请已通过<br/>
					预计1个工作日内与您联系
				</p>
				<p class="phone">
					0731-85240088
				</p>
			</div>
			
			<div class="z-failed" v-show="status.master_status=='2'">
				<img src="resource/image/icon-master/expression_failed.png">
				<p class="text">
					申请失败<br/>
					失败原因：{{status.reason}}
				</p>
				<button type="button" class="btn u-btn-edit btn-lg btn-block" @click="backEditInfo">修改申请信息</button>
			</div>
			
			<div class="z-stopped" v-show="status.master_status=='4'">
				<img src="resource/image/icon-master/expression_stopped.png">
				<p class="text">
					您的鲜果师资格已被停用<br/>
					若有疑问，请咨询客服中心
				</p>
				<p class="phone">
					0731-85240088
				</p>
			</div>
			
			<div class="z-waiting" v-show="status.master_status=='0'">
				<img src="resource/image/icon-master/expression_waitting.png">
				<p class="text">
					您的申请正在审核中<br/>
					预计1-3个工作日内给您回复
				</p>
			</div>
		</section>		
	</div>
	<script>
		$(function(){
		    //实例化vue
			var vm=new Vue({
                el:"#apply_info",
                data:{
                	status:${result}
                },
                computed:{
                },
                filters: {
                },
                methods: {
                	backEditInfo:function(){
                		window.location.href="${CONTEXT_PATH}/fruitMaster/masterDetail?id="+this.status.master_id;
                	} 
                }
		     });
		});
	</script>
</body>
</html>