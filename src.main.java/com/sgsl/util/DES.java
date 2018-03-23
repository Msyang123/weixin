package com.sgsl.util;

import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.spec.AlgorithmParameterSpec;
import java.util.List;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.sgsl.utils.StringUtil;

/*import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;*/

public class DES {
	private final static String encoding = "UTF-8";
	// 向量
	private final static byte[] Keys = { 0x12, 0x34, 0x56, 0x78, (byte) 0x90, (byte) 0xAB, (byte) 0xCD, (byte) 0xEF };

	/*public static final String encrypt(String content, String secret) throws Exception {
		byte[] bytes = secret.getBytes(encoding);
		DESKeySpec keySpec = new DESKeySpec(bytes);
		AlgorithmParameterSpec iv = new IvParameterSpec(Keys);
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
		Key key = keyFactory.generateSecret(keySpec);
		Cipher enCipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
		enCipher.init(Cipher.ENCRYPT_MODE, key, iv);
		byte[] pasByte = enCipher.doFinal(content.getBytes(encoding));
		return new BASE64Encoder().encode(pasByte);
	}

	public static final String decrypt(String content, String secret) throws Exception {
		if(com.sgsl.util.StringUtil.isNotNull(content)&&!"NULL".equals(content)){
			byte[] bytes = secret.getBytes(encoding);
			DESKeySpec keySpec = new DESKeySpec(bytes);
			AlgorithmParameterSpec iv = new IvParameterSpec(Keys);
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			Key key = keyFactory.generateSecret(keySpec);
			Cipher deCipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
			deCipher.init(Cipher.DECRYPT_MODE, key, iv);
			byte[] data = new BASE64Decoder().decodeBuffer(content);
			byte[] pasByte = deCipher.doFinal(data);
			return new String(pasByte, encoding);
		}else{
			return "";
		}
	}*/
	
	/**
	 * 批量解密
	 * 
	 */
	/*public JSONObject getWord() {
		JSONObject result = new JSONObject();

		try {
			String secret = "12345679";
			List<UserPass1> ps = new UserPass1().findUserPass();
			for (UserPass1 p : ps) {
				p.set("new_pass", DES.decrypt(p.get("old_pass", ""), secret));

				Record record = new Record();
				//record.setColumns(model2map(p));
				Db.update("user_pass1", record);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("解密结束");
		result.put("result", "解密结束");
		return result;
	}*/
	/*public static void main(String[] args) throws Exception {
		String pwd = "199707";
		String secret = "12345679";
		String ciphertext = encrypt(pwd, secret);
		System.out.println(ciphertext);
		String expressly = decrypt(ciphertext, secret);
		System.out.println(expressly);
	}*/
}
