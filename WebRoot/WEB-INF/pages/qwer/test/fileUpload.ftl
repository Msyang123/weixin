<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["/js/zxxFile.js"] styles=[]>


<span id="qqLoginBtn" ></span>
</@layout>
<script type="text/javascript" src="http://qzonestyle.gtimg.cn/qzone/openapi/qc_loader.js" data-appid="101064276" data-redirecturi="http://www.happy731.com/auth/afterQQLogin" charset="utf-8" ></script>



<script type="text/javascript">
 QC.Login({
  btnId : "qqLoginBtn",//插入按钮的html标签id
  size : "A_L",//按钮尺寸
  scope : "get_user_info",//展示授权，全部可用授权可填 all
  display : "pc"//应用场景，可选
 });
</script>
