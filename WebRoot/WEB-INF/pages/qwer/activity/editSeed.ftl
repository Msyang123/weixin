<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<div class="col-xs-12">
	<form action="${CONTEXT_PATH}/seedManage/saveSeedActivity" class="form-horizontal" role="form" method="post" id="seed_activity">
	    <input type="hidden" name="activity.id" value="${activity.id!'0'}" id="activity_id"/>
	    <input type="hidden" name="activity.content" id="content" />
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="main_title">活动主标题 </label>
	        <div class="col-sm-9">
	            <input type="text" id="main_title" name="activity.main_title" value="${activity.main_title!}"  placeholder="活动主标题" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="subheading">活动副标题 </label>
	        <div class="col-sm-9">
	            <input type="text" id="subheading" name="activity.subheading" placeholder="活动副标题" value="${activity.subheading!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right mr12" for="editor"> 内容 </label>
	        <textarea id="editor" style="width:700px;height:300px;" >${activity.content!}</textarea>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">活动时间起 </label>
	
	        <div class="col-sm-9">
	            <input type="text" id="yxq_q" name="activity.yxq_q" placeholder="活动时间起" value="${activity.yxq_q!}" 
	            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">活动时间止 </label>
	
	        <div class="col-sm-9">
	            <input type="text" id="yxq_z" name="activity.yxq_z" placeholder="活动时间止" value="${activity.yxq_z!}" 
	            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	       <label class="col-sm-3 control-label no-padding-right">分享送种子</label>
	       <input type="hidden" name="activity.share_send" id="share_send" value='${activity.share_send!}' />
	       <div class="col-sm-3">
				<label>
					<input type="checkbox" id="isShare" name="isShare" class="ace ace-switch ace-switch-2" checked="checked" value="true">
					<span class="lbl"></span>
				</label>
		   </div>
	    </div>
	    
	    <div class="form-group form-inline share-seed">
	         <label class="col-sm-3 control-label no-padding-right">赠送种子类型</label>
	         <div class="seed-exchanges col-sm-9">
	            <select id="share_seed_type" class="seed-type form-control" name="share_seed_type">
	        		<#list seedType as item>
	        			<option value="${item.id}">${item.seed_name}</option>
	        		</#list>    		
	        	</select>
	        	<div class="input-group">
	        	    <input type="text" name="share_seed_num" id="share_seed_num" class="form-control" placeholder="数量"/>
	        	</div>
	        	<div class="radio">
					<label for="frequence"><input type="radio" id="frequence" name="frequence" class="ace form-control" checked="checked" value="0" /><span class="lbl">仅一次</span></label>
					<label for="frequence2"><input type="radio" id="frequence2" name="frequence" class="ace form-control" value="1" /><span class="lbl">每日刷新</span></label>
		        </div>
	         </div>             
	    </div>
	    
	    <div class="form-group">
	       <label class="col-sm-3 control-label no-padding-right">购物送种子</label>
	       <input type="hidden" name="activity.gm_send" id="gm_send" value='${activity.gm_send!}' />
	       <div class="col-sm-3">
				<label>
					<input type="checkbox" id="isPurchase" name="isPurchase" class="ace ace-switch ace-switch-2" checked="checked" value="true">
					<span class="lbl"></span>
				</label>
		   </div>
	    </div>
	    
	    <div class="purchase-seed">
		    <div class="form-group">
		        <label class="col-sm-3 control-label no-padding-right" for="activity_money">赠送门槛金额 </label>
		        <div class="col-sm-9">
		            <input type="text" id="activity_money" name="activity.activity_money" placeholder="门槛金额" class="col-sm-5" value='${(activity.activity_money)!}' />
		        </div>
		    </div>
		    
		    <div class="form-group form-inline">
		         <label class="col-sm-3 control-label no-padding-right">赠送种子类型</label>
		         <div class="seed-exchanges col-sm-9">
		            <select id="gms_seed_type" class="seed-type form-control" name="gms_seed_type">
		        		<#list seedType as item>
		        			<option value="${item.id}">${item.seed_name}</option>
		        		</#list>    		
		        	</select>
		        	<div class="input-group">
		        	    <input type="text"  id="gms_seed_num" name="gms_seed_num" class="form-control" placeholder="数量"/>
		        	</div>
		        	<div class="radio">
						<label for="mode"><input type="radio" id="mode" name="mode" class="ace form-control" checked="checked" value="0" /><span class="lbl">固定赠送</span></label>
						<label for="mode2"><input type="radio" id="mode2" name="mode" class="ace form-control" value="1" /><span class="lbl">比例赠送</span></label>
			        </div>
			        <p class="mt10">计算公式: 订单金额/门槛金额（向下取整）X 赠送种子数量</p>
		         </div>
		    </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="dis_order">排序 </label>
	
	        <div class="col-sm-9">
	            <input type="text" id="dis_order" name="activity.dis_order" placeholder="排序" value="${activity.dis_order!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">活动类型 </label>
	        <div class="col-sm-9">
	            <select id="activity_type" name="activity.activity_type" value="${activity.activity_type!}">	         
		             <option value="18" selected readonly>种子购活动</option>      		
	        	</select>
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">url</label>
	        <div class="col-sm-9">
	            <input type="text" id="url" name="activity.url" placeholder="url" value="${activity.url!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">限制购买数量</label>
	        <div class="col-sm-9">
	            <input type="text" id="restrict" name="activity.restrict" placeholder="限制购买数量" value="${activity.restrict!}" class="col-xs-10 col-sm-5" />
	        </div>
	    </div>
	    
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right">有效标志</label>
	        <div class="col-sm-9">
	        	<select id="yxbz" name="activity.yxbz" class="col-xs-10 col-sm-5">
				  	  <option <#if activity.yxbz?? && activity.yxbz=='Y' >selected</#if> value="Y" >有效</option>
					  <option <#if activity.yxbz?? && activity.yxbz=='N' >selected</#if> value="N" >无效</option>
				</select>
	        </div>
	    </div>
	   
	    <div class="form-group">
	        <label class="col-sm-3 control-label no-padding-right" for="url2">banner</label>
	        <div class="col-sm-9">
		        <input type="hidden" id="image_src" name="image_src" value="${(image.save_string)!}" />
		        <img id="url2" src="${(image.save_string)!}"/>
				<input type="button" id="image" value="选择图片" />
				<p class="mt10">推荐尺寸为720X320（单位：px）</p>
	        </div>
	    </div>
	    
	    <div class="clearfix">
	        <div class="col-md-offset-3 col-md-9">
	            <#if activity.yxbz?? && activity.yxbz=='N'>
	            <button class="btn btn-info" type="button" id="btn-sumbit">
	                <i class="fa fa-check bigger-110"></i> 提交
	            </button>
	            <#elseif activity.yxbz?? && activity.yxbz=='Y'>
	            <#else>
	            <button class="btn btn-info" type="button" id="btn-sumbit">
	                <i class="fa fa-check bigger-110"></i> 提交
	            </button>
	            </#if>
	            <button class="btn btn-danger" type="button" onclick="history.go(-1);">
	                <i class="fa fa-undo bigger-110"></i> 取消
	            </button>
	        </div>
	    </div>
	</form>

	<ul class="nav nav-tabs mt20" role="tablist">
		  <li class="nav-item active">
		    <a class="nav-link" data-toggle="tab" href="#seedSend" role="tab">种子发放管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#single" role="tab">单品管理</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" data-toggle="tab" href="#cmobo" role="tab">套餐管理</a>
		  </li>
	</ul>
	
	<!-- Tab panes -->
	<div class="tab-content" style="height:625px;">
	      <!--Begain SeedSend-->
		  <div class="tab-pane active clearfix" id="seedSend" role="tabpanel">
			     <div class="col-xs-12 wigtbox-head form-inline">
					<form id="submitForm">
					    <div class="pull-left">
						    <input class="form-control" id="interval_name" name="interval_name" type="text" placeholder="段区间名称"/>
						    <div class="input-group">
								  <input type="text" id="begin_time" placeholder="开始时间" name="begin_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'end_time\')}'})" />
					        	至 <input type="text" id="end_time" placeholder="结束时间" name="end_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'begin_time\')}'})" />
						    </div>
						    <select id="status" name="status" class="form-control">
					    	    <option value="">请选择状态</option>
						    	<option value="1">开启</option>
						    	<option value="0">关闭</option>
						    </select>
						    <button class="btn btn-info btn-sm btn-clear" type="button">
						        <i class="fa fa-remove bigger-110"></i>     
						    </button>
						     <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-seed">
						        <i class="fa fa-search bigger-110"></i> 搜索     
						    </button>
					    </div>
					    				    
					    <div class="pull-right">
						    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" data-target="#add-interval">
							    <i class="fa fa-plus bigger-110"></i> 添加
							</button>
							<button class="btn btn-danger btn-sm btn-del" type="button" data-acid="${activity.id!}" onclick="confrimDel('#grid-table-seed','${CONTEXT_PATH}/seedManage/delIntervalAjax',this)">
						        <i class="fa fa-trash bigger-110"></i> 删除
						    </button>	
						</div>
					</form>
				</div>
				
				<div class="col-xs-12">
				    <!--Table Begain -->
				    <table id="grid-table-seed"></table>
				    <div id="grid-pager-seed"></div>			   
				</div><!-- /.col -->  
				   
		  </div><!--/End SeedSend>
	  
	      <!--Begain single-->
		  <div class="tab-pane" id="single" role="tabpanel">
		        <div class="col-xs-12 wigtbox-head form-inline">
					<form id="submitForm">
					    <div class="pull-left">
						    <input type="text" name="single_name" id="single_name" class="form-control" placeholder="单品名称" />
					        <select id="status" name="status" class="form-control">
					    	    <option value="">请选择状态</option>
						    	<option value="Y">上架</option>
						    	<option value="N">下架</option>
						    </select>
						    <button class="btn btn-info btn-sm btn-clear" type="button">
						        <i class="fa fa-remove bigger-110"></i>     
						    </button>
					        <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-single">
						        <i class="fa fa-search bigger-110"></i> 搜索     
						    </button>
					    </div>
					    
					    <div class="pull-right">
						    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" data-target="#add_single">
							    <i class="fa fa-plus bigger-110"></i> 添加
							</button>
							<button class="btn btn-danger btn-sm btn-del" data-acid="${activity.id!}" type="button" onclick="confrimDel('#grid-table-single','${CONTEXT_PATH}/seedManage/delSingleAjax',this)">
						        <i class="fa fa-trash bigger-110"></i> 删除
						    </button>
						</div>
					</form>
				</div>
				
				<div class="col-xs-12">
				    <!--Table Begain -->
				    <table id="grid-table-single"></table>
				    <div id="grid-pager-single"></div>			   
				</div><!-- /.col -->
		  
		  </div><!--/End single--> 
	  
		  <!--Begain cmobo-->
		  <div class="tab-pane" id="cmobo" role="tabpanel">
		        <div class="col-xs-12 wigtbox-head form-inline">
					<form id="submitForm">
					    <div class="pull-left">
						    <input type="text" name="package_name" id="package_name" class="form-control" placeholder="套餐名称"/>
					        <select id="status" name="status" class="form-control">
					    	    <option value="">请选择状态</option>
						    	<option value="Y">上架</option>
						    	<option value="N">下架</option>
						    </select>
						    <button class="btn btn-info btn-sm btn-clear" type="button">
						        <i class="fa fa-remove bigger-110"></i>     
						    </button>
					        <button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-table-cmobo">
						        <i class="fa fa-search bigger-110"></i> 搜索     
						    </button>
					    </div>
					    
					    <div class="pull-right">
						    <button class="btn btn-warning btn-sm" type="button" data-toggle="modal" data-target="#add_combo">
							    <i class="fa fa-plus bigger-110"></i> 添加
							</button>
							<button class="btn btn-danger btn-sm btn-del" data-acid="${activity.id!}" type="button" onclick="confrimDel('#grid-table-cmobo','${CONTEXT_PATH}/seedManage/delComboAjax',this)">
						        <i class="fa fa-trash bigger-110"></i> 删除
						    </button>
						</div>
					</form>
				</div>
				
				<div class="col-xs-12">
				    <!--Table Begain -->
				    <table id="grid-table-cmobo"></table>
				    <div id="grid-pager-cmobo"></div>			   
				</div><!-- /.col -->
		  
		  </div><!--/End cmobo-->
		  
	 </div>
