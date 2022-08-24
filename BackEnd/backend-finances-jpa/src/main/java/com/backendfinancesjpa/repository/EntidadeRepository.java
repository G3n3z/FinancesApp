package com.backendfinancesjpa.repository;

import com.backendfinancesjpa.data.entity.Entidade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


public interface EntidadeRepository extends JpaRepository<Entidade, Long> {

    Optional<Entidade> findByName(String name);

}
