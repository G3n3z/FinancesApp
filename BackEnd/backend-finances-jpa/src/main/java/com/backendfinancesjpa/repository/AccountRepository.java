package com.backendfinancesjpa.repository;

import com.backendfinancesjpa.data.entity.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface AccountRepository extends JpaRepository<Account,Long> {

    Optional<Account> findByName(String name);
}
