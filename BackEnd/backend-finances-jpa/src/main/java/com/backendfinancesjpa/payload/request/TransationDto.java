package com.backendfinancesjpa.payload.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TransationDto {

    private String name;
    private String category;
    private String account;
    private String data;
    private String entity;
    private double amount;

}
