package filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.UnsupportedEncodingException;

/*
 *  包装 request，处理 doGet 的字符问题
 */
public class EncodingRequest extends HttpServletRequestWrapper {
    private HttpServletRequest req;

    public EncodingRequest(HttpServletRequest request)
    {
        super(request);
        this.req=request;
    }

    @Override
    public String getParameter(String name) {
        String value=req.getParameter(name);


        //处理编码问题
        try {
            value=new String(value.getBytes("ISO-8859-1"),"utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return value;
    }
}
