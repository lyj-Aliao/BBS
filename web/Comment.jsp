<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/7/24
  Time: 21:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="JS/Comment.js" defer></script>
    <link rel="stylesheet" type="text/css" href="CSS/Comment.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
    <title>Title</title>
</head>
<script>
    function Pre() {
        // 获取评论列表
        $.ajax({
            type: "Get",
            url: "CommentServlet",
            data: "pid=0&page=1",
            success: function(){}
        })

        // 分页
        var page = <%= session.getAttribute("page")%>;
        var current_page = <%= session.getAttribute("current_page")%>;
        var begin_page = 1;
        var end_page = current_page + 6;
        if (current_page > 3){
            begin_page = current_page - 3;
        }
        if(end_page > page){
            if (page - 6 > 0){
                end_page = page;
            }else{
                begin_page = 1;
                end_page = page;
            }
        }
        var pid = <%= session.getAttribute("pid")%>;
        //首页链接
        var begin_a = document.createElement("a");
        begin_a.href = "CommentServlet?pid="+pid+"&page=1";
        begin_a.id = "begin_a";
        document.getElementById("page").appendChild(begin_a);
        //首页按钮
        var begin_button = document.createElement("input");
        begin_button.type = "button";
        begin_button.value = "首页";
        begin_button.style.width = "45px";
        begin_button.style.height = "25px";
        document.getElementById("begin_a").appendChild(begin_button);
        for (var i = begin_page; i <= end_page; i++){
            //分页链接
            var a = document.createElement("a");
            a.href = "CommentServlet?pid="+pid+"&page="+i;
            a.id = "a"+i;
            document.getElementById("page").appendChild(a);

            //分页按钮
            var button = document.createElement("input");
            button.type = "button";
            button.value = i;
            button.style.width = "25px";
            button.style.height = "25px";
            document.getElementById("a"+i).appendChild(button);


        }
        //尾页链接
        var end_a = document.createElement("a");
        end_a.href = "CommentServlet?pid="+pid+"&page="+page;
        end_a.id = "end_a";
        document.getElementById("page").appendChild(end_a);
        //尾页按钮
        var end_button = document.createElement("input");
        end_button.type = "button";
        end_button.value = "尾页";
        end_button.style.width = "45px";
        end_button.style.height = "25px";
        document.getElementById("end_a").appendChild(end_button);
    }

    //缩放图片到合适大小,如果宽度>高度，宽度=maxwidth，高度等比缩放，反之亦然
    function ResizeImages(){
        var myimg,oldwidth,oldheight;
        var maxwidth=85;
        var maxheight=85;
        var maxwidth1=70;
        var maxheight1=70;
        // img 为 img 图片标签
        // 用户头像
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
        // 帖子用户头像
        for(j=0;j<100;j++){
            var img = document.getElementsByClassName('picture')[j].getElementsByTagName('img');
            for(i=0;i<img.length;i++){
                myimg = img[i];
                if(myimg.width > myimg.height){
                    if(myimg.width > maxwidth1)
                    {
                        oldwidth = myimg.width;
                        myimg.height = myimg.height * (maxwidth1/oldwidth);
                        myimg.width = maxwidth1;
                    }
                }else{
                    if(myimg.height > maxheight1)
                    {
                        oldheight = myimg.height;
                        myimg.width = myimg.width * (maxheight1/oldheight);
                        myimg.height = maxheight1;
                    }
                }
            }
        }
    }
