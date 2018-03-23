<!DOCTYPE html>
<html>
<head>
	<title>水果熟了</title>
	<meta charset="utf-8" />
	<base href="${CONTEXT_PATH}/" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
	<meta name="description" content="水果熟了-种子购活动" />
	<#include "/WEB-INF/pages/common/_layout_mobile.ftl"/>
</head>
<body> 
	<div data-role="page" class="seed-buy bg-white">
			<div class="orderhead">
				<div class="btn-back">
					<a onclick="back();"><img height="20px" src="resource/image/icon/icon-back.png" /></a>   
			    </div>
			     <div>${(mActivity.main_title)!}</div>
			     <div class="rules"><a href="javascript:void(0);" class="brand-red" data-target="#activity_rules" data-toggle="modal"><u>活动规则</u></a></div>
			</div>
			
			<div data-role="main" class="seed-buy-content mt41">
				<div class="banner">
				   <img src="${(mActivity.save_string)!}" class="w-100" onerror="common.imgLoadMaster(this)"/>
				</div>
				<div class="white-box">
				   <div class="white-box-head text-center">
					   <h3>
					   	 <hr class="hrLine mr5"/>
					   	  您拥有的种子
					   	 <hr class="hrLine ml5"/>
					   	 <span class="btn-record" id="goRrecord"><u>兑换记录</u></span>
					   </h3>
				   </div>
				   <div class="swiper-container0">
				      <div class="swiper-wrapper row no-gutters seed-box">
						<#if mySeeds?? &&(mySeeds?size>0) >
							<#list mySeeds as seed>
						      	<div class="swiper-slide seed">
							      	<img src="${seed.save_string!}" />
							      	<h5>${seed.seed_name!}</h5>
							      	<span>x${seed.total_instance!}</span>	
						      	</div>
						    </#list>
  						<#else>
  							暂时还未获取到种子
  						</#if>
				   	  </div>
				   	  <div class="swiper-pagination0"></div>
				   </div>
				</div>
				
				<div class="white-box pd-less">
				   	<div class="white-box-head text-center">
				   		<h3><hr class="hrLine mr5"/>单品兑换<hr class="hrLine ml5"/></h3>
				   </div>
				   <div class="swiper-container">
				      <div class="swiper-wrapper row no-gutters friut-exchanges">
				      <input type="hidden" id="activity_id" value="${mActivity.id!}">
				      		<#if mSeedProducts?? &&(mSeedProducts?size>0) >
				      			<#list mSeedProducts as product>
						           <div class="swiper-slide friut-exchange">
						               <img src="${product.seedProduct.save_string}" height="60"/>

						               <h5><span class="mb5 js-proname">${product.seedProduct.product_name!}</span>
						                                             约${product.seedProduct.product_amount!}${product.seedProduct.base_unitname!}/${product.seedProduct.unit_name!}</h5>

						               <#if product.seedProduct.status=='Y'>
						               		<button type="button" class="btn-exchange btn-custom" data-target="#exchange" data-toggle="modal" data-type="single" data-singleid="${product.seedProduct.id}">兑换</button>
						               <#else>
						               		<button type="button" class="btn-exchange btn-custom btn-disabled disabled" data-type="single">无法兑换</button>
						               </#if>
						               <p>需<#list product.needSeed as seed>
						               <span class="js-seedstr">${seed.seed_name}${seed.amount}个</span>
						               </#list>
						               </p>
						           </div>
						        </#list>   
				           <#else>
				           		暂无单品
				           </#if>
				      </div>
				      <div class="swiper-pagination1"></div>
				   </div>
				</div>
				
				<div class="white-box pd-less">
				   <div class="white-box-head text-center"><h3>
				   		<hr class="hrLine mr5"/>套餐兑换<hr class="hrLine ml5"/>
				   	  </h3></div>
				   	  	<#if mPackages?? &&(mPackages?size>0)>
					   	  	<#list mPackages as pg>
					   		<div class="combo-box">
							   <div class="combo">
							      <div class="combo-head">
							          <h3 class="brand-red">${pg.package.package_name}</h3>
							          <p class="text-muted">套餐内含：
							          <#list pg.packageProduct as pp>	
							          		<#if (pp_index gt 0) >
							          			、
							          		</#if>
											${pp.product_name!}约${(pp.product_amount)!}${pp.base_unitname!}/${pp.unit_name!}(x${pp.amount!})
									  </#list>
							          </p>
							      </div>
							      <div class="combo-img">
					                    <img src="${pg.package.save_string!}" height="85" onerror="this.src='resource/image/activity/seedbuy/taocan.png'"/>
							          <h3>需要种子</h3>		          
							      </div>
							      <div class="row no-gutters justify-content-center align-items-center combo-content">
							      	<#if pg.packageSeed?? && (pg.packageSeed?size>0)>
							      		<#list pg.packageSeed as ps>
							      			<#if (ps_index gt 0) >
							          			<div class="col-auto"><img src="resource/image/activity/seedbuy/seed-plus.png" /></div>
							          		</#if>
							      			 <div class="col combo-seed" data-seed="${ps.seed_name}" data-num="${ps.amount}">
										          <img src="${ps.save_string}" height="48"/>
										         <!--  <span>${ps.seed_name}</span> -->
										          <span>x${ps.amount}</span>
									          </div>
							      		</#list>
							      	<#else>
							      		暂无兑换种子数据	
							      	</#if>
							      </div>
							   </div>
							   <div class="col-12 text-center">
								   <#if pg.package.isLimit==0>
									   <button type="button" class="btn-exchange btn-custom" 
								   		data-target="#exchange" data-toggle="modal" data-name="${pg.package.package_name}" data-type="combo" data-packageid="${pg.package.id}">兑换</button>	
								   <#elseif pg.package.isLimit==1>
								   		<#if (pg.package.max_num gt 0)>
								   			<button type="button" class="btn-exchange btn-custom" 
									   		data-target="#exchange" data-toggle="modal" data-name="${pg.package.package_name}" data-type="combo" data-packageid="${pg.package.id}">兑换</button>	
								   		<#else>
								   			<button type="button" class="btn-exchange btn-custom btn-disabled disbaled">无法兑换</button>
								   		</#if>
								   	<#else>
								   		<button type="button" class="btn-exchange btn-custom btn-disabled disbaled">无法兑换</button>
								   </#if>
							   </div>
					         </div>
					       </#list>  
				        <#else>
				        	暂无套餐
				        </#if>
				</div>

				<div class="line"></div>
				<#if frequence??>
					<div class="share-area">
						<input type="hidden" id="seedNum" value="${seedNum!}">
					     <img src="resource/image/activity/seedbuy/icon-gift.png" height="35" />
					     <h5>活动期间
					     	<#if frequence=='0'>
								首次
							<#else>
								每天
							</#if>
					     	分享活动内容页到朋友圈</h5>
					     <h4>将获得${seedNum!}个种子作为奖励</h4>
					     <div class="col-12"><button type="button" class="btn-exchange btn-custom go-share">马上分享</button></div>
					 </div>
			    </#if>
			</div>
	</div>
	
	<div class="modal fade" id="activity_rules" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <h3 class="modal-title brand-red text-center" style="padding-bottom: 5px;border-bottom:1px solid #eeeded;">活动规则</h3>
	            <div class="modal-body text-left">
	            	${(mActivity.content)!}
	            </div>
	        </div>
	    </div>
	</div><!--/End activity_rules-->
	
	<div class="shade">
            <i class="icon">
                <img src="resource/image/icon/arrows-share.png" />
            </i>
            <p>叫上小伙伴们一起来集种子吧~</p>
            <p>
           	    点击右上角   <span class="share">•••</span>
            </p>
            <div class="close_box">
                <a class="close_btn">知道啦</a>
            </div>
     </div>
     
	<div class="modal fade" id="share-succeed" tabindex="-1" role="dialog" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="pr10">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
		            </div>
		            <div class="modal-body text-center">
		            	<img src="resource/image/activity/seedbuy/fenxiang.png" width="30%">
		            	<p>分享成功</p>
		            	<p id="share-succeed-msg"></p>
		            </div>
		        </div>
		    </div>
    </div><!--/End share-succeed-->
		<!-- 由于直接生成订单，暂且注释掉 -->
		
	<div class="modal fade" id="exchange" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="pr10">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" data-role="none">&times;</button>
	            </div>
	            <div class="modal-body text-center">
	            	<img src="resource/image/activity/seedbuy/duihuan.png" width="30%" />
	            	<h5>兑换 <span class="exchange-fruit"></span></h5>
	            	<p>需 <span class="brand-red need-seed"></span></p>
	            	<input name="giftId" id="giftId" type="hidden"/>
	            	<div class="col-12 text-center">
		            	<button type="button" class="btn-exchange btn-custom" id="btn-confirm">确认兑换</button>
		            </div>
	            </div>
	        </div>
	    </div>
	</div><!--/End exchange-->
			
	<#include "/WEB-INF/pages/common/share.ftl"/>
	<script src="plugin/common/location.js"></script>
	<script type="text/javascript">
	/*初始化console*/
	$(function(){
	     //弹出框事件
	     $('#exchange').on('show.bs.modal',function(e){
	           var $button=$(e.relatedTarget);
	           $('#btn-confirm').attr("data-type",$button.data('type'));
	           //为套餐兑换时
	           if($button.data("type")=="combo"){
	                var name=$button.data('name');
	                var packageid=$button.data('packageid');
	                var seedNodes=$button.parents('.combo-box').find('.combo-seed');
	                var len=seedNodes.length; 
	                var needStr="";
	                var seed="",num="";    
	                
	                $('.exchange-fruit').text(name);  
	                
	                $('#giftId').val(packageid);
	                
	                if(len==1){
	                     seed=seedNodes.eq(0).data("seed");
		                 num=seedNodes.eq(0).data("num");
	                     needStr=seed+num+"个";
	                     $('.need-seed').text(needStr);                  
	                }else{                           
		                for(var i=0;i<len;i++){
		                   seed=seedNodes.eq(i).data("seed");
		                   num=seedNodes.eq(i).data("num");               
		                   needStr+=seed+num+"个"+"+";	                                      
		                }                      
		                $('.need-seed').text(needStr.substring(0,needStr.length-1));
	                }
	                
	           }else{
	               var name=$button.parents('.friut-exchange').find('.js-proname').text();   
	               var spanNodes=$button.parents('.friut-exchange').find('span.js-seedstr');
	               var singleid=$button.data('singleid');
	               var len=spanNodes.length;
	               var needStr=""; 
	                   
	               $('.exchange-fruit').text(name); 
	               
	               $('#giftId').val(singleid);
	               	               
	               if(len==1){
	                     needStr=spanNodes.text();
	                     $('.need-seed').text(needStr);                  
	                }else{                           
		                for(var i=0;i<len;i++){                       
		                   needStr+=spanNodes.eq(i).text()+"+";	                                      
		                }                      
		                $('.need-seed').text(needStr.substring(0,needStr.length-1));
	                }                                              
	           }           
	     });
	     
	     //兑奖记录
	     $('#goRrecord').on('click',function(){
	    	 window.location.href="${CONTEXT_PATH}/getExchangeRecord";
	     })
	     
	     //确认兑换
	     $('#btn-confirm').on('click',function(){
	            
	            var type=$(this).data("type");
	            var giftId=$('#giftId').val();
	            var activity_id = $("#activity_id").val();

	            console.log(giftId);
	            
	            //单品兑换
	           if(type=='single'){ 
		           $.ajax({
			            type: "POST",
			            url: "${CONTEXT_PATH}/activity/seedExchangeProduct",
			            data: {'singleid':giftId,'activity_id':activity_id},
			            dataType: "json",
			            success: function(data){
			            	$('#exchange').modal('hide');
			            	console.log(data);
			            	if(data.success){
			            		//$('#exchange-succeed').modal('show');
			            		var historyp=[];
			            		$.each(data.seedProducts, function(index, obj) {
			            			console.log(obj);
			            		    var product_id=obj.product_id;
			            		    var product_num=1;
			            		    var pf_id=obj.product_f_id;
			            		    var real_price=obj.real_price;
			            		    var new_historyp={product_id:product_id,product_num:product_num,pf_id:pf_id,real_price:real_price};
			            		    historyp.push(new_historyp);
			            		});
			            		var d="D";
			            		var herf=encodeURI(JSON.stringify(historyp));
			            		var seedTypeList=encodeURI(JSON.stringify(data.seedTypeList));
			            		//$.cookie('seedInfo',historyp,{expires:15,path:'/'});
			            		window.location.href="${CONTEXT_PATH}/txOrder1?seedTypeList="+seedTypeList
			            				+"&exchangeId="+data.singleid+"&exchangeType="+d+"&proList="+herf;
			            	}else{
			            		$.dialog.alert(data.message);
			            	}
			            }
		        	});
	        	}else{
	        	//套餐兑换
	        		$.ajax({
			            type: "POST",
			            url: "${CONTEXT_PATH}/activity/seedExchangePackage",
			            data: {'packageid':giftId,'activity_id':activity_id},
			            dataType: "json",
			            success: function(data){
			                $('#exchange').modal('hide');
			                console.log(data);
			            	if(data.success){           		
			            		//$('#exchange-succeed').modal('show');
			            		var historyp=[];
			            		$.each(data.packageProducts, function(index, obj) {
			            			console.log(obj);
			            		    var product_id=obj.product_id;
			            		    var product_num=obj.amount;
			            		    var pf_id=obj.product_f_id;
			            		    var real_price=obj.real_price;
			            		    var new_historyp={product_id:product_id,product_num:product_num,pf_id:pf_id,real_price:real_price};
			            		    historyp.push(new_historyp);
			            		});
			            		var t="T";
			            		 var herf=encodeURI(JSON.stringify(historyp));
			            		var seedTypeList=encodeURI(JSON.stringify(data.seedTypeList)); 
			            		//console.log(seedTypeList);
			            		     window.location.href="${CONTEXT_PATH}/txOrder1?seedTypeList="+seedTypeList
			            		    		+"&proList="+herf+"&exchangeId="+data.packageid+"&exchangeType="+t; 
			            	}else{
			            		$.dialog.alert(data.message);
			            	}
			            }
		        	});	
	        	}
	     });     
	          
	     //拥有的种子		
		 var swiper = new Swiper('.swiper-container0', {
			    pagination : '.swiper-pagination0',
			    paginationClickable:true,
		        scrollbarHide: true,
		        slidesPerView: 4,
		        slidesPerGroup:4,
		        centeredSlides: false,
		        spaceBetween: 10,
		        grabCursor: true,
		        setWrapperSize :false,
		        breakpoints: { 
				    //当宽度小于等于320
				    320: {
				      slidesPerView: 4,
				      slidesPerGroup:4,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于376
				    375: { 
				      slidesPerView: 4,
				      slidesPerGroup:4,
				      spaceBetweenSlides: 10
				    },
				   //当宽度小于等于415
				    414: { 
				      slidesPerView: 4,
				      slidesPerGroup:4,
				      spaceBetweenSlides: 10
				    },
				     //当宽度小于等于415
				    480: { 
				      slidesPerView: 5,
				      slidesPerGroup:5,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于640
				    640: {
				      slidesPerView: 6,
				      slidesPerGroup:6,
				      spaceBetweenSlides: 20
			        }
			     }
		    });
		    //单品兑换		
		    var swiper1 = new Swiper('.swiper-container', {
			    pagination : '.swiper-pagination1',
			    paginationClickable:true,
		        scrollbarHide: true,
		        slidesPerView: 3,
		        slidesPerGroup:3,
		        centeredSlides: false,
		        spaceBetween: 10,
		        grabCursor: true,
		        setWrapperSize :false,
		        breakpoints: { 
				    //当宽度小于等于320
				    320: {
				      slidesPerView: 3,
				      slidesPerGroup:3,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于376
				    375: { 
				      slidesPerView: 3,
				      slidesPerGroup:3,
				      spaceBetweenSlides: 10
				    },
				   //当宽度小于等于415
				    414: { 
				      slidesPerView: 3,
				      slidesPerGroup:3,
				      spaceBetweenSlides: 10
				    },
				     //当宽度小于等于415
				    480: { 
				      slidesPerView: 4,
				      slidesPerGroup:4,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于640
				    640: {
				      slidesPerView: 5,
				      slidesPerGroup:5,
				      spaceBetweenSlides: 20
			        }
			     }
		    });
		    		       
			$(".recievePresent").css("left",(window.screen.width-300)/2+"px");
			
			//分享引导层
			$(".go-share").click(function(){
	 	 		$(".shade").css("display","block");
	 	 	});
	 	 	
	        $(document).on("touchmove",function(e) {
	            if($(".shade").css("display")==='block') {
	                e.preventDefault();
	            }
	        });
	        
	        $(".close_btn").click(function(){
	            $(".shade").css("display","none");
	        });
			
	      //发送Ajax去请求与路径相匹配的分享模板
			$.ajax({
			    type:'Get',
				url: "${CONTEXT_PATH}/share",
			    success: function(result){
			          if(result){	
			               var link='${app_domain}/activity/seedBuy';
			               var imgUrl=result.share.picture?'${app_domain}'+result.share.picture.replace("/weixin",""):
			               '${app_domain}/resource/image/logo/shuiguoshullogo.png';
			               var title=result.share.title;
			               var desc=result.share.content;
			               var shareData={
			                  title:title,
							  desc:desc,
							  link:link,
							  imgUrl:imgUrl,
							  success:function(){
							     //分享成功回调函数
								  getSeed(1);
							  },
							  cancel:function(){
							    //分享取消回调函数
							  }
			               };
			               
			               //微信分享js
						   wx.ready(function() {
							  var share=new wxShare(shareData);
							  share.bind();
						  });
			          }   
			    }			
			});
	        
	        
		});
		
		function back(){
	 		window.location.href="${CONTEXT_PATH}/main?index=0";
	 	}
	 	
		//分享后获取种子
	 	function getSeed(get_type){
	 		$.ajax({ 
				url: "${CONTEXT_PATH}/activity/getSeed", 
				data: {'count':$("#seedNum").val(),'type':get_type}, 
				success: function(data){
					if(data.seedCount>0){
						$("#share-succeed").modal();
						$("#share-succeed-msg").html("恭喜获得"+data.seedCount+"个"+data.seedType.seed_name);
						setTimeout(function(){
			        		window.location.href="${CONTEXT_PATH}/activity/seedBuy";
			        	},3000);
					}else{
						$.dialog.alert("已经领过啦！");
					}	
		      	}
			});
	 	}
    </script>
</body>
</html>