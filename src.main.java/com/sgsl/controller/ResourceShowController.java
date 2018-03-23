package com.sgsl.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.kit.PathKit;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.revocn.comparator.NameComparator;
import com.revocn.comparator.SizeComparator;
import com.revocn.comparator.TypeComparator;
import com.revocn.controller.BaseController;
import com.sgsl.config.AppConst;
import com.sgsl.config.AppProps;
import com.sgsl.model.MShare;
import com.sgsl.model.PublicAccount;
import com.sgsl.model.ResourceShow;
import com.sgsl.model.SysUser;
import com.sgsl.model.TUser;
import com.sgsl.util.StringUtil;
import com.sgsl.wechat.UserStoreUtil;
import com.sgsl.wechat.oauth2.OAuth2Interceptor;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 资讯（律师信息发布）
 * Created by Tao on 2014-07-17.
 */
public class ResourceShowController extends BaseController {
    protected final static Logger logger = Logger.getLogger(ResourceShowController.class);

    /**
     * 后台查询资讯信息用于管理
     */
    public void searchResourceShows() {
        String keyWord=getPara("keyWord");
        int pageSize=getParaToInt("rows");
        int page=getParaToInt("page");
        String sidx=getPara("sidx");
        String sord=getPara("sord");
        Page<ResourceShow> pageInfo=null;
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        if(StringUtil.isNull(keyWord)){
            if(StringUtil.isNull(sidx)){
                pageInfo= ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where uuid=? order by layout_time desc",publicAccount.getStr("uuid"));
            }else{
                pageInfo=ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where uuid=? order by "+sidx+" "+sord,publicAccount.getStr("uuid"));
            }
        }else{
            if(StringUtil.isNull(sidx)){
                pageInfo=ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where key_word like '%"+keyWord+"%' and uuid=? order by layout_time desc",publicAccount.getStr("uuid"));
            }else{
                pageInfo=ResourceShow.dao.paginate(page,pageSize,"select *","from resource_show where key_word like '%"+keyWord+"%' and uuid=? order by "+sidx+" "+sord,publicAccount.getStr("uuid"));
            }
        }

        JSONObject result=new JSONObject();
        result.put("total",pageInfo.getTotalPage());
        result.put("page",pageInfo.getPageNumber());
        result.put("records",pageInfo.getPageSize());

        JSONArray rows=new JSONArray();
        for (ResourceShow rs:pageInfo.getList()){
            JSONObject json=new JSONObject();
            JSONArray row=new JSONArray();
            json.put("id",rs.get("id"));
            row.add("");
            row.add(rs.get("id"));
            row.add(rs.getStr("key_word"));
            //row.add(rs.getStr("content").length()>10?rs.getStr("content").substring(0,10):rs.getStr("content"));
            row.add(rs.get("layout_time"));
            row.add(rs.get("url"));
            json.put("cell",row);
            rows.add(json);
        }
        result.put("rows", rows);
        renderJson(result);
    }

    public void initResourceShow() {
        render(AppConst.PATH_MANAGE_PC + "/sys/resourceShow.ftl");
    }

    /**
     * 上传文件到网络
     */

    public void upload() {
        //SysUser user=getSessionAttr(AppConst.KEY_SESSION_USER);
        //if(user == null) return;
        // 文件保存目录路径
        String savePath =AppProps.get("filePath")+ "/resource/image/"; //PathKit.getWebRootPath() + "/resource/image/";

        // 文件保存目录URL
        String saveUrl = getRequest().getContextPath() + "/resource/image/";

        // 定义允许上传的文件扩展名
        HashMap<String, String> extMap = new HashMap<String, String>();
        extMap.put("image", "gif,jpg,jpeg,png,bmp");
        extMap.put("product", "gif,jpg,jpeg,png,bmp");
        extMap.put("activity", "gif,jpg,jpeg,png,bmp");
        extMap.put("flash", "swf,flv");
        extMap.put("media", "swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb");
        extMap.put("file", "doc,docx,xls,xlsx,ppt,htm,html,txt,zip,rar,gz,bz2");

        // 最大文件大小100k
        long maxSize = 1024000;

        getResponse().setContentType("text/html; charset=UTF-8");

        if (!ServletFileUpload.isMultipartContent(getRequest())) {
            // out.println(getError("请选择文件。"));
            renderJson("请选择文件。");
            return;
        }
        // 检查目录
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            /*renderJson("上传目录不存在。");
            return;*/
        }
        // 检查目录写权限
        if (!uploadDir.canWrite()) {
            renderJson("上传目录没有写权限。");
            return;
        }

