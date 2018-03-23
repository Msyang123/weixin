<!DOCTYPE html>
<html>
<head>
<title>美味食鲜-鲜果师申请</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-鲜果师申请页" />
<link rel="stylesheet" href="plugin/webuploader/webuploader.css">
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">
	<div id="master_apply" class="wrapper pd10">
		<header class="m-apply-banner">
			<img src="resource/image/img-master/upload_banner.png">
		</header>
		
		<form id="apply_form">
			<div class="s-card m-apply-info">
				 <div class="form-group">
				    <label for="name">姓名</label>
				    <input type="hidden" id="master_recommend " name="xFruitMaster.master_recommend" value="${masterDetail.master_recommend!}">
				    <input type="hidden" id="master_id" name="xFruitMaster.id" value="${(masterDetail.id)!}">
				    <input type="hidden" id="apply_id" name="xFruitApply.id" value="${(masterDetail.apply_id)!}">
				    <input type="text" id="name" name="xFruitMaster.master_name" placeholder="请输入身份证上的姓名" value="${(masterDetail.master_name)!}">
				 </div>
				 <div class="form-group">
				    <label for=" idNumber">身份证号码</label>
				    <input type="text" id="idNumber" name="xFruitApply.idcard" value="${(masterDetail.idcard)!}">
				 </div>		
				 <div class="form-group">
				    <label for="phoneNumber">手机号码</label>
				    <input type="number" id="phoneNumber" name="xFruitApply.mobile" value="${(masterDetail.mobile)!}">
				 </div>
				 <div class="form-group">
				    <label for="authCode">验证码</label>
				    <input type="text" id="authCode" name="authCode">
				    <button id="getVerify" type="button" class="u-btn-brown3" style="width: auto;padding: 0 8px;">获取验证码</button>
				 </div>
			</div>
			
			<div class="m-apply-card1 s-shadow2">
				<h3>身份证正面</h3>
				<div class="u-upload-box u-id-box1">
					<img src="resource/image/icon-master/upload_idcard_positive.png" class="u-bg-img">
					<img src="resource/image/icon-master/btn_add.png" class="u-btn-add">
					<div id="filePicker" class="u-true-btn">选择图片</div>
        			<div id="thelist" class="uploader-list u-true-img"></div>
        			<input type="hidden" id="id_IMAGE" name="xFruitApply.idcard_face" value="${(masterDetail.idcard_face)!}"/>
					<img id="preview" class="img-responsive u-look-img" src="${(masterDetail.idcard_face)!}"/>
				</div>
			</div>
			
			<div class="m-apply-card2 s-shadow2">
				<h3>身份证反面</h3>
				<div class="u-upload-box u-id-box2">
					<img src="resource/image/icon-master/upload_certificate.png" class="u-bg-img">
					<img src="resource/image/icon-master/btn_add.png" class="u-btn-add">
					<div id="filePicker1" class="u-true-btn">选择图片</div>
        			<div id="thelist1" class="uploader-list u-true-img"></div>
        			<input type="hidden" id="id_IMAGE1" name="xFruitApply.idcard_opposite" value="${(masterDetail.idcard_opposite)!}"/>
					<img id="preview1" class="img-responsive u-look-img" src="${(masterDetail.idcard_opposite)!}"/>
				</div>
			</div>
			
			<div class="m-apply-card3 s-shadow2">
				<h3>资质证明</h3>
				<p>如营养师证，相关专业毕业证。选填</p>
				<div class="u-upload-box">
					<img src="resource/image/icon-master/upload_idcard_reverse.png" class="u-bg-img">
					<img src="resource/image/icon-master/btn_add.png" class="u-btn-add">
					<div id="filePicker2" class="u-true-btn">选择图片</div>
        			<div id="thelist2" class="uploader-list u-true-img"></div>
        			<input type="hidden" id="OTHER_IMAGE" name="xFruitApply.qualification" />
					<img id="preview2" class="img-responsive u-look-img" src="${(masterDetail.qualification)!}"/>
				</div>
			</div>
			
			<button type="button" class="btn u-btn-apply btn-lg btn-block" id="btn-apply">申请成为鲜果师</button>
		</form>			
			
	</div>
