<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/> <@layout
scripts=["http://api.map.baidu.com/api?v=2.0&ak=SWZ3SdyjahAsTlbUMWFGrTxQ"] styles=[] >
<a id="modal-369895" href="#modal-table" role="button" class="btn"
	data-toggle="modal">新增 </a>
<div id="sample-table-2_filter" class="dataTables_filter">
	<form action="m/role/storeSearch" method="post">
		 Search:
        <select name="store_area">
            <option value="">全部</option>
            <#list store_areaAll as x>
                <option value="${(x.code_value)!}">${(x.code_name)!}</option>
            </#list>
        </select>
            <input type="text" name="msg"
			aria-controls="sample-table-2"> <input
			class="btn btn-xs btn-info" type="submit" value="查询" />

	</form>
</div>
<div id="modal-table" class="modal fade" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header no-padding">
				<div class="table-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">
						<span class="white">&times;</span>
					</button>
					新增店铺
				</div>
			</div>
			<div class="modal-body no-padding">
				<div class="page-content">
					<!-- /.page-header -->

					<div class="row">
						<div class="col-xs-12">
							<!-- PAGE CONTENT BEGINS -->

							<form class="form-horizontal" action="m/role/addStore"
								role="form" method="post" >
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										> 店名 </label>

									<div class="col-sm-9">
										<input type="text" id="store_name" name="store.store_name"
											placeholder="请输入店名" class="col-xs-10 col-sm-5" value="${(xx.store_name)!}" onblur="checkStoreName();"/> <span
                                            class="help-inline col-xs-12 col-sm-7"><span
											id="nameMsg" class="middle"></span>
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										> 地址 </label>

									<div class="col-sm-9">
										<input type="text" id="store_addr" name="store.store_addr"
											placeholder="" class="col-xs-10 col-sm-5" onblur="checkStoreAddr();"/> <span
											class="help-inline col-xs-12 col-sm-7"> <span
											id="addrMsg" class="middle"></span>
										</span>
									</div>
								</div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            > 商家描述 </label>

                                    <div class="col-sm-9">
                                        <textarea id="store_description" name="store.store_description"
                                                  placeholder="请输入公司描述内容" class="col-xs-10 col-sm-5" ></textarea> <span
                                            id="decMsg" class="middle"></span>
                                    </div>
                                </div>
								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										> 负责人 </label>

									<div class="col-sm-9">
										<input type="text" name="store.head_preson"
											class="col-xs-10 col-sm-5" id="head_preson" onblur="checkStorePreson();"/> <span
											class="help-inline col-xs-12 col-sm-7"> <span
											id="presonMsg" class="middle"></span>
										</span>
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										>联系电话</label>

									<div class="col-sm-4">
										<input class="input-sm" type="text" name="store.tel" id="tel"
											/><!--placeholder="0731-" onblur="checkSubmitMobil();" -->
									</div>
                                    <span
                                            id="telmsg" class="middle"></span>
								</div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right">所属区域</label>

                                    <div class="col-sm-4">
                                        <div class="clearfix">
                                            <select id="store_type" name="store.store_area"
                                                    class="form-control">
                                                <#list store_areaAll as x>
                                                     <option value="${(x.code_value)!}">${(x.code_name)!}</option>
                                                </#list>
                                            </select>
                                        </div>
                                    </div>
                                </div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right">所属公司</label>

									<div class="col-sm-4">
										<div class="clearfix">
											<select id="form-field-select-1" name="store.corp_id"
												class="form-control">
												<option value="80">无</option> <#list corpAll as c>
												<option value="${c.id}">${c.corp_name}</option> </#list>
											</select>
										</div>
									</div>
								</div>
								<div class="space-4"></div>
								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="submit"
											onclick="return checkAll();">
											<i class="icon-ok bigger-110"></i> 提交
										</button>
										&nbsp; &nbsp; &nbsp;
										<button class="btn" type="reset">
											<i class="icon-undo bigger-110"></i> 重置
										</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="Modify" class="modal fade" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header no-padding">
				<div class="table-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">
						<span class="white">&times;</span>
					</button>
					修改信息
				</div>
			</div>
			<div class="modal-body no-padding">
				<div class="page-content">
					<!-- /.page-header -->

					<div class="row">
						<div class="col-xs-12">
							<!-- PAGE CONTENT BEGINS -->

							<form class="form-horizontal" action="m/role/modifyStore"
								role="form" method="post">
								<input type="hidden" name="store.id" id="store_id" />
								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										> 店名 </label>

									<div class="col-sm-9">
										<input type="text" id="modify_store_name" name="store.store_name"
											placeholder="请输入店名" class="col-xs-10 col-sm-5" readonly/> <span
											id="nameModifyMsg" class="middle" ></span>
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										> 地址 </label>

									<div class="col-sm-9">
										<input type="text" id="modify_store_addr" name="store.store_addr"
											placeholder="" class="col-xs-10 col-sm-5" onblur="checkStoreAddr();" /> <span
											class="help-inline col-xs-12 col-sm-7"> <span
											id="addrModifyMsg" class="middle"></span>
										</span>
									</div>
								</div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right"
                                            > 商家描述 </label>

                                    <div class="col-sm-9">
                                        <textarea id="modify_store_description" name="store.store_description"
                                                  placeholder="请输入公司描述内容" class="col-xs-10 col-sm-5" ></textarea> <span
                                            id="decMofigyMsg" class="middle"></span>
                                    </div>
                                </div>
								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										> 负责人 </label>

									<div class="col-sm-9">
										<input type="text" id="modify_head_preson" name="store.head_preson"
											class="col-xs-10 col-sm-5" /> <span
											class="help-inline col-xs-12 col-sm-7"> <span
											id="presonModifyMsg" class="middle"></span>
										</span>
									</div>
								</div>

								<div class="space-4"></div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right"
										>联系电话</label>

									<div class="col-sm-4">
										<input class="input-sm" type="text"  name="store.tel" id="modify_tel"/>
											<!--placeholder="0731-"-->
									</div>
                                    <span id="telModifymsg" class="middle"></span>
								</div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no-padding-right">所属区域</label>

                                    <div class="col-sm-4">
                                        <div class="clearfix">
                                            <select id="modify_store_type" name="store.store_area"
                                                    class="form-control">
                                                <#list store_areaAll as x>
                                                    <option value="${(x.code_value)!}">${(x.code_name)!}</option>
                                                </#list>
                                            </select>
                                        </div>
                                    </div>
                                </div>

								<div class="form-group">
									<label class="col-sm-3 control-label no-padding-right">所属公司</label>

									<div class="col-sm-4">
										<div class="clearfix">
											<select id="modify_corp_id" name="store.corp_id"
												class="form-control">
											<#list corpAll as c>
												<option value="${c.id}">${c.corp_name}</option> </#list>
											</select>
										</div>
									</div>
								</div>
								<div class="space-4"></div>
								<div class="clearfix form-actions">
									<div class="col-md-offset-3 col-md-9">
										<button class="btn btn-info" type="submit" onclick="return checkModify();"
											>
											<i class="icon-ok bigger-110"></i> 提交
										</button>
										&nbsp; &nbsp; &nbsp;
										<button class="btn" type="reset">
											<i class="icon-undo bigger-110"></i> 重置
										</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="table_box">
	<table
		class="table table-bordered table-striped table-condensed  table-hover">
		<thead>
			<tr>
				<th>店名</th>
				<th>地址</th>
				<th>负责人</th>
				<th>联系电话</th>
                <!--<th>坐标</th>-->
                <th> 所属区域</th>
				<th>所属公司</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		
			<#list storePage.getList() as x>
			<form action="m/role/deleteStore" method="post">
			<tr class="myclass">
				<td  style="text-align: center;" hidden="true">${(x.id)}</td>
				<td  style="text-align: center;">${(x.store_name)!}</td>
				<td  style="text-align: center;">${(x.store_addr)!}</td>
				<td  style="text-align: center;">${(x.head_preson)!}</td>
				<td  style="text-align: center;">${(x.tel)!}</td>
				<!--<td  style="text-align: center;">${(x.map_index)!}</td>-->
                <td  style="text-align: center;">${(x.store_areaa)!}</td>
				<td  style="text-align: center;"><a href="m/role/showCorp?id=${(x.corp_id)}" style="text-decoration:none;color:#000000">${(x.corp_name)!}</a></td>
				<td  style="text-align: center;">&nbsp;&nbsp;
				<input type="hidden" name="delete_id"value="${(x.id)}"/>
					<button 
						class="btn btn-xs btn-danger"
						onclick='return confirm("你确定删除${(x.store_name)!}?");'>
						<i class="icon-trash bigger-120"></i>
						</form>
					</button> &nbsp;&nbsp;
					<button id="modify"
						href="#Modify"
						role="button" data-toggle="modal" class="btn btn-xs btn-info" onclick="return modify(${x.id});">
						<i class="icon-edit bigger-120"></i>
					</button>
					<a href="m/role/setMap?id=${x.id}&dz=${x.store_name}&point=${(x.map_index)!}">
					设置
					</a>
					</td>
			</tr>
			</#list>
		</tbody>
	</table>
	<#include "/WEB-INF/pages/common/_paginate.html" /> <@paginate
	currentPage=storePage.pageNumber totalPage=storePage.totalPage
	actionUrl="/m/role/storeList/" />
