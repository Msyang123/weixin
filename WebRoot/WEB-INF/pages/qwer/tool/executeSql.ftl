<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<div class="col-xs-12 wigtbox-head form-inline">
sql执行器
</div>
 <form class="form-horizontal" role="form" method="post">
    <input type="hidden" name="executeSql.id" value="${executeSql.id!}"/>
    <div class="form-group" id="show_main_title">
        <label class="col-sm-3 control-label no-padding-right" for="main_title">sql功能名 </label>
        <div class="col-sm-9">
            <input type="text" id="execute_name" name="executeSql.execute_name"
             value="${executeSql.execute_name!}" readonly=ture  placeholder="sql功能名" class="col-xs-10 col-sm-5" />
        </div>
    </div>   
    <#list executeSqlParams as params>
	    <div class="form-group" id="show_main_title">
	        <label class="col-sm-3 control-label no-padding-right" for="main_title">${params.param_cn_name}</label>
	        <div class="col-sm-9">
	        	<#if params.param_type=='text'>
		            <input type="text"  name="${params.param_name}"
		             value="${params.default_value!}"  placeholder="${params.param_cn_name}" 
		             class="col-xs-10 col-sm-5" />
	            <#elseif params.param_type=='select'>
	            	<select name="${params.param_name}" >
	            		<#if params.default_value=='0'>
				    		<option value="${params.default_value!}">库存订单不足</option>
				    	</#if>
				    </select>
	            <#else>
	            	<input type="text"  name="${params.param_name}" placeholder="${params.param_cn_name}" 
	            	value="${params.default_value!}" 
            		onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" 
            		class="col-xs-10 col-sm-5" />
	            </#if> 
	        </div>
	    </div>
    </#list>
    <div class="clearfix form-actions">
        <div class="col-md-offset-3 col-md-9">
		    <button class="btn btn-primary" type="button" 
		    onclick="
			   var formData= $('.form-horizontal').serializeArray();
	          	var jsonData={};
	          
	           for(var i=0;i<formData.length;i++){
	               jsonData[formData[i].name]=formData[i].value;
	           } 
		       jQuery('#grid-table').setGridParam({postData:
		    		jsonData
		       }).trigger('reloadGrid');">
		        <i class="fa fa-search bigger-110"></i> 执行  
		    </button>
		    &nbsp; &nbsp; &nbsp;
		    <button class="btn btn-warning" type="button" onclick="exportExcel();" 
		    target="_blank"><i class="fa fa-sign-out"></i>导出</button>
            &nbsp; &nbsp; &nbsp;
            <button class="btn" type="button" onclick="history.go(-1);">
                <i class="icon-undo bigger-110"></i>
                		取消
            </button>
        </div>
    </div>
</form>

<div class="col-xs-12">
    <!-- PAGE CONTENT BEGINS -->
    <table id="grid-table"></table>
    <div id="grid-pager"></div>
    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->

</@layout>


<script type="text/javascript">
var $path_base = "/";
var grid_selector = "#grid-table";
var pager_selector = "#grid-pager";
function exportExcel(){
		window.location.href=
		encodeURI("${CONTEXT_PATH}/execute/export?formData="+JSON.stringify($("form").serializeArray())
				+"&colNames="+JSON.stringify(jQuery(grid_selector).getGridParam().colNames)
				+"&colModel="+JSON.stringify(jQuery(grid_selector).getGridParam().colModel)
		);
	}
jQuery(function($) {

    jQuery(grid_selector).jqGrid({
        //direction: "rtl",

        //data: grid_data,
        url:"${CONTEXT_PATH}/execute/execute?executeSql.id=${executeSql.id}",
        mtype: "post",
        datatype: "json",
        height: '100%',
        colNames:[
        	<#list columnNames as columnName>
        		<#if columnName_index==0>
        			'${columnName}'
        		<#else>
        			,'${columnName}'
        		</#if>
        	</#list>
        ],
        colModel:[
        	<#list columnNames as columnName>
        		<#if columnName_index==0>
        			{name:'${columnName}',index:'${columnName}', width:90, editable: false}
        		<#else>
        			,{name:'${columnName}',index:'${columnName}', width:90, editable: false}
        		</#if>
        	</#list>
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
                styleCheckbox(table);

                updateActionIcons(table);
                updatePagerIcons(table);
                enableTooltips(table);
            }, 0);
        },
        caption: "sql执行结果",
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
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />');
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