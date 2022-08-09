package com.finances.backend.payload.response;

import com.finances.backend.payload.request.TransationDto;

import lombok.Data;

@Data
public class TransactionResponse {
    TransationDto transation;
    String message;
}