</div>

</@layout>
<script type="text/javascript">
function modify(id) {
	 $.ajax({ // 一个Ajax过程
		type : "post", // 以post方式与后台沟通
		url : "/m/role/toModifyStore",
		dataType : 'json',// 
		data : {
			id:id
		},
		success : function(json) {
			$("#store_id").val(json.mm.id);
			$("#modify_store_name").val(json.mm.store_name);
			$("#modify_store_addr").val(json.mm.store_addr);
            $("#modify_store_area").val(json.mm.store_area);
			$("#modify_head_preson").val(json.mm.head_preson);
			$("#modify_tel").val(json.mm.tel);
			$("#modify_corp_id").val(json.mm.corp_id);
			$("#modify_store_description").val(json.mm.store_description);

		},
		error : function(json) {
			alert("error");
			
		}
	}) 
}

function setMap(id) {
	$.ajax({ // 一个Ajax过程
		type : "post", // 以post方式与后台沟通
		url : "/m/test/setMap",
		dataType : 'json',// 
		data : {
			id:id
		},
		success : function(json) {
			//alert(json);
		},
		error : function(json) {
			alert("error");
			
		}
	})
}
	function checkSubmitMobil() {
		if ($("#tel").val() == "") {
			$("#telmsg").html("<font color='red'>手机号码不能为空！</font>");
			$("#tel").focus();
		} else if (!$("#tel").val().match(/^1[3|4|5|8][0-9]\d{4,8}$/)) {
			$("#telmsg").html("<font color='red'>手机号码格式不正确！请重新输入！</font>");
			$("#tel").focus();
		} else {
			$("#telmsg").html(" ");
		}
	}
	function checkStoreName(){
		var name=$("#store_name").val();
		if (name == "") {
			$("#nameMsg").html("<font color='red'>店铺名不能为空！</font>");
			$("#store_name").focus();
		} else {
			$.ajax({ // 一个Ajax过程
				type : "post", // 以post方式与后台沟通
				url : "/m/role/checkStoreName",
				dataType : 'json',// 
				data : {
					name:name
				},
				success : function(json) {
					if(json.store==null){
						$("#nameMsg").html(" ");
					}else{
						$("#nameMsg").html("<font color='red'>店铺名已经注册，不能重复 ！</font>");
					}
				},
				error : function(json) {
					alert("error");
					$("#nameMsg").html("<font color='red'>网络错误，请重试  ！</font>");
				}
			});
		}
	}
	function checkStoreAddr(){
		if ($("#store_addr").val() == "") {
			$("#addrMsg").html("<font color='red'>地址不能为空！</font>");
		} else {
			$("#addrMsg").html(" ");
		}
	}
	function checkStorePreson(){
		if ($("#head_preson").val() == "") {
			$("#presonMsg").html("<font color='red'>负责人不能为空！</font>");
		} else {
			$("#presonMsg").html(" ");
		}
	}
	function checkAll(){
		var nameMsg=$("#nameMsg").html();
		var addrMsg=$("#addrMsg").html();
		var presonMsg=$("#presonMsg").html();
		if(" "==nameMsg&&" "==addrMsg&&" "==presonMsg){
			return true
		}else{
		return false;
		}
	}
	function checkModifyStoreName(){
		if ($("#modify_store_name").val() == "") {
			$("#nameModifyMsg").html("<font color='red'>店铺名不能为空！</font>");
			return false;
		}else {
			var name=$("#modify_store_name").val();
			$.ajax({ // 一个Ajax过程
				type : "post", // 以post方式与后台沟通
				url : "/m/role/checkStoreName",
				dataType : 'json',// 
				data : {
					name:name
				},
				success : function(json) {
					if(json.store==null){
						$("#nameModifyMsg").html(" ");
					}else{
						$("#nameModifyMsg").html("<font color='red'>店铺名已经注册，不能重复 ！</font>");
						return false;
					}
				},
				error : function(json) {
					$("#nameModifyMsg").html("<font color='red'>网络错误，请重试  ！</font>");
					return false;
				}
			});
		} 
	}
	
	function checkModify() {
		/*if ($("#modify_tel").val() == "") {
			$("#telModifymsg").html("<font color='red'>手机号码不能为空！</font>");
			$("#modify_tel").focus();
			return false;
		}else if(!$("#modify_tel").val().match(/^1[3|4|5|8][0-9]\d{4,8}$/)){
			$("#telModifymsg").html("<font color='red'>手机号码格式不正确！请重新输入！</font>");
			$("#modify_tel").focus();
			return false;
		}else{
			$("#telModifymsg").html("");
		}*/
		
		if ($("#modify_store_addr").val() == "") {
			$("#addrModifyMsg").html("<font color='red'>地址不能为空！</font>");
			$("#modify_store_addr").focus();
			return false;
		} else {
			$("#addrModifyMsg").html(" ");
		}

		if ($("#modify_head_preson").val() == "") {
			$("#presonModifyMsg").html("<font color='red'>负责人不能为空！</font>");
			$("#modify_head_preson").focus();
			return false;
		} else {
			$("#presonModifyMsg").html(" ");
		}

		return true;
	}
	
</script>
