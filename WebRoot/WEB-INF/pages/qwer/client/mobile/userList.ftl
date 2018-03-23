<div id="user_list">
	<!-- 用户列表开始 -->
	<#list userList as item>
	<div class="row no-gutters align-items-center user-information" onclick="selectUser('${item.id}','${item.nickname!}','${item.phone_num_display!}');">
		<div class="col-3">
			<img class="user-avatar" src="${item.user_img_id}" onerror="imgLoad(this)"/>
		</div> 
		<div class="col-5">
		    ${item.nickname!}
		</div>
		<div class="col-4 user-phone text-right">
		   ${item.phone_num_display!}
		</div>
	</div>
	</#list>
</div>
<script>
	
function imgLoad(element){
    var imgSrc="resource/image/icon/user-avatar.jpg";
    $(element).attr("src",imgSrc);
  }
</script>