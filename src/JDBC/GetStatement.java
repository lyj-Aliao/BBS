package JDBC;

import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.*;

public class GetStatement {
    public static Statement getState() {
        /*
         *1.创建连接池对象
         *2.配置四大参数
         *3.配置池参数
         *4.得到连接对象
         */
        Connection con = null;
        Statement stmt = null;
        BasicDataSource dataSource=new BasicDataSource();

        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://47.99.218.86:3306/bbs?useUnicode=true&characterEncoding=UTF-8");
        dataSource.setUsername("root");
        dataSource.setPassword("");

        dataSource.setMaxTotal(20);
        dataSource.setMinIdle(3);
        dataSource.setMaxWaitMillis(1000);

        try{
            con=dataSource.getConnection();
            stmt = con.createStatement();
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        return stmt;
    }
}
