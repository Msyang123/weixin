<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-银行卡设置" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_card" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>银行卡设置</span>
		  </header>
		  
		  <section class="m-bankcard weui-cells weui-cells_form mt48">
		        <div class="card-bg"></div>
			    <div class="weui-cell">
			        <div class="weui-cell__hd"><label class="weui-label">持卡人</label></div>
			        <div class="weui-cell__bd text-right js-card-user">{{bankInfo.master_name}}</div>
			    </div>
			    
			    <div class="weui-cell">
			        <div class="weui-cell__hd"><label class="weui-label">银行卡号</label></div>
			        <div class="weui-cell__bd">
			            <input class="weui-input text-right" type="number" placeholder="请输入卡号"  
			            v-model="bankInfo.bank_card" id="card_num" name="bank_card"/>
			        </div>
			    </div>
			    
		       <div class="weui-cell">
			        <div class="weui-cell__hd"><label class="weui-label">开户行</label></div>
			        <div class="weui-cell__bd">
			            <input class="weui-input text-right" type="text" placeholder="请输入开户行" 
			             v-model="bankInfo.bank_deposit" id="card_count" name="bank_deposit"/>
			        </div>
			    </div>

	        	<div class="u-btn-confirm text-center">
		        	<button class="btn u-btn-brown2" @click="updateCard" v-if="bankInfo.bank_card==null">确认添加</button>
		        	<button class="btn u-btn-brown2" @click="updateCard" v-else>修改</button>
		        </div>
		  </section>

	</div>
	
	<script>
		$(function() {
			//实例化vue
			var data={
				bankInfo:${bankInfo},
			    master_id:${master_id}
		    };
		    
			var vm=new Vue({
				mixins:[backHistory,formatCurrency],
                el:"#my_card",
                data:data,
                computed:{

                },
                filters: {
                	
                },
                methods: {
                    updateCard:function(){
                        var _this=this;
                        if(!_this.checkParms()) return false;
                        
                    	//处理JFinal后台接收不到contentType为Json数据结构参数问题
                        var params = new URLSearchParams();
                        params.append('bank_card', _this.bankInfo.bank_card);
                        params.append('bank_deposit',_this.bankInfo.bank_deposit);
                        params.append('bank_user',_this.bankInfo.master_name);
                        params.append('master_id',_this.master_id);
                        //提交数据到后台
                        axios.post('${CONTEXT_PATH}/fruitMaster/updateCardInfo',params)
                        .then(function(response){
                     	   if(response.data.status){
                                $.dialog.alert("操作成功");
                            }else{
                         	   $.dialog.alert("操作失败，请重新尝试！");
                            }
                        })
                        .catch(function(error){
                             console.log(error);
                        });
                    },
                    checkParms:function(){
                    	var _this=this;
                    	
                        if(_this.bankInfo.bank_card==""){
                        	$.dialog.alert("请输入银行卡号");
                        	return false;
                        }  
                        
                        if(!common.luhmCheck(_this.bankInfo.bank_card.toString()))
                        {
                        	$.dialog.alert("请输入正确格式的银行卡号");
                        	return false;
                        }

                        if(_this.bankInfo.bank_deposit==""){
                        	$.dialog.alert("请输入开户行名称");
                        	return false;
                        }
                        
                        return true;
                    }
                }
		     });
		});
	</script>
</body>
</html>