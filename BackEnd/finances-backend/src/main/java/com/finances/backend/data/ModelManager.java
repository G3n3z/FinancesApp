package com.finances.backend.data;

import com.finances.backend.data.conection.ConnectionFactory;
import com.finances.backend.data.entity.*;
import com.finances.backend.data.sevices.SqlAcountService;
import com.finances.backend.data.sevices.SqlCategoryService;
import com.finances.backend.data.sevices.SqlTransationService;
import com.finances.backend.data.sevices.SqlUserService;
import com.finances.backend.exception.ApiException;
import com.finances.backend.payload.AccountDto;
import com.finances.backend.payload.UserDto;
import com.finances.backend.payload.request.TransationDto;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ModelManager {
    private final String url = "jdbc:mysql://localhost:3306?verifyServerCertificate=false&useSSL=true";

    private SqlTransationService transationService;
    private SqlAcountService acountService;
    private SqlUserService userService;
    private SqlCategoryService categoryService;

    public ModelManager(SqlTransationService transationService, SqlAcountService acountService,
                        SqlUserService userService, SqlCategoryService categoryService) {
        this.transationService = transationService;
        this.acountService = acountService;
        this.userService = userService;
        this.categoryService = categoryService;
    }

    public boolean loginIsCorrect(String email, String password) {
        return true;
    }



    public boolean registerUser(UserDto userDto)  {
        User user = mapToUser(userDto);
        Connection con;
        try {
            con = ConnectionFactory.getConection();
            con.setAutoCommit(false);
        } catch (SQLException e ){
            throw new ApiException("Error creating user" , HttpStatus.INTERNAL_SERVER_ERROR);
        }
        user = userService.registerUser(user, con);
        if(user != null) {
            if(acountService.registerDefaultAccount(user.getId(), con)){
                ConnectionFactory.commit(con);
                return true;
            }else {
                ConnectionFactory.rollback(con);
                throw new ApiException("Error creating user" , HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        ConnectionFactory.closeConnection(con);
        throw new ApiException("Data of new user corrupted" , HttpStatus.BAD_REQUEST);

    }

    public User mapToUser(UserDto userDto){
        User user = new User();
        user.setAge(userDto.getAge());
        user.setEmail(userDto.getEmail());
        user.setNationality(userDto.getNationality());
        user.setName(userDto.getName());
        user.setPassword(userDto.getPassword());
        return user;
    }


    public Object[] getConnectionAndStatement(){
        Connection connection;
        Statement stm;
        try {
            connection = ConnectionFactory.getConection();
            stm = connection.createStatement();
        } catch (SQLException e) {
            return null;
        }
        return new Object[]{connection, stm};
    }


    public User getUserByEmail(String email)  {
        Object[] o = getConnectionAndStatement();
        Connection connection = (Connection) o[0];
        Statement stm = (Statement) o[1];

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
            connection.close();
            return user;
        } catch (SQLException e) {
            return null;
        }finally {
            ConnectionFactory.closeConnectionAndStatement(connection, stm);
        }


    }

    public boolean updateAccount(double amount, String email){
        Connection connection;
        boolean res;
        try {
            connection = ConnectionFactory.getConection();
        } catch (SQLException e) {
            return false;
        }

        User user = userService.getUserByEmail(email, connection);
        if(user == null){
            ConnectionFactory.closeConnection(connection);
            return false;
        }
        res =  acountService.updateAccount(amount, user.getId(), "Carteira", connection);
        ConnectionFactory.closeConnection(connection);
        return res;

    }




    public AccountDto registerAccount(String email, AccountDto accountDto) {
        Connection connection = null;
        try {
            connection =  ConnectionFactory.getConection();

        } catch (SQLException e) {
            return null;
        }
        User user = userService.getUserByEmail(email, connection);
        userNotFound(user);
        Account account = mapToAccount(accountDto);
        account.setUser(user);
        account.setBalance(0);
        if(!acountService.registerAccount(account, connection)){
            throw new ApiException("Name already exists", HttpStatus.BAD_REQUEST);
        }

        return accountDto;
    }

    private void userNotFound(User user) {
        if(user == null){
            throw new ApiException("Problems finding data of user", HttpStatus.MULTI_STATUS);
        }
    }

    private Account mapToAccount(AccountDto accountDto) {
        Account account = new Account();
        account.setBalance(accountDto.getBalance());
        account.setName(accountDto.getName());
        return account;
    }


    public void createTransaction(TransationDto request, String email) {
        Connection connection;
        boolean res;
        try {
            connection = ConnectionFactory.getConection();
            connection.setAutoCommit(false);
        } catch (SQLException e) {
            throw new ApiException("Isn't possible register transaction" , HttpStatus.INTERNAL_SERVER_ERROR);
        }


        User user = userService.getUserByEmail(email, connection);
        long userId = user.getId();
        Account accountId = acountService.getAccountByIdAndNameAccount(userId,request.getAccount(), connection);
        long categoryID = categoryService.getUserCategoryByCategoryNameAndUserId(request.getCategory(), userId);

        if(categoryID != -1)
        {
            Long transitionId = transationService.registTransition(request, userId, accountId.getId(), categoryID, connection);
            if (transitionId != null) {
                acountService.updateAccount(request.getAmount(), userId, accountId.getName(), connection);
                ConnectionFactory.commit(connection);
                return;
            }else {
                throw new ApiException("Data of transaction is corrupted" , HttpStatus.BAD_REQUEST);
            }
        }
        ConnectionFactory.rollback(connection);
        throw new ApiException("Dont exists " + request.getCategory() + " in " + email + " account", HttpStatus.BAD_REQUEST);
    }



    public List<TransationDto> getAllTransaction(Long id) {
        List<TransationDto> list = transationService.getAllTransactionById(id);
        for (TransationDto transationDto : list) {
            Account a = acountService.getAccountByIdAndIdAccount(id, Long.parseLong(transationDto.getAccount()));
            transationDto.setAccount(a.getName());
            Category c =  categoryService.getCategoryByIds(id, Long.parseLong(transationDto.getCategory()));
            transationDto.setCategory(c.getName());
        }

        return list;
    }

    public void createCategory(CategoryDto request, Long idUser) {
        Connection connection;
        try {
            connection = ConnectionFactory.getConection();
        } catch (SQLException e) {
            throw new ApiException("Problems with Server Database", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        if(!categoryService.createCategory(request, idUser, connection)){
            ConnectionFactory.closeConnection(connection);
            throw new ApiException("Can't register category", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        ConnectionFactory.closeConnection(connection);
    }

    public List<TransationDto> getTransactionWithSortAndPagination(int month, int year, String order,String orderField, int pageSize, int pageNumber, Long idUser) {
        Connection connection;
        try {
            connection = ConnectionFactory.getConection();
        } catch (SQLException e) {
            throw new ApiException("Problems with Server Database", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        List<Transaction> list = transationService.getTransactionWithSortAndPagination(month, year,order,orderField,pageSize, pageNumber, idUser, connection);

        List<TransationDto> listDto = new ArrayList<>();
        for (Transaction transaction : list) {
            listDto.add(mapToTransactioDto(transaction));
        }

        return listDto;
    }

    private TransationDto mapToTransactioDto(Transaction transaction) {
        if(transaction == null){
            return null;
        }
        return new TransationDto(transaction.getName(),transaction.getCategory().getName(),transaction.getAccount().getName(),
                transaction.getDate().toString(), transaction.getAmount());
    }

    public double getAmountTotal(Long idUser) {
        Connection connection;
        try {
            connection = ConnectionFactory.getConection();
        } catch (SQLException e) {
            throw new ApiException("Problems with Server Database", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        double total = acountService.getAmountTotal(idUser, connection);
        if(total == -1L){
            throw new ApiException("Problems with Server Database", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        ConnectionFactory.closeConnection(connection);
        return total;
    }

    public Map<String, Double> getCostsByCategory(Long idUser,int year, int month) {
        Map<String, Double> costs;;
        Connection connection;
        try {
            connection = ConnectionFactory.getConection();
        } catch (SQLException e) {
            throw new ApiException("Problems with Server Database", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        costs = categoryService.getCostsByCategory(idUser, connection, year,  month);
        ConnectionFactory.closeConnection(connection);
        return costs;
    }

    public Map<String, Double> getCostsByAccount(Long idUser, int year, int month) {
        Map<String, Double> costs;;
        Connection connection;
        try {
            connection = ConnectionFactory.getConection();
        } catch (SQLException e) {
            throw new ApiException("Problems with Server Database", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        costs = acountService.getCostsByAccount(idUser, connection, year, month);
        ConnectionFactory.closeConnection(connection);
        return costs;

    }
}
