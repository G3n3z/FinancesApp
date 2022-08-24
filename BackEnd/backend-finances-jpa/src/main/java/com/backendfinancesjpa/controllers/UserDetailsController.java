package com.backendfinancesjpa.controllers;


import com.backendfinancesjpa.payload.response.GeneralResponse;
import com.backendfinancesjpa.service.ProxyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.LocalDate;
import java.time.temporal.TemporalField;

@RestController
@RequestMapping("/client")
public class UserDetailsController {

    @Autowired
    ProxyService proxy;

//    @GetMapping()
//    public ResponseEntity<AccountDto> getClientBalance(
//    @RequestHeader("Authorization") String header){
//        String token = header.substring(7);
//        AccountDto accountDto = proxy.getClientBalance(token);
//
//        return new ResponseEntity<>(accountDto, HttpStatus.OK);
//    }

    @GetMapping()
    public ResponseEntity<String> getClientBalances(){
        System.out.println(Instant.now());
        return new ResponseEntity<>("1000", HttpStatus.OK);
    }

    @PutMapping("/account")
    public ResponseEntity<String> updateAccount(@RequestBody String amount, @RequestHeader("Authorization") String header){
        Double x = Double.parseDouble(amount);
        if(proxy.updateAccount(x)){
            return new ResponseEntity<>("Okey", HttpStatus.OK);
        }
        else{
            return new ResponseEntity<>("Falhou", HttpStatus.BAD_REQUEST);
        }

    }
    @GetMapping("/general")
    public ResponseEntity<GeneralResponse> getClientGeneral(@RequestParam(name = "mth", defaultValue = "0", required = false) int month,
                                                            @RequestParam( name = "year", defaultValue = "0", required = false) int year,
                                                            @RequestHeader("Authorization") String header){

        String token = header.substring(7);
        if(month < 0 || year < 2000 ){
            LocalDate currentdate = LocalDate.now();
            month = currentdate.getMonth().getValue();
            year = currentdate.getYear();
        }
        GeneralResponse response = proxy.getClienteGeneral(token, year, month);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
