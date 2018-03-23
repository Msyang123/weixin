<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/> <@layout
scripts=["/js/saveText.js","/js/ajaxfileupload.js","/js/bootstrap-datepicker.min.js",
"/js/bootstrap-timepicker.min.js","/js/daterangepicker.min.js"] styles=[] >

<a id="modal-369895" href="#modal-table" role="button" class="btn"
   data-toggle="modal">新增 </a>
<div id="sample-table-2_filter" class="dataTables_filter">
    <form action="m/role/corpSearch" method="post">
         Search:
            <select name="corp_type">
                <option value="">全部</option>
                <#list corp_typeAll as x>
                    <option value="${(x.code_value)!}">${(x.code_name)!}</option>
                </#list>
            </select>
            <input type="text" name="msg"
                               aria-controls="sample-table-2"></input> <input
                class="btn btn-xs btn-info" type="submit" value="查询"/>

    </form>
</div>
<div id="modal-table" class="modal fade" tabindex="-1">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header no-padding">
    <div class="table-header">
        <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">
            <span class="white">&times;</span>
        </button>
        新增公司
    </div>
</div>
<div class="modal-body no-padding">
<div class="page-content">
<!-- /.page-header -->

<div class="row">
<div class="col-xs-12">
<!-- PAGE CONTENT BEGINS -->

<form class="form-horizontal" action="m/role/addCorp"
      role="form" method="post">
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            > 公司名 </label>

    <div class="col-sm-9">
        <input type="text" id="corp_name" name="corp.corp_name"
               placeholder="请输入公司名" class="col-xs-10 col-sm-5"/> <span
            id="nameMsg" class="middle"></span>
    </div>
</div>

<div class="space-4"></div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            > LOGO</label>

    <div class="col-sm-9">
        <input type="hidden" id="filesrc" name="corp.corp_logo"></input>
        <input type="file" id="corp_logo" name="corp_logo" placeholder=""
               class="col-xs-10 col-sm-5" onchange="uploadImage(this)"></input>
										<span class="help-inline col-xs-12 col-sm-7"> <span
                                                id="logoMsg" class="middle"><img id="zstp1"
                                                                                 width="100" height="45"
                                                                                 src="img/moren.jpg"></span>
										</span>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            > 公司描述 </label>

    <div class="col-sm-9">
        <textarea id="corp_description" name="corp.corp_description"
                  placeholder="请输入公司描述内容" class="col-xs-10 col-sm-5" ></textarea> <span
            id="decMsg" class="middle"></span>
    </div>
</div>

<div class="space-4"></div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            > 地址 </label>

    <div class="col-sm-9">
        <input type="text" name="corp.corp_addr"
               class="col-xs-10 col-sm-5" id="corp_addr"/> <span
            class="help-inline col-xs-12 col-sm-7"> <span
            id="addrMsg" class="middle"></span>
										</span>
    </div>
</div>

<div class="space-4"></div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >负责人</label>

    <div class="col-sm-9">
        <input type="text" name="corp.head_preson"
               class="col-xs-10 col-sm-5" id="head_preson"/> <span
            id="presonMsg" class="middle"></span>

        <div class="space-2"></div>
    </div>
</div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >联系电话</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input  type="text" name="corp.tel" id="tel"
                   placeholder="0731-"class="col-xs-10 col-sm-5"/> <span id="telMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>

        <div class="help-block" id="input-span-slider"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right">行业类型</label>

    <div class="col-sm-4">
        <div class="clearfix">
            <select id="corp_type" name="corp.corp_type"
                    class="form-control">
                <#list corp_typeAll as x>
                    <option value="${(x.code_value)!}">${(x.code_name)!}</option>
                </#list>
            </select>
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >开户行</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.bank_deposit" id="bank_deposit"
                    /> <span id="bank_depositMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >开户账号</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.bank_account" id="bank_account"
                    /> <span id="bank_accountMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >开户名</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.account_ower" id="account_ower"
                    /> <span id="account_owerMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >折扣</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.rebate" id="rebate"
                    /> <span id="rebateMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >返佣</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5"type="text" name="corp.return_commission" id="return_commission"
                    /> <span id="return_commissionMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >结算周期</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5"  type="text" name="corp.balance" id="balance"
                    /> <span id="balanceMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >合同失效时间</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.valid_time" id="valid_time"
                   placeholder="2014-07-09 " /> <span id="valid_timeMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >pos机手续费</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.pos_poundage" id="pos_poundage"
                    /> <span id="pos_poundageMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >拓展经理</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.expand_manager" id="expand_manager"
                    /> <span id="expand_managerMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="clearfix form-actions">
    <div class="col-md-offset-3 col-md-9">
        <button class="btn btn-info" type="submit"
                onclick="return checkSubmitMobil();">
            <i class="icon-ok bigger-110"></i> 提交
        </button>
        &nbsp; &nbsp; &nbsp;
        <button class="btn" type="reset">
            <i class="icon-undo bigger-110"></i> 重置
        </button>
    </div>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div id="Modify" class="modal fade" tabindex="-1">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header no-padding">
    <div class="table-header">
        <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">
            <span class="white">&times;</span>
        </button>
        修改信息
    </div>
