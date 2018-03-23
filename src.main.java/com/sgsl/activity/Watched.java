package com.sgsl.activity;
//抽象主题角色，watched：被观察
public interface Watched {
	public void addWatcher(Watcher watcher);
	public void addWatcher(Watcher watcher,int index);

    public void removeWatcher(Watcher watcher);

    public void notifyWatchers(TransmitDataInte str);
}
