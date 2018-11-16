<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/7/10
  Time: 13:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%--<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">--%>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <script src="JS/jquery.Jcrop.min.js"></script>
    <link rel="stylesheet" href="CSS/jquery.Jcrop.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="CSS/changePic.css">
    <title>修改头像</title>
</head>
<script language="Javascript">
    //截取图片，将坐标传给后台
    jQuery(function($) {
        var jcrop_api,
            boundx,
            boundy,
            $preview = $('#preview-pane'),
            $pcnt = $('#preview-pane .preview-container'),
            $pimg = $('#preview-pane .preview-container img'),
            xsize = $pcnt.width(),
            ysize = $pcnt.height();
        console.log('init',[xsize,ysize]);

        $('#target').Jcrop({
            onChange: showPreview,
            onSelect: showPreview,
            aspectRatio: 1
        },function(){
            var bounds = this.getBounds();
            //网页中的图片宽高
            boundx = bounds[0];
            boundy = bounds[1];
            jcrop_api = this;
            $preview.appendTo(jcrop_api.ui.holder);
        });
        // coords.w 截取框宽度 coords.h 截取框高度
        function showPreview(coords)
        {
            var rx = xsize / coords.w;
            var ry = ysize / coords.h;
            $("#finalWidth").attr("value", Math.round(rx * boundx));
            $("#finalHeight").attr("value", Math.round(ry * boundy));
            $("#x").attr("value", Math.round(rx * coords.x));
            $("#y").attr("value",Math.round(ry * coords.y));
            $pimg.css({
                width: Math.round(rx * boundx) + 'px',
                height: Math.round(ry * boundy) + 'px',
                marginLeft: '-' + Math.round(rx * coords.x) + 'px',
                marginTop: '-' + Math.round(ry * coords.y) + 'px'
            });
        }
    });
    //缩放图片到合适大小,如果宽度>高度，宽度=maxwidth，高度等比缩放，反之亦然
    function ResizeImages(){
        var myimg,oldwidth,oldheight;
        var maxwidth=300;
        var maxheight=300;
        <%-- img 为 img 图片标签 --%>
        var imgs = document.getElementById('picture-pane').getElementsByTagName('img');
        for(i=0;i<imgs.length;i++){
            myimg = imgs[i];
            if(myimg.width > myimg.height){
                if(myimg.width > maxwidth)
                {
                    oldwidth = myimg.width;
                    myimg.height = myimg.height * (maxwidth/oldwidth);
                    myimg.width = maxwidth;
                }
            }else{
                if(myimg.height > maxheight)
                {
                    oldheight = myimg.height;
                    myimg.width = myimg.width * (maxheight/oldheight);
                    myimg.height = maxheight;
                }
            }
        }
    }
    function checkFile(){
        if (document.querySelector("input[type=file]").files.length == 0){
            alert("未选择文件");
            return false;
        }
        return true;
    }
    function isSelect(){
        if (document.getElementById("x").value.length == 0){
            alert("未剪裁图片");
            return false;
        }
        return true;
    }
</script>
<body style="background: #CB4042">
    <%
        if (session.getAttribute("user") == null){
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }
    %>
    <%
        String photoPath = (String) session.getAttribute("photoPic");
        String msg = (String) request.getAttribute("msg");
        if (msg != null){
            out.print("<script language='javascript'>alert('"+msg+"')</script>");
        }
    %>
    <div class="HiddenPicDiv" id="HiddenPicDiv" style="visibility: visible">
        <%-- 图片上传 --%>
        <form action="${pageContext.request.contextPath}/UploadServlet" method="post" enctype="multipart/form-data"  onsubmit="return checkFile();">
            <div id="picture-pane">
                <img src="<%= photoPath%>" id="target" onLoad="ResizeImages();"/>
                <input type="file" id="selectPic" accept="image/jpg, image/jpeg, image/png" name="upload" value="选择图片">
            </div>
            <input type="submit" value="更新图片" style="position: fixed; top: 37%; left: 41%">
        </form>
        <div id="preview-pane">
            <div class="preview-container">
                <img src="<%= photoPath%>" id="preview" />
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/PhotoServlet" method="post" onsubmit="return isSelect();">
            <input type="hidden" name="x" id="x">
            <input type="hidden" name="y" id="y">
            <input type="hidden" name="finalWidth" id="finalWidth">
            <input type="hidden" name="finalHeight" id="finalHeight">
            <input type="submit" id="buttonPic" value="提交">
        </form>
        <p id="a">预览图:</p>
        <h1 id="upTitle" style="color: #CB4042">从电脑中选择喜欢的图片</h1>
        <div id="aside">
        <h2>给你自己扮酷!</h2><br>
            点击 “浏览” 选择图片，并点击 “更新图片” 进行更新<br><br>
            确保图片尺寸至少为160*160, 这样才能完美剪切头像<br><br>
            上传你喜欢的照片，随意拖拽或调整大图中的虚线方格，预览的小图即为保存后的头像图标。<br><br>
            更新图片后如果图标显示异常，请多刷新几次。
        </div>
    </div>
</body>
</html>
