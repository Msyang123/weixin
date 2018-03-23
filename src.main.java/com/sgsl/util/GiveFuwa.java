package com.sgsl.util;

import java.math.BigDecimal;

/**
 * 送福娃活动。四个福娃，按几率随机获取
 * 
 * @author leon
 *
 */
public class GiveFuwa {
	private double number = 0d;
	private BigDecimal fw1;
	private BigDecimal fw2;
	private BigDecimal fw3;
	private BigDecimal fw4;

	/**
	 * 设置四个福娃随机概率。四个概率相加必须等于一
	 * 
	 * @param p1 第一个福娃概率
	 * @param p2 第二个福娃概率
	 * @param p3 第三个福娃概率
	 * @param p4 第四个福娃概率
	 */
	public GiveFuwa(final String p1, final String p2, final String p3, final String p4) {
		this.fw1 = new BigDecimal(p1);
		this.fw2 = new BigDecimal(p2);
		this.fw3 = new BigDecimal(p3);
		this.fw4 = new BigDecimal(p4);
		if (this.fw1.add(fw2).add(fw3).add(fw4).intValue() != 1) {
			throw new RuntimeException("四个福娃概率相加必须等于一！");
		}
	}

	/**
	 * 获得一个福娃
	 * 
	 * @return
	 */
	public int get() {
		this.number = Math.random();
		if (this.number >= 0 && this.number <= this.fw1.doubleValue()) {
			return 0;
		} else if (this.number >= this.fw1.doubleValue() && this.number <= this.fw1.add(this.fw2).doubleValue()) {
			return 1;
		} else if (this.number >= this.fw1.add(this.fw2).doubleValue()
				&& this.number <= this.fw1.add(this.fw2).add(this.fw3).doubleValue()) {
			return 2;
		} else if (this.number >= this.fw1.add(this.fw2).add(this.fw3).doubleValue()
				&& this.number <= this.fw1.add(this.fw2).add(this.fw3).add(this.fw4).doubleValue()) {
			return 3;
		}
		return -1;
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
		for(int i=0;i<20;i++){
			System.out.println((int)(Math.random()*10));
		}
	}
}
