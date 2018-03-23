package com.sgsl.config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.jfinal.handler.Handler;
import com.jfinal.kit.StrKit;

public class MyContextPathHandler extends Handler {

	private String contextPathName;
	private String contextPathVal;

	public MyContextPathHandler() {
		contextPathName = "CONTEXT_PATH";
	}

	public MyContextPathHandler(String contextPathName,String contextPathVal) {
		if (StrKit.isBlank(contextPathName))
			throw new IllegalArgumentException("contextPathName can not be blank.");
		this.contextPathName = contextPathName;
		this.contextPathVal =contextPathVal;
	}

	public void handle(String target, HttpServletRequest request, HttpServletResponse response, boolean[] isHandled) {
		request.setAttribute(contextPathName, contextPathVal);
		nextHandler.handle(target, request, response, isHandled);
	}
}
