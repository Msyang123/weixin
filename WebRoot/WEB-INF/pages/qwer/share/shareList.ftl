 <#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-all.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=["${CONTEXT_PATH}/plugin/kindeditor-4.1.10/themes/default/default.css"]>
<div class="col-xs-12 wigtbox-head form-inline">
	<form id="submitForm">
	    <div class="pull-left">
		    <input class="form-control" id="template" name="template" type="text" placeholder="模板名称"/>	    
			<button class="btn btn-primary btn-sm" type="button" onclick="jQuery('#grid-table').setGridParam({postData:{'template':$('#template').val()}}).trigger('reloadGrid');">
		        <i class="fa fa-search bigger-110"></i> 搜索     
		    </button>
	    </div>
	     <div class="pull-right">		
			<button class="btn btn-warning btn-sm" type="button"  data-toggle="modal" data-target="#editModal"/>
			    <i class="fa fa-plus bigger-110"></i> 添加
			</button>
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDelete();"/>
			    <i class="fa fa-close bigger-110"></i> 删除
			</button>
		</div>  
	</form>
</div>


<div class="col-xs-12">
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
	           	<form id="share_form" method="post" class="form-horizontal col-md-7" action="${CONTEXT_PATH}/shareManage/saveShare" >
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">模板名称：</label>
				         <div class="col-md-8">
				         <input type="hidden" class="form-control" id="share_id" name="share_id" />
				         <input type="text" class="form-control" id="template" name="share.template" />
				         </div> 
				     </div>   
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">页面类型：</label>
				         <div class="col-md-8">
						 	<select id="page_type" class="form-control" onchange="otherSet()" name="share.pages" >
		                    	  <option value="0">基础页面</option>
		                    	  <option value="1">商品详情页</option>
		                    	  <option value="2">拼团商品详情页</option>
		                    	  <option value="3">商品列表页</option>
		                    	  <option value="4">拼团商品列表页</option>
		                    	  <option value="5">拼团等待页</option>
		                    	  <option value="6" >其他页面</option>
					         </select>
						 </div> 
				     </div> 
				     <div class="form-group page_url_box" hidden>
	                     <label class="col-md-3 text-right nopd-lr">url：</label>
				         <div class="col-md-8"><input type="text" class="form-control" id="url" name="share.url"></div> 
				     </div> 
				     <hr>
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">分享标题：</label>
				         <div class="col-md-8"><input type="text" class="form-control" id="title" placeholder="最多输入80字，请注意" maxlength="80" name="share.title"></div> 
				     </div> 
				     <div class="form-group">
	                     <label class="col-md-3 text-right nopd-lr">分享内容：</label>
				         <div class="col-md-8">
				         	<textarea class="form-control" id="content" placeholder="最多输入150字，请注意" rows="4" maxlength="150" name="share.content"></textarea>
				         </div> 
				     </div> 
				     <div class="form-group">
				         <label class="col-sm-3 text-right nopd-lr">分享图片：</label>
				         <div class="col-sm-8">
					          <input type="text" id="image_src" 
					          placeholder="使用模版填写右侧字符串" class="col-md-8"  value="" name="share.picture"/>
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
						{{left_count}} 拼团仅剩人数<br/>
						{{activity_price_reduce}} 团购价<br/>
						{{penson_count}}  凑足多少人<br/><br/>
					</div>
					<div class="pro-fieldname" hidden>
						{{Username}}   用户名<br/>
						{{product_name}}   商品名称<br/>
						{{standard}}   商品规格(例如：1*1.5)<br/>
						{{product_unit}}   售卖单位(例如：斤，盒)<br/>
						{{price}}   商品价格<br/>
						{{time}}   系统时间<br/>
						{{url}}   地址<br/>
						{{picture}}   商品图片<br/><br/>
					</div>
					编写案例<br/>
					如：（分享某商品详情）<br/>
					分享标题：我在水果熟了看中了红心火龙果，真的好好吃，有没有一起买的~<br/>
					分享内容：在你来之前，我们已经淘汰掉99%又微小瑕疵的水果，直接把它带走吧，节省下来的时间你可以来一次有氧小跑<br/>
					分享图片：商品图片<br/><br/>
					
					后台模版编写时输入<br/>
					分享标题：我在水果熟了看中了{{product_name}}，真的好好吃，有没有一起买的~<br/>
					分享内容：在你来之前，我们已经淘汰掉99%又微小瑕疵的水果，直接把它带走吧，节省下来的时间你可以来一次有氧小跑<br/>
					分享图片：{{picture}}<br/>
					分享模版需带出指定图片时请上传，上传图片需小于32K。否则无法上传
					<div class="btn-box pd10 text-center">
						<button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#rulesModal">查看详细编写规则</button>
					</div>
				</div>
	        </div>
	        <div class="modal-footer justify-content-center">
	            <button type="button" class="btn btn-default btn-sm btn-cancel" data-dismiss="modal" id="btn-cancel">取消</button>
	            <button type="button" class="btn btn-info btn-sm btn-confirm" id="btn-confirm" onclick="whenSubmit();">保存</button>
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
				拼团仅剩人数{{left_count}} 团购价{{activity_price_reduce}} 商品名称{{product_name}} 
				凑足多少人{{penson_count}} 图片{{picture}} 商品原价{{price}} 商品现价{{activity_price_reduce}}  地址{{picture}}   商品图片
				编写案例<br/><br/>
				（分享某商品详情）<br/>
				分享标题：我在水果熟了看中了红心火龙果，真的好好吃，有没有一起买的~<br/>
				分享内容：在你来之前，我们已经淘汰掉99%又微小瑕疵的水果，直接把它带走吧，节省下来的时间你可以来一次有氧小跑<br/>
				分享图片：商品图片<br/>
				
				后台模版编写时输入<br/><br/>
				分享标题：我在水果熟了看中了{{product_name}}，真的好好吃，有没有一起买的~<br/>
				分享内容：在你来之前，我们已经淘汰掉99%又微小瑕疵的水果，直接把它带走吧，节省下来的时间你可以来一次有氧小跑<br/>
				分享图片：{{picture}}<br/>
				注意：<span class="u-red">因{{}}字符被应用在字符串内，在编辑模版时，这两个符号不能应用于字符串以外的文本中。</span></p>
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
$(function(){
	//编辑器和单独图片上传
	var editor;
	var K=window.KindEditor;
	KindEditor.ready(function (K) {
		//这里是kindeditor编辑器的基本初始化配置
			editor = K.editor({
			resizeType: 1,
			fullscreenMode: 0, //是否全屏显示
			designMode: 1,
			cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
			uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName=pageShareImage',
			fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=image&idName=pageShareImage',
			allowPreviewEmoticons: false,
			allowImageUpload: true,
			allowFileManager: true,
			width : "100%", //编辑器的宽度
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
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
	});
	
	//编辑回填数据
    $('#editModal').on('show.bs.modal',function(e){
          var $button=$(e.relatedTarget);
          var id=$button.data("id");
          var modal = $(this);
          //发送ajax回去查询单条数据
          $.ajax({
                url:'${CONTEXT_PATH}/shareManage/initSave',
                type:'Get',
                data:{id:id},
                success:function(result){
                    if(result){
                    	console.log(result);
                        //回填数据
                        modal.find('#template').val(result.mShare.template);
                        $("#page_type").find("option[value='"+result.mShare.pages+"']").attr("selected",true);
                        modal.find('#url').val(result.url);
                        modal.find('#title').val(result.mShare.title);
                        modal.find('#content').text(result.mShare.content);
                        modal.find('#share_id').val(result.mShare.id);
                        $("#url").val(result.mShare.url);
                       	$("#url2").attr('src',result.mShare.picture); 
                       	$("#image_src").val(result.mShare.picture);
                    }
                    else
                    {
                        alert('提示','查看详情失败 ！');
                    }
                }
          });
    });
	
  //查看详情
    $('#detailModal').on('show.bs.modal',function(e){
          var $button=$(e.relatedTarget);
          var id=$button.data("id");
          var modal = $(this);
          //发送ajax回去查询单条数据
          $.ajax({
                url:'${CONTEXT_PATH}/shareManage/initSave',
                type:'Get',
                data:{id:id},
                success:function(result){
                    if(result){
                    	console.log(result);
                        //回填数据
                        $(".activity-name").html(result.mShare.template);
                        //modal.find('#template').val(result.template);
                        if(result.mShare.pages==0){
                        	modal.find('.pages').html("基础页面");
                        }else if(result.mShare.pages==1){
                        	modal.find('.pages').html("商品详情页");
                        }else if(result.mShare.pages==2){
                        	modal.find('.pages').html("拼团商品详情页");
                        }else if(result.mShare.pages==3){
                        	modal.find('.pages').html("商品列表页");
                        }else if(result.mShare.pages==4){
                        	modal.find('.pages').html("拼团商品列表页");
                        }else if(result.mShare.pages==5){
                        	modal.find('.pages').html("拼团等待页");
                        }else if(result.mShare.pages==6){
                        	modal.find('.pages').html("其它页面");
                        }
                        modal.find('.share-title').html(result.mShare.title);
                        modal.find('.share-desc').html(result.mShare.content);
                        if(result.mShare.pages==1||result.mShare.pages==2){
                        	$("#preview").attr('src',result.image_src); 
                        }
                    }
                    else
                    {
                        alert('提示','查看详情失败 ！');
                    }
                }
          });
    });

	
});
	
	function otherSet(){
		var page_type=$("#page_type").val();
		if(page_type == 6){
			$(".page_url_box").show();
		}else{
			$(".page_url_box").hide();
		}
	}

 	function whenSubmit(){
   		$("#share_form").submit();
    }
    
    function getSelRowToDelete(){
    	var selr = jQuery("#grid-table").getGridParam('selarrrow');
        if(!selr){
            alert("请先选择一行数据再删除");
            return;
        }
         if(confirm("确定删除此分享模板?")){
        	window.location.href="${CONTEXT_PATH}/shareManage/shareDelete?ids="+selr;
        }	 
    }
    
    function confrimOpenOrClose(id,status,pageType){
    	$.ajax({
            url:'${CONTEXT_PATH}/shareManage/templateOpenOrClose',
            type:'Get',
            data:{id:id,status:status,pageType:pageType},
            success:function(result){
                if(result){
                	alert(result.mes);
                	jQuery("#grid-table").trigger("reloadGrid");
                }
            }
      }); 
    }

var $path_base = "/";

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";

    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/shareManage/getSharesJson",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['','模板名称','指定页面','分享标题','分享内容', '模板状态','操作'],
        colModel:[ 
        	{name:'id',index:'id', width:30, editable: true,hidden:true},          
            {name:'template',index:'template', width:30, editable: true},
            {name:'pages',index:'pages',width:70, editable:true, formatter:pageFormatter},
            {name:'title',index:'title', width:100,editable: true,editoptions:{size:"20",maxlength:"30"}},
            {name:'content',index:'content', width:100,editable: true},
            {name:'status',index:'status', width:30,editable: false,formatter:statusFormatter},
            {name:'myac',index:'',width:200, fixed:true, sortable:false, resize:false,
                formatter: function(cellvalue,options,rowObject){
                	var myacStr;
                	var value = rowObject[5];
                	var pages=rowObject[2];
                	var id = rowObject[0];
                	console.log(id);
                	if(value == 0){
                		myacStr = '<a class="btn btn-danger btn-xs mr5" title="关闭" onclick=confrimOpenOrClose('+id+','+value+','+pages+')><i class="fa fa-cloud-download"></i></a>'+
				         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" data-toggle="modal" data-target="#editModal" data-id="'+id+'"><i class="fa fa-edit"></i></a>'+
				         '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#detailModal" data-id="'+id+'" title="查看详情"><i class="fa fa-eye"></i></a>';
                	}else{
                		 myacStr = '<a class="btn btn-success btn-xs mr5" title="开启" onclick=confrimOpenOrClose('+id+','+value+','+pages+')><i class="fa fa-cloud-upload"></i></a>'+                		 
				         '<a class="btn btn-warning btn-xs mr5 btn-edit" title="编辑" data-toggle="modal" data-target="#editModal" data-id="'+id+'"><i class="fa fa-edit"></i></a>'+
				         '<a class="btn btn-info btn-xs mr5" data-toggle="modal" data-target="#detailModal" data-id="'+id+'" title="查看详情"><i class="fa fa-eye"></i></a>';
                	}
				    return myacStr;
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
                enableTooltips(table);
            }, 0);
        },

        editurl: "${CONTEXT_PATH}/shareManage/e",//nothing is saved
        caption: "分享模板管理",
        autowidth: true
    });
	
    initNavGrid(grid_selector,pager_selector);
    
     //开启或关闭设置
    function statusFormatter(cellvalue, options, rowObject){   
   		if(rowObject[5]==0){
    		return "开启";
    	}else{
    		return "关闭";
    	}
    }
     
    function pageFormatter(cellvalue, options, rowObject){
    	var rowObject=rowObject[2];
    	if(rowObject==0){
        	return "基础页面";
        }else if(rowObject==1){
        	return "商品详情页";
        }else if(rowObject==2){
        	return "拼团商品详情页";
        }else if(rowObject==3){
        	return "商品列表页";
        }else if(rowObject==4){
        	return "拼团商品列表页";
        }else if(rowObject==5){
        	return "拼团等待页";
        }else if(rowObject==6){
        	return "其它页面";
        }
    }
});
</script>