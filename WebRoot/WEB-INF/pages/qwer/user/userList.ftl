<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
		<div style="margin-bottom:5px;">
			
		</div>
		<div class="col-xs-12 wigtbox-head">
			<form id="submitForm">
				<div class="pull-left">
					手机号
					<input type="text" id="phoneNum" name="phoneNum" />
					注册时间	
					<input type="text" id="registTimeBegin" name="registTimeBegin" value='${registTimeBegin}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
            		至
            		<input type="text" id="registTimeEnd" name="registTimeEnd" value='${registTimeEnd}' onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" />
            	</div>
            	<div class="pull-right">
		            <button class="btn btn-info btn-sm" type="button" onclick="jQuery('#grid-table')
		                    .setGridParam({postData:{'phoneNum':$('#phoneNum').val(),'registTimeBegin':$('#registTimeBegin').val(),'registTimeEnd':$('#registTimeEnd').val()}})
		                    .trigger('reloadGrid');">
		                <i class="fa fa-search bigger-110"></i>查询
		            </button>
		             <button class="btn btn-info btn-success btn-sm" type="button"  onclick="getSelRowToEdit();">			
			         <i class="fa fa-reply bigger-110"></i> 回复
				    </button>
					<button class="btn btn-primary btn-sm" type="button"  onclick="repAll();">	
					    <i class="fa fa-send bigger-110"></i> 群发
					</button>
		            <button class="btn btn-warning btn-sm" type="button" onclick="exportExcel();" target="_blank"><i class="fa fa-sign-out"></i>导出</a>
		        </div>
	        </form>  
	    </div>  
	      
        <div class="row">
            <div class="col-xs-12">
                <!-- PAGE CONTENT BEGINS -->
                <table id="grid-table"></table>
                <div id="grid-pager"></div>
                <!-- PAGE CONTENT ENDS -->
            </div><!-- /.col -->
        </div><!-- /.row -->
        
        <script>

		    function getSelRowToEdit(){
		        var selr = jQuery("#grid-table").getGridParam('selrow');
		        if(!selr){
		            alert("请先选择一行数据再回复");
		            return;
		        }
				var rowData = $("#grid-table").jqGrid("getRowData",selr);
		        window.location.href="${CONTEXT_PATH}/submitMsg/initRepWxmsg?msgFrom="+rowData.open_id;
		    }
		    function repAll(){
		    	var ids=$("#grid-table").jqGrid("getGridParam","selarrrow");
		        window.location.href="${CONTEXT_PATH}/submitMsg/initRepWxmsg?ids="+ids.join();
		    }
		    
		</script>
</@layout>


