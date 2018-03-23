package com.sgsl.util;

public class MapsUtil {
	static double DEF_PI = 3.14159265359D;
	static double DEF_2PI = 6.28318530712D;
	static double DEF_PI180 = 0.01745329252D;
	static double DEF_R = 6370693.5D;

	public double GetAreaPostion(double GpsCoordinate) {
		double nDegree = GpsCoordinate / 1000000.0D * 1000000.0D;

		int nSecond = (int) (1.0E-006D * (GpsCoordinate - nDegree) * 3600.0D);

		return nDegree + nSecond;
	}

	public double GetShortDistance(double lon1, double lat1, double lon2, double lat2) {
		double ew1 = lon1 * DEF_PI180;
		double ns1 = lat1 * DEF_PI180;
		double ew2 = lon2 * DEF_PI180;
		double ns2 = lat2 * DEF_PI180;

		double dew = ew1 - ew2;

		if (dew > DEF_PI)
			dew = DEF_2PI - dew;
		else if (dew < -DEF_PI)
			dew = DEF_2PI + dew;
		double dx = DEF_R * Math.cos(ns1) * dew;
		double dy = DEF_R * (ns1 - ns2);

		double distance = Math.sqrt(dx * dx + dy * dy);
		return distance;
	}
}