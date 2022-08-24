package com.backendfinancesjpa.security;

import com.backendfinancesjpa.data.ModelManager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class CustomUserDetails implements UserDetailsService {

    @Autowired
    ModelManager modelManager;

    public CustomUserDetails(ModelManager modelManager) {
        this.modelManager = modelManager;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        com.backendfinancesjpa.data.entity.User user = modelManager.getUserByEmail(email);
        if (user != null) {
            return new User(user.getEmail(), user.getPassword(),
                    new ArrayList<>());
        } else {
            throw new UsernameNotFoundException("User not found with email: " + email);
        }

    }
}
