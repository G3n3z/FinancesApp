package com.finances.backend.service;

import com.finances.backend.data.ModelManager;
import com.finances.backend.data.entity.CategoryDto;
import com.finances.backend.payload.AccountDto;
import com.finances.backend.payload.request.TransationDto;
import com.finances.backend.payload.response.GeneralResponse;
import com.finances.backend.security.JwtTokenProvider;
import org.springframework.stereotype.Service;

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
        return model.getTransactionWithSortAndPagination(month,year, order,orderField, pageSize, pageNumber, idUser);
    }

    public GeneralResponse getClienteGeneral(String token, int year, int month) {
        Long idUser = tokenProvider.getIdByToken(token);
        GeneralResponse response = new GeneralResponse();
        response.setAmountTotal(model.getAmountTotal(idUser));
        response.setCostsByCategories(model.getCostsByCategory(idUser, year, month));
        response.setCostsByAccount(model.getCostsByAccount(idUser, year, month));
        return response;
    }

    public AccountDto getClientBalance(String token) {
        Long idUser = tokenProvider.getIdByToken(token);
        double total = model.getAmountTotal(idUser);
        return new AccountDto("total",total);
    }
}
