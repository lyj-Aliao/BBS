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
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class SendPostAndCommentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Statement stmt = GetStatement.getState();
        ResultSet rs = null;
        //获取格式化系统时间
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar now = Calendar.getInstance();
        String time = simpleDateFormat.format(now.getTime());
        String sql = null;

        //发帖
        if (req.getParameter("hidden").equals("fromPost")){
            sql = "insert into post (title, comment, createAccount, time, priority, clickCount, isHot, userID) values ('"+req.getParameter("title")+"','"+req.getParameter("content")+"','"+session.getAttribute("name")+"','"+time+"',0,0,0,'"+session.getAttribute("user")+"')";
            try{
                if (stmt.executeUpdate(sql) == 1){
                    req.setAttribute("msg", "帖子提交成功 :)");
                    req.getRequestDispatcher("Post.jsp").forward(req, resp);
                }
            }catch (SQLException ex){
                ex.printStackTrace();
            }
        }

        //发评论
        if (req.getParameter("hidden").equals("fromComment")){
            sql = "insert into comment (pID, content, createAccount, time, fID, replyID, userID) values ("+session.getAttribute("pid")+", '"+req.getParameter("content")+"', '"+session.getAttribute("name")+"', '"+time+"',0,0,"+session.getAttribute("user")+")";
            try{
                if (stmt.executeUpdate(sql) == 1){
                    resp.sendRedirect("/BBS/Comment.jsp");
                }
            }catch (SQLException ex){
                ex.printStackTrace();
            }
        }

        //回复评论
        if (req.getParameter("hidden").equals("replyComment")){
            sql = "insert into comment (pID, content, createAccount, time, fID, replyID, userID) values (0, '"+req.getParameter("content")+"', '"+session.getAttribute("name")+"', '"+time+"',"+req.getParameter("hidden1")+",0,"+session.getAttribute("user")+")";
            try{
                if (stmt.executeUpdate(sql) == 1){
                    resp.sendRedirect("/BBS/Comment.jsp");
                }
            }catch (SQLException ex){
                ex.printStackTrace();
            }
        }

        //回复子评论
        if (req.getParameter("hidden").equals("replySonComment")){
            sql = "insert into comment (pID, content, createAccount, time, fID, replyID, userID) values (0, '"+req.getParameter("content")+"', '"+session.getAttribute("name")+"', '"+time+"',"+req.getParameter("hidden1")+","+req.getParameter("hidden2")+","+session.getAttribute("user")+")";
            try{
                if (stmt.executeUpdate(sql) == 1){
                    resp.sendRedirect("/BBS/Comment.jsp");
                }
            }catch (SQLException ex){
                ex.printStackTrace();
            }
        }
    }
}
