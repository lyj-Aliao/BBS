package filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

public class CharacterFilter implements javax.servlet.Filter {
    @Override
    public void destroy() {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)throws IOException, ServletException, UnsupportedEncodingException {
        //处理 doPost 字符编码问题
        servletRequest.setCharacterEncoding("utf-8");

        HttpServletRequest req= (HttpServletRequest) servletRequest;
        /**
         * 处理get请求的编码问题
         */
//        String username=request.getParameter("username");
//        username=new String(username.getBytes("ISO-8859-1"),"utf-8");

        /**
         * 调包request
         * 1.写一个request的装饰类
         * 2.在放行时，使用我们自己的request
         */
        if (req.getMethod().equals("GET")) {
            EncodingRequest er = new EncodingRequest(req);

            filterChain.doFilter(er, servletResponse);
        }else if (req.getMethod().equals("POST")){
            filterChain.doFilter(servletRequest, servletResponse);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {

    }
}
