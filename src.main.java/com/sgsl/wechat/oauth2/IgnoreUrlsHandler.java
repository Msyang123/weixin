package com.sgsl.wechat.oauth2;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jfinal.handler.Handler;

public class IgnoreUrlsHandler extends Handler{

	private List<String> ignores = new ArrayList<String>();
	
	{
		ignores.add("/wx_oauth2_servlet");
	}
	
	public void handle(String target, HttpServletRequest request, HttpServletResponse response, boolean[] isHandled) {
		if(!ignores.contains(target)){
			nextHandler.handle(target, request, response, isHandled);
		}
	}
}