</div>
<div class="modal-body no-padding">
<div class="page-content">
<!-- /.page-header -->

<div class="row">
<div class="col-xs-12">
<!-- PAGE CONTENT BEGINS -->

<form class="form-horizontal" action="m/role/addCorp"
      role="form" method="post">
<input type="hidden" name="corp.id" id="corp_id"/>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            > 公司名 </label>

    <div class="col-sm-9">
        <input type="text" id="modify_corp_name" name="corp.corp_name"
               placeholder="请输入公司名" class="col-xs-10 col-sm-5"/> <span
            id="nameModifyMsg" class="middle"></span>
    </div>
</div>

<div class="space-4"></div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >LOGO </label>

    <div class="col-sm-9">
        <input type="hidden" id="modifyfilesrc" name="corp.corp_logo"></input>
        <input type="file" id="modify_corp_logo" name="modify_corp_logo"
               placeholder="" class="col-xs-10 col-sm-5"
               onchange="uploadImage(this)"/> <span
            class="help-inline col-xs-12 col-sm-7"> <span
            id="logoModifyMsg" class="middle"><img id="modifyzstp1"
                                                   width="100" height="45" src=""></span>
										</span>
    </div>
</div>
 <div class="form-group">
     <label class="col-sm-3 control-label no-padding-right"
             > 公司描述 </label>

     <div class="col-sm-9">
         <textarea id="modify_corp_description" name="corp.corp_description"
                   placeholder="请输入公司描述内容" class="col-xs-10 col-sm-5" ></textarea> <span
             id="decModifyMsg" class="middle"></span>
     </div>
 </div>

<div class="space-4"></div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            > 地址</label>

    <div class="col-sm-9">
        <input type="text" id="modify_corp_addr" name="corp.corp_addr"
               class="col-xs-10 col-sm-5"/> <span
            class="help-inline col-xs-12 col-sm-7"> <span
            id="addrModifyMsg" class="middle"></span>
										</span>
    </div>
</div>

<div class="space-4"></div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >负责人</label>

    <div class="col-sm-9">
        <input class="col-xs-10 col-sm-5" type="text"
               name="corp.head_preson" id="modify_head_preson"/> <span
            id="presonModifyMsg" class="middle"></span>

        <div class="space-2"></div>

        <div class="help-block" id="input-size-slider"></div>
    </div>
</div>

<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >联系电话</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.tel"
                   id="modify_tel" placeholder="0731-"/> <span id="telModifyMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>

    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right">行业类型</label>

    <div class="col-sm-4">
        <div class="clearfix">
            <select id="modify_corp_type" name="corp.corp_type"
                    class="form-control">
                <#list corp_typeAll as x>
                    <option value="${(x.code_value)!}">${(x.code_name)!}</option>
                </#list>
            </select>
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >开户行</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.bank_deposit" id="modify_bank_deposit"
                    /> <span id="modify_bank_depositMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >开户账号</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.bank_account" id="modify_bank_account"
                    /> <span id="modify_bank_accountMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >开户名</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.account_ower" id="modify_account_ower"
                    /> <span id="modify_account_owerMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >折扣</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.rebate" id="modify_rebate"
                    /> <span id="modify_rebateMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >返佣</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.return_commission" id="modify_return_commission"
                    /> <span id="modify_return_commissionMsg" class="middle"></span>
        </div>

        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >结算周期</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.balance" id="modify_balance"
                    /> <span id="modify_balanceMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >合同失效时间</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.valid_time" id="modify_valid_time"
                   placeholder="2014-07-09 " /> <span id="modify_valid_timeMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >pos机手续费</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.pos_poundage" id="modify_pos_poundage"
                    /> <span id="modify_pos_poundageMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>
