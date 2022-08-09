package com.finances.backend.payload.request;

import lombok.Data;

@Data
public class RegisterRequest {

    private String name;
    private String email;
    private String password;
    private String nationality;
    private int age;

}