<script type="text/javascript" src="plugin/webuploader/webuploader.min.js"></script>	
<script type="text/javascript">
    $(function(){
        /*init webuploader*/
        var $btn = $("#btn-apply")
        var thumbnailWidth = 1;//缩略图高度和宽度 （单位是像素）
        var thumbnailHeight = 1;
        var $list = $("#thelist");
        var $list1 = $("#thelist1");
        var $list2 = $("#thelist2");
        
        var uploader = WebUploader.create({
        	// 选完文件后，是否自动上传。
            auto: true,

            // swf文件路径
            swf: 'plugin/webuploader/Uploader.swf',

            // 文件接收服务端。
            server: '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName=masterImage',

            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            pick: '#filePicker',

            // 只允许选择图片文件。
            accept: {
                title: 'Images',
                extensions: 'gif,jpg,jpeg,bmp,png',
                mimeTypes: 'image/jpg,image/jpeg,image/png'
            },
            method:'POST',
           // fileSizeLimit:1
           
        });
        
        // 当有文件添加进来的时候
        uploader.on('fileQueued', function (file) {
            var $li = $(
                            '<div id="' + file.id + '" class="file-item">' +
                            '<img id="preview_img' + file.id + '" style="display:none;">' +
                            '</div>'
                    ),
                    $img = $li.find('img');
            
            // $list为容器jQuery实例
            $list.html('');
            $list.append($li); 
            // 创建缩略图
            // 如果为非图片文件，可以不用调用此方法。
            // thumbnailWidth x thumbnailHeight 为 100 x 100
            uploader.makeThumb(file, function (error, src) {
                if (error) {
                    $img.replaceWith('<span>不能预览</span>');
                    return;
                }
                $img.attr('src', src);
            }, thumbnailWidth, thumbnailHeight);
        });



        // 文件上传过程中创建进度条实时显示。
        uploader.on( 'uploadProgress', function( file, percentage ) {
            var $li = $( '#'+file.id ),
                    $percent = $li.find('.progress span');

            // 避免重复创建
            if ( !$percent.length ) {
                $percent = $('<p class="progress"><span></span></p>')
                        .appendTo( $li )
                        .find('span');
            }

            $percent.css( 'width', percentage * 100 + '%' );
        });

        // 文件上传成功，给item添加成功class, 用样式标记上传成功。
        uploader.on('uploadSuccess', function (file, response) {
        	//序列化服务器端的数据
        	    var data = response;
        	    //返回结果 {error: 0, url: "/weixin/resource/image/activity/zhongzigouhuodong/20170813093041_371.jpg"}
       	    	var $preview=$('#' + file.id).parents('.u-upload-box').find('#preview');
       	    	$preview.attr('src',data.url);
       	    	$preview.prev('input').val(data.url);
       	    	$('#preview_img' + file.id).attr('data-value',data.fileUrl);
            	$( '#'+file.id ).addClass('upload-state-done');
            	if(data.error!=0){
            		$.dialog.alert(response._raw); 
            	}
        });

        // 文件上传失败，显示上传出错。
        uploader.on( 'uploadError', function(file) {
            var $li = $( '#'+file.id ),
                    $error = $li.find('div.error');

            // 避免重复创建
            if ( !$error.length ) {
                $error = $('<div class="error"></div>').appendTo( $li );
            }

            $error.text('上传失败');
        });

        // 完成上传完了，成功或者失败，先删除进度条。
        uploader.on( 'uploadComplete', function( file ) {
            $( '#'+file.id ).find('.progress').remove();
        });
//         uploader.on( 'all', function() {  
//         	console.log($("#filePicker").find(".webuploader-element-invisible").attr("capture"));
//         	var u = navigator.userAgent;
//        	    if (u.indexOf('Android') > -1 || u.indexOf('Adr') > -1) {
//        	         //安卓手机
//        	    	$("#filePicker").find(".webuploader-element-invisible").attr("capture","camera");
//        	    	alert($("#filePicker").find(".webuploader-element-invisible").attr("capture"));
//        	    } else if (!!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)) {
//        	         //苹果手机
//        	    	$("#filePicker").find(".webuploader-element-invisible").removeAttr("capture");
//        	    	alert($("#filePicker").find(".webuploader-element-invisible").attr("capture"));
//        	    }
//         	$("#filePicker").find(".webuploader-element-invisible").attr("capture","camera");
//         });
        
        var uploader1 = WebUploader.create({
            // 选完文件后，是否自动上传。
            auto: true,

            // swf文件路径
            swf: 'plugin/webuploader/Uploader.swf',

            // 文件接收服务端。
            server: '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName=masterImage',

            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            pick: '#filePicker1',

            // 只允许选择图片文件。
            accept: {
                title: 'Images',
                extensions: 'gif,jpg,jpeg,bmp,png',
                mimeTypes: 'image/jpg,image/jpeg,image/png'
            },
            method:'POST',
           // fileSizeLimit:1
        });

        // 当有文件添加进来的时候
        uploader1.on('fileQueued', function (file) {
            var $li = $(
                            '<div id="' + file.id + '" class="file-item">' +
                            '<img id="preview_img1' + file.id + '" style="display:none;">' +
                            '</div>'
                    ),
                    $img = $li.find('img');

            // $list为容器jQuery实例
            $list1.html('');
            $list1.append($li); 
            // 创建缩略图
            // 如果为非图片文件，可以不用调用此方法。
            // thumbnailWidth x thumbnailHeight 为 100 x 100
            uploader1.makeThumb(file, function (error, src) {
                if (error) {
                    $img.replaceWith('<span>不能预览</span>');
                    return;
                }
                $img.attr('src', src);
            }, thumbnailWidth, thumbnailHeight);
        });



        // 文件上传过程中创建进度条实时显示。
        uploader1.on( 'uploadProgress', function( file, percentage ) {
            var $li = $( '#'+file.id ),
                    $percent = $li.find('.progress span');

            // 避免重复创建
            if ( !$percent.length ) {
                $percent = $('<p class="progress"><span></span></p>')
                        .appendTo( $li )
                        .find('span');
            }

            $percent.css( 'width', percentage * 100 + '%' );
        });

        // 文件上传成功，给item添加成功class, 用样式标记上传成功。
        uploader1.on('uploadSuccess', function (file, response) {
        	    //序列化服务器端的数据
        	    var data = response;
        	    //返回结果 {error: 0, url: "/weixin/resource/image/activity/zhongzigouhuodong/20170813093041_371.jpg"}
       	    	var $preview=$('#' + file.id).parents('.u-upload-box').find('#preview1');
       	    	$preview.attr('src',data.url);
       	    	$preview.prev('input').val(data.url);
       	    	$('#preview_img' + file.id).attr('data-value',data.fileUrl);
            	$( '#'+file.id ).addClass('upload-state-done');
            	if(data.error!=0){
            		$.dialog.alert(response._raw); 
            	}
        });

        // 文件上传失败，显示上传出错。
        uploader1.on( 'uploadError', function(file) {
            var $li = $( '#'+file.id ),
                    $error = $li.find('div.error');

            // 避免重复创建
            if ( !$error.length ) {
                $error = $('<div class="error"></div>').appendTo( $li );
            }

            $error.text('上传失败');
        });

        // 完成上传完了，成功或者失败，先删除进度条。
        uploader1.on( 'uploadComplete', function( file ) {
            $( '#'+file.id ).find('.progress').remove();
        });
        
        var uploader2 = WebUploader.create({
            // 选完文件后，是否自动上传。
            auto: true,

            // swf文件路径
            swf: 'plugin/webuploader/Uploader.swf',

            // 文件接收服务端。
            server: '${CONTEXT_PATH}/resourceShow/upload?dir=image&idName=masterImage',

            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            pick: '#filePicker2',

            // 只允许选择图片文件。
            accept: {
                title: 'Images',
                extensions: 'gif,jpg,jpeg,bmp,png',
                mimeTypes: 'image/jpg,image/jpeg,image/png'
            },
            method:'POST',
           // fileSizeLimit:1
        });
        // 当有文件添加进来的时候
        uploader2.on('fileQueued', function (file) {
            var $li = $(
                            '<div id="' + file.id + '" class="file-item">' +
                            '<img id="preview_img2' + file.id + '" style="display:none;">' +
                            '</div>'
                    ),
                    $img = $li.find('img');

            // $list为容器jQuery实例
            $list2.html('');
            $list2.append($li); 
            // 创建缩略图
            // 如果为非图片文件，可以不用调用此方法。
            // thumbnailWidth x thumbnailHeight 为 100 x 100
            uploader2.makeThumb(file, function (error, src) {
                if (error) {
                    $img.replaceWith('<span>不能预览</span>');
                    return;
                }
                $img.attr('src', src);
            }, thumbnailWidth, thumbnailHeight);
        });



        // 文件上传过程中创建进度条实时显示。
        uploader2.on( 'uploadProgress', function( file, percentage ) {
            var $li = $( '#'+file.id ),
                    $percent = $li.find('.progress span');

            // 避免重复创建
            if ( !$percent.length ) {
                $percent = $('<p class="progress"><span></span></p>')
                        .appendTo( $li )
                        .find('span');
            }

            $percent.css( 'width', percentage * 100 + '%' );
        });

        // 文件上传成功，给item添加成功class, 用样式标记上传成功。
       uploader2.on('uploadSuccess', function (file, response) {
        	    //序列化服务器端的数据
        	    var data = response;
        	    //返回结果 {error: 0, url: "/weixin/resource/image/activity/zhongzigouhuodong/20170813093041_371.jpg"}
       	    	var $preview=$('#' + file.id).parents('.u-upload-box').find('#preview2');
       	    	$preview.attr('src',data.url);
       	    	$preview.prev('input').val(data.url);
       	    	$('#preview_img' + file.id).attr('data-value',data.fileUrl);
            	$( '#'+file.id ).addClass('upload-state-done');
            	if(data.error!=0){
            		$.dialog.alert(response._raw); 
            	}
        });

        // 文件上传失败，显示上传出错。
        uploader2.on( 'uploadError', function(file) {
            var $li = $( '#'+file.id ),
                    $error = $li.find('div.error');

            // 避免重复创建
            if ( !$error.length ) {
                $error = $('<div class="error"></div>').appendTo( $li );
            }

            $error.text('上传失败');
        });

        // 完成上传完了，成功或者失败，先删除进度条。
        uploader2.on( 'uploadComplete', function( file ) {
            $( '#'+file.id ).find('.progress').remove();
        });
    })    
     
    $(function(){
       	var t = 0;
 		var getVerifyClick = false;
 			
     $("#getVerify").on('click',function(){
 		var phone_num = $("#phoneNumber").val();
			var reg = /^1[0-9]{10}$/;
			if(phone_num==null||phone_num==""){
				alert("手机号码不能为空！");
				return;
			}
			if(!reg.test(phone_num)){
				alert("请输入正确的手机号码！");
				return;
			}
			getVerifyClick = true;
			clearInterval(t);
			$("#getVerify").attr("disabled","true");
 			$.ajax({
 	            type: "POST",
 	            data:{phone_num:$("#phoneNumber").val()},
 	            url: "${CONTEXT_PATH}/fruitMaster/getVerifyCode"
 	        }).done(function(data){
 	        	if(data.result=="success"){
	        		var seconds = 120;
	        		$("#phoneNumber").attr("readonly","readonly");
	        		$("#getVerify").css({
	        			  "color":"#ffffff",
	        			  "background-color":"#b2b2b2"
	        			  });
	        		$("#getVerify").html("再次获取("+seconds+")");
	 	        	t = setInterval(function() {
	 	        		if(seconds>1){
	 	        			seconds--;
	 	        			$("#getVerify").html("再次获取("+seconds+")");
	 	        		}else{
	 	        			$("#getVerify").html("再次获取");
	 	        			$("#getVerify").removeAttr("disabled");
	 	        		}
					}, 1000); 
 	        	}else{
 	        		alert(data.msg);
	        	}
       });
    })

		        var flag1,flag2,flag3,flag4,flag5,flag6;
		        //用户名
				function checkName(){
					var value = $("#name").val();
					var istrue=$("#name").val()!="";
		            if(!istrue){
		                flag1 = false;
		                $("#name").addClass('s-error-input');
		            }else {
		                flag1 = true;
		                $("#name").removeClass('s-error-input');
		            }
				}
		        
		        //身份证
				function checkNum(){
					var parent=/^(\d{18}|\d{17}[xX])$/;
					var value=$("#idNumber").val();
		            var istrue=parent.test(value)&&$("#idNumber").val()!="";
		            if(!istrue){
		                flag2 = false;
		                $("#idNumber").addClass('s-error-input');
		            }else {
		                flag2 = true;
		                $("#idNumber").removeClass('s-error-input');
		            }
				}
		        
		        
		      	//手机号
		      	function checkPhone(){
		      		var parent=/^1[0-9]{10}$/;
		            var value=$("#phoneNumber").val();
		            var istrue=parent.test(value)&&$("#phoneNumber").val()!="";
		            if(!istrue){
		                flag3 = false;
		                $("#phoneNumber").addClass('s-error-input');
		            }else {
		                flag3 = true;
		                $("#phoneNumber").removeClass('s-error-input');
		            }
		      	}
		      	
		        //验证码
		      	function checkCode(){
		      		var value=$("#authCode").val();
		            var istrue=$("#authCode").val()!="";
		            if(!istrue){
		                flag4 = false;
		                $("#authCode").addClass('s-error-input');
		            }else {
		                flag4 = true;
		                $("#authCode").removeClass('s-error-input');
		            }
		      	}
		        
		        function checkImg(){
		        	if($("#id_IMAGE").val()!=""){
		        		$("#id_IMAGE").parent(".u-id-box1").removeClass('s-error-input');
			    		flag5 = true;
			    	}else{
			    		flag5 = false;
			    		$("#id_IMAGE").parent(".u-id-box1").addClass('s-error-input');
			    	}
		        }
		        
		        function checkImg1(){
			    	if($("#id_IMAGE1").val()!=""){
			    		flag6 = true;
			    		$("#id_IMAGE1").parent(".u-id-box2").removeClass('s-error-input');
			    	}else{
			    		flag6 = false;
			    		$("#id_IMAGE1").parent(".u-id-box2").addClass('s-error-input');
			    	}
		        }
			    //提交
			    $('#btn-apply').on('click',function(){
			    	checkName();
			    	checkNum();
			    	checkPhone();
			    	checkCode();
			    	checkImg();
			    	checkImg1();
			    	if(flag1&&flag2&&flag3&&flag4&&flag5&&flag6){  
				          var formData= $('#apply_form').serializeArray();
				          var jsonData={};
				          for(var i=0;i<formData.length;i++){
				               jsonData[formData[i].name]=formData[i].value;
				          }
				          $.ajax({
					          url:'${CONTEXT_PATH}/fruitMaster/fruitregister',
						      type:'post',
						      dataType:'json',
						      data: jsonData,
					            success: function(data){
				            	if(data.result=="success"){
					        				$.dialog.alert("提交成功！");
						 	        		setTimeout(function(){
							        			window.location.href = "${CONTEXT_PATH}/fruitMaster/sbtCallbackSuccess";
							        		 },1000);
					 	        	}else{
					 	        		$.dialog.alert(data.msg);
					 	        	}
				            	}
				          });
			    	 }else {
			    		 $.dialog.alert("您填入的信息有误或者不完善，请重新输入");
		            } 
			    	
			    });		        
		});
</script>	
</body>
</html>