<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[""] styles=[""]>

    <div class="form-horizontal" align="center" id="manual_release">
    
			<form id="excelForm"  method="post" enctype="multipart/form-data" target="frmright">
				<a href="发券名单模版.xlsx" download="发券名单模版.xlsx" class="form-group">下载excel文件模版</a>
				<div style="color:red">注意：下载好模板后，在模板里加完名单后，记得将“电话号码”列设置为“文本”格式，否则将无法发放！！！</div>
				<div class="form-group"  style="padding-top:40px">
					<label class="col-sm-5 control-label no-padding-right" for="file_path">导入发放名单：</label>
					<div class="col-sm-7" align="left">
			       		<input id="file_path" name="file_path" readonly="true" value="${(image.save_string)!}"/>
						<button type="button" id="image">导入excel</button>
		        	</div>
				</div>
			</form>
			
			<form id="sumbitForm">
				<div class="form-group">
					<label class="col-sm-5 control-label no-padding-right" for="yxq_q">优惠券有效时间起：</label>
						<div class="col-sm-7">
							<input type="text" id="yxq_q" name="yxq_q" required
						     onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'yxq_z\')}'})" class="col-xs-10 col-sm-5" />
						 </div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-5 control-label no-padding-right" for="yxq_z_category">优惠券有效时间止：</label>
						<div class="col-sm-7">
							<input type="text" id="yxq_z" name="yxq_z" required 
						     onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'yxq_q\')}'})" class="col-xs-10 col-sm-5" />
				      	</div>
				</div>
				
				<div class="form-group">
			        <label class="col-sm-5 control-label no-padding-right">关联优惠券：</label>
			        <div class="col-sm-7">
			            <select id="coupon_scale_id" name="coupon_scale_id" class="col-xs-10 col-sm-5">
			              <option value="" selected disabled style="display:none">请选择优惠券</option>
			               <#list scaleList as item>
		                          <option value="${item.id}">${item.coupon_desc}</option>
		                     </#list>
		                   </select>
			        </div>
			    </div>
			    
			    <div class="form-group">
			        <label class="col-sm-5 control-label no-padding-right" for="give_coupon_amount">每人发放张数：</label>
			        <div class="col-sm-7">
			            <input type="number" id="give_coupon_amount" name="give_coupon_amount" value="1" class="col-xs-10 col-sm-5" required/>
			        </div>
			    </div>
			    
				<div class="form-group">
					<div class="col-12 text-center">
						<button class="btn btn-info btn-sm" type="button" id="release_coupon">
							<i class="fa fa-check bigger-110"></i> 提交
						</button>
						<button class="btn btn-primary btn-sm" aria-hidden="true" id="btn-reset">
							<i class="fa fa-refresh bigger-110"></i> 重置
						</button>
						<button class="btn btn-danger btn-sm" aria-hidden="true" onclick="window.history.back();">
							<i class="fa fa-reply bigger-110"></i> 取消
						</button>
					</div>
				</div>			
			</form>
	</div>
	
</@layout>
<script>
    <!--上传用户名单-->
	KindEditor.ready(function(K) {
		 var editor = K.editor({
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/uploadExcel?dir=file&idName=file',
				//fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=手动发放优惠券活动',
				//allowFileManager : true,
		});
		//给按钮添加click事件
		K('#image').click(function() {
			editor.loadPlugin('image', function() {
				//图片弹窗的基本参数配置
				editor.plugin.imageDialog({
					imageUrl : K('#url').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
					//点击弹窗内”确定“按钮所执行的逻辑
					clickFn : function(url, title, width, height, border, align) {
						K('#file_path').val(url);//图片地址存储
						editor.hideDialog(); //隐藏弹窗
					}
				});
			});
		});
	});
	
	jQuery(function($) {
		 $('#btn-reset').on('click',function(){
			  $('#sumbitForm')[0].reset();
	     });
	     //手动发券确认
	     $('#release_coupon').on('click',function(){
		    	var scaleId = $('#coupon_scale_id').val();
		    	var couponNum=$('#give_coupon_amount').val();
		 		var filePath = $('#file_path').val();
		 		var yxq_q = $('#yxq_q').val();
		 		var yxq_z = $('#yxq_z').val();
		 		
		 		if(!file_path){
		 			$.alert("提示","请先上传发放名单！");
		 			return;
		 		}
		 		//表单校验
		        var validetor=$('#sumbitForm').validate({
		        	rules: {
		        		coupon_scale_id:{
		        			required:true,
		        		},
		        		yxq_q:{
		        			required:true,
		        		},
		        		yxq_z:{
		        			required:true,
		        		},
		        		yxq:{
		        			required:true,
		        			digits:true
		        		},
		        		give_coupon_amount:{
		        			required:true,
		        			digits:true
		        		}
		        	},
		        	messages:{
		        		coupon_scale_id:{
		        			required:"请关联一张优惠券规模",
		        		},
		        		yxq_q:{
		        			required:"请输入开始时间",
		        		},
		        		yxq_z:{
		        			required:"请输入结束时间",
		        		},
		        		give_coupon_amount:{
		        		   required:"请输入发放数量",
		        		   digits:"请输入正整数"
		        		}
		        	},
		        });
		        
		        if(!validetor.form()){     
		        	return false;
		        }
		        
		        $("#release_coupon").attr("disabled", true);
		 		//发送Ajax去手动发券 	
		 		$.ajax({
		 			url:"${CONTEXT_PATH}/activityManage/releaseCoupon",
		 			data:{'coupon_scale_id':scaleId,'file_path':filePath,
			 			  'yxq_q':yxq_q,'yxq_z':yxq_z,'give_coupon_amount':couponNum},
		 			success:function(result){
 		        		if(result.success){
 		        			if(result.fail_phone.length==0){
 		        				$.alert("提示","全部发放完成");
 	        				}else{
 	        					$.alert("提示","发放结束，以下是发放失败的名单:"+result.fail_phone);
 	        				}
 		        		}else{
 		        			$.alert("提示",result.msg);
 	 		            }
 		        		//防止重复提交
	        		    $("#release_coupon").attr("disabled", false); 
		 		    }
		 		});
	     });
	});   
</script>