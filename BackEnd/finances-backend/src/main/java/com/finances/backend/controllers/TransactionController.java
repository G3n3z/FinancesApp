package com.finances.backend.controllers;

import com.finances.backend.exception.ApiException;
import com.finances.backend.payload.request.TransationDto;
import com.finances.backend.payload.response.ListTransactionResponse;
import com.finances.backend.payload.response.TransactionResponse;
import com.finances.backend.service.ProxyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/transaction")
public class TransactionController {

    @Autowired
    private ProxyService proxy;

    @PostMapping
    public ResponseEntity<TransactionResponse> createTransaction(@RequestBody TransationDto request, @RequestHeader("Authorization")String header) {
        String token = header.substring(7);
        proxy.createTransaction(request, token);
        TransactionResponse response = new TransactionResponse();
        response.setTransation(request);
        response.setMessage("Transaction register successfully");

        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<ListTransactionResponse> getTransactionPerMonth(@RequestHeader("Authorization")String header,
                                                                      @RequestParam(name = "mth", defaultValue = "0") int month,
                                                                      @RequestParam( name = "year", defaultValue = "0") int year,
                                                                          @RequestParam(name = "ord", defaultValue = "asc" ) String order,
                                                                          @RequestParam(name = "ordBy", defaultValue = "", required = false) String orderField,
                                                                          @RequestParam(name = "pageSize", defaultValue = "10") int pageSize,
                                                                          @RequestParam(name = "pageNo", defaultValue = "1") int pageNumber) {
        String token = header.substring(7);

        List<TransationDto> list = null;
        if (month < 0 || year < 2000 || month > 12 || year > Calendar.getInstance().get(Calendar.YEAR)) {
            throw new ApiException("Transaction date invalid", HttpStatus.BAD_REQUEST);
        }
        else {
            if(((!order.equals("asc")) && (!order.equals("desc"))) || pageNumber < 0 || pageSize < 1){
                throw new ApiException("Transaction parameters invalid " + "\nord should be 'asc or desc' and pageNumber "
                        + "and pageSize should be greater then 1 ", HttpStatus.BAD_REQUEST);
            }
        }
        list = proxy.getTransactionWithSortAndPagination(month, year, order,orderField, pageSize, pageNumber, token);
        ListTransactionResponse response = new ListTransactionResponse();
        if(list != null) {
            response.setTransactionResponses(list);
            response.setSize(list.size());
            response.setPagination(true);
            response.setLastPage(list.size() != pageSize);
        }

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
