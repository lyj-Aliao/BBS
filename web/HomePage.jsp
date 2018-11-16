<%--
  Created by IntelliJ IDEA.
  User: WTH
  Date: 2018/7/19
  Time: 14:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="CSS/HomePage.css">
    <title>欢迎</title>
</head>
<style type="text/css">
    #R1{
        position: absolute;
        top: 0px;
        width: 50%;
        pointer-events: none;
        display: none;
    }
    #Login1{
        position: absolute;
        top: 0px;
        width: 50%;
        pointer-events: none;
        display: none;
    }
    #Admin1{
        position: absolute;
        top: 0px;
        width: 50%;
        pointer-events: none;
        display: none;
    }
</style>
<body style="background: #CB4042">

    <div style="position:absolute; top: 60%; left: 30%">
        <a href="RegisterUser.jsp">
            <img src="Image\R.png" style="position: relative; width: 50%; height: 18%;" id="R"
                 onmousemove="document.getElementById('R1').style.display='block'" onmouseleave="document.getElementById('R1').style.display='none';">
        </a>
            <img src="Image\R1.png" id="R1">
    </div>



    <div style="position:absolute; top: 60%; left: 41%">
        <a href="Login.jsp">
            <img src="Image\Login.png" style="width: 50%; height: 18%;" id="Login"
                 onmousemove="document.getElementById('Login1').style.display='block'" onmouseleave="document.getElementById('Login1').style.display='none';">
        </a>
            <img src="Image\Login1.png" id="Login1">
    </div>



    <div style="position:absolute; top: 60%; left: 53.3%">
        <a href="RegisterAdmin.jsp">
            <img src="Image\Admin.png" style="width: 50%; height: 18%;" id="Admin"
                 onmousemove="document.getElementById('Admin1').style.display='block'" onmouseleave="document.getElementById('Admin1').style.display='none';">
        </a>
            <img src="Image\Admin1.png" id="Admin1">
    </div>
</body>
</html>
