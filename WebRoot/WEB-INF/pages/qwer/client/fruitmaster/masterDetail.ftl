<!DOCTYPE html>
<html>
<head>
<title>美味食鲜-鲜果师详情</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-鲜果师详情页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body>

	<div id="master_details" class="wrapper s-cpd">
		<div class="btn-circle-back" @click="back">
		<img src="resource/image/icon-master/icon_circle_back.png" width="30"></div>
		
		<div class="card u-card">
		  <img  class="card-img-top" v-bind:src="masterInfo.master_image | formatImg">
		  <div class="card-body">
		    <h4 class="card-title">{{masterInfo.master_name}}</h4>
		    <p class="card-text">{{masterInfo.description}}</p>
		  </div>
		</div>
		
		<div class="u-normal-title">
			原创文章
		</div>
		
		<article>
			<div class="article-itm"  v-for="item in masterInfo.xArticles">
				<img class="bg-img" v-bind:src="item.head_image | formatImg" onerror="common.imgLoadMaster(this)">
				<a class="f-mask u-mask" :href="'${CONTEXT_PATH}/mall/articleDetail?article_id=' + item.article_id">
					<p class="itm-tit">{{item.title}}</p>
					<p class="itm-text">{{item.article_intro}}</p>
				</a>
			</div>
		</article>
		
		<section class="z-none" v-if="masterInfo.xArticles.length==0">
			<img src="resource/image/icon-master/expression_helpless.png" style="margin-top: 30px;">
			<p>暂无文章</p>
		</section>
	</div> 
	
	<script>
		$(function(){
		    //实例化vue
			var vm=new Vue({
				mixins:[backHistory],
		        el:"#master_details",
		        data:{
		        	masterInfo:${masterDetail},
		        },
		        computed:{
		        },
		        filters: {
		        	formatImg:function(value){
                		if (!value) return 'resource/image/icon-master/img-error-big.png';
                	    return value.toString();
                	}
		        },
		        methods: {
		           
		        }
		     });
		});
	</script>
</body>
</html>