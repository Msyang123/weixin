<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head">
		<div style="margin-bottom:5px">
			<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToOrderReduce();">
			    <i class="fa fa-send bigger-110"></i>海鼎发送
			</button>			
			<button class="btn btn-danger btn-sm" type="button"  onclick="getSelRowToOrderCancel();">
			    <i class="fa fa-trash bigger-110"></i>取消海鼎订单
			</button>
			<button class="btn btn-info btn-sm" type="button"  onclick="getSelRowToRechange();">
			    <i class="fa fa-cubes bigger-110"></i>调货
			</button>
			<button class="btn btn-warning btn-sm" type="button"  onclick="getSelRowToEdit();">
			    <i class="fa fa-retweet bigger-110"></i>退货
			</button>
		</div>
		
		<form id="submitForm" style="margin-bottom:5px">
				<input type="text" id="orderId" name="orderId" placeholder="订单编号"/>
				<input type="text" id="phoneNum" name="phoneNum" placeholder="手机号"/>
				订单状态
				<select  id="orderStatus" name="orderStatus">
					<option value="-1">全部</option>
					<option value="1">未付款</option>
					<option value="2">支付中</option>
					<option value="3">已付款</option>
					<option value="4">已收货</option>
					<option value="5">退货中</option>
					<option value="6">退货完成</option>
					<option value="7">取消中</option>
					<option value="8">海鼎退货中</option>
					<option value="9">海鼎退货失败</option>
					<option value="10">微信退款失败</option>
					<option value="11">订单成功</option>
					<option value="0">已失效</option>
				</select>
				海鼎状态
				<select  id="hdStatus" name="hdStatus">
					<option value="-1">全部</option>
					<option value="0">成功</option>
					<option value="1">失败</option>
				</select>
				创建时间	
				<input type="text" id="createDateBegin" name="createDateBegin" value='${createDateBegin}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
		    	至
		    	<input type="text" id="createDateEnd" name="createDateEnd" value='${createDateEnd}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
	            <button class="btn btn-info btn-sm" type="button" onclick="jQuery('#grid-table')
	                    .setGridParam({postData:{'orderId':$('#orderId').val(),'phoneNum':$('#phoneNum').val(),'orderStatus':$('#orderStatus').val(),'hdStatus':$('#hdStatus').val(),'createDateBegin':$('#createDateBegin').val(),'createDateEnd':$('#createDateEnd').val()}})
	                    .trigger('reloadGrid');">
	                <i class="fa fa-search bigger-110"></i>查询
	            </button>
	            <button class="btn btn-warning btn-sm" type="button" onclick="exportExcel();" target="_blank"><i class="fa fa-sign-out"></i>导出</button>
		  </form>       
		</div>
       
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->
            <table id="grid-table"></table>
            <div id="grid-pager"></div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
  
        <script>
		  
		    
		</script>
</@layout>


<script type="text/javascript">
	var $path_base = "/";
	var grid_selector = "#grid-table";
	var pager_selector = "#grid-pager";
	function exportExcel(){
		window.location.href=
		encodeURI("${CONTEXT_PATH}/orderManage/export?formData="+JSON.stringify($("form").serializeArray())
				+"&colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
				+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
		);
	}

  function getSelRowToEdit(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再操作");
            return;
        }
        var rowData=jQuery("#grid-table").getRowData(selr);
        if(rowData.order_status!='退货中' && rowData.order_status!='已收货'){
        	alert("请选择退货中的订单操作");
        	return;
        }
		$.ajax({ 
			url: "${CONTEXT_PATH}/orderManage/orderReject", 
			data: {id:selr}, 
			success: function(data){
				alert(data.msg);
	      	}
		});
    }
    function getSelRowToOrderReduce(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再操作");
            return;
        }
        var rowData=jQuery("#grid-table").getRowData(selr);
        if(rowData.hd_status!='1'){
        	alert("请选择海鼎发送失败的订单操作");
        	return;
        }
		$.ajax({ 
			url: "${CONTEXT_PATH}/orderManage/orderReduce", 
			data: {id:selr}, 
			success: function(data){
				alert(data.msg);
	      	}
		});
    }
    //取消订单后台操作
    function getSelRowToOrderCancel(){
        var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再操作");
            return;
        }
        var rowData=jQuery("#grid-table").getRowData(selr);
        if(rowData.order_status!='取消中'){
        	alert("请选择取消中的订单操作");
        	return;
        }
		$.ajax({ 
			url: "${CONTEXT_PATH}/orderManage/orderCancel", 
			data: {id:selr}, 
			success: function(data){
				alert(data.message);
	      	}
		});
    }
    
    function getSelRowToRechange(){
    	var selr = jQuery("#grid-table").getGridParam('selrow');
        if(!selr){
            alert("请先选择一行数据再操作");
            return;
        }
		window.location.href="${CONTEXT_PATH}/orderManage/initRechange?id="+selr;
    }
	