        String dirName = getPara("dir");
        String idName=getPara("idName");
        if (StringUtil.isNull(dirName)) {
            dirName = "image";
        }
        if(StringUtil.isNull(idName)){
        	idName="temp";
        }
        if (!extMap.containsKey(dirName)) {
            renderJson("目录名不正确。");
            return;
        }
        // 创建文件夹
        savePath += dirName + "/";
        saveUrl += dirName + "/";
        /*File saveDirFile = new File(savePath);
        if (!saveDirFile.exists()) {
            saveDirFile.mkdirs();
        }*/
        /*SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String ymd = sdf.format(new Date());
        savePath += ymd + "/";
        saveUrl += ymd + "/";*/
        String idNamePy=StringUtil.getPingYin(idName);
        savePath += idNamePy + "/";
        saveUrl += idNamePy + "/";
        File dirFile = new File(savePath);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }

        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setHeaderEncoding("UTF-8");
        List items = null;
        try {
            items = upload.parseRequest(getRequest());
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        Iterator itr = items.iterator();
        while (itr.hasNext()) {
            FileItem item = (FileItem) itr.next();
            String fileName = item.getName();
            if (!item.isFormField()) {
                // 检查文件大小
                if (item.getSize() > maxSize) {
                    renderJson("上传文件大小超过限制。");
                    return;
                }
                // 检查扩展名
                String fileExt = fileName.substring(
                        fileName.lastIndexOf(".") + 1).toLowerCase();
                if (!Arrays.<String> asList(extMap.get(dirName).split(","))
                        .contains(fileExt)) {
                    renderJson("上传文件扩展名是不允许的扩展名。\n只允许" + extMap.get(dirName)
                            + "格式。");
                    return;
                }

                SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
                String newFileName = df.format(new Date()) + "_"
                        + new Random().nextInt(1000) + "." + fileExt;
                try {
                    File uploadedFile = new File(savePath, newFileName);
                    item.write(uploadedFile);
                } catch (Exception e) {
                    renderJson("上传文件失败。");
                    return;
                }

                JSONObject obj = new JSONObject();
                obj.put("error", 0);
                obj.put("url", saveUrl + newFileName);
                renderJson(obj.toJSONString());
            }
        }
    }

    /**
     * 查找在线图片空间
     */
    public void fileManage() {

        /*SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);;
        if (user == null)
            return;*/

        // 根目录路径，可以指定绝对路径，比如 /var/www/attached/
        String rootPath = PathKit.getWebRootPath() + "/resource/image/";
        //        + user.getInt("id").toString() + "/";
        // 根目录URL，可以指定绝对路径，比如 http://www.yoursite.com/attached/
        String rootUrl = getRequest().getContextPath() + "/resource/image/";
        //        + user.getInt("id").toString() + "/";
        // 图片扩展名
        String[] fileTypes = new String[] { "gif", "jpg", "jpeg", "png", "bmp" };

        String dirName = getRequest().getParameter("dir");
        if (dirName != null) {
            if (!Arrays.<String> asList(
                    new String[] { "image","product","activity", "flash", "media", "file" })
                    .contains(dirName)) {
                System.out.println("Invalid Directory name.");
                return;
            }
            rootPath += dirName + "/";
            rootUrl += dirName + "/";
            File saveDirFile = new File(rootPath);
            if (!saveDirFile.exists()) {
                saveDirFile.mkdirs();
            }
        }
        // 根据path参数，设置各路径和URL
        String path = getRequest().getParameter("path") != null ? getRequest()
                .getParameter("path") : "";
        String currentPath = rootPath + path;
        String currentUrl = rootUrl + path;
        String currentDirPath = path;
        String moveupDirPath = "";
        if (!"".equals(path)) {
            String str = currentDirPath.substring(0,
                    currentDirPath.length() - 1);
            moveupDirPath = str.lastIndexOf("/") >= 0 ? str.substring(0,
                    str.lastIndexOf("/") + 1) : "";
        }

        // 排序形式，name or size or type
        String order = getRequest().getParameter("order") != null ? getRequest()
                .getParameter("order").toLowerCase() : "name";

        // 不允许使用..移动到上一级目录
        if (path.indexOf("..") >= 0) {
            System.out.println("Access is not allowed.");
            return;
        }
        // 最后一个字符不是/
        if (!"".equals(path) && !path.endsWith("/")) {
            System.out.println("Parameter is not valid.");
            return;
        }
        // 目录不存在或不是目录
        File currentPathFile = new File(currentPath);
        if (!currentPathFile.isDirectory()) {
            System.out.println("Directory does not exist.");
            return;
        }

        // 遍历目录取的文件信息
        List<Hashtable> fileList = new ArrayList<Hashtable>();
        if (currentPathFile.listFiles() != null) {
            for (File file : currentPathFile.listFiles()) {
                Hashtable<String, Object> hash = new Hashtable<String, Object>();
                String fileName = file.getName();
                if (file.isDirectory()) {
                    hash.put("is_dir", true);
                    hash.put("has_file", (file.listFiles() != null));
                    hash.put("filesize", 0L);
                    hash.put("is_photo", false);
                    hash.put("filetype", "");
                } else if (file.isFile()) {
                    String fileExt = fileName.substring(
                            fileName.lastIndexOf(".") + 1).toLowerCase();
                    hash.put("is_dir", false);
                    hash.put("has_file", false);
                    hash.put("filesize", file.length());
                    hash.put("is_photo", Arrays.<String> asList(fileTypes)
                            .contains(fileExt));
                    hash.put("filetype", fileExt);
                }
                hash.put("filename", fileName);
                hash.put("datetime",
                        new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(file
                                .lastModified()));
                fileList.add(hash);
            }
        }

        if ("size".equals(order)) {
            Collections.sort(fileList, new SizeComparator());
        } else if ("type".equals(order)) {
            Collections.sort(fileList, new TypeComparator());
        } else {
            Collections.sort(fileList, new NameComparator());
        }
        JSONObject result = new JSONObject();
        result.put("moveup_dir_path", moveupDirPath);
        result.put("current_dir_path", currentDirPath);
        result.put("current_url", currentUrl);
        result.put("total_count", fileList.size());
        result.put("file_list", fileList);

        getResponse().setContentType("application/json; charset=UTF-8");
        renderJson(result.toJSONString());
    }

    /**
     * 初始化资讯信息编辑
     */
    public void initEditResourceShow(){
        ResourceShow resourceShow=ResourceShow.dao.findById(getPara("id"));
        if(resourceShow==null){
            resourceShow=new ResourceShow();
        }
        setAttr("resourceShow",resourceShow);
        render(AppConst.PATH_MANAGE_PC+"/sys/editResourceShow.ftl");
    }
    /**
     * 保存资讯信息
     */
    public void saveResourceShow(){
        SysUser user = getSessionAttr(AppConst.KEY_SESSION_USER);
        PublicAccount publicAccount=PublicAccount.dao.findUserByLoginName(user.getStr("user_name"));
        ResourceShow model = getModel(ResourceShow.class,"rs");
        Record record = new Record();
        record.set("layout_time",new Date());
        record.set("uuid",publicAccount.getStr("uuid"));
        record.setColumns(model2map(model));
        if(StringUtil.isNull(getPara("rs.id"))){
            Db.save("resource_show",record);
        }else{
            Db.update("resource_show",record);
        }
        redirect("/resourceShow/initResourceShow");
    }

    /**
     * 删除资讯信息
     */
    public void delResourceShow(){
        String oper=getPara("oper");
        if(oper.equals("del")){
            ResourceShow.dao.deleteById(getPara("id"));
        }
        renderJson("{result:'success'}");
    }

    /**
     * 上传excel文件到网络
     */

    public void uploadExcel() {
        // 文件保存目录路径
        String savePath = AppProps.get("filePath");//AppProps.get("filePath")+ PathKit.getWebRootPath() + "/resource/image/";

        // 文件保存目录URL
        String saveUrl = getRequest().getContextPath() + "/resource/excel/";

        // 定义允许上传的文件扩展名
        HashMap<String, String> extMap = new HashMap<String, String>();
        extMap.put("file", "xlsx");
        // 最大文件大小10000k(10M)
        long maxSize = 10240000;

        getResponse().setContentType("text/html; charset=UTF-8");

        if (!ServletFileUpload.isMultipartContent(getRequest())) {
            renderJson("请选择文件。");
            return;
        }
        // 检查目录
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        // 检查目录写权限
        if (!uploadDir.canWrite()) {
            renderJson("上传目录没有写权限。");
            return;
        }

        String dirName = getPara("dir");
        String idName=getPara("idName");
        if (StringUtil.isNull(dirName)) {
            dirName = "file";
        }
        if(StringUtil.isNull(idName)){
        	idName="手动发送名单";
        }
        if (!extMap.containsKey(dirName)) {
            renderJson("目录名不正确。");
            return;
        }
        // 创建文件夹
        savePath += dirName + "/";
        saveUrl += dirName + "/";

        String idNamePy=StringUtil.getPingYin(idName);
        savePath += idNamePy + "/";
        saveUrl += idNamePy + "/";
        File dirFile = new File(savePath);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }

        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setHeaderEncoding("UTF-8");
        List items = null;
        try {
            items = upload.parseRequest(getRequest());
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        Iterator itr = items.iterator();
        while (itr.hasNext()) {
            FileItem item = (FileItem) itr.next();
            String fileName = item.getName();
            if (!item.isFormField()) {
                // 检查文件大小
                if (item.getSize() > maxSize) {
                    renderJson("上传文件大小超过限制。");
                    return;
                }
                // 检查扩展名
                String fileExt = fileName.substring(
                        fileName.lastIndexOf(".") + 1).toLowerCase();
                if (!Arrays.<String> asList(extMap.get(dirName).split(","))
                        .contains(fileExt)) {
                    renderJson("上传文件扩展名是不允许的扩展名。\n只允许" + extMap.get(dirName)
                            + "格式。");
                    return;
                }

                SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
                String newFileName = df.format(new Date()) + "_"
                        + new Random().nextInt(1000) + "." + fileExt;
                try {
                    File uploadedFile = new File(savePath, newFileName);
                    item.write(uploadedFile);
                    System.out.println("保存地址为："+savePath+"\n文件名为"+newFileName);
                } catch (Exception e) {
                    renderJson("上传文件失败。");
                    return;
                }

                JSONObject obj = new JSONObject();
                obj.put("error", 0);
                obj.put("url", savePath + newFileName);
                renderJson(obj.toJSONString());
            }
        }
    }

  
}