<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right"
            >拓展经理</label>

    <div class="col-sm-9">
        <div class="clearfix">
            <input class="col-xs-10 col-sm-5" type="text" name="corp.expand_manager" id="modify_expand_manager"
                    /> <span id="modify_expand_managerMsg" class="middle"></span>
        </div>
        <div class="space-2"></div>
    </div>
</div>

<!--<div class="form-group">
    <label class="col-sm-3 control-label no-padding-right">坐标</label>

    <div class="col-sm-3">
        <div class="clearfix">
            <input type="text" id="modify_map_index"
                name="corp.map_index" class="col-xs-10 col-sm-5" />
        </div>
    </div>
</div>-->
<div class="space-4"></div>
<div class="clearfix form-actions">
    <div class="col-md-offset-3 col-md-9">
        <button class="btn btn-info" type="submit" onclick="return checkModify();">
            <i class="icon-ok bigger-110"></i> 提交
        </button>
        &nbsp; &nbsp; &nbsp;
        <button class="btn" type="reset">
            <i class="icon-undo bigger-110"></i> 重置
        </button>
    </div>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<table
        class="table table-bordered table-striped table-condensed  table-hover">
    <thead>
    <tr>
        <th>公司名</th>
        <th>地址</th>
        <th>负责人</th>
        <th>联系电话</th>
        <th>行业类型</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>

    <#list corpPage.getList() as x>
        <form action="m/role/deleteCorp" method="post">
            <tr class="myclass">
                <td style="text-align: center;" hidden="true">${(x.id)}</td>
                <td style="text-align: center;"><a href="m/role/showCorp?id=${(x.id)}" style="text-decoration:none;color:#000000">${(x.corp_name)!}</a></td>
                <!--<td style="text-align: center;"><img width="200" height="90"
                    onload="return imgzoom(this,600);"
                    onclick="javascript:window.open(this.src);"
                    style="cursor: pointer;" src="${(x.corp_logo)!}"></td>-->
                <!--<td style="text-align: center;">${(x.corp_description)!}</td>-->
                <td style="text-align: center;">${(x.corp_addr)!}</td>
                <td style="text-align: center;">${(x.head_preson)!}</td>
                <td style="text-align: center;">${(x.tel)!}</td>
                <td style="text-align: center;">

                    ${x.corp_typea}
                </td>

                <td style="text-align: left;">&nbsp;&nbsp; <input
                        type="hidden" name="delete_id" value="${(x.id)}"/>
                    <!--  <input type="hidden" name="corp_logo" value="${(x.corp_logo)!}"/> -->
                    <button type="submit" class="btn btn-xs btn-danger"
                            onclick='return confirm("你确定删除${(x.corp_name)!}?");'>
                        <i class="icon-trash bigger-120"></i>
        </form>
        </button>
        &nbsp;&nbsp;
        <button id="modify" href="#Modify" role="button" data-toggle="modal"
                class="btn btn-xs btn-info" onclick="return modify(${x.id});">
            <i class="icon-edit bigger-120"></i>
        </button>
        </tr>
    </#list>
    </tbody>
</table>
<#include "/WEB-INF/pages/common/_paginate.html" /> <@paginate
currentPage=corpPage.pageNumber totalPage=corpPage.totalPage
actionUrl="/m/role/corpList/" />
</div>

