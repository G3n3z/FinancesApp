package com.finances.backend.controllers;

import com.finances.backend.data.entity.User;
import com.finances.backend.payload.AuthResponseDto;
import com.finances.backend.payload.UserDto;
import com.finances.backend.payload.request.LoginRequest;

import com.finances.backend.security.CustomUserDetails;
import com.finances.backend.security.JwtTokenProvider;
import com.finances.backend.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

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
//        response.setToken(jwtTokenService.loginUser(request));
//        UsernamePasswordAuthenticationToken uPAT = new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword(), null);
//        SecurityContextHolder.getContext().setAuthentication(uPAT);
//        String token = tokenProvider.generateJwtToken(request);

        Authentication authentication =  authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail()
                ,request.getPassword()));
//        final UserDetails userDetail = userDetails
//                .loadUserByUsername(request.getEmail());


        //Long id = tokenProvider.getIdByToken(header.substring(6));
        SecurityContextHolder.getContext().setAuthentication(authentication);

        long id = authService.getUserId(request.getEmail());
        String token = tokenProvider.generateJwtToken(request, id);
        response.setToken(token);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponseDto> register(@RequestBody UserDto request){

        User user = authService.registerUser(request);

        Authentication authentication =  authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail()
                ,request.getPassword()));
//        final UserDetails userDetail = userDetails
//                .loadUserByUsername(request.getEmail());


        //Do Login to response JwtToken
        LoginRequest login = new LoginRequest();
        login.setEmail(request.getEmail()); login.setPassword(request.getPassword());
        String token = tokenProvider.generateJwtToken(login, user.getId());

        //Create Response with token
        AuthResponseDto response = new AuthResponseDto();
        response.setToken(token);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/login")
    public ResponseEntity<String> getLogin(){
        return new ResponseEntity<>("Oki", HttpStatus.OK);
    }



}
