<#if (basketInfoJson??)&&(basketInfoJson?size>0)> 
<table id="proTable">
	<#list basketInfoJson as item>
	<tr>
		<td style="width:25%;"><img height="50px" src="${item.image_url!}" onerror="imgLoad(this)"/></td>
		<td style="width:45%;">${item.product_name!}</td>
		<td style="width:15%;">
			<div>
				<input type="number" class="basket-input" value="${item.product_num}" id="basketProduct${item.product_id}" onblur="joinBasket(this,'${item.product_id}','${item.image_url!}','${item.product_name!}','${item.amount!0}','${item.is_int}');"/>
			</div>
		</td>
		<td style="width:15%;" onclick="delFromBasket('${item.product_id}')">
			<img height="20px" src="resource/image/icon/icon-cut.png" />
		</td>
	</tr>
	</#list> 
</table>
<#else>
	<div style="margin-top:30%;font-size:1.4rem;">暂无商品</div>
</#if>