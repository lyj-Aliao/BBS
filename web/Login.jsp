<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/6/29
  Time: 16:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="CSS/Login.css?version=2018092602">
    <script src="JS/Login.js" defer></script>
    <title>登录</title>
</head>
<body>
    <%
        //保存用户账号密码 3 小时
        String user="", password="";
        Cookie[] cookies = request.getCookies();
        if (cookies!=null){
            for (Cookie cookie: cookies){
                if ("user".equals(cookie.getName())){
                    user = cookie.getValue();
                }
                if ("password".equals(cookie.getName())){
                    password = cookie.getValue();
                }
            }
        }
    %>
    <%
        //登录失败提示
        String msg = (String) request.getAttribute("msg");
        if (msg != null){
            out.print("<script language='javascript'>alert('"+msg+"')</script>");
        }
    %>
    <div class="main"><br><br><br>
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post" onsubmit="return preLogin();">
            <input type="hidden" name="hidden" value="Login">
            <div style="margin:-20 auto;width: 250px">
                账号：<br>
                <input type="text" name="user" id="user" value="<%= user%>" class="login_table_text" placeholder="账号 / 邮箱"><br><br>
                密码：<br>
                <input type="password" name="password" id="pw" value="<%= password%>" class="login_table_text"><br>
                <p id="checkCode">验证码：<br>
                    <input type="text" name="checkCode" id="testCode" style="width: 180px; height: 35px;" onblur="if (this.value=='') this.value='点击图片更换验证码';" onfocus="if (this.value=='点击图片更换验证码') this.value='';">
                    <img id="img" border=0 src="image.jsp" style="display: block;float: right;width: 60px;height: 35px;" onclick="this.src='image.jsp?'+Math.random()"/><a href="javascript:void(0)"  onclick="changeImage()" style="font-size:15px;color:grey;"></a>
                </p>
                <input type="checkbox" name="remember" value="remember" id="remember"><label for="remember">记住密码</label>&nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" onclick="document.getElementById('HiddenDiv').style.display='block'">忘记密码</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="RegisterUser.jsp">注册</a><br><br>
                <input type="submit" value="确定"  class="login_table_text"><br><br>
            </div>
        </form>
    </div>
    <%-- 修改密码 --%>
    <div class="HiddenDiv" id="HiddenDiv">
        <div class="sonHiddenDiv">
            <form action="${pageContext.request.contextPath}/LoginServlet" method="post" onsubmit="return preModifyPW();">
                <table id="modify_table">
                    <tr>
                        <td>账号：</td>
                        <td><input type="text" name="user" id="username" class="modify_table_text"></td>
                    </tr>
                    <tr>
                        <td>邮箱：</td>
                        <td><input type="text" id="emailAddress" name="emailAddress" class="modify_table_text"></td>
                    </tr>
                    <tr>
                        <td>验证码：</td>
                        <td>
                            <input type="text" id="captcha" name="captcha" disabled="true" style="width: 90px; height: 30px;">&nbsp;
                            <input type="button" id="sendCode" value="点击发送" onclick="reClick()" style="height: 30px;">
                        </td>
                    </tr>
                    <tr>
                        <td>新密码：</td>
                        <td><input type="password" name="password" placeholder="含大小写字母" class="modify_table_text" id="password" onkeyup="myFunction3()"></td>
                        <div id="pwStrongth" style="top: 250px;left: 123px; width: 170px; height: 7px;"><span id="innerprogress"></span></div>
                    </tr>
                    <tr>
                        <td style="width: 90;">确认密码：</td>
                        <td><input type="password" id="againPW" class="modify_table_text"></td>
                    </tr>
                    <tr>
                        <td colspan="2"><input type="submit" value="确定" style="width: 260px; height: 30px"></td>
                    </tr>
                </table>
                <a href="javascript:void(0)" onclick="document.getElementById('HiddenDiv').style.display='none'"><--想起来了，我要登录</a>
            </form>
        </div>
    </div>
</body>
</html>
