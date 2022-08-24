package com.finances.backend.payload.response;

import com.finances.backend.data.entity.CategoryDto;
import com.finances.backend.data.entity.Entity;
import com.finances.backend.data.entity.Transaction;
import com.finances.backend.payload.AccountDto;
import com.finances.backend.payload.EntityDto;
import com.finances.backend.payload.request.TransationDto;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GeneralResponse {

    private double amountTotal;
    private Map<String, Double> costsByCategories;
    private Map<String, Double> costsByAccount;
    private List<AccountDto> accounts;
    private List<TransationDto> transactions;
    private List<CategoryDto> categories;
    private List<EntityDto> entities;
}
