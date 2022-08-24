package com.backendfinancesjpa.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class Encrip {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        System.out.println(encoder.encode("abc"));
    }
}
