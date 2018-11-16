package servlet;

import JDBC.GetStatement;
import service.CutPicture;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;

public class PhotoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Calendar calendar = Calendar.getInstance();
        int x = Integer.parseInt(req.getParameter("x"));
        int y = Integer.parseInt(req.getParameter("y"));
        int finalWidth = Integer.parseInt(req.getParameter("finalWidth"));
        int finalHeight = Integer.parseInt(req.getParameter("finalHeight"));
        String photoPath = null;

        // 当用户未上传新图片而是尝试剪裁自己的头像时，系统获取不到上传路径，将源文件剪裁并按毫秒值创建新图片文件
        if (session.getAttribute("filePath") == null){

            long Mills = calendar.getTimeInMillis();
            // 新头像路径
            String srcMillsFile = "D:\\Work Space\\BBS\\web\\upload\\"+Mills+".jpg";
            // 原头像路径
            String profilePhoto = "D:\\Work Space\\BBS\\web\\"+session.getAttribute("profilePhoto");

            CutPicture.abscut(profilePhoto, srcMillsFile, x*2, y*2, 80*2, 80*2, finalWidth*2, finalHeight*2);

            //新头像创建成功，删除原头像，若用户原头像为默认头像，不删除
            if ( !session.getAttribute("profilePhoto").equals("Image\\default.jpg") ){
                File file = new File(profilePhoto);
                file.delete();
            }

            photoPath = "upload\\\\" + Mills + ".jpg";
        }else{

            // 用户上传了新的图片
            // 图片最终宽高即 destWidth, destHeight 参数应与预览图宽高一致，本网页预览图宽高同为 80px ，若不一致（参数中为80*2），
            // 则其他参数应与图片最终宽高的比例保持相同（本方法参数都 *2）
            CutPicture.abscut(session.getAttribute("filePath").toString(), null, x*2, y*2, 80*2, 80*2, finalWidth*2, finalHeight*2);

            if ( !session.getAttribute("oldPhoto").equals("Image\\default.jpg") ) {
                // 头像创建成功 删除原头像
                File file = new File("D:\\Work Space\\BBS\\web\\" + session.getAttribute("oldPhoto"));
                file.delete();
            }

            photoPath = "upload\\\\" + session.getAttribute("profilePhoto").toString().substring(6);
        }


        //成功上传头像，为用户保存头像
        Statement stmt = GetStatement.getState();
        String sql = "update accounts set profilePhoto = '"+photoPath+"' where user = "+session.getAttribute("user");
        try{
            if (stmt.executeUpdate(sql) == 1){
                if (session.getAttribute("filePath") == null){
                    //将新路径传给 session
                    session.setAttribute("profilePhoto", photoPath);
                }
                req.setAttribute("msg", "头像设置成功 :)");
                req.setAttribute("JumpTo" ,"UserInfo.jsp");
                req.getRequestDispatcher("pass.jsp").forward(req, resp);
            }
        }catch (SQLException ex){
            ex.printStackTrace();
        }
    }
}
