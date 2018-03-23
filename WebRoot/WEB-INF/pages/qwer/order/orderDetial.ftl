
<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
    <div class="row">
		<div class="col-sm-6">
			<ul class="list-group">
				<li class="list-group-item">用户昵称：<b>${(orderDetial.nickname)!}</b></li>
				<li class="list-group-item">用户手机号码：<b>${(orderDetial.phone_num)!}</b></li>
				<li class="list-group-item">订单编号:<b>${(orderDetial.order_id)!}</b></li>
		        <li class="list-group-item">微信交易流水号：<b>${(orderDetial.transaction_id)!}</b></li>
				<li class="list-group-item">订单创建日期：<b>${(orderDetial.createtime)!}</b></li>
				<li class="list-group-item">门店名称：<b>${(orderDetial.store_name)!}</b></li>
				<li class="list-group-item">订单种类：
					<#if orderDetial.order_style==0>
						<b>普通订单</b>
					<#elseif orderDetial.order_style==1>
						<b>团购订单</b>
					<#elseif orderDetial.order_style==2>
						<b>兑换订单</b>
					</#if>  
				</li>
				<li class="list-group-item">退货理由：
		        	<b>${(orderDetial.reason)!}</b>
		        </li>
			</ul>
		</div>    
		<div class="col-sm-6">
			<ul class="list-group">
				<li class="list-group-item">订单类型：
					<#if orderDetial.deliverytype=='1'>
						<b>门店自提</b>
					<#elseif orderDetial.deliverytype=='2'>
						<b>送货上门</b>
					<#elseif orderDetial.deliverytype=='3'>
						<b>全国配送</b>
					</#if> 
				</li>
				<li class="list-group-item">订单状态：
					<#if orderDetial.order_status=='1'>
						<b>未付款</b>
					<#elseif orderDetial.order_status=='2'>
						<b>支付中</b>
					<#elseif orderDetial.order_status=='3'>
						<b>已付款</b>
					<#elseif orderDetial.order_status=='4'>
						<b>已收货</b>
					<#elseif orderDetial.order_status=='5'>
						<b>退货中</b>
					<#elseif orderDetial.order_status=='6'>
						<b>退货完成</b>
					<#elseif orderDetial.order_status=='7'>
						<b>取消中</b>
					<#elseif orderDetial.order_status=='8'>
						<b>海鼎退货中</b>
					<#elseif orderDetial.order_status=='9'>
						<b>海海鼎退货失败</b>
					<#elseif orderDetial.order_status=='10'>
						<b>微信退款失败</b>
					<#elseif orderDetial.order_status=='11'>
						<b>订单成功</b>
					<#elseif orderDetial.order_status=='12'>
						<b>配送中</b>
					<#elseif orderDetial.order_status=='12'>
						<b>已失效</b>
					</#if> 
				</li>
		        <li class="list-group-item">海鼎状态：
			        <#if orderDetial.hd_status=='0'>
						<b>发送海鼎成功</b>
					<#elseif orderDetial.hd_status=='1'>
						<b>发送海鼎失败</b>
					</#if> 
		        </li>
				<li class="list-group-item">订单总金额： 
					<b>${(orderDetial.total/100)!}元</b>
				</li>
				<li class="list-group-item">优惠金额： 
					<b>${(orderDetial.discount/100)!}元</b>
				</li>
				<li class="list-group-item">应付金额： 
					<b>${(orderDetial.need_pay/100)!}元</b>
				</li>
				<li class="list-group-item">配送时间： 
					<b>${(orderDetial.deliverytime)!}</b>
				</li>
				<li class="list-group-item">配送费： 
					<b>${(orderDetial.delivery_fee/100)!}元</b>
				</li>
			</ul>
		</div>
    </div>
</@layout>