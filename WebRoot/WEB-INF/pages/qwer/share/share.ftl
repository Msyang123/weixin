<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>
<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-left">
		    <input class="form-control" name="template-name" type="text" placeholder="模板名称"/>
		    <button class="form-control" type="button">
		        <i class="fa fa-search bigger-110"></i> 搜索    
		    </button> 
	    </div>
	    
	    <div class="pull-right">	    	   
		    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" data-target="#editModal">
			    <i class="fa fa-plus bigger-110"></i> 添加
			</button>
			<button class="btn btn-danger btn-sm" type="button">
			    <i class="fa fa-close bigger-110"></i> 删除
			</button>
		</div>
	</form>
</div>

<div class="col-xs-12 pbb80">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

<!--查看详情Model-->
<div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel" aria-hidden="true">
   <div class="modal-dialog" role="document">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">查看分享模板</h4>
         </div>
	     <div class="modal-body">
	      	    <div class="form-horizontal detail-form">
					  <div class="form-group">
	                        <label class="col-md-3">模板名称 ：</label>
					        <div class="col-md-9 activity-name">aaaaa</div> 
					  </div>  				     
					  <div class="form-group">
	                        <label class="col-md-3">指定页面 ：</label>
					        <div class="col-md-9 pages">aaaaaaa</div> 
					  </div> 
					  <div class="form-group">
	                        <label class="col-md-3">分享标题 ：</label>
					        <div class="col-md-9 share-title">aaaaa</div> 
					  </div>  				     
					  <div class="form-group">
	                        <label class="col-md-3">分享内容 ：</label>
					        <div class="col-md-9 share-desc">aaaaaaa</div> 
					  </div> 
					  <div class="form-group">
	                        <label class="col-md-3">分享图片：</label>
					        <div class="col-md-9">
					            <input type="hidden" class="share-img" value="" />
						        <img id="preview" class="col-md-2 nopd-lr img-responsive" src=""/>
					        </div> 
					  </div>
				</div>
	      </div>
       </div>
   </div>
</div>

<!--添加和编辑Model-->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
   <div class="modal-dialog" role="document">
      <div class="modal-content" style="width: 750px;">
	      <div class="modal-header">
	           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	           <h4 class="modal-title">编辑分享模板</h4>
	      </div>
	      <div class="modal-body text-center rows clearfix">
	           	<form id="share_form" method="Post" class="form-horizontal col-md-7">
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">模板名称：</label>
				         <div class="col-md-8"><input type="text" class="form-control" id="template_name" name="template_name"></div> 
				     </div>   
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">页面类型：</label>
				         <div class="col-md-8">
						 	<select id="page_type" class="form-control" onchange="typeChange()" name="page_type">
		                    	  <option value="0">基础页面</option>
		                    	  <option value="1">商品详情页</option>
		                    	  <option value="2">拼团商品详情页</option>
		                    	  <option value="3">商品列表页</option>
		                    	  <option value="4">拼团商品列表页</option>
		                    	  <option value="5">拼团等待页</option>
		                    	  <option value="6">其他页面</option>
					         </select>
						 </div> 
				     </div> 
				     <div class="form-group page_url_box" hidden>
	                     <label class="col-md-3 text-right nopd-lr">url：</label>
				         <div class="col-md-8"><input type="text" class="form-control" id="page_url" name="page_url"></div> 
				     </div> 
				     <hr>
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">分享标题：</label>
				         <div class="col-md-8"><input type="text" class="form-control" id="share_title" placeholder="最多输入15字，请注意" maxlength="15" name="share_title"></div> 
				     </div> 
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">分享内容：</label>
				         <div class="col-md-8">
				         	<textarea class="form-control" id="share_content" placeholder="最多输入40字，请注意" rows="4" maxlength="40" name="share_content"></textarea>
				         </div> 
				     </div> 
				     <div class="form-group">
				         <label class="col-sm-3 text-right nopd-lr">分享图片：</label>
				         <div class="col-sm-8">
				         	  <input type="text" placeholder="使用模版填写右侧字符串" class="col-md-8">
					          <input type="hidden" id="image_src" name="image_src" value="" name="image_src"/>
					          <input type="hidden" id="image_id" name="" value=""/>
					          
							  <input type="button" id="image" value="选择图片" class="col-md-4 nopd-lr btn btn-sm btn-info"/>
				         </div>
				 	 </div>
				 	 <div class="form-group">
				         <label class="col-sm-3 text-right nopd-lr">图片预览：</label>
				         <div class="col-sm-8 text-left">
					         <img id="url2" width="35%"/>
				         </div>
				    </div>
				</form>
				<div class="col-md-5 text-left bg-text">
					该指定页面类型可使用以下字符串<br/>
					<div class="normal-fieldname">
						@Username;   用户名<br/>
						@time;   系统时间<br/>
						@address;   地址<br/><br/>
					</div>
					<div class="pro-fieldname" hidden>
						@Username;   用户名<br/>
						@merchandise;   商品名称<br/>
						@specification;   商品规格<br/>
						@unit;   售卖单位<br/>
						@price;   商品价格<br/>
						@time;   系统时间<br/>
						@address;   地址<br/>
						@picture;   商品图片<br/><br/>
					</div>
					编写案例<br/>
					如：（分享某商品详情）<br/>
					分享标题：XXX为你推荐<br/>
					分享内容：火龙果只需￥17.6/盒，你还在等什么？<br/>
					分享图片：商品图片<br/><br/>
					
					后台模版编写时输入<br/>
					分享标题：@Username;为你推荐<br/>
					分享内容：@merchandise;只需@price;/@unit;，你还在等什么<br/>
					分享图片：@picture;<br/>
					分享模版需带出指定图片时请上传，上传图片需小于32K。否则无法上传
					<div class="btn-box pd10 text-center">
						<button type="button" class="btn btn-warning btn-sm" data-toggle="modal" data-target="#rulesModal">查看详细编写规则</button>
					</div>
				</div>
	        </div>
	        <div class="modal-footer justify-content-center">
	            <button type="button" class="btn btn-default btn-sm btn-cancel" data-dismiss="modal" id="btn-cancel">取消</button>
	            <button type="button" class="btn btn-info btn-sm btn-confirm" id="btn-confirm">确认</button>
	        </div>
       </div>
   </div>
