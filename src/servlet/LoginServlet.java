package servlet;

//import JDBC.GetStatement;
import dao.Accounts;
import service.SendEmail;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 用户登录、注册和修改密码
 */
public class LoginServlet extends HttpServlet {

    // 正则表达式判断用户输入是否为邮箱格式
    Pattern p = Pattern.compile("\\w+@(\\w+.)+[a-z]{2,3}");
    private boolean isEmailFormat(String email){
        Matcher m = p.matcher(email);
        return m.matches();
    }

    // JDBC连接数据库
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://47.99.218.86:3306/bbs?useUnicode=true&characterEncoding=UTF-8";
    static final String USER = "root";
    static final String PASS = "";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ResultSet rs = null;
        Accounts accounts = new Accounts();
        String sql = null;
//        Statement stmt = GetStatement.getState();
//        Statement stmt1 = GetStatement.getState();
        HttpSession session = req.getSession();

        try{
            Connection conn = null;

            // 注册 JDBC 驱动
            Class.forName("com.mysql.jdbc.Driver");
            // 打开链接
            conn = DriverManager.getConnection(DB_URL,USER,PASS);
            // 执行查询
            Statement stmt = conn.createStatement();
            Statement stmt1 = conn.createStatement();

            if ("Login".equals(req.getParameter("hidden"))){
                //验证码
                String rand = (String)req.getSession().getAttribute("rand");
                String checkCode = req.getParameter("checkCode");
                if  (rand.equals(checkCode)){
                    //验证码输入正确
                    //账号密码输入正确,session读取并传送用户信息,保存cookies
                    String user = req.getParameter("user");
                    String password = req.getParameter("password");
                    if (isEmailFormat(user)){
                        sql = "select * from accounts where email = '"+user+"' and password = '"+password+"'";
                    }else{
                        sql = "select * from accounts where user = "+user+" and password = '"+password+"'";
                    }
                    rs = stmt.executeQuery(sql);
                    if (rs.next()){
                        String pw = rs.getString("password");
                        if (pw.equals(password)){

                            //获取格式化系统时间,更新用户最后登录时间
                            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            Calendar now = Calendar.getInstance();
                            String time = simpleDateFormat.format(now.getTime());
                            sql = "update accounts set lastTime = '"+time+"' where user = "+rs.getInt("user");
                            stmt1.executeUpdate(sql);

                            //如果选择记住密码，添加cookies
                            String checkboxs = req.getParameter("remember");
                            if (checkboxs!=null){
                                Cookie cookie1 = new Cookie("user",user);
                                Cookie cookie2 = new Cookie("password",password);
                                //账号密码保存一天
                                cookie1.setMaxAge(60*60*24);
                                cookie2.setMaxAge(60*60*24);
                                resp.addCookie(cookie1);
                                resp.addCookie(cookie2);
                            }

                            if (rs.getString("email") == null){
                                session.setAttribute("email", "未设置邮箱，请在用户设置菜单绑定邮箱");
                            }else {
                                session.setAttribute("email", rs.getString("email"));
                            }
                            session.setAttribute("lastTime", time);
                            session.setAttribute("profilePhoto", rs.getString("profilePhoto")+"");
                            session.setAttribute("user",rs.getInt("user")+"");
                            session.setAttribute("name",rs.getString("name"));
                            session.setAttribute("isChecked",rs.getInt("isChecked")+"");
                            session.setAttribute("checkIn",rs.getInt("checkIn")+"");
                            session.setAttribute("createTime",rs.getString("createTime").substring(0,19));

                            //默认为 null 为之后剪裁原头像做铺垫
                            session.setAttribute("filePath", null);

                            //获取签到排名
                            sql = "select u.rank from ( select user,(@rank:=@rank+1) as rank from accounts,( select (@rank :=0) ) b order by accounts.checkIn desc ) u where u.user = '"+rs.getString("user")+"'";
                            rs = stmt.executeQuery(sql);
                            if (rs.next()){
                                Integer rank = rs.getInt(1);
                                session.setAttribute("rank",rank.toString());
                            }

                            req.setAttribute("msg", "登录成功");
                            //要跳转的网页
                            req.setAttribute("JumpTo", "Post.jsp");
                            req.getRequestDispatcher("pass.jsp").forward(req, resp);
//                            resp.sendRedirect("Post.jsp");
                        }
                    }
                    req.setAttribute("msg","账号或密码错误");
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }else{
                    req.setAttribute("msg","验证码错误");
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }
            }else{
                if (session.getAttribute("captcha").equals(req.getParameter("captcha"))){
                    session.setAttribute("captcha", "dijvbisdvjanscas");
                    // 修改密码
                    sql = "select * from accounts where user = "+req.getParameter("user")+" and email = '"+req.getParameter("emailAddress")+"'";
                    rs = stmt.executeQuery(sql);
                    if (rs.next()){
                        sql = "update accounts set password = '"+req.getParameter("password")+"' where user = "+req.getParameter("user");
                        if (stmt.executeUpdate(sql) == 1) {
                            req.setAttribute("msg", "修改成功！");
                            req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                        }
                    }else{
                        req.setAttribute("msg","账号或昵称输入错误:(");
                        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                    }
                }else{
                    req.setAttribute("msg","验证码错误:(");
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }

            }
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        try {
            int code = SendEmail.sendEmail(req.getParameter("emailAddress"));
            session.setAttribute("captcha", code+"");
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }
}
