<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-帮助中心页" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="helper_center" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>帮助中心</span>
				<a v-if="faqObj.type==4" href="javacript:void(0);" class="u-btn-modal" data-toggle="modal" data-target="#contact_servicer">联系客服</a>
		  </header>
		  
		  <section class="m-list-questions col-12 mt48" v-cloak>
		       <div class="m-item" v-for="item in faqObj.faqList" :key="item.id">
		            <div class="u-question">
		              <img src="resource/image/icon-master/icon_question.png" class="" height="20"/>
		              <span>{{item.faq_title}}</span>
		            </div>
		           <div class="u-answer row no-gutters justify-content-center">
		                <div class="col-2 text-right"><img src="resource/image/icon-master/icon_answer.png" class="" height="20" /></div>
		                <div class="col-10"><p>{{item.faq_content}}</p></div>
		            </div>
		       </div>
		  </section>
		  
		  <div class="modal fade m-modal" id="contact_servicer" tabindex="-1" role="dialog" aria-hidden="true">
		      <div class="modal-dialog">
		   		<div class="modal-content">
		         	<div class="modal-body">	
			           	<h4>客服微信：<span class="js-account">1384568888</span></h4>
			           	<h4>留言框</h4>
			           	<input type="text" name="title"class="u-input-title form-control" placeholder="标题"
			           	v-model.trim="fbTitle" @focus="focusHandler" autocomplete="off" />
			           	<textarea id="feed_back" name="content" v-model.trim="fbContent" @focus="focusHandler"
			           	class="u-textarea-content form-control" placeholder="尽情的吐槽吧" oninput="common.reExpression()"></textarea>
			           	<span class="text-danger brand-red" v-show="isInvalid">{{errorMsg}}</span>
			           	<div class="text-center">
				        	<button class="btn bnt-sm u-btn-brown" @click="submitFeedBack">提交</button>
				        </div>
		         	</div>
		          </div>
		      </div>
		  </div>
	</div>
	
	<script>
		$(function() {
			var data={
                faqObj:${faqs},
                fbTitle:"",
                fbContent:"",
                isInvalid:false,
                errorMsg:""
		    };
		    
			var vm=new Vue({
				mixins:[backHistory],
                el:"#helper_center",
                data:data,
                methods: {
                    focusHandler:function(){
                         this.isInvalid=false;
                         this.errorMsg="";
                    },
                    submitFeedBack:function(){
                       var _this=this;
                       //先进行校验 标题内容不能为空
                       if(!_this.checkParam()){return false;}
                       //处理JFinal后台接收不到contentType为Json数据结构参数问题
                       var params = new URLSearchParams();
                       params.append('title', _this.fbTitle);
                       params.append('content',_this.fbContent);
                       //提交数据到后台
                       axios.post('${CONTEXT_PATH}/myself/saveFeedBack',params)
                       .then(function(response){
                    	   //console.log(response.data);
                           $('.m-modal').modal('hide');
                    	   if(response.data.status){
                               $.dialog.alert("提交成功，谢谢您的及时反馈！");
                           }else{
                        	   $.dialog.alert("提交失败，请尝试重新提交！");
                           }
                       })
                       .catch(function(error){
                            console.log(error);
                       });
                    },
                    checkParam:function(){
                         var _this=this;
                         var msg="标题不能为空";
                         var msg2="内容不能为空";
                         
                         if(_this.fbTitle==""&&_this.fbContent==""){
                              msg=msg+","+msg2;
                              _this.isInvalid=true;
                              _this.errorMsg=msg;
                              return false;
                         }
                         
                         if(_this.fbTitle==""){
                        	 _this.isInvalid=true;
                             _this.errorMsg=msg;
                             return false;
                         }  
                         
                         if(_this.fbContent==""){
                        	 _this.isInvalid=true;
                             _this.errorMsg=msg2;
                             return false;
                         }
                         return true;
                    }
                }
		     });

		     $('#contact_servicer').on('show.bs.modal',function(){
                  //清除掉上次填的数据
                  vm.fbTitle="";
                  vm.fbContent="";
                  vm.isInvalid=false;
                  vm.errorMsg="";
			 });
	    });
	</script>
</body>
</html>