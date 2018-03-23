package com.sgsl.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.util.StringUtil;

/**
 * Created by yj on 2014/7/28. 微网站订单信息
 */
public class TPresent extends Model<TPresent> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public static final TPresent dao = new TPresent();
	
	private List<Record> presentProducts;//订单中的商品
	private int totalProduct;//订单中商品总数统计
	
	public int getTotalProduct() {
		return totalProduct;
	}
	public void setTotalProduct(int totalProduct) {
		this.totalProduct = totalProduct;
	}
	public List<Record> getPresentProducts() {
		return presentProducts;
	}
	public void setPresentProducts(List<Record> presentProducts) {
		this.presentProducts = presentProducts;
	}
	
	public Record findTPresentById(int presentId,int user){
		String sql = "";
		sql += "select a.*,"
				+ "CASE a.present_status "
				+ "when '1' then '待付款' "
				+ "when '2' then '支付中' "
				+ "when '3' then '已支付' "
				+ "when '4' then '已接收' "
				+ "when '0' then '已失效' end as status_cn,b.nickname,b.phone_num "
				+ "from t_present a "
				+ "left join t_user b on a.target_user=b.id "
				+ "where a.present_status='1' and a.id=? and a.present_user=?";
		return Db.findFirst(sql, presentId,user);
	}
	
	public Record findTPresentDetail(int presentId,int user,String type){
		String sql="select a.*,"+ "CASE a.present_status "
				+ "when '1' then '待付款' "
				+ "when '2' then '支付中' "
				+ "when '3' then '已支付' "
				+ "when '4' then '已接收' "
				+ "when '0' then '已失效' end as status_cn ,concat(b.nickname,'(',IFNULL(b.phone_num,''),')') as present_username "
				+ "from t_present a left join t_user b ";
		if(type.equals("source")){
			sql += "on a.target_user=b.id ";
			sql += "where a.id=? and a.present_user=? ";
		}else{
			sql += "on a.present_user=b.id ";
			sql += "where a.id=? and a.target_user=? and present_status='4'";
		}
		return Db.findFirst(sql, presentId,user);
	}
	
	public List<Record> findPresentProList(int presentId){
		String sql = "";
		sql += "select a.*,(select unit_name from t_unit  where unit_code = c.base_unit) as base_unit ,b.price,ifnull(b.special_price,b.price) as real_price,b.product_amount,c.product_name,d.save_string,u.unit_name from t_present_products a "
				+ "left join t_product_f b on a.pf_id = b.id "
				+ "left join t_product c on b.product_id = c.id "
				+ "left join t_image d on c.img_id = d.id "
				+ "left join t_unit u on b.product_unit = u.unit_code "
				+ "where a.present_id=?";
		return Db.find(sql,presentId);
	}
	
	public List<Record> findProList(int presentId){
		String sql = "select a.*,b.product_id from t_present_products a "
				+ "left join t_product_f b on a.pf_id=b.id where present_id=?";
		return Db.find(sql,presentId);
	}
	
	/**
	 * 根据状态查询赠送订单
	 * @param userId
	 * @return
	 */
	public List<Record> findTPresentsByUserId(int userId,String user_type) {
		String sql="select a.*,concat(b.nickname,'(',IFNULL(b.phone_num,''),')') as present_username from t_present a left join t_user b ";
		if(user_type.equals("source")){
			sql += "on a.target_user=b.id ";
			sql += "where a.present_user=? ";
		}else{
			sql += "on a.present_user=b.id ";
			sql += "where a.target_user=? and present_status>='3'";
		}
		sql += "order by present_time desc";
		List<Record> presents=Db.find(sql, userId);
		for(Record present:presents){
			int presentId = present.getInt("id");
			List<Record> presentProducts=Db.find("select op.*,p.*,i.save_string,u.unit_name as base_unitname from t_present_products op "+
					"left join t_product_f pf on pf.id=op.pf_id "+
					"left join t_product p on pf.product_id=p.id "+
					"left join t_unit u on p.base_unit=u.unit_code "+
					"left join t_image i on p.img_id=i.id where op.present_id=? ", presentId);
			present.set("presentProducts",presentProducts);;
			//统计当前订单中
			present.set("totalProduct",presentProducts.size());
		}
		return presents;
	}
	
	public int cancelPresent(int presentId,int user){
		String sql = "update t_present set present_status = '0' where id=? and present_user=?";
		return Db.update(sql, presentId,user);
	}
	
	public int recievePresent(int presentId,int user){
		String sql = "update t_present set present_status = '4' where id=? and target_user=? and present_status='3'";
		return Db.update(sql, presentId,user);
	}
	
	public Record findMyPresentCount(int user){
		String sql = "select count(1) as present_count from t_present "
				+ "where present_status='3' and target_user=?";
		return Db.findFirst(sql, user);
	}
	public Record findTUnpayPresentTotal(int userId){
		return Db.findFirst("select count(*) as present_count from t_present where present_status in('1','2') and present_user=? ", userId);
	}
	
	public Page<Record> presentList(int presentStatus,String  presentDateBegin, String presentDateEnd,
									int pageSize,
									int page,
									String sidx,
									String sord){
		Page<Record> pageInfo=null;
		//全部
		if(StringUtil.isNull(sidx)){
            pageInfo= Db.paginate(page,pageSize,
            	"select (select nickname from t_user where id=t.present_user) present_user,(select nickname from t_user where id=t.target_user) target_user,present_time,present_status,need_pay,present_msg,discount"	,
        				" from t_present t "+
						" where  t.present_time between '"+presentDateBegin+"' and '"+presentDateEnd+"' "+
						(presentStatus>-1?" and t.present_status ="+presentStatus:"")+
        				" order by t.present_time desc");
		}else{
			pageInfo= Db.paginate(page,pageSize,
	            	"select (select nickname from t_user where id=t.present_user) present_user,(select nickname from t_user where id=t.target_user) target_user,present_time,present_status,need_pay,present_msg,discount"	,
	        				" from t_present t "+
							" where  t.present_time between '"+presentDateBegin+"' and '"+presentDateEnd+"' "+
							(presentStatus>-1?" and t.present_status ="+presentStatus:"")+
							" order by "+sidx+" "+sord);
		}
		return pageInfo;
	}
	
}