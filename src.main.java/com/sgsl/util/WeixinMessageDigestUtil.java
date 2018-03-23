package com.sgsl.util;

import java.security.MessageDigest;
import java.util.Arrays;

public final class WeixinMessageDigestUtil {
	private static final WeixinMessageDigestUtil _instance = new WeixinMessageDigestUtil();
	private MessageDigest alga;

	private WeixinMessageDigestUtil() {
		try {
			this.alga = MessageDigest.getInstance("SHA-1");
		} catch (Exception e) {
			throw new InternalError("init MessageDigest error:" + e.getMessage());
		}
	}

	public static WeixinMessageDigestUtil getInstance() {
		return _instance;
	}

	public static String byte2hex(byte[] b) {
		String des = "";
		String tmp = null;
		for (int i = 0; i < b.length; i++) {
			tmp = Integer.toHexString(b[i] & 0xFF);
			if (tmp.length() == 1) {
				des = des + "0";
			}
			des = des + tmp;
		}
		return des;
	}

	public String encipher(String strSrc) {
		String strDes = null;
		byte[] bt = strSrc.getBytes();
		this.alga.update(bt);
		strDes = byte2hex(this.alga.digest());
		return strDes;
	}

	public static void main(String[] args) {
		String signature = "b7982f21e7f18f640149be5784df8d377877ebf9";
		String timestamp = "1365760417";
		String nonce = "1365691777";
		String[] ArrTmp = { "token", timestamp, nonce };
		Arrays.sort(ArrTmp);
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < ArrTmp.length; i++) {
			sb.append(ArrTmp[i]);
		}
		String pwd = getInstance().encipher(sb.toString());
		if (signature.equals(pwd))
			System.out.println("token 验证成功~!");
		else
			System.out.println("token 验证失败~!");
	}
}