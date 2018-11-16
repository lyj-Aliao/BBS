package servlet;

import JDBC.GetStatement;
import dao.Comments;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CommentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Statement stmt = GetStatement.getState();
        Statement stmt1 = GetStatement.getState();
        Statement stmt2 = GetStatement.getState();
        ResultSet rs = null, rs1 = null, rs2 = null;
        List<Comments> list = new ArrayList<Comments>();
        List<Comments> replyList = new ArrayList<Comments>();
        if (0 != Integer.parseInt(req.getParameter("pid"))){
            session.setAttribute("pid", req.getParameter("pid"));
        }
        int fid=0;

        //获取评论总数和分页, 每页显示8个评论
        String sql = "select count(*) from comment where pid = "+session.getAttribute("pid")+" and fid = 0";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                if (rs.getInt(1)%10 > 0){
                    session.setAttribute("page", rs.getInt(1)/10 + 1);
                }else{
                    session.setAttribute("page", rs.getInt(1)/10);
                }
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }


        //获取对应帖子的评论列表
        int start = (Integer.parseInt(req.getParameter("page"))-1)*10;
        session.setAttribute("current_page", req.getParameter("page"));
        sql = "select comment.*,profilePhoto,name from comment,accounts where pid="+session.getAttribute("pid")+" and accounts.name = comment.createAccount limit "+start+",10";
        try{
            rs = stmt.executeQuery(sql);
            while(rs.next()){
                Comments comments = new Comments();
                comments.setProfilePhoto(rs.getString("profilePhoto"));
                comments.setCreateAccount(rs.getString("name"));
                comments.setContent(rs.getString("content"));
                comments.setTime(rs.getString("time").substring(0, 16));
                comments.setId(rs.getInt("id"));
                comments.setUserID(rs.getInt("userID"));

                //获取子评论数
                sql = "select count(*) from comment where fID = "+rs.getInt("id");
                rs1 = stmt1.executeQuery(sql);
                if(rs1.next()){
                    comments.setCountByReply(rs1.getInt(1));
                }

                //获取每条评论下对应的子评论
                sql = "select * from comment where fID = "+rs.getInt("id");
                rs1 = stmt1.executeQuery(sql);
                while (rs1.next()){
                    Comments comments1 = new Comments();
                    comments1.setCreateAccount(rs1.getString("createAccount"));
                    comments1.setContent(rs1.getString("content"));
                    comments1.setTime(rs1.getString("time").substring(0, 16));
                    comments1.setId(rs1.getInt("id"));

                    //获取回复子评论时文本框的填充内容
                    if (rs1.getInt("replyID") != 0){
                        sql = "select * from comment where id ="+rs1.getInt("replyID");
                        rs2 = stmt2.executeQuery(sql);
                        if (rs2.next()){
                            comments1.setReplyAccount(rs2.getString("createAccount"));
                        }
                    }else{
                        comments1.setReplyAccount("");
                    }

                    replyList.add(comments1);
                }
                session.setAttribute("replyList", replyList);

                list.add(comments);
            }
            session.setAttribute("list", list);
        }catch (SQLException ex){
            ex.printStackTrace();
        }

        //获取顶部帖子
        sql = "select post.*,accounts.profilePhoto,name from post,accounts where id = "+session.getAttribute("pid")+" and post.createAccount = accounts.name";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                session.setAttribute("post_photo", rs.getString("profilePhoto"));
                session.setAttribute("post_createAccount", rs.getString("name"));
                session.setAttribute("post_time", rs.getString("time").substring(0, 10));
                session.setAttribute("post_title", rs.getString("title"));
                session.setAttribute("post_comment", rs.getString("comment"));
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }

        resp.sendRedirect("/BBS/Comment.jsp");

    }
}
