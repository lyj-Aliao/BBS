<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/7/27
  Time: 12:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <title>Pass</title>
</head>
<script>
    onload=function(){
        setInterval(go, 1000);
    };
    var x=4; //利用了全局变量来执行
    function go(){
        x--;
        if(x>0){
            document.getElementById("sp").innerHTML=x;  //每次设置的x的值都不一样了。
        }else{
            // 获取帖子列表
            $.ajax({
                type: "Get",
                url: "PostServlet",
                data: "page=1",
                success: function(){}
            })
            location.href= '<%= request.getAttribute("JumpTo")%>';
        }
    }
</script>
<body style="font-size: 25px; font-family: 微软雅黑; margin: 0px; background: #CB4042;">
    <%
        String msg = (String) request.getAttribute("msg");
    %>
    <div style="background-color: #fff; margin-top: 10%; margin-left: 23%; width: 800px; height: 300px;">
        <span style="display: block; text-align: center; position: relative; top: 20%;"><%= msg%></span><br>
        <span style="display: block; text-align: center; position: relative; top: 20%;">若帖子、评论和头像不及时显示，请多刷新一遍</span><br>
        <span style="display: block; text-align: center; position: relative; top: 20%;"><span id="sp"></span>&nbsp;秒后自动跳转网页</span>
    </div>
</body>
</html>
