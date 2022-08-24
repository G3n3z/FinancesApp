package com.backendfinancesjpa.controllers;

import com.backendfinancesjpa.payload.AccountDto;
import com.backendfinancesjpa.payload.EntityDto;
import com.backendfinancesjpa.service.ProxyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/entity")
public class EntityController {

    @Autowired
    ProxyService proxy;

    @PostMapping
    public ResponseEntity<EntityDto> createEntity(@RequestBody EntityDto entityDto, @RequestHeader("Authorization") String header){

        String token = header.substring(7);
        proxy.createEntity(entityDto, token);

        return new ResponseEntity<>(entityDto, HttpStatus.CREATED);
    }
}
