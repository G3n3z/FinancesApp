package com.finances.backend.service;

import com.finances.backend.data.ModelManager;
import com.finances.backend.data.entity.User;
import com.finances.backend.payload.UserDto;
import com.finances.backend.payload.request.LoginRequest;
import com.finances.backend.security.JwtTokenProvider;
import org.springframework.stereotype.Service;

@Service
public class JwtTokenService {


    JwtTokenProvider tokenProvider;
    ModelManager modelManager;

    public JwtTokenService(JwtTokenProvider tokenProvider, ModelManager modelManager) {
        this.tokenProvider = tokenProvider;
        this.modelManager = modelManager;
    }

    public String loginUser(LoginRequest request){
        boolean success = modelManager.loginIsCorrect(request.getEmail(), request.getPassword());
        if (!success){
            throw new RuntimeException("Email or Password incorrect");
        }

        return "";
    }

    public User registerUser(UserDto userDto){
        modelManager.registerUser(userDto);
        return modelManager.getUserByEmail(userDto.getEmail());
    }
}
