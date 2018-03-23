package com.xgs.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;

public class XArticle extends Model<XArticle> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static final XArticle dao = new XArticle();

	/**
	 * 模糊查询鲜果师文章
	 */
	public Page<XArticle> findMasterArticleByContent(String content,int pageNumber,int pageSize) {
		String select = "select * ";
		String sqlExceptSelect = "from x_article where status = 0 and (article_content like '%" + content
				+ "%' or title like '%" + content + "%')";
		return dao.paginate(pageNumber, pageSize, select, sqlExceptSelect);
	}

	/**
	 * 根据文章编号查询鲜果师文章详情
	 */
	public XArticle findMasterArctileById(int article_id) {

		// return dao.findFirst("select a.*,p.*,pf.*,u.unit_name from x_article
		// a "
		// + "LEFT JOIN x_rele_products rp on a.id = rp.article_id "
		// + "LEFT JOIN t_product p on rp.format_id = p.id LEFT JOIN t_product_f
		// pf on p.id = pf.product_id "
		// + "LEFT JOIN t_unit u on pf.product_unit = u.unit_code LEFT JOIN
		// t_image i on p.img_id = i.img_id "
		// + "where p.product_status = '01' and p.fresh_format = '0' and a.id =
		// ?", article_id);
		return dao.findFirst("select * from x_article where id = ?", article_id);
	}

	/** =========食鲜========= */
	public Page<XArticle> findArticlesByCategoryId(String category_name, int pageSize, int pageNum) {
		String sql = "select a.*,ac.category_name ";
		String condition = " from x_article a left join x_article_category ac on a.category_id=ac.id where status=0 and file_type='0' and ac.category_name = '"
				+ category_name + "'  order by a.create_time desc";
		return dao.paginate(pageNum, pageSize, sql, condition);
	}
	
	/**============鲜果师管理后台=========*/
	/** ========文章列表========== */
	public Page<XArticle> findXArticleList(int pageNumber, int pageSize, String article_categroy, int status,String articleName) {
		String select = "select a.id,a.category_id,a.title,a.contribution_penson,a.edit_penson,a.create_time,a.status,a.url,ac.category_name,a.recommend_product_name ";
		String sqlExceptSelect="";
		if(status!=3){
			sqlExceptSelect = " from x_article a left join x_article_category ac on a.category_id = ac.id where a.status=" + status+" and a.file_type=0";
		}else{
			sqlExceptSelect = " from x_article a left join x_article_category ac on a.category_id = ac.id where a.status=0 or a.status=1 and a.file_type=0";
		}
		
		if (article_categroy != "") {
			sqlExceptSelect += " and ac.category_name like '%"
					+ article_categroy + "%' and a.status=" + status +" and a.file_type=0";
		} 
		if(articleName != ""){
			sqlExceptSelect += " and title like '%"+articleName+"%' " +" and a.file_type=0";
		}
		return dao.paginate(pageNumber, pageSize, select, sqlExceptSelect);
	}
	
	/**
	 * 添加文章
	 * @param record
	 * @return
	 */
	public boolean addXArticle(Record record){
		boolean flag = Db.save("x_article", record);
		return flag;
	}
}
