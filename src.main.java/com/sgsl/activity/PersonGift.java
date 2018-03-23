package com.sgsl.activity;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.AFuwa;
import com.sgsl.model.AFwGet;
import com.sgsl.model.AUserFw;
import com.sgsl.model.TBlanceRecord;
import com.sgsl.model.TGiftProduct;
import com.sgsl.model.TOrder;
import com.sgsl.model.TPresent;
import com.sgsl.model.TStock;
import com.sgsl.model.TUser;
import com.sgsl.model.TUserWhite;
import com.sgsl.model.TWhiteGift;
import com.sgsl.util.GiveFuwa;
import com.sgsl.util.GiveGuobi;
import com.sgsl.util.StringUtil;
import com.sgsl.utils.DateFormatUtil;
import com.sgsl.wechat.UserStoreUtil;

public class PersonGift {
	/**
	 * 前台页面展示代码
	 * <!-- 内部水果礼包
		<#if isWhite??>
		<div class="recievePresent" id="recievePresent" >
			<div style="position:absolute;right:0px;width:25px;height:25px;">
				<img id="closeGift" style="width:100%;"  src="resource/image/huodong/personGift/关闭.png">
			</div>
			<div id="fdImg" style="width:100%;height:100%;">
				<img style="width:100%;"  src="resource/image/huodong/personGift/福袋.jpg">
			</div>
			<div id="giftDiv" style="width:100%;height:100%;display:none;background-color:white;font-size:14px;">
				<img id="giftImg" style="width:120px;height:120px;margin-top:50px;" ><br/>
				恭喜您获得  <span id="giftProName" style="color:#de374e;"></span>  <span id="giftProAmount" style="color:#de374e;"></span><br/>
				<button data-inline="true" data-mini="true" id="goStorage" style="height:30px;">去仓库查看</button>
			</div>
			
		</div>
		<div class="mask"></div>
		<script type="text/javascript">
		$(function(){
			$(".recievePresent").css("left",(window.screen.width-300)/2+"px");
			$("#fdImg").bind("click",function(){
				$.ajax({
		            type: "POST",
		            url: "${CONTEXT_PATH}/personGift",
		            data: {},
		            dataType: "json",
		            success: function(data){
		           		if(data.status=="success"){
		           			$("#giftImg").attr("src",data.giftProduct.save_string);
		    				$("#giftProName").html(data.giftProduct.product_name);
		    				$("#giftProAmount").html(data.giftProduct.total_amount+""+data.giftProduct.unit_name);
		    				$("#fdImg").hide();
		    				$("#giftDiv").show();
		           		}else{
		           			alert(data.msg);
		           		}
		           }
		       });
			});
			
			$("#closeGift").bind("click",function(){
				$("#recievePresent").hide();
				$(".mask").hide();
			});
			
			$("#goStorage").bind("click",function(){
				window.location.href="${CONTEXT_PATH}/myStorage";
			});
		});
		</script>
		</#if> -->
	 * @param req
	 * 内部员工水果礼包
	 */
	public Map<String,Object> personGift(HttpServletRequest req){
		Map<String,Object> result =new HashMap<String,Object>();
		TUser tUserSession = UserStoreUtil.get(req);
		int userId= tUserSession.get("id");
		Record isWhite = new TUserWhite().isWhite(userId, 15);
		if(isWhite==null){
			result.put("status","failed");
			result.put("msg", "您已经领取过礼品了！");
		}else{
			String sql = "select a.id,a.product_f_id,a.remain_num,a.product_f_amount*b.product_amount as total_amount,b.product_amount,c.id as pro_id,ifnull(b.special_price,b.price) as real_price,c.product_name,u.unit_name,i.save_string "
					+"from t_gift_product a left join t_product_f b on a.product_f_id=b.id left join t_product c on b.product_id=c.id "
					+"left join t_unit u on c.base_unit = u.unit_code "
					+"left join t_image i on c.img_id=i.id "
					+"where a.remain_num>0";
			List<Record> giftList = Db.find(sql);
			Random random = new Random();
			Record gift = giftList.get(random.nextInt(giftList.size()));
			result.put("giftProduct",gift);
			TStock stock = new TStock().getStockByUser(userId);
			int stockId = stock.getInt("id");
			Record stockProduct = new Record();
			stockProduct.set("stock_id", stockId);
			stockProduct.set("product_f_id", gift.get("product_f_id"));
			stockProduct.set("product_id", gift.get("pro_id"));
			stockProduct.set("unit_price", gift.getInt("real_price")/gift.getDouble("product_amount"));
			stockProduct.set("amount", gift.getDouble("total_amount"));
			stockProduct.set("get_time", DateFormatUtil.format1(new Date()));
			Db.save("t_stock_product", stockProduct);
			TGiftProduct giftProduct = new TGiftProduct();
			giftProduct.set("id", gift.get("id"));
			giftProduct.set("remain_num", gift.getInt("remain_num")-1);
			giftProduct.update();
			TWhiteGift whiteGift =new TWhiteGift();
			whiteGift.set("user_id", userId);
			whiteGift.set("activity_id", 15);
			whiteGift.set("gift_type", "1");
			whiteGift.set("gift_no", gift.get("product_f_id"));
			whiteGift.set("gift_amount", gift.getDouble("total_amount"));
			whiteGift.set("get_time", DateFormatUtil.format1(new Date()));
			whiteGift.save();
			result.put("status","success");
		}
		return result;
	}
}