</div>

<!--新增/更改种子发放周期-->
<div class="modal fade" id="add-interval" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content clearfix">
	            <div class="modal-header">
	                <h4 class="modal-title pull-left">新增/更改种子发放周期</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	            </div>
			    <div class="modal-body clearfix">
				    <form action="${CONTEXT_PATH}/seedManage/saveSeedInstAndInterval" class="form-horizontal" id="seedInstAndInterval" method="post">
					    <input type="hidden" id="activityId" name="activityId" value="${activity.id!}" />
					    <input type="hidden" id="intervalId" name="intervalId" value="0" />
					    <input type="hidden" id="send_type" name="interval.send_type" />
					    <input type="hidden" id="send_percent" name="interval.send_percent" />
					                        
					    <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right" for="interval_name">时间段区间名称</label>
					        <div class="col-sm-9">
					            <input type="text" id="interval_name" name="interval.interval_name" class="col-xs-10 col-sm-5" />
					        </div>
					    </div>
					    
					    <div class="form-group">
		        			<label class="col-sm-3 control-label no-padding-right" for="yxq_q">开始时间节点</label>
					        <div class="col-sm-9">
					            <input type="text" id="begin_time" name="interval.begin_time" 
					            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'end_time\')}'})" class="col-xs-10 col-sm-5" required/>
					            <span class="tip">(*)</span>
					        </div>
				    	</div>
				    	
					    <div class="form-group">
					        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">结束时间节点 </label>
					        <div class="col-sm-9">
					            <input type="text" id="end_time" name="interval.end_time"   
					            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'begin_time\')}'})" class="col-xs-10 col-sm-5" required/>
					            <span class="tip">(*)</span>
					        </div>
					    </div>
					    
					    <div class="form-group">
					       <label class="col-sm-3 control-label no-padding-right" for="interval_name">种子发放总数</label>
					        <div class="col-sm-9">
					            <input type="number" id="send_total" name="interval.send_total" class="col-xs-10 col-sm-5" required/><span class="tip">(*)</span>
					        </div>
					    </div>    
					    
					    <div class="form-group form-inline">
			        		<label class="col-sm-3 control-label no-padding-right">种子发放概率 </label>
			        		<div class="col-sm-9 seed-exchanges">
			            		<div class="seed-exchange">
					            	<select id="seed_type" class="seed-type form-control" name="seed_type">
					        			<#list seedType as item>
						        			<option value="${item.id}">${item.seed_name}</option>
						        		</#list>      		
					        		</select>
					        		<div class="input-group">
					        	    	<input type="number" name="percent" class="form-control" placeholder="请输入比例（<1.00）" step="0.01"/>
					        		</div>
				         		</div>
				             
				         		<div class="seed-exchange">
				            		<select id="seed_type" class="seed-type form-control" name="seed_type">
			        					<#list seedType as item>
						        			<option value="${item.id}">${item.seed_name}</option>
						        		</#list>   		
				        			</select>
					        		<div class="input-group">
					        		    <input type="number" name="percent" class="form-control" placeholder="请输入比例（<1.00）" step="0.01"/>
					        	    	<span class="input-group-btn">
					        	       	 	<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>
					        	   		</span>
					        		</div>
				        	 </div>
			         
			        	     <div class="text-left"><button type="button" class="btn btn-info btn-sm btn-seed" data-type="1"><i class="fa fa-plus"></i></button></div>
				          </div>
				       </div>
				       
				       <div class="form-group">
					       <label class="col-sm-3 control-label no-padding-right" for="interval_name">单次领取最大值</label>
					        <div class="col-sm-9">
					            <input type="number" id="max_num" name="interval.max_num" class="col-xs-10 col-sm-6" required/>
					            <div class="col-xs-6 center-block">
									<label for="send_type1"><input type="radio" id="send_type1" name="send_types" class="ace form-control" checked="checked" value="0" /><span class="lbl">固定领取</span></label>
									<label for="send_type2"><input type="radio" id="send_type2" name="send_types" class="ace form-control" value="1" /><span class="lbl">随机领取</span></label>
						        </div>
					        </div>
					    </div>
	                </form>    
			    </div> 
			    <div class="modal-footer text-center">
	           		<button class="btn btn-info" type="button" id="btn-confirm">确认</button>
	            </div> 
	        </div><!--/END Modal-content -->
	  </div><!--/END Modal-Dialog-->
</div><!--/END Modal-->

