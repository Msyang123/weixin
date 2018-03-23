<#macro layout scripts styles >
<!DOCTYPE html>
<html lang="en">
	<head>
		<base href="${CONTEXT_PATH}/"/>
		<meta charset="utf-8" />
		<title>微信公众平台后台管理系统</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta name="description" content="水果熟了微信公众平台后台管理系统，致力成为国内领先的智能，人性化食物获取平台。公司拥有鲜果品牌连锁经营经验积累近二十年，在湖南省内拥有广泛、深厚的资源支持，并逐步建立了果品采购、运输、储藏、销售、物联网改造等各个重要环节的标准化运作体系和操作手册。并将于本年度内启动大品牌战略，注册母体公司湖南绿航物联网控股集团有限公司（品牌生态主体），成立供应链品牌（深耕供应链服务）、物联网电商品牌（APP在线平台）、人才培养品牌（绿航商学院）等生态链子品牌，与连锁品牌（水果熟了）相呼应，形成鲜果领域物联网生态集团" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="plugin/ace/css/bootstrap.min.css" />
		<link rel="stylesheet" href="resource/css/font-awesome.min.css" />
	
		<!-- page specific plugin styles -->
		<!-- text fonts -->
		<link rel="stylesheet" href="plugin/ace/css/ace-fonts.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="plugin/ace/css/jquery-ui-1.10.3.full.min.css" />
        <link rel="stylesheet" href="plugin/ace/css/datepicker.css"/>
        <link rel="stylesheet" href="plugin/ace/css/ui.jqgrid.css"/>
		<link rel="stylesheet" href="plugin/ace/css/ace.min.css" id="main-ace-style" />

		<!--[if lte IE 9]>
			<link rel="stylesheet" href="plugin/ace/css/ace-part2.min.css" />
		<![endif]-->
		<link rel="stylesheet" href="plugin/ace/css/ace-skins.min.css" />
		<link rel="stylesheet" href="plugin/ace/css/ace-rtl.min.css" />

		<!--[if lte IE 9]>
		  <link rel="stylesheet" href="plugin/ace/css/ace-ie.min.css" />
		<![endif]-->

		<!-- inline styles related to this page -->
		<link rel="stylesheet" href="plugin/kindeditor-4.1.10/themes/default/default.css" />
		<link rel="stylesheet" href="plugin/artDialog-7.0.0/css/dialog.css" />
		
		<#list styles as item >
		<link rel="stylesheet" href="${(item)! }" />
		</#list>
        <link rel="stylesheet" href="resource/css/backend.css" />
		<!-- ace settings handler -->
		<script src="plugin/ace/js/ace-extra.min.js"></script>
		<script src="plugin/My97DatePicker/WdatePicker.js"></script>
		<script src="plugin/kindeditor-4.1.10/kindeditor-all.js"></script>
		<script src="plugin/kindeditor-4.1.10/lang/zh_CN.js"></script>
		<script src="plugin/kindeditor-4.1.10/plugins/code/prettify.js"></script>
		<script src="plugin/kindeditor-4.1.10/kindeditor.js"></script>
		
		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='plugin/ace/js/jquery.min.js'>"+"<"+"/script>");
		</script>
		<!-- <![endif]-->

		<!--[if IE]>
		<script type="text/javascript">
		 window.jQuery || document.write("<script src='plugin/ace/js/jquery1x.min.js'>"+"<"+"/script>");
		</script>
        <![endif]-->
        
        <script src="plugin/ace/js/bootstrap.min.js"></script>
        
        <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
		<!--[if lt IE 9]>
		<script src="plugin/ace/assets/js/html5shiv.js"></script>
		<script src="plugin/ace/assets/js/respond.min.js"></script>
		<![endif]-->
	</head>

	<body class="no-skin">
		<!-- #section:basics/navbar.layout -->
		<div id="navbar" class="navbar navbar-default">
			<script type="text/javascript">
				try{ace.settings.check('navbar' , 'fixed')}catch(e){}
			</script>

			<div class="navbar-container" id="navbar-container">
				<div class="navbar-header pull-left">
					<a href="m/start" class="navbar-brand">
						<small>
							<i class="icon-leaf"></i>
							微信公众平台后台管理系统
						</small>
					</a><!-- /.brand -->
				</div><!-- /.navbar-header -->

				<!-- #section:basics/navbar.dropdown -->
				<div class="navbar-buttons navbar-header pull-right" role="navigation">
					<ul class="nav ace-nav" style="padding-right:80px;">
						<!-- #section:basics/navbar.user_menu -->
						<li class="light-blue">
							<a data-toggle="dropdown" href="javascript:;" class="dropdown-toggle">
								<!-- <img class="nav-user-photo" src="plugin/ace/avatars/user.jpg" alt="Jason's Photo" /> -->
								<span class="user-info">
									<small>欢迎</small>
									<#if session?? && session['sessionUser']??> 
										${session['sessionUser'].real_name!}
									<#else>
										<script type="text/javascript">
											window.location.href="${app_domain}/m/index";
										</script>	
									</#if>
								</span><span class="caret"></span>
							</a>

							<ul class="user-menu pull-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
								<li>
									<a href="javascript:;">
										设置
									</a>
								</li>
								<li>
									<#if session??> 
										<a href="m/role/toModifyPwd?id=${session['sessionUser'].id!}">
											修改密码
										</a>
									</#if>	
								</li>
								<li class="divider"></li>
								<li>
									<a href="m/logout">
										退出
									</a>
								</li>
							</ul>
						</li>
						<!-- /section:basics/navbar.user_menu -->
					</ul>
				</div>

				<!-- /section:basics/navbar.dropdown -->
			</div><!-- /.navbar-container -->
		</div>

		<!-- /section:basics/navbar.layout -->
		<div class="main-container" id="main-container">
			<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
			</script>

			<!-- #section:basics/sidebar -->
			<div id="sidebar" class="sidebar responsive">
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
				</script>

				<div class="sidebar-shortcuts" id="sidebar-shortcuts">
					<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
						<button class="btn btn-success">
							<i class="ace-icon fa fa-signal"></i>
						</button>

						<button class="btn btn-info">
							<i class="ace-icon fa fa-pencil"></i>
						</button>

						<!-- #section:basics/sidebar.layout.shortcuts -->
						<button class="btn btn-warning">
							<i class="ace-icon fa fa-users"></i>
						</button>

						<button class="btn btn-danger">
							<i class="ace-icon fa fa-cogs"></i>
						</button>

						<!-- /section:basics/sidebar.layout.shortcuts -->
					</div>

					<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
						<span class="btn btn-success"></span>

						<span class="btn btn-info"></span>

						<span class="btn btn-warning"></span>

						<span class="btn btn-danger"></span>
					</div>
				</div><!-- /.sidebar-shortcuts -->

				<#if session??>
                    ${session['sessionMenu']}
                </#if><!-- /.nav-list -->

				<!-- #section:basics/sidebar.layout.minimize -->
				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>
				<!-- /section:basics/sidebar.layout.minimize -->
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
				</script>
			</div>

			<!-- /section:basics/sidebar -->
			<div class="main-content">
				<!-- #section:basics/content.breadcrumbs -->
				<div class="breadcrumbs" id="breadcrumbs">
					<script type="text/javascript">
						try{ace.settings.check('breadcrumbs' , 'fixed')}catch(e){}
					</script>

					<ul class="breadcrumb">
						<li>
								<i class="icon-home home-icon"></i>
								<a href="m/start">首页</a>
							</li>

							<li class="active"><#if sessionNav??> ${sessionNav} <span
								class="divider"></span> <#else><span
								class="divider"></span> </#if>
							</li>
					</ul><!-- /.breadcrumb -->

					<!-- #section:basics/content.searchbox -->
					<!--<div class="nav-search" id="nav-search">
						<form class="form-search">
							<span class="input-icon">
								<input type="text" placeholder="Search ..." class="nav-search-input" id="nav-search-input" autocomplete="off" />
								<i class="ace-icon fa fa-search nav-search-icon"></i>
							</span>
						</form>
					</div>--><!-- /.nav-search -->

					<!-- /section:basics/content.searchbox -->
				</div>

				<!-- /section:basics/content.breadcrumbs -->
				<div class="page-content">
					<div class="row">
							<div class="col-xs-12 nopd-lr">
								<!-- PAGE CONTENT BEGINS -->
								<#if (errormsg!='1')>
									<div id="sysalert" class="alert alert-warning fade in">
										<button id='alert1' type="button" class="close" data-dismiss="alert"
											aria-hidden="true">&times;</button>
										${errormsg!}
									</div>
								</#if>
								<#if session??> <#nested> </#if>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
				</div><!-- /.page-content -->
			</div><!-- /.main-content -->

			<div class="footer">
				<div class="footer-inner">
					<!-- #section:basics/footer -->
					<div class="footer-content">
						<span class="bigger-120">
							<span class="blue bolder">水果熟了</span>
							Application &copy; 2017
						</span>

						&nbsp; &nbsp;
						<span class="action-buttons">
							<a href="javascript:;">
								<i class="ace-icon fa fa-twitter-square light-blue bigger-150"></i>
							</a>

							<a href="javascript:;">
								<i class="ace-icon fa fa-facebook-square text-primary bigger-150"></i>
							</a>

							<a href="javascript:;">
								<i class="ace-icon fa fa-rss-square orange bigger-150"></i>
							</a>
						</span>
					</div>

					<!-- /section:basics/footer -->
				</div>
			</div>

			<a href="javascript:;" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
			</a>
		</div><!-- /.main-container -->
		<!-- basic scripts -->

		
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='plugin/ace/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		
		<!-- ace scripts -->
		<script src="plugin/ace/js/ace-elements.min.js"></script>
		<script src="plugin/ace/js/ace.min.js"></script>
		
        <!--Common JS-->
        <script src="plugin/ace/js/bootstrap.min.js"></script>
        <script src="plugin/ace/js/date-time/bootstrap-datepicker.min.js"></script>
        <script src="plugin/ace/js/uncompressed/jqGrid/jquery.jqGrid.src.js"></script>
        <script src="plugin/ace/js/jqGrid/i18n/grid.locale-en.js"></script>
        <script src="plugin/jquery.mobile-1.4.2/juqery.mobile-1.4.2.alert.js"></script>
        
        <script src="plugin/jquery-validation-1.17.0/jquery.validate.min.js"></script>
		<script src="plugin/jquery-validation-1.17.0/localization/messages_zh.js"></script>
		
		<!-- artdialog plugin-->
		<script src="plugin/artDialog-7.0.0/dist/dialog.js"></script>
		<script src="plugin/artDialog-7.0.0/dist/artdialog.min.js"></script>
		<script src="plugin/echarts-3.6.1/echarts.min.js"></script>
		
		<!--Custome Js-->
		<script src="resource/scripts/common.grids.js"></script>
		<script src="resource/scripts/common.opreation.js"></script>
		
		<#list scripts as item >
		<script src="${(item)!}"></script>
		</#list>
	</body>
</html>
</#macro>
