<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/7/11
  Time: 21:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="JS/Post.js"></script>
    <link rel="stylesheet" type="text/css" href="CSS/Post.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
    <title>帖子</title>
</head>
<script>
    function Pre() {
        // 获取帖子列表
        $.ajax({
            type: "Get",
            url: "PostServlet",
            data: "page=1",
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
        //首页链接
        var begin_a = document.createElement("a");
        begin_a.href = "PostServlet?page=1";
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
            a.href = "PostServlet?page="+i;
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
        end_a.href = "PostServlet?page="+page;
        end_a.id = "end_a";
        document.getElementById("page").appendChild(end_a);
        //尾页按钮
        var end_button = document.createElement("input");
        end_button.type = "button";
        end_button.value = "尾页";
        end_button.style.width = "45px";
        end_button.style.height = "25px";
        document.getElementById("end_a").appendChild(end_button);

        $.ajax({
            type: "Post",
            url: "PostServlet?check=1",
            success: function () {}
        })

        if ("<%= (String)session.getAttribute("isChecked")%>" == "1") {
            document.getElementById('click').disabled=true;
        }else{
            document.getElementById('click').disabled=false;
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

        String countByPost = (String) session.getAttribute("countByPost");
        String countByComment = (String) session.getAttribute("countByComment");
        String countByAccounts = (String) session.getAttribute("countByAccounts");
        String sumByCheckIn = (String) session.getAttribute("sumByCheckIn");
        String photo = (String) session.getAttribute("profilePhoto");
        String rank = (String) session.getAttribute("rank");
        String name = (String) session.getAttribute("name");
        String checkIn = (String) session.getAttribute("checkIn");
    %>
    <%-- 菜单栏 --%>
    <div id="nav">
        <div style="display: inline-block; padding: 15px;">
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
        <div style="text-align:center; margin:20px auto;">
            <span id="out">测试&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试</span>
        </div>
    </div>
    <%-- 签到模块 --%>
    <div id="checkIn">
        <span id="check-Days">已签到 <%= checkIn%> 天</span>
        <span id="rank">排名 <%= rank%> </span>
        <form method="post" action="${pageContext.request.contextPath}/PostServlet?check=0"><input type="submit" id="click" name="checkIn" value="签到" onsubmit="return check();"></form>
    </div>
    <%-- 网页统计模块 --%>
    <div class="statistics">
        <div style="border-bottom: 1px solid #15d64a; margin-top: 5px"><span style="font-size: 22px; margin-left: 10px;">网页统计</span></div><br>
        <table>
            <tr>
                <td width="55%">&nbsp;&nbsp;帖子数: <%= countByPost%></td>
                <td>评论数: <%= countByComment%></td>
            </tr>
            <tr>
                <td>&nbsp;&nbsp;用户数: <%= countByAccounts%></td>
                <td>签到数: <%= sumByCheckIn%></td>
            </tr>
        </table>
    </div>

    <%-- 帖子显示模块 --%>
    <div id="main" style="position: absolute; width: 50%;top: 134px;left: 10%;">
        <%-- 显示置顶帖子--%>
        <c:forEach items="${topPosts}" var="Post">
            <div class="context">
                <div class="picture"><img src="${Post.profilePhoto}" onLoad="ResizeImages();"></div>
                <a href="CommentServlet?pid=${Post.id}&page=1" class="top">
                    <table cellpadding="6" cellspacing="0" width="80%">
                        <tr>
                            <td colspan="2"><img src="Image/logo/Top2.jpg" style="margin-top: 3px; margin-left: -2px"><span style="font-size: 18px; color: RED;">${Post.title}</span></td>
                        </tr>
                        <tr>
                            <td><span style="font-size: 12px; color: #646464;">发帖人&nbsp;&nbsp;<span style=" font-weight: bold">${Post.createAccount}</span>&nbsp;&nbsp;●&nbsp;&nbsp;${Post.time}</span></td>
                        </tr>
                    </table>
                    <span class="span_comment">${Post.countByComment}</span>
                </a>
            </div>
        </c:forEach>
        <%-- 显示普通和加精帖子 --%>
        <c:forEach items="${normalPosts}" var="Post">
            <div class="context">
                <div class="picture"><img src="${Post.profilePhoto}" onLoad="ResizeImages();"></div>
                <a href="CommentServlet?pid=${Post.id}&page=1">
                    <table cellpadding="6" cellspacing="0" width="80%">
                        <tr>
                            <td colspan="2"><span class="span${Post.priority}" style="font-size: 18px"><img src="Image/logo/精.jpg" class="img${Post.priority}" style="display: none; margin-left: 0px; margin-top: 4px" onload="isJing()">${Post.title}</span></td>
                        </tr>
                        <tr>
                            <td><span style="font-size: 12px; color: #646464;">发帖人&nbsp;&nbsp;<span style=" font-weight: bold">${Post.createAccount}</span>&nbsp;&nbsp;●&nbsp;&nbsp;${Post.time}</span></td>
                        </tr>
                    </table>
                    <span class="span_comment">${Post.countByComment}</span>
                </a>
            </div>
        </c:forEach>
    </div>
    <%-- 分页 --%>
    <div id="page" style="position: relative; width: 50%;top: 100%;left: 10%;"></div>

    <%-- 发帖模块--%>
    <div id="SendPost_Main" style="position: relative; margin-top: 770px;">
        <form action="${pageContext.request.contextPath}/SendPostAndCommentServlet" method="post" onsubmit="return preSend()">
            <input type="hidden" name="hidden" value="fromPost">
            <div id="SendPost_title">&nbsp;标题：<input type="text" placeholder="不超过 x 个字" id="title" name="title" style="margin-top: 10px; margin-left: 5px; width: 80%; height: 50px;"></div><br>
            <div id="SendPost_content">&nbsp;内容：
                <textarea style="vertical-align:top; width: 80%; height: 250px;" placeholder="不超过 400 字" name="content" id="comment"></textarea>
                <br><input type="submit" value="发送" style="margin-left: 77%; margin-top: 10px; width: 80px; height: 40px;">
            </div>
        </form>
    </div>

    <script>
        // 搜索框兼容拼音输入法
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