<!--新增/更改种子单品-->
<div class="modal fade" id="add_single" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
	                <h4 class="modal-title pull-left">新增/更改种子单品</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	        </div>
    		<div class="modal-body clearfix">
    		     <form action="${CONTEXT_PATH}/seedManage/saveSeedProduct" class="form-horizontal" role="form" method="post" id="seed_single">
				    <input type="hidden" name="seedProduct.activity_id" value="${activity.id!}" />
				    <input type="hidden" id="product_f_id" name="seedProduct.product_f_id" />
				    <input type="hidden" id="product_id" name="seedProduct.product_id" />
				    <input type="hidden" id="seedExchangeSingle" name="seedExchangeSingle" />
				    <input type="hidden" id="single_id" name="seedProduct.id" />
				    
				    <div class="form-group">
				       <label class="col-sm-3 control-label no-padding-right" for="single_name">名称</label>
				        <div class="col-sm-9">
				            <input type="text" id="single_name" name="seedProduct.single_name" class="col-xs-10 col-sm-5" maxlength="15" required/>
				            <span class="tip">(*)</span>
				        </div>
				    </div>
				    
				    <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="order_id">排序 </label>
				
				        <div class="col-sm-9">
				            <input type="text" id="order_id" name="seedProduct.order_id" class="col-xs-10 col-sm-5" />
				        </div>
				    </div>
				    
				    <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right">分类类型</label>
				        <div class="col-sm-9">
				            <select id="type_id" name="seedProduct.type_id">
                                    <option value="1">兑换商品</option>
					        		<option value="2">特惠商品</option>
					        		<option value="3">尝鲜商品</option>
					        		<option value="4">神秘商品</option>
                             </select>
				        </div>
				    </div>
					
					<div class="form-group form-inline">
				        <label class="col-sm-3 control-label no-padding-right">兑换种子 </label>
				        <div class="col-sm-9 seed-exchanges">
				            <div class="seed-exchange">
					            <select id="seed_type" class="seed-type form-control" name="seed_type">
					        		<#list seedType as item>
					        			<option value="${item.id}">${item.seed_name}</option>
					        		</#list>    		
					        	</select>
					        	<div class="input-group">
					        	    <input type="number" name="seed_num" class="form-control" placeholder="请输入数量" required/>
					        	</div>
					         </div>
					         
					         <div class="seed-exchange">
					            <select id="seed_type" class="seed-type form-control" name="seed_type">
				        			<#list seedType as item>
					        			<option value="${item.id}">${item.seed_name}</option>
                                    </#list>  
					        	</select>
					        	<div class="input-group">
					        	    <input type="number" name="seed_num" class="form-control" placeholder="请输入数量" required/>
					        	    <span class="input-group-btn">
					        	        <button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>
					        	    </span>
					        	</div>
					         </div>
					         
					         <div class="text-left"><button type="button" class="btn btn-info btn-sm btn-seed" data-type="0"><i class="fa fa-plus"></i></button></div>
				          </div>
				    </div>
				    
				    <div class="form-group">
				    	<label class="col-sm-3 control-label no-padding-right" for="pro_id">关联商品</label>
				    	<div class="col-sm-9">
				    		<input type="hidden" id="pro_id" placeholder="商品编号" class="col-sm-5" />
				    		<input type="text" id="pro_name" placeholder="商品名称" class="col-sm-5" />
				    		<span class="input-group-btn pull-left">
			                     <button type="button" class="btn btn-primary btn-sm btn-pro-search" data-type="single" data-toggle="modal" data-target="#pro-list">
			                     <i class="fa fa-search"></i></button>
			                </span>
				    	</div>
				    </div>
				    
				    <div class="form-group">
				       <label class="col-sm-3 control-label no-padding-right">限制奖品份数</label>
				       <div class="col-sm-3">
							<label>
								<input type="checkbox" id="isLimit" name="seedProduct.isLimit" class="ace ace-switch ace-switch-2 isLimit" value="0">
								<span class="lbl"></span>
							</label>
					   </div>
				    </div>
				    
				    <div class="form-group" style="display:none;">
				    	<label class="col-sm-3 control-label no-padding-right" for="max_num">奖品份数</label>
				    	<div class="col-sm-9">
				    		<input type="text" id="max_num" name="seedProduct.max_num" class="col-sm-5 col-xs-10 max-num" value="0"/>
				    	</div>
				    </div>
				    
				</form>
		    </div>
		    <div class="modal-footer text-center">
           		<button class="btn btn-info" type="button" id="btn-sure">确认</button>
           </div>
        </div>
    </div>
</div>

<!--新增/更改种子套餐-->
<div class="modal fade" id="add_combo" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
           <div class="modal-header">
	                <h4 class="modal-title pull-left">新增/更改种子套餐</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	        </div>
    		<div class="modal-body clearfix">
	    		<form action="${CONTEXT_PATH}/seedManage/savePackage" class="form-horizontal" id="seed_combo" role="form" method="post">
				    <input type="hidden" name="activity_id" value="${activity.id!}" />
				    <input type="hidden" id="package_id" name="package.id" />
				    <input type="hidden" id="seedExchangeCombo" name="seedExchangeCombo" />
				    <input type="hidden" id="proExchangeCombo" name="proExchangeCombo" />
				    
				    <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="package_name">套餐名称</label>
				        <div class="col-sm-9">
				            <input type="text" id="package_name" name="package.package_name" class="col-xs-10 col-sm-5" maxlength="20" required/>
				            <span class="tip">(*)</span>
				        </div>
				    </div>
				    
				    <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="order_id">排序 </label>
				        <div class="col-sm-9">
				            <input type="text" id="order_id" name="package.order_id" placeholder="排序" class="col-xs-10 col-sm-5" />
				        </div>
				    </div>
			
				    <div class="form-group">
				        <label class="col-sm-3 control-label no-padding-right" for="combo_img">套餐图片</label>
				        <div class="col-sm-9">
					        <input type="hidden" id="image_combo_src" name="image_combo_src" />
					        <img id="combo_img_url" src="" />
					        <p class="text-muted">推荐使用尺寸为200X200 (单位:px)</p>
							<input type="button" id="combo_img" value="选择图片" />
				        </div>
				    </div>	
				    
				    <div class="form-group form-inline">
				        <label class="col-sm-3 control-label no-padding-right">套餐分类 </label>
				        <div class="col-sm-9">
				            <select id="type_id" class="form-control" name="package.type_id">
			                    <option value="1">兑换商品</option>
				        		<option value="2">特惠商品</option>
			                </select>
				        </div>
				    </div>
				    
				    <div class="form-group form-inline">
				        <label class="col-sm-3 control-label no-padding-right">兑换种子 </label>
				        <div class="col-sm-9 seed-exchanges">
					            <div class="seed-exchange">
						            <select id="seed_type" class="seed-type form-control" name="seed_type">
					        			<#list seedType as item>
						        			<option value="${item.id}">${item.seed_name}</option>
						        		</#list>    		
						        	</select>
						        	<div class="input-group">
						        	    <input type="number" name="seed_num" class="form-control" placeholder="数量" required/>
						        	</div>
						         </div>
						         
						         <div class="seed-exchange">
						            <select id="seed_type" class="seed-type form-control" name="seed_type">
					        			<#list seedType as item>
						        			<option value="${item.id}">${item.seed_name}</option>
						        		</#list>     		
						        	</select>
						        	<div class="input-group">
						        	    <input type="number" name="seed_num" class="form-control" placeholder="数量" required/>
						        	    <span class="input-group-btn">
						        	        <button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>
						        	    </span>
						        	</div>
						         </div>
					        <div class="text-left"><button type="button" class="btn btn-info btn-sm btn-seed" data-type="0"><i class="fa fa-plus"></i></button></div>
				         </div>
				    </div>
				    
				    <div class="form-group form-inline">
				        <label class="col-sm-3 control-label no-padding-right">关联商品 </label>
				        <div class="col-sm-9 relative-pros">
				        		<div class="relative-pro">   	
						            <input type="hidden" name="pro_id" class="pro-id" />
						            <input type="hidden" name="pro_unit_id" class="pro-unit-id" />
					            	<input type="text" name="pro_num" class="pro-num mr5 col-xs-2" placeholder="数量"/>
						        	<div class="input-group">    
						        	    <input type="text" name="pro_name" class="form-control pro-name" />
						        	    <span class="input-group-btn">
						        	       <button type="button" class="btn btn-primary btn-sm btn-pro-search" data-toggle="modal" data-target="#pro-list" data-type="combo" data-index="0"><i class="fa fa-search"></i></button>
						        	    </span>
						        	</div>
						        </div>
					        	<div class="relative-pro">   	
						            <input type="hidden" name="pro_id" class="pro-id" />
						            <input type="hidden" name="pro_unit_id" class="pro-unit-id" />
					            	<input type="text" name="pro_num" class="pro-num mr5 col-xs-2" placeholder="数量"/>
						        	<div class="input-group">    
						        	    <input type="text" name="pro_name" class="form-control pro-name" />
						        	    <span class="input-group-btn">
						        	       <button type="button" class="btn btn-primary btn-sm btn-pro-search" data-toggle="modal" data-target="#pro-list" data-type="combo" data-index="1"><i class="fa fa-search"></i></button>
						        	    </span>
						        	</div>
						         </div>
					             <div class="text-left"><button type="button" class="btn btn-info btn-sm" id="btn-pro"><i class="fa fa-plus"></i></button></div>
				          </div>
				    </div>
				    
				    <div class="form-group">
				       <label class="col-sm-3 control-label no-padding-right">限制奖品份数</label>
				       <div class="col-sm-3">
							<label>
								<input type="checkbox" id="isLimit" name="package.isLimit" class="ace ace-switch ace-switch-2 isLimit" value="0">
								<span class="lbl"></span>
							</label>
					   </div>
				    </div>
				    
				    <div class="form-group" style="display:none;">
				    	<label class="col-sm-3 control-label no-padding-right" for="max_num">奖品份数</label>
				    	<div class="col-sm-9">
				    		<input type="text" id="max_num" name="package.max_num" class="col-sm-5 col-xs-10 max-num" value="0"/>
				    	</div>
				    </div>
				    
				</form>
    		
		    </div>
		    <div class="modal-footer text-center">
           		<button class="btn btn-info" type="button" id="btn-okay">确认</button>
           </div>
        </div>
    </div>
</div>

<!--种子发放管理统计模块  -->
<div class="modal fade" id="activity_statistics" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" style="width:800px">
			<div class="modal-content">
	            <div class="modal-header">
	                <h4 class="modal-title pull-left">活动数据统计</h4>
	                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <div class="clearfix"></div>
	            </div>
	           <div class="modal-body clearfix">
	               <input type="hidden" name="interval_id" id="interval_id" value="0"/>
	               <div class="col-xs-12 nopd-lr wigtbox-head form-inline hidden">
					    <div class="pull-left">
						    <div class="input-group">
								  <input type="text" id="start_time" placeholder="开始时间" name="start_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
					        	至 <input type="text" id="end_time" placeholder="结束时间" name="end_time"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
						    </div>
					    </div>
					    <div class="pull-right">
					        <button class="btn btn-primary btn-sm" type="button" id="btn-statistic">
						        <i class="fa fa-search bigger-110"></i> 搜索     
						    </button>
						</div>
					</div>
														
					<div class="row">
						<div class="col-sm-6 nopd-lr">
							<div id="seed_chart" style="width:384px; height: 200px; margin: 0 auto; clear: both;"></div>
						</div>
						<div class="col-sm-6">
						    <table class="table table-hover table-bordered" id="seed_receive">
							    <thead>
						          <tr>
						            <th>种子类型</th>
						            <th>用户领取数</th>
						          </tr>
						     </thead>
						     <tbody>
						         <tr>
						            <td>已领取总数</td>
						            <td>14352</td>
						         </tr>
						         <tr>
						            <td>初春种子</td>
						            <td>0</td>
						         </tr>
						          <tr>
						            <td>盛夏种子</td>
						            <td>0</td>
						         </tr>
						          <tr>
						            <td>金秋种子</td>
						            <td>14352</td>
						         </tr> 
						         <tr>
						            <td>暖冬种子</td>
						            <td>0</td>
						         </tr>
						          <tr>
						            <td>神秘种子</td>
						            <td>0</td>
						         </tr>
						     </tbody>
						    </table>
		               </div>
	                </div>
	  
			   </div>
			   <div class="modal-footer text-center">
	           		<button type="button" class="btn btn-info" data-dismiss="modal" id="btn-close">确认</button>
		      </div>
	        </div>
         
    </div>
