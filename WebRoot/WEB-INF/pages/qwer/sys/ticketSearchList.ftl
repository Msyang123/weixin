<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/> <@layout
scripts=["/js/ajaxfileupload.js","/js/ticketUpload.js"] styles=[] >

<a id="modal-369895" href="#modal-table" role="button" class="btn"
   data-toggle="modal">新增积分商城</a>
<a id="modal-369896" href="#modal-table-lottery" role="button" class="btn"
   data-toggle="modal">新增抽奖</a>
<div id="sample-table-2_filter" class="dataTables_filter">
    <form action="m/ticket/ticketSearch" method="post">
        <label> Search: <input type="text" name="msg"
                               aria-controls="sample-table-2"></input> <input
                class="btn btn-xs btn-info" type="submit" value="查询"/>
        </label>
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
                    新增积分商城电子券
                </div>
            </div>
            <div class="modal-body no-padding">
                <div class="page-content">
                    <!-- /.page-header -->

                    <div class="row">
                        <div class="col-xs-12">
                            <!-- PAGE CONTENT BEGINS -->

                            <form class="form-horizontal" action="m/ticket/addTicket"
                                  role="form" method="post">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            > 公司 </label>

                                    <div class="col-sm-9">

                                        <div class="clearfix">
                                            <select id="ticket_corp_id" name="ticket.corp_id"
                                                    class="col-xs-10 col-sm-5"
                                                    onchange="changeCorp(this.value)">
                                                <option class="corp" value="">请选择公司</option>
                                                <#list corpAll as t>
                                                    <option value="${t.id}">${t.corp_name}</option>
                                                </#list>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-4"></div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            > 商品 </label>

                                    <div class="col-sm-9">
                                        <div class="clearfix">
                                            <select id="ticket_product_id" name="ticket.product_id"
                                                    class="col-xs-10 col-sm-5">


                                            </select>
                                            <span id="actMsg" class="middle"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >优惠券图片</label>

                                    <div class="col-sm-9">
                                        <input type="file" id="pic_path" name="pic_path"
                                               placeholder="" class="col-xs-10 col-sm-5"
                                               onchange="imgUpload(this)"/><span
                                            class="help-inline col-xs-12 col-sm-7"> <input
                                            type="hidden" id="img" name="ticket.img_src"/>
										</span>

                                    </div>

                                    <div class="col-sm-9">
                                        </span> <img id="zstp1" width="200" height="200" src="img/moren.jpg"> <span
                                            id="srcMsg" class="middle">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >面值</label>

                                    <div class="col-sm-9">
                                        <input type="text" name="ticket.par_value"
                                               class="col-xs-10 col-sm-5" id="ticket_par_value"/> <span
                                            class="help-inline col-xs-12 col-sm-7"> <span
                                            id="valMsg" class="middle"></span>
										</span>
                                    </div>
                                </div>

                                <div class="space-4"></div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >电子券有效期</label>

                                    <div class="col-sm-9">
                                        <input class="col-xs-1" type="text" name="ticket.valid_time"
                                               id="ticket_valid_time" placeholder=""/>天 <span
                                            id="validTimeMsg" class="middle"></span>

                                        <div class="space-2"></div>

                                        <div class="help-block" id="input-size-slider"></div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >生成张数</label>

                                    <div class="col-sm-9">
                                        <div class="clearfix">
                                            <input class="col-xs-1" type="text" name="create_num"
                                                   id="create_num" placeholder="" onblur="checkSubmitTicket();"/>张
                                            <span id="numMsg" class="middle"></span>
                                        </div>

                                        <div class="space-2"></div>

                                        <div class="help-block" id="input-span-slider"></div>
                                    </div>
                                </div>


                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >使用场景</label>

                                    <div class="col-sm-9">
                                        <div class="clearfix">
                                            <select id="form-field-select-1" name="ticket.use_scope"
                                                    class="col-xs-10 col-sm-5">
                                                <option value="1">线上</option>
                                                <option value="2">线下</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="clearfix form-actions">
                                    <div class="col-md-offset-3 col-md-9">
                                        <button class="btn btn-info" type="submit"
                                                onclick="return checkSubmitTicket();">
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

