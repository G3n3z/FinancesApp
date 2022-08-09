package com.finances.backend.data.entity;

import lombok.Data;

@Data
public class Account {
    private long id;
    private String name;
    private double balance;
    private User user;
}
