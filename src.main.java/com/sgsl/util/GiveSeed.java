package com.sgsl.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.model.MActivity;
import com.sgsl.model.MInterval;
import com.sgsl.model.MSeedInstance;
import com.sgsl.model.MSeedType;
import com.sgsl.utils.DateFormatUtil;

/**
 * 送种子活动。随机获取
 * 
 * @author yijun
 *
 */
public class GiveSeed {

	/**
	 * 
	 * 
	 */
	public GiveSeed() {
	}

	/**
	 * 获得一个种子
	 * getType 获取种子来源类型1分享朋友圈 
	 * @return
	 */
	public Map get1(int activityId,int userId,int seedCount,int getType) {
		System.out.println("=========================="+activityId);
		Map seedTypeMap=new HashMap();
		seedTypeMap.put("state", 0);
		//取到种子类型
		MSeedType seedType=null;
		MActivity activity = MActivity.dao.findById(activityId);
		//购买赠送送神秘种子   暂时不赠送神秘种子
		if(getType==7||getType==8){
			//支付必须超过门槛金额才能赠送种子
			if(seedCount<activity.getInt("activity_money")/100){
				seedTypeMap.put("seedType", seedType);
				seedTypeMap.put("seedCount", 0);
				seedTypeMap.put("state", 1);
				return seedTypeMap;
			}
			
			//是否开启购物送
			if(activity.getStr("gm_send")!=null||!("".equals(activity.getStr("gm_send")))){
				JSONObject shop_send = JSONObject.parseObject(activity.getStr("gm_send"));
				if(shop_send.getString("isPurchase").equals("true")){
					if(shop_send.get("mode").equals("0")){
						//固定送
						seedTypeMap.put("seedType", GiveSeed.getSeedName(shop_send.getInteger("seedTypeId")));
						seedTypeMap.put("seedCount", shop_send.getInteger("seedNum"));
						//TODO MSeedInstance加种子条数
						GiveSeed.setSeedInstance(shop_send.getInteger("seedTypeId"), shop_send.getInteger("seedNum"), userId, getType,activityId);
						return seedTypeMap;
					}else{
						seedTypeMap.put("seedType", GiveSeed.getSeedName(shop_send.getInteger("seedTypeId")));
						//比例赠送计算公式如下 订单金额/门槛金额（相除结果向下取整）X赠送种子数量
						int activity_money=activity.getInt("activity_money")/100;
						int seedNum = seedCount/activity_money* Integer.parseInt((String) shop_send.get("seedNum"));
						seedTypeMap.put("seedCount", seedNum);
						GiveSeed.setSeedInstance(shop_send.getInteger("seedTypeId"), seedNum, userId, getType,activityId);
						return seedTypeMap;
					}
				}else{
					seedTypeMap.put("seedType", null);
					seedTypeMap.put("seedCount", 0);
					seedTypeMap.put("state", 0);
					return seedTypeMap;
				}
			}
			
		}else if(getType==1){//分享送种子
			if(activity.getStr("share_send")!=null||!("".equals(activity.getStr("share_send")))){
				JSONObject share_send = JSONObject.parseObject(activity.getStr("share_send"));
				if(share_send.getString("isShare").equals("true")){
					if(share_send.get("frequence").equals("0")){//该期活动只送一次
						List<MSeedInstance> seedInstances= MSeedInstance.dao.find("select * from m_seed_instance where user_id=? and get_type=1 and activity_id=? ",userId,activityId);
						if(seedInstances.size()>0){
							seedTypeMap.put("seedType", GiveSeed.getSeedName(share_send.getInteger("seedTypeId")));
							seedTypeMap.put("seedCount", 0);
							seedTypeMap.put("state", 2);
							return seedTypeMap;
						}
						
					}else{//每天送一次种子
						String currentDate =DateFormatUtil.format5(new Date());
						List<MSeedInstance> seedInstances= MSeedInstance.dao.find("select m.* from m_seed_instance m "
								+ "left join m_seed_type s on m.seed_type_id=s.id "
								+ "where user_id=? and m.get_type=1 and s.activity_id=? and m.get_time between '"+currentDate+" 00:00:00' "
								+ "and '"+currentDate+" 23:59:59' ",userId,activityId);
						if(seedInstances.size()>0){
							seedTypeMap.put("seedType", GiveSeed.getSeedName(share_send.getInteger("seedTypeId")));
							seedTypeMap.put("seedCount", 0);
							seedTypeMap.put("state", 5);
							return seedTypeMap;
						}
						
					}
					seedTypeMap.put("seedType", GiveSeed.getSeedName(share_send.getInteger("seedTypeId")));
					seedTypeMap.put("seedCount", share_send.getInteger("seedNum"));
					//TODO MSeedInstance加种子条数
					GiveSeed.setSeedInstance(share_send.getInteger("seedTypeId"), share_send.getInteger("seedNum"), userId, getType,activityId);
					return seedTypeMap;
				}
			}
			
		}else if(getType==6){
			/*//只查询现在还有实体种子的类型
			MInterval seedTotal=MInterval.dao.findFirst("select *from m_interval where activity_id=? and send_total>0", activityId);
			//没有种子可领取
			if(seedTotal==null&&seedTotal.getInt("send_total")<=0){
				seedTypeMap.put("seedType", seedType);
				seedTypeMap.put("seedCount", 0);
				seedTypeMap.put("state", 1);
				return seedTypeMap;
			}*/
			//查询在区间内的时间
			MInterval interval= MInterval.dao.findFirst("select * from  m_interval where activity_id=? and send_total>0 and status=1 and begin_time<date_format(now(),'%Y-%m-%d %H:%i:%s') and end_time>date_format(now(),'%Y-%m-%d %H:%i:%s') ",activityId);
			if(interval==null){
				seedTypeMap.put("seedType", seedType);
				seedTypeMap.put("seedCount", 0);
				seedTypeMap.put("state", 3);
				return seedTypeMap;
			}
			//点击领取6
			List<MSeedInstance> seedInstances= MSeedInstance.dao.find("select * from m_seed_instance where user_id=? and get_type=6 and ?<get_time and ?>get_time",
					userId,interval.getStr("begin_time"),interval.getStr("end_time"));
			//是否在活动时间段内且已经领取过
			if(seedInstances.size()>0){
				seedTypeMap.put("seedType", seedType);
				seedTypeMap.put("seedCount", 0);
				seedTypeMap.put("state", 4);
				return seedTypeMap;
			}
			
			if(interval.get("send_percent")!=null || !("".equals(interval.get("send_percent")))){
				JSONArray send_percents = JSONArray.parseArray(interval.getStr("send_percent"));           
				//存储每个种子类型新的概率区间
				List<Double> proSection = new ArrayList<Double>();
				proSection.add(0d);
				double number = 0f;//随机概率数值
				for(int i=0; send_percents.size()>i;i++){
					String a = (String) send_percents.getJSONObject(i).get("percent");
					double d=Double.valueOf(a).doubleValue();
					number+=d;
					proSection.add(number);
				}
				
				//获取总的概率区间中的随机数
				Random random = new Random();
				Random r=new Random();// 定义随机类
				double randomPro = random.nextDouble();
				//判断取到的随机数在哪个种子的概率区间中
				for (int i = 0,size = proSection.size(); i < size; i++) {
					if(randomPro >= proSection.get(i) 
							&& randomPro < proSection.get(i + 1)){
						System.out.println(send_percents.get(i).toString());
						int seedType1 = send_percents.getJSONObject(i).getInteger("seedType");
						seedTypeMap.put("seedType", GiveSeed.getSeedName(seedType1));
						if(interval.getInt("send_type")==0){//固定领取
							seedTypeMap.put("seedCount", interval.getInt("max_num"));
							GiveSeed.setSeedInstance(seedType1, interval.getInt("max_num"), userId, getType,activityId);
							interval.set("send_total", interval.getInt("send_total")-interval.getInt("max_num"));//种子发放总量减去领取数
							interval.update();
						}else{//随机领取
							int seedNum=r.nextInt(interval.getInt("max_num"))+1;
							seedTypeMap.put("seedCount", seedNum);//排除0
							GiveSeed.setSeedInstance(seedType1, seedNum, userId, getType,activityId);
							interval.set("send_total", interval.getInt("send_total")-seedNum);//种子发放总量减去领取数
							interval.update();
						}
						return seedTypeMap;
					}
				}
				
			}
		}
		
		
		return seedTypeMap;
	}
	