<script type="text/javascript">
var $path_base = "/";
var grid_selector = "#grid-table";
var pager_selector = "#grid-pager";
function exportExcel(){
	window.location.href=
	encodeURI("${CONTEXT_PATH}/userManage/export?formData="+JSON.stringify($("form").serializeArray())
		+"&colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
		+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
	);
}
jQuery(function($) {  

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        url:"${CONTEXT_PATH}/userManage/userList",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:['序号','微信用户标示', '性别', '手机号','昵称','生日','真实姓名',
        			'用户地址','注册时间','用户头像','会员余额','会员积分','状态','所属店铺'],
        colModel:[
            {name:'id',index:'id', width:200, sorttype:"int", editable: false},
            {name:'open_id',index:'open_id',width:200, editable:false},
            {name:'sexDisplay',index:'sexDisplay', width:150,editable: false},
            {name:'phone_num',index:'phone_num',width:150,editable: false},
            {name:'nickname',index:'nickname', width:150,editable: false},
            {name:'birthday',index:'birthday', width:150,editable: false},
            {name:'realname',index:'realname', width:150,editable: false},
            {name:'user_address',index:'user_address', width:150,editable: false},
            {name:'regist_time',index:'regist_time', width:150,editable: false},
            {name:'user_img_id',index:'user_img_id', width:150,editable: false,formatter: photoFormatter},
            {name:'balance',index:'balance', width:150,editable: false},
            {name:'member_points',index:'member_points', width:150,editable: false},
            {name:'statusDisplay',index:'statusDisplay', width:150,editable: false},
            {name:'store_name',index:'store_name', width:150,editable: false}
        ],

        viewrecords : true,
        rowNum:10,
        rowList:[10,20,30,200],
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
                styleCheckbox(table);

                updateActionIcons(table);
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },
        //双击表格行回调函数
        ondblClickRow:function(rowid, iRow, iCol, e){
        	window.open("${CONTEXT_PATH}/userManage/userInfosList?id="+rowid);
        },
        caption: "用户管理",
        autowidth: true
    });

    //enable search/filter toolbar
    //jQuery(grid_selector).jqGrid('filterToolbar',{defaultSearch:true,stringResult:true})

    //switch element when editing inline
    function aceSwitch( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=checkbox]')
                    .wrap('<label class="inline" />')
                    .addClass('ace ace-switch ace-switch-5')
                    .after('<span class="lbl"></span>');
        }, 0);
    }
    //enable datepicker
    function pickDate( cellvalue, options, cell ) {
        setTimeout(function(){
            $(cell) .find('input[type=text]')
                    .datepicker({format:'yyyy-mm-dd' , autoclose:true});
        }, 0);
    }
    //显示图片渲染函数
    function photoFormatter(cellvalue, options, rowdata){
    	 return "<img src='"+rowdata[9]+"' style='width:40px;height:40px;' />";
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
            },
            {
                //edit record form
                //closeAfterEdit: true,
                recreateForm: true,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_edit_form(form);
                }
            },
            {
                //new record form
                closeAfterAdd: true,
                recreateForm: true,
                viewPagerButtons: false,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_edit_form(form);
                }
            },
            {
                //delete record form
                recreateForm: true,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    if(form.data('styled')) return false;

                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_delete_form(form);

                    form.data('styled', true);
                },
                onClick : function(e) {
                    alert(1);
                }
            },
            {
                //search form
                recreateForm: true,
                afterShowSearch: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                    style_search_form(form);
                },
                afterRedraw: function(){
                    style_search_filters($(this));
                }
                ,
                multipleSearch: true
                /**
                 multipleGroup:true,
                 showQuery: true
                 */
            },
            {
                //view record form
                recreateForm: true,
                beforeShowForm: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                }
            }
    )



    function style_edit_form(form) {
        //enable datepicker on "sdate" field and switches for "stock" field
        form.find('input[name=sdate]').datepicker({format:'yyyy-mm-dd' , autoclose:true})
                .end().find('input[name=stock]')
                .addClass('ace ace-switch ace-switch-5').wrap('<label class="inline" />').after('<span class="lbl"></span>');

        //update buttons classes
        var buttons = form.next().find('.EditButton .fm-button');
        buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
        buttons.eq(0).addClass('btn-primary').prepend('<i class="icon-ok"></i>');
        buttons.eq(1).prepend('<i class="icon-remove"></i>')

        buttons = form.next().find('.navButton a');
        buttons.find('.ui-icon').remove();
        buttons.eq(0).append('<i class="icon-chevron-left"></i>');
        buttons.eq(1).append('<i class="icon-chevron-right"></i>');
    }

    function style_delete_form(form) {
        var buttons = form.next().find('.EditButton .fm-button');
        buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
        buttons.eq(0).addClass('btn-danger').prepend('<i class="icon-trash"></i>');
        buttons.eq(1).prepend('<i class="icon-remove"></i>')
    }

    function style_search_filters(form) {
        form.find('.delete-rule').val('X');
        form.find('.add-rule').addClass('btn btn-xs btn-primary');
        form.find('.add-group').addClass('btn btn-xs btn-success');
        form.find('.delete-group').addClass('btn btn-xs btn-danger');
    }
    function style_search_form(form) {
        var dialog = form.closest('.ui-jqdialog');
        var buttons = dialog.find('.EditTable')
        buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'icon-retweet');
        buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'icon-comment-alt');
        buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'icon-search');
    }

    function beforeDeleteCallback(e) {
        var form = $(e[0]);
        if(form.data('styled')) return false;

        form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
        style_delete_form(form);

        form.data('styled', true);
    }

    function beforeEditCallback(e) {
        var form = $(e[0]);
        form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
        style_edit_form(form);
    }



    //it causes some flicker when reloading or navigating grid
    //it may be possible to have some custom formatter to do this as the grid is being created to prevent this
    //or go back to default browser checkbox styles for the grid
    function styleCheckbox(table) {
        /**
         $(table).find('input:checkbox').addClass('ace')
         .wrap('<label />')
         .after('<span class="lbl align-top" />')


         $('.ui-jqgrid-labels th[id*="_cb"]:first-child')
         .find('input.cbox[type=checkbox]').addClass('ace')
         .wrap('<label />').after('<span class="lbl align-top" />');
         */
    }


    //unlike navButtons icons, action icons in rows seem to be hard-coded
    //you can change them like this in here if you want
    function updateActionIcons(table) {
        /**
         var replacement =
         {
             'ui-icon-pencil' : 'icon-pencil blue',
             'ui-icon-trash' : 'icon-trash red',
             'ui-icon-disk' : 'icon-ok green',
             'ui-icon-cancel' : 'icon-remove red'
         };
         $(table).find('.ui-pg-div span.ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					})
         */
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

    function enableTooltips(table) {
        $('.navtable .ui-pg-button').tooltip({container:'body'});
        $(table).find('.ui-pg-div').tooltip({container:'body'});
    }

    //var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');

});
</script>