package com.sgsl.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.http.Consts;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;
import org.springframework.core.io.FileSystemResource;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
/*import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;*/

import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonObject;

public class FileUpload {
	
	//上传到文件服务器
/*    public String postFile(File file,String url) throws ClientProtocolException, IOException {  
    	  
        FileBody bin = null;  
        HttpClient httpclient = new DefaultHttpClient();  
        HttpPost httppost = new HttpPost(url);  
        if(file != null) {  
            bin = new FileBody(file);  
        }
  
        MultipartEntity reqEntity = new MultipartEntity();  
        reqEntity.addPart("file", bin);  
          
        httppost.setEntity(reqEntity);  
        HttpResponse response = httpclient.execute(httppost);  
        HttpEntity resEntity = response.getEntity(); 
        
        StringBuffer sb=new StringBuffer();
        if (resEntity != null) {  
          InputStream in = resEntity.getContent();  
          byte[] inCont=new byte[1000];
          int re=0;
          while((re=in.read(inCont))!=-1){
          	sb.append(new String(inCont));
          }
        } 
        //关闭连接
        httppost.releaseConnection();
        httpclient.getConnectionManager().shutdown();
        
        return sb.toString();  
    } */
	
    public String postFile(File file,String url) throws IOException {  
  	  
        FileBody bin = null;  
        MultipartEntity reqEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE, null, Charset.forName("UTF-8"));
        HttpClient httpclient = new DefaultHttpClient();  
        HttpPost httppost = new HttpPost(url);  
        if(file != null) {  
            bin = new FileBody(file);  
        }
  
       // MultipartEntity reqEntity = new MultipartEntity();  
        StringBody sbody = new StringBody("text",ContentType.create("text/plain", Consts.UTF_8));
        reqEntity.addPart("file", bin);  
        reqEntity.addPart("text", sbody);
          
        httppost.setEntity(reqEntity);  
        HttpResponse response = httpclient.execute(httppost);  
        HttpEntity resEntity = response.getEntity(); 
        
        StringBuffer sb=new StringBuffer();
        if (resEntity != null) {  
          InputStream in = resEntity.getContent();  
          byte[] inCont=new byte[1000];
          int re=0;
          while((re=in.read(inCont))!=-1){
          	sb.append(new String(inCont));
          }
        } 
        //关闭连接
        httppost.releaseConnection();
        httpclient.getConnectionManager().shutdown();
        
        return sb.toString();  
    } 
    
}
