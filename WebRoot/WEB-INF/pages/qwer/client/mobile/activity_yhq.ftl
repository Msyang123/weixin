<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-客显屏" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<div data-role="page">
    <!--头部-->
    <div class="header">
    	<#if activity.yxq_q gt .now >
    		<a href="#activityPopup" data-rel="popup" data-position-to="window"><img src='${image.save_string!}'/></a>
		<#else>
			<a href="${activity.url!}" data-ajax="false"><img src='${image.save_string!}'/></a>
		</#if>
        <!--弹出内容-->
        <div data-role="popup" id="activityPopup" class="ui-content">
            <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn ui-icon-delete ui-btn-icon-notext ui-btn-right">关闭</a>
            <p style="font-size:14px;">18:00-20:30开始抢购,等你哦！</p>
            <a style="font-size:14px;" href="${activity.url!}"  data-ajax="false" >不管，我就要原价购买</a>
       </div>
    </div>

    <!--优惠券-->
    <div class="ui-content">

		<#if couponList?? && (couponList?size>0)>
			<div class="ui-grid-b">
				<#list couponList as coupon>
				    <div class="
					<#if coupon_index%3==0>
					ui-block-a
					<#elseif coupon_index%3==1>
					ui-block-b
					<#elseif coupon_index%3==2>
					ui-block-c
					</#if>	
						">
		                <#--<div class="conpon_one" onclick="getYhq('${coupon.title}','${activity.id}',${coupon.c});">
		                    <div class="conpon_small">
		                    	<p id="${coupon.title}">剩余${coupon.c}张</p>
		                        <p><span>${coupon.coupon_val/100}</span>${coupon.title}</p>
		                    </div>
		                </div>-->
		            </div>
				</#list>
			</div>
		</#if>
	</div>
      <div data-role="main" class="ui-content ">
          <div class="hot_line">
              <p>热门爆款</p>
              <p>果园到舌尖，安全又新鲜</p>
          </div>
		<#if mRecommends?? && (mRecommends?size>0)>
          <div class="hot_pro ui-grid-a">
          	<#list mRecommends as recommend>
              <div <#if recommend_index%2==0>
						class="ui-block-a"
					<#elseif recommend_index%2==1>
						class="ui-block-b"
					</#if>
				onclick="window.location.href='${CONTEXT_PATH}/fruitDetial?pf_id=${recommend.pf_id}';">
	                  <img src="${recommend.save_string!}">
	                  <p class="pro_name">${recommend.product_name!}</p>
	                  <p class="pro_price">￥${(recommend.real_price!0)/100}/<span>${recommend.unit_name!}</span></p>
	                   <span style="font-size: 12px;color: #999999">已售${recommend.saleCount!0}件</span>
              </div>
            </#list>  
          </div>
        </#if>  
      </div>
      
      <div style="background-color: #EEECED; height: 10px;"></div>
      
      
      <div data-role="main" class="ui-content">
          <div class="hot_line">
              <p>精挑细选</p>
              <p>熟了，自然甜蜜</p>
          </div>
          <#if mRecommends1?? && (mRecommends1?size>0)>
	          <div class="ui-grid-b">
	             <#list mRecommends1 as recommend>
	              <div <#if recommend_index%3==0>
							class="ui-block-a"
						<#elseif recommend_index%3==1>
							class="ui-block-b"
						<#elseif recommend_index%3==2>
							class="ui-block-c"
						</#if>
						onclick="window.location.href='${CONTEXT_PATH}/fruitDetial?pf_id=${recommend.pf_id}';">
	                  <img src="${recommend.save_string!}">
	                  <p class="guess_name">${recommend.product_name!}</p>
	                  <p class="guess_price">￥${(recommend.real_price!0)/100}/<span>${recommend.unit_name!}</span></p>
	                  <span style="font-size: 12px;color: #999999">已售${recommend.saleCount!0}件</span>
	              </div>
	             </#list> 
	          </div>
          </#if>
      </div>

</div>
<#include "/WEB-INF/pages/common/share.ftl"/>
<script type="text/javascript">
		//领优惠券
		function getYhq(title,activityId,count){
		    $.ajax({ 
				url: "${CONTEXT_PATH}/activity/getYhq", 
			data: {title:title,activityId:activityId}, 
			success: function(data){
				if(data.errcode==0){
					$.dialog.alert("领取成功");
					$("#"+title).html('剩余'+(count-1)+'张');
				}else{
					$.dialog.alert(data.errmsg);
				}	
	      	}
		});
	}
</script>
</body>
</html>