<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[]>

<form action="${CONTEXT_PATH}/activityManage/saveJggActivity" class="form-horizontal" role="form" method="post">
    <input type="hidden" name="activity.content" id="content"/>
    <input type="hidden" name="activity.activity_type" id="hidden_activity_type" value="${activity.activity_type!}"/>
    
 	<div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">编号 </label>
        <div class="col-sm-9">
            <input type="text" readonly="readonly" id="id" name="activity.id" value="${activity.id!}"  placeholder="编号" class="col-xs-10 col-sm-5" />
        </div>
    </div>

    <div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">活动名称 </label>
        <div class="col-sm-9">
            <input type="text" id="main_title" name="activity.main_title" value="${activity.main_title!}"  placeholder="活动名称" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_content">
        <label class="col-sm-3 control-label no-padding-right" for="editor">活动规则</label>
        <textarea id="editor" name="activity.content" class="col-sm-5 ml12" rows="7" width="650" height="350">
        ${activity.content!}</textarea>
    </div>
    
    <div class="form-group" id="show_yxqq">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">活动开始时间 </label>
        <div class="col-sm-9">
            <input type="text" id="yxq_q" name="activity.yxq_q" placeholder="活动开始时间" value="${activity.yxq_q!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_yxqz">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">活动结束时间 </label>
        <div class="col-sm-9">
            <input type="text" id="yxq_z" name="activity.yxq_z" placeholder="活动结束时间" value="${activity.yxq_z!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_yxqq">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_q">抽奖机会有效期启 </label>
        <div class="col-sm-9">
            <input type="text" id="cjjh_q" name="activity.cjjh_q" placeholder="抽奖机会有效期启" value="${activity.cjjh_q!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_yxqz">
        <label class="col-sm-3 control-label no-padding-right" for="yxq_z">抽奖机会有效期止 </label>
        <div class="col-sm-9">
            <input type="text" id="cjjh_z" name="activity.cjjh_z" placeholder="抽奖机会有效期止" value="${activity.cjjh_z!}" 
            onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="col-xs-10 col-sm-5" />
        </div>
    </div>
	
	<div class="form-group" id="show_url">
        <label class="col-sm-3 control-label no-padding-right">url</label>
        <div class="col-sm-9">
            <input type="text" id="url" name="activity.url" placeholder="url" value="${activity.url!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_dis_order">
        <label class="col-sm-3 control-label no-padding-right" for="dis_order">活动针对范围 </label>
        <div class="col-sm-9">
        	<#if activity.scope??>
        		<input type="radio" <#if activity.scope=='1'>checked="checked"</#if> name="activity.scope" value="1" />全部门店
            	<input type="radio" <#if activity.scope=='2'>checked="checked"</#if> name="activity.scope" value="2" />部分门店
        	<#else>
        		<input type="radio" checked="checked"  name="activity.scope" value="1"/>全部门店
            	<input type="radio" name="activity.scope" value="2"/>部分门店
        	</#if>
        </div>
    </div>
    
    <div class="form-group" id="show_restrict">
        <label class="col-sm-3 control-label no-padding-right">门店选择（选择部分门店时需进行设置）</label>
        <div class="col-sm-9">
        	<select name="activityStore.store_id">
        		<option value="">请选择门店</option>
        		<#list AllStore as store>
        			<option value="${store.id}" <#if (existActivityStore.store_id)?? && existActivityStore.store_id==store.id>selected=true</#if> >${store.store_name}</option>
        		</#list>
        	</select>
        </div>
    </div>
    
    <div class="form-group" id="show_cjjh_type">
        <label class="col-sm-3 control-label no-padding-right">抽奖机会获取方式</label>
        <div class="col-sm-9">
        	<select id="cjjh_type" name="activity.cjjh_type" onchange="change()" class="col-xs-10 col-sm-5">
			  	  <option <#if activity.cjjh_type?? && activity.cjjh_type=='1' >selected</#if> value="1" >购物送</option>
				  <option <#if activity.cjjh_type?? && activity.cjjh_type=='2' >selected</#if> value="2" >注册送</option>
				  <option <#if activity.cjjh_type?? && activity.cjjh_type=='3' >selected</#if> value="3" >购物+注册</option>
				  <option <#if activity.cjjh_type?? && activity.cjjh_type=='4' >selected</#if> value="4" >充值满送</option>
			</select>
        </div>
    </div>
    
    <div class="form-group" id="show_coupon_count">
        <label class="col-sm-3 control-label no-padding-right">抽奖机会赠送限制金额</label>

        <div class="col-sm-9">
            <input type="text" id="activity_money" name="activity.activity_money" 
            placeholder="抽奖机会赠送限制金额"
            	value="${activity.activity_money!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_default_czcjjh_count">
        <label class="col-sm-3 control-label no-padding-right">充值赠送抽奖机会次数</label>

        <div class="col-sm-9">
            <input type="text" id="default_czcjjh_count" name="activity.default_czcjjh_count" 
            placeholder="1"
            	value="${activity.default_czcjjh_count!1}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_leading_content">
        <label class="col-sm-3 control-label no-padding-right">引导文案设置</label>

        <div class="col-sm-9">
            <input type="text" id="leading_content" name="activity.leading_content" 
            placeholder="引导文案设置"
            	value="${activity.leading_content!}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_activity_money">
        <label class="col-sm-3 control-label no-padding-right">默认抽奖次数</label>

        <div class="col-sm-9">
            <input type="text" id="default_cjjh_count" name="activity.default_cjjh_count" 
            placeholder="默认抽奖次数" value="${(activity.default_cjjh_count)!0}" class="col-xs-10 col-sm-5" />
        </div>
    </div>
    
    <div class="form-group" id="show_yxbz">
        <label class="col-sm-3 control-label no-padding-right">有效状态</label>

        <div class="col-sm-9">
        	<select id="yxbz" name="activity.yxbz" class="col-xs-10 col-sm-5">
			  	  <option <#if activity.yxbz?? && activity.yxbz=='Y' >selected</#if> value="Y" >有效</option>
				  <option <#if activity.yxbz?? && activity.yxbz=='N' >selected</#if> value="N" >无效</option>
			</select>
        </div>
    </div>
    
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
            <button class="btn btn-info" type="button" onclick="whenSubmit();">
                	提交
            </button>
            <button class="btn" type="button" onclick="history.go(-1);">
             	            取消
            </button>
        </div>
    </div>
