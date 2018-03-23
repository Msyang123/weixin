package com.sgsl.activity;
//具体的主题角色注册活动
public class RegisterActivityWatcher implements Watcher
{

    @Override
    public void update(TransmitDataInte data)
    {
    	RegisterTransmitData registerData=(RegisterTransmitData)data;
    	
        System.out.println("注册活动"+registerData.getUserId());
    }

}