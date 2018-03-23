/**
 * Created by Andrew on 2017/11/13.
 * 公共的grid相关action的代码
 */
$(document).ready(function(){
    

    
});

/**
 * Grid Common functions
 */
function initNavGrid(grid_selector,pager_selector){
	$(grid_selector).jqGrid('navGrid',pager_selector,
	        { 	//navbar options
	            edit: false,
	            editicon : 'fa fa-pencil blue',
	            add: false,
	            addicon : 'fa fa-plus-sign purple',
	            del: false,
	            delicon : 'fa fa-trash red',
	            search: false,
	            searchicon : 'fa fa-search orange',
	            refresh: true,
	            refreshicon : 'fa fa-refresh green',
	            view: true,
	            viewicon : 'fa fa-search-plus grey'
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
	            },
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
	   );
}

function style_edit_form(form) {
    form.find('input[name=sdate]').datepicker({format:'yyyy-mm-dd' , autoclose:true})
            .end().find('input[name=stock]')
            .addClass('ace ace-switch ace-switch-5').wrap('<label class="inline" />').after('<span class="lbl"></span>');

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

function aceSwitch( cellvalue, options, cell ) {
    setTimeout(function(){
        $(cell) .find('input[type=checkbox]')
                .wrap('<label class="inline" />')
                .addClass('ace ace-switch ace-switch-5')
                .after('<span class="lbl"></span>');
    }, 0);
}

function enableTooltips(table) {
    $('.navtable .ui-pg-button').tooltip({container:'body'});
    $(table).find('.ui-pg-div').tooltip({container:'body'});
}

function ChangeStatusBatch(grid, obj, url,publishField) {

	var bol = false;
    var items = $(grid).getGridParam('selarrrow');//获取选中的行ids
    var allids=[],allStatus=[];
    var colModel=$(grid).getGridParam('colModel');//取主键列的属性名
    var colName=colModel[1].name;
    
    if(items.length==0){
        $.alert("提示","请先选择一行数据再操作");
        return false;
    }
    
    for(let i=0;i<items.length;i++){
        var row=$(grid).getRowData(items[i]);
        //var col=$(grid).getCell(items[i],"PUBLISH_STATUS");
        if (row[publishField].indexOf("已发布")>=0) {
			$.alert("提示","不能选择已经发布的图文<br/>如仍需选择，请先取消发布。");
			return false;
		}
        allids.push(row[colName]);
    }
    
    console.log("ids:"+allids+"status:"+allStatus);
    
	var d = dialog({
		title: '消息',
		content: '<p>确定要' + (bol ? '取消 ' : '') + '发布?</p>',
		okValue: '确认',
		ok: function() {
			$.ajax({
				type: 'Get',
				data:{ids:allids,status:allStatus},
				url: url,
				cache: false
			}).done(function(data) {
				if (data.success) {
					$.alert("提示", data.msg);
					//刷新Grid
					$(grid).trigger("reloadGrid");
				} else {
					$.alert("提示", data.msg);
				}
			});
			return true;
		},
		cancelValue: '取消',
		cancel: function() {}
	});
	d.showModal();
}

function ChangeStatus(id, status, obj, url) {
	var bol = false;
	if (status == "Y" || status=="1") {
		bol = true;
	}
	var d = dialog({
		title: '消息',
		content: '<p>确定要' + (bol ? '取消 ' : '') + '发布?</p>',
		okValue: '确认',
		ok: function() {
			$.ajax({
				type: 'Get',
				data:{id:id,status:status},
				url: url,
				cache: false
			}).done(function(data) {
				if (data.success) {
					$.alert("提示", data.msg);
					console.log(obj);
				    HandlerPage($(obj));
				} else {
					$.alert("提示", data.msg);
				}
			});
			return true;
		},
		cancelValue: '取消',
		cancel: function() {}
	});
	d.showModal();
}

function HandlerPage($obj) {
	var gridName=$obj.data('grid');
	$obj.toggleClass('btn-success');
	$obj.toggleClass('btn-danger');

	if ($obj.html() == '<i class="fa fa-cloud-download"></i>') {
		$obj.html('<i class="fa fa-cloud-upload"></i>');
	} else {
		$obj.html('<i class="fa fa-cloud-download"></i>');
	}
	//刷新Grid
	$("#"+gridName).trigger("reloadGrid");
}

function imgLoad(element) {
	var imgSrc = $(element).height() < 80 ? "resource/image/icon/failed-small.png"
			: "resource/image/icon/failed-big.png"
	$(element).attr("src", imgSrc);
}

//enable datepicker
function pickDate( cellvalue, options, cell ) {
    setTimeout(function(){
        $(cell) .find('input[type=text]')
                .datepicker({format:'yyyy-mm-dd' , autoclose:true});
    }, 0);
}

function switchType(type){
          switch(type){
          case 1:
              return "抢购活动";
              break;
          case 2:
        	  return "底部活动";
              break;
          case 3:
        	  return "特殊活动";
              break;
          case 4:
              return "其他活动";
              break;
          case 5:
        	  return "优惠券活动";
              break;
          case 6:
        	  return "返券活动";
              break;
          case 7:
              return "满立减活动";
              break;
          case 8:
        	  return "排名活动";
              break;
          case 9:
        	  return "banner活动";
              break;
		  case 10:
			  return "团购活动";
			  break;
		  case 11:
              return "首单送鲜果币";
              break;
          case 12:
        	  return "手动发券活动";
              break;
          case 13:
        	  return "九宫格活动";
              break;
          case 14:
              return "首页滚动公告活动";
              break;
          case 15:
        	  return "鲜果师食鲜推荐";
              break;
          case 16:
        	  return "鲜果师营养精选";
              break;
          case 17:
              return "H5页发券活动";
              break;
          case 18:
        	  return "种子购活动";
        	  break;
          case 19:
        	  return "优惠券兑换码";
        	  break;
          default:
        	  return "N/A";
		}
}
/**     
 * 对Date的扩展，将 Date 转化为指定格式的String     
 * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、周(E)、季度(q) 可以用 1-2 个占位符     
 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)     
 * eg:     
 * (new Date()).pattern("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423     
 * (new Date()).pattern("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 二 20:09:04     
 * (new Date()).pattern("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 周二 08:09:04     
 * (new Date()).pattern("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 星期二 08:09:04     
 * (new Date()).pattern("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18     
使用：(eval(value.replace(/\/Date\((\d+)\)\//gi, "new Date($1)"))).pattern("yyyy-M-d h:m:s.S");
 */
Date.prototype.pattern = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份        
        "d+": this.getDate(), //日        
        "h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //小时        
        "H+": this.getHours(), //小时        
        "m+": this.getMinutes(), //分        
        "s+": this.getSeconds(), //秒        
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度        
        "S": this.getMilliseconds() //毫秒        
    };
    var week = {
        "0": "/u65e5",
        "1": "/u4e00",
        "2": "/u4e8c",
        "3": "/u4e09",
        "4": "/u56db",
        "5": "/u4e94",
        "6": "/u516d"
    };
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    if (/(E+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "/u661f/u671f" : "/u5468") : "") + week[this.getDay() + ""]);
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    }
    return fmt;
};