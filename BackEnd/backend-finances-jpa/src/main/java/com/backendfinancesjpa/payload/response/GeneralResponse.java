package com.backendfinancesjpa.payload.response;

import com.backendfinancesjpa.data.entity.CategoryDto;
import com.backendfinancesjpa.payload.AccountDto;
import com.backendfinancesjpa.payload.EntityDto;
import com.backendfinancesjpa.payload.request.TransationDto;
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
