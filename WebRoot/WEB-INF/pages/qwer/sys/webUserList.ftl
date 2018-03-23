<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/> <@layout
scripts=[]
styles=["/css/loginDialog.css"] >
<div id="LoginBox">
    <div class="row1">
        会员详细信息<a href="javascript:void(0)" title="关闭窗口" class="close_btn" id="closeBtn">×</a>
    </div>
    <div class="row">
        会员名称:
        <input type="text" id="user_name" />

    </div>
    <div class="row">
        手机:
        <input type="text" id="tel" />

    </div>
    <div class="row">
        微信名称:
        <input type="text" id="wx_name"  />

    </div>
    <div class="row">
        省份:
        <input type="text" id="wx_province"  />

    </div>
    <div class="row">
        城市:
        <input type="text" id="wx_city"  />

    </div>
    <div class="row">
        国家:
        <input type="text" id="wx_country"  />

    </div>

</div>

<div id="sample-table-2_filter" class="dataTables_filter">
    <form action="m/webUser/search" method="post">
        <label> 城 市: <select id="city" name="wx_city" >
            <#list userList.getList() as u>
                <option value="${u.wx_city}" >${u.wx_city}</option>
            </#list>
        </select>
        </label>
        <label> Search: <input type="text" name="msg"
                               aria-controls="sample-table-2">
            <input
                    class="btn btn-xs btn-info" type="submit" value="查询" />
        </label>
    </form>
</div>
<div class="table_box">
    <table
            class="table table-bordered table-striped table-condensed  table-hover">
        <thead>
        <tr>
            <th style="text-align: center;">会员名称</th>
            <th style="text-align: center;">手机</th>
            <th style="text-align: center;">微信名称</th>
            <th style="text-align: center;">省份</th>
            <th style="text-align: center;">城市</th>
            <th style="text-align: center;">国家</th>


        </tr>
        </thead>
        <tbody>

        <#list webUserPage.getList() as x>
            <tr class="myclass"onclick="searchMsg(${(x.id)})">
                <td  style="text-align: center;" hidden="true">${(x.id)}</td>
                <td  style="text-align: center;">${(x.user_name)!}</td>
                <td  style="text-align: center;">${(x.tel)!}</td>
                <td  style="text-align: center;">${(x.wx_name)!}</td>
                <td  style="text-align: center;">${(x.wx_province)!}</td>
                <td  style="text-align: center;">${(x.wx_city)!}</td>
                <td  style="text-align: center;">${(x.wx_country)!}</td>


            </tr>
        </#list>

        </tbody>
    </table>
    <#include "/WEB-INF/pages/common/_paginate.html" /> <@paginate
    currentPage=webUserPage.pageNumber totalPage=webUserPage.totalPage
    actionUrl="/m/webUser/webUserList/" />
</div>

</@layout>
<script type="text/javascript">
    $(function ($) {
        //弹出登录
        $("#example").hover(function () {
            $(this).stop().animate({
                opacity: '1'
            }, 600);
        }, function () {
            $(this).stop().animate({
                opacity: '0.6'
            }, 1000);
        }).on('click', function () {

        });
        //
        //按钮的透明度
        $("#loginbtn").hover(function () {
            $(this).stop().animate({
                opacity: '1'
            }, 600);
        }, function () {
            $(this).stop().animate({
                opacity: '0.8'
            }, 1000);
        });
        //关闭
        $(".close_btn").hover(function () { $(this).css({ color: 'black' }) }, function () { $(this).css({ color: '#999' }) }).on('click', function () {
            $("#LoginBox").fadeOut("fast");
            $("#mask").css({ display: 'none' });
        });
    });
</script>
<script type="text/javascript">
    function searchMsg(id){
        $.ajax({type:"POST",
            url:"/m/webUser/searchMsg",
            data:{id:id},
            dataType:"json",
            error:function () {
                alert("系统错误，请稍后重试");
            }, success:function (data) {
                $("#user_name").val(data.bu.user_name);
                $("#tel").val(data.bu.tel);
                $("#wx_name").val(data.bu.wx_name);
                $("#wx_province").val(data.bu.wx_province);
                $("#wx_city").val(data.bu.wx_city);
                $("#wx_country").val(data.bu.wx_country);
                $("body").append("<div id='mask'></div>");
                $("#mask").addClass("mask").fadeIn("slow");
                $("#LoginBox").fadeIn("slow");
            }});

    }
</script>