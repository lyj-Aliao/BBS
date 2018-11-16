package servlet;

import JDBC.GetStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserInfoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sql = null;
        Statement stmt = GetStatement.getState();
        HttpSession session = req.getSession();
        ResultSet rs = null;
        try{
            if (req.getParameter("hidden").equals("1")){
                if (session.getAttribute("captcha").equals(req.getParameter("captcha"))) {
                    session.setAttribute("captcha", Math.random()*10000+"");
                    sql = "select * from accounts where email = '"+req.getParameter("email")+"'";
                    rs = stmt.executeQuery(sql);
                    if (rs.next()){
                        req.setAttribute("msg","该邮箱已被使用，请重新输入");
                        req.getRequestDispatcher("/UserInfo.jsp").forward(req, resp);
                    }else {
                        sql = "update accounts set email = '"+req.getParameter("email")+"' where user = "+session.getAttribute("user");
                        if (stmt.executeUpdate(sql) == 1){
                            session.setAttribute("email", req.getParameter("email"));
                            resp.sendRedirect("/BBS/UserInfo.jsp");
                        }else {
                            req.setAttribute("msg","邮箱设置失败");
                            req.getRequestDispatcher("/UserInfo.jsp").forward(req, resp);
                        }
                    }
                }else{
                    req.setAttribute("msg","验证码错误:(");
                    req.getRequestDispatcher("/UserInfo.jsp").forward(req, resp);
                }

            }else if (req.getParameter("hidden").equals("2")){

                sql = "update accounts set email = null where user = "+session.getAttribute("user");
                if (stmt.executeUpdate(sql) == 1){
                    session.setAttribute("email", "未设置邮箱");
                    resp.sendRedirect("/BBS/UserInfo.jsp");
                }
            }else if (req.getParameter("hidden").equals("3")){

                // 修改昵称
                //1. 检测输入的昵称是否存在，存在则重新输入
                sql = "select * from accounts where name = '"+req.getParameter("name")+"'";
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    req.setAttribute("msg","该昵称已存在，请重新输入");
                    req.getRequestDispatcher("/UserInfo.jsp").forward(req, resp);
                }else{
                    //2. 不存在相同昵称，更新数据
                    sql = "update accounts set name ='"+req.getParameter("name")+"' where user = "+session.getAttribute("user");
                    if (stmt.executeUpdate(sql) == 1){
                        sql = "select name from accounts where user ="+session.getAttribute("user");
                        rs = stmt.executeQuery(sql);
                        if (rs.next()){
                            session.setAttribute("name",rs.getString(1));
                        }
                        resp.sendRedirect("/BBS/UserInfo.jsp");
                    }else{
                        //3. 更新失败，转发
                        req.setAttribute("msg","修改失败");
                        req.getRequestDispatcher("/UserInfo.jsp").forward(req, resp);
                    }
                }
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }
}
