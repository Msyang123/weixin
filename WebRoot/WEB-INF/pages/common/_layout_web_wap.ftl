<#macro layout scripts styles >
<!DOCTYPE html>
<html>
<head>
	<base href="${CONTEXT_PATH}/"/>
    <meta charset="utf-8">
    <title>翼支付</title>
    <!--<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">-->

    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!--<link rel="stylesheet" href="${ctx}/plugin/ratchet-v2.0.2/css/ratchet.min.css">
    <link rel="stylesheet" href="${ctx}/plugin/ratchet-v2.0.2/css/ratchet-theme-ios.min.css">
    <link rel="stylesheet" href="${ctx}/plugin/ratchet-v2.0.2/css/app.css">-->

    <!-- begin 自定义图标 -->
    <link rel="stylesheet" href="plugin/jquery.mobile-1.4.2/themes/blue-icons.min.css" />
    <link rel="stylesheet" href="plugin/jquery.mobile-1.4.2/themes/jquery.mobile.icons.min.css" />
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.2/jquery.mobile.structure-1.4.2.min.css" />
    <!-- END 自定义图标 -->
<!-- 轮播样式-->

    <#list styles as item >
        <link rel="stylesheet" type="text/css" href="${(item)! }" />
    </#list>

    <!--<script src="${ctx}/plugin/ratchet-v2.0.2/js/ratchet.min.js"></script>-->

    <style>
        .ui-block-a,
        .ui-block-b,
        .ui-block-c
        {
            /*height: 100px;*/
            text-align: center;
        }

    </style>
</head>
<body style="background-color: #E8E7E7;">

<div data-role="page"  >
    <link rel="stylesheet" href="css/lunbostyle.css" />

    <#if (errormsg!='1')>
        <div class="" style="text-align: center;background-color: #f3e97a"> ${errormsg!} </div>
    </#if>

    <div data-role="content" style="margin: -1em;"><!-- 去白边-->
        <#nested>
    </div>
    <div data-role="footer" data-position="fixed" class="ui-navbar ui-footer-fixed"  >
        <ul class="ui-grid-c">
            <li class="ui-block-a"><a  href=""   data-iconpos="top" data-transition="none" data-ajax="false"><img id="sy" src="img/home.png"  width="50px" height="50px"> </a></li>
            <li class="ui-block-b"><a  href="lo/searchLocation"  data-iconpos="top" data-transition="none" data-ajax="false"><img id="fj" src="img/zb.png"  width="50px" height="50px"></a></li>
            <li class="ui-block-c"><a  href="mall/lookCart"  data-iconpos="top" data-transition="none" data-ajax="false"><img id="gwc" src="img/cart.png" width="50px" height="50px"></a></li>
            <li class="ui-block-d" style="text-align: center"><a  href="u/myWing"   data-iconpos="top" data-transition="none" data-ajax="false"><img id="yl" src="img/yl.png" width="50px" height="50px"></a></li>
        </ul>
    </div>


</div>

</body>
<script src="http://ajax.useso.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="http://libs.useso.com/js/jquery-mobile/1.4.2/jquery.mobile.min.js"></script>

<script type="text/javascript">
    $(document).bind("mobileinit", function() {
        $.mobile.defaultPageTransition = "none";
        $.mobile.defaultDialogTransition = "none";
        $.mobile.ajaxEnabled="false";

    });

</script>

<#list scripts as item >
    <script src="${(item)! }"></script>
</#list>
</html>
</#macro>
