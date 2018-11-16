package servlet;

import JDBC.GetStatement;
import dao.Accounts;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * 用户注册
 */
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Accounts accounts = new Accounts();
        Statement stmt = GetStatement.getState();
        ResultSet rs = null;
        String sql = null;
        if (session.getAttribute("captcha").equals(req.getParameter("captcha"))) {
            session.setAttribute("captcha", Math.random()*10000+"");

            //获取格式化系统时间
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Calendar now = Calendar.getInstance();
            String time = simpleDateFormat.format(now.getTime());

            sql = "select count(*) from accounts where user =" + req.getParameter("user");
            try {
                //账户合法性检查
                rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    if (rs.getInt(1) == 1) {
                        req.setAttribute("msg", "该用户已存在, 请重新输入");
                        req.getRequestDispatcher("/RegisterUser.jsp").forward(req, resp);
                    }
                }
                sql = "select count(*) from accounts where email = '"+req.getParameter("emailAddress")+"'";
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    if (rs.getInt(1) == 1) {
                        req.setAttribute("msg", "该邮箱已被使用, 请重新输入");
                        req.getRequestDispatcher("/RegisterUser.jsp").forward(req, resp);
                    }
                }
                sql = "insert into accounts values (" + req.getParameter("user") + ",'" + req.getParameter("password") + "','" + req.getParameter("name") + "','" + time + "','Image\\\\default.jpg',0,0,null,0,0,'"+req.getParameter("emailAddress")+"','0000-00-00 00:00:00')";
                if (stmt.executeUpdate(sql) == 1) {
                    req.setAttribute("msg","注册成功！");
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }else{
            req.setAttribute("msg","验证码错误:(");
            req.getRequestDispatcher("/RegisterUser.jsp").forward(req, resp);
        }
    }
}
