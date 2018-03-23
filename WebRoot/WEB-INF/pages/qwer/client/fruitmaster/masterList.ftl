<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-鲜果师列表页" />
<link rel="stylesheet" href="plugin/dropload/dropload.css">
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="master_list" class="wrapper">
		<header class="g-hd bg-white">
	        <div class="u-btn-back">
	          <a href="javascript:void(0);" onclick="back();">
	          <img height="20px" src="resource/image/icon/icon-back.png" /></a>
	        </div>
	        <span>鲜果师列表</span>
	    </header>
	    
	    <div class="m-search mt48">
	    	<a class="u-search bg-white" onclick="masterListSearch();">
				<i><img src="resource/image/icon-master/icon_search.png"></i>
				请输入鲜果师的名称
			</a>
	    </div>
	    
	    <section class="m-master-list row">
	         <#list data.masterList as item>
	         <a href="${CONTEXT_PATH}/masterIndex/masterDetail?master_id=${item.id}" class="col-6 master-itm">
		    		<i><img src="${item.head_image!'resource/image/icon-master/default_icon.png'}" onerror="common.imgLoadHead(this)"></i>
		    		<div class="master-itm-mask">
		    			<p class="master-itm-name">${item.master_name!}</p>
		    			<p class="master-itm-level">${item.master_nc!}</p>
		    		</div>
		     </a>
	         </#list>
	    </section>
	</div>   
	
	<script src="plugin/dropload/dropload.min.js"></script>	
	<script>
		$(function() {
			// 页数
		    var page = 1;
		    // 每页展示8个
		    var size = 8;
		    // dropload
		    $('.wrapper').dropload({
		        scrollArea : window,
		        domDown:{
	        		domClass : 'dropload-down',
		        	domRefresh : '<div class="dropload-refresh"></div>',
		        	domLoad : '<div class="dropload-load">加载中...</div>',
		        	domNoData : '<div class="dropload-noData brand-grey-s">-------------我是有底线的-------------</div>'
        		},
		        loadDownFn : function(me){
		        	 // 拼接HTML
		            var result = '';
		        	page++;
		        	
		            $.ajax({
		                type: 'GET',
		                url:'${CONTEXT_PATH}/masterIndex/LoadDetail',
		                data:{page:page,size:size},
		                dataType: 'json',
		                success: function(data){
		                   
		                    var arrLen = data.masterList.length;
		                    if(arrLen > 0){
		                        for(var i=0; i<arrLen; i++){
		                        	var headImg = data.masterList[i].head_image;
		                        	headImg = 'undefined' ? 'resource/image/icon-master/default_icon.png':data.masterList[i].head_image;
	                            result += '<a class="col-6 master-itm" href="${CONTEXT_PATH}/masterIndex/masterDetail?master_id='+data.masterList[i].id+'"><i><img src="'+headImg+'"></i>'
	                                            +'<div class="master-itm-mask"><p class="master-itm-name">'+data.masterList[i].master_name+'</p>'
	                                            +'<p class="master-itm-level">'+data.masterList[i].master_nc+'</p>'
	                                       		+'</div></a>';
		                        }
		                    // 如果没有数据
		                    }else{
		                        // 锁定
		                        me.lock();
		                        // 无数据
		                        me.noData();
		                    }
		                    // 为了测试，延迟1秒加载
	                        setTimeout(function(){
	                            // 插入数据到页面，放到最后面
	                               $('.m-master-list').append(result);
	                            // 每次数据插入，必须重置
	                            me.resetload();
	                        },1000);
		                },
		                error: function(xhr, type){
		                    // 即使加载出错，也得重置
		                    me.resetload();
		                }
		            });
		        }
		    }); 
	    })
	    
		function masterListSearch(){
			window.location.href = "${CONTEXT_PATH}/masterIndex/masterSearch";
		}
		
		function back(){
			window.history.back();
		}
	</script>	
</body>
</html>