<div id="modal-table-lottery" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header no-padding">
                <div class="table-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-hidden="true">
                        <span class="white">&times;</span>
                    </button>
                    新增商品抽奖电子券
                </div>
            </div>
            <div class="modal-body no-padding">
                <div class="page-content">
                    <!-- /.page-header -->

                    <div class="row">
                        <div class="col-xs-12">
                            <!-- PAGE CONTENT BEGINS -->

                            <form class="form-horizontal" action="m/ticket/addLotteryTicket"
                                  role="form" method="post">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            > 商家 </label>

                                    <div class="col-sm-9">

                                        <div class="clearfix">
                                            <select id="LotteryTicket_store_id" name="LotteryTicket.store_id"
                                                    class="col-xs-10 col-sm-5"
                                                    onchange="changeStore(this.value)">
                                                <option class="store" value="">请选择商家</option>
                                                <#list storeAll as t>
                                                    <option value="${t.id}">${t.store_name}</option>
                                                </#list>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-4"></div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            > 商品 </label>

                                    <div class="col-sm-9">
                                        <div class="clearfix">
                                            <select id="LotteryTicket_product_id" name="LotteryTicket.product_id"
                                                    class="col-xs-10 col-sm-5">


                                            </select>
                                            <span id="actLotteryTicketMsg" class="middle"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >优惠券图片</label>

                                    <div class="col-sm-9">
                                        <input type="file" id="LotteryTicket_pic_path" name="LotteryTicket_pic_path"
                                               placeholder="" class="col-xs-10 col-sm-5"
                                               onchange="imgUpload(this)"/><span
                                            class="help-inline col-xs-12 col-sm-7"> <input
                                            type="hidden" id="LotteryTicket_img" name="LotteryTicket.img_src"/>
										</span>

                                    </div>

                                    <div class="col-sm-9">
                                        </span> <img id="zstpLotteryTicket" width="200" height="200" src="img/moren.jpg"> <span
                                            id="srcLotteryTicketMsg" class="middle">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >面值</label>

                                    <div class="col-sm-9">
                                        <input type="text" name="LotteryTicket.par_value"
                                               class="col-xs-10 col-sm-5" id="LotteryTicket_par_value"/> <span
                                            class="help-inline col-xs-12 col-sm-7"> <span
                                            id="valLotteryTicketMsg" class="middle"></span>
										</span>
                                    </div>
                                </div>

                                <div class="space-4"></div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >电子券有效期</label>

                                    <div class="col-sm-9">
                                        <input class="col-xs-1" type="text" name="LotteryTicket.valid_time"
                                               id="LotteryTicket_valid_time" placeholder=""/>天 <span
                                            id="validTimeLotteryTicketMsg" class="middle"></span>

                                        <div class="space-2"></div>

                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >生成张数</label>

                                    <div class="col-sm-9">
                                        <div class="clearfix">
                                            <input class="col-xs-1" type="text" name="LotteryTicketcreate_num"
                                                   id="LotteryTicketcreate_num" placeholder=""/>张
                                            <span id="numLotteryTicketMsg" class="middle"></span>
                                        </div>

                                        <div class="space-2"></div>

                                    </div>
                                </div>


                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            >使用场景</label>

                                    <div class="col-sm-9">
                                        <div class="clearfix">
                                            <select id="form-field-select-2" name="LotteryTicket.use_scope"
                                                    class="col-xs-10 col-sm-5">
                                                <option value="1">线上</option>
                                                <option value="2">线下</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="clearfix form-actions">
                                    <div class="col-md-offset-3 col-md-9">
                                        <button class="btn btn-info" type="submit"
                                                onclick="return checkLotteryTicketSubmitTicket();">
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
<div class="table_box">
    <table
            class="table table-bordered table-striped table-condensed  table-hover">
        <thead>
        <tr>
            <th style="text-align: center;">串号</th>
            <th style="text-align: center;">商品名称</th>
            <th style="text-align: center;">获得类型</th>
            <th style="text-align: center;">电子券状态</th>
            <th style="text-align: center;">使用范围</th>
            <!--	<th style="text-align: left;">使用场景</th>-->
            <th style="text-align: center;">面值</th>
            <th style="text-align: center;">电子券生成时间</th>
            <th style="text-align: center;">电子券领取时间</th>
            <th style="text-align: center;">有效期</th>
            <th style="text-align: center;">电子券生效日期</th>
            <th style="text-align: center;">电子券失效日期</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>

        <#list ticketPage.getList() as x>
            <form action="m/ticket/deleteTicket" method="post">
                <tr class="myclass">
                    <td style="text-align: left;" hidden="true">${(x.id)}</td>
                    <td style="text-align: left;">${(x.serial_number)!}</td>
                    <td style="text-align: left;">${(x.name)!}</td>
                    <td style="text-align: left;">${(x.use_scenea)!}</td>
                    <td style="text-align: left;">${(x.statusa)!}</td>
                    <td style="text-align: left;">${(x.use_scopea)!}</td>
                    <!--	<td style="text-align: left;">${(x.use_scene)!}</td>-->
                    <td style="text-align: left;">${(x.par_value)!}</td>
                    <td style="text-align: left;">${(x.produce_time)!}</td>
                    <td style="text-align: left;">${(x.get_time)!}</td>
                    <td style="text-align: left;">${(x.valid_time)!}</td>
                    <td style="text-align: left;">${(x.activate_time)!}</td>
                    <td style="text-align: left;">${(x.invalid_time)!}</td>
                    <td style="text-align: left;">&nbsp;&nbsp; <input
                            type="hidden" name="delete_id" value="${(x.id)}"/>
                        <button class="btn btn-xs btn-danger"
                                onclick='return confirm("你确定删除${(x.serial_number)!}?");'>
                            <i class="icon-trash bigger-120"></i>
            </form>
            </button>
            &nbsp;&nbsp;
            <!-- <button id="modify"
                        href="#Modify"
                        role="button" data-toggle="modal" class="btn btn-xs btn-info" onclick="return modify(${x.id});">
                        <i class="icon-edit bigger-120"></i>
                    </button> -->
            </tr>
        </#list>
        </tbody>
    </table>
    <#include "/WEB-INF/pages/common/_paginate.html" />
    <@paginate
	currentPage=ticketPage.pageNumber totalPage=ticketPage.totalPage
	actionUrl="/m/ticket/ticketSearch/" urlParas="?msg=${msg!}" />
