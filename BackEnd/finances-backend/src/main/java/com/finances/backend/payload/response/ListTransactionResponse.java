package com.finances.backend.payload.response;

import com.finances.backend.payload.AccountDto;
import com.finances.backend.payload.request.TransationDto;
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
