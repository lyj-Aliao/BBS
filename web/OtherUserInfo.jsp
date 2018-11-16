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
    <script type="text/javascript" src="OtherUserInfo.js"></script>
    <link rel="stylesheet" type="text/css" href="CSS/UserInfo.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
    <title>个人信息</title>
</head>
<script>
    // div 不刷新切换
    $(function(){
        ui_control(0);  // 0 表示初始显示第一个 div
        $(".tab_content").height($(document).height()-200);
    });
    function ui_control(aType){    //tabs-start
        $("ul.tab_title li:eq(0)").addClass("select");
        $(".tab_content:eq(0)").show();

        $("ul.tab_title li").each(function(i){
            $(this).click(function(){
                //i=i+1;
                //alert(i);
                $(".tab_content:eq("+i+")").show().siblings().hide();
                $(this).addClass("select").siblings().removeClass("select");
            });
        });
        $("ul.tab_title li:eq("+aType+")").click();
        //tabs_end
    }

    // 搜索框智能提示
    function search(){
        // 获得用户输入
        var content = document.getElementById("search");
        if (content.value == ""){
            clearContent();
            return ;
        }

        // 向服务器通过 ajax 异步发送数据
        $.ajax({
            type: "Post",
            dataType: "json",
            data: "keyword="+content.value,
            url: "SearchServlet",
            success: function (text) {
                var array = new Array();
                var idList = new Array();
                $.each(text,function(i,n){
                    array[i] = n["title"];
                    idList[i] = n["id"];
                })
                setContent(array, idList);
            }
        })
    }

    // 关联数据的展示，参数是服务器传递过来的关联数据
    function setContent(contents, pid){
        // 获得获得关联数据长度，以此确定生成多少行
        var size = contents.length;
        clearContent();
        // 内容
        for (var i=0;i<size;i++){
            // 第 i 个元素
            var nextNode = contents[i];
            var nextLink = pid[i];
            var a = document.createElement("a");
            a.href = "CommentServlet?pid="+nextLink+"&page=1";
            a.style = "text-decoration:none; display:inline-block; width: 100%; height: 30px; line-height: 30px;";
            var tr = document.createElement("tr");
            var td = document.createElement("td");
            var text = document.createTextNode(nextNode);
            a.appendChild(text);
            td.appendChild(a);
            tr.appendChild(td);
            document.getElementById("content_table_body").appendChild(tr);
        }
    }

    $('#content_table_body').onblur(function () {
        clearContent();
    })

    function clearContent() {
        var contentBody = document.getElementById("content_table_body");
        var size = contentBody.childNodes.length;
        for (var i=size-1;i>=0;i--){
            contentBody.removeChild(contentBody.childNodes[i]);
        }
    }


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
<body>
    <%
        if (session.getAttribute("user") == null){
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }
    %>
    <%
        String lastTime = (String) session.getAttribute("OtherLastTime");
        String PostCount = (String) session.getAttribute("OtherPostCount");
        String CommentCount = (String) session.getAttribute("OtherCommentCount");
        String photo = (String) session.getAttribute("OtherProfilePhoto");
        String name = (String) session.getAttribute("OtherName");
        String createTime = (String) session.getAttribute("OtherCreateTime");
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
        <div id="picture-pane"><img src="<%= photo%>" onLoad="ResizeImages();"></div>
    </div>

    <div class="main">
        <div class="tab_div">
            <ul class="tab_title">
                <li><div class="tab_title_div"><a>基本信息</a></div></li>
                <li><div class="tab_title_div"><a>发过的帖子</a></div></li>
                <li><div class="tab_title_div"><a>发过的评论</a></div></li>
            </ul>
        </div>
        <div class="tab_container" style="height: 93%;overflow: auto">
            <div class="tab_content" >
                <form method="post" action="${pageContext.request.contextPath}/LoginServlet">
                    <input type="hidden" name="hidden" value="modify">
                    <table style="margin:-20px auto auto 5%; border-collapse:separate;border-spacing:100px 80px;">
                        <tr>
                            <td>昵称:</td>
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
                        <tr>
                            <td>等级:</td>
                            <td>38</td>
                        </tr>
                        <tr>
                            <td>发帖数:</td>
                            <td><%= PostCount%></td>
                        </tr>
                        <tr>
                            <td>评论数:</td>
                            <td><%= CommentCount%></td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="tab_content">
                <table style="border-collapse:separate; border-spacing:10px 30px;">
                    <c:forEach items="${OtherPostList}" var="postList">
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
                    <c:forEach items="${OtherCommentList}" var="commentList">
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
