package com.finances.backend.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Instant;
import java.util.ArrayList;

//@WebFilter(urlPatterns = {"/client/*"})
@Component
public class AuthorizationFilter extends OncePerRequestFilter {

    @Value("${app.jwt.security.header}")
    private String header;

    @Autowired
    CustomUserDetails userDetails;

    @Autowired
    JwtTokenProvider tokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws IOException, ServletException {

        String authHeader = request.getHeader("Authorization");
        if(!request.getRequestURI().equals("/auth/login") && !request.getRequestURI().equals("/auth/register")) {

            String token = authHeader.substring(7);
            if(tokenProvider.validateToken(token)){
                String email = tokenProvider.getEmailByToken(token);
                UserDetails user = userDetails.loadUserByUsername(email);
                UsernamePasswordAuthenticationToken uPAT = new UsernamePasswordAuthenticationToken(user, null, new ArrayList<>());
                SecurityContextHolder.getContext().setAuthentication(uPAT);
                System.out.println(Instant.now());
            }
        }else{
            UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                    "asd", null, new ArrayList<>()
            );
            SecurityContextHolder.getContext().setAuthentication(authenticationToken);
        }
        chain.doFilter(request, response);
    }
}
