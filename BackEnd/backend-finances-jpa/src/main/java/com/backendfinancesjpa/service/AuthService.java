package com.backendfinancesjpa.service;

import com.backendfinancesjpa.data.ModelManager;
import com.backendfinancesjpa.data.entity.User;
import com.backendfinancesjpa.exception.ApiException;
import com.backendfinancesjpa.payload.UserDto;
import com.backendfinancesjpa.payload.request.LoginRequest;

import org.springframework.http.HttpStatus;
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
        if(modelManager.existsUserByEmail(request.getEmail())){
            throw new ApiException("Email registered to a User", HttpStatus.BAD_REQUEST);
        }
        modelManager.registerUser(request);
        return modelManager.getUserByEmail(request.getEmail());
    }

    public long getUserId(String email) {
        return modelManager.getUserByEmail(email).getId();
    }

    public void changePassword(String email, String password) {
        modelManager.changePassword( email,  password);
    }
}
