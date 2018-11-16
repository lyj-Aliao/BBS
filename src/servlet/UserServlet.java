package servlet;

import JDBC.GetStatement;
import dao.Comments;
import dao.Post;
import net.sf.json.JSONArray;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Statement stmt = GetStatement.getState();
        ResultSet rs = null;
        try{
            List<Post> postList = new ArrayList<>();
            List<Comments> commentList = new ArrayList<>();
            if (Integer.parseInt(req.getParameter("isOther")) == 1){
                String sql = "select * from accounts where user = "+req.getParameter("userID");
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    session.setAttribute("OtherProfilePhoto", rs.getString("profilePhoto"));
                    session.setAttribute("OtherName", rs.getString("name"));
                    session.setAttribute("OtherCreateTime", rs.getString("createTime").substring(0,19));
                    session.setAttribute("OtherLastTime", rs.getString("lastTime").substring(0,19));
                }
                // 获取发帖数、评论数
                sql = "select count(*) from post where userID = "+req.getParameter("userID");
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    session.setAttribute("OtherPostCount", rs.getInt(1)+"");
                }
                sql = "select count(*) from comment where userID = "+req.getParameter("userID");
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    session.setAttribute("OtherCommentCount", rs.getInt(1)+"");
                }

                // 获取发帖记录、评论记录
                sql = "select * from post where userID = "+req.getParameter("userID")+" order by id desc";
                rs = stmt.executeQuery(sql);
                while (rs.next()){
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTime(rs.getString("time").substring(0,16));
                    post.setTitle(rs.getString("title"));
                    postList.add(post);
                }
                sql = "select *,comment.id as commentID,post.title,post.id as postID from comment,post where post.id = comment.pID and comment.userID = "+req.getParameter("userID")+" order by commentID desc";
                rs = stmt.executeQuery(sql);
                while (rs.next()){
                    Comments comments = new Comments();
                    comments.setId(rs.getInt("postID"));
                    comments.setTime(rs.getString("time").substring(0,16));
                    comments.setContent(rs.getString("content"));
                    comments.setTitle(rs.getString("title"));
                    commentList.add(comments);
                }
                session.setAttribute("OtherPostList", postList);
                session.setAttribute("OtherCommentList", commentList);

                resp.sendRedirect("/BBS/OtherUserInfo.jsp");
            }else{
                // 获取发帖数、评论数
                List list = new ArrayList();
                String sql = "select count(*) from post where userID = "+session.getAttribute("user");
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    list.add(rs.getInt(1));
                    session.setAttribute("PostCount", rs.getInt(1)+"");
                }
                sql = "select count(*) from comment where userID = "+session.getAttribute("user");
                rs = stmt.executeQuery(sql);
                if (rs.next()){
                    list.add(rs.getInt(1));
                    session.setAttribute("CommentCount", rs.getInt(1)+"");
                }

                // 获取发帖记录、评论记录
                sql = "select * from post where userID = "+session.getAttribute("user")+" order by id desc";
                rs = stmt.executeQuery(sql);
                while (rs.next()){
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTime(rs.getString("time").substring(0,11));
                    post.setTitle(rs.getString("title"));
                    postList.add(post);
                }
                sql = "select *,comment.id as commentID,post.title,post.id as postID from comment,post where post.id = comment.pID and comment.userID = "+session.getAttribute("user")+" order by commentID desc";
                rs = stmt.executeQuery(sql);
                while (rs.next()){
                    Comments comments = new Comments();
                    comments.setId(rs.getInt("postID"));
                    comments.setTime(rs.getString("time").substring(0,11));
                    comments.setContent(rs.getString("content"));
                    comments.setTitle(rs.getString("title"));
                    commentList.add(comments);
                }
                resp.getWriter().write(JSONArray.fromObject(list).toString());
                session.setAttribute("postList", postList);
                session.setAttribute("commentList", commentList);
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