</@layout>
<script type="text/javascript">
  /*  jQuery(function ($) {
        $("#valid_time").datepicker({
            showOtherMonths: true,
            selectOtherMonths: false
        });
        $("#modify_valid_time").datepicker({
            showOtherMonths: true,
            selectOtherMonths: false
        });
    });*/
    function modify(id) {
        $.ajax({ // 一个Ajax过程
            type: "post", // 以post方式与后台沟通
            url: "/m/role/toModifyCorp",
            dataType: 'json',//
            data: {
                id: id
            },
            success: function (json) {
                $("#corp_id").val(json.mm.id);
                $("#modify_corp_name").val(json.mm.corp_name);
                $("#modify_corp_type").val(json.mm.corp_type);
                $("#modify_corp_addr").val(json.mm.corp_addr);
                $("#modify_head_preson").val(json.mm.head_preson);
                $("#modify_tel").val(json.mm.tel);
                $("#modifyfilesrc").val(json.mm.corp_logo);
                $("#modifyzstp1").attr("src", json.mm.corp_logo);
                $("#modify_bank_deposit").val(json.mm.bank_deposit);
                $("#modify_bank_account").val(json.mm.bank_account);
                $("#modify_account_ower").val(json.mm.account_ower);
                $("#modify_rebate").val(json.mm.rebate);
                $("#modify_return_commission").val(json.mm.return_commission);
                $("#modify_balance").val(json.mm.balance);
                $("#modify_valid_time").val(json.mm.valid_time);
                $("#modify_pos_poundage").val(json.mm.pos_poundage);
                $("#modify_expand_manager").val(json.mm.expand_manager);
                $("#modify_corp_description").val(json.mm.corp_description);

            },
            error: function (json) {
                alert("error");

            }
        })
    }

    function checkSubmitMobil() {
        if ($("#tel").val() == "") {
            $("#telMsg").html("<font color='red'>手机号码不能为空！</font>");
            $("#tel").focus();
            return false;
        } else if (!$("#tel").val().match(/^1[3|4|5|8][0-9]\d{4,8}$/)) {
            $("#telMsg").html("<font color='red'>手机号码格式不正确！请重新输入！</font>");
            $("#tel").focus();
            return false;
        } else {
            $("#telMsg").html("");
        }
        if ($("#corp_name").val() == "") {
            $("#nameMsg").html("<font color='red'>店铺名不能为空！</font>");
            $("#corp_name").focus();
            return false;
        } else {
            $("#nameMsg").html(" ");
        }

        if ($("#corp_addr").val() == "") {
            $("#addrMsg").html("<font color='red'>地址不能为空！</font>");
            $("#corp_addr").focus();
            return false;
        } else {
            $("#addrMsg").html(" ");
        }

        if ($("#head_preson").val() == "") {
            $("#presonMsg").html("<font color='red'>负责人不能为空！</font>");
            $("#head_preson").focus();
            return false;
        } else {
            $("#presonMsg").html(" ");
        }/*if ($("#valid_time").val() == "") {
            $("#valid_timeMsg").html("<font color='red'> 合同失效时间不能为空！</font>");
            $("#valid_time").focus();
            return false;
        } else {
            $("#valid_timeMsg").html("");
        }*/
        return true;
    }


    function checkModify() {
        if ($("#modify_tel").val() == "") {
            $("#telModifyMsg").html("<font color='red'>手机号码不能为空！</font>");
            $("#modify_tel").focus();
            return false;
        } else if (!$("#modify_tel").val().match(/^1[3|4|5|8][0-9]\d{4,8}$/)) {
            $("#telModifyMsg").html("<font color='red'>手机号码格式不正确！请重新输入！</font>");
            $("#modify_tel").focus();
            return false;
        } else {
            $("#telModifyMsg").html("");
        }
        if ($("#modify_corp_name").val() == "") {
            $("#nameModifyMsg").html("<font color='red'>店铺名不能为空！</font>");
            $("#modify_corp_name").focus();
            return false;
        } else {
            $("#nameModifyMsg").html(" ");
        }

        if ($("#modify_corp_addr").val() == "") {
            $("#addrModifyMsg").html("<font color='red'>地址不能为空！</font>");
            $("#modify_corp_addr").focus();
            return false;
        } else {
            $("#addrModifyMsg").html(" ");
        }

        if ($("#modify_head_preson").val() == "") {
            $("#presonModifyMsg").html("<font color='red'>负责人不能为空！</font>");
            $("#modify_head_preson").focus();
            return false;
        } else {
            $("#presonModifyMsg").html(" ");
        }/*if ($("modify_valid_time").val() == "") {
            $("#modify_valid_timeMsg").html("<font color='red'> 合同失效时间不能为空！</font>");
            $("#modify_valid_time").focus();
            return false;
        } else {
            $("#modify_valid_timeMsg").html("");
        }*/

        return true;
    }

</script>

</script>

