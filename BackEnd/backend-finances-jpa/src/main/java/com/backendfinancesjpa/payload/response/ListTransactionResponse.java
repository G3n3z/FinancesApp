package com.backendfinancesjpa.payload.response;

import com.backendfinancesjpa.payload.AccountDto;
import com.backendfinancesjpa.payload.request.TransationDto;

import lombok.Data;

import java.util.List;

@Data
public class ListTransactionResponse {

    List<AccountDto> accounts;
    List<TransationDto> transactionResponses;
    int size;
    boolean isPagination;
    boolean lastPage;
}
