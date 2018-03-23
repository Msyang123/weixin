package com.sgsl.util;

import java.math.BigDecimal;

/**
 * 果币按几率随机获取
 * 
 * @author leon
 *
 */
public class GiveGuobi {
	private double number = 0d;
	private BigDecimal gb1;
	private BigDecimal gb2;
	private BigDecimal gb3;
	private BigDecimal gb4;
	private BigDecimal gb5;
	private BigDecimal gb6;
	private BigDecimal gb7;

	public GiveGuobi(final String p1, final String p2, final String p3, final String p4) {
		this.gb1 = new BigDecimal(p1);
		this.gb2 = new BigDecimal(p2);
		this.gb3 = new BigDecimal(p3);
		this.gb4 = new BigDecimal(p4);
		if (this.gb1.add(gb2).add(gb3).add(gb4).intValue() != 1) {
			throw new RuntimeException("概率相加必须等于一！");
		}
	}
	/**
	 * 设置7个随机概率。五个概率相加必须等于一
	 * 
	 * @param p1 第一个概率
	 * @param p2 第二个概率
	 * @param p3 第三个概率
	 * @param p4 第四个概率
	 */
	public GiveGuobi(final String p1, final String p2, final String p3, final String p4, final String p5) {
		this.gb1 = new BigDecimal(p1);
		this.gb2 = new BigDecimal(p2);
		this.gb3 = new BigDecimal(p3);
		this.gb4 = new BigDecimal(p4);
		this.gb5 = new BigDecimal(p5);
		if (this.gb1.add(gb2).add(gb3).add(gb4).add(gb5).intValue() != 1) {
			throw new RuntimeException("概率相加必须等于一！");
		}
	}
	public GiveGuobi(final String p1, final String p2, final String p3, final String p4, final String p5, final String p6, final String p7) {
		this.gb1 = new BigDecimal(p1);
		this.gb2 = new BigDecimal(p2);
		this.gb3 = new BigDecimal(p3);
		this.gb4 = new BigDecimal(p4);
		this.gb5 = new BigDecimal(p5);
		this.gb6 = new BigDecimal(p6);
		this.gb7 = new BigDecimal(p7);
	}

	/**
	 * 获得一个
	 * 
	 * @return
	 */
	public int get() {
		this.number = Math.random();
		if (this.number >= 0 && this.number <= this.gb1.doubleValue()) {
			return 0;
		} else if (this.number >= this.gb1.doubleValue() && this.number <= this.gb1.add(this.gb2).doubleValue()) {
			return 1;
		} else if (this.number >= this.gb1.add(this.gb2).doubleValue()
				&& this.number <= this.gb1.add(this.gb2).add(this.gb3).doubleValue()) {
			return 2;
		} else if (this.number >= this.gb1.add(this.gb2).add(this.gb3).doubleValue()
				&& this.number <= this.gb1.add(this.gb2).add(this.gb3).add(this.gb4).doubleValue()) {
			return 3;
		}else if (this.number >= this.gb1.add(this.gb2).add(this.gb3).add(this.gb4).doubleValue()
				&& this.number <= this.gb1.add(this.gb2).add(this.gb3).add(this.gb4).add(this.gb5).doubleValue()) {
			return 4;
		}
		return -1;
	}
	/**
	 * 随机获取一个果币
	 */
	public double getBlanceByRandom(double min,double max){
		return new BigDecimal(min+Math.random()*(max-min))
				.setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
	}
	
	public static void main(String[] args) {
		/*GiveGuobi gf = new GiveGuobi("0.4","0.3", "0.2", "0.1");
		int size = 150;
		double[] c = {0,0,0,0,0};
		for (int i = 0; i < size; i++) {
			int fuwa = gf.get();
			double a = gf.getBlanceByRandom(0.88,2);
			System.out.println(a);
			c[fuwa] = a;
		}
		
		System.out.println("总数：" + (c[0] + c[1] + c[2] + c[3]+c[4]));*/
	}
}
