<!DOCTYPE html>
<html lang="en">
<head>
	<base href="${CONTEXT_PATH}/"/>
    <meta charset="utf-8" />
    <title>后台登录页面</title>
    <link href="plugin/ace/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="plugin/ace/css/font-awesome.min.css" />
    <link rel="stylesheet" href="plugin/ace/css/ace.min.css" />
    <link rel="stylesheet" href="plugin/ace/css/ace-rtl.min.css" />
</head>
<body class="login-layout">
<#if (errormsg!='1')>
    <div id="sysalert" class="alert alert-warning fade in">
        <button id='alert1' type="button" class="close" data-dismiss="alert"
                aria-hidden="true">&times;</button>
        ${errormsg!}
    </div>
</#if>
<div class="main-container">
<div class="main-content">
    <div class="row">
        <div class="col-sm-10 col-sm-offset-1">
            <div class="login-container">
                <div class="center">
                    <h1>
                        <i class="icon-leaf green"></i>
                        <span class="white">微信公众平台</span>
                    </h1>
                    <h4 class="blue">&copy; 后台登陆</h4>
                </div>
                <div class="space-6"></div>
                <div class="position-relative">
                    <div id="login-box" class="login-box visible widget-box no-border">
                        <div class="widget-body">
                            <div class="widget-main">
                                <h4 class="header blue lighter bigger">
                                    <i class="icon-coffee green"></i>
                                    请输入您的信息
                                </h4>
                                <div class="space-6"></div>
                                <form action="m/login" method="post">
                                    <fieldset>
                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="text" class="form-control" name="user_name" placeholder="用户名" />
															<i class="icon-user"></i>
														</span>
                                        </label>

                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="password" class="form-control" name="pwd" placeholder="密码" />
															<i class="icon-lock"></i>
														</span>
                                        </label>

                                        <div class="space"></div>

                                        <div class="clearfix">
                                            <label class="inline">
                                                <input type="checkbox" class="ace" />
                                                <span class="lbl"> 记住我</span>
                                            </label>

                                            <button type="submit" class="width-35 pull-right btn btn-sm btn-primary">
                                                <i class="icon-key"></i>
                                                登录
                                            </button>
                                        </div>

                                        <div class="space-4"></div>
                                    </fieldset>
                                </form>


                            </div><!-- /widget-main -->

                            <div class="toolbar clearfix">
                                <div>
                                    <a href="javascript:;" onclick="show_box('forgot-box'); return false;" class="forgot-password-link">
                                        <i class="icon-arrow-left"></i>
                                       找回密码
                                    </a>
                                </div>

                                <div>
                                    <#--<a href="javascript:;" onclick="show_box('signup-box'); return false;" class="user-signup-link">-->
                                    <a href="customer/initRegister"  class="user-signup-link">
                                       我想注册
                                        <i class="icon-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div><!-- /widget-body -->
                    </div><!-- /login-box -->

                    <div id="forgot-box" class="forgot-box widget-box no-border">
                        <div class="widget-body">
                            <div class="widget-main">
                                <h4 class="header red lighter bigger">
                                    <i class="icon-key"></i>
                                    找回密码
                                </h4>

                                <div class="space-6"></div>
                                <p>
                                    输入您的电子邮件地址和接收指令！
                                </p>

                                <form>
                                    <fieldset>
                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="email" class="form-control" placeholder="Email" />
															<i class="icon-envelope"></i>
														</span>
                                        </label>

                                        <div class="clearfix">
                                            <button type="button" class="width-35 pull-right btn btn-sm btn-danger">
                                                <i class="icon-lightbulb"></i>
                                                发送给我！
                                            </button>
                                        </div>
                                    </fieldset>
                                </form>
                            </div><!-- /widget-main -->

                            <div class="toolbar center">
                                <a href="javascript:;" onclick="show_box('login-box'); return false;" class="back-to-login-link">
                                    回到登录
                                    <i class="icon-arrow-right"></i>
                                </a>
                            </div>
                        </div><!-- /widget-body -->
                    </div><!-- /forgot-box -->

                    <div id="signup-box" class="signup-box widget-box no-border">
                        <div class="widget-body">
                            <div class="widget-main">
                                <h4 class="header green lighter bigger">
                                    <i class="icon-group blue"></i>
                                    新用户注册
                                </h4>

                                <div class="space-6"></div>
                                <p> 开始输入您的信息: </p>

                                <form>
                                    <fieldset>
                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="email" class="form-control" placeholder="Email" />
															<i class="icon-envelope"></i>
														</span>
                                        </label>

                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="text" class="form-control" placeholder="Username" />
															<i class="icon-user"></i>
														</span>
                                        </label>

                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="password" class="form-control" placeholder="Password" />
															<i class="icon-lock"></i>
														</span>
                                        </label>

                                        <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input type="password" class="form-control" placeholder="Repeat password" />
															<i class="icon-retweet"></i>
														</span>
                                        </label>

                                        <label class="block">
                                            <input type="checkbox" class="ace" />
														<span class="lbl">
															我同意
															<a href="javascript:;">用户协议</a>
														</span>
                                        </label>

                                        <div class="space-24"></div>

                                        <div class="clearfix">
                                            <button type="reset" class="width-30 pull-left btn btn-sm">
                                                <i class="icon-refresh"></i>
                                               撤销
                                            </button>

                                            <button type="button" class="width-65 pull-right btn btn-sm btn-success">
                                               注册
                                                <i class="icon-arrow-right icon-on-right"></i>
                                            </button>
                                        </div>
                                    </fieldset>
                                </form>
                            </div>

                            <div class="toolbar center">
                                <a href="javascript:;" onclick="show_box('login-box'); return false;" class="back-to-login-link">
                                    <i class="icon-arrow-left"></i>
                                  回到登录
                                </a>
                            </div>
                        </div><!-- /widget-body -->
                    </div><!-- /signup-box -->
                </div><!-- /position-relative -->
            </div>
        </div><!-- /.col -->
    </div><!-- /.row -->
</div>
</div><!-- /.main-container -->

<!-- basic scripts -->







<script src='plugin/ace/js/jquery-2.0.3.min.js'></script>
<script src='plugin/ace/js/jquery.mobile.custom.min.js'></script>
<!-- inline scripts related to this page -->
<script type="text/javascript">
    function show_box(id) {
        jQuery('.widget-box.visible').removeClass('visible');
        jQuery('#'+id).addClass('visible');
    }
</script>

</body>
</html>
