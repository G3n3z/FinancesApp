package com.finances.backend.data.sevices;

import com.finances.backend.data.conection.ConnectionFactory;
import com.finances.backend.data.entity.Category;
import com.finances.backend.data.entity.CategoryDto;
import com.finances.backend.data.entity.Transaction;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

@Component
public class SqlCategoryService {

    public Transaction registCategory(){
        return null;
    }

    public Category getCategoryByIds(Long id, long id_category) {
        try {
            Connection connection = ConnectionFactory.getConection();
            String query = "Select * from Categories, user_category where user_category.id_user = ? \n " +
                    "and user_category.id_category = Categories.id_category\n" +
                    "and Categories.id_category = ?";
            PreparedStatement stm = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            stm.setLong(1, id);
            stm.setLong(2, id_category);

            stm.execute();
            ResultSet res = stm.getResultSet();
            res.next();

            Category c = new Category();
            c.setId(res.getLong("id_category"));
            c.setName(res.getString("name"));
            return c;

        } catch (SQLException e) {
            return null;
        }

    }

    public boolean existsRelationCategoryUser(String category, long userId) {
        try {
            int result = 0;
            Connection connection = ConnectionFactory.getConection();
            String query = "SELECT  count(*) as cont from user_category, (SELECT id_category as id from Categories where Categories.name_category = ?) t1 " +
                        "where user_category.id_category = t1.id" +
                        " and user_category.id_user = ?";
            PreparedStatement stm = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, category);
            stm.setLong(2, userId);

            stm.execute();
            ResultSet res = stm.getResultSet();
            if(res.next())
            {
                result = res.getInt("cont");

            }
            return result>0;

        } catch (SQLException e) {
            return false;
        }
    }

    public long getUserCategoryByCategoryNameAndUserId(String category, long userId) {
        try {
            int result = 0;
            Connection connection = ConnectionFactory.getConection();
            String query = "SELECT  id_category from user_category, (SELECT id_category as id from Categories where Categories.name_category = ?) t1 " +
                    "where user_category.id_category = t1.id" +
                    " and user_category.id_user = ?";
            PreparedStatement stm = connection.prepareStatement(query);
            stm.setString(1, category);
            stm.setLong(2, userId);

            stm.execute();
            ResultSet res = stm.getResultSet();
            if(res.next())
            {
                return res.getLong(1);

            }
            return -1L;

        } catch (SQLException e) {
            return -1L;
        }
    }


    public boolean createCategory(CategoryDto request, Long idUser, Connection connection) {
        Long idCategory = insertCategory(request, connection);
        if(idCategory == -1L){
            return false;
        }
        return insertRelationshipBetweenUserAndCategory(idCategory, idUser, connection);
    }

    private boolean insertRelationshipBetweenUserAndCategory(Long idCategory, Long idUser, Connection connection) {

        String query = "INSERT INTO user_category(id_user, id_category)values (?, ?)";
        PreparedStatement stm = null;
        try {
            stm = connection.prepareStatement(query);
            stm.setLong(1, idUser);
            stm.setLong(2, idCategory);
            stm.execute();
            return true;

        } catch (SQLException e) {
            return false;
        }finally {
            assert stm != null;
            ConnectionFactory.closeStatement(stm);
        }

    }

    private Long insertCategory(CategoryDto request, Connection connection) {
        String query1 = "INSERT INTO Categories(name_category)values (?)";
        PreparedStatement stm = null;
        try {
            stm = connection.prepareStatement(query1, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, request.getName());
            stm.execute();
            ResultSet res = stm.getGeneratedKeys();
            if(res.next()){
                return res.getLong(1);
            }

        } catch (SQLException e) {
            return -1L;
        }finally {
            assert stm != null;
            ConnectionFactory.closeStatement(stm);
        }
        return -1L;
    }

    public Category getCategoryFromResultSet(ResultSet res) {
        try{
            Category category = new Category();
            category.setId(res.getLong("id_category"));
            category.setName(res.getString("name_category"));

            return category;
        }catch (SQLException e){
            return null;
        }
    }

    public Map<String, Double> getCostsByCategory(Long idUser, Connection connection, int year, int month) {

        Map<String, Double> costs = new HashMap<>();

        String query1 = "Select IFNULL(sum(t1.amount),0) total, t2.name \n" +
                "from (SELECT id_category, amount " +
                        "FROM transation where transation.id_user = ? and amount < 0 " +
                        "and date_format(date, '%Y-%m') = ? ) t1 \n" +
                "RIGHT JOIN  (Select Categories.id_category as id_Cat, Categories.name_category as name \n" +
                              "from Categories, user_category\n" +
                              "where Categories.id_category = user_category.id_category\n" +
                            "and user_category.id_user = ?) as t2 on  t1.id_category = t2.id_Cat \n" +
                "group by t2.id_cat;";
        PreparedStatement stm = null;

        month--;
        Calendar calendar = new GregorianCalendar(year, month, 1);

        String date = new SimpleDateFormat("yyyy-MM").format(calendar.getTime());
        try {
            stm = connection.prepareStatement(query1);
            stm.setLong(1,idUser);
            stm.setString(2, date);
            stm.setLong(3,idUser);
            stm.execute();
            ResultSet res = stm.getResultSet();
            while (res.next()){
                costs.put(res.getString("name"), res.getDouble("total"));
            }

        } catch (SQLException e) {
            return costs;
        }finally {
            assert stm != null;
            ConnectionFactory.closeStatement(stm);
        }
        return costs;



    }
}
