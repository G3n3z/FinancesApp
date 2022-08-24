package com.backendfinancesjpa.service;

import com.backendfinancesjpa.data.ModelManager;
import com.backendfinancesjpa.data.entity.CategoryDto;
import com.backendfinancesjpa.payload.AccountDto;
import com.backendfinancesjpa.payload.EntityDto;
import com.backendfinancesjpa.payload.request.TransationDto;
import com.backendfinancesjpa.payload.response.GeneralResponse;
import com.backendfinancesjpa.security.JwtTokenProvider;

import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
public class ProxyService {

    ModelManager model;
    JwtTokenProvider tokenProvider;

    public ProxyService(ModelManager model, JwtTokenProvider tokenProvider) {
        this.model = model;
        this.tokenProvider = tokenProvider;
    }

    public boolean updateAccount(double amount){
        return model.updateAccount(amount, "asd");
    }

    public AccountDto createAccount(String token, AccountDto accountDto){
        String email = tokenProvider.getEmailByToken(token);
        return model.registerAccount(email, accountDto);
    }

    public void createTransaction(TransationDto request, String token) {
        String email = tokenProvider.getEmailByToken(token);
        model.createTransaction(request, email);

    }



    public List<TransationDto> getAllTransaction(String token) {
        Long id = tokenProvider.getIdByToken(token);
        return model.getAllTransaction(id);
    }

    public void createCategory(CategoryDto request, String token) {
        Long idUser = tokenProvider.getIdByToken(token);
        model.createCategory(request, idUser);
    }

    public List<TransationDto> getTransactionWithSortAndPagination(int month, int year, String order,String orderField, int pageSize, int pageNumber, String token) {
        Long idUser = tokenProvider.getIdByToken(token);
        model.getTransactionWithSortAndPagination(month,year, order,orderField, pageSize, pageNumber, idUser);
        return null;
    }

    public GeneralResponse getClienteGeneral(String token, int year, int month) {
        Long idUser = tokenProvider.getIdByToken(token);
        Calendar calendar = Calendar.getInstance();
        GeneralResponse response = new GeneralResponse();
        response.setAmountTotal(model.getAmountTotal(idUser));
        response.setCostsByCategories(model.getCostsByCategory(idUser, year, month));
        response.setCostsByAccount(model.getCostsByAccount(idUser, year, month));
        response.setAccounts(model.getAccounts(idUser));
        response.setCategories(model.getCategories(idUser));
        response.setEntities(model.getEntities(idUser));
        response.setTransactions(model.getTransactionWithSortAndPagination(month, year, "desc", "date", 30, 0 , idUser));
        return response;
    }

    public AccountDto getClientBalance(String token) {
        Long idUser = tokenProvider.getIdByToken(token);
        double total = model.getAmountTotal(idUser);
        return new AccountDto("total",total);
    }

    public List<AccountDto> getAccounts(String token) {
        Long idUser = tokenProvider.getIdByToken(token);
        return model.getAccounts(idUser);
    }

    public void createEntity(EntityDto entityDto, String token) {
        Long idUser = tokenProvider.getIdByToken(token);
        model.createEntity(entityDto, idUser);
    }

    public void deleteAccount(String token, AccountDto accountDto) {
        Long idUser = tokenProvider.getIdByToken(token);
        model.deleteAccount(accountDto, idUser);
    }
}
