package com.backendfinancesjpa.data;

import com.backendfinancesjpa.data.conection.ConnectionFactory;
import com.backendfinancesjpa.data.entity.User;

import com.backendfinancesjpa.data.entity.*;

import com.backendfinancesjpa.exception.ApiException;
import com.backendfinancesjpa.payload.AccountDto;
import com.backendfinancesjpa.payload.EntityDto;
import com.backendfinancesjpa.payload.UserDto;
import com.backendfinancesjpa.payload.request.TransationDto;

import com.backendfinancesjpa.repository.*;
import com.backendfinancesjpa.utils.DefaultNames;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.*;
import java.text.DecimalFormat;
import java.util.*;
import java.util.Date;
import java.util.stream.Collectors;

@Service
public class ModelManager {
    private final String url = "jdbc:mysql://localhost:3306?verifyServerCertificate=false&useSSL=true";

    private static final DecimalFormat df = new DecimalFormat("0.00");
    AccountRepository accountRepository;

    CategoryRepository categoryRepository;

    UserRepository userRepository;

    EntidadeRepository entidadeRepository;

    TransactionRepository transactionRepository;

    public ModelManager(AccountRepository accountRepository, CategoryRepository categoryRepository,
                        UserRepository userRepository, EntidadeRepository entidadeRepository,
                        TransactionRepository transactionRepository) {
        this.accountRepository = accountRepository;
        this.categoryRepository = categoryRepository;
        this.userRepository = userRepository;
        this.entidadeRepository = entidadeRepository;
        this.transactionRepository = transactionRepository;
    }

    public boolean loginIsCorrect(String email, String password) {
        return true;
    }



    public boolean registerUser(UserDto userDto)  {
        User user = mapToUser(userDto);
        user.setPassword(new BCryptPasswordEncoder().encode(user.getPassword()));

        for (String namesCategory : DefaultNames.NAMES_CATEGORIES) {
            //Category c = new Category(namesCategory);
            Category c = categoryRepository.findByName(namesCategory).orElse(new Category(namesCategory));
            //c.getUsers().add(user);
            user.getCategories().add(c);
        }
        for (String namesEntity : DefaultNames.NAMES_ENTITIES) {
            Entidade e = entidadeRepository.findByName(namesEntity).orElse(new Entidade(namesEntity));
            //e.getUsers().add(user);
            user.getEntidades().add(e);
        }
        for (String nameAccount : DefaultNames.NAMES_ACCOUNTS) {
            Account a = accountRepository.findByName(nameAccount).orElse(new Account(nameAccount));
            //a.setUser(user);
            user.getAccounts().add(new Account(nameAccount));
        }
        userRepository.save(user);

        return true;
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
        User u = userRepository.findByEmail(email);
        return u;
    }

    public boolean updateAccount(double amount, String email){
        return  true;
    }




