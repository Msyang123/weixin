<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=[] styles=[] >
<form action="m/web/modifyWebParma" method="post">
<label for="webpar" style="width:100px">标题：</label>
<input type="hidden" name = "webparam.id" value="${(wp.id)!}">
<input id="title"type="text" name="webparam.title" value="${(wp.title)!}" class="form-control"><br>
<label for="webpar" style="width:100px">关键字:</label>
<input id="keywords"type="text" name="webparam.keywords" value="${(wp.keywords)!}" class="form-control"><br>
<label for="webpar" style="width:100px">信息描述:</label>
<input id="tjjs" type="text" name="webparam.tjjs" value="${(wp.tjjs)!}" class="form-control"><br>
<input type="submit" value="更新">
</form>
</@layout>