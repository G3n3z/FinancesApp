package com.finances.backend.data.sevices;


import com.finances.backend.data.conection.ConnectionFactory;
import com.finances.backend.data.entity.Transaction;
import com.finances.backend.payload.request.TransationDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;


@Service
public class SqlTransationService {

    @Autowired
    SqlCategoryService categoryService;

    @Autowired
    SqlAcountService acountService;

    public Long registTransition(TransationDto dto, long userId, long accountId, long categoryId, Connection connection){
        PreparedStatement stm = null;
        try {

            String query = "INSERT INTO transation(name_transaction, date, amount, id_user, id_account, id_category) values " +
                    "(?,?,?,?,?,?)";
            stm = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, dto.getName());
            stm.setString(2, dto.getData());
            stm.setDouble(3, dto.getAmount());
            stm.setLong(4,userId);
            stm.setLong(5,accountId);
            stm.setLong(6,categoryId);

            stm.execute();
            ResultSet res = stm.getGeneratedKeys();
            res.next();
            return res.getLong(1);

        } catch (SQLException e) {
            return null;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }

    }

    public List<TransationDto> getAllTransactionById(Long id) {

        TransationDto dto;
        try {
            Connection connection = ConnectionFactory.getConection();
            String query = "SELECT * from transation where id_user = ?";
            PreparedStatement stm = connection.prepareStatement(query);
            stm.setLong(1, id);
            stm.execute();
            ResultSet res = stm.getResultSet();
            List<TransationDto> listTransactionsDto = new ArrayList<>();
            while(res.next()){
                 listTransactionsDto.add(getTransactionDtoByResultSet(res));
            }

            return listTransactionsDto;

        } catch (SQLException e) {
            return null;
        }

    }

    private TransationDto getTransactionDtoByResultSet(ResultSet res) {
        TransationDto dto = new TransationDto();
        try {
            dto.setAmount(res.getDouble("amount"));
            dto.setData(res.getDate("date").toString());
            dto.setName(res.getString("name_transaction"));
            dto.setAccount(Long.toString(res.getLong("id_account")));
            dto.setCategory(Long.toString(res.getLong("id_category")));
            return dto;
        }catch (Exception e ){
            return null;
        }
    }

    public List<Transaction> getTransactionWithSortAndPagination(int month, int year, String order,String orderField, int pageSize, int pageNumber,
                                                                 Long idUser, Connection connection) {
        List<Transaction> list = new ArrayList<>();
        PreparedStatement stm = null;
        int deslocation = pageSize * pageNumber;
        orderField = getOrderField(orderField);
        try {

            String query = "Select * " +
                    "from transation, Categories, Account " +
                    "where transation.id_user = ? " +
                    "and transation.id_account = Account.id_account \n" +
                    "and Categories.id_category = transation.id_category \n" +
                    "and DATE_FORMAT(transation.date, '%Y-%m') = ?";
            if(order.equals("asc"))
                query = query + " order by " + orderField + " Limit ?, ?";
            else {
                query = query + " order by " + orderField + " desc Limit ?, ?";
            }
            month--;
            Calendar calendar = new GregorianCalendar(year, month, 1);

            String date = new SimpleDateFormat("yyyy-MM").format(calendar.getTime());
            stm = connection.prepareStatement(query);
            stm.setLong(1,idUser);
            stm.setString(2,date);
            stm.setInt(3,deslocation);
            stm.setInt(4,pageSize);

            stm.execute();
            ResultSet res = stm.getResultSet();
            while(res.next()){
                list.add(getTransactionByResultSet(res));
            }


        } catch (SQLException e) {
            return null;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }

        return list;
    }

    private String getOrderField(String orderField) {
        switch (orderField){
            case "amount":
                return "amount";
            case "category":
                return "name_category";
            case "account":
                return "name_account";
            default:
                return "date";
        }
    }

    private Transaction getTransactionByResultSet(ResultSet res) {
        Transaction transaction = new Transaction();
        try {
            transaction.setId(res.getLong("id_transation"));
            transaction.setAmount(res.getDouble("amount"));
            transaction.setDate(res.getDate("date"));
            transaction.setName(res.getString("name_transaction"));
            transaction.setAccount(acountService.getAccountFromResultSetWithoutUser(res));
            transaction.setCategory(categoryService.getCategoryFromResultSet(res));
            return transaction;
        }catch (Exception e ){
            return null;
        }
    }
}
