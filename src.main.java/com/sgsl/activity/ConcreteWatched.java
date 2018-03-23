package com.sgsl.activity;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
//具体的观察者
public class ConcreteWatched implements Watched
{
    // 存放观察者
    private List<Watcher> list = new ArrayList<Watcher>();

    @Override
    public void addWatcher(Watcher watcher)
    {
        list.add(watcher);
    }
    @Override
    public void addWatcher(Watcher watcher,int index)
    {
        list.add(index,watcher);
    }

    @Override
    public void removeWatcher(Watcher watcher)
    {
        list.remove(watcher);
    }

    @Override
    public void notifyWatchers(TransmitDataInte data)
    {
        // 自动调用实际上是主题进行调用的
        for (Watcher watcher : list)
        {
            watcher.update(data);
        }
    }
    
    public static void main(String[] args)
    {
        
        
        /******订单活动******************/
    	Watched orderActivityWatched = new ConcreteWatched();
        Watcher watcher1 = new OrderActivity1Watcher();
        Watcher watcher2 = new OrderActivity2Watcher();
        Watcher watcher3 = new OrderActivity3Watcher();
        Watcher watcher4 = new OrderActivity4Watcher();
        
        
        orderActivityWatched.addWatcher(watcher2);
        orderActivityWatched.addWatcher(watcher3);
        orderActivityWatched.addWatcher(watcher4);
        orderActivityWatched.addWatcher(watcher1);
        OrderTransmitData data=new OrderTransmitData();
        data.setNeedPay(60);
        data.setOrderId(423423);
        data.setUserId(2);
        data.setCouponId(1);
        data.setCurrentTime(new Date());
        //分发通知
        orderActivityWatched.notifyWatchers(data);
        /******订单活动******************/
        
    }
}
