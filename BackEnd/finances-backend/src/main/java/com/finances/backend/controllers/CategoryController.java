package com.finances.backend.controllers;

import com.finances.backend.data.entity.Category;
import com.finances.backend.data.entity.CategoryDto;
import com.finances.backend.service.ProxyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/category")
public class CategoryController {

    @Autowired
    ProxyService proxy;

    @PostMapping
    public ResponseEntity<String> createCategory(@RequestBody CategoryDto request, @RequestHeader("Authorization") String header){

        String token = header.substring(7);
        proxy.createCategory(request, token);
        return new ResponseEntity<>("Caregory created sucessful", HttpStatus.CREATED);
    }
}
