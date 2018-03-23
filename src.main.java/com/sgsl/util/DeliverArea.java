package com.sgsl.util;

public enum DeliverArea{
	AREA_0_1000(0, 1000),
	AREA_1000_2000(1000, 2000),
	AREA_2000_3000(2000, 3000),
	AREA_3000_4000(3000, 4000),
	AREA_4000_5000(4000, 5000)
	;
	private int min;
	private int max;
	private DeliverArea(int min, int max){
		this.min = min;
		this.max = max;
	}
	
	public static DeliverArea match(double distance){
		for(DeliverArea area: values()){
			if(distance > area.min && distance <= area.max){
				return area;
			}
		}
		return null;
	}
	
	public double reduceFee(double needPayFee, int[] minuends){
		if(values().length != minuends.length){
			throw new IllegalArgumentException("参数错误！");
		}
		return needPayFee - minuends[this.ordinal()];
	}
}
