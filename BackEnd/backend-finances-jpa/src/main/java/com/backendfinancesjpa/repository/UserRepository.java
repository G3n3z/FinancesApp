package com.backendfinancesjpa.repository;

import com.backendfinancesjpa.data.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


public interface UserRepository extends JpaRepository<User, Long> {

    User findByEmail(String email);

    boolean existsUserByEmail(String email);

}