</div>

<!--编写规则Model-->
<div class="modal fade" id="rulesModal" tabindex="-1" role="dialog" aria-labelledby="rulesModalLabel" aria-hidden="true">
   <div class="modal-dialog" role="document">
       <div class="modal-content" style="width: 750px;">
          <div class="modal-header">
             <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
             <h4 class="modal-title">分享模版编写规则</h4>
          </div>
	      <div class="modal-body">
				<p>1.每个指定页面类型（除去其他页面类型）仅能存在一个模版，不能给单一指定页面重复添加模版</p>
				<p>2.基础页面类型为基础的分享模版，适用于所有页面（即页面未设置特殊的分享模版时，则使用这个分享模版）</p>
				<p>3.选择其他页面类型时需输入URL来确定页面，若不输入，则无法保存，其他页面可同时存在多个</p>
				<p>4.编写分享模版时，字段信息可用特定字符串代替，目前存在的特定字符串如下：<br/>
				@Username;   用户名@merchandise;   商品名称@specification;   商品规格@unit;   售卖单位@price;   商品价格@time;   系统时间@address;   地址@picture;   商品图片
				编写案例<br/><br/>
				（分享某商品详情）<br/>
				分享标题：肖伏特为你推荐<br/>
				分享内容：火龙果只需￥17.6/盒，你还在等什么？<br/>
				分享图片：商品图片<br/>
				
				后台模版编写时输入<br/><br/>
				分享标题：@Username;为你推荐<br/>
				分享内容：@merchandise;只需@price;/@unit;，你还在等什么<br/>
				分享图片：@picture;<br/>
				注意：<span class="u-red">因@和;字符被应用在字符串内，在编辑模版时，这两个符号不能应用于字符串以外的文本中。</span></p>
				<p>5.若分享模版需带出指定图片时请上传，上传图片需小于32K。否则无法上传</p>
				<p>6.分享模版可关闭，关闭分享模版后，若存在基础页面分享模版，则按基础页面分享模版执行，若没有，则按微信分享接口要求执行</p>
	      </div>
	      <div class="modal-footer justify-content-center">
	            <button type="button" class="btn btn-info btn-sm" data-dismiss="modal">知道了</button>
	        </div>
       </div>
   </div>
</div>
</@layout>
<script type="text/javascript">
var $path_base = "/";

