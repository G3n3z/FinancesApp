package com.backendfinancesjpa.repository;

import com.backendfinancesjpa.data.entity.Transaction;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;


public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findAllByUser_IdAndDateIsAfter(long userId, Date date, Pageable pageable);

    List<Transaction> findAllByUser_IdAndDateIsAfterAndAmountIsLessThan(long accountId, Date date, Double amount);



}