</div>

</@layout>
<script type="text/javascript">
    function changeStore(val) {
        //alert(val);
        $.ajax({
            type: "post",
            url: "/m/ticket/storeProduct",
            dataType: 'json',
            data: {
                id: val
            },
            success: function (json) {
                $("#actLotteryTicketMsg").html("");
                $("option").remove(".store");
                var arr = json.storeProduct;
                if (arr.length > 0) {
                    for (var i = 0; i < arr.length; i++) {
                        $("#LotteryTicket_product_id").append("<option class='store' value='" + arr[i].id + "'>" + arr[i].name + "</option>");
                    }
                } else {
                    $("#LotteryTicket_product_id").append("<option class='store' value=''>商家未发布商品</option>");
                }
            },
            error: function (json) {
                alert("error");

            }
        })
    }
    function changeCorp(val) {
        //alert(val);
        $.ajax({
            type: "post",
            url: "/m/ticket/corpProduct",
            dataType: 'json',
            data: {
                id: val
            },
            success: function (json) {
                $("#actMsg").html("");
                $("option").remove(".corp");
                var arr = json.corpProduct;
                if (arr.length > 0) {
                    for (var i = 0; i < arr.length; i++) {
                        $("#ticket_product_id").append("<option class='corp' value='" + arr[i].id + "'>" + arr[i].name + "</option>");
                    }
                } else {
                    $("#ticket_product_id").append("<option class='corp' value=''>公司未发布商品</option>");
                }
            },
            error: function (json) {
                alert("error");

            }
        })
    }

    function checkLotteryTicketSubmitTicket() {
        if ($("#LotteryTicket_product_id").val() == null || $("#LotteryTicket_product_id").val() == "") {
            $("#actLotteryTicketMsg").html("<font color='red'>商品不能为空！请选择商家</font>");
            return false;
        } else {
            $("#actLotteryTicketMsg").html("");
        }
        if ($("#LotteryTicket_par_value").val() == "") {
            $("#valLotteryTicketMsg").html("<font color='red'>面值不能为空！</font>");
            return false;
        } else if (!$("#LotteryTicket_par_value").val().match(/^\d+$/)) {
            $("#valLotteryTicketMsg").html("<font color='red'>面值为数字！</font>");
            return false;
        }
        else {
            $("#valLotteryTicketMsg").html("");
        }
        if ($("#LotteryTicket_valid_time").val() == "") {
            $("#validTimeLotteryTicketMsg").html("<font color='red'>有效期不能为空！</font>");
            return false;
        } else {
            $("#validTimeLotteryTicketMsg").html("");
        }
        if ($("#LotteryTicketcreate_num").val() == "") {
            $("#numLotteryTicketMsg").html("<font color='red'>生成张数不能为空！</font>");
            return false;
        } else if (!$("#LotteryTicketcreate_num").val().match(/^\d+$/)) {
            $("#numLotteryTicketMsg").html("<font color='red'>张数为数字！</font>");
            return false;
        } else {
            $("#numLotteryTicketMsg").html("");
        }
        return true;
    }

    function checkSubmitTicket() {
        if ($("#ticket_product_id").val() == null || $("#ticket_product_id").val() == "") {
            $("#actMsg").html("<font color='red'>商品不能为空！请选择公司</font>");
            return false;
        } else {
            $("#actMsg").html("");
        }
        if ($("#ticket_par_value").val() == "") {
            $("#valMsg").html("<font color='red'>面值不能为空！</font>");
            return false;
        } else if (!$("#ticket_par_value").val().match(/^\d+$/)) {
            $("#valMsg").html("<font color='red'>面值为数字！</font>");
            return false;
        }
        else {
            $("#valMsg").html("");
        }
        if ($("#ticket_valid_time").val() == "") {
            $("#validTimeMsg").html("<font color='red'>有效期不能为空！</font>");
            return false;
        } else {
            $("#validTimeMsg").html("");
        }
        if ($("#create_num").val() == "") {
            $("#numMsg").html("<font color='red'>生成张数不能为空！</font>");
            return false;
        } else if (!$("#create_num").val().match(/^\d+$/)) {
            $("#numMsg").html("<font color='red'>张数为数字！</font>");
            return false;
        } else {
            $("#numMsg").html("");
        }
        return true;
    }


</script>