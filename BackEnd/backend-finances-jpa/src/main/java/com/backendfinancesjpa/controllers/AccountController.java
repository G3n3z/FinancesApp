package com.backendfinancesjpa.controllers;


import com.backendfinancesjpa.payload.AccountDto;
import com.backendfinancesjpa.service.ProxyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/account")
public class AccountController {

    @Autowired
    ProxyService proxy;

    @PostMapping()
    public ResponseEntity<AccountDto> createAccount(@RequestBody AccountDto accountDto, @RequestHeader("Authorization") String header){
        String token = header.substring(7);
        AccountDto response = proxy.createAccount(token, accountDto);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @DeleteMapping()
    public ResponseEntity<String> deleteAccount(@RequestBody AccountDto accountDto, @RequestHeader("Authorization") String header){
        String token = header.substring(7);
        proxy.deleteAccount(token, accountDto);
        return new ResponseEntity<>("Account deleted successfully", HttpStatus.CREATED);
    }

}
