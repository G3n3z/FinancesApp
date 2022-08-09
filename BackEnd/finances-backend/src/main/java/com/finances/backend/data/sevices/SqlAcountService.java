package com.finances.backend.data.sevices;

import com.finances.backend.data.conection.ConnectionFactory;
import com.finances.backend.data.entity.Account;
import org.springframework.stereotype.Component;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

@Component
public class SqlAcountService {

    public boolean updateAccount(double value, long userId, String name, Connection connection){
        PreparedStatement stm = null;
        try {
            String query = "Update Account \n set balance = balance + ? \n" +
                    "where id_user = ? and name_account = ?";
            stm = connection.prepareStatement(query);
            stm.setDouble(1, value);
            stm.setLong(2, userId);
            stm.setString(3, name);

            stm.execute();
        }catch (SQLException e){
            return false;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }


        return true;
    }

    public boolean registerAccount(Account account, Connection connection){
        String sql = "Insert into Account(name_account, balance,id_user) value (?, ?,?)";
        if(existsAccountWithName(account.getUser().getId(), account.getName(), connection)){
            return false;
        }

        PreparedStatement stm = null;
        try {
            stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, account.getName());
            stm.setDouble(2, account.getBalance());
            stm.setLong(3, account.getUser().getId());
            stm.execute();
        } catch (SQLException e) {
            return false;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }

        return true;
    }

    public boolean registerDefaultAccount(long idUser, Connection connection){
        String sql = "Insert into Account(name_account, balance,id_user) value (?, ?,?)";
        PreparedStatement stm = null;
        try {
            stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, "Carteira");
            stm.setDouble(2, 0);
            stm.setLong(3, idUser);
            stm.execute();
        } catch (SQLException e) {
            return false;
        }finally {
            if (stm != null)
                ConnectionFactory.closeStatement(stm);
        }
       return true;
    }

    public boolean existsAccountWithName(Long id, String name, Connection connection){
        String sql = "SELECT name_account from Account where name_account = ? and id_user = ?";
        boolean result = false;

        PreparedStatement stm = null;
        try {
            stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, name);
            stm.setLong(2, id);
            stm.execute();
            ResultSet res = stm.getResultSet();
            if(res.next()){
                result = true;
            }
        } catch (SQLException e) {
            return false;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }
        return result;
    }

    public Account getAccountByIdAndNameAccount(long userId, String nameAccount, Connection connection ) {
        String sql = "SELECT id_account, name_account, balance from Account where id_user = ? and name_account = ?";
        PreparedStatement stm = null;
        Account account = null;
        try {
            stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setLong(1, userId);
            stm.setString(2, nameAccount);
            stm.execute();
            ResultSet res = stm.getResultSet();
            account = new Account();
            if(res.next()){
                account.setId(res.getLong("id_account"));
                account.setName(res.getString("name_account"));
                account.setBalance(res.getDouble("balance"));

            }
        } catch (SQLException e) {
            return null;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }
        return account;

    }

    public Account getAccountByIdAndIdAccount(Long id, Long accountId) {

        String sql = "SELECT id_account, name_account, balance from Account where id_user = ? and id_account = ?";
        Connection connection = null;
        PreparedStatement stm = null;
        Account account = null;
        try {
            connection = ConnectionFactory.getConection();
            stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setLong(1, id);
            stm.setLong(2, accountId);
            stm.execute();
            ResultSet res = stm.getResultSet();
            account = new Account();
            if(res.next()){
                account.setId(res.getLong("id_account"));
                account.setName(res.getString("name_account"));
                account.setBalance(res.getDouble("balance"));

            }
        } catch (SQLException e) {
            return null;
        }finally {
            ConnectionFactory.closeConnectionAndStatement(connection, stm);
        }
        return account;

    }

    public Account getAccountFromResultSetWithoutUser(ResultSet res){
        Account a = new Account();
        try {
            a.setId(res.getLong("id_account"));
            a.setName(res.getString("name_account"));
            a.setBalance(res.getDouble("balance"));
        }catch (SQLException e){
            return null;
        }
        return a;
    }

    public double getAmountTotal(Long idUser, Connection connection) {

        String sql = "SELECT sum(balance) as total from Account where id_user = ?";
        PreparedStatement stm = null;
        Account account = null;
        try {
            stm = connection.prepareStatement(sql);
            stm.setLong(1, idUser);
            stm.execute();
            ResultSet res = stm.getResultSet();
            account = new Account();
            if(res.next()){
                return res.getDouble("total");
            }
        } catch (SQLException e) {
            return -1L;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }
        return -1L;
    }

    public Map<String, Double> getCostsByAccount(Long idUser, Connection connection, int year, int month) {
        Map<String, Double> costs = new HashMap<>();

        String sql = "Select IFNULL(sum(t1.amount),0) total, t2.name\n" +
                "from   (SELECT id_account, amount \n" +
                "         FROM transation where transation.id_user = ? and amount <= 0\n" +
                "          and date_format(date, '%Y-%m') = ?) t1\n" +
                "RIGHT JOIN  (Select Account.id_account as id_acc, Account.name_account as name\n" +
                            " from Account\n" +
                            " where Account.id_user = ?) as t2 on  t1.id_account = t2.id_acc\n" +
                "group by t2.name;";
        PreparedStatement stm = null;
        month--;
        Calendar calendar = new GregorianCalendar(year, month, 1);

        String date = new SimpleDateFormat("yyyy-MM").format(calendar.getTime());
        try {
            stm = connection.prepareStatement(sql);
            stm.setLong(1, idUser);
            stm.setString(2, date);
            stm.setLong(3, idUser);
            stm.execute();
            ResultSet res = stm.getResultSet();
            while(res.next()){
                 costs.put( res.getString("name"),res.getDouble("total"));
            }

        } catch (SQLException e) {
            return costs;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }
        return costs;

    }
}
