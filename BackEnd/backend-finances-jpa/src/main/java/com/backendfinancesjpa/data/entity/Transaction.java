package com.backendfinancesjpa.data.entity;

import lombok.*;

import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    long id;
    private String name;
    double amount;
    Date date;

    @OneToOne
    private Account account;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToOne
    private Category category;

    @OneToOne
    private Entidade entidade;

}
