<!DOCTYPE html>
<html lang="en">
<head>
	<base href="${CONTEXT_PATH}/"/>
    <meta charset="utf-8"/>
    <title>湖南绿航恰果账号注册</title>

    <!-- basic styles -->

    <link href="plugin/ace/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="plugin/ace/css/font-awesome.min.css"/>

    <!--[if IE 7]>
    <link rel="stylesheet" href="plugin/ace/css/font-awesome-ie7.min.css"/>
    <![endif]-->

    <!-- page specific plugin styles -->

    <link rel="stylesheet" href="plugin/ace/css/jquery-ui-1.10.3.custom.min.css"/>
    <link rel="stylesheet" href="plugin/ace/css/chosen.css"/>
    <link rel="stylesheet" href="plugin/ace/css/datepicker.css"/>
    <link rel="stylesheet" href="plugin/ace/css/bootstrap-timepicker.css"/>
    <link rel="stylesheet" href="plugin/ace/css/daterangepicker.css"/>
    <link rel="stylesheet" href="plugin/ace/css/colorpicker.css"/>

    <!-- fonts -->


    <!-- ace styles -->

    <link rel="stylesheet" href="plugin/ace/css/ace.min.css"/>
    <link rel="stylesheet" href="plugin/ace/css/ace-rtl.min.css"/>
    <link rel="stylesheet" href="plugin/ace/css/ace-skins.min.css"/>

    <!--[if lte IE 8]>
    <link rel="stylesheet" href="plugin/ace/css/ace-ie.min.css"/>
    <![endif]-->

    <!-- inline styles related to this page -->

    <!-- ace settings handler -->

    <script src="plugin/ace/js/ace-extra.min.js"></script>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    <!--[if lt IE 9]>
    <script src="plugin/ace/js/html5shiv.js"></script>
    <script src="plugin/ace/js/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<div class="page-content">
    <div class="page-header">
        <h1>
           湖南绿航恰果微信平台
            <small>
                <i class="icon-double-angle-right"></i>
                账号注册
            </small>
        </h1>
    </div>
    <!-- /.page-header -->
    <div class="row">
        <div class="col-xs-12">
            <form class="form-horizontal" role="form" action="customer/register" method="post">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-1">用户账户</label>

                    <div class="col-sm-9">
                        <input type="text"  name="pa.username" placeholder="用户账户"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>

                <div class="space-4"></div>

                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-2"> 密码 </label>

                    <div class="col-sm-9">
                        <input type="password" name="pa.password" placeholder="登录密码"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>
                <div class="space-4"></div>

                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-1">用户昵称</label>

                    <div class="col-sm-9">
                        <input type="text"  name="real_name" placeholder="用户昵称"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-1">公众账号AppId</label>

                    <div class="col-sm-9">
                        <input type="text" name="pa.app_id" placeholder="公众账号AppId"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>
                <div class="space-4"></div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-1">公众账号AppSecret</label>

                    <div class="col-sm-9">
                        <input type="text" name="pa.app_key" placeholder="公众账号AppSecret"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>
                <div class="space-4"></div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-1">原始ID</label>

                    <div class="col-sm-9">
                        <input type="text" name="pa.old_num" placeholder="原始ID"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>
                <div class="space-4"></div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="form-field-1">公众账号微信号</label>

                    <div class="col-sm-9">
                        <input type="text" name="pa.weixin_num" placeholder="公众账号微信号"
                               class="col-xs-10 col-sm-5"/>
                    </div>
                </div>
                <div class="clearfix form-actions">
                    <div class="col-md-offset-3 col-md-9">
                        <button class="btn btn-info" type="submit">
                            <i class="icon-ok bigger-110"></i>
                            注册
                        </button>

                        &nbsp; &nbsp; &nbsp;
                        <button class="btn" type="reset">
                            <i class="icon-undo bigger-110"></i>
                            取消
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>