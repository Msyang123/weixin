<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form class="form-horizontal" role="form" method="post" id="get_coupon">
	
	<input type="hidden" id="designate_product" name="designate_product" value="N" />
	<input type="hidden" id="activity_type" name="activity_type" value="${(activity.activity_type)!'5'}"/>
	
    <div class="form-group" id="show_activity_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="activity_main_title">活动名称： </label>
        <div class="col-sm-9">
            <input type="text" id="main_title" name="main_title" value="${(activity.main_title)!}"  placeholder="活动主标题" class="col-xs-10 col-sm-5" />
        </div> 
    </div>
    
    <div class="form-group" id="show_subheading">
        <label class="col-sm-3 control-label no-padding-right" for="subheading">编号：</label>
        <div class="col-sm-9">
            <input type="text" id="id" name="id" placeholder="活动编号,系统自动生成" value="${(activity.id)!}" readonly="readonly" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_yxqq">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">活动开始时间：</label>
        <div class="col-sm-9">
            <input type="text" id="yxq_q" name="yxq_q" placeholder="活动开始时间" value="${(activity.yxq_q)!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'yxq_z\')}'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_yxqz">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">活动结束时间： </label>
        <div class="col-sm-9">
            <input type="text" id="yxq_z" name="yxq_z" placeholder="活动结束时间" value="${(activity.yxq_z)!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'yxq_q\')}'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_url">
        <label class="col-sm-3 control-label no-padding-right" for="url">url： </label>
        <div class="col-sm-9">
            <input type="text" id="url" name="url" placeholder="url" value="${(activity.url)!}" " class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <!--<div class="form-group" id="show_yxbz">
        <label class="col-sm-3 control-label no-padding-right">有效标志</label>
        <div class="col-sm-9">
        	<select id="yxbz" name="yxbz" class="col-xs-10 col-sm-5">
			  	  <option <#if (activity.yxbz)?? && (activity.yxbz)=='Y' >selected</#if> value="Y" >有效</option>
				  <option <#if (activity.yxbz)?? && (activity.yxbz)=='N' >selected</#if> value="N" >无效</option>
			</select>
        </div>
    </div>-->
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" id="btn-save">
              	  提交
            </button>
            <button class="btn" type="button" onclick="window.history.back();">
             	 取消
            </button>
        </div>
    </div>
</form>

<div id="grid_coupon_scale">
	<div class="col-xs-12 wigtbox-head form-inline">
		<form id="submitForm">
		    <div class="pull-right">	    	   
			    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal"  
			            data-target="#get_coupon_setting" data-type="add"
			            data-grid="#grid-table-couponScale">
				        <i class="fa fa-plus bigger-110"></i> 添加
				</button>
			</div>
		</form>
	</div>
	
	<div class="col-xs-12">            
	    <!-- PAGE CONTENT BEGINS -->
	    <table id="grid-table-couponScale"></table>
	    <div id="grid-pager-couponScale"></div>
	    <!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div>

<div id="show_couponGrid5">
	<div class="col-xs-12 wigtbox-head form-inline pt40">
		<form id="submitForm">
			 <div class="pull-right">
			 	    <input type="hidden" id="activity_id" name="activity_id" value="${(activity.id)!}"/>
					<button class="btn btn-info btn-sm" type="button" data-toggle="modal" 
					     data-target="#get_coupon_setting" data-type="edit"
					     data-grid="#grid-table-couponCategory">
					    <i class="fa fa-edit bigger-110"></i> 编辑
					</button>
					<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToDeleteCouponCategory('#grid-table-couponCategory')">
					    <i class="fa fa-close bigger-110"></i> 删除
					</button>
			 </div>
		</form>
	</div>
	<div class="col-xs-12" id="coupon5">
	    <!-- PAGE CONTENT BEGINS -->
	    <table id="grid-table-couponCategory"></table>
	    <div id="grid-pager-couponCategory"></div>
	    <!-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div>