</form>

<div class="col-xs-12 wigtbox-head form-inline">
	    <div class="pull-right">
		    <button class="btn btn-info btn-sm" type="button"  
		    	onclick="getSelRowToEdit()"/>
			    <i class="fa fa-edit bigger-110"></i> 编辑
			</button>
		</div>
</div>

<div class="row">
	<div class="col-xs-12">
	    <#-- PAGE CONTENT BEGINS -->
	    <table id="grid-table"></table>
	    <div id="grid-pager"></div>
	    <#-- PAGE CONTENT ENDS -->
	</div><!-- /.col -->
</div><#-- /.row -->

<script>
window.onload=function(){
    change();
};

function change(){
	var cjjh_type = $("#cjjh_type").val();
	if(cjjh_type=='4'){
		$("#show_default_czcjjh_count").show();
		$("#show_leading_content").show();
	}else{
		$("#show_default_czcjjh_count").hide();
		$("#show_leading_content").hide();
	}
}

function getSelRowToEdit(){
    var selr = jQuery("#grid-table").getGridParam('selrow');
	window.location.href="${CONTEXT_PATH}/activityManage/editAward?activityId=${activity.id!}&id="+selr;
}

var K=window.KindEditor;
var resuorceEditor;
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
	
</#if>
function whenSubmit(){
    $("#content").val($(".ke-edit-iframe").contents().find("body").html());
    $(".form-horizontal").submit();
}

jQuery(function($) {
    var grid_selector = "#grid-table";
    var pager_selector = "#grid-pager";
    
    jQuery(grid_selector).jqGrid({
        url:"${CONTEXT_PATH}/activityManage/getJggAwardRecordListJson?activityId=${activity.id!-1}",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['操作','编号','排序','奖品图片','奖品名称', '中奖概率','奖品类型','奖品份数'],
        colModel:[
            {name:'myac',index:'', width:80, fixed:true, sortable:false, resize:false,
                formatter:'actions',
                formatoptions:{
                    keys:false,
                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback}
                }
            },
            {name:'id',index:'id', width:90, editable: true},
            {name:'award_sequence',index:'award_sequence',width:90, editable:true,sorttype:"date"},
            {name:'save_string',index:'save_string',width:90, editable:false,
                  formatter:function(value,grid,rows,state){
                	return "<img src='"+value+"' style='width:40px;height:40px;' onerror='imgLoad(this)' />";
                  }
            },
            {name:'award_name',index:'award_name',width:90, editable:true,sorttype:"date"},
            {name:'award_percent',index:'award_percent',width:90, editable:true},
            {name:'award_type',index:'award_type', width:90,editable: false,edittype:"select",
            	editoptions:{value:"'1':鲜果币;'2':优惠券;'3':实物奖品;'4':谢谢惠顾"},
            	formatter:function(cellvalue, options, rowObject){
            		if(cellvalue=='1'){return "鲜果币"}
            		else if(cellvalue=='2'){return "优惠券"}
            		else if(cellvalue=='3'){return "实物奖品"}
            		else{return "谢谢惠顾"}}
        	},
        	{name:'award_num',index:'award_num',width:90, editable:true}
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
        editurl: "${CONTEXT_PATH}/activityManage/e",
        caption: "抽奖活动奖品管理",
        autowidth: true
    });

    initNavGrid(grid_selector,pager_selector);

});
</script>
</@layout>