</script>
<body onload="Pre()">
    <%
        if (session.getAttribute("user") == null){
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }
    %>
    <%
        //签到成功提示
        String msg = (String) request.getAttribute("msg");
        if (msg != null){
            out.print("<script language='javascript'>alert('"+msg+"')</script>");
        }

    %>
    <%
        String photo = (String) session.getAttribute("profilePhoto");
        String name = (String) session.getAttribute("name");
        String post_photo = (String) session.getAttribute("post_photo");
        String post_title = (String) session.getAttribute("post_title");
        String post_createAccount = (String) session.getAttribute("post_createAccount");
        String post_comment = (String) session.getAttribute("post_comment");
        String post_time = (String) session.getAttribute("post_time");
        int a = (Integer.parseInt(session.getAttribute("current_page").toString())-1)*10+1;
    %>
    <%-- 菜单栏 --%>
    <div id="nav">
        <div style="display: inline-block;padding: 15px;">
            <input type="search" id="search" placeholder="   搜索帖子 ..." onblur="setTimeout(function(){ clearContent() },100)" onfocus="search()">

            <%-- 内容展示部分 --%>
            <div id="popDiv">
                <table id="content_table" bgcolor="#FFFAFA" border="0" cellspacing="0" cellpadding="0" style="width: 100%; border-radius: 5px;">
                    <tbody id="content_table_body"></tbody>
                </table>
            </div>
        </div>
        <div class="bar">
            <a href="UserInfo.jsp"><i class="fa fa-user fa-lg" aria-hidden="true"></i></a>
        </div>
        <div class="bar">
            <a href="Post.jsp"><i class="fa fa-home fa-lg" aria-hidden="true"></i></a>
        </div>
    </div>
    <%-- 用户信息模块 --%>
    <div id="UserInfo">
        <div id="name"><%= name%></div>
        <div id="picture-pane"><img src="<%= photo%>" onLoad="ResizeImages();"></div>
        <div style="text-align:center; margin-top: 15%;">
            <span id="out">测试&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试</span>
        </div>
    </div>
    <%-- 顶部帖子 --%>
    <div id="post">
        <div id="title"><span style="margin-left: 10px"><%= post_title%></span></div>
        <div id="content">
            <div class="picture">
                <img src="<%= post_photo%>" style="margin-top: 25%;" onload="ResizeImages">
                <span style="display: block; text-align: center; margin-top: 10%;"><a href="javascript:void(0)" style="text-decoration : none; color: black;"><%= post_createAccount%></a></span>
            </div>
            <div style="float: left; width: 85%">
                <span style="display: block; margin: 5px auto auto 5px; min-height: 220px;"><%= post_comment%></span>
                <span style="float: bottom; margin-left: 85%;"><%= post_time%></span>
            </div>
        </div>
    </div>

    <%-- 评论显示 --%>
    <div id="main">
        <c:set var="lastIndex" value="0" scope="session"/>
        <c:forEach items="${list}" var="Comment" varStatus="status">
            <div class="context">
                <div class="context_left">
                    <div class="picture" style="text-align:center;"><a href="${pageContext.request.contextPath}/UserServlet?userID=${Comment.userID}&isOther=1"><img src="${Comment.profilePhoto}" style="margin-top: 15%" onLoad="ResizeImages();"></a></div>
                    <span style="display: block; text-align: center; position: relative; margin-top: 5%;">${Comment.createAccount}</span>
                </div>
                <div class="context_right">
                    <span style="display: block; position: relative; margin-top: -150px; left: 94%; color: #CB4042">#<%= a++%></span>
                    <div style="position: relative; left: 1%; margin-bottom: 30px;">${Comment.content}</div>
                    <span style="display: block; margin-left: 68%; margin-top: 12%;">
                        <span style="color: #80828b">${Comment.time}</span>&nbsp;
                        <a href="javascript:void(0)" style="text-decoration : none;" onclick="hideAndDisplay(${status.index})">回复(${Comment.countByReply})</a>
                    </span>

                    <%-- 子评论显示 --%>
                    <div id="reply_area${status.index}" style="display: none; margin-bottom: 10px; background-color: #cad8f2; width: 80%; height: 55%; position: relative; left: 19%;">
                        <div style="height: 88%; overflow: auto;">
                            <c:if test="${Comment.countByReply > 0}">
                                <c:forEach items="${replyList}" var="replyComment" varStatus="stat" begin="${lastIndex}" end="${lastIndex+Comment.countByReply-1}">
                                    <div id="div${status.count}${stat.index}" style="height: auto; line-height: 30px; border-bottom: #ffffff 1px solid;">
                                    <c:choose>
                                        <c:when test="${ replyComment.replyAccount != '' }">    <!-- if -->

                                            <span style="margin-left: 10px; display: block;">
                                                <a href="javascript:void(0)" style="text-decoration : none;">${replyComment.createAccount}</a>&nbsp;回复&nbsp;<a href="javascript:void(0)" style="text-decoration : none;">${replyComment.replyAccount}</a>&nbsp;：${replyComment.content}
                                            </span>
                                            <span style="float: right; margin-right: 10px; color: #586060;">
                                                ${replyComment.time}
                                                <a href="javascript:void(0)" style="text-decoration : none; text-align: center;" onclick="hideAndDisplay2(${status.count}${stat.index})">回复</a>
                                            </span>
                                            <div class="clear"></div>   <!-- 消除浮动效果 -->
                                            <div id="replyDiv${status.count}${stat.index}" style="float: bottom; height: 35px; display: none;">
                                                <form action="${pageContext.request.contextPath}/SendPostAndCommentServlet" method="post">
                                                    <input type="hidden" name="hidden" value="replySonComment">
                                                    <input type="hidden" name="hidden1" value="${Comment.id}">
                                                    <input type="hidden" name="hidden2" value="${replyComment.id}">
                                                    <input type="text" placeholder="回复 ${replyComment.createAccount}" name="content" style="float: left; margin-left: 10px; height: 30px; width: 82%">
                                                    <input type="submit" value="发送" style="margin-left: 10px; width: 12%; height: 30px;">
                                                </form>
                                            </div>

                                        </c:when>
                                        <c:otherwise>    <!-- else -->

                                            <span style="margin-left: 10px; display: block;">
                                                <a href="javascript:void(0)" style="text-decoration : none;">${replyComment.createAccount}</a>：${replyComment.content}
                                            </span>
                                            <span style="float: right; margin-right: 10px; color: #586060;">
                                                <span>${replyComment.time}</span>
                                                <a href="javascript:void(0)" style="text-decoration : none; text-align: center;" onclick="hideAndDisplay2(${status.count}${stat.index})">回复</a>
                                            </span>
                                            <div class="clear"></div>   <!-- 消除浮动效果 -->
                                            <div id="replyDiv${status.count}${stat.index}" style="float: bottom; height: 35px; display: none;">
                                                <form action="${pageContext.request.contextPath}/SendPostAndCommentServlet" method="post">
                                                    <input type="hidden" name="hidden" value="replySonComment">
                                                    <input type="hidden" name="hidden1" value="${Comment.id}">
                                                    <input type="hidden" name="hidden2" value="${replyComment.id}">
                                                    <input type="text" placeholder="回复 ${replyComment.createAccount}" name="content" style="float: left; margin-left: 10px; height: 30px; width: 82%">
                                                    <input type="submit" value="发送" style="margin-left: 10px; width: 12%; height: 30px;">
                                                </form>
                                            </div>

                                        </c:otherwise>
                                    </c:choose>
                                    </div>
                                </c:forEach>
                                <c:set var="lastIndex" value="${lastIndex+Comment.countByReply}" scope="session"/>
                            </c:if>
                        </div>

                        <div style="float: bottom; height: 12%;">
                            <form action="${pageContext.request.contextPath}/SendPostAndCommentServlet" method="post">
                                <input type="hidden" name="hidden" value="replyComment">
                                <input type="hidden" name="hidden1" value="${Comment.id}">
                                <input type="text" name="content" style="float: left;margin: 10px auto auto 10px; height: 65%; width: 82%">
                                <input type="submit" value="发送" style="margin: 10px auto auto 10px; width: 12%; height: 65%;">
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <%-- 分页 --%>
    <div id="page" style="position: relative;width: 30%;top: 445px;left: 10%;"></div>

    <%-- 回复评论 --%>
    <div id="SendComment_Main">
        <form action="${pageContext.request.contextPath}/SendPostAndCommentServlet" method="post" onsubmit="return preSend()">
            <input type="hidden" name="hidden" value="fromComment">
            <textarea style="vertical-align:top; margin: 10px auto auto 10px; width: 80%; height: 230px;" placeholder="请输入内容,不超过 400 字" id="comment" name="content"></textarea>
            <input type="submit" value="发送" style="position: relative; top: -40px; margin-left: 88%; width: 80px; height: 40px;">
        </form>
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