<div class="modal fade" id="get_coupon_setting" tabindex="-1" role="dialog" aria-hidden="true">
   <div class="modal-dialog" >
        <div class="modal-content">
           <div class="modal-header">
                <h4 class="modal-title pull-left">设置优惠券模板</h4>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <div class="clearfix"></div>
           </div>
           <div class="modal-body clearfix">
	            <form id="coupon_category" class="form-horizontal" role="form" method="post">
	                <input type="hidden" id="coupon_type" name="coupon_type" value="1" />
	                <input type="hidden" id="coupon_category_id" name="id" />
	                
					<div class="form-group" id="yxq_q_category_show">
				       <label class="col-sm-3 control-label no-padding-right" for="yxq_q_category">优惠券有效时间起：</label>
				        <div class="col-sm-9">
				            <input type="text" id="yxq_q_category" name="yxq_q_category" required
				             onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'yxq_z_category\')}'})" class="col-xs-10 col-sm-5" />
				        </div>
				    </div>
			   
				    <div class="form-group" id="yxq_z_category_show">
				       <label class="col-sm-3 control-label no-padding-right" for="yxq_z_category">优惠券有效时间止：</label>
				       <div class="col-sm-9">
				            <input type="text" id="yxq_z_category" name="yxq_z_category" required
				             onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'yxq_q_category\')}'})" class="col-xs-10 col-sm-5" />
				        </div>
				    </div>
			    
				    <div class="form-group" id="coupon_total_show">
				       <label class="col-sm-3 control-label no-padding-right" for="coupon_total">优惠券总量：</label>
				       <div class="col-sm-9">
				            <input type="text" id="coupon_total" name="coupon_total" class="col-xs-10 col-sm-5" required/>
				        	<input type="checkbox" id="coupon_total_checkbox" onclick="checkboxShow('#coupon_total_checkbox','#coupon_total')"></input>不限制
				        </div>
				    </div>
			    
				    <div class="form-group" id="user_gain_times_show">
				       <label class="col-sm-3 control-label no-padding-right" for="user_gain_times">用户领取次数限制：</label>
				       <div class="col-sm-9">
				            <input type="number" id="user_gain_times" name="user_gain_times" placeholder="" value="" class="col-xs-10 col-sm-5" />
				        </div>
				    </div>
			    			    
				    <div class="form-group" id="show_yxbz">
				        <label class="col-sm-3 control-label no-padding-right" for="yxbz_coupon5">有效标志：</label>
				        <div class="col-sm-9">
				        	<select id="yxbz_coupon5" name="yxbz_coupon5" class="col-xs-10 col-sm-5">
							  	  <option value="Y" >有效</option>
								  <option value="N" >无效</option>
							</select>
				        </div>
				    </div>
	            </form>
           </div>
	       <div class="modal-footer text-center">
          		<button class="btn btn-info btn-md" type="button" id="btn-confirm">
               	        确认
	           	</button>
	           	<button class="btn btn-danger btn-md" data-dismiss="modal" aria-hidden="true">
	                                            取消
	            </button>
	       </div>
	    </div>
    </div>
</div>
</@layout>

