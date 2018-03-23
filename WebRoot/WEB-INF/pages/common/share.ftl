<input type="hidden"  value="${app_domain}"  id="app_domain"/>
<script src="https://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script src="plugin/weixin/wxjssdk.util.js?v=${.now?long}"></script>

<script>
var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?f2059b272eca2785767cbb761fbab189";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();

$('body').wxJsUtil();
</script>