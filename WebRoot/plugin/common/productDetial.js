function getContextPath() {
    var pathName = document.location.pathname;
    var index = pathName.substr(1).indexOf("/");
    var result = pathName.substr(0,index+1);
    return result;
}
function fruitDetial(pfId){
	window.location.href=getContextPath()+"/fruitDetial?pf_id="+pfId;
}