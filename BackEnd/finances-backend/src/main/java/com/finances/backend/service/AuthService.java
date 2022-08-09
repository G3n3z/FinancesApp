package com.finances.backend.service;

import com.finances.backend.data.ModelManager;
import com.finances.backend.data.entity.User;
import com.finances.backend.payload.UserDto;
import com.finances.backend.payload.request.LoginRequest;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    ModelManager modelManager;

    public AuthService(ModelManager modelManager) {
        this.modelManager = modelManager;
    }

    public String loginUser(LoginRequest request){
        boolean success = modelManager.loginIsCorrect(request.getEmail(), request.getPassword());
        if (!success){
            throw new RuntimeException("Email or Password incorrect");
        }

        return "";
    }

    public User registerUser(UserDto request){

        modelManager.registerUser(request);
        return modelManager.getUserByEmail(request.getEmail());
    }

    public long getUserId(String email) {
        return modelManager.getUserByEmail(email).getId();
    }
}
