package com.backendfinancesjpa.data.entity;


import lombok.*;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String name;

    public Category(String name){
        this.name = name;
    }

    @ManyToMany(mappedBy = "categories", targetEntity = User.class)
    Set<User> users = new HashSet<>();

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Category category = (Category) o;

        return getName() != null ? getName().equals(category.getName()) : category.getName() == null;
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(name);
    }
}
