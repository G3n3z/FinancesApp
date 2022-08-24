package com.backendfinancesjpa.controllers;


import com.backendfinancesjpa.data.entity.User;
import com.backendfinancesjpa.exception.ApiException;
import com.backendfinancesjpa.payload.AuthResponseDto;
import com.backendfinancesjpa.payload.UserDto;
import com.backendfinancesjpa.payload.request.LoginRequest;
import com.backendfinancesjpa.security.CustomUserDetails;
import com.backendfinancesjpa.security.JwtTokenProvider;
import com.backendfinancesjpa.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    AuthService authService;

    @Autowired
    JwtTokenProvider tokenProvider;

    @Autowired
    CustomUserDetails userDetails;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDto> login(@RequestBody LoginRequest request, @RequestHeader("Authorization") String header){

        AuthResponseDto response = new AuthResponseDto();

        Authentication authentication =  authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail()
                ,request.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

        long id = authService.getUserId(request.getEmail());
        String token = tokenProvider.generateJwtToken(request.getEmail(), id);
        response.setToken(token);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponseDto> register(@RequestBody UserDto request){

        //Regex to validate emails
        String regex = "^(.+)@(.+)$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(request.getEmail());
        //If email dont match with regex, throw ApiException
        if(!matcher.matches()){
            throw new ApiException("Email invalid", HttpStatus.BAD_REQUEST);
        }

        //Register user to DataBase
        User user = authService.registerUser(request);

        //Generate  JwtToken
        String token = tokenProvider.generateJwtToken(request.getEmail(), user.getId());

        //Create Response with token
        AuthResponseDto response = new AuthResponseDto();
        response.setToken(token);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }


    @PostMapping("/login/changePassword")
    public ResponseEntity<AuthResponseDto> changePassword(@RequestBody LoginRequest request, @RequestHeader("Authorization") String header){

        authService.changePassword(request.getEmail(), request.getPassword());

        AuthResponseDto response = new AuthResponseDto();

        Authentication authentication =  authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail()
                ,request.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

        long id = authService.getUserId(request.getEmail());
        String token = tokenProvider.generateJwtToken(request.getEmail(), id);
        response.setToken(token);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
