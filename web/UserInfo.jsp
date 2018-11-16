<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/7/10
  Time: 13:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="JS/UserInfo.js" defer></script>
    <link rel="stylesheet" type="text/css" href="CSS/UserInfo.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
    <title>个人信息</title>
</head>
<script>
    //缩放图片到合适大小,如果宽度>高度，宽度=maxwidth，高度等比缩放，反之亦然
    function ResizeImages(){
        var myimg,oldwidth,oldheight;
        var maxwidth=120;
        var maxheight=120;
        <%-- img 为 img 图片标签 --%>
        <%-- 用户头像 --%>
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
</script>
<body onload="Reload()">
    <%
        String msg = (String) request.getAttribute("msg");
        if (msg != null){
            out.print("<script language='javascript'>alert('"+msg+"')</script>");
        }

        if (session.getAttribute("user") == null){
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        String lastTime = (String) session.getAttribute("lastTime");
        String email = (String) session.getAttribute("email");
        String photo = (String) session.getAttribute("profilePhoto");
        session.setAttribute("photoPic", photo);
        String user = (String) session.getAttribute("user");
        String name = (String) session.getAttribute("name");
        String createTime = (String) session.getAttribute("createTime");
    %>

    <%-- 菜单栏 --%>
    <div id="nav">
        <div style="display: inline-block;padding: 15px;">
            <input type="search" id="search" placeholder="   搜索帖子 ..." style="background-color: #218f53;color: white;width: 300px;height: 25px;border: 0px;border-radius: 20px;outline: none;" onblur="setTimeout(function(){ clearContent() },100)" onfocus="search()">

            <%-- 内容展示部分 --%>
            <div id="popDiv">
                <table id="content_table" bgcolor="#FFFAFA" border="0" cellspacing="0" cellpadding="0" style="width: 100%; border-radius: 5px;">
                    <tbody id="content_table_body"></tbody>
                </table>
            </div>
        </div>
        <div class="bar" style="float: right;">
            <a href="UserInfo.jsp"><i class="fa fa-user fa-lg" aria-hidden="true" style="display: inline-block; color: black; margin-top: 15px;"></i></a>
        </div>
        <div class="bar" style="float: right;">
            <a href="Post.jsp"><i class="fa fa-home fa-lg" aria-hidden="true" style="display: inline-block; color: black; margin-top: 15px;"></i></a>
        </div>
    </div>
    <div id="out">
        <div id="picture-pane">
            <a href="changePic.jsp"><img src="<%= photo%>" onmousemove="document.getElementById('toPic').style.display='block'" onmouseleave="document.getElementById('toPic').style.display='none'" onLoad="ResizeImages();"></a>
            <img src="Image/photo.png" id="toPic" style="position: absolute; top: 6px; left: 6px; display: none; pointer-events: none;" onLoad="ResizeImages();">
        </div>
    </div>
    <a href="Login.jsp">
        <input type="button" value="退出登录" style="position: absolute; left: 51%; top: 30%; width: 130px; height: 50px; font-size: 20px; background-color: #fff; border: #3399ff 3px solid; border-radius: 8px;">
    </a>

    <div class="main">
        <div class="tab_div">
            <ul class="tab_title">
                <li><div class="tab_title_div"><a>基本信息</a></div></li>
                <li><div class="tab_title_div"><a>用户设置</a></div></li>
                <li><div class="tab_title_div"><a>发过的帖子</a></div></li>
                <li><div class="tab_title_div"><a>发过的评论</a></div></li>
            </ul>
        </div>
        <div class="tab_container" style="height: 93%;overflow: auto">
            <div class="tab_content" >
                <input type="hidden" name="hidden" value="modify">
                <table style="margin:-20px auto auto 5%; border-collapse:separate;border-spacing:100px 80px;">
                    <tr>
                        <td>账号:</td>
                        <td><%= user%></td>
                    </tr>
                    <tr>
                        <td>邮箱:</td>
                        <td><%= email%></td>
                    </tr>
                    <tr>
                        <td>用户名:</td>
                        <td><%= name%></td>
                    </tr>
                    <tr>
                        <td>创建时间:</td>
                        <td><%= createTime%></td>
                    </tr>
                    <tr>
                        <td>最后登录时间:</td>
                        <td><%= lastTime%></td>
                    </tr>
                    <tr id="postCount">
                        <td>发帖数:</td>
                    </tr>
                    <tr id="commentCount">
                        <td>评论数:</td>
                    </tr>
                </table>
            </div>
            <div class="tab_content">
                <table style="margin-top:-20px; border-collapse:separate;border-spacing:50px 80px;">
                    <form action="${pageContext.request.contextPath}/UserInfoServlet?hidden=1" method="Post">
                        <tr>
                            <td>邮箱:</td>
                            <td><input type="email" placeholder="请输入待绑定邮箱" id="emailAddress" name="email" style="width: 250px; height: 40px;"></td>
                            <td><input type="button" id="sendCode" value="点击发送验证码" onclick="reClick()" style="height: 40px;"></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="text" id="captcha" name="captcha" placeholder="请输入收到的邮箱验证码" disabled="true" style="width: 250px; height: 40px;">&nbsp;</td>
                            <td><input type="submit" style="display: inline-block; height: 40px;" value="绑定邮箱"></td>
                        </tr>
                    </form>
                    <a href="${pageContext.request.contextPath}/UserInfoServlet?hidden=2"><input type="button" style="display: inline-block; height: 40px; position: relative; left: 750px; top: 118px;" value="解绑"></a>
                    <tr>
                        <td>用户名:</td>
                        <form action="${pageContext.request.contextPath}/UserInfoServlet?hidden=3" method="Post">
                            <td><input type="text" placeholder="<%= name%>" name="name" style="width: 250px; height: 40px;"></td>
                            <td><input type="submit" style="height: 40px;" value="修改用户名"></td>
                        </form>
                    </tr>
                </table>
            </div>
            <div class="tab_content">
                <table style="border-collapse:separate; border-spacing:10px 30px;">
                    <c:forEach items="${postList}" var="postList">
                        <tr>
                            <td>
                                <div>
                                    ${postList.time}<br/>
                                    <a href="CommentServlet?pid=${postList.id}&page=1" style="color: black">
                                        <span style="display: inline-block;background-color: #d4dff4;border-radius: 5px;padding: 10px 10px 10px 10px;margin-top: 10px;">${postList.title}</span>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
            <div class="tab_content">
                <table style="border-collapse:separate; border-spacing:10px 40px;">
                    <c:forEach items="${commentList}" var="commentList">
                        <tr>
                            <td>
                                <div>
                                    ${commentList.time}<br/>
                                    <a href="CommentServlet?pid=${commentList.id}&page=1" style="color: black">
                                        <div style="display: inline-block;background-color: #e0e9ff;border-radius: 10px;margin: 10px auto 10px 0px; padding: 15px">
                                            ${commentList.title}<br/>
                                            <span style="display: inline-block;background-color: #c1dbff;border-radius: 5px;padding: 10px 10px 10px 10px;margin-top: 10px;"><strong>${commentList.content}</strong></span>
                                        </div>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>

    <script>
        var flag = true;
        $('#search').on('compositionstart',function(){
            flag = false;
        })
        $('#search').on('compositionend',function(){
            flag = true;
        })
        $('#search').on('input',function(){
            var _this = this;
            setTimeout(function(){
                if(flag){
                    search()
                }
            },0)
        })
    </script>
</body>
</html>