$(function(){
	/*初始化校验*/
	$("#share_form").validate();
	
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/teamBuyManage/groupActivity",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['活动编号','活动名称','活动链接','活动状态','操作'],
        colModel:[
        	{name:'id',index:'id',sorttype:"int", editable: false},
            {name:'main_title',index:'main_title',editable: false},
            {name:'url',index:'url', editable:false},
            {name:'status',index:'status',editable: false},
            {name: 'myac', index: '',fixed: true, sortable: false, resize: false,    
                formatter: function(value, grid, rows, state){ 
			    	return '<a class="btn btn-info btn-xs mr5" title="修改" data-toggle="modal" data-target="#editModal" data-id="'+rows[1]+'"><i class="fa fa-edit"></i></a>'+
		                '<a class="btn btn-default btn-xs mr5" title="查看"  data-toggle="modal" data-target="#detailModal" data-id="'+rows[1]+'"><i class="fa fa-eye"></i></a>'+
		                '<a class="btn btn-danger btn-xs mr5" title="删除"><i class="fa fa-trash"></i></a>';
			    }  
            }
        ],
        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        multiselect: true,
        multiboxonly: true,

        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        editurl: "${CONTEXT_PATH}/activityManage/e",//nothing is saved
        caption: "活动控制",
        autowidth: true
    });
    
    //图片上传
	var editor;
	var K=window.KindEditor;
	KindEditor.ready(function(K) {
	   editor = K.editor({
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+$('#carousel_name').val(),
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+$('#carousel_name').val(),
			allowFileManager : true,
	   });
	   //给按钮添加click事件
	   K('#image').click(function() {
			editor.loadPlugin('image', function() {
				//图片弹窗的基本参数配置
				editor.plugin.imageDialog({
					imageUrl : K('#image_src').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
					//点击弹窗内”确定“按钮所执行的逻辑
					clickFn : function(url, title, width, height, border, align) {
						K('#image_src').val(url);//获取图片地址
						K('#url2').attr("src",url);
						$('#image_id').val(0);
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
	});	
		
   //查看详情
    $('#detailModal').on('show.bs.modal',function(e){
          var $button=$(e.relatedTarget);
          var id=$button.data("id");
          var modal = $(this);
          //发送ajax回去查询单条数据
//           $.ajax({
//                 url:'',
//                 type:'Get',
//                 data:{id:id},
//                 success:function(result){
//                     if(result){
//                         //回填数据
//                         var url=;
//                         modal.find('#preview').attr("src",url);
//                         modal.find('#share-img').val(url);
//                         modal.find('.activity-name').text();
//                         modal.find('.pages').text();
//                         modal.find('.share-title').text();
//                         modal.find('.share-desc').text();
//                     }
//                     else
//                     {
//                         $.alert('提示','查看详情失败 ！');
//                     }
//                 }
//           });
    });
    
    //添加或编辑
    $('#editModal').on('show.bs.modal',function(e){
          var $button=$(e.relatedTarget);
          var id=$button.data("id");
          var modal = $(this);
          if(id==null||id==""){
              //添加直接show
              modal.find('#template_name').val("");
              modal.find('#page_type').val("");
              modal.find('#page_url').val("");
              modal.find('#share_title').val("");
              modal.find('#share_content').val("");
              modal.find('#image_src').val("");
              modal.find('#url2').attr("src","");
              modal.find('#image_id').val("");
              return;
          }else{
	          //编辑发送ajax回去查询单条数据
// 	          $.ajax({
// 	                url:'',
// 	                type:'Get',
// 	                data:{id:id},
// 	                success:function(result){
// 	                    if(result){
// 	                        //回填数据
// 	                        modal.find('#template_name').val();
// 	                        modal.find('#page_type').val();
// 	                        modal.find('#page_url').val();
// 	                        modal.find('#share_title').val();
// 	                        modal.find('#share_content').val();
// 	                        modal.find('#image_src').val();
// 	                        modal.find('#url2').attr("src",);
// 	                        modal.find('#image_id').val();
// 	                    }else{
// 	                        $.alert('提示','操作失败 ！');
// 	                    }
// 	                }
// 	          });
          }
    });
    
  //添加或修改提交
    $('#btn-confirm').on('click',function(){
          //Ajax提交表单数据
          var formData= $('#share_form').serializeArray();
          var jsonData={};
          
          for(var i=0;i<formData.length;i++){
               jsonData[formData[i].name]=formData[i].value;
          }
          var data=JSON.stringify(jsonData);
       	  $.ajax({
	          url:'',
		      type:'Post',
		      dataType:'json',
		      contentType: 'application/json',
		      data: data,
		      success:function(result){
                    if(result.success){
                        //操作成功之后
                        //关闭modal
                        $('#editModal').modal('hide');
                        $.alert('提示', result.msg);
                        //刷新Grid
                        $('#grid-table').trigger("reloadGrid");
                    }
                    else
                    {
                        $.alert('提示',result.msg);
                    }
		      }
          });
    });
});

//改变奖励内容
function typeChange(event){
	event = event ? event : window.event; 
	var wayBtn=$(event.target);
	var wayForm = wayBtn.parents('form');
    var strvalue=wayBtn.val();
    console.log(strvalue);
    $("#page_url").val("");
    if(strvalue==6){
    	$(".page_url_box").show();
    }else{
    	$(".page_url_box").hide();
    }
    if(strvalue==1||strvalue==2||strvalue==5){
    	$(".normal-fieldname").hide();
    	$(".pro-fieldname").show();
    }else{
    	$(".normal-fieldname").show();
    	$(".pro-fieldname").hide();
    }
}

//replace icons with FontAwesome icons like above
function updatePagerIcons(table) {
    var replacement =
    {
        'ui-icon-seek-first' : 'fa fa-angle-double-left bigger-140',
        'ui-icon-seek-prev' : 'fa fa-angle-left bigger-140',
        'ui-icon-seek-next' : 'fa fa-angle-right bigger-140',
        'ui-icon-seek-end' : 'fa fa-angle-double-right bigger-140'
    };
    $('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
        var icon = $(this);
        var $class = $.trim(icon.attr('class').replace('ui-icon', ''));

        if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
    })
}
</script>