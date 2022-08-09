package com.finances.backend.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GeneralResponse {

    private double amountTotal;
    private Map<String, Double> costsByCategories;
    private Map<String, Double> costsByAccount;
}
