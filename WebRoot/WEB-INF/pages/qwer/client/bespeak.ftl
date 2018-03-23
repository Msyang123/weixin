<!DOCTYPE html>
<html>
<head>
	<base href="${CONTEXT_PATH}/"/>
    <meta name="viewport" content="width=device-width" />
    <link rel="stylesheet" href="plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.css">
    <link rel="stylesheet" href="plugin/jquery.mobile-1.4.2/themes/blue-icons.min.css"/>
    <link rel="stylesheet" href="plugin/jquery.mobile-1.4.2/themes/jquery.mobile.icons.min.css"/>
    <link type="text/css" href="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.min.css" rel="stylesheet" />

    <script src="plugin/jQuery/jquery-1.11.0.min.js"></script>
    <script src="plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/jquery.mousewheel.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.core.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.mode.calbox.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.mode.datebox.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.mode.flipbox.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.mode.durationbox.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/latest/jqm-datebox.mode.slidebox.min.js"></script>
    <script type="text/javascript" src="http://dev.jtsage.com/cdn/datebox/i18n/jquery.mobile.datebox.i18n.zh-CN.utf8.js"></script>
    <script type="text/javascript">
        jQuery.extend(jQuery.mobile, { ajaxEnabled: false });
    </script>
</head>
<body>

<div data-role="page">
    <div data-role="header">
        <h1>预约会见</h1>
    </div>

    <div data-role="content">
        <form method="post" class="input-group" action="bespeak/saveBespeak">
            <input type="hidden" name="be.uuid" value="${uuid!}"/>
            <div class="input-row">
                <input name="be.submit_name" id="submit_name" type="text" placeholder="你的姓名是？" value=""/>
            </div>
            <div class="input-row">
                <label for="age" class="ui-hidden-accessible">你的年龄是？</label>
                <input name="be.age" id="age" type="text" placeholder="你的年龄是？" value=""/>
            </div>
            <div class="input-row">
                <input name="be.job"  id="job" type="text" placeholder="你的职业是？" value=""/>
            </div>
            <div class="input-row">
                <input name="be.meet" id="meet" type="text" placeholder="你的会见对象姓名？" value=""/>
            </div>
            <div class="input-row">
                   <input name="be.date" id="date" type="date" data-role="datebox" placeholder="预约日期?" data-options='{"mode": "calbox"}'>
            </div>
            <div class="input-row">
                    <input type="submit" data-inline="true" value="提交信息">
            </div>
        </form>
    </div>


</div>

</body>
</html>