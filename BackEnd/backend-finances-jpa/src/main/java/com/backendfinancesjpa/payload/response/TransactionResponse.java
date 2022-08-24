package com.backendfinancesjpa.payload.response;

import com.backendfinancesjpa.payload.request.TransationDto;


import lombok.Data;

@Data
public class TransactionResponse {
    TransationDto transation;
    String message;
}
