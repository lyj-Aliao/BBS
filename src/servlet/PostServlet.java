package servlet;

import JDBC.GetStatement;
import dao.Post;

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

public class PostServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Statement stmt = GetStatement.getState();
        ResultSet rs = null;
        String sql = null;

        // 恢复所有用户签到可用 isChecked = 0
        if(Integer.parseInt(req.getParameter("check")) == 1){
            sql = "select isChecked from bbs.accounts where user ="+session.getAttribute("user");
            try{
                rs = stmt.executeQuery(sql);
                while (rs.next()){
                    session.setAttribute("isChecked", rs.getInt(1)+"");
                }
            }catch (SQLException ex){
                ex.printStackTrace();
            }
            resp.sendRedirect("/BBS/Post.jsp");
        }

        // 签到功能
        if ("签到".equals(req.getParameter("checkIn"))){

            //签到天数加1
            int checkIn = Integer.parseInt(session.getAttribute("checkIn").toString()) + 1;

            //签到状态为 0 才能签到
            if (session.getAttribute("isChecked").equals("0")) {

                sql = "update accounts set checkIn = "+checkIn+" where user = "+session.getAttribute("user");
                try{
                    stmt.executeUpdate(sql);
                    req.setAttribute("msg","签到成功, 明天再来吧 :)");
                    //签到成功，修改签到状态为 1
                    sql = "update accounts set isChecked = 1 where user = "+session.getAttribute("user");
                    stmt.executeUpdate(sql);
                    //获取签到排名
                    sql = "select u.rank from ( select user,(@rank:=@rank+1) as rank from accounts,( select (@rank :=0) ) b order by accounts.checkIn desc ) u where u.user ="+session.getAttribute("user");
                    rs = stmt.executeQuery(sql);
                    while (rs.next()){
                        Integer rank = rs.getInt(1);
                        session.setAttribute("rank",rank.toString());
                    }
                }catch (SQLException ex){
                    ex.printStackTrace();
                }
                session.setAttribute("isChecked","1");
                session.setAttribute("checkIn",String.valueOf(checkIn));
                req.getRequestDispatcher("/Post.jsp").forward(req, resp);
            }else {
                //刷新页面 ，签到状态为 1 ，无法签到, 重定向回 Title
                resp.sendRedirect("/BBS/Post.jsp");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Statement stmt = GetStatement.getState();
        Statement stmt1 = GetStatement.getState();
        ResultSet rs = null;
        ResultSet rs1 = null;
        String sql = null;
        List<Post> normalPosts = new ArrayList<Post>();
        List<Post> topPosts = new ArrayList<Post>();

        //获取普通和加精帖子总数和分页, 每页显示8个帖子, 将生成的页数保存到 session
        sql = "select count(*) from post where priority in (0,1) ";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                if (rs.getInt(1)%8 > 0){
                    session.setAttribute("page", rs.getInt(1)/8 + 1);
                }else{
                    session.setAttribute("page", rs.getInt(1)/8);
                }
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }

        // 获取置顶帖子
        sql = "select accounts.profilePhoto, post.* from accounts, post where post.createAccount = accounts.name and priority = 2";
        try{
            rs = stmt.executeQuery(sql);
            while(rs.next()){
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setCreateAccount(rs.getString("createAccount"));
                post.setTime(rs.getString("time").substring(0,10));
                post.setProfilePhoto(rs.getString("profilePhoto"));

                //获取评论数
                sql = "select count(*) from comment,post where post.id = comment.pid and post.id = "+rs.getInt("id")+" and post.priority = 2 and fid = 0";
                rs1 = stmt1.executeQuery(sql);
                if(rs1.next()){
                    post.setCountByComment(rs1.getInt(1));
                }

                topPosts.add(post);
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }

        // 按当前页数获取帖子列表，首次加载从第一页获取
        int start = (Integer.parseInt(req.getParameter("page"))-1)*8;
        session.setAttribute("current_page", req.getParameter("page"));
        sql = "select accounts.profilePhoto, post.* from accounts, post where post.createAccount = accounts.name and priority in (0,1) order by id desc limit "+start+",8";
        try{
            rs = stmt.executeQuery(sql);
            while(rs.next()){
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setCreateAccount(rs.getString("createAccount"));
                post.setTime(rs.getString("time").substring(0,10));
                post.setProfilePhoto(rs.getString("profilePhoto"));
                post.setPriority(rs.getInt("priority"));
                //获取评论数
                sql = "select count(*) from comment,post where post.id = comment.pid and post.id = "+rs.getInt("id")+" and post.priority in (0,1) and fid = 0";
                rs1 = stmt1.executeQuery(sql);
                if(rs1.next()){
                    post.setCountByComment(rs1.getInt(1));
                }

                normalPosts.add(post);
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }

        // 获取帖子、评论、用户和签到数目
        sql = "select count(*) from post";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                session.setAttribute("countByPost", ""+rs.getInt(1));
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        sql = "select count(*) from comment";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                session.setAttribute("countByComment", ""+rs.getInt(1));
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        sql = "select count(*) from accounts";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                session.setAttribute("countByAccounts", ""+rs.getInt(1));
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        sql = "select sum(checkIn) from accounts";
        try{
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                session.setAttribute("sumByCheckIn", ""+rs.getInt(1));
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        session.setAttribute("normalPosts", normalPosts);
        session.setAttribute("topPosts", topPosts);
        resp.sendRedirect("/BBS/Post.jsp");
    }
}