</div>

<!--关联商品 Grid-->
<div class="modal fade" id="pro-list" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" style="width:800px">
        		<div class="modal-content clearfix">
		            <div class="modal-header">
		                <h4 class="modal-title pull-left">关联商品</h4>
		                <button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">&times;</button>
		                <div class="clearfix"></div>
		            </div>
		            <div class="modal-content clearfix">
			           	<form id="submitForm">
						    <div class="col-xs-12 wigtbox-head form-inline mt10">
						       <div class="pull-left">
						            <input type="hidden" name="pro-index" id="pro-index"/>
						            <input type="hidden" name="type" id="type" />
								    <input type="text" id="productExceptName" name="productExceptName" placeholder="请输入名称" class="form-control"/>
							   		<select  id="productExceptStatus" name="productExceptStatus" class="form-control">
										<option value="01">正常</option>
										<option value="02">禁采</option>
										<option value="03">停止下单</option>
									</select>
									<button class="btn btn-primary btn-sm btn-search" type="button" data-grid="#grid-product-table">
								        <i class="fa fa-search bigger-110"></i> 搜索     
								    </button>
							    </div>
							    <div class="pull-right">
								    <button class="btn btn-success btn-sm" type="button" id="btn-relative">确认</button>
								</div>
						    </div>
						</form>
						<div class="col-xs-12">
						    <!--Table Begain -->
				            <table id="grid-product-table"></table>
		       				<div id="grid-product-pager"></div>  
	       				</div><!--/END col-->
	       			</div>       
               </div>
    </div>
</div>
</@layout>

