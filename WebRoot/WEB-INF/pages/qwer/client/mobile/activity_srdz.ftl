<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-私人定制" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
	<div data-role="page" id="srdz">
		<div class="back">
			<a onclick="back();"><img height="20px"
				src="resource/image/icon/icon-back.png" /></a>
	    </div>
		<div data-role="main">
			<div id="content">
				<div class="xnxg">
					<img src="resource/image/activity/srdz/私人定制详情01.jpg" />
					<img src="resource/image/activity/srdz/私人定制详情02.jpg" />
					<img src="resource/image/activity/srdz/私人定制详情03.jpg" />
					<img src="resource/image/activity/srdz/私人定制详情04.jpg" />
				</div>
			</div>
			<div class="box-29" style="top:37%;left:5%;" onclick="viewDetail('A')"></div>
			<div class="box-29" style="top:37%;left:36%;" onclick="viewDetail('B')"></div>
			<div class="box-29" style="top:37%;left:67%;" onclick="viewDetail('C')"></div>
			<div class="box-29" style="top:47%;left:5%;" onclick="viewDetail('D')"></div>
			<div class="box-29" style="top:47%;left:36%;" onclick="viewDetail('E')"></div>
			<div class="box-29" style="top:47%;left:67%;" onclick="viewDetail('F')"></div>
			<div class="box-29" style="top:58%;left:5%;" onclick="viewDetail('G')"></div>
			<div class="box-29" style="top:58%;left:36%;" onclick="viewDetail('H')"></div>
			<div class="box-29" style="top:58%;left:67%;" onclick="viewDetail('I')"></div>
			<div class="box-29" style="top:68%;left:5%;" onclick="viewDetail('J')"></div>
			<div class="box-29" style="top:68%;left:36%;" onclick="viewDetail('K')"></div>
			<div class="box-29" style="top:68%;left:67%;" onclick="viewDetail('L')"></div>
			<div class="box-29" style="top:78%;left:5%;" onclick="viewDetail('M')"></div>
			<div class="box-29" style="top:78%;left:36%;" onclick="viewDetail('N')"></div>
			<div class="box-29" style="top:78%;left:67%;" onclick="viewDetail('O')"></div>
			<div class="box-29" style="top:88%;left:5%;" onclick="viewDetail('P')"></div>
		</div>
	</div>
	<div data-role="page" id="tc">
		<div class="back">
		    <a href="#srdz"><img height="20px" src="resource/image/icon/icon-back.png" /></a>
	    </div>
		<img id="tcImg" style="width:100%;" src="resource/image/activity/srdz/A.png">
	</div>
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script type="text/javascript">
		function back(){
	 		window.location.href="${CONTEXT_PATH}/main?index=0";
	 	}
		
		function viewDetail(tc){
			$("#tcImg").attr("src","resource/image/activity/srdz/"+tc+".png");
			$.mobile.changePage("#tc");
		}
   </script>
</body>
</html>