jQuery(function($) {
    jQuery(grid_selector).jqGrid({
        //data: grid_data,
        url:"${CONTEXT_PATH}/masterOrderManage/orderList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['门店名称','创建日期','创建时间', '支付时间', '订单编号','微信交易编号','微信支付','订单金额','折扣金额','实收金额','客户手机','客户昵称',
        			'鲜果币','订单状态','订单类型','海鼎状态','提货方式','退货理由','客户留言','调货原订单编码'],
        colModel:[
            {name:'store_name',index:'store_name', width:200, sorttype:"int", editable: false},
            {name:'createtime',index:'createtime',width:200, editable:false},
            {name:'commitTime',index:'commitTime', width:150,editable: false},
            {name:'time_end',index:'time_end',width:150,editable: false},
            {name:'order_id',index:'order_id', width:150,editable: false},
            {name:'transaction_id',index:'transaction_id', width:150,editable: false},
            {name:'wx_pay',index:'wx_pay', width:90,editable: false},
            {name:'total',index:'total', width:90,editable: false},
            {name:'discount',index:'discount', width:90,editable: false},
            {name:'need_pay',index:'need_pay', width:90,editable: false},
            {name:'phone_num',index:'phone_num', width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'balance',index:'balance', width:150,editable: false},
            {name:'order_status',index:'order_status', width:150,editable: false},
            {name:'order_type',index:'order_type', width:150,editable: false},
            {name:'hd_status',index:'hd_status', width:150,editable: false},
            {name:'deliverytype',index:'deliverytype', width:150,editable: false},
            {name:'reason',index:'reason', width:150,editable: false},
            {name:'customer_note',index:'customer_note', width:150,editable: false},
            {name:'old_order_id',index:'old_order_id', width:150,editable: false}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30],
        pager : pager_selector,
        emptyrecords : "未找到任何数据",
        pgtext: "第{0}页 共{1}页",
        altRows: true,
        //toppager: true,
        multiselect: true,
        //multikey: "ctrlKey",
        multiboxonly: true,
        loadComplete : function() {
            var table = this;
            setTimeout(function(){
                updatePagerIcons(table);
            }, 0);
        },
        //双击表格行回调函数
        ondblClickRow:function(rowid, iRow, iCol, e){
        	window.open("${CONTEXT_PATH}/orderManage/orderDetial?id="+rowid);
        },
        caption: "订单管理",
        autowidth: true
    });

    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }
    //navButtons
    jQuery(grid_selector).jqGrid('navGrid',pager_selector,
            { 	//navbar options
                edit: false,
                editicon : 'icon-pencil blue',
                add: false,
                addicon : 'icon-plus-sign purple',
                del: false,
                delicon : 'icon-trash red',
                search: false,
                searchicon : 'icon-search orange',
                refresh: true,
                refreshicon : 'icon-refresh green',
                view: true,
                viewicon : 'icon-zoom-in grey'
            }
    )
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

});
</script>