<!DOCTYPE html>
<html>
<head>
<title>美味食鲜</title>
<meta charset="utf-8" />
<base href="${CONTEXT_PATH}/" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no" />
<meta name="description" content="美味食鲜-收入与结算" />
<#include "/WEB-INF/pages/common/_layout_mobile_master.ftl"/>
</head>
<body class="bg-grey-light">

	<div id="my_salary" class="wrapper">
	
		  <header class="g-hd bg-white">
				<div class="u-btn-back">
					<a href="javascript:void(0);" @click="back">
					<img height="20px" src="resource/image/icon/icon-back.png" /></a>
				</div>
				<span>收入与结算</span>
		  </header>
		  
		  <section class="m-salary row justify-content-between no-gutters mt48"  v-cloak>
		       <div class="col-6">
		            <h3>已获得红利</h3>
		            <h5>（已完成的交易）</h5>
		            <h2 class="profit">&yen; {{salaryInfo.bonus_total | formatCurrency}}</h2>
		       </div>
		       <div class="col-6 pr15 text-right">
		            <h4>可结算金额：<span class="amount">&yen; {{salaryInfo.bonus | formatCurrency}}</span></h4>
		            
		            <button v-if="salaryInfo.button_flag!=0" 
		            class="btn bnt-sm u-btn-brown" 
		            data-toggle="modal" 
		            data-target="#withdraw_salary" 
		            type="button">结算</button>
		            <button v-else class="btn bnt-sm u-btn-brown disabled" disabled="disabled" type="button">结算</button>
		       </div>
		  </section>
		  
		  <section class="m-card-top"  v-cloak>
		        <div class="row justify-content-between no-gutters align-items-center">
		           <div class="col-6">历史总收入</div>
		           <div class="col-6 text-right pr15 num">&yen; {{salaryInfo.all_money | formatCurrency}}</div>
		        </div>
		        <div class="row justify-content-between no-gutters align-items-center">
		           <div class="col-6">已结算总额</div>
		           <div class="col-6 text-right pr15 num">&yen; {{salaryInfo.gotMoney | formatCurrency}}</div>
		        </div>
		        <div class="row justify-content-between no-gutters align-items-center">
		           <div class="col-6">正在结算</div>
		           <div class="col-6 text-right pr15 num">&yen; {{salaryInfo.gettingMoney | formatCurrency}}</div>
		        </div>
		  </section>
		  
		  <section class="m-card-bottom">
		        <div class="row justify-content-between no-gutters align-items-center" @click="goBankSetting">
		           <div class="col-6">我的银行卡</div>
		           <div class="col-6 text-right pr15">
			           <span class="tip" v-if="salaryInfo.bank_setting==1">已设置</span>
			           <img height="20px" src="resource/image/icon-master/icon_more_single.png" />
		           </div>
		        </div>
		        <div class="row justify-content-between no-gutters align-items-center" @click="goSalaryRecord">
		           <div class="col-6">收支明细</div>
		           <div class="col-6 text-right pr15">
		             <img height="20px" src="resource/image/icon-master/icon_more_single.png" />
		           </div>
		        </div>
		  </section>
		  
		  <section class="m-rules">
		        <h4>结算规则：</h4>
		        <ol>
					<li>当月可结算金额=剩余可结算金额+上月订单提成+上月下级鲜果师红利</li>
					<li>每月15~17日可进行结算</li>
					<li>申请结算后，结算部分金额会从可结算金额扣除，并在1~3个工作日内汇入鲜果师指定账户内</li>
					<li>请确保银行卡的正确性，若因银行卡错误导致结算出现问题，由鲜果师本人承担后果</li>
				</ol>		
		  </section>
		  
		  <div class="modal fade" id="withdraw_salary" tabindex="-1" role="dialog" aria-hidden="true">
		      <div class="modal-dialog">
		   		<div class="modal-content">
		         	<div class="modal-body">	
			           	<h4>请输入结算金额</h4>
			           	<input v-model="money" autofocus autocomplete="off" class="u-money form-control" type="number"/>
			           	<div class="text-center">
				        	<button class="btn bnt-sm u-btn-brown" @click="widthraw($event)">确认</button>
				        </div>
		         	</div>
		          </div>
		      </div>
	      </div>
	</div>

	<script>
		$(function() {
			var date = new Array();
			var vm=new Vue({
				mixins:[backHistory,formatCurrency],
                el:"#my_salary",
                data:{
    			    salaryInfo:${salaryInfo},
                    money:0
    		    },
                created:function(){
                     this.money=common.formatCurrency(this.salaryInfo.bonus);         
                },
                methods: {
                    goBankSetting:function(){
                        window.location.href="${CONTEXT_PATH}/fruitMaster/myCard?master_id="+this.salaryInfo.master_id;
                    },
                    goSalaryRecord:function(){
                    	window.location.href="${CONTEXT_PATH}/fruitMaster/inOutDetail?inout_type=1&pageNumber=1&pageSize=5&master_id="+this.salaryInfo.master_id;
                    },
                    widthraw:function(e){
                    	date.push(new Date());
        				if (date.length > 1 && (date[date.length - 1].getTime() - date[date.length - 2].getTime() < 800)){
        					e.cancelBubble = true;
        					return false;
        				}
                       //点击结算按钮向后台发送请求
                       var _this=this;
                       _this.salaryInfo.button_flag=0;
                       //处理JFinal后台接收不到contentType为Json数据结构参数问题
                       var params = new URLSearchParams();
                       params.append('master_id', _this.salaryInfo.master_id);
                       params.append('apply_money',_this.money);
                       console.log(_this.money);
                       //提交数据到后台
                       axios.post('${CONTEXT_PATH}/fruitMaster/applyMoney',params)
                       .then(function(response){
                           $('#withdraw_salary').modal('hide');
                          
                           $.dialog.alert(response.data.msg);
                    	   if(response.data.result=="success"){
                               _this.salaryInfo.bonus=parseFloat(_this.salaryInfo.bonus-_this.money*100);
                               _this.salaryInfo.gettingMoney=parseFloat(_this.salaryInfo.gettingMoney+_this.money*100);
                               _this.salaryInfo.bonus_total=parseFloat(_this.salaryInfo.bonus_total-_this.money*100);
                               console.log('bonus:'+_this.salaryInfo.bonus+'\r\n'+_this.salaryInfo.gettingMoney+'\r\n'+_this.salaryInfo.bonus_total);
                           }
                    	   _this.salaryInfo.button_flag=response.data.button_flag;
                       })
                       .catch(function(error){
                            console.log(error);
                       });
                    }
                }
		     });
		});
	</script>
</body>
</html>