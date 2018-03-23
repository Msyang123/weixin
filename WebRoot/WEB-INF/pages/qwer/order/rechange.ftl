<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >

<form action="${CONTEXT_PATH}/orderManage/rechange" class="form-horizontal" role="form" method="post">
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="order_id">订单编号</label>
        <div class="col-sm-9">
            <input type="text" readonly="readonly"
            id="order_id" name="order_id"
            value="${order.order_id!}"
             placeholder="订单编号" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="order_id">手机号码</label>
        <div class="col-sm-9">
            <input type="text" readonly="readonly"
            id="phone_num" name="phone_num"
            value="${order.phone_num!}"
             placeholder="手机号码" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="order_id">昵称</label>
        <div class="col-sm-9">
            <input type="text" readonly="readonly"
            id="nickname" name="nickname"
            value="${order.nickname!}"
             placeholder="昵称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right" for="store_name">所在店铺</label>
        <div class="col-sm-9">
            <input type="text" readonly="readonly"
            id="store_name"
            value="${order.store_name!}"
             placeholder="所在店铺" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right">调换店铺 </label>
        <div class="col-sm-9">
            <select id="order_store" name="order_store">
            <#list stores as store>
	        	<option value="${store.store_id}" >${store.store_name}</option>
	        </#list>	
        	</select>
        </div>
    </div>
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" onclick="$('.form-horizontal').submit();">
                	提交
            </button>
            <button class="btn" type="button" onclick="history.go(-1);">
                	取消
            </button>
        </div>
	</div>
</form>
</@layout>