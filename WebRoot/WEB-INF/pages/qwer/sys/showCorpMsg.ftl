<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/> <@layout
scripts=[] styles=[] >
<div class="form-group">
    <label style="width:100px"> 公司名</label>
     <input class="form-control"   value="${(corp.corp_name)!}" />
</div>

<div class="form-group">
    <label style="width:100px"> 公司描述</label>
     <textarea class="form-control"   >${(corp.corp_description)!}</textarea>
</div>

<div class="form-group">
    <label style="width:100px"> 公司logo</label>
    <img src="${(corp.corp_logo)!}" width="100px" height="60px" />
</div>

<div class="form-group">
    <label style="width:100px">地址</label>
    <input class="form-control" value="${(corp.corp_addr)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">负责人</label>
    <input class="form-control" value="${(corp.head_preson)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">联系电话</label>
    <input class="form-control" value="${(corp.tel)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">行业类型</label>
    <input class="form-control" value="${(corp.corp_typea)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">开户行</label>
    <input class="form-control" value="${(corp.bank_deposit)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">开户账号</label>
    <input class="form-control" value="${(corp.bank_account)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">开户名</label>
    <input class="form-control" value="${(corp.account_ower)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">折扣</label>
    <input class="form-control" value="${(corp.rebate)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">返佣</label>
    <input class="form-control" value="${(corp.return_commission)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">结算周期</label>
    <input class="form-control" value="${(corp.balance)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">合同失效时间</label>
    <input class="form-control" value="${(corp.valid_time)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">pos机手续费</label>
    <input class="form-control" value="${(corp.pos_poundage)!}"/>
</div>

<div class="form-group">
    <label style="width:100px">拓展经理</label>
    <input class="form-control" value="${(corp.expand_manager)!}"/>
</div>

</@layout>