<script>
    //根据时间判定有效状态
    function checkTime(){  
		var date = new Date();
		var now = date.getFullYear()+ "-" + ((date.getMonth() + 1) > 10 ? (date.getMonth() + 1) : "0"
	            + (date.getMonth() + 1)) + "-" + (date.getDate() < 10 ? "0" + date.getDate() : date.getDate()) 
	            + " " + (date.getHours() < 10 ? "0" + date.getHours() : date.getHours()) + ":"
	        	+ (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()) + ":"
	        	+ (date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds());
		var now=new Date(now.replace("-", "/").replace("-", "/"));  
		
	    var startTime=$("#yxq_q").val();  
	    var start=new Date(startTime.replace("-", "/").replace("-", "/"));  
	
	    var endTime=$("#yxq_z").val();  
	    var end=new Date(endTime.replace("-", "/").replace("-", "/")); 
	
	    var boo = now>start&&now<end;
	    var message;
	    if(!boo){  
	    	message = "当前时间不在有效时间内，活动为无效";
	        $("#yxbz").val("N");
	    } else{
	    	message = 0;
	    }
	     return message;
    }  
    
	//检查checkbox是否选中
	function checkboxShow(checkboxID,inputID){
		var flag = $(checkboxID).prop("checked");
		if(flag){
			$(inputID).attr("disabled",true);
			$(inputID).val("/");
			$("#coupon_type").val("2");
		}else{
			$(inputID).attr("disabled",false);
			$(inputID).val("");
			$("#coupon_type").val("1");
		}
	}
           
    //删除优惠券
    function getSelRowToDeleteCouponCategory(table_name){
    	var selr = $(table_name).getGridParam("selrow");
        if(!selr){
        	$.alert("提示","请先选择一行数据再删除");
            return;
        }
        if(confirm("您确认要删除该种优惠券规模吗？")){
	        $.ajax({
	        	url:"${CONTEXT_PATH}/activityManage/delCouponCategory?id="+selr,
	        	success:function(data){
	        		$.alert("提示",data.msg);
	        		$(table_name).trigger("reloadGrid");
	        	}
	        });
        }
    }
    	
	//优惠券规模列表
	$(function() {
	    var grid_selector_couponScale = "#grid-table-couponScale";
	    var pager_selector_couponScale = "#grid-pager-couponScale";
	    var grid_selector_couponCategory = "#grid-table-couponCategory";
	    var pager_selector_couponCategory = "#grid-pager-couponCategory";
	       
	    $(grid_selector_couponScale).jqGrid({
	        url:"${CONTEXT_PATH}/activityManage/getCouponScaleJson?is_valid='Y'",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['操作','优惠券编号','优惠券描述','满减金额', '优惠券面值','是否有效'],
	        colModel:[
	            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
	                  formatter:'actions',
	                  formatoptions:{
	                      keys:false,
	                      delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}                    
	                  }
	            },
	            {name:'id',index:'id', width:90, editable: true},
	            {name:'coupon_desc',index:'coupon_desc',width:90, editable:true, sorttype:"date"},
	            {name:'min_cost',index:'min_cost', width:150,editable: true,editoptions:{size:"20",maxlength:"30"}},
	            {name:'coupon_val',index:'coupon_val', width:90,editable: true},
	            {name:'is_valid',index:'is_valid', width:90,editable: false},
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : pager_selector_couponScale,
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
	        editurl: "${CONTEXT_PATH}/activityManage/e",
	        caption: "优惠券规模管理",
	        autowidth: true
	   });
	     
	   initNavGrid(grid_selector_couponScale,pager_selector_couponScale);
	    
	   //领券活动grid
	   $(grid_selector_couponCategory).jqGrid({
		    postData:{'activity_id':$("#activity_id").val()},
	        url:"${CONTEXT_PATH}/activityManage/getCouponCategoryJson",
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['操作','优惠券编号','优惠券描述','优惠券数量','有效期','有效期起','有效期止','优惠券获得金额','优惠券获得数量','用户领取次数限制','是否有效',],
	        colModel:[
	            {name:'myac',index:'', width:70, fixed:true, sortable:false, resize:false,
	                  formatter:'actions',
	                  formatoptions:{
	                      keys:false,
	                      delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
	                  }
	            },
	            {name:'id',index:'id', width:30, editable: true},
	            {name:'coupon_desc',index:'coupon_desc',width:40, editable:true},
	            {name:'coupon_total',index:'coupon_total', width:40,editable:true},
	            {name:'yxq',index:'yxq', width:20, hidden:true},
	            {name:'yxq_q',index:'yxq_q', width:50,hidden:true},
	            {name:'yxq_z',index:'yxq_z', width:50,hidden:true},
	            {name:'min_pay_give',index:'min_pay_give', width:20,hidden:true},
	            {name:'give_coupon_amount',index:'give_coupon_amount', width:20,hidden:true},
	            {name:'user_gain_times',index:'user_gain_times', width:50,editable: true},
	            {name:'yxbz',index:'yxbz', width:20,editable: true}
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : pager_selector_couponCategory,
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
	        editurl: "${CONTEXT_PATH}/activityManage/e",
	        caption: "已关联优惠券规模",
	        autowidth: true
	    });
	    
	    initNavGrid(grid_selector_couponCategory,pager_selector_couponCategory);

	    $('#btn-save').on('click',function(){
	    	var message = checkTime();
	    	if(message!=0){
	    		var mymessage=confirm("你确定要创建一个无效的活动吗？");  
	    		if(mymessage==false){return;}
	    	}
	    	//表单校验
	        var validetor=$('#get_coupon').validate({
	        	rules: {
	        		main_title:{
	        			required:true,
	        		},
	        		yxq_q:{
	        			required:true,
	        		},
	        		yxq_z:{
	        			required:true,
	        		}
	        	},
	        	messages:{
	        		main_title:{
	        			required:"请输入活动主标题",
	        		},
	        		yxq_q:{
	        			required:"请输入开始时间",
	        		},
	        		yxq_z:{
	        			required:"请输入结束时间",
	        		}
	        	},
	        });
	        
	        if(!validetor.form()){     
	        	return false;
	        }
	        
	        var formData=$('#get_coupon').serialize();
	        console.log(formData);
	    	$.ajax({  
	            type:"POST",
	            url:"${CONTEXT_PATH}/activityManage/saveCouponActivity",  
	            data:formData,
	            success:function(result) {
	              		if(result.success){                        		  	 
	              		  	 $("#id").val(result.id);                        		  	 
	              		  	 $("#activity_id").val(result.id);
	              		  	 $.alert("提示","操作成功");
	              		}else{  
	              			 $.alert("提示","操作失败，请重试");  
	             		}  
	            }  
	        });

	    });

	    $('#get_coupon_setting').on("show.bs.modal",function(e){
	    	    var modal=$(this);
	            var $btn=$(e.relatedTarget);
	            var gridName=$btn.data("grid");
	            var type=$btn.data("type");
	            
	            var actvity_id = $("#id").val();
	            var coupon_scale_id = $(gridName).getGridParam('selrow');
	         	var activity_type = $("#activity_type").val();
	         	
	         	if(actvity_id==null||actvity_id==""){
	         		$.alert("提示","请先添加一个返券活动再进行后续操作");
	                return false;
	         	}
	         	if(!coupon_scale_id){
	         		$.alert("提示","请先选择一行数据再添加具体规模优惠券");
	         		return false;
	         	}
	         	
	         	if(type=="add"){
	         		//清空掉form
	         		$("form#coupon_category")[0].reset();
	            }else{
		         	var selr = $(gridName).getGridParam("selrow");
		        
		            if(!selr){
		             	 $.alert("提示","请先选择一行数据再编辑");
		                 return false;
		            }       
		            
		            var id=$(gridName).jqGrid("getCell",selr,"id");              
	            	var yxq_q=$(gridName).jqGrid("getCell",selr,"yxq_q");
	            	var yxq_z=$(gridName).jqGrid("getCell",selr,"yxq_z");
	            	var coupon_total=$(gridName).jqGrid("getCell",selr,"coupon_total");
	            	var user_gain_times=$(gridName).jqGrid("getCell",selr,"user_gain_times");
	      		    var yxbz=$(gridName).jqGrid("getCell",selr,"yxbz");
	      		    
	      		    $("#coupon_category_id").val(id);
	            	$("#yxq_q_category").val(yxq_q);
	            	$("#yxq_z_category").val(yxq_z);
		     		$("#coupon_total").val(coupon_total);
		      		$("#user_gain_times").val(user_gain_times);
		      		$("#yxbz_coupon5").val(yxbz); 
		     	
		     		if($("#coupon_total").val()=="/"){
		     			$("#coupon_total_checkbox").attr("checked", true);
		     			$("#coupon_total").attr("disabled",true);
		     			$('#coupon_type').val("2");
		     		}else{
		     			$("#coupon_total_checkbox").attr("checked", false);
		     			$("#coupon_total").attr("disabled",false);
		     			$('#coupon_type').val("1");
		     		} 	
	           }	         	
	    });

	    $('#btn-confirm').on("click",function(){
	    	var activity_type = $("#activity_type").val();
	    	//表单校验
	        var validetor=$('#coupon_category').validate({
	        	rules: {
	        		main_title:{
	        			required:true
	        		},
	        		yxq_q_category:{
	        			required:true
	        		},
	        		yxq_z_category:{
	        			required:true
	        		},
	        		coupon_total:{
	        			required:true,
	        			digits:true
	        		},
	        		user_gain_times:{
	        			required:true
		            }
	        	},
	        	messages:{
	        		main_title:{
	        			required:"请输入活动主标题",
	        		},
	        		yxq_q_category:{
	        			required:"请输入开始时间",
	        		},
	        		yxq_z_category:{
	        			required:"请输入结束时间",
	        		},
	        		coupon_total:{
	        			required:"请输入优惠券总量",
	        			digits:"请输入合法的正整数"
		            },
		        	user_gain_times:{
	        			required:"请输入用户领取限制次数"
		            }
	        	},
	        });
	        
	        if(!validetor.form()){     
	        	return false;
	        }
	        
	    	var jsonData = {
    			id:$("#grid-table-couponCategory").getGridParam("selrow"),
				main_title:$("#main_title").val(),
				activity_id:$("#activity_id").val(),
				couponScale_id:$("#grid-table-couponScale").getGridParam("selrow"),
				coupon_type:$("#coupon_type").val(),
				yxq_q:$("#yxq_q_category").val(),
				yxq_z:$("#yxq_z_category").val(),
				coupon_total:$("#coupon_total").val(),
				user_gain_times:$("#user_gain_times").val(),
				yxbz:$("#yxbz_coupon5").val()
	        }
	        
	        //发送Ajax去保存category
	    	$.ajax({ 
				url: "${CONTEXT_PATH}/activityManage/saveCouponCategory", 
				data: jsonData, 
				success: function(data){
					if(data.errcode==0){
						$.dialog.alert("操作成功");				
						$("#grid-table-couponCategory").setGridParam({postData:{'activity_id':$("#activity_id").val()}}).trigger("reloadGrid");
						$("#get_coupon_setting").modal("hide");
					}else{
						$.dialog.alert(data.errmsg);
					}	
		      	}
			});
		});
	});     
</script>