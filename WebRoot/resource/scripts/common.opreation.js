/**
 * Created by Andrew on 04/16.
 * 公共的grid相关opreation的代码
 */
$(document).ready(function(){
	 /**
     * CRUD--Add
     * 添加或修改调整新页-Ajaxload
     */
    $('#btn-add').on("click",function(){
        var $this = $(this);
        var link=$this.data("link");
        var title = $.trim($this.text());
        loadPage(link);
    });

    /**
     * CRUDS--Search
     * 搜索功能-Ajaxload
     */
    $('.btn-search').on("click",function(){
    	  //将form表单序列化传过去
    	  //提交前先校验--后期做
    	  //$('#search_form').submit();
    	  var gridName=$(this).data('grid');
    	  var data=$(this).parents('form#submitForm').serializeArray();
    	  var jsonData={};
          for(var i=0;i<data.length;i++){
               jsonData[data[i].name]=data[i].value;
          }
          //提交后刷新grid
    	  $(gridName).setGridParam({postData:jsonData}).trigger('reloadGrid');
    });
    
    /**
     * CRUDS--ClearForm
     * 清除搜索条件查询功能
     */
    $('.btn-clear').on('click',function(){
	     $(this).parents('#submitForm')[0].reset();
	    //隐藏字段也清除掉
	     $(this).parents('#submitForm').find('input[type="hidden"]').each(function(i,item){
	    	  $(item).val("");
	     })
        //刷新列表内容
	     $(this).next('.btn-search').trigger('click');
	});
});

function loadPage(url){
	$(".page-content .wrapper").load(url, null, function(response, status, xhr){
    	if (status != "error") {
            try {
              $(".page-content .wrapper").fadeIn();
              $("[data-toggle='tooltip']").tooltip({html : true});
              return;
            } catch (e) {}
            $(".page-content .wrapper").fadeOut();
          }
    });
}


function confrimDel(grid_selector,url,obj){
    var items = $(grid_selector).getGridParam('selarrrow');//获取的是行id
    var idArr=[];
    if(items.length==0){
        $.alert("提示","请先选择一行数据再操作");
        return false;
    }
    var content= items.length>1?"您确认删除这些记录吗？":"您确认删除此条记录吗？";
    var colModel=$(grid_selector).getGridParam('colModel');//取主键列的属性名
    var colName=colModel[1].name;
    for(let i=0;i<items.length;i++){
        var row=$(grid_selector).getRowData(items[i]);
        idArr.push(row[colName]);
    }
    var ids = idArr.join(",");
    var data={ids:ids};
   // var couponCategoryId=$(obj).data("categoryid");//有些删除需要传递acid
    $.confirm(content,"确定","取消",function () {
       //发送ajax回去删除
          $.ajax({
                url: url,
                type:'Get',
                data:data,
                success:function(result){
                    if(result.success){
                        $.alert('提示',result.msg);
                        //刷新grid
                        $(grid_selector).trigger("reloadGrid");
                    }
                    else
                    {
                        $.alert('提示',result.msg);
                    }
                }
         });
   });
}

function disableEdit(msg){
	$.alert("提示",msg);
}

function disableDel(msg){
	$.alert("提示",msg);
}