<script>
		var K=window.KindEditor;
		var resuorceEditor;
		var editor;
		<#if activity.id??>
			KindEditor.ready(function(K) {
	            resuorceEditor = K.create('textarea[id="editor"]', {
					cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
					uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+K('#main_title').val(),
					fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+K('#main_title').val(),
					allowFileManager : true,
					afterCreate : function() {
						var self = this;
						K.ctrl(document, 13, function() {
							self.sync();
							document.forms['editForm'].submit();
						});
						K.ctrl(self.edit.doc, 13, function() {
							self.sync();
							document.forms['editForm'].submit();
						});
					}
			    });
				   
		        editor = K.editor({
					cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
					uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=种子购活动',
					fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=种子购活动',
					allowFileManager : true,
				});
				
				K('#image').click(function () {
					resuorceEditor.loadPlugin('image', function () {
						resuorceEditor.plugin.imageDialog({
							imageUrl: K('#image_src').val(),
							clickFn: function (url, title, width, height, border, align) {
								K('#image_src').val(url);
								K('#url2').attr("src",url);
								resuorceEditor.hideDialog();
							 }
						});
					});
				});
				
				K('#combo_img').click(function() {
					editor.loadPlugin('image', function() {
						//图片弹窗的基本参数配置
						editor.plugin.imageDialog({
							imageUrl : K('#combo_img_url').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
							//点击弹窗内”确定“按钮所执行的逻辑
							clickFn : function(url, title, width, height, border, align) {
								K('#image_combo_src').val(url);//图片地址存储
								K('#combo_img_url').attr("src",url);//显示图片
								editor.hideDialog(); //隐藏弹窗
							}
						});
					});
				});
				
				prettyPrint();
			});
		<#else>
			K('#main_title').blur(function (){
				 if($('#main_title').val()==''){
						alert("请先填写活动主标题");
						return;
				 }
			     resuorceEditor=K.create('textarea[id="editor"]', {
					cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
					uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName='+K('#main_title').val(),
					fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName='+K('#main_title').val(),
					allowFileManager : true,
					afterCreate : function() {
						var self = this;
						K.ctrl(document, 13, function() {
							self.sync();
							document.forms['editForm'].submit();
						});
						K.ctrl(self.edit.doc, 13, function() {
							self.sync();
							document.forms['editForm'].submit();
						});
					}
				});
					
			});
			
			editor = K.editor({
				cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
				uploadJson : '${CONTEXT_PATH}/resourceShow/upload?dir=activity&idName=种子购活动',
				fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage?dir=activity&idName=种子购活动',
				allowFileManager : true,
			});
		   
			K('#image').click(function () {
					resuorceEditor.loadPlugin('image', function () {
						resuorceEditor.plugin.imageDialog({
							imageUrl: K('#image_src').val(),
							clickFn: function (url, title, width, height, border, align) {
								K('#image_src').val(url);
								K('#url2').attr("src",url);
								resuorceEditor.hideDialog(); //隐藏弹窗
							 }
						});
					});
			});
			
			K('#combo_img').click(function() {
				editor.loadPlugin('image', function() {
					//图片弹窗的基本参数配置
					editor.plugin.imageDialog({
						imageUrl : K('#combo_img_url').val(), //如果图片路径框内有内容直接赋值于弹出框的图片地址文本框
						//点击弹窗内”确定“按钮所执行的逻辑
						clickFn : function(url, title, width, height, border, align) {
							K('#image_combo_src').val(url);//图片地址存储
							K('#combo_img_url').attr("src",url);//显示图片
							editor.hideDialog(); //隐藏弹窗
						}
					});
				});
			});
    </#if>
        
    $(function(){
       
	    var grid_selector = "#grid-table-seed";
	    var pager_selector = "#grid-pager-seed";
	    
	    var grid_selector_cmobo="#grid-table-cmobo";
	    var pager_selector_cmobo="#grid-pager-cmobo";
	    
	    var grid_selector_single="#grid-table-single";
	    var pager_selector_single="#grid-pager-single";

	    var grid_product_selector = "#grid-product-table";
	    var pager_product_selector = "#grid-product-pager";

        //TODO: 新增两个JSON串字段 编辑初始化时先反序列化为JSON对象回填值和选中checkbox
        if($("#share_send").val()!=""&&$('#gm_send').val()!=""){
		   	var shareSendObj=JSON.parse($("#share_send").val());
		   	var gmSendObj=JSON.parse($('#gm_send').val());
		   	
		    if(shareSendObj.isShare=="true"){
	            $('#isShare').attr("checked","checked");
	            $('#isShare').val("true"); 
			}else{
				$('#isShare').attr("checked",false);
	            $('#isShare').val("false");
	            //隐藏关联div 
	            $('.share-seed').hide();
		    }
		    
		    if(gmSendObj.isPurchase=="true"){
		    	$('#isPurchase').attr("checked","checked");
	            $('#isPurchase').val("true"); 
			}else{
				$('#isPurchase').attr("checked",false);
	            $('#isPurchase').val("false"); 
	            //隐藏关联div
	            $('.purchase-seed').hide(); 
		    }
	    
	        $('#share_seed_type').val(shareSendObj.seedTypeId);
	        $('#share_seed_num').val(shareSendObj.seedNum);
		    $('#gms_seed_type').val(gmSendObj.seedTypeId);
	        $('#gms_seed_num').val(gmSendObj.seedNum);
        
	        if(shareSendObj.frequence=="0"){
	            $('#frequence').attr("checked","checked");
	        }else{
	        	$('#frequence2').attr("checked","checked");
	        }
	
	        if(gmSendObj.mode=="0"){
	            $('#mode').attr("checked","checked");
	        }else{
	        	$('#mode2').attr("checked","checked");
	        }
        }
        
	    jQuery(grid_selector).jqGrid({
	        url:"${CONTEXT_PATH}/seedManage/getIntervalsJson?activity_id="+jQuery("#activity_id").val(),
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','段区间名称','开始时间', '结束时间','发放数量','发放类型','发放状态','操作'],
	        colModel:[
	            {name:'inte.id',index:'id', editable: true},
	            {name:'inte.interval_name',index:'interval_name', editable:true},
	            {name:'inte.begin_time',index:'begin_time',editable: true},
	            {name:'inte.end_time',index:'end_time',editable: true},
	            {name:'inte.send_total',index:'send_total',editable: true,
	            	formatter:function(cellvalue,options,rows){
                        //console.log(cellvalue);
                        if(!cellvalue){return "N/A"}
                        return cellvalue;
                   }
		        },
	            {name:'inte.send_type',index:'send_type',editable: true,
	            	formatter:function(cellvalue,options,rows){
                         //console.log(cellvalue);
                         if(rows[5]==0){
                             return "固定";
                         }else{
                        	 return "随机";
                         }
                    }
		        },
	            {name:'inte.status',index:'status',editable: true,
                    formatter:function(cellvalue,options,rows){
                    	 //console.log(cellvalue);
                    	 if(rows[6]==0){
                    		 return "关闭";
                         }else if(rows[6]>0){
                        	 return "开启";
                         }else{
                        	 return "N/A";
                         }
                     }
		        },
	            {name:'myac',index:'', fixed:true, sortable:false, resize:false,
	            	formatter:function(cellvalue, options, rows) { 
	                    //console.log(rows[6]);
	                    var acid=$('#activity_id').val();
		               	if(rows[6] == 1){
		               		return  '<a class="btn btn-danger btn-xs mr5" title="关闭发放" data-grid="grid-table-seed" onclick =ChangeStatus('+rows[0]+',"'+rows[6]+'",this,"${CONTEXT_PATH}/seedManage/changeIntervalStatus")><i class="fa fa-cloud-download"></i></a>'+
				                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已开启的活动,需先关闭再编辑")><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已开启的活动,需先关闭再删除")><i class="fa fa-trash"></i></a>'+
				                '<a class="btn btn-default btn-xs" title="数据统计" data-toggle="modal" data-target="#activity_statistics" data-start-time="'+rows[2]+'" data-end-time="'+rows[3]+'" data-id="'+rows[0]+'"><i class="fa fa-line-chart"></i></a>';
		               	}else{
						    	return  '<a class="btn btn-success btn-xs mr5" title="开启发放" data-grid="grid-table-seed" onclick = ChangeStatus('+rows[0]+',"'+rows[6]+'",this,"${CONTEXT_PATH}/seedManage/changeIntervalStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
				                '<a class="btn btn-warning btn-xs mr5" title="修改" data-id="'+rows[0]+'" data-toggle="modal" data-target="#add-interval"><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" data-acid="'+acid+'" onclick=confrimDel("#grid-table-seed","${CONTEXT_PATH}/seedManage/delIntervalAjax",this)><i class="fa fa-trash"></i></a>'+
				                '<a class="btn btn-default btn-xs" title="数据统计" data-toggle="modal" data-target="#activity_statistics" data-start-time="'+rows[2]+'" data-end-time="'+rows[3]+'" data-id="'+rows[0]+'"><i class="fa fa-line-chart"></i></a>';
		               	}
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
	        editurl: "${CONTEXT_PATH}/seedManage/saveInterval",
	        caption: "活动时间段管理",
	        autowidth: true,
	        sortname:'begin_time',
	        sortorder:'desc'
	    });
		       
	    jQuery(grid_selector_single).jqGrid({
	        url:"${CONTEXT_PATH}/seedManage/getSeedProductList?activity_id="+jQuery("#activity_id").val(),//+jQuery("#activity_id").val()
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','单品名称','商品名称','顺序','分类类型','状态','操作'],
	        colModel:[
	            {name:'seed_product.id',index:'id', editable: false},
	            {name:'single_name',index:'single_name', editable: true},
	            {name:'product_name',index:'product_name', editable: false},
	            {name:'seed_product.order_id',index:'order_id', editable:true},
	            {name:'seed_product.type_id',index:'type_id',editable: false,
	            	formatter:function(cellvalue,options,rows){
		            	if(!cellvalue){return "N/A"};
		            	switch(cellvalue){
                        	case 1:
                        		return "普通商品";
                            	break;
                        	case 2:
                        		return "尝鲜商品";
                            	break;
                        	case 3:
                        		return "特惠商品";
                            	break;
                        	case 4:
                        		return "神秘商品";
                            	break;
                            default:
                                return "普通商品";
                        }
                   }
		        },
	            {name:'seed_product.status',index:'status',editable: true,
	            	formatter:function(cellvalue,options,rows){
                        //console.log(cellvalue);
                        if(cellvalue=="Y"){
                            return "上架";
                        }else{
                       	    return "下架";
                        }
                   }
		        },
	            {name:'myac',index:'', fixed:true, sortable:false, resize:false,
	            	formatter:function(cellvalue, options, rows) { 
		            	var acid=$('#activity_id').val();
		               	if(rows[5] == "Y"){
		               		return  '<a class="btn btn-danger btn-xs mr5" title="下架单品" data-grid="grid-table-single" onclick =ChangeStatus('+rows[0]+',"'+rows[5]+'",this,"${CONTEXT_PATH}/seedManage/changeSingleStatus")><i class="fa fa-cloud-download"></i></a>'+
				                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已上架的单品,需先下架再编辑")><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已上架的单品,需先下架再删除")><i class="fa fa-trash"></i></a>';
		               	}else{
						    	return  '<a class="btn btn-success btn-xs mr5" title="上架单品" data-grid="grid-table-single" onclick = ChangeStatus('+rows[0]+',"'+rows[5]+'",this,"${CONTEXT_PATH}/seedManage/changeSingleStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
				                '<a class="btn btn-warning btn-xs mr5" title="修改" data-pro-name="'+rows[2]+'" data-id="'+rows[0]+'" data-toggle="modal" data-target="#add_single"><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" data-acid="'+acid+'" onclick=confrimDel("#grid-table-single","${CONTEXT_PATH}/seedManage/delSingleAjax",this)><i class="fa fa-trash"></i></a>';
		               	}
				    }
	            }
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : pager_selector_single,
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
	        editurl: "${CONTEXT_PATH}/seedManage/gDSaveSeedProduct",
	        caption: "单品管理",
	        autowidth: true,
	        sortname:'status',
	        sortorder:'desc'
	   });    

	   jQuery(grid_selector_cmobo).jqGrid({
	        url:"${CONTEXT_PATH}/seedManage/getPackageList?activity_id="+jQuery("#activity_id").val(),
	        mtype: "post",
	        datatype: "json",
	        height: '100%',
	        colNames:['编号','套餐名称','顺序','套餐类型','状态','操作'],
	        colModel:[
	            {name:'package.id',index:'id', editable: true},
	            {name:'package.package_name',index:'package_name', editable:true, sorttype:"date"},
	            {name:'package.order_id',index:'order_id',editable:true},
	            {name:'package.type_id',index:'type_id',editable: false,
	            	formatter:function(cellvalue,options,rows){
		            	if(!cellvalue){return "N/A"};
                        switch(cellvalue){
                        	case 1:
                        		return "普通套餐";
                            	break;
                        	case 2:
                        		return "尝鲜套餐";
                            	break;
                        	case 3:
                        		return "特惠套餐";
                            	break;
                        	case 4:
                        		return "神秘套餐";
                            	break;
                            default:
                                return "普通套餐";
                        }
                   }
		        },
	            {name:'package.status',index:'status',editable: true,edittype:"select",editoptions:{value:"Y:上架;N:下架"},
	            	formatter:function(cellvalue,options,rows){
                        //console.log(cellvalue);
                        if(cellvalue=="Y"){
                            return "上架";
                        }else{
                       	    return "下架";
                        }
                    }
		        },
	            {name:'myac',index:'',fixed:true, sortable:false, resize:false,
	            	formatter:function(cellvalue, options, rows) { 
	            		var acid=$('#activity_id').val();
		               	if(rows[4] == "Y"){
		               		return  '<a class="btn btn-danger btn-xs mr5" title="下架套餐" data-grid="grid-table-cmobo" onclick =ChangeStatus('+rows[0]+',"'+rows[4]+'",this,"${CONTEXT_PATH}/seedManage/changeCmoboStatus")><i class="fa fa-cloud-download"></i></a>'+
				                '<a class="btn btn-warning btn-xs mr5" title="修改" onclick=disableEdit("不能编辑已上架的套餐,需先下架再编辑")><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" onclick=disableDel("不能删除已上架的套餐,需先下架再删除")><i class="fa fa-trash"></i></a>';
		               	}else{
						    	return  '<a class="btn btn-success btn-xs mr5" title="上架套餐" data-grid="grid-table-cmobo" onclick = ChangeStatus('+rows[0]+',"'+rows[4]+'",this,"${CONTEXT_PATH}/seedManage/changeCmoboStatus")><i class="fa fa-cloud-upload"></i></a>'+ 
				                '<a class="btn btn-warning btn-xs mr5" title="修改" data-id="'+rows[0]+'" data-toggle="modal" data-target="#add_combo"><i class="fa fa-edit"></i></a>'+
				                '<a class="btn btn-danger btn-xs mr5" title="删除" data-acid="'+acid+'" onclick=confrimDel("#grid-table-cmobo","${CONTEXT_PATH}/seedManage/delCmoboAjax",this)><i class="fa fa-trash"></i></a>';
		               	}
				    }
	            },
	        ],
	        viewrecords : true,
	        rowNum:10,
	        rowList:[10,20,30],
	        pager : pager_selector_cmobo,
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
	        editurl: "${CONTEXT_PATH}/seedManage/gDSavePackage",
	        caption: "套餐管理",
	        autowidth: true,
	        sortname:'status',
	        sortorder:'desc'
	   });

	   jQuery(grid_product_selector).jqGrid({
	       url:"${CONTEXT_PATH}/seedManage/seedSelectToAddProductList",
	       mtype: "post",
	       datatype: "json",
	       height: '100%',
	       colNames:['序号','首图', '商品名称', '价格','特价','商品编号','规格编号','规格','单位'],
	       colModel:[
	           {name:'pf_id',index:'pf_id', sorttype:"int", editable: false},
	           {name:'save_string',index:'save_string', editable:false,
	               formatter:function(value,options,rows){
	                   if(!value){return "N/A"}
	               	   return '<img src="'+value+'" width="40" height="40" class="img-responsive" onerror="imgLoad(this) "/>';
	               }
	           },
	           {name:'product_name',index:'product_name',editable: false},
	           {name:'price',index:'price',editable: false},
	           {name:'special_price',index:'special_price',editable: false},
	           {name:'id',index:'id',editable: false},
	           {name:'pf_id',index:'pf_id',editable: false},
	           {name:'standard',index:'standard',editable: false},
	           {name:'unit_name',index:'unit_name',editable: false}
	       ],
	       viewrecords : true,
	       rowNum:10,
	       rowList:[10,20,30,100,500],
	       pager : pager_product_selector,
	       emptyrecords : "未找到任何数据",
	       pgtext: "第{0}页 共{1}页",
	       altRows: true,
	       multiselect: true,
	       multiboxonly: true,
			editurl: "",
	       loadComplete : function() {
	           var table = this;
	           setTimeout(function(){
	               updatePagerIcons(table);
	               enableTooltips(table);
	           }, 0);
	       },
	       caption: "选择单品",
	       autowidth: false,
	       shrinkToFit:true,
	       width:765
	   });
		   
	   initNavGrid(grid_selector,pager_selector);
	   initNavGrid(grid_selector_cmobo,pager_selector_cmobo);
	   initNavGrid(grid_selector_single,pager_selector_single);
	   initNavGrid(grid_product_selector,pager_product_selector);
	   
	   //种子套餐新增或修改
       $('#add_combo').on('show.bs.modal',function(e){
     	   var $button=$(e.relatedTarget);
           var modal=$(this);
           var id=$button.data("id");
           //如果有id值则为修改,否则为新增
           if(id==null||id==""){
               //添加直接show
               $('#seed_combo')[0].reset();
 		       //隐藏字段也清除掉
 		       $('#package_id').val("");
 		       modal.find('#isLimit').val("0");
 		       $('#seedExchangeCombo').val("");
 		       $('#proExchangeCombo').val("");
               return;
           }else{
 	          //发送ajax回去查询单条数据
 	          $.ajax({
 	                url:'${CONTEXT_PATH}/seedManage/comboDetail',
 	                type:'Get',
 	                data:{id:id},
 	                success:function(result){
 	                    if(result.success){
 	                        //回填数据
 	                        modal.find('#package_id').val(result.data.id);
 	                        modal.find("#package_name").val(result.data.package_name);
 	                        modal.find("#type_id").val(result.data.type_id);
 	                        modal.find("#order_id").val(result.data.order_id);
 	                        modal.find("#seedExchangeCombo").val(JSON.stringify(result.seedExchangeCombo));
 	                        modal.find("#proExchangeCombo").val(JSON.stringify(result.proExchangeCombo));
 	                        modal.find('#max_num').val(result.data.max_num);
 	                        modal.find('#isLimit').val(result.data.isLimit);
 	                        modal.find('#image_combo_src').val(result.image.save_string);
 	                        modal.find("#combo_img_url").attr("src",result.image.save_string);
 	                       //TODO: 新增种子发放JSON串字段 编辑初始化时选中checkbox
 	                        if(result.data.isLimit==1){
 	                        	modal.find('#isLimit').prop("checked","checked");
 	                        	modal.find('#max_num').parents('.form-group').show();
 	 	 	                }else{
 	 	 	                	modal.find('#isLimit').prop("checked",false);
 	                        	modal.find('#max_num').parents('.form-group').hide();
 	 	 	 	            }
 	                       
 	                		//清空之前存在的seed-exchange
 	                		modal.find('.seed-exchange').remove();
 	                		modal.find('.relative-pro').remove();
 	                		
 	                		var seedComboArr=result.seedExchangeCombo;
 	                		var listNum=seedComboArr.length;
 			                var removeBtn='<span class="input-group-btn">'+
 					        	        '<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>'+
 					        	     '</span>';
 				            var markup='<div class="seed-exchange">'+
 						            '<select id="seed_type" class="seed-type form-control" name="seed_type">'+
 						        		<#list seedType as item>
 						        			'<option value="${item.id}">${item.seed_name}</option>'+ 
 						        		</#list>      		
 						        	'</select> '+
 						        	'<div class="input-group">'+
 						        	    '<input type="number" name="seed_num" class="form-control" placeholder="请输入数量" required/>'+
 						        	     (listNum>1?removeBtn:"")+
 						        	'</div>'+
 						         '</div>';
 						         
                             //循环生成seedComboList
                             for(let i=0;i<listNum;i++){
                                 //先添加相对应个数的DOM
                                 modal.find('.btn-seed').parent().before(markup);
                                 //再进行赋值
                                 var seedNode=modal.find('.seed-exchange').eq(i);
                                 seedNode.find("#seed_type").val(seedComboArr[i].seedType);
                                 seedNode.find("input[name=seed_num]").val(seedComboArr[i].seedNum);
                                 //第一个没有删除按钮
                                 if(i==0){
                                     seedNode.find('input[name=seed_num]').next('span').remove();
                                     continue;
                                 }
                             }
                             
                             var proArr=result.proExchangeCombo;
  	                		 var prolistNum=proArr.length;
                             var removeBtnPro='<button type="button" class="btn btn-danger btn-sm btn-remove-pro"><i class="fa fa-remove"></i></button>';
	               	         var markupPro='<div class="relative-pro">'+               	
	               		                '<input type="hidden" name="pro_id" class="pro-id" />'+
	               		                '<input type="hidden" name="pro_unit_id" class="pro-unit-id" />'+
	               		            	'<input type="text" name="pro_num" class="pro-num col-xs-2 mr5" placeholder="数量"/>'+
	               			        	'<div class="input-group">'+	        	  		        	   
	               			        	    '<input type="text" name="pro_name" class="form-control pro-name" placeholder=""/>'+
	               			        	    '<span class="input-group-btn">'+
	               			        	       '<button type="button" class="btn btn-primary btn-sm btn-pro-search" data-toggle="modal" data-type="combo" data-target="#pro-list" data-index="'+prolistNum+'"><i class="fa fa-search"></i>'+
	               	                           (prolistNum>=2?removeBtnPro:"")+  		        	       
	               			        	    '</span>'+
	               			        	'</div>'+
	               			         '</div>';
	               			         
	               	         //循环生成proList
                             for(let i=0;i<prolistNum;i++){
                                 //先添加相对应个数的DOM
                                 modal.find('#btn-pro').parent().before(markupPro);
                                 //再进行赋值
                                 var proNode=modal.find('.relative-pro').eq(i);
                                 proNode.find(".pro-id").val(proArr[i].proId);
                                 proNode.find(".pro-unit-id").val(proArr[i].proUnitId); 
                                 proNode.find(".pro-num").val(proArr[i].proNum);
                                 proNode.find(".pro-name").val(proArr[i].proName);
                                 proNode.find(".btn-pro-search").attr("data-index",i);
                                 //第一个没有删除按钮
                                 if(i==0||i==1){
                                	 proNode.find('.btn-remove-pro').remove();
                                     continue;
                                 }
                             }
 	                    }
 	                    else
 	                    {
 	                    	modal.modal('hide');
 	                        $.alert('提示',result.msg);
 	                    }
 	                }
 	          });
           }
       });
       
	   //种子套餐编辑提交
	   $('#btn-okay').on("click",function(){
	        //兑换种子数组
	        var seedArray=new Array();
            var seedNodes=$(this).parents('.modal-content').find('.seed-exchange');
		    var len=seedNodes.length;
		    var seed=new Object();
		    //校验
            var validetor=$('#seed_combo').validate();
           
            if(!validetor.form()){
                return false;
            }
	           
		    for(var i=0;i<len;i++){
		        var obj=new Object();
		        obj.seedType=seedNodes.eq(i).find('.seed-type').val();
		        obj.seedNum=seedNodes.eq(i).find('input[name="seed_num"]').val();
		        if(obj.seedNum==''){
	            	continue;
	            }
		        seedArray.push(obj);
		    }
		    console.log(JSON.stringify(seedArray));
	        $("#seedExchangeCombo").val(JSON.stringify(seedArray));
	        //关联商品数组
	        var relativeArray=new Array();
	        var rlen=$('.relative-pro').length;
	        var relativePro=new Object();
	        
	        for(var x=0;x<rlen;x++){
		        var obj=new Object();
		        var currentNode=$('.relative-pro').eq(x);
		        obj.proId=currentNode.find('.pro-id').val();
		        obj.proUnitId=currentNode.find('.pro-unit-id').val();
		        obj.proNum=currentNode.find('.pro-num').val();
		        if(obj.proNum==''){
	            	continue;
	            }
		        relativeArray.push(obj);
		    }
	        $("#proExchangeCombo").val(JSON.stringify(relativeArray));
	        console.log(JSON.stringify(relativeArray));
	        $("#seed_combo").submit();   
	    });
	    
	    $('.relative-pros').on('click','.btn-remove-pro',function(e){
           var $remove=$(e.currentTarget);
           $remove.parents('.relative-pro').remove();
        });
        
	    $('#pro-list').on('show.bs.modal', function (e) {
            var $button=$(e.relatedTarget);
            var index=$button.data("index");
            var type=$button.data("type");
            $('#type').val(type);
            $('#pro-index').val(index);        
	    });
		
	    //两个模态框嵌套时 第二个关闭导致第一个不能滚动
	    $('#pro-list').on('hidden.bs.modal', function() {
	    	$('#add_combo').css({'overflow-y':'scroll'});
	    });
	    
	    $('#btn-pro').on('click',function(){
	         var existNum=$('.relative-pro').length;
	         var removeBtn='<button type="button" class="btn btn-danger btn-sm btn-remove-pro"><i class="fa fa-remove"></i></button>';
	         		        	    
	          var markup='<div class="relative-pro">'+               	
		                '<input type="hidden" name="pro_id" class="pro-id" />'+
		                '<input type="hidden" name="pro_unit_id" class="pro-unit-id" />'+
		            	'<input type="text" name="pro_num" class="pro-num col-xs-2 mr5" placeholder="数量"/>'+
			        	'<div class="input-group">'+	        	  		        	   
			        	    '<input type="text" name="pro_name" class="form-control pro-name" placeholder=""/>'+
			        	    '<span class="input-group-btn">'+
			        	       '<button type="button" class="btn btn-primary btn-sm btn-pro-search" data-toggle="modal" data-type="combo" data-target="#pro-list" data-index="'+existNum+'"><i class="fa fa-search"></i>'+
	                        (existNum>=2?removeBtn:"")+  		        	       
			        	    '</span>'+
			        	'</div>'+
			         '</div>';
			         
			     if(existNum>=10){
			        $.dialog.alert('请不要超过10个');
			         return false;
			     }
			     
	          $(this).parent().before(markup);
	    });
    
	   //种子单品新增或修改
       $('#add_single').on('show.bs.modal',function(e){
     	   var $button=$(e.relatedTarget);
           var modal=$(this);
           var id=$button.data("id");
           var proNmae=$button.data("pro-name");
           if(proNmae){
               modal.find('#pro_name').val(proNmae);
           }
           //如果有id值则为修改,否则为新增
           if(id==null||id==""){
               //添加直接show
               $('#seed_single')[0].reset();
 		       //隐藏字段也清除掉
 		       $('#product_f_id').val("");
 		       $('#product_id').val("");
 		       $('#single_id').val("");
 		       $('#isLimit').val("0");
 		       $('#seedExchangeSingle').val("");
               return;
           }else{
 	          //发送ajax回去查询单条数据
 	          $.ajax({
 	                url:'${CONTEXT_PATH}/seedManage/singleDetial',
 	                type:'Get',
 	                data:{id:id},
 	                success:function(result){
 	                    if(result.success){
 	                        //回填数据
 	                        modal.find('#single_id').val(result.data.id);
 	                        modal.find("#single_name").val(result.data.single_name);
 	                        modal.find("#type_id").val(result.data.type_id);
 	                        modal.find("#order_id").val(result.data.order_id);
 	                        modal.find("#seedExchangeSingle").val(JSON.stringify(result.seedProList));
 	                        modal.find("#product_id").val(result.data.product_id);
 	                        modal.find("#product_f_id").val(result.data.product_f_id);
 	                        modal.find('#pro_id').val(result.data.product_id);
 	                        modal.find('#max_num').val(result.data.max_num);
 	                        modal.find('#isLimit').val(result.data.isLimit);
 	                        
 	                        if(result.data.isLimit==1){
 	                        	modal.find('#isLimit').prop("checked","checked");
 	                        	modal.find('#max_num').parents('.form-group').show();
 	 	 	                }else{
 	 	 	                	modal.find('#isLimit').prop("checked",false);
 	                        	modal.find('#max_num').parents('.form-group').hide();
 	 	 	 	            }
 	                        //TODO: 新增种子发放JSON串字段 编辑初始化时选中checkbox
 	                		//清空之前存在的seed-exchange
 	                		modal.find('.seed-exchange').remove();
 	                		
 	                		var seedArr=result.seedProList;
 	                		var listNum=seedArr.length;
 	                		
 			                var removeBtn='<span class="input-group-btn">'+
 					        	        '<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>'+
 					        	     '</span>';
 					        	     
 				            var markup='<div class="seed-exchange">'+
 						            '<select id="seed_type" class="seed-type form-control" name="seed_type">'+
 						        		<#list seedType as item>
 						        			'<option value="${item.id}">${item.seed_name}</option>'+ 
 						        		</#list>      		
 						        	'</select> '+
 						        	'<div class="input-group">'+
 						        	    '<input type="number" name="seed_num" class="form-control" placeholder="请输入数量" required/>'+
 						        	     (listNum>1?removeBtn:"")+
 						        	'</div>'+
 						         '</div>';
 						         
                             //循环生成seedList
                             for(let i=0;i<listNum;i++){
                                 //先添加相对应个数的DOM
                                 modal.find('.btn-seed').parent().before(markup);
                                 //再进行赋值
                                 var seedNode=modal.find('.seed-exchange').eq(i);
                                 seedNode.find("#seed_type").val(seedArr[i].seedType);
                                 seedNode.find("input[name=seed_num]").val(seedArr[i].seedNum);
                                 //第一个没有删除按钮
                                 if(i==0){
                                     seedNode.find('input[name=seed_num]').next('span').remove();
                                     continue;
                                 }
                             }
 	                    }
 	                    else
 	                    {
 	 	                    modal.modal('hide');
 	                        $.alert('提示',result.msg);
 	                    }
 	                }
 	          });
           }
       });
       
       //种子单品新增或编辑提交
       $('#btn-sure').on('click',function(){
    	   //兑换种子数组
           var seedArray=new Array();
           var seedNodes=$(this).parents('.modal-content').find('.seed-exchange');
           var len=seedNodes.length;
           var seed=new Object();
           //校验
           var validetor=$('#seed_single').validate();
           
           if(!validetor.form()){
                return false;
           }
           
           for(var i=0;i<len;i++){
               var obj=new Object();
               var seedType=seedNodes.eq(i).find('.seed-type').val();
               var seedNum=seedNodes.eq(i).find('input[name="seed_num"]').val();
               if(seedNum==''){
                 seedNum=0;
               	 continue;
               }
               obj.seedType=seedType;
               obj.seedNum=seedNum;
               seedArray.push(obj);
           }
           $("#seedExchangeSingle").val(JSON.stringify(seedArray));
           $("#seed_single").submit();
       });
	   
	   //关联商品确认提交
	   $('#btn-relative').on('click',function(){
		    var type=$("#type").val();
		    var selr = $("#grid-product-table").getGridParam('selrow');
	        if(!selr){
	            $.alert("请先选择商品");
	            return;
	        }
	        var rowData=$("#grid-product-table").getRowData(selr);
	        
	        if(type=="single"){
	        	//单品关联商品后赋值
	        	$("#pro_id").val(rowData.id);
		        $("#pro_name").val(rowData.product_name);
		        $("#product_id").val(rowData.id);
		        $("#product_f_id").val(rowData.pf_id);
		    }else if(type=="combo"){
		    	 //套餐关联商品后赋值
	            var proId=rowData.id;
	            var proName=rowData.product_name;
	            var proUnitId=rowData.pf_id;
	            //var proUnit=rowData.unit_name;
	            var index=$('#pro-index').val();
	            if(index==""){
	                return;
	            }
	            var parentNode=$('.relative-pro').eq(index);
	            parentNode.find('.pro-id').val(proId);
	            parentNode.find('.pro-name').val(proName);
	            parentNode.find('.pro-unit-id').val(proUnitId);
			}else{
				console.log("type is empty string");
		    }
		    
	        $("#pro-list").modal('hide');
	   });
	   
       //种子活动编辑提交
       $('#btn-sumbit').on('click',function(){
 	  	  $("#content").val($(".ke-edit-iframe").contents().find("body").html());
 	        //表单提交之前--组织JSON串
 	        var shareSendObj=new Object(),pucharseSendObj=new Object();
 	        shareSendObj.isShare=$('#isShare').val();
 	        shareSendObj.seedTypeId=$('#share_seed_type').val();
 	        shareSendObj.seedNum=$('#share_seed_num').val();
 	        shareSendObj.frequence=$('input[name=frequence]:checked').val();
 	        
 	        pucharseSendObj.isPurchase=$('#isPurchase').val();
 	        pucharseSendObj.seedTypeId=$('#gms_seed_type').val();
 	        pucharseSendObj.seedNum=$('#gms_seed_num').val();
 	        pucharseSendObj.mode=$('input[name=mode]:checked').val();
 	        
 	        console.log(JSON.stringify(shareSendObj));
 	        console.log(JSON.stringify(pucharseSendObj));
 	        
 	        $('#share_send').val(JSON.stringify(shareSendObj));
 	        $('#gm_send').val(JSON.stringify(pucharseSendObj));
 	        
 	        $("#seed_activity").submit();
 	   });

 	   //种子发放管理新增或修改
       $('#add-interval').on('show.bs.modal',function(e){
     	   var $button=$(e.relatedTarget);
           var modal=$(this);
           var id=$button.data("id");
           
           //如果有id值则为修改,否则为新增
           if(id==null||id==""){
               //添加直接show
               $('#seedInstAndInterval')[0].reset();
 		       //隐藏字段也清除掉
 		       $('#send_type').val("0");
 		       $('#intervalId').val("0");
 		       $('#send_percent').val("");
               return;
           }else{
 	          //发送ajax回去查询单条数据
 	          $.ajax({
 	                url:'${CONTEXT_PATH}/seedManage/intervalDetial',
 	                type:'Get',
 	                data:{id:id},
 	                success:function(result){
 	                    if(result.success){
 	                        //回填数据
 	                        modal.find('#intervalId').val(result.data.id);
 	                        modal.find("#send_percent").val(result.data.send_percent);
 	                        modal.find("#interval_name").val(result.data.interval_name);
 	                        modal.find("#begin_time").val(result.data.begin_time);
 	                        modal.find("#end_time").val(result.data.end_time);
 	                        modal.find("#send_total").val(result.data.send_total);
 	                        modal.find("#max_num").val(result.data.max_num);
 	                        modal.find("#send_type").val(result.data.send_type);
 	                        //TODO: 新增种子发放JSON串字段 编辑初始化时选中checkbox
 	                	    if($("#send_type").val()!=""){
 	                	    	if($("#send_type").val()=="0"){
 	                	            $('#send_type1').prop("checked","checked");
 	                	        }else{
 	                	        	$('#send_type2').prop("checked","checked");
 	                	        }
 	                		}
 	                		//清空之前存在的seed-exchange
 	                		modal.find('.seed-exchange').remove();
 	                		
 	                		var seedArr=JSON.parse(result.data.send_percent);
 	                		var listNum=seedArr.length;
 	                		
 			                var removeBtn='<span class="input-group-btn">'+
 					        	        '<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>'+
 					        	     '</span>';
 					        	     
 				            var markup='<div class="seed-exchange">'+
 						            '<select id="seed_type" class="seed-type form-control" name="seed_type">'+
 						        		<#list seedType as item>
 						        			'<option value="${item.id}">${item.seed_name}</option>'+ 
 						        		</#list>      		
 						        	'</select> '+
 						        	'<div class="input-group">'+
 						        	    '<input type="number" name="percent" class="form-control" placeholder="请输入比例（<1.00）" step="0.01" />'+
 						        	     (listNum>1?removeBtn:"")+
 						        	'</div>'+
 						         '</div>';
 						         
                             //循环生成seedList
                             for(let i=0;i<listNum;i++){
                                 //先添加相对应个数的DOM
                                 modal.find('.btn-seed').parent().before(markup);
                                 //再进行赋值
                                 var seedNode=modal.find('.seed-exchange').eq(i);
                                 seedNode.find("#seed_type").val(seedArr[i].seedType);
                                 seedNode.find("input[name=percent]").val(seedArr[i].percent);
                                 //第一个没有删除按钮
                                 if(i==0){
                                     seedNode.find('input[name=percent]').next('span').remove();
                                     continue;
                                 }
                             }
 	                    }
 	                    else
 	                    {
 	                    	modal.modal('hide');
 	                        $.alert('提示',result.msg);
 	                    }
 	                }
 	          });
           }
       });
       
	   //种子发放管理编辑提交 
       $('#btn-confirm').on('click',function(){
			//兑换种子数组
	        var seedArray=new Array();
	        var seedNodes=$(this).parents('.modal-content').find('.seed-exchange');
	        var len=seedNodes.length;
              
            //校验
            var validetor=$('#seedInstAndInterval').validate();
            
            if(!validetor.form()){
                 return false;
            }
	        
	        for(var i=0;i<len;i++){
	            var obj=new Object();
	            var seedType=seedNodes.eq(i).find('.seed-type').val();
	            var percent=seedNodes.eq(i).find('input[name="percent"]').val();
	            if(percent==''){
	            	percent=0;
	            	continue;
	            }
	            obj.seedType=seedType;
	            obj.percent=percent;
	            seedArray.push(obj);
	        }
	        $('#send_percent').val(JSON.stringify(seedArray));
	        $('#seedInstAndInterval').submit();
	   }); 
	   
       $('.seed-exchanges').on('click','.btn-remove',function(e){
           var $remove=$(e.currentTarget);
           $remove.parents('.seed-exchange').remove();
       });
       
       $('.btn-seed').on('click',function(){
              //区分是比例还是数量 0-seed_num 1-percent
              var type=$(this).data("type");
              console.log(type);
              var existNum=$('.seed-exchange').length;
              var removeBtn='<span class="input-group-btn">'+
		        	        '<button type="button" class="btn btn-danger btn-sm btn-remove"><i class="fa fa-remove"></i></button>'+
		        	     '</span>';
		        	     
              var markup='<div class="seed-exchange">'+
		            '<select id="seed_type" class="seed-type form-control" name="seed_type">'+
		        		<#list seedType as item>
		        			'<option value="${item.id}">${item.seed_name}</option>'+ 
		        		</#list>      		
		        	'</select> '+
		        	'<div class="input-group">'+
		        	    '<input type="number" name="'+(type==0?"seed_num":"percent")+'" class="form-control" placeholder="'+(type==0?"请输入数量":"请输入比例（<1.00）")+'" step="0.01" />'+
		        	     (existNum>=1?removeBtn:"")+
		        	'</div>'+
		         '</div>';
		         
		      if(existNum>=10){
		        $.dialog.alert('请不要超过10个');
		         return false;
		      }   
		      $(this).parent().before(markup);	          
       });
     
      $('#isShare').on('click',function(){
            var _this=$(this);
            if(_this.is(":checked")){
            	_this.val("true");
            	$('.share-seed').show();
            }else{
            	_this.val("false");
                $('.share-seed').hide();
            }
      });

      $('#isPurchase').on('click',function(){
    	   var _this=$(this);
           if(_this.is(":checked")){
        	   _this.val("true");
        	   $('.purchase-seed').show();
           }else{
        	   _this.val("false");
        	   $('.purchase-seed').hide();
           }
      });

      $('.isLimit').on('click',function(){
    	  var _this=$(this);
    	  var _maxNode=$(this).parents('.form-group').next('.form-group').find("#max_num");
    	  if(_this.is(":checked")){
	       	   _this.val("1");
	       	   _this.parents('.form-group').next().show();
          }else{
	       	   _this.val("0");
	           _maxNode.val("0");
	       	   _this.parents('.form-group').next().hide();
          }
      });
      
      $('input[name=send_types]').on('click',function(){
    	   $('#send_type').val($(this).val());
      });
      
      //数据统计部分
      var seedChart = echarts.init(document.getElementById('seed_chart'));
      var legendArr=["初春种子","盛夏种子","金秋种子","暖冬种子","神秘种子"];
  	  var seriesData=[{name:"初春种子",value:"0"},{name:"初春种子",value:"0"},{name:"盛夏种子",value:"0"},{name:"金秋种子",value:"14352"},
  	                {name:"暖冬种子",value:"0"},{name:"神秘种子",value:"0"}];
        
      var seedOpt = {
  		    title : {
  		        text: '种子具体领取情况占比图',
  		        subtext: '',
  		        x:'center'
  		    },
  		    tooltip : {
  		        trigger: 'item',
  		        formatter: "{a} <br/>{b} : {c} ({d}%)"
  		    },
  		    legend: {
  		        orient: 'vertical',
  		        left: 'left',
  		        data: []
  		    },
  		    series : [
  		        {
  		            name: '所占百分比',
  		            type: 'pie',
  		            radius : '55%',
  		            center: ['50%', '60%'],
  		            data: [],
  		            itemStyle: {
  		                emphasis: {
  		                    shadowBlur: 10,
  		                    shadowOffsetX: 0,
  		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
  		                }
  		            }
  		        }
  		    ]
      };
      
      seedChart.setOption(seedOpt);
      
      $('#activity_statistics').on('show.bs.modal',function(e){
          var $button=$(e.relatedTarget);
          var modal=$(this);
          var startTime=$button.data("start-time");
          var endTime=$button.data("end-time");
          var id=$button.data("id");
          modal.find('#start_time').val(startTime);
          modal.find('#end_time').val(endTime);
          modal.find('#interval_id').val(id);
          //默认搜索从活动开始时间到当前系统时间的数据
          $('#btn-statistic').trigger("click");
       });

       $('#btn-statistic').on('click',function(e){
    	  var parentNode=$(this).parents('.modal-body');
          var startTime=parentNode.find('#start_time').val();
          var endTime=parentNode.find('#end_time').val();
          var acid=$('#activity_id').val();
          var intervalId=$('#interval_id').val();
          
          //可能需要校验开始和结束时间
          if(startTime==""||endTime==""){
              $.alert("提示","活动区间段的开始时间和结束时间不能为空");
              return false;             
          }
          
          //发送Ajax回去请求数据
          $.ajax({
                url:'${CONTEXT_PATH}/seedManage/intarvalCount',
                type:'Get',
                data:{start_time:startTime,end_time:endTime,id:acid},
                success:function(result){
                	var seedGetTable=$('#seed_receive').find('tbody');
                    if(result){
                    	var markup="";
 		                var seriesData=[];
	                   //清除上次查询结果
	                   seedGetTable.html("");
	                   
	                   //具体领取明细统计
		               for(let x=0;x<result.seriesData.length;x++){
		            	   markup+='<tr><td>'+result.seriesData[x].name+'</td>'+
		            	   '<td>'+result.seriesData[x].value+'</td></tr>';
		            	   if(x>0){
		            		   seriesData.push(result.seriesData[x]);
			               }
			           }
		               //填充表格数据
	                   seedGetTable.append(markup);
	                   //绘制饼图
	                   seedOpt.series[0].data=seriesData;
	                   //删除掉已领取总数
	                   result.legendArr.splice(0,1);
	                   seedOpt.legend.data=result.legendArr;
	                   seedChart.setOption(seedOpt);
                    }
                    else
                    {
                        $.alert('提示','查询失败 ！');
                    }
                }
          }); 
       });
       
	});    
</script>