<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.core-3.5.min.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.excheck-3.5.js","${CONTEXT_PATH}/plugin/zTree_v3/js/jquery.ztree.exedit-3.5.js","${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor-min.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/lang/zh_CN.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.js", "${CONTEXT_PATH}/plugin/kindeditor-4.1.10/kindeditor.js"] styles=["${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/zTreeStyle.css"] >

<div class="col-xs-12">

    <div class="zTreeDemoBackground left pull-left">
        <label>可创建最多3个一级菜单，每个一级菜单下可创建最多5个二级菜单。</label>
        <div id="weixinMenu" class="ztree"></div>
        
    </div>
    <div class="pull-right">
        <button class="btn btn-info" type="button" onclick="rebulidWeixinMenu();">
            <i class="fa fa-refresh bigger-110"></i> 生成微信公众平台菜单
        </button>
    </div>
    <div class="clearfix"></div>
    
    <div class="right">
        <div class="widget-box">
            <div class="widget-header widget-header-flat">
                <h4>微信菜单编辑</h4>
            </div>

            <div class="widget-body">
                <div class="widget-main">
                    <div class="row">
                        <div class="col-xs-12">
                            <form class="form-horizontal" role="form" id="editMenuItem">
                                <input type="hidden" name="udm.id" id="id"/>
                                <input type="hidden" name="udm.pid" id="pid"/>
                                <input type="hidden" name="udm.received_info" id="save_received_info"/>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        菜单名称
                                    </label>
                                    <div class="col-sm-9">
                                        <input type="text" id="menuName" name="udm.menu_name" placeholder="菜单名称"
                                               class="col-xs-12 col-sm-12"/>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        菜单标示
                                    </label>
                                    <div class="col-sm-9">
                                        <input type="text" id="menuSign" name="udm.menu_sign" placeholder="菜单标示"
                                               class="col-xs-12 col-sm-12"/>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        所属类型
                                    </label>
                                    <div class="col-sm-9">
                                        <div class="radio">
                                            <label>
                                                <input id="menuTypeClick" name="udm.menu_type" type="radio" class="ace" value="click"
                                                onclick="$('#receivedInfo').hide();
                                                $('#editorDiv').show(); "/>
                                                <span class="lbl">发送信息</span>
                                            </label>

                                            <label>
                                                <input id="menuTypeView" name="udm.menu_type" type="radio" class="ace" value="view"
                                                onclick="$('#receivedInfo').show();
                                                $('#editorDiv').hide();"/>
                                                <span class="lbl">跳转到网页</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        消息类型
                                    </label>
                                    <div class="col-sm-9">
                                        <div class="radio">
                                            <label>
                                                <input id="commonMessage" name="udm.msg_type" type="radio" class="ace" value="1" checked="checked"/>
                                                <span class="lbl">普通消息</span>
                                            </label>

                                            <label>
                                                <input id="mixedMessage" name="udm.msg_type" type="radio" class="ace" value="2"/>
                                                <span class="lbl">文字图片消息</span>
                                            </label>

                                            <label>
                                                <input id="pictureMessage" name="udm.msg_type" type="radio" class="ace" value="3"/>
                                                <span class="lbl">图片消息</span>
                                            </label>
                                            <label>
                                                <input id="selfMessage" name="udm.msg_type" type="radio" class="ace" value="4" onclick="$('#receivedInfo').hide();
                                                $('#editorDiv').show();"/>
                                                <span class="lbl">自定义消息</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        消息内容
                                    </label>
                                    <div class="col-sm-9">
                                        <input type="text" id="receivedInfo"  placeholder="消息内容"
                                               class="col-xs-12 col-sm-12"/>
                                        <div id="editorDiv" style="display: none;">
                                            <textarea id="editor" name="received_info" style="width:1230px;height:300px;" ></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        排序序号
                                    </label>
                                    <div class="col-sm-9">
                                        <input type="text" id="orderId" name="udm.order_id" placeholder="排序序号"
                                               class="col-xs-12 col-sm-12"/>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        图片地址
                                    </label>
                                    <div class="col-sm-9">
                                        <input type="text" id="picUrl" name="udm.pic_url" placeholder="图片地址"
                                               class="col-xs-12 col-sm-12"/>
                                    </div>
                                </div>
                                <div class="space-4"></div>
                                <div class="form-group">
                                    <label class="col-sm-1 control-label no-padding-right" for="form-input-readonly">
                                        链接地址
                                    </label>
                                    <div class="col-sm-9">
                                        <input type="text" id="url" name="udm.url" placeholder="链接地址"
                                               class="col-xs-12 col-sm-12"/>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-sm-12 col-md-12 text-center">
                                        <button class="btn btn-info" id="saveForm" type="button">
                                            <i class="icon-ok bigger-110"></i> 保存
                                        </button>
                                        <button class="btn" type="reset">
                                            <i class="icon-undo bigger-110"></i> 取消
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</@layout>


<script type="text/javascript">
    var resuorceEditor;
    var setting = {
        async: {
            enable: true,
            url: "${CONTEXT_PATH}/system/showWeixinMenu",
            dataType: "text",
            dataFilter: ajaxDataFilter,

            autoParam: ["id", "name"]
        },
        data: { // 必须使用data
            simpleData: {
                enable: true,
                idKey: "id", // id编号命名 默认
                pIdKey: "pId", // 父id编号命名 默认
                rootPId: 0 // 用于修正根节点父节点数据，即 pIdKey 指定的属性值
            }
        },
        // 回调函数
        callback: {
            onClick: function (event, treeId, treeNode, clickFlag) {
                    $("#id").val(treeNode.id);
                    $("#pid").val(treeNode.pId);
                    $("#menuName").val(treeNode.name);
                    $("#menuSign").val(treeNode.menuSign);
                    if(treeNode.menuType=='click'){
                        $("#menuTypeClick").prop("checked","checked");
                        $("#receivedInfo").hide();
                        $("#editorDiv").show();
                    }else{
                        $("#menuTypeView").prop("checked","checked");
                        $("#receivedInfo").show();
                        $("#editorDiv").hide();
                    }
                    if(treeNode.msgType==1){
                        $("#commonMessage").prop("checked","checked");
                    }else if(treeNode.msgType==2){
                        $("#mixedMessage").prop("checked","checked");
                    }else if(treeNode.msgType==3){
                        $("#pictureMessage").prop("checked","checked");
                    }else{
                    	$("#selfMessage").prop("checked","checked");
                    	$("#receivedInfo").hide();
                        $("#editorDiv").show();
                    }
                    $("#orderId").val(treeNode.orderId);
                    $("#receivedInfo").val(treeNode.receivedInfo);
                    resuorceEditor.html(treeNode.receivedInfo);
                    $("#save_received_info").val(treeNode.receivedInfo);
                    $("#picUrl").val(treeNode.picUrl);
                    $("#url").val(treeNode.url);
            },
            //捕获<strong>异步</strong>加载出现异常错误的事件回调函数 和 成功的回调函数
            onAsyncError: function (event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {
                alert("加载错误：" + XMLHttpRequest);
            },
            onAsyncSuccess: function (event, treeId, treeNode, msg) {

            },
            //简洁的重新编辑菜单项
            onRename:function(event, treeId, treeNode){
                $.ajax({
                    cache: false,
                    type: "POST",
                    url:"${CONTEXT_PATH}/system/saveItem",
                    data:{'udm.menu_name':treeNode.name,'udm.id':treeNode.id,'udm.pid':treeNode.pId,'udm.menu_sign':treeNode.menuSign,
                    'udm.menu_type':treeNode.menuType,'udm.order_id':treeNode.orderId,'udm.received_info':treeNode.receivedInfo,
                        'udm.msg_type':treeNode.msgType,'udm.pic_url':treeNode.picUrl,'udm.url':treeNode.url},
                    async: true,
                    error: function(request) {
                        alert("重命名错误");
                    },
                    success: function(data) {
                        menUtree.reAsyncChildNodes(menUtree.getNodeByTId("weixinMenu_1"), "refresh",false);
                    }
                });
            },
            beforeRemove: beforeRemove,
            onRemove: onRemove/*,
            beforeDrag: beforeDrag,
            beforeEditName: beforeEditName,
            beforeRemove: beforeRemove,
            beforeRename: beforeRename,
            onRemove: onRemove,
            onRename: onRename*/
        },

        view: {
            addHoverDom: addHoverDom,
            removeHoverDom: removeHoverDom,
            selectedMulti: false
        },
        edit: {
            enable: true,
            editNameSelectAll: true,
            showRemoveBtn: showRemoveBtn,
            showRenameBtn: showRenameBtn
        }
    };

    var zNodes = [
        { id: 0, pId: -1, name: "微信自定义菜单", isParent: true, open: true, icon: "${CONTEXT_PATH}/plugin/zTree_v3/css/zTreeStyle/img/diy/1_close.png"}
    ];
    var log, className = "dark";
    function beforeDrag(treeId, treeNodes) {
        return false;
    }
    function beforeEditName(treeId, treeNode) {
        className = (className === "dark" ? "" : "dark");
        showLog("[ " + getTime() + " beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
        var zTree = $.fn.zTree.getZTreeObj("weixinMenu");
        zTree.selectNode(treeNode);
        return confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？");
    }
    function beforeRemove(treeId, treeNode) {
        className = (className === "dark" ? "" : "dark");
        showLog("[ " + getTime() + " beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
        var zTree = $.fn.zTree.getZTreeObj("weixinMenu");
        zTree.selectNode(treeNode);
        return confirm("确认删除 节点(" + treeNode.name + ")吗？");
    }
    function onRemove(e, treeId, treeNode) {
        $.ajax({
            cache: false,
            type: "POST",
            url:"${CONTEXT_PATH}/system/removeItem",
            data:{'id':treeNode.id},
            async: true,
            error: function(request) {
                alert("删除菜单错误");
            },
            success: function(data) {
                menUtree.reAsyncChildNodes(menUtree.getNodeByTId("weixinMenu_1"), "refresh",false);
            }
        });
    }
    function beforeRename(treeId, treeNode, newName, isCancel) {
        className = (className === "dark" ? "" : "dark");
        showLog((isCancel ? "<span style='color:red'>" : "") + "[ " + getTime() + " beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>" : ""));
        if (newName.length == 0) {
            alert("节点名称不能为空.");
            var zTree = $.fn.zTree.getZTreeObj("weixinMenu");
            setTimeout(function () {
                zTree.editName(treeNode)
            }, 10);
            return false;
        }
        return true;
    }
    function onRename(e, treeId, treeNode, isCancel) {
        showLog((isCancel ? "<span style='color:red'>" : "") + "[ " + getTime() + " onRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>" : ""));
    }
    //非根节点的显示所有的
    function showRemoveBtn(treeId, treeNode) {
        return treeNode.tId!="weixinMenu_1";//!treeNode.isFirstNode;
    }
    //非根节点的显示所有的
    function showRenameBtn(treeId, treeNode) {
        return treeNode.tId!="weixinMenu_1";//!treeNode.isLastNode;
    }
    function showLog(str) {
        if (!log) log = $("#log");
        log.append("<li class='" + className + "'>" + str + "</li>");
        if (log.children("li").length > 8) {
            log.get(0).removeChild(log.children("li")[0]);
        }
    }
    function getTime() {
        var now = new Date(),
                h = now.getHours(),
                m = now.getMinutes(),
                s = now.getSeconds(),
                ms = now.getMilliseconds();
        return (h + ":" + m + ":" + s + " " + ms);
    }

    var newCount = 1;

    //添加节点
    function addHoverDom(treeId, treeNode) {
        var sObj = $("#" + treeNode.tId + "_span");
        if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) return;
        var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                + "' title='add node' onfocus='this.blur();'></span>";
        sObj.after(addStr);
        var btn = $("#addBtn_" + treeNode.tId);
        if (btn) btn.bind("click", function () {
            //var zTree = $.fn.zTree.getZTreeObj("weixinMenu");
            $("#pid").val(treeNode.id);
            $("#id").val("");
            $("#menuName").val("").focus();
            //zTree.addNodes(treeNode, {id: (100 + newCount), pId: treeNode.id, name: "new node" + (newCount++)});
            return false;
        });
    }
    ;
    function removeHoverDom(treeId, treeNode) {
        $("#addBtn_" + treeNode.tId).unbind().remove();
    }
    ;
    /**
     * 组织Tree数据
     * @param treeId
     * @param parentNode
     * @param data
     * @returns {Array}
     */
    function ajaxDataFilter(treeId, parentNode, data) {
        var nc = data.childMenuItems.length, _pId = parentNode.id, _id = null, _name = null, array = [];
        for (var i = 0; i < nc; i++) {
            _id = data.childMenuItems[i].id;
            _name = data.childMenuItems[i].menu_name;
            array[i] = {pId: _pId, id: _id, name: _name, isParent: data.childMenuItems[i].is_parent, open: false,orderId:data.childMenuItems[i].order_id,
                menuSign:data.childMenuItems[i].menu_sign,menuType:data.childMenuItems[i].menu_type,receivedInfo:data.childMenuItems[i].received_info,
                msgType:data.childMenuItems[i].msg_type,picUrl:data.childMenuItems[i].pic_url,url:data.childMenuItems[i].url};
        }

        return array;
    }
    var menUtree=null;
    function submitEditedMenuItem(resuorceEditor){
        if($("#menuTypeClick:checked").val()!=null||$("#selfMessage:checked").val()!=null){

            $("#save_received_info").val(resuorceEditor.html());
        }else{
            $("#save_received_info").val($("#receivedInfo").val());
        }
        $.ajax({
            cache: false,
            type: "POST",
            url:"${CONTEXT_PATH}/system/saveItem",
            data:$('#editMenuItem').serialize(),
            async: false,
            error: function(request) {
                alert("Connection error");
            },
            success: function(data) {
                menUtree.reAsyncChildNodes(menUtree.getNodeByTId("weixinMenu_1"), "refresh",false);
            }
        });
    }
    /**
     * 生成微信菜单树
     */
     function rebulidWeixinMenu(){
        $.ajax({
            cache: false,
            type: "POST",
            url:"${CONTEXT_PATH}/weixin/rebulidWeixinMenu",
            data:{},
            async: false,
            error: function(request) {
                alert("内部错误");
            },
            success: function(data) {
                if(data.errcode==0){
                    alert("生成微信公众平台菜单成功");
                }else{
                    alert("生成微信公众平台菜单失败，错误码("+data.errcode+")，请重试"+data.errmsg);
                }
            }
        });
     }
    /**
     * 渲染树
     */
    $(document).ready(function () {
        menUtree=$.fn.zTree.init($("#weixinMenu"), setting, zNodes);


        KindEditor.ready(function(K) {
            resuorceEditor = K.create('textarea[id="editor"]', {
                cssPath : '${CONTEXT_PATH}/plugin/kindeditor-4.1.10/plugins/code/prettify.css',
                uploadJson : '${CONTEXT_PATH}/resourceShow/upload',
                fileManagerJson : '${CONTEXT_PATH}/resourceShow/fileManage',
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
            K("#saveForm").click(function(e) {
                submitEditedMenuItem(resuorceEditor);
            });
            prettyPrint();
        });
    });
</script>