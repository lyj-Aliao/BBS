package service;

import com.sun.mail.util.MailSSLSocketFactory;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.http.HttpServletRequest;

public class SendEmail
{
    //产生 6或5 位随机验证码
    public static int getCode(){
        return (int)(Math.random()*1000000);
    }
    public static int sendEmail(String to) throws Exception
    {
        //随机生成的验证码
        int code = getCode();

        // 发件人电子邮箱
        String from = "844311882@qq.com";

        // 指定发送邮件的主机为 smtp.qq.com 邮件服务器
        String host = "smtp.qq.com";

        // 获取系统属性
        Properties properties = System.getProperties();

        // 设置邮件服务器
        properties.setProperty("mail.smtp.host", host);

        properties.put("mail.smtp.auth", "true");
        MailSSLSocketFactory sf = new MailSSLSocketFactory();
        sf.setTrustAllHosts(true);
        properties.put("mail.smtp.ssl.enable", "true");
        properties.put("mail.smtp.ssl.socketFactory", sf);
        // 获取默认session对象
        Session session = Session.getInstance(properties,new Authenticator(){
            @Override
            public PasswordAuthentication getPasswordAuthentication()
            {
                //发件人邮件用户名、密码
                return new PasswordAuthentication("844311882@qq.com", "staiqjdzgpdxbejg");
            }
        });

        try{
            // 创建默认的 MimeMessage 对象
            MimeMessage message = new MimeMessage(session);

            // Set From: 头部头字段
            message.setFrom(new InternetAddress(from));

            // Set To: 头部头字段
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            // 标题
            message.setSubject("你好，网站向你索要验证码来啦 ~");

            // 内容
            message.setText(code+"");

            // 发送消息
            Transport.send(message);
            System.out.println();
            System.out.println("发送成功");
        }catch (MessagingException ex) {
            System.out.println();
            System.out.println("发送失败");
            ex.printStackTrace();
        }
        return code;
    }
}