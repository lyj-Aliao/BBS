package servlet;

import JDBC.GetStatement;
import dao.Post;
import net.sf.json.JSONArray;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("utf-8");
        HttpSession session = req.getSession();
        Statement stmt = GetStatement.getState();
        ResultSet rs = null;
        List<Post> postList = new ArrayList<>();
        String keyword = req.getParameter("keyword");
        String sql = "select id,title,comment from post where title like '%"+keyword+"%'";
        try{
            rs = stmt.executeQuery(sql);
            while (rs.next()){
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                postList.add(post);
            }
            // 返回 JSON 格式
            resp.getWriter().write(JSONArray.fromObject(postList).toString());
        }catch (SQLException ex){
            ex.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doGet(req,resp);
    }
}
