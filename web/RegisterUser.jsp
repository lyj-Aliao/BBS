<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/6/29
  Time: 17:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script type="text/javascript" src="JS/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="JS/RegisterUser.js" defer></script>
    <link rel="stylesheet" type="text/css" href="CSS/RegisterUser.css?version=2018092604">
    <title>注册</title>
</head>
<body>
    <%
        String msg = (String) request.getAttribute("msg");
        if (msg != null){
            out.print("<script language='javascript'>alert('"+msg+"')</script>");
        }
    %>
    <div class="main">
        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" onsubmit="return preRegister()">
            <table>
                <tr>
                    <td>账号：</td>
                    <td><input type="text" id="user" name="user" class="main_table_text"></td>
                </tr>
                <tr>
                    <td>邮箱：</td>
                    <td><input type="text" id="emailAddress" name="emailAddress" class="main_table_text"></td>
                </tr>
                <tr>
                    <td>验证码：</td>
                    <td>
                        <input type="text" id="captcha" name="captcha" placeholder="请输入验证码" disabled="true" style="width: 200px; height: 35px;">&nbsp;
                        <input type="button" id="sendCode" value="点击发送" onclick="reClick()" style="height: 35px;">
                    </td>
                </tr>
                <tr>
                    <td>密码：</td>
                    <td><input type="password" name="password" id="password" placeholder="含大小写字母" class="main_table_text" onkeyup="myFunction3()"></td>
                </tr>
                <div id="pwStrongth"><span id="innerprogress"></span></div>
                <tr>
                    <td>确认密码：</td>
                    <td><input type="password" id="againPW" name="confirm" class="main_table_text"></td>
                </tr>
                <tr>
                    <td>昵称：</td>
                    <td><input type="text" name="name" id="name" class="main_table_text"></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="checkbox" id="check" disabled="true"/><span class="agree">我已阅读并同意</span>
                        <a href="javascript: void(0)" onclick="document.getElementById('HiddenDiv').style.display='block'">《服务条款》</a>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" value="确定">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="Login.jsp">我有账号，登录</a></td>
                </tr>
            </table>
        </form>
    </div>
    <div class="HiddenDiv" id="HiddenDiv">
        <div style="margin-top: 40px;">
            <h2 style="text-align: center">服务条款</h2>
        </div>
        <div id="Hidden_content">
            1.&nbsp;&nbsp;本网站仅供娱乐。<br/><br/>
            2.&nbsp;&nbsp;建站初衷只为了练手，所以如果有什么业务逻辑上的不足请见谅。<br/><br/>
            3.&nbsp;&nbsp;防患于未然，注册账户的邮箱，之后若不再登录请解绑。<br/><br/>
            4.&nbsp;&nbsp;666
        </div>
        <div>
            <input type="button" value="同意" onclick="document.getElementById('HiddenDiv').style.display='none';check();">
        </div>
    </div>
</body>
</html>
