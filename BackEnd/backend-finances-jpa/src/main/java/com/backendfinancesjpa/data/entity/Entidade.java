package com.backendfinancesjpa.data.entity;

import lombok.*;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Entidade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    long id;
    String name;

    @ManyToMany(mappedBy = "entidades", targetEntity = User.class)
    Set<User> users = new HashSet<>();

    public Entidade(String name) {
        this.name = name;
    }
}