	public static Map getSeedName(int typeId){
		Map<String,Object> mSeedType = new HashMap<String, Object>();
		Record seed = Db.findFirst("select m.*,t.save_string from m_seed_type m left join t_image t on m.image_id=t.id where  m.id=?", typeId);
		mSeedType.put("seed_name", seed.getStr("seed_name"));
		mSeedType.put("save_string", seed.getStr("save_string"));
		return mSeedType;
	}
	
	//添加种子
	public static void setSeedInstance(int type,int seedNum,int user_id,int getType,int activity_id){
		String currentTime=DateFormatUtil.format1(new Date());
		MSeedInstance seedInstance = new MSeedInstance();
		for(int i=0;seedNum>i;i++){
			seedInstance.set("status", 1);
			seedInstance.set("user_id", user_id);
			seedInstance.set("get_time", currentTime);
			//获取来源 分享朋友圈1 分享朋友2 分享微博3 分享qq 4分享qq空间5 点击领取6 购买送7
			seedInstance.set("get_type", getType);
			seedInstance.set("seed_type_id", type);
			seedInstance.set("activity_id", activity_id);
			seedInstance.save();
			seedInstance.remove("id");
		}
	}
	
	public static void main(String[] args) {
		/*GiveFuwa gf = new GiveFuwa("0.4", "0.41", "0.1", "0.09");
		int size = 99;
		int[] c = {0,0,0,0};
		for (int i = 0; i < size; i++) {
			int fuwa = gf.get();
			c[fuwa] = c[fuwa] + 1;
			try {
				Thread.sleep(200);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		for (int i = 0; i < c.length; i++) {
			System.out.println(c[i]);
		}
		System.out.println("总数：" + (c[0] + c[1] + c[2] + c[3]));*/
		 //存储每个奖品新的概率区间
       /* List<Double> proSection = new ArrayList<Double>();
        proSection.add(0d);
		String b = "[{'seedType':'4','seedNum':'0.60'},{'seedType':'3','seedNum':'0.30'},{'seedType':'1','seedNum':'0.10'}]";
		JSONArray send_percents = JSONArray.parseArray(b);
		double number = 0f;//随机概率数值
		for(int i=0; send_percents.size()>i;i++){
			String a = (String) send_percents.getJSONObject(i).get("seedNum");
			double d=Double.valueOf(a).doubleValue();
			number+=d;
			proSection.add(number);
		}
		
		  //获取总的概率区间中的随机数
        Random random = new Random();
        double randomPro = random.nextDouble();
        //判断取到的随机数在哪个奖品的概率区间中
        for (int i = 0,size = proSection.size(); i < size; i++) {
            if(randomPro >= proSection.get(i) 
                && randomPro < proSection.get(i + 1)){
                System.out.println(send_percents.get(i).toString());
            }
        }*/
		//System.out.println(b[num]); 
    		String currentTime=DateFormatUtil.format1(new Date());
    		MSeedInstance seedInstance = new MSeedInstance();
    		int hung=100;
    		for(int i=0;hung>i;i++){
    			seedInstance.set("status", 1);
    			seedInstance.set("user_id", 12944);
    			seedInstance.set("get_time", currentTime);
    			//获取来源 分享朋友圈1 分享朋友2 分享微博3 分享qq 4分享qq空间5 点击领取6 购买送7
    			seedInstance.set("get_type", 7);
    			seedInstance.set("seed_type_id", 1);
    			seedInstance.set("activity_id", 22);
    			seedInstance.save();
    			seedInstance.remove("id");
    		}
    	}
}
