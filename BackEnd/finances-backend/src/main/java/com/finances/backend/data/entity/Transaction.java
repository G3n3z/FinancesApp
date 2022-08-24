package com.finances.backend.data.entity;

import com.finances.backend.data.entity.Account;
import com.finances.backend.data.entity.Category;
import com.finances.backend.data.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Transaction {

    long id;
    private String name;
    double amount;
    Date date;
    Account account;
    User user;
    Category category;
    Entity entity;

}
