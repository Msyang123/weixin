<!DOCTYPE html>
<html>
<head>
<title>水果熟了</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="水果熟了-个人信息" />
<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body>
<div data-role="page" class="my-detial">
		<div class="orderhead">
			<div class="btn-back">
				<a onclick="back();"><img height="20px"
					src="resource/image/icon/icon-back.png" /></a>
			</div>
			<div class="commit" onclick="fbCommit()"><img height="25px" src="resource/image/icon/tijiaofankui.png" /></div>
			<div>个人信息</div>
		</div>
	<div data-role="main" class="info-box">	
		<form method="post" id="userForm" action="${CONTEXT_PATH}/userModifyCmt"  data-ajax="false">
	      <div>
	      <table style="width: 100%;border-collapse:collapse;">
			<tr>
				<td class="info-name">昵称：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;">
				<input type="text" readonly="readonly" value="${user.nickname!}">
				</td>
			</tr>
			<tr>
				<td class="info-name">真实姓名：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;">
				<input type="text" name="tUser.realname" id="realname" placeholder="你的姓名.." value="${user.realname!}">
				</td>
			</tr>
			<tr>
				<td class="info-name">QQ：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;">
				<input type="text" name="tUser.qq" id="qq" placeholder="你的qq号码.." value="${user.qq!}">
				</td>
			</tr>
			<tr>
				<td class="info-name">生日：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;">
                    <input type="date" name="tUser.birthday" id="birthday" class="form-control" placeholder="生日">
				</td>
			</tr>
			<tr>
				<td class="info-name">E-mail：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;">
				<input type="email" name="tUser.email" id="email"  placeholder="你的电子邮箱.." value="${user.email!}">
				</td>
			</tr>
			<tr>
				<td class="info-name">个人说明：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;">
				<textarea name="tUser.personal_info" id="personal_info">${user.personal_info!}</textarea>
				</td>
			</tr>
			<tr>
				<td class="info-name">注册时间：</td>
				<td>&nbsp;</td>
				<td style="padding-right:10px;"><input placeholder="${user.regist_time!}" data-mini="true" readonly="readonly"/></td>
			</tr>
		  </table>
	      </div>
	      <input type="hidden" name="tUser.id" value="${user.id}" />
	    </form>	
	</div>
</div>
<#include "/WEB-INF/pages/common/share.ftl"/>	
<script type="text/javascript">
 	function back(){
 		window.history.back();
 	}
 	
 	function fbCommit(){
 		$("#userForm").submit();
 	}
</script>
</body>
</html>