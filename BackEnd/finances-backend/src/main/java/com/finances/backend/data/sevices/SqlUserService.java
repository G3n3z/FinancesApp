package com.finances.backend.data.sevices;

import com.finances.backend.data.conection.ConnectionFactory;
import com.finances.backend.data.entity.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.sql.*;

@Component
public class SqlUserService {



    public User getUserByEmail(String email, Connection connection)  {


        Statement stm = null;
        try {
            stm = connection.createStatement();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        String query = "Select * from user where email = " + "'" + email + "'";
        ResultSet res = null;
        try {
            res = stm.executeQuery(query);
            User user = new User();
            res.next();
            user.setId(res.getInt("id_user"));
            user.setEmail(res.getString("email"));
            user.setName(res.getString("nome"));
            user.setPassword(res.getString("password"));
            user.setNationality(res.getString("nacionalidade"));
            user.setAge(res.getInt("idade"));
            stm.close();
            //connection.close();
            return user;
        } catch (SQLException e) {
            return null;
        }finally {
            //ConnectionFactory.closeStatement(stm);
        }


    }

    public Long getUserIdByEmail(String email){
        Connection connection = null;
        Statement stm = null;
        try {
            connection = ConnectionFactory.getConection();
            stm = connection.createStatement();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        String query = "Select id_user from user where email = " + "'" + email + "'";
        ResultSet res = null;
        try {
            res = stm.executeQuery(query);
            User user = new User();
            res.next();
            Long id =  res.getLong("id_user");
            stm.close();
            connection.close();
            return id;
        } catch (SQLException e) {
            return null;
        }

    }

    public User registerUser(User user, Connection connection)  {


        PreparedStatement stm = null;
        long id = -1;
        try {
            String passwordEncode = new BCryptPasswordEncoder().encode(user.getPassword());
            String sql = "Insert into user(email, nome, password, nacionalidade, idade) values(?,?,?,?,?)";
            stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, user.getEmail());
            stm.setString(2, user.getName());
            stm.setString(3, passwordEncode);
            stm.setString(4, user.getNationality());
            stm.setInt(5, user.getAge());


            stm.execute();
            ResultSet rs = stm.getGeneratedKeys();
            if(rs.next()){
                id = rs.getInt(1);
                user.setId(id);
            }


        } catch (SQLException e) {
            return null;
        }finally {
            if(stm != null) {
                ConnectionFactory.closeStatement(stm);
            }
        }

        return user;
    }


    public void deleteUser(long id) {
    }
}