    public AccountDto registerAccount(String email, AccountDto accountDto) {
        Account a = mapToAccount(accountDto);
        User user = userRepository.findByEmail(email);
        if(user == null){
            throw new ApiException("", HttpStatus.BAD_REQUEST);
        }
        user.getAccounts().add(a);
        userRepository.save(user);
        return mapToAccountDto(a);
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


    @Transactional()
    public void createTransaction(TransationDto request, String email) {

        boolean res;
        User user = userRepository.findByEmail(email);
        if (user == null){
            throw new ApiException("Dont exists " + email + " account", HttpStatus.BAD_REQUEST);
        }
        Category category = user.getCategories().stream().filter(c -> c.getName().equals(request.getCategory())).findFirst().orElseThrow(
                () -> new ApiException("Category dont exists", HttpStatus.BAD_REQUEST));

        Entidade entidade = user.getEntidades().stream().filter(e -> e.getName().equals(request.getEntity())).findFirst().orElseThrow(
                () -> new ApiException("Entity dont exists", HttpStatus.BAD_REQUEST));
        Account account = user.getAccounts().stream().filter(a -> a.getName().equals(request.getAccount())).findFirst().orElseThrow(
                () -> new ApiException("Account dont exists", HttpStatus.BAD_REQUEST));

        account.setBalance(account.getBalance() + request.getAmount());
        Transaction transaction = new Transaction();
        transaction.setAccount(account); transaction.setCategory(category); transaction.setUser(user); transaction.setEntidade(entidade);
        transaction.setAmount(request.getAmount()); transaction.setName(request.getName()); transaction.setDate(stringToDate(request.getData()));
        transaction.setUser(user);
        transactionRepository.save(transaction);
        accountRepository.save(account);
        //throw new ApiException("Dont exists " + request.getCategory() + " in " + email + " account", HttpStatus.BAD_REQUEST);
    }

    private Date stringToDate(String data) {
       String [] dataSplited = data.split("-");
       if(dataSplited.length != 3){
           return new Date();
       }
       int year, month, day;
       try{
           year = Integer.parseInt(dataSplited[0]);
           month = Integer.parseInt(dataSplited[1]);
           day = Integer.parseInt(dataSplited[2]);
       }catch (NumberFormatException e){
           return new Date();
       }
       return new Date(year-1900, month-1, day);
    }


    public List<TransationDto> getAllTransaction(Long id) {

        return null;
    }

    public void createCategory(CategoryDto request, Long idUser) {
        User user = userRepository.findById(idUser).orElseThrow(() -> new ApiException("User not found", HttpStatus.BAD_REQUEST));

        Category category =  mapToCategory(request);
        if(category != null){
            user.getCategories().add(category);
        }
        userRepository.save(user);
    }

    private Category mapToCategory(CategoryDto request) {
        if(request != null){
            Category c =  new Category();
            c.setName(request.getName());
            return c;
        }
        return null;
    }

    public List<TransationDto> getTransactionWithSortAndPagination(int month, int year, String order,String orderField, int pageSize, int pageNumber, Long idUser) {
        //User user = userRepository.findById(idUser).get();
        Sort sort = order.equalsIgnoreCase("asc") ? Sort.by(new Sort.Order(Sort.Direction.ASC,orderField), new Sort.Order(Sort.Direction.ASC,"id"))
                : Sort.by(new Sort.Order(Sort.Direction.DESC,orderField), new Sort.Order(Sort.Direction.DESC,"id"));
        Pageable pageable = PageRequest.of(pageNumber,pageSize, sort);
        return transactionRepository.findAllByUser_IdAndDateIsAfter(idUser,new Date(year-1990, month,1) , pageable).stream().map(this::mapToTransactioDto).collect(Collectors.toList());

    }

    private TransationDto mapToTransactioDto(Transaction transaction) {
        if(transaction == null){
            return null;
        }
        return new TransationDto(transaction.getName(),transaction.getCategory().getName(),transaction.getAccount().getName(),
                transaction.getDate().toString(),transaction.getEntidade().getName() ,transaction.getAmount() );
    }

    public double getAmountTotal(Long idUser) {

        return 0;
    }

    public Map<String, Double> getCostsByCategory(Long idUser,int year, int month) {
        Map<String, Double>  costsByCategory = new HashMap<>();
        List<Transaction> transactions = transactionRepository.findAllByUser_IdAndDateIsAfterAndAmountIsLessThan(idUser, new Date(year-1900, month, 1), 0.0);
        List<String> categoryNames = transactions.stream().map(t -> t.getCategory().getName()).distinct().toList();
        categoryNames.forEach(category -> {
            double s = transactions.stream().filter(t -> t.getCategory().getName().equals(category)).map(Transaction::getAmount).reduce(0.0, Double::sum);
            costsByCategory.put(category, s);
        });

        return costsByCategory;
    }

    public Map<String, Double> getCostsByAccount(Long idUser, int year, int month) {
        List<Transaction> transactions = transactionRepository.findAllByUser_IdAndDateIsAfterAndAmountIsLessThan(idUser, new Date(year-1900, month, 1), 0.0);
        Map<String, Double> costs = new HashMap<>();
        List<String> accounts = transactions.stream().map(t -> t.getAccount().getName()).distinct().toList();
        accounts.forEach( (a) ->{
            double s = transactions.stream().filter(t -> t.getAccount().getName().equals(a)).map(Transaction::getAmount).reduce(0.0, Double::sum);
            costs.put(a, s);
        });
        return costs;

    }

    public List<AccountDto> getAccounts(Long idUser) {

        return userRepository.findById(idUser).get().getAccounts().stream().map(this::mapToAccountDto).map(t -> {
            t.setBalance(Math.floor(t.getBalance()));
            return t;
        }).toList();
    }

    private AccountDto mapToAccountDto(Account account) {
        return new AccountDto(account.getName(), account.getBalance());
    }

    public List<CategoryDto> getCategories(Long idUser) {
        User user = userRepository.findById(idUser).orElseThrow(() -> new ApiException("Dont exists this user " , HttpStatus.BAD_REQUEST));
        return user.getCategories().stream().map(this::mapToCategoryDto).collect(Collectors.toList());
    }

    private CategoryDto mapToCategoryDto(Category category){
        return new CategoryDto(category.getName());
    }

    public List<EntityDto> getEntities(Long idUser) {
        User user = userRepository.findById(idUser).orElseThrow(() -> new ApiException("Dont exists this user " , HttpStatus.BAD_REQUEST));
        return user.getEntidades().stream().map(this::mapToEntityDto).collect(Collectors.toList());
    }

    public EntityDto mapToEntityDto(Entidade entidade){
        return new EntityDto(entidade.getName());
    }

    public void createEntity(EntityDto entityDto, Long idUser) {
        User user = userRepository.findById(idUser).orElseThrow(() -> new ApiException("Dont exists this user " , HttpStatus.BAD_REQUEST));
        Entidade entidade = mapToEntity(entityDto);

        user.getEntidades().add(entidade);
        userRepository.save(user);
    }

    private Entidade mapToEntity(EntityDto entityDto) {
        Entidade entidade = new Entidade();
        entidade.setName(entityDto.getName());
        return entidade;
    }

    public boolean existsUserByEmail(String email) {
        return userRepository.existsUserByEmail(email);
    }

    public void changePassword(String email, String password) {
        User user = userRepository.findByEmail(email);
        user.setPassword(new BCryptPasswordEncoder().encode(password));
        userRepository.save(user);
    }

    public void deleteAccount(AccountDto accountDto, Long idUser) {
       Account account =  mapToAccount(accountDto);
       User user = userRepository.findById(idUser).orElseThrow(() -> new ApiException("Dont exists this user " , HttpStatus.BAD_REQUEST));
       user.getAccounts().removeIf(a -> a.getName().equals( accountDto.getName()));
       userRepository.save(user);
    }
}
