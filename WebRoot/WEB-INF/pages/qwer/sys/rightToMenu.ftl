 <#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
  <div class="row">
    <div class="col-xs-12 col-sm-5">
      <div class="control-group"> <#list roles as r >
        <label class="control-label bolder blue"></label>
        <div class="radio">
          <label>
            <input class="ace" name="role" id="role" type="radio" value="" onclick="tt(${r.id},'${r.role_desc}');" />
            <span class="lbl"></span>${r.role_desc} </label>
        </div>
        </#list> </div>
    </div>
    <div class="col-xs-12 col-sm-6">
      <div class="control-group">
        <label class="control-label bolder blue"></label>
        <form action="m/role/saveRightToMenu" method="post">
          <input id="roleid" name="roleid" type="hidden" value="" >
          <label>当前操作角色
            <input id="ss" name="rolename"  value="" />
          </label>
          <!-- --------------菜单树开始------------ --> 
          <div id="menuTree">
          </div>
          <input type="submit" value="提交" class="btn btn-primary"/>
        </form>
      </div>
    </div>
  </div>
</@layout>
<script type="text/javascript">

function tt(id,name){
	document.getElementById("ss").value=name;
	document.getElementById("roleid").value=id;
	ajaxTree(id);
	/* $("#ss").text=name;
	$("#roleid").val=id; */
	//document.getElementById("menuTree").innerHTML = "";
}
function ajaxTree(id){
	document.getElementById("menuTree").innerHTML = "";
	$.ajax({ // 一个Ajax过程
		type : "post", // 以post方式与后台沟通
		url : "/m/role/rightToMenu",
		dataType : 'json',// 
		data : {
			role_id : id,
		},
		success : function(json) {

			var data = json.list;
			var ss = "";
			
			for(var i=0; i<data.length; i++){
                
              	//alert(data[i].id);
              	
              	ss += "<div class='checkbox'>";
              	ss += "<label>";
              	ss += "<input class='ace' type='checkbox' name='menuid' value='"+ data[i].id +"'";
              	if(data[i].chk != '0'){
              		ss += " checked='checked' "
              	}
              	ss += " /> ";
              	ss += "<span class='lbl'></span>"+data[i].menu_name+"</label></div>";
            }  
			document.getElementById("menuTree").innerHTML = ss;
		},
		error : function(json) {
			alert("error");

		}
	})
}
</script>