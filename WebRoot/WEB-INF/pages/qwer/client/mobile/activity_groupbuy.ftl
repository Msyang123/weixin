<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-团购活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
    <div data-role="page" class="group-buy bg-white mt41">
    
    	<div data-role="main">
			<div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>   
			    </div>
			    <div>拼团</div>
			    <div class="rules"><a href="javascript:void(0);" class="brand-red" data-target="#activity_rules" data-toggle="modal">活动规则</a></div>
             </div>
               
           <div data-role="main" class="group-buy-content">
               <div class="see-mine" onclick="seeMyGroup();">去看看我的拼团清单 <i class="fa fa-angle-double-right"></i></div> 
               <div class="banners img-responsive">
               		<img src="${image.save_string}" style="width:100%">
               </div>
               
               <div class="products-list">
                    <h4>商品清单</h4>
                    <#list teamDetial as item>
	                    <div class="row no-gutters justify-content-center pro-item">
	                        <div class="col-4"><img src="${item.save_string}" class="img-responsive" height="86"/></div>
	                        <div class="col-8 text-left">
	                             <div class="pro-name">${item.product_name!} &nbsp;<span class="pro-standard">约${item.product_amount!0}${item.base_unitname!}/${item.unit_name!}</span></div>
	                             <div class="group-num">已拼团 <span>${item.total!0}</span> 件</div>
	                             <div class="pro-price row no-gutters justify-content-start">
	                                 <span class="pro-price-num col-7">￥${(item.min_price_reduce)/100}</span>
	                                 <button class="btn-custom btn-groups col-4"  data-id="${item.activity_product_id}">去开团</button>
	                             </div>
	                        </div>
	                    </div>
                    </#list>
                </div>
           </div>
         </div>
    </div>
    
	<div class="modal fade" id="activity_rules" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <h3 class="modal-title brand-red text-center" style="padding-bottom: 5px;border-bottom:1px solid #eeeded;">活动规则</h3>
	            <div class="modal-body text-left">
	            	${actResult.content}
	            </div>
	        </div>
	    </div>
	</div><!--/End activity_rules-->
			
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/location.js"></script>
	<script type="text/javascript">
	    $(function(){
	     	$('.btn-groups').on('click',function(){
	     	      var activityProductId=$(this).data('id');
	     	      window.location.href="${CONTEXT_PATH}/activity/groupGoodsInfo?id="+activityProductId;
	     	});
	     	
	     	$('.pro-item').on('click',function(){
	     	      var activityProductId=$(this).find('.btn-groups').data('id');
	     	      window.location.href="${CONTEXT_PATH}/activity/groupGoodsInfo?id="+activityProductId;
	     	});
		});
		
		function back(){
	 		window.location.href="${CONTEXT_PATH}/main?index=0";
	 	}
	 	
	 	function seeMyGroup(){
	 		window.location.href="${CONTEXT_PATH}/activity/myGroup";
	 	}
	 	
	    //发送Ajax去请求与路径相匹配的分享模板
		$.ajax({
		    type:'Get',
			url: "${CONTEXT_PATH}/share",
		    success: function(result){
		          if(result){		          
		               var link=window.location.href;
		               var imgUrl=result.share.picture?'${app_domain}'+result.share.picture.replace("/weixin",""):
		               '${app_domain}/resource/image/logo/shuiguoshullogo.png';
		               var title=result.share.title;
		               var desc=result.share.content;
		               
		               console.log(title+'\r\n'+desc+'\r\n'+link+'\r\n'+imgUrl);
		               
		               var shareData={
		                  title:title,
						  desc:desc,
						  link:link,
						  imgUrl:imgUrl,
						  success:function(){
						     //分享成功回调函数
						  },
						  cancel:function(){
						    //分享取消回调函数
						  }
		               };
		               
		               //微信分享js
					   wx.ready(function() {
					       var share=new wxShare(shareData);
						   share.bind();
					   });
		          }   
			    }
		       });
    </script>
</body>
